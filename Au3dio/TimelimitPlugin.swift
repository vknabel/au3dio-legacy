
import RxSwift
import SwiftyJSON
import ConclurerLog
import AccessOperator

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
        private var timelimit: NSTimeInterval = 60.0
        public let idPath: IdPath

        public init(composition: CompositionType, idPath: IdPath) {
            self.idPath = idPath
        }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            timelimit = rawData.doubleValue
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return RawDataType(floatLiteral: timelimit)
        }

        public func connect<S : ObservableType, R : ObserverType where S.E == GameInteractor.Environment.State, R.E == GameInteractor.Environment.StateReducer>(to path: IdPath, receiving state: S, reducing observer: R) -> Disposable? {
            return Observable<Int>.interval(1.0, scheduler: ConcurrentMainScheduler.instance)
                .subscribeNext({ i in
                    observer.onNext({ (currentState: GameInteractor.Environment.State) -> GameInteractor.Environment.State? in
                        guard var state: GameInteractor.Environment.State? = currentState
                            else { return nil }
                        state?.updateComponent(BehaviorPlugin.Component.self, update: { behaviorComponent in
                            behaviorComponent.updateComponent(TimelimitPlugin.Component.self, update: { timelimitComponent in
                                let old = timelimitComponent.timelimit
                                timelimitComponent.timelimit = max(timelimitComponent.timelimit - 1, 0)
                                if old == timelimitComponent.timelimit {
                                    state = nil
                                    observer.onCompleted()
                                }
                            })
                        })
                        return state
                    })
                })
        }
    }
}
