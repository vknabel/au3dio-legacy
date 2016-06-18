//
//  CommonPlugins.swift
//  Au3dio
//
//  Created by Valentin Knabel on 17.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public extension Au3dioModule {
    public static let commonPlugins: [Au3dioModulePlugin.Type] = [
        NamePlugin.self,
        ScenarioListPlugin.self,
        BehaviorListPlugin.self,
        EntityListPlugin.self,
        PositionPlugin.self,
        SoundPlugin.self
    ]
    public private(set) static var debugPlugins: [Au3dioModulePlugin.Type] = {
        var plugins: [Au3dioModulePlugin.Type] = [GreetingPlugin.self]
        plugins.appendContentsOf(Au3dioModule.commonPlugins)
        return plugins
    }()
}
