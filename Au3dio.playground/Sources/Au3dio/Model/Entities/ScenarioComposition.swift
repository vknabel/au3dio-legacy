
public protocol ScenarioComponent: AnyComponent {
    init(composition: ScenarioComposition, data: JSON)
}

public struct ScenarioComposition: AnyComposition {
    var scenarioComponents: [String: ScenarioComponent]

    public init(data: JSON) {
        scenarioComponents = [:]
    }
}

public extension ScenarioComposition {
    public var components: [String: AnyComponent] {
        get {
            return scenarioComponents.flatMapCastDict()
        }
        set {
            scenarioComponents = newValue.flatMapCastDict()
        }
    }

    public func export() -> JSON {
        let x = components.mapDict {
            ($0.0, $0.1.export())
            } as [String: JSON]
        return JSON(x)
    }
}
