
import SwiftyJSON

public protocol ScenarioListComponentType {
    var scenarios: [CompositionType] { get }
}
public final class ScenarioListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["scenarios"] = Component.self
    }

    public struct Component: ComponentType, ScenarioListComponentType {
        private var idPath: IdPath
        private var readModesExternal: [PersistenceMode: Bool] = [:] /// wether a specific mode is external or internal
        public var scenarios: [CompositionType] = []

        public init(composition: CompositionType, key: String) {
            idPath = IdPath(idPath: composition.idPath, suffix: key)
        }
        public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            assertOneOf(rawData.type, [.Bool, .Array])
            switch rawData.type {
            case .Bool:
                guard rawData.boolValue else { break }
                defer { readModesExternal[mode] = true }
                let rawArray = try module.dataManager.fetchRawIdPath(idPath, mode: mode)
                try readDataArray(rawArray, map: map, mode: mode, module: module)

            case .Array:
                defer { readModesExternal[mode] = false }
                try readDataArray(rawData, map: map, mode: mode, module: module)

            default:
                throw Au3dioDataManager.FetchError.InvalidFormat(rawData, Log())
            }
        }
        private mutating func readDataArray(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            assertEqual(rawData.type, .Array)

            for (_, v) in rawData {
                assertEqual(rawData.type, .Dictionary)
                var scenario = ScenarioComposition(idPath: idPath)
                try scenario.readData(v, map: map, mode: mode, module: module)
                scenarios.append(scenario)
            }
        }
        public func export(mode: PersistenceMode) -> JSONType? {
            return JSONType(scenarios.flatMap { $0.export(mode) })
        }
    }
}