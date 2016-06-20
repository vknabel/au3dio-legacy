
import SwiftyJSON
import ConclurerLog

public final class SearchPlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["search"] = Component.self
    }

    public struct Component: ComponentType {
        // TODO: Implement

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return nil
        }
    }
}
