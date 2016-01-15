
import Au3dio
import SwiftyJSON

func play() {
    let paths: [PersistenceMode: String] = [
        PersistenceMode.Readonly: "Readonly",
        .Descriptive: "Descriptive",
        .SemiPersistent: "Semi",
        .FullyPersistent: "Fully"
        ].mapDict { ($0.0, NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent($0.1)) }
    let config = Au3dioConfiguration(persistenceModePaths: paths)
    let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
        GameDataInteractor.self,
        NamePlugin.self,
        GreetingPlugin.self,
        CompositionListPlugin.self
    )
    au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

    do {
        let rootId = IdPath(id: "Au3dioData")
        let root = try au3dio.dataManager.fetchRootIdPath(rootId, mode: .Readonly)
        print("succeeded: \(root.components)")

        let testId = IdPath(idPath: rootId, suffix: "ScenarioList")
    } catch {
        print("failed \(error)")
    }
}