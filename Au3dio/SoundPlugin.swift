//
//  SoundPlugin.swift
//  Au3dio
//
//  Created by Valentin Knabel on 17.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import SwiftyJSON
import ConclurerLog

private extension String {
    static var soundSource: String { return "source" }
    static var soundPosition: String { return "position" }
    static var soundVolume: String { return "volume" }
    static var soundLoops: String { return "loops" }
    static var soundDelay: String { return "delay" }
}

public final class SoundNodePlugin: CommonModulePlugin {
    public required init(module: Au3dioModule) {
        super.init(module: module)
        module.componentMap.componentTypes["sound"] = SoundComponent.self
    }

    public struct SoundComponent: ComponentType {
        public private(set) var source: String!
        public private(set) var position: Float?
        public private(set) var volume: Float?
        public private(set) var loops: Int?
        public private(set) var delay: NSTimeInterval?

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            guard let dict: [String : JSON] = rawData.dictionary,
                let source = dict[.soundSource]?.string
                else { throw FetchError.InvalidFormat("Value of type [String: JSON] containing [\"\(.soundSource)\"]: String \(rawData.debugDescription)", Log(type: .Error)) }
            self.source = source
            self.position = dict[.soundPosition]?.float
            self.volume = dict[.soundVolume]?.float
            self.loops = dict[.soundLoops]?.int
            self.delay = dict[.soundDelay]?.double
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            assert(source != nil, "Tried to export SoundComponent without any source (\(.soundSource)) given")
            return JSON([
                String.soundSource: source,
                .soundPosition: position ?? NSNull(),
                .soundVolume: volume ?? NSNull(),
                .soundLoops: loops ?? NSNull(),
                .soundDelay: delay ?? NSNull()
            ])
        }
    }
}
