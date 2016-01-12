
public typealias JsonDataType = AnyObject

public protocol AnyComposition: PersistentModeExportable {
    init(data: JsonDataType)

    var compositions: [String: AnyComponent] { get set }
}
public protocol AnyComponent: PersistentModeExportable {
    init(composition: AnyComposition, data: JsonDataType)
}

public enum PersistenceMode: Int {
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

public protocol PersistentModeExportable {
    func export() -> JsonDataType
}
