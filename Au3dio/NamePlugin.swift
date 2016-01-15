
import SwiftyJSON

public final class NamePlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["name"] = Component.self
    }

    public struct Component: ComponentType {
        public var name: String = ""

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            guard rawData.type == .String else {
                throw Au3dioDataManager.FetchError.InvalidFormat(__FILE__, __LINE__, rawData)
            }
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
