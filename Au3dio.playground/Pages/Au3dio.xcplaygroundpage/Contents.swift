//: Playground - noun: a place where people can play

/*: TODO
- Add configuration options for `Au3dioModule`: Dictionary<PersistenceMode, String/NSURL>
- Implement `Au3dioDataManager`
- Implement hook for every implementation of Composition: (String) -> Component.Type
*/

import Foundation

class TempInteractor: Au3dioInteractorType, InteractorType {
    var module: Au3dioModule
    required init(module: Au3dioModule) {
        self.module = module
    }
}

let config = Au3dioConfiguration(persistenceModePaths: [
    .Readonly: "",
    .Descriptive: "",
    .SemiPersistent: "",
    .FullyPersistent: ""
    ]
)
let au3dio = Au3dioModule(configuration: config, listOfInteractionTypes:
    GameDataInteractor.self,
    TempInteractor.self
)
