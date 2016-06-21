//
//  PersistenceMode.swift
//  Au3dio
//
//  Created by Valentin Knabel on 24.01.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

/// Represents all cases of writing/reading raw data.
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

    /// All persistence modes.
    public static func allPersistenceModes<T: ArrayLiteralConvertible where T.Element == PersistenceMode>() -> T {
        return [PersistenceMode.Readonly, .Descriptive, .SemiPersistent, .FullyPersistent]
    }
    /// All persistence modes except `.Readonly`.
    public static func writeablePersistenceModes<T: ArrayLiteralConvertible where T.Element == PersistenceMode>() -> T {
        return [.Descriptive, .SemiPersistent, .FullyPersistent]
    }
}

/// Instances are able to be exported.
public protocol ModePersistable {
    /// The `IdPath` to be referenced.
    var idPath: IdPath { get }
    /// Returns the raw data for a given mode. If there is no data, returns `nil`.
    func export(mode: PersistenceMode) -> RawDataType?
    func descendant(with path: IdPath) -> ModePersistable?
}

/// Instances that need to save own/external data.
public protocol ExtendedModePersistable: ModePersistable {
    /// Tries to save all data in the given modes. Modes without a associated path need to be ignored.
    /// :throws: FetchError
    func save(module: Au3dioModule, modes: Set<PersistenceMode>) throws
}

public protocol DefaultDescendant: ModePersistable {
    func descendant(withComponent component: String) -> ModePersistable?
}

public extension DefaultDescendant {
    public func descendant(with path: IdPath) -> ModePersistable? {
        let relativeComponents = path.components(relativeTo: idPath)
        guard let first = relativeComponents.first else { return self }
        return descendant(withComponent: first)?.descendant(with: IdPath(components: relativeComponents))
    }
}

public protocol EmptyDescendant: ModePersistable { }

public extension EmptyDescendant {
    public func descendant(with path: IdPath) -> ModePersistable? {
        return nil
    }
}
