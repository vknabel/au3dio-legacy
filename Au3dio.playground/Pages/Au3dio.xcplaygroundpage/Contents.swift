//: Playground - noun: a place where people can play

class TempInteractor: Au3dioInteractorType, InteractorType {
    var module: Au3dioModule
    required init(module: Au3dioModule) {
        self.module = module
    }
}

let au3dio = Au3dioModule(listOfInteractionTypes:
    GameDataInteractor.self,
    TempInteractor.self
)
