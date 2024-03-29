
import Then
import StateMachine
import RxSwift

/// The Interactor to be used in order to communicate with the framework.
public final class Au3dioModule: ModuleType, Then {
    /// State Machine for possible phases of the Au3dioModule.
    private var phaseMachine: StateMachine<Phase>
    /// Stores all module interactors
    public lazy var dataManager: DataManager = DataManager(module: self)
    public private(set) lazy var modulePlugins: [Au3dioModulePlugin] = [self.dataManager]
    public let configuration: Configuration
    public var componentMap: ComponentMap = ComponentMap()
    public private(set) lazy var rootCompositionStream: Observable<RootComposition> = self.dataManager.rootCompositionSubject.asObservable().shareReplayLatestWhileConnected()
    public let disposeBag: DisposeBag = DisposeBag()

    /// Create an instance of Au3dioModule by the given Au3dioInteractorTypes.
    public init(configuration: Configuration, pluginTypes: [Au3dioModulePlugin.Type]) {
        self.configuration = configuration
        
        phaseMachine = StateMachine(initial: .Preparation(.Initial)) { trans in
            trans.allow(transitionFrom: .Preparation(.Initial), to: .Preparation(.PrepareHooks))
            trans.allow(transitionFrom: .Preparation(.PrepareHooks), to: .Preparation(.RegisterHooks))
            trans.allow(transitionFrom: .Preparation(.RegisterHooks), to: .Runtime(.Idle))
            trans.allowAssociatively([.Runtime(.Idle), .Runtime(.Running)])
        }
        modulePlugins.appendContentsOf(pluginTypes.map { $0.init(module: self) })
    }
    /// Create an instance of Au3dioModule by the given list of Au3dioPluginTypes.
    public convenience init(configuration: Configuration, listOfPluginTypes pluginTypes: Au3dioModulePlugin.Type...) {
        self.init(configuration: configuration, pluginTypes: pluginTypes)
    }

    /// Performs the given operation on phase transitions to a given phase.
    public func onPhase(phase: Phase, perform op: StateMachine<Phase>.Operation) {
        phaseMachine.on(transitionTo: phase, perform: op)
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

/// Adds convenience methods for finding plugins.
public extension Au3dioModule {
    /// Searched for a stored plugin of the given type.
    public func findPlugin<T: Au3dioModulePlugin>(type: T.Type) -> T? {
        for c in self.modulePlugins {
            if let c = c as? T {
                return c
            }
        }
        return nil
    }
}

/// Implements missing methods for Au3dioModule.Phase's protocols
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
