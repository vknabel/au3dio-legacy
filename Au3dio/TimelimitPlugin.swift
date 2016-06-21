
import RxSwift
import SwiftyJSON
import ConclurerLog

private extension NSTimeInterval {
    var seconds: NSTimeInterval {
        return self
    }
    var minutes: NSTimeInterval {
        return self * 60
    }
}

public final class TimelimitPlugin: Au3dioModulePlugin {
    public var module: Au3dioModule
    public init(module: Au3dioModule) {
        self.module = module

        module.componentMap.componentTypes["timelimit"] = Component.self
    }

    public struct Component: ComponentType, GameStateReducer {
        private var timeout: NSTimeInterval = 60.0
        public let idPath: IdPath

        public init(composition: CompositionType, idPath: IdPath) {
            self.idPath = idPath
        }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            timeout = rawData.doubleValue
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return RawDataType(floatLiteral: timeout)
        }

        public func connect<S : ObservableType, R : ObserverType where S.E == GameInteractor.Environment.State, R.E == GameInteractor.Environment.StateReducer>(to path: IdPath, receiving state: S, reducing observer: R) -> Disposable? {
            Log.print("Connected to \(path)", type: .Step)
            return Observable<Int>.interval(1.0, scheduler: ConcurrentMainScheduler.instance)
                .withLatestFrom(state)
                .map({ state in
                    return state
                })
                .subscribe()
        }
    }
}
