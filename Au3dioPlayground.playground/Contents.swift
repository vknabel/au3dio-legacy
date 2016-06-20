//: Playground - noun: a place where people can play

/*: TODO
- Add configuration options for `Au3dioModule`: Dictionary<PersistenceMode, String/NSURL>
- Implement `DataManager`
- Implement hook for every implementation of Composition: (String) -> Component.Type
*/
import Foundation
import Au3dio
import SwiftyJSON
import ConclurerLog
import XCPlayground
import RxSwift

extension Int {
    var seconds: Int {
        return self
    }
    var minutes: Int {
        return self * 60
    }
}

let levelTicks = 1.minutes

let bag = DisposeBag()

NSURL(string: "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/")
let paths: [PersistenceMode: String] = [
    PersistenceMode.Readonly: "Readonly",
    .Descriptive: "Descriptive",
    .SemiPersistent: "Semi",
    .FullyPersistent: "Fully"
    ].mapDict { ($0.0, "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/\($0.1)") }

let config = Configuration(persistenceModePaths: paths)
let au3dio = Au3dioModule(configuration: config, debug: false)


let levelStream = au3dio.rootCompositionStream.map { (root) -> CompositionType? in
    let scenarios = root.findComponent(ScenarioListPlugin.Component.self)
    let firstScenario = scenarios?.children.first
    let levels = firstScenario?.findComponent(LevelListPlugin.Component.self)
    let firstLevel = levels?.children.first
    return firstLevel
}

let environmentStream = levelStream.map({ (level: CompositionType?) -> GameInteractor.Environment? in
    guard let level = level else { return nil }
    return try! au3dio.findPlugin(GameInteractor.self)?.environment(level)
})

let nonOptionalStream = environmentStream.flatMap { (optEnv) -> Observable<GameInteractor.Environment> in
    if let env = optEnv {
        return Observable.of(env)
    } else {
        return Observable.empty()
    }
}

nonOptionalStream.subscribeNext({ (environment: GameInteractor.Environment) -> Void in
    Log.print("Game Environment created", type: .Step)
}).addDisposableTo(bag)

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
