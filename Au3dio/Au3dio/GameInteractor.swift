
import Then
import RxSwift


public protocol GameStateReducer: ComponentType {
    func connect<S: ObservableType, R: ObserverType
        where S.E == GameInteractor.Environment.State,
        R.E == GameInteractor.Environment.StateReducer>
        (to path: IdPath, receiving state: S, reducing observer: R) -> Disposable
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
}
