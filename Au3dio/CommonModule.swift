//
//  CommonModule.swift
//  Au3dio
//
//  Created by Valentin Knabel on 29.05.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public class CommonModulePlugin: Au3dioModulePlugin {
    public let module: Au3dioModule

    public required init(module: Au3dioModule) {
        self.module = module
    }
}