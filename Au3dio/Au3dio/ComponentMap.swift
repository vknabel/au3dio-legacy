
/// A `ComponentMap` defines property names for component types for each Composition type.
public struct ComponentMap {
    public typealias MapType = [String: ComponentType.Type]
    public var componentTypes: [String: ComponentType.Type] = [:]
    //public var goalComponents: [String: GoalComponent.Type] = [:]
}