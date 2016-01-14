
public typealias JSONType = JSON
public protocol CompositionType: ModePersistable {
    init(idPath: IdPath)
    var idPath: IdPath { get }
    var components: [String: ComponentType] { get set }
}
public protocol ComponentType: ModePersistable {
    init(composition: CompositionType, key: String)
    mutating func readData(rawData: JSONType, mode: PersistenceMode)
}

public struct Composition: CompositionType {
    public let idPath: IdPath
    public var components: [String: ComponentType] = [:]

    public init(idPath: IdPath) {
        self.idPath = idPath
    }

    public func export() -> JSONType {
        return JSONType(components.mapDict({ ($0.0, $0.1.export()) }))
    }
}

public extension CompositionType {
    public mutating func readComponents(rawData: JSONType, map: ComponentMap.MapType, mode: PersistenceMode) throws {
        assert(rawData.type == .Dictionary, "ComponentType.readComponents requires rawData.type to be .Dictionary,  \(rawData.type)")
        for (k, sub) in rawData {
            guard let type = map[k] else { throw Au3dioDataManager.FetchError.UnknownComponent(k) }
            self.components[k] = type.init(composition: self, key: k)
            self.components[k]?.readData(sub, mode: mode)
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
}

public protocol ModePersistable {
    func export() -> JSONType
}

public protocol ExtendedModePersistable {
    func save(ensureCached: (IdPath, Int) -> Void) throws
}
