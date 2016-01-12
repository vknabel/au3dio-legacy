
public protocol ScenarioComponent: AnyComponent {
    init(composition: ScenarioComposition, data: JsonDataType)
}

public struct ScenarioComposition: AnyComposition {
    var scenarioComponents: [String: ScenarioComponent]

    public init(data: JsonDataType) {
        scenarioComponents = [:]
    }
}

public extension ScenarioComposition {
    public var compositions: [String: AnyComponent] {
        get {
            return scenarioComponents.flatMapCastDict()
        }
        set {
            scenarioComponents = newValue.flatMapCastDict()
        }
    }

    public func export() -> JsonDataType {
        return scenarioComponents.mapDict {
            ($0.0, $0.1.export())
        }
    }
}
