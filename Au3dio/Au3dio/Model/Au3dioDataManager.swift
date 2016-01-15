
import Foundation
import SwiftyJSON

public final class Au3dioDataManager: Au3dioModulePlugin {
    public var module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module
    }

    /// :throws: `FetchError`
    public func fetchRawIdPath(idPath: IdPath, mode: PersistenceMode) throws -> JSON {
        do {
            guard let prefixPath = module.configuration.persistenceModePaths[mode]
                else { throw FetchError.UndefinedMode }
            let path = idPath.absolutePath(prefixPath)
            guard let data = NSData(contentsOfFile: path) else { throw FetchError.FileNotFound }
            return JSON(data: data)
        } catch let error as FetchError {
            throw error
        } catch let error as NSError {
            throw FetchError.FoundationError(error)
        }
    }
    public func fetchRootIdPath(idPath: IdPath, mode: PersistenceMode) throws -> RootComposition {
        let raw = try fetchRawIdPath(idPath, mode: mode)
        var root = Composition(idPath: idPath)
        try root.readData(raw, map: module.componentMap.componentTypes, mode: mode, module: module)
        return root
    }

    /// :params: mode PersistenceMode
    /// :throws: `FetchError`
    private func fetchRecursively(mode: PersistenceMode, into: JSON? = nil) throws -> JSON {
        // TODO: Implement
        throw FetchError.NotImplemented
    }
}

public extension Au3dioDataManager {

    public enum FetchError: ErrorType {
        case UndefinedMode
        case InvalidFormat(String, Int, Any)
        case FileNotFound
        case UnknownComponent(String, Int, Any, String)
        case NotImplemented
        case InvalidTargetObject
        case NoData
        case FoundationError(NSError)
    }
}
