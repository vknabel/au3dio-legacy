
public protocol EntityComponent: AnyComponent {
    init(composition: EntityComposition, data: JsonDataType)
}

public struct EntityComposition: AnyComposition, PersistentModeExportable {
    var entityComponents: [String: EntityComponent]

    public init(data: JsonDataType) {
        entityComponents = [:]
    }
}

public extension EntityComposition {
    public var compositions: [String: AnyComponent] {
        get {
            return entityComponents.flatMapCastDict()
        }
        set {
            entityComponents = newValue.flatMapCastDict()
        }
    }

    public func export() -> JsonDataType {
        return entityComponents.mapDict {
            ($0.0, $0.1.export())
        }
    }
}
