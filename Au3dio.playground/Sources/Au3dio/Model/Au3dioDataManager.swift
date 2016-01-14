
import Foundation
//import SwiftyJSON

public final class Au3dioDataManager: Au3dioModulePart {
    public var module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module
    }

    /// :throws: `FetchError`
    private func fetchRawOnce(idPath: IdPath, mode: PersistenceMode) throws -> JSON {
        do {
            guard let prefixPath = module.configuration.persistenceModePaths[mode]
                else { throw FetchError.UndefinedMode }
            let path = idPath.absolutePath(prefixPath)
            return JSON(data: NSData(contentsOfFile: path)!)
        } catch let error as FetchError {
            throw error
        } catch let error as NSError {
            throw FetchError.FoundationError(error)
        }
    }
    public func fetchIdPath(idPath: IdPath, mode: PersistenceMode) throws -> RootComposition {
        let raw = try fetchRawOnce(idPath, mode: mode)
        var root = Composition(idPath: idPath)
        try root.readComponents(raw, map: module.componentMap.componentTypes, mode: mode)
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
        case UnknownComponent(String)
        case NotImplemented
        case InvalidTargetObject
        case NoData
        case FoundationError(NSError)
    }
}
