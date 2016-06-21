
import SwiftyJSON
import ConclurerLog

/// The used raw data type used throughout the project.
public typealias RawDataType = JSON

/// Compositions are persistent entities referenced by an `IdPath`.
public protocol CompositionType: ModePersistable {
    /// Creates an empty composition.
    init(idPath: IdPath)
    /// Stores all components by name.
    var components: [String: ComponentType] { get set }
}
/// Components will be added to a composition.
public protocol ComponentType: ModePersistable {
    /// Initializes a components with a composition. 
    /// The given composition is only used to initialze the composition.
    init(composition: CompositionType, idPath: IdPath)
    /// Applys changes given as raw data in a given mode.
    /// :throws: FetchError
    mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws
}

/// An empty and default implementation of a composition.
public struct Composition: CompositionType, DefaultDescendant {
    public let idPath: IdPath
    public var components: [String: ComponentType] = [:]

    public init(idPath: IdPath) {
        self.idPath = idPath
    }

    public func export(mode: PersistenceMode) -> RawDataType? {
        return RawDataType(components.mapDict({ ($0.0, $0.1.export(mode) ?? RawDataType(NSNull())) }))
    }
}
/// An empty implementation that is not meant to be stored in external files.
public struct InlineComposition: CompositionType, DefaultDescendant {
    public let idPath: IdPath
    public var components: [String: ComponentType] = [:]

    public init(idPath: IdPath) {
        self.idPath = idPath
    }

    public func export(mode: PersistenceMode) -> RawDataType? {
        return RawDataType(components.mapDict({ ($0.0, $0.1.export(mode) ?? RawDataType(NSNull())) }))
    }
}

/// Adds basic functionality to all compositions.
public extension CompositionType {
    /// Creates and updates all components with rawData.
    /// :throws: FetchError
    public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
        guard rawData.type == .Dictionary else {
            assert([.Dictionary, .Null].contains(rawData.type), "ComponentType.readComponents requires rawData.type to be .Dictionary,  \(rawData.type)")
            return
        }
        for (k, sub) in rawData {
            guard let type = map[k] else { throw FetchError.UnknownComponent(k, Array(map.keys), rawData, Log()) }
            self.components[k] = self.components[k] ?? type.init(composition: self, idPath: IdPath(idPath: idPath, suffix: k))
            try self.components[k]?.readData(sub, map: map, mode: mode, module: module)
        }
    }
    /// Returns a component of a given type when found.
    public func findComponent<T: ComponentType>(type: T.Type) -> T? {
        for (_, c) in components {
            if let c = c as? T {
                return c
            }
        }
        return nil
    }
    /// Adds a component for a given key.
    public mutating func setComponent<T: ComponentType>(key: String, component: T) {
        components[key] = component
    }
    /// Searches for a component by type and updates it when found.
    public mutating func updateComponent<T: ComponentType>(type: T.Type, update: (inout T) -> ()) {
        for (k, v) in components {
            if var c = v as? T {
                update(&c)
                components[k] = c
                return
            }
        }
    }

    public func descendant(withComponent component: String) -> ModePersistable? {
        return components[component]
    }
}
