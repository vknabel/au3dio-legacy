
import Au3dio
import SwiftyJSON

func play() {
    let paths: [PersistenceMode: String] = [
        PersistenceMode.Readonly: NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent("Readonly"),
        .Descriptive: String(path: "Descriptive", relativeTo: NSSearchPathDirectory.DocumentDirectory)!,
        .SemiPersistent: String(path: "Semi", relativeTo: NSSearchPathDirectory.LibraryDirectory)!,
        .FullyPersistent: String(path: "Fully", relativeTo: NSSearchPathDirectory.LibraryDirectory)!
    ]
    let config = Au3dioConfiguration(persistenceModePaths: paths)
    let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
        GameDataInteractor.self,
        NamePlugin.self,
        GreetingPlugin.self,
        CompositionListPlugin.self
    )
    au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

    do {
        var root = au3dio.dataManager.rootComposition
        print("succeeded: \(root.components)")

        root.updateComponent(CompositionListPlugin.Component.self) {
            $0.scenarios[0].updateComponent(NamePlugin.Component.self) { (inout c: NamePlugin.Component) in
                c.name = "BATMAN"
            }
            return
        }
        au3dio.dataManager.rootComposition = root
        try au3dio.dataManager.saveRootComposition()
        print("updated: \(root.components)")
        try au3dio.dataManager.reloadRootComposition()
        print("reloaded: \(root.components)")
    } catch {
        print("failed \(error)")
    }
}
