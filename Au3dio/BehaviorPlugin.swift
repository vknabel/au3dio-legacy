
import SwiftyJSON
import ConclurerLog

public final class BehaviorPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["behavior"] = Component.self
    }

    public struct Component: ComponentType {
        public private(set) var idPath: IdPath
        private var composition: InlineComposition
        public var components: [String: ComponentType] {
            get {
                return composition.components
            }
            set {
                composition.components = newValue
            }
        }

        public init(composition: CompositionType, key: String) {
            idPath = IdPath(idPath: composition.idPath, suffix: key)
            self.composition = InlineComposition(idPath: idPath)
        }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            try self.composition.readData(rawData, map: map, mode: mode, module: module)
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return self.composition.export(mode)
        }
    }
}
