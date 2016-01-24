
import SwiftyJSON
import ConclurerLog

public typealias JSONType = JSON
public protocol CompositionType: ModePersistable {
    init(idPath: IdPath)
    var idPath: IdPath { get }
    var components: [String: ComponentType] { get set }
}
public protocol ComponentType: ModePersistable {
    init(composition: CompositionType, key: String)
    mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws
}

public struct Composition: CompositionType {
    public let idPath: IdPath
    public var components: [String: ComponentType] = [:]

    public init(idPath: IdPath) {
        self.idPath = idPath
    }

    public func export(mode: PersistenceMode) -> JSONType? {
        return JSONType(components.mapDict({ ($0.0, $0.1.export(mode) ?? JSONType(NSNull())) }))
    }
}
public struct InlineComposition: CompositionType {
    public let idPath: IdPath
    public var components: [String: ComponentType] = [:]

    public init(idPath: IdPath) {
        self.idPath = idPath
    }

    public func export(mode: PersistenceMode) -> JSONType? {
        return JSONType(components.mapDict({ ($0.0, $0.1.export(mode) ?? JSONType(NSNull())) }))
    }
}

public extension CompositionType {
    public mutating func readData(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
        guard rawData.type == .Dictionary else {
            assert([.Dictionary, .Null].contains(rawData.type), "ComponentType.readComponents requires rawData.type to be .Dictionary,  \(rawData.type)")
            return
        }
        for (k, sub) in rawData {
            guard let type = map[k] else { throw Au3dioDataManager.FetchError.UnknownComponent(k, rawData, Log()) }
            self.components[k] = self.components[k] ?? type.init(composition: self, key: k)
            try self.components[k]?.readData(sub, map: map, mode: mode, module: module)
        }
    }

    public func findComponent<T: ComponentType>(type: T.Type) -> T? {
        for c in components {
            if let c = c as? T {
                return c
            }
        }
        return nil
    }

    public mutating func setComponent<T: ComponentType>(key: String, component: T) {
        components[key] = component
    }
    public mutating func updateComponent<T: ComponentType>(type: T.Type, update: (inout T) -> ()) {
        for (k, v) in components {
            if var c = v as? T {
                update(&c)
                components[k] = c
                return
            }
        }
    }
}

public enum PersistenceMode: Int, Hashable {
    /// The default storage, that is readonly.
    /// Typically results of an .Descriptive export are used data source.
    case Readonly = 0
    /// Exports in this mode represent initial states.
    /// Module parts aren't required to support this level.
    /// Typically levels are build in this mode.
    /// TODO: Is this required?
    case Descriptive
    /// Only some data will be persistent.
    /// .SemiPersistent storages are typically used for achievements.
    case SemiPersistent
    /// The highest layer of persistence. All data will be saved.
    /// .FullyPersistent data usually represents saved games.
    case FullyPersistent

    public static func allPersistenceModes<T: ArrayLiteralConvertible where T.Element == PersistenceMode>() -> T {
        return [PersistenceMode.Readonly, .Descriptive, .SemiPersistent, .FullyPersistent]
    }
    public static func writeablePersistenceModes<T: ArrayLiteralConvertible where T.Element == PersistenceMode>() -> T {
        return [.Descriptive, .SemiPersistent, .FullyPersistent]
    }
}

public protocol ModePersistable {
    func export(mode: PersistenceMode) -> JSONType?
}

public protocol ExtendedModePersistable: ModePersistable {
    func save(module: Au3dioModule, modes: Set<PersistenceMode>) throws
}
