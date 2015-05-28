//
//  Monoid.swift
//  Monad
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation


// Monoid
/*
 * Reference wikipedia: http://en.wikipedia.org/wiki/Monoid
 * Associativity
 * For all a, b and c in S, the equation (f • g) • h = f • (g • h) holds.
 *
 * Identity element
 * There exists an element e in S such that for every element a in S, the equations e • a = a • e = a hold
 */
struct Monoid<T> {
    let unit: T -> T // Or Idenity
    
    /*
    * Function Composition or •
    */
    func compose(#f: T -> T, g: T -> T) -> T -> T {
        return { g(f($0)) }
    }
}

