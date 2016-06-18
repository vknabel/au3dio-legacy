//
//  GameEnvironment.swift
//  Au3dio
//
//  Created by Valentin Knabel on 18.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift

public extension GameInteractor {
    public final class Environment {
        public enum Error: ErrorType {
            case MissingLevelComponent
        }

        // TODO: Revalidate typealiases
        public typealias LevelComposition = CompositionType
        public typealias GameState = CompositionType

        private let stateSubject: PublishSubject<GameState> = PublishSubject()
        private let bag: DisposeBag = DisposeBag()

        internal init(level: LevelComposition) throws {
            // TODO: Implement all Component Plugins
            guard let entities = level.findComponent(EntityListPlugin.Component.self),
                let behaviors = level.findComponent(BehaviorListPlugin.Component.self)
                else { throw Error.MissingLevelComponent }

            stateSubject.takeLast(1).subscribeNext(complete).addDisposableTo(bag)

            // TODO: Also add global behaviors to Au3dioModule
            behaviors.children.castReduce(GameBehavior.self).forEach { behavior in
                behavior.connect(to: stateSubject).addDisposableTo(bag)
            }
        }

        internal func complete(final state: GameState) {
            // TODO: Discuss wether this function is really needed.
        }
    }
}
