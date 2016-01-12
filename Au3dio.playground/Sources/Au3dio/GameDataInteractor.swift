
public final class GameDataInteractor: Au3dioInteractorType, InteractorType, Then {

    public var module: Au3dioModule

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
}
