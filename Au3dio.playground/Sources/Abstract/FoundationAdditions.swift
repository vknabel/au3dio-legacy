
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
}
