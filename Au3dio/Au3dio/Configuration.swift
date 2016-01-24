
/// Instances store all data Au3dioModule requires to be immutable.
public struct Configuration {
    /// Stores a path for `PersistenceMode`s.
    /// `PersistenceMode`s without paths will be ignored.
    public var persistenceModePaths: [PersistenceMode: String]

    /// Creates a Configuration with paths for `PersistenceMode`s.
    public init(persistenceModePaths: [PersistenceMode: String]) {
        self.persistenceModePaths = persistenceModePaths
    }
}
