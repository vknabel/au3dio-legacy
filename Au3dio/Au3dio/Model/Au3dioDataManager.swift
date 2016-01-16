
import Foundation
import SwiftyJSON

public final class Au3dioDataManager: Au3dioModulePlugin {
    public var module: Au3dioModule
    public let rootIdPath = IdPath(id: "Au3dioRoot")

    public private(set) lazy var rootComposition: RootComposition = self.fetchRootCompositionUnthrowingly()

    public init(module: Au3dioModule) {
        self.module = module
    }

    private func fetchRootCompositionUnthrowingly() -> RootComposition {
        do {
            return try self.fetchRootComposition()
        } catch {
            print("\(__FILE__):\(__LINE__) \(error)")
            return RootComposition(idPath: self.rootIdPath)
        }
    }
    private func fetchRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> RootComposition {
        return try fetchComposition(rootIdPath, modes: modes)
    }

    public func reloadRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> RootComposition {
        
        rootComposition = try self.fetchRootComposition()
        return rootComposition
    }

    /// :throws: `FetchError`
    public func fetchRawIdPath(idPath: IdPath, mode: PersistenceMode) throws -> JSON {
        do {
            guard let prefixPath = module.configuration.persistenceModePaths[mode]
                else { throw FetchError.UndefinedMode }
            let path = idPath.absolutePath(prefixPath)
            guard let data = NSData(contentsOfFile: path) else { throw FetchError.FileNotFound(__FILE__, __LINE__, path) }
            return JSON(data: data)
        } catch let error as FetchError {
            throw error
        } catch let error as NSError {
            throw FetchError.FoundationError(error)
        }
    }
    public func fetchComposition<C: CompositionType>(idPath: IdPath, modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws -> C {
        var comp = C(idPath: idPath)
        for m in PersistenceMode.allPersistenceModes() where modes.contains(m) {
            guard let raw = try? fetchRawIdPath(rootIdPath, mode: m) else { continue }
            try comp.readData(raw, map: module.componentMap.componentTypes, mode: m, module: module)
        }
        return comp
    }

    public func saveRawData(rawData: JSONType, idPath: IdPath, mode: PersistenceMode) throws {
        guard let path = module.configuration.persistenceModePaths[mode] else { return }
        let data = try rawData.rawData()
        try data.writeToFile(idPath.absolutePath(idPath.absolutePath(path)), options: NSDataWritingOptions.DataWritingAtomic)
    }
    public func saveRootComposition(modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws {
        try savePersistable(rootComposition, idPath: rootIdPath, modes: modes)
    }
    /// TODO: Discuss
    public func savePersistable<T: ModePersistable>(persistable: T, idPath: IdPath, modes: Set<PersistenceMode> = PersistenceMode.allPersistenceModes()) throws {
        for m in PersistenceMode.allPersistenceModes() where modes.contains(m) {
            let raw = persistable.export(m)
            try saveRawData(raw, idPath: idPath, mode: m)
        }
        if let composition = persistable as? ExtendedModePersistable {
            try composition.save(module, modes: modes)
        }
    }
}

public extension Au3dioDataManager {

    public enum FetchError: ErrorType {
        case InvalidFormat(String, Int, Any)
        case UnknownComponent(String, Int, Any, String)
        case FileNotFound(String, Int, String)
        case UndefinedMode
        case NotImplemented
        case InvalidTargetObject
        case NoData
        case FoundationError(NSError)
    }
}
