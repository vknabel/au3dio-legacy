
/// The Interactor to be used in order to communicate with the framework.
public final class Au3dioModule: ModuleType, Then {
    /// State Machine for possible phases of the Au3dioModule.
    private var phaseMachine: StateMachine<Phase>
    /// Stores all module interactors
    public private(set) var moduleInteractors: [Au3dioInteractorType] = []

    /// Create an instance of Au3dioModule by the given Au3dioInteractorTypes.
    public init(interactorTypes: [Au3dioInteractorType.Type]) {
        phaseMachine = StateMachine(initial: .Preparation(.Initial)) { trans in
            trans.allow(from: .Preparation(.Initial), to: .Preparation(.PrepareHooks))
            trans.allow(from: .Preparation(.PrepareHooks), to: .Preparation(.RegisterHooks))
            trans.allow(from: .Preparation(.RegisterHooks), to: .Runtime(.Idle))
            trans.allowAssociatively([.Runtime(.Idle), .Runtime(.Running)])
        }
        moduleInteractors.appendContentsOf(interactorTypes.map { $0.init(module: self) })
    }
    /// Create an instance of Au3dioModule by the given list of Au3dioInteractorTypes.
    public convenience init(listOfInteractionTypes interactorTypes: Au3dioInteractorType.Type...) {
        self.init(interactorTypes: interactorTypes)
    }

    /// Performs the given operation on phase transitions to a given phase.
    public func onPhase(phase: Phase, perform op: StateMachine<Phase>.Operation) {
        phaseMachine.onTransitions(to: phase, perform: op)
    }

}

/// Declares Au3dioModule.Phase for the phase property
public extension Au3dioModule {

    /// Represents the framework's internal state.
    public enum Phase: Hashable {
        /// This represents the initial phase.
        case Preparation(PreparationPhase)
        /// The usual phase, after .Preparation(_)
        case Runtime(RuntimePhase)

        /// These sub-phases will only be triggered once per lifecycle of the Au3dioModule.
        public enum PreparationPhase: Hashable {
            /// The initial sub-phase.
            /// Currently only the Au3dioModule global phase is initialized.
            case Initial
            /// In this phase all custom hooks shall be initialized internally.
            case PrepareHooks
            /// Use this phase in order to register callbacks for external hooks.
            case RegisterHooks
        }
        /// Represents all possible sub-phases when the .Preparation(_) phase has been finished.
        public enum RuntimePhase: Hashable {
            /// This phase represents, that currently no game is running.
            case Idle
            /// Currently there is a game running in this context.
            case Running
        }
    }
}

public extension Au3dioModule.Phase {

    public var hashValue: Int {
        switch self {
        case .Preparation(let substate):
            return substate.hashValue >> 0
        case .Runtime(let substate):
            return substate.hashValue >> 2
        }
    }
}

@warn_unused_result
public func ==(lhs: Au3dioModule.Phase, rhs: Au3dioModule.Phase) -> Bool {
    switch (lhs, rhs) {
    case (.Preparation(let lpp), .Preparation(let rpp)):
        return lpp == rpp
    case (.Runtime(let lrp), .Runtime(let rrp)):
        return lrp == rrp
    default:
        return false
    }
}
