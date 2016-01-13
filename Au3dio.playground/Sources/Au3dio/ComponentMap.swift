
/// A `ComponentMap` defines property names for component types for each Composition type.
public struct ComponentMap {
    public var entityComponents: [String: EntityComponent.Type] = [:]
    public var scenarioComponents: [String: ScenarioComponent.Type] = [:]
    public var levelComponents: [String: LevelComponent.Type] = [:]
    //public var goalComponents: [String: GoalComponent.Type] = [:]
}