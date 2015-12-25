//
//  IOMonad.swift
//  Monad
//
//  Created by Davide Mendolia on 13/06/15.
//  Copyright © 2015 Karumi. All rights reserved.
//

import Foundation

enum IOMonad<T> {
    case Result(T)
    case NoResult
}

func printLine<U>(value: U) -> IOMonad<String> {
    print(value)
    return .NoResult
}

func getLine() -> IOMonad<String> {
    return .Result(readLine()!)
}

func >>= <U, V>(left: IOMonad<U>, right: U -> IOMonad<V>) -> IOMonad<V> {
    switch left {
    case let .Result(value):
        return right(value)
    case .NoResult:
        return .NoResult
    }
}

func >> <U, V>(left: IOMonad<U>, right: IOMonad<V>) -> IOMonad<V> {
    return right
}

func main() -> IOMonad<String> {
    return printLine("What is your name?") >>
    getLine() >>= {
        name in
        printLine("Nice to meet you, \(name)!")
    }
}