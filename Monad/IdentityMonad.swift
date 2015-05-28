//
//  IdentityMonad.swift
//  Monad
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

struct IdentityMonad<T> {
    let value: T
    
    // equivalent >>= operator un haskell
    func bind<U>(f:T -> U) -> IdentityMonad<U> {
        return IdentityMonad<U>(value:f(value))
    }

}