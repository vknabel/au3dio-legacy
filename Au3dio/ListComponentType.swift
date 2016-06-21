
import SwiftyJSON
import ConclurerLog

public protocol ListComponentType: ComponentType {
    var idPath: IdPath { get }
    /// wether a specific mode is external or internal
    var readModesExternal: [PersistenceMode: Bool] { get set }
    var children: [CompositionType] { get set }
}

public extension ListComponentType {

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
        let sc = children
        var newScs = [CompositionType]()
        var i = 0
        for (_, v) in rawData {
            assertEqual(rawData.type, .Dictionary)
            var list = sc.count > i ? sc[i] : InlineComposition(idPath: idPath)

            defer {
                newScs.append(list)
                i += 1
            }
            guard v.type != .Null else { continue }
            try list.readData(v, map: map, mode: mode, module: module)
        }
        children = newScs
    }
    public func export(mode: PersistenceMode) -> RawDataType? {
        return RawDataType(children.map { $0.export(mode) ?? RawDataType(NSNull()) })
    }
}
