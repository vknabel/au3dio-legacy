
import SwiftyJSON
import ConclurerLog

public final class NamePlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["name"] = Component.self
    }

    public struct Component: ComponentType, EmptyDescendant {
        public var name: String = ""
        public let idPath: IdPath

        public init(composition: CompositionType, idPath: IdPath) {
            self.idPath = idPath
        }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            switch rawData.type {
            case .String:
                name = rawData.stringValue
            case .Null:
                break
            default:
                throw FetchError.InvalidFormat(rawData, Log())
            }
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            switch mode {
            case .Readonly, .SemiPersistent:
                return nil
            case .Descriptive, .FullyPersistent:
                return JSON(name)
            }
        }
    }
}
