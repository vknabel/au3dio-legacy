
public protocol ComposedComponentType: ComponentType, DefaultDescendant {
    var components: [String: ComponentType] { get }
}

public extension ComposedComponentType {
    public func descendant(withComponent component: String) -> ModePersistable? {
        return components[component]
    }
}
