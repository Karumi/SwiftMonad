//
//  MaybeMonad.swift
//  Monad
//
//  Created by Davide Mendolia on 26/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

// MaybeMonad alread exist in Swift is called Optional
// When calling function we use the ? operator that is equivalent to the bind or map function
// And ! is implemented using the unwrap method

enum MaybeMonad<T> {
    case None
    case Some(T)
    
    /// Construct a `nil` instance.
    init() {
        self = .None
    }
    
    /// Construct a non-\ `nil` instance that stores `some`.
    init(_ some: T) {
        self = .Some(some)
    }
    
    func map<U>(f: (T) -> U) -> MaybeMonad<U> {
        switch self {
            case let .Some(value):
                return MaybeMonad<U>(f(value))
            case let .None:
                return MaybeMonad<U>()
        }
    }
    
    func unwrap() -> T {
        switch self {
            case let .Some(value):
                return value
            case let .None:
                fatalError("unwrapping a nil value")
        }
    }
    
}

func main3() {
    let i:Int? = 0
    // Using map to optionaly execute the func successor
    let i1:Int = (i?.successor())!
    
    let j:MaybeMonad<Int> = MaybeMonad(0)
    let j1:Int = j.map({$0.successor()}).unwrap()
}