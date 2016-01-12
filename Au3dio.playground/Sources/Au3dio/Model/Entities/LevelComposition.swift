
public protocol LevelComponent: AnyComponent {
    init(composition: LevelComposition, data: JsonDataType)
}

public struct LevelComposition: AnyComposition {
    var levelComponents: [String: LevelComponent]

    public init(data: JsonDataType) {
        levelComponents = [:]
    }
}

public extension LevelComposition {
    public var compositions: [String: AnyComponent] {
        get {
            return levelComponents.flatMapCastDict()
        }
        set {
            levelComponents = newValue.flatMapCastDict()
        }
    }
    
    public func export() -> JsonDataType {
        return levelComponents.mapDict {
            ($0.0, $0.1.export())
        }
    }
}
