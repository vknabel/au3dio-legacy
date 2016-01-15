
public struct Au3dioConfiguration {
    public var persistenceModePaths: [PersistenceMode: String]

    public init(persistenceModePaths: [PersistenceMode: String]) {
        self.persistenceModePaths = persistenceModePaths
    }
}
