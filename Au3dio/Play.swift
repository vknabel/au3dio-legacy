
import Au3dio
import SwiftyJSON
import ConclurerLog
import RxSwift

func play() {
    // log types will be printed colored
    Log.xcodeColorsEnabled = true

    // Declares all paths for valid persistence modes.
    let paths: [PersistenceMode: String] = [
        PersistenceMode.Readonly: NSBundle.mainBundle().resourcePath!.nsstring.stringByAppendingPathComponent("Readonly"),
        .Descriptive: String(path: "Descriptive", relativeTo: NSSearchPathDirectory.DocumentDirectory)!,
        .SemiPersistent: String(path: "Semi", relativeTo: NSSearchPathDirectory.LibraryDirectory)!,
        .FullyPersistent: String(path: "Fully", relativeTo: NSSearchPathDirectory.LibraryDirectory)!
    ]
    let config = Configuration(persistenceModePaths: paths)
    // Add all uses plugins to Au3dio
    let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
        GameDataInteractor.self,
        NamePlugin.self,
        GreetingPlugin.self,
        CompositionListPlugin.self
    )
    // Sets up CompositionListPlugin
    au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

    do {
        // value semantic
        au3dio.rootCompositionSubject.asObservable().subscribe(onNext: { root in
                Log.print("[UPDATED] \(root)", type: .Step)
            },
            onError: { error in
                Log.print("[FAILURE] \(error)")
            },
            onCompleted: { 
                Log.print("[COMPLETED]")
            }).addDisposableTo(au3dio.disposeBag)
        var root = au3dio.dataManager.rootComposition
        Log.print("succeeded: \(root.components)")

        // updates local root composition
        root.updateComponent(CompositionListPlugin.Component.self) {
            $0.scenarios[0].updateComponent(NamePlugin.Component.self) { (inout c: NamePlugin.Component) in
                c.name = "BATMAN"
            }
            return
        }
        // set as global root and save
        au3dio.dataManager.rootComposition = root
        try au3dio.dataManager.saveRootComposition()
        Log.print("updated: \(au3dio.dataManager.rootComposition)", type: .Success)

        // reloads root composition
        _ = try au3dio.dataManager.reloadRootComposition()
        Log.print("reloaded: \(au3dio.dataManager.rootComposition)", type: .Success)

        // delete 'save game' data
        try au3dio.dataManager.invalidateModes(modes: [.FullyPersistent])
        Log.print("invalidated: \(au3dio.dataManager.rootComposition)", type: .Success)

        // usually done automatically
        _ = try au3dio.dataManager.reloadRootComposition()
        Log.print("reloaded: \(au3dio.dataManager.rootComposition)", type: .Success)
    } catch {
        Log.print("failed \(error)", type: .Error)
    }
}
