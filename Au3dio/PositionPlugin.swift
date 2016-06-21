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
        module.componentMap.componentTypes["position"] = Component.self
    }

    public struct Component: ComponentType {
        public private(set) var x: Float!
        public private(set) var y: Float!
        public let idPath: IdPath

        public init(composition: CompositionType, idPath: IdPath) {
            self.idPath = idPath
        }

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

        public func descendant(withComponent component: String) -> ModePersistable? {
            return nil
        }
    }
}
