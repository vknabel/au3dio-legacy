
import Au3dio
import SwiftyJSON
import ConclurerLog

func play() {
    Log.xcodeColorsEnabled = true

    let paths: [PersistenceMode: String] = [
        PersistenceMode.Readonly: NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent("Readonly"),
        .Descriptive: String(path: "Descriptive", relativeTo: NSSearchPathDirectory.DocumentDirectory)!,
        .SemiPersistent: String(path: "Semi", relativeTo: NSSearchPathDirectory.LibraryDirectory)!,
        .FullyPersistent: String(path: "Fully", relativeTo: NSSearchPathDirectory.LibraryDirectory)!
    ]
    let config = Configuration(persistenceModePaths: paths)
    let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
        GameDataInteractor.self,
        NamePlugin.self,
        GreetingPlugin.self,
        CompositionListPlugin.self
    )
    au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

    do {
        var root = au3dio.dataManager.rootComposition
        Log.print("succeeded: \(root.components)")

        root.updateComponent(CompositionListPlugin.Component.self) {
            $0.scenarios[0].updateComponent(NamePlugin.Component.self) { (inout c: NamePlugin.Component) in
                c.name = "BATMAN"
            }
            return
        }
        au3dio.dataManager.rootComposition = root
        try au3dio.dataManager.saveRootComposition()
        Log.print("updated: \(au3dio.dataManager.rootComposition)", type: .Success)
        try au3dio.dataManager.reloadRootComposition()
        Log.print("reloaded: \(au3dio.dataManager.rootComposition)", type: .Success)

        try au3dio.dataManager.invalidateModes(modes: [.FullyPersistent, .Descriptive])
        Log.print("invalidated: \(au3dio.dataManager.rootComposition)", type: .Success)
        try au3dio.dataManager.reloadRootComposition()
        Log.print("reloaded: \(au3dio.dataManager.rootComposition)", type: .Success)
    } catch {
        Log.print("failed \(error)", type: .Error)
    }
}
