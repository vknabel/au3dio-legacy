//
//  TraversePlugin.swift
//  Au3dio
//
//  Created by Valentin Knabel on 21.06.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public protocol ComponentAccessType {
    associatedtype IndexType: Equatable
    associatedtype ValueType
    subscript(index: IndexType) -> ValueType? { get set }
}

public extension CompositionType {
    public typealias IndexType = String
    public typealias ValueType = ComponentType

    public subscript(index: IndexType) -> ValueType? {
        get {
            return self.components[index]
        }
        set {
            if let newValue = newValue {
                self.components[index] = newValue
            } else {
                self.components.removeValueForKey(index)
            }
        }
    }
}

public extension ListComponentType {
    public typealias IndexType = Int
    public typealias ValueType = CompositionType

    public subscript(index: Int) -> CompositionType? {
        get {
            guard index < children.count else { return nil }
            return self.children[index]
        }
        set {
            if let newValue = newValue {
                children[index] = newValue
            } else {
                children.removeAtIndex(index)
            }
        }
    }
}

public extension ComposedComponentType {
    public typealias IndexType = String
    public typealias ValueType = ComponentType

    public subscript(index: IndexType) -> ValueType? {
        get {
            return self.components[index]
        }
        set {
            if let newValue = newValue {
                self.components[index] = newValue
            } else {
                self.components.removeValueForKey(index)
            }
        }
    }
}

