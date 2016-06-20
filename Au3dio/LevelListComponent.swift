
import SwiftyJSON
import ConclurerLog

public final class LevelListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["levels"] = Component.self
    }

    public func addAliases(aliases: [String]) {
        aliases.forEach {
            module.componentMap.componentTypes[$0] = Component.self
        }
    }

    public struct Component: ComponentType, ListComponentType {
        public private(set) var idPath: IdPath
        public var readModesExternal: [PersistenceMode: Bool] = [:]
        public var children: [CompositionType] = []

        public init(composition: CompositionType, key: String) {
            idPath = IdPath(idPath: composition.idPath, suffix: key)
        }
    }
}
