
public protocol LevelComponent: AnyComponent {
    init(composition: LevelComposition, data: JSON)
}

public struct LevelComposition: AnyComposition {
    var levelComponents: [String: LevelComponent]

    public init(data: JSON) {
        levelComponents = [:]
    }
}

public extension LevelComposition {
    public var components: [String: AnyComponent] {
        get {
            return levelComponents.flatMapCastDict()
        }
        set {
            levelComponents = newValue.flatMapCastDict()
        }
    }

    public func export() -> JSON {
        let x = components.mapDict {
            ($0.0, $0.1.export())
            } as [String: JSON]
        return JSON(x)
    }
}
