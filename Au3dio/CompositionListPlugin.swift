
import SwiftyJSON
import ConclurerLog

public protocol CompositionListComponentType {
    var scenarios: [CompositionType] { get }
}
public final class CompositionListPlugin: Au3dioModulePlugin {
    public let module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["compositions"] = Component.self
    }

    public func addAliases(aliases: [String]) {
        aliases.forEach {
            module.componentMap.componentTypes[$0] = Component.self
        }
    }

    public struct Component: ComponentType, ScenarioListComponentType {
        private var idPath: IdPath
        private var readModesExternal: [PersistenceMode: Bool] = [:] /// wether a specific mode is external or internal
        public var scenarios: [CompositionType] = []

        public init(composition: CompositionType, key: String) {
            idPath = IdPath(idPath: composition.idPath, suffix: key)
        }
        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
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
                throw FetchError.InvalidFormat(rawData, Log())
            }
        }
        private mutating func readDataArray(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            assertEqual(rawData.type, .Array)
            let sc = scenarios
            var newScs = [CompositionType]()
            var i = 0
            for (_, v) in rawData {
                assertEqual(rawData.type, .Dictionary)
                var scenario = sc.count > i ? sc[i] : ScenarioComposition(idPath: idPath)

                defer {
                    newScs.append(scenario)
                    i++
                }
                guard v.type != .Null else { continue }
                try scenario.readData(v, map: map, mode: mode, module: module)
            }
            scenarios = newScs
        }
        public func export(mode: PersistenceMode) -> RawDataType? {
            return RawDataType(scenarios.map { $0.export(mode) ?? RawDataType(NSNull()) })
        }
    }
}