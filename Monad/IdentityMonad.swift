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

func main2() {
    let m1:IdentityMonad = IdentityMonad(value: 1).bind({$0 + 4}).bind({$0 * 2})
    let result1 = m1.bind({$0 / 5}) // 10
    let m2 = IdentityMonad(value: 1).bind({$0 + 4})
    let result2 = m2.bind({$0 * 2}).bind({$0 / 5}) // 10
    let assoc = result1.value == result2.value
    
    IdentityMonad(value: "Hello World").bind(println)
}