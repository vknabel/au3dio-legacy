
public struct IdPath: CustomStringConvertible {
    internal var pathComponents: [String]

    public init(id: String) {
        pathComponents = [id]
    }

    public init(idPath: IdPath, suffix: String) {
        pathComponents = idPath.pathComponents
        pathComponents.append(suffix)
    }

    public func absolutePath(path: String) -> String {
        return pathComponents.reduce(path, combine: {
            $0.appendingPath($1)
        }).appendingFileExtension("json")
    }

    public var description: String {
        return pathComponents.reduce("", combine: {
            $0.appendingPath($1)
        }).appendingFileExtension("json")
    }
}
