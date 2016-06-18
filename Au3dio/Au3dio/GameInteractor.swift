
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
}
