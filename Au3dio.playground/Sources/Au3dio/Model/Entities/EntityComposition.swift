
public protocol EntityComponent: AnyComponent {
    init(composition: EntityComposition, data: JSON)
}

public struct EntityComposition: AnyComposition, PersistentModeExportable {
    var entityComponents: [String: EntityComponent]

    public init(data: JSON) {
        entityComponents = [:]
    }
}

public extension EntityComposition {
    public var components: [String: AnyComponent] {
        get {
            return entityComponents.flatMapCastDict()
        }
        set {
            entityComponents = newValue.flatMapCastDict()
        }
    }

    public func export() -> JSON {
        let x = components.mapDict {
            ($0.0, $0.1.export())
            } as [String: JSON]
        return JSON(x)
    }
}
