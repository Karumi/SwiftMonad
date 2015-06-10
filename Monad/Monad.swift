//
//  Monad.swift
//  Monad
//
//  Created by Davide Mendolia on 10/06/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

struct Monad<W> {
    let value:W
    
    /*
    * Function Composition or •
    */
    static func compose<T, U, V>(f: T -> Monad<U>, g: U -> Monad<V>) -> T -> Monad<V> {
        return { g(f($0).value) }
    }
    
    /**
    * The first lamba will always be an empty lamba the return the input value
    * So let's remove it.
    */
    static func compose<U, V>(m: Monad<U>, g: U -> Monad<V>) -> Monad<V> {
        return g(m.value)
    }
    
    /**
    * Let's rewrite in OOP fashion, this will allow us to do chaining of function.
    */
    func compose<V>(g: W -> Monad<V>) -> Monad<V> {
        return g(self.value)
    }
    
    /*
    * I can do better and move the responsability to initialize the monad inside the composition function
    * And only have the effect in the lambda.
    */
    func compose<V>(g: W -> V) -> Monad<V> {
        return Monad<V>(value: g(self.value))
    }
}