//: Playground - noun: a place where people can play

/*: TODO
- Add configuration options for `Au3dioModule`: Dictionary<PersistenceMode, String/NSURL>
- Implement `Au3dioDataManager`
- Implement hook for every implementation of Composition: (String) -> Component.Type
*/

import Foundation

final class ScenarioNamePlugin: Au3dioModulePart {
    var module: Au3dioModule
    init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["name"] = ScenarioNameComponent.self
    }
}
struct ScenarioNameComponent: ComponentType {
    var name: String

    init(composition: CompositionType, rawData: JSON) {
        name = rawData.string ?? ""
    }

    func export() -> JSON {
        return JSON(name)
    }
}

final class GreetingPlugin: Au3dioModulePart {
    var module: Au3dioModule
    init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["greeting"] = Component.self
    }

    struct Component: ComponentType {
        var greeting: String

        init(composition: CompositionType, rawData: JSON) {
            greeting = rawData.string ?? ""
        }

        func export() -> JSON {
            return JSON(greeting)
        }
    }
}
let paths: [PersistenceMode: String] = [
    PersistenceMode.Readonly: "Readonly",
    .Descriptive: "Descriptive",
    .SemiPersistent: "Semi",
    .FullyPersistent: "Fully"
    ].mapDict { ($0.0, NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent($0.1)) }
let config = Au3dioConfiguration(persistenceModePaths: paths)
let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
    GameDataInteractor.self,
    ScenarioNamePlugin.self,
    GreetingPlugin.self
)

do {
    let rootId = IdPath(id: "Au3dioData")
    let root = try au3dio.dataManager.fetchIdPath(rootId, mode: .Readonly)
    root.components

    let testId = IdPath(idPath: rootId, suffix: "ScenarioList")
} catch {
    print("failed \(error)")
}
