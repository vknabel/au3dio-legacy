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
let tick = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish().replay(1).refCount()
tick.take(Int(levelTicks))
    .subscribeNext({ i in
        print(levelTicks - i)
    }).addDisposableTo(bag)

NSURL(string: "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/")
let paths: [PersistenceMode: String] = [
    PersistenceMode.Readonly: "Readonly",
    .Descriptive: "Descriptive",
    .SemiPersistent: "Semi",
    .FullyPersistent: "Fully"
    ].mapDict { ($0.0, "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/\($0.1)") }

let config = Configuration(persistenceModePaths: paths)
let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
    GameDataInteractor.self,
    NamePlugin.self,
    GreetingPlugin.self,
    CompositionListPlugin.self,
    SoundNodePlugin.self,
    PositionPlugin.self
)
au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

au3dio.rootCompositionStream.subscribeNext({ comp in
    print(comp)
    }).addDisposableTo(au3dio.disposeBag)

let root = try! au3dio.dataManager.reloadRootComposition()
print("ROOT", root)

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
