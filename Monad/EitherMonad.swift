//
//  EitherMonad.swift
//  Monad
//
//  Created by Davide Mendolia on 28/05/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

enum EitherMonad<T, V> {
    case Left(T)
    case Right(V)

    
    func match<U, W>(left leftMatch: T -> U, right rightMatch: V -> W) -> EitherMonad<U, W> {
        switch self {
        case let .Left(value1):
            return .Left(leftMatch(value1))
        case let .Right(value2):
            return .Right(rightMatch(value2))
        }
    }
}