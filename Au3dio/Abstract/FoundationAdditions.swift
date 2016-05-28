
import Foundation

/// Fails in debug mode when two provided values are unequal.
/// Otherwise nothing will be executed.
public func assertEqual<T: Equatable>(@autoclosure lhs: () -> T, @autoclosure _ rhs: () -> T, file: StaticString = #file, line: UInt = #line) {
    #if debug
    let (l, r) = (lhs(), rhs())
    assert(l == r, "\(file):\(line) Expected value to be \(r), given \(l)")
    #endif
}
/// Fails in debug mode when the first value is not contained in the latter ones.
/// Otherwise nothing will be executed.
public func assertOneOf<T: Equatable>(@autoclosure lhs: () -> T, @autoclosure _ rhss: () -> [T], file: StaticString = #file, line: UInt = #line) {
    #if debug
        let (l, rs) = (lhs(), rhss())
        assert(rs.contains(l), "\(file):\(line) Expected value to be one of \(rs), given \(l)")
    #endif
}

extension SequenceType {
    /// Returns all values of a specific type.
    public func castReduce<T>() -> [T] {
        return reduce([], combine: { ( slf, val) -> [T] in
            var mutate = slf
            if let castVal = val as? T {
                mutate.append(castVal)
            }
            return mutate
        })
    }
}

extension Dictionary {
    /// Transforms all elements of the dictionary to new key-value-tuples into a new instance of Dictionary.
    public func mapDict<K, V>(@noescape transform: Generator.Element throws -> (K, V)) rethrows -> [K: V] {
        var result = [K: V]()
        for kv in self {
            let (newKey, newValue) = try transform(kv)
            result[newKey] = newValue
        }
        return result
    }
    /// Transforms all elements of the dictionary to new key-value-tuples into a new instance of Dictionary.
    /// Nil values will be ignored.
    public func flatMapDict<K, V>(@noescape transform: Generator.Element throws -> (K, V)?) rethrows -> [K: V] {
        var result = [K: V]()
        for kv in self {
            if let (newKey, newValue) = try transform(kv) {
                result[newKey] = newValue
            }
        }
        return result
    }
    /// Returns a dictionary filtered for a specific type.
    public func flatMapCastDict<T>() -> [Key: T] {
        var result = [Key: T]()
        for (k, v) in self {
            if let newV = v as? T {
                result[k] = newV
            }
        }
        return result
    }
}

public extension String {
    /// Returns a representation of `NSString`.
    public var nsstring: NSString {
        return self as NSString
    }
    /// Creates a new instance of `String` relative to a searched path directory using a domain mask when possible.
    public init?(path: String = "", relativeTo: NSSearchPathDirectory, domain: NSSearchPathDomainMask = .AllDomainsMask, expandTilde: Bool = true) {
        if let s = NSSearchPathForDirectoriesInDomains(relativeTo, domain, expandTilde).first?.nsstring.stringByAppendingPathComponent(path) {
            self = s
        } else {
            return nil
        }
    }
    /// Appends a given path component.
    public mutating func appendPath(relativePath: String) {
        self = nsstring.stringByAppendingPathComponent(relativePath)
    }
    /// Returns a new `String` by appending a path component.
    public func appendingPath(relativePath: String) -> String {
        return nsstring.stringByAppendingPathComponent(relativePath)
    }
    /// Appends a given file extension.
    public mutating func appendFileExtension(fileExtension: String) {
        self = nsstring.stringByAppendingPathExtension(fileExtension) ?? "\(self).\(fileExtension)"
    }
    /// Returns a new `String` by appending a file extension.
    public func appendingFileExtension(fileExtension: String) -> String {
        return nsstring.stringByAppendingPathExtension(fileExtension) ?? "\(self).\(fileExtension)"
    }
}
