
import Foundation
//import SwiftyJSON

public final class Au3dioDataManager: Au3dioModulePart {
    public var module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module
    }

    /// :throws: `FetchError`
    public func fetchRawOnce(path: String, mode: PersistenceMode) throws -> JSON {
        do {
            return try JSON(contentsOfFile: path)
        } catch let error as FetchError {
            throw error
        } catch let error as NSError {
            throw FetchError.FoundationError(error)
        }
    }
    public func fetchScenarioOnce(path: String, mode: PersistenceMode) throws -> ScenarioComposition {
        return ScenarioComposition(data: try fetchRawOnce(path, mode: mode))
    }

    /// :params: mode PersistenceMode
    /// :throws: `FetchError`
    public func fetchRecursively(mode: PersistenceMode, into: JSON? = nil) throws -> JSON {
        // TODO: Implement
        throw FetchError.NotImplemented
    }
}

public extension Au3dioDataManager {

    public enum FetchError: ErrorType {
        case NotImplemented
        case InvalidTargetObject
        case NoData
        case FoundationError(NSError)
    }
}