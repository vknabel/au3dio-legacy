//
//  SetFix.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

internal func delete<S: RangeReplaceableCollectionType where S.Generator.Element: Equatable>(duplicates seq: S)-> S {
    let s = seq.reduce(S()){
        ac, x in ac.contains(x) ? ac : ac + [x]
    }
    return s
}
