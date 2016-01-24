
public struct Configuration {
    public var persistenceModePaths: [PersistenceMode: String]

    public init(persistenceModePaths: [PersistenceMode: String]) {
        self.persistenceModePaths = persistenceModePaths
    }
}
