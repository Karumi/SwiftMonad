//
//  Monoid.swift
//  Monad
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation


// Monoid
struct Monoid<T> {
    let f: T -> T
    let g: T -> T
    
    /*
    * Function Composition
    */
    func compose(a:T) -> T {
        return g(f(a))
    }
}

/*
 * Functions under composition is a Monoid
 */
struct TwoParamFuncMonoid<T> {
    let unit: T // Or Idenity
    //Set of things
    let f: (T, T) -> T
    let g: (T, T) -> T
    
    /*
    * Rule for combining the things
    * Meta rule:
    * 1) associativity of func
    * 2) has unit
    */
    func compose(#x:T, y:T) -> T {
        return g(f(x,y), unit)
    }
}

func main() {
    let a = 1
    let m = Monoid(f: {$0 + 1}, g: {$0 * 3})
    m.compose(a)
    
    let clock = TwoParamFuncMonoid(unit: 12, f: {$0 + $1}, g: {$0 % $1})
    clock.compose(x: 10, y: 5) //expected 3
}