
import SwiftyJSON


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

        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            greeting = rawData.string ?? ""
        }

        public func export(mode: PersistenceMode) -> JSON {
            return JSON(greeting)
        }
    }
}
