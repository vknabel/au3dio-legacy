//
//  GameEnvironment.swift
//  Au3dio
//
//  Created by Valentin Knabel on 18.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import ConclurerLog

public extension GameInteractor {
    public final class Environment {
        public enum Error: ErrorType {
            case MissingLevelComponent
        }

        // TODO: Revalidate typealiases
        public typealias LevelComposition = CompositionType
        public typealias State = CompositionType
        public typealias StateReducer = (State) -> State?

        private let stateReducerSubject: PublishSubject<StateReducer> = PublishSubject()
        private let stateSubject: BehaviorSubject<State>
        public let bag: DisposeBag = DisposeBag()

        public var stateObservable: Observable<State> {
            return self.stateSubject.asObservable()
        }
        public var stateObserver: AnyObserver<State> {
            return self.stateSubject.asObserver()
        }

        internal init(level: LevelComposition) throws {
            guard let entities = level.findComponent(EntityListPlugin.Component.self),
                let levelBehavior = level.findComponent(BehaviorPlugin.Component.self)
                else { throw Error.MissingLevelComponent }
            stateSubject = BehaviorSubject(value: level)

            var behaviors = entities.children.map { entity in
                entity.findComponent(BehaviorPlugin.Component.self)
                }.castReduce(BehaviorPlugin.Component.self)
            behaviors.append(levelBehavior)

            behaviors.forEach { behavior in
                behavior.components.flatMapCastDict(GameStateReducer.self).forEach { _, stateReducer in
                    stateReducer.connect(
                        to: behavior.idPath,
                        receiving: stateSubject.asObservable(),
                        reducing: stateReducerSubject.asObserver()
                    )?.addDisposableTo(bag)
                }
            }

            stateReducerSubject.flatMap({ (reducer: StateReducer) -> Observable<State> in
                guard let result = reducer(try self.stateSubject.value())
                    else { return Observable.empty() }
                return Observable.just(result)
            }).subscribe(stateSubject).addDisposableTo(bag)
            stateSubject.takeLast(1).subscribeNext(complete).addDisposableTo(bag)
        }

        internal func complete(final state: State) {
            // TODO: Discuss wether this function is really needed.
            Log.print("Completed with \(state)", type: .Success)
        }
    }
}
