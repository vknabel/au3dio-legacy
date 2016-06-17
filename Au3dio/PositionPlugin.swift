//
//  PositionPlugin.swift
//  Au3dio
//
//  Created by Valentin Knabel on 17.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import ConclurerLog
import SwiftyJSON

public final class PositionPlugin: CommonModulePlugin {
    public required init(module: Au3dioModule) {
        super.init(module: module)
        module.componentMap.componentTypes["position"] = PositionComponent.self
    }

    public struct PositionComponent: ComponentType {
        public private(set) var x: Float!
        public private(set) var y: Float!

        public init(composition: CompositionType, key: String) { }

        public mutating func readData(rawData: RawDataType, map: ComponentMap.MapType, mode: PersistenceMode, module: Au3dioModule) throws {
            guard let coords = rawData.arrayObject as? [Float]
                where coords.count == 2
                else { throw FetchError.InvalidFormat("Expected [Float] of length 2, \(rawData) given", Log(type: .Error)) }
            self.x = coords[0]
            self.y = coords[1]
        }

        public func export(mode: PersistenceMode) -> RawDataType? {
            return JSON([x, y])
        }
    }
}
