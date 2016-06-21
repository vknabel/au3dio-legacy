
import SwiftyJSON
import ConclurerLog

public final class ScenarioListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["scenarios"] = Component.self
    }

    public func addAliases(aliases: [String]) {
        aliases.forEach {
            module.componentMap.componentTypes[$0] = Component.self
        }
    }

    public struct Component: ComponentType, ListComponentType, DefaultDescendant {
        public private(set) var idPath: IdPath
        public var readModesExternal: [PersistenceMode: Bool] = [:]
        public var children: [CompositionType] = []

        public init(composition: CompositionType, idPath: IdPath) {
            self.idPath = idPath
        }
    }
}
