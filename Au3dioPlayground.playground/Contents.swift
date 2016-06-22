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
import AccessOperator

struct AccessComponent<T : ComponentType>: AccessOperator {
    typealias Target = ComponentDictionaryType
    typealias Argument = T
    typealias Result = T

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {

    }
}
struct AccessIndex: AccessOperator {
    typealias Target = ListComponentType
    typealias Argument = Int
    typealias Result = CompositionType

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result: Result? = target?.children[argument]
        withAccess(result: &result)
        if let result: Result = result {
            target?.children[argument] = result
        } else {
            target?.children.removeAtIndex(argument)
        }
    }
}
struct AccessKey: AccessOperator {
    typealias Target = ComponentDictionaryType
    typealias Argument = String
    typealias Result = ComponentType

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result = target?.components[argument]
        withAccess(result: &result)
        if let result = result {
            target?.components[argument] = result
        } else {
            target?.components.removeValueForKey(argument)
        }
    }
}

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


let environmentStream = au3dio.rootCompositionStream.map { (root) -> GameInteractor.Environment? in
    guard let level = root.findComponent(ScenarioListPlugin.Component.self)?[0]?.findComponent(LevelListPlugin.Component.self)?[0]
        else { return nil }
    return try! au3dio.findPlugin(GameInteractor.self)?.environment(level)
}

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
