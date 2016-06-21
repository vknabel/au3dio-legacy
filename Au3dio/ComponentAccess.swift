//
//  TraversePlugin.swift
//  Au3dio
//
//  Created by Valentin Knabel on 21.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public protocol SubscriptCompositionType {
    subscript(index: Int) -> CompositionType? { get set }
}
public protocol FindComponentType {
    func findComponent<T: ComponentType>(type: T.Type) -> T?
    mutating func setComponent<T: ComponentType>(key: String, component: T)
    mutating func updateComponent<T: ComponentType>(type: T.Type, update: (inout T) -> ())
}
