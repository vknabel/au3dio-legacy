//: Playground - noun: a place where people can play

/*: TODO
- Add configuration options for `Au3dioModule`: Dictionary<PersistenceMode, String/NSURL>
- Implement `DataManager`
- Implement hook for every implementation of Composition: (String) -> Component.Type
*/
import Foundation

/*
public final class GreetingPlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["greeting"] = Component.self
    }

    public struct Component: ComponentType {
        public var greeting: String = ""

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode) throws {
            greeting = rawData.string ?? ""
        }

        public func export() -> JSON {
            return JSON(greeting)
        }
    }
}
public final class NamePlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["name"] = NameComponent.self
    }

    public struct NameComponent: ComponentType {
        public var name: String = ""

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode) throws {
            guard rawData.type == .String else { throw DataManager.FetchError.InvalidFormat }
            name = rawData.string ?? ""
        }

        public func export(mode: PersistenceMode) -> JSONType {
            switch mode {
            case .Readonly, .SemiPersistent:
                return JSON(NSNull())
            case .Descriptive, .FullyPersistent:
                return JSON(name)
            }
        }
    }
}

public protocol ScenarioListComponentType {
    var scenarios: [CompositionType] { get }
}
public final class ScenarioListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["scenarios"] = Component.self
    }

    public struct Component: ComponentType, ScenarioListComponentType {
        private var idPath: IdPath
        private var readModes: [PersistenceMode] = []
        public private(set) var scenarios: [CompositionType] = []

        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode) throws {
            assertEqual(rawData.type, .Array)

            defer { readModes.append(mode) }
            for (_, v) in rawData {
                assertEqual(rawData.type, .Dictionary)
                var scenario = ScenarioComposition(idPath: idPath)
                try scenario.readComponents(v, map: map, mode: mode)
                scenarios.append(scenario)
            }
        }
        public init(composition: CompositionType, key: String) {
            idPath = composition.idPath
        }
        public func export(mode: PersistenceMode) -> JSONType {
            return JSONType(scenarios.map { $0.export(mode) })
        }
    }

    public struct ExternalComponent: ComponentType, ExtendedModePersistable {
    var idPath: IdPath
    private var _list: [String] = []

    public init(composition: CompositionType, key: String) {
    idPath = IdPath(idPath: composition.idPath, suffix: key)
    }
    mutating public func readData(rawData: JSONType, mode: PersistenceMode) {
    assertEqual(rawData.type, .String)
    }
    public func save(ensureCached: (IdPath, Int) -> Void) throws { }
    public func export() -> JSONType {
    return JSONType(NSNull())
    }
    }
}

let paths: [PersistenceMode: String] = [
    PersistenceMode.Readonly: "Readonly",
    .Descriptive: "Descriptive",
    .SemiPersistent: "Semi",
    .FullyPersistent: "Fully"
    ].mapDict { ($0.0, NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent($0.1)) }
let config = Configuration(persistenceModePaths: paths)
let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
    GameDataInteractor.self,
    NamePlugin.self,
    GreetingPlugin.self,
    ScenarioListPlugin.self
)

do {
    let rootId = IdPath(id: "Au3dioData")
    let root = try au3dio.dataManager.fetchIdPath(rootId, mode: .Readonly)
    root.components

    let testId = IdPath(idPath: rootId, suffix: "ScenarioList")
} catch {
    print("failed \(error)")
}
*/
