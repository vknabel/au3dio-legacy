
import Then
import RxSwift


public protocol GameBehavior: ComponentType {
    func connect<S: SubjectType where S.E == GameInteractor.Environment.GameState>(to stateSubject: S) -> Disposable
}

/// This VIPER Interactor represents the use-case of displaying a specific level.
public final class GameInteractor: Au3dioInteractorType, InteractorType, Then {
    public let module: Au3dioModule

    public init(module: Au3dioModule) {
        self.module = module

        module.onPhase(.Preparation(.PrepareHooks)) {
            // create custom hook
            return
        }

        module.onPhase(.Preparation(.RegisterHooks)) {
            // register hooks
            return
        }
    }

    public func environment(level: Environment.LevelComposition) throws -> Environment {
        return try Environment(level: level)
    }

    enum Error: ErrorType {
        case InvalidLevel
    }

    public final class Environment {
        // TODO: Revalidate typealiases
        public typealias LevelComposition = CompositionType
        public typealias GameState = CompositionType

        private let stateSubject: PublishSubject<GameState> = PublishSubject()
        private let bag: DisposeBag = DisposeBag()

        internal init(level: LevelComposition) throws {
            // TODO: Implement all Component Plugins
            guard let goals = level.findComponent(GreetingPlugin.Component.self),
                let entities = level.findComponent(GreetingPlugin.Component.self),
                let background = level.findComponent(GreetingPlugin.Component.self),
                let sound = level.findComponent(SoundPlugin.Component.self),
                let behaviors = level.findComponent(CompositionListPlugin.Component.self)
                else { throw Error.InvalidLevel }

            stateSubject.takeLast(1).subscribeNext(complete).addDisposableTo(bag)

            // TODO: Also add global behaviors to Au3dioModule
            behaviors.scenarios.castReduce(GameBehavior.self).forEach { behavior in
                behavior.connect(to: stateSubject).addDisposableTo(bag)
            }
        }

        internal func complete(final state: GameState) {

        }
    }
}
