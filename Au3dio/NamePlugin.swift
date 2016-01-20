
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
            switch rawData.type {
            case .String:
                name = rawData.stringValue
            case .Null:
                break
            default:
                throw Au3dioDataManager.FetchError.InvalidFormat(__FILE__, __LINE__, rawData)
            }
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