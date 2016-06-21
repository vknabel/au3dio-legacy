
/// Represents path components and an id.
public struct IdPath: CustomStringConvertible {
    internal var pathComponents: [String]

    public init(components: [String]) {
        pathComponents = components
    }
}

public extension IdPath {
    public var parent: IdPath? {
        guard pathComponents.count > 0 else { return nil }
        var comps = pathComponents
        _ = comps.removeLast()
        return IdPath(components: comps)
    }

    /// Creates a root id path.
    internal init(id: String) {
        pathComponents = [id]
    }

    /// Creates a relative `IdPath`.
    public init(idPath: IdPath, suffix: String) {
        pathComponents = idPath.pathComponents
        pathComponents.append(suffix)
    }

    /// Constructs a json-file path relative to an absolute path.
    public func filePath(path: String) -> String {
        return pathComponents.reduce(path, combine: {
            $0.appendingPath($1)
        }).appendingFileExtension("json")
    }
    /// Constructs a directory path relative to an absolute path.
    public func directoryPath(path: String) -> String {
        return pathComponents.reduce(path, combine: {
            $0.appendingPath($1)
        })
    }
    /// Returns a relative file path of the `IdPath`.
    public var description: String {
        return pathComponents.reduce("", combine: {
            $0.appendingPath($1)
        }).appendingFileExtension("json")
    }

    public func components(relativeTo parentPath: IdPath) -> [String] {
        var (descendants, parents) = (self.pathComponents, parentPath.pathComponents)
        while let descTop = descendants.first, let parentTop = parents.first where parentTop == descTop {
            descendants.removeFirst()
            parents.removeFirst()
        }
        return descendants
    }
}
