
import SwiftyJSON
import ConclurerLog


/// ATTENTION: This plugin is debug-only
public final class GreetingPlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["greeting"] = Component.self
    }

    public struct Component: ComponentType {
        public var greeting: String = ""

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            switch rawData.type {
            case .String:
                greeting = rawData.stringValue
            case .Null:
                break
            default:
                throw DataManager.FetchError.InvalidFormat(rawData, Log())
            }
        }

        public func export(mode: PersistenceMode) -> JSON? {
            switch mode {
            case .Readonly, .SemiPersistent:
                return nil
            case .Descriptive, .FullyPersistent:
                return RawDataType(greeting)
            }
        }
    }
}
