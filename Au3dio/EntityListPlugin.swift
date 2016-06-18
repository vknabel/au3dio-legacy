
import SwiftyJSON
import ConclurerLog

public final class EntityListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["entities"] = Component.self
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
