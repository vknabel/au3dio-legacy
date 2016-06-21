
public protocol ComposedComponentType: ComponentType {
    var components: [String: ComponentType] { get }
}
