
/// A `ComponentMap` defines property names for component types for each Composition type.
public struct ComponentMap {
    /// `MapType` associates strings with component types.
    public typealias MapType = [String: ComponentType.Type]
    /// Stores all keys with their according type of `ComponentType`s.
    public var componentTypes: [String: ComponentType.Type] = [:]
    //public var goalComponents: [String: GoalComponent.Type] = [:]
}