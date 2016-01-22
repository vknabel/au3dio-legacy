
import Foundation

/// :license: MIT
/// :source: https://github.com/krzysztofzablocki/KZLinkedConsole
func logMessage(message: String, filename: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
    print("\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)")
}

public func assertEqual<T: Equatable>(@autoclosure lhs: () -> T, @autoclosure _ rhs: () -> T, file: StaticString = __FILE__, line: UInt = __LINE__) {
    #if debug
    let (l, r) = (lhs(), rhs())
    assert(l == r, "\(file):\(line) Expected value to be \(r), given \(l)")
    #endif
}
public func assertOneOf<T: Equatable>(@autoclosure lhs: () -> T, @autoclosure _ rhss: () -> [T], file: StaticString = __FILE__, line: UInt = __LINE__) {
    #if debug
        let (l, rs) = (lhs(), rhss())
        assert(rs.contains(l), "\(file):\(line) Expected value to be one of \(rs), given \(l)")
    #endif
}

extension SequenceType {
    public func castReduce<T>() -> [T] {
        return reduce([], combine: { (var slf, val) -> [T] in
            if let castVal = val as? T {
                slf.append(castVal)
            }
            return slf
        })
    }
}

extension Dictionary {
    public func flatMapCastDict<T>() -> [Key: T] {
        var result = [Key: T]()
        for (k, v) in self {
            if let newV = v as? T {
                result[k] = newV
            }
        }
        return result
    }

    public func mapDict<K, V>(@noescape transform: Generator.Element throws -> (K, V)) rethrows -> [K: V] {
        var result = [K: V]()
        for kv in self {
            let (newKey, newValue) = try transform(kv)
            result[newKey] = newValue
        }
        return result
    }
    public func flatMapDict<K, V>(@noescape transform: Generator.Element throws -> (K, V)?) rethrows -> [K: V] {
        var result = [K: V]()
        for kv in self {
            if let (newKey, newValue) = try transform(kv) {
                result[newKey] = newValue
            }
        }
        return result
    }
}

public extension String {
    public var nsstring: NSString {
        return self as NSString
    }
    public init?(path: String = "", relativeTo: NSSearchPathDirectory, domain: NSSearchPathDomainMask = .AllDomainsMask, expandTilde: Bool = true) {
        if let s = NSSearchPathForDirectoriesInDomains(relativeTo, domain, expandTilde).first?.nsstring.stringByAppendingPathComponent(path) {
            self = s
        } else {
            return nil
        }
    }

    public mutating func appendPath(relativePath: String) {
        self = nsstring.stringByAppendingPathComponent(relativePath)
    }
    public func appendingPath(relativePath: String) -> String {
        return nsstring.stringByAppendingPathComponent(relativePath)
    }
    public mutating func appendFileExtension(fileExtension: String) {
        self = nsstring.stringByAppendingPathExtension(fileExtension) ?? "\(self).\(fileExtension)"
    }
    public func appendingFileExtension(fileExtension: String) -> String {
        return nsstring.stringByAppendingPathExtension(fileExtension) ?? "\(self).\(fileExtension)"
    }
}
