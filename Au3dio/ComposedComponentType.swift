
public protocol ComponentDictionaryType: FindComponentType {
    /// Stores all components by name.
    var components: [String: ComponentType] { get set }
}

public extension ComponentDictionaryType {
    /// Returns a component of a given type when found.
    public func findComponent<T: ComponentType>(type: T.Type) -> T? {
        for (_, c) in components {
            if let c = c as? T {
                return c
            }
        }
        return nil
    }
    /// Adds a component for a given key.
    public mutating func setComponent<T: ComponentType>(key: String, component: T) {
        components[key] = component
    }
    /// Searches for a component by type and updates it when found.
    public mutating func updateComponent<T: ComponentType>(type: T.Type, update: (inout T) -> ()) {
        for (k, v) in components {
            if var c = v as? T {
                update(&c)
                components[k] = c
                return
            }
        }
    }
}
