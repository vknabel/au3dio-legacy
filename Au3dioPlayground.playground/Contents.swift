//: Playground - noun: a place where people can play

/*: TODO
- Add configuration options for `Au3dioModule`: Dictionary<PersistenceMode, String/NSURL>
- Implement `DataManager`
- Implement hook for every implementation of Composition: (String) -> Component.Type
*/
import Foundation
import Au3dio
import SwiftyJSON
import ConclurerLog
import XCPlayground

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
NSURL(string: "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/")
let paths: [PersistenceMode: String] = [
    PersistenceMode.Readonly: "Readonly",
    .Descriptive: "Descriptive",
    .SemiPersistent: "Semi",
    .FullyPersistent: "Fully"
    ].mapDict { ($0.0, "/Users/vknabel/Developer/university/au3dio/Au3dioPlayground.playground/Resources/\($0.1)") }

let config = Configuration(persistenceModePaths: paths)
let au3dio = Au3dioModule(configuration: config, listOfPluginTypes:
    GameDataInteractor.self,
    NamePlugin.self,
    GreetingPlugin.self,
    CompositionListPlugin.self,
    SoundNodePlugin.self,
    PositionPlugin.self
)
au3dio.findPlugin(CompositionListPlugin.self)?.addAliases(["scenarios"])

au3dio.rootCompositionStream.subscribeNext({ comp in
    print(comp)
    }).addDisposableTo(au3dio.disposeBag)

let root = try! au3dio.dataManager.reloadRootComposition()
print("ROOT", root)
