
import Foundation
import SwiftyJSON
import ConclurerLog

/// A DataManager handles all kind of access to raw data in specified peristence modes.
public final class DataManager: Au3dioModulePlugin {
    public var module: Au3dioModule
    public static let rootIdPath = IdPath(id: "Au3dioRoot")

    /// The composition defined as root. It represents the data stored using `DataManager.rootIdPath`.
    public lazy var rootComposition: RootComposition = self.fetchRootCompositionUnthrowingly()

    public init(module: Au3dioModule) {
        self.module = module
    }

    private func fetchRootCompositionUnthrowingly() -> RootComposition {
        do {
            return try self.fetchRootComposition()
        } catch {
            Log.print(error, type: .Error)
            return RootComposition(idPath: DataManager.rootIdPath)
        }
    }
    private func fetchRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> RootComposition {
        return try fetchComposition(DataManager.rootIdPath, modes: modes)
    }

    /// Reloads the root composition in the given modes, updates `self.rootComposition` and returns the result.
    /// :throws: FetchError
    @warn_unused_result public func reloadRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> RootComposition {
        rootComposition = try self.fetchRootComposition()
        return rootComposition
    }

    /// Fetches and returns all raw data stored under an IdPath in a given mode.
    /// :throws: `FetchError`
    public func fetchRawIdPath(idPath: IdPath, mode: PersistenceMode) throws -> RawDataType {
        do {
            guard let prefixPath = module.configuration.persistenceModePaths[mode]
                else { throw FetchError.UndefinedMode }
            let path = idPath.filePath(prefixPath)
            guard let data = NSData(contentsOfFile: path) else { throw FetchError.FileNotFound(path, Log()) }
            return JSON(data: data)
        } catch let error as FetchError {
            throw error
        } catch let error as NSError {
            throw FetchError.FoundationError(error)
        }
    }
    /// Fetches and returns a composition stored under an IdPath in given modes.
    /// :throws: `FetchError`
    public func fetchComposition<C: CompositionType>(idPath: IdPath, modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> C {
        var comp = C(idPath: idPath)
        for m in PersistenceMode.allPersistenceModes() where modes.contains(m) {
            guard let raw = try? fetchRawIdPath(DataManager.rootIdPath, mode: m) else { continue }
            try comp.readData(raw, map: module.componentMap.componentTypes, mode: m, module: module)
        }
        return comp
    }

    /// Saves some raw data in a given mode under an IdPath.
    /// :throws: `FetchError`
    public func saveRawData(rawData: RawDataType, idPath: IdPath, mode: PersistenceMode) throws {
        guard let path = module.configuration.persistenceModePaths[mode]
            where PersistenceMode.writeablePersistenceModes().contains(mode)
            else { return }
        let data = try rawData.rawData()
        try data.writeToFile(idPath.filePath(path), options: NSDataWritingOptions.DataWritingAtomic)
    }
    public func saveRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws {
        try savePersistable(rootComposition, idPath: DataManager.rootIdPath, modes: modes)
    }
    /// TODO: Discuss
    public func savePersistable<T: ModePersistable>(persistable: T, idPath: IdPath, modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws {
        for m in PersistenceMode.allPersistenceModes() where modes.contains(m) {
            createIdPathDirectory(idPath, mode:  m)
            guard let raw = persistable.export(m) else { continue }
            try saveRawData(raw, idPath: idPath, mode: m)
        }
        if let composition = persistable as? ExtendedModePersistable {
            try composition.save(module, modes: modes)
        }
    }
    /// Creates all directories required to store raw data under an IdPath in a specific mode if needed.
    public func createIdPathDirectory(idPath: IdPath, mode: PersistenceMode) {
        guard let prefixPath = module.configuration.persistenceModePaths[mode] else { return }
        _ = try? NSFileManager.defaultManager().createDirectoryAtPath(idPath.directoryPath(prefixPath), withIntermediateDirectories: true, attributes: nil)
    }
    /// Removes all raw data of the given modes associated with an IdPath.
    public func invalidateModes(idPath: IdPath = DataManager.rootIdPath, modes: Set<PersistenceMode> = PersistenceMode.writeablePersistenceModes()) throws {
        let manager = NSFileManager.defaultManager()
        for m in PersistenceMode.writeablePersistenceModes() where modes.contains(m) {
            guard let prefixPath = module.configuration.persistenceModePaths[m] else { continue }

            func deleteIfPossible(path: String) throws {
                if manager.isDeletableFileAtPath(path) {
                    try manager.removeItemAtPath(path)
                } else {
                    Log.print("cannot delete \(path)", type: .Error)
                }
            }
            try deleteIfPossible(idPath.filePath(prefixPath))
            try deleteIfPossible(idPath.directoryPath(prefixPath))
        }

        _ = try self.reloadRootComposition()
    }
}

public extension DataManager {
    /// Describes all possible errors that may occur with persistence.
    public enum FetchError: ErrorType {
        case InvalidFormat(Any, Log)
        case UnknownComponent(String, Any, Log)
        case FileNotFound(String, Log)
        case UndefinedMode
        case NotImplemented
        case InvalidTargetObject
        case NoData
        case FoundationError(NSError)
    }
}
