
import RxSwift
import SwiftyJSON
import ConclurerLog

public final class SearchPlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["search"] = Component.self
    }

    public struct Component: ComponentType, GameStateReducer {
        // TODO: Implement

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return nil
        }

        public func connect<S : ObservableType, R : ObserverType where S.E == GameInteractor.Environment.State, R.E == GameInteractor.Environment.StateReducer>(to path: IdPath, receiving state: S, reducing observer: R) -> Disposable? {
            Log.print("Connected to \(path)", type: .Step)
            return nil
        }
    }
}
