//
//  List.swift
//  Monad
//
//  Created by Davide Mendolia on 24/07/15.
//  Copyright © 2015 Karumi. All rights reserved.
//

import Foundation

enum List<T> {
    case Empty
    indirect case Cons(head: T, tail: List<T>)
    
    init() {
        self = .Empty
    }
    
    init(head: T, tail: List<T>) {
        self = Cons(head: head, tail: tail)
    }
    
    func reduce(list: List<T>, initial: T, combine: (T, T) -> T) -> T {
        switch list {
        case .Empty: return initial
        case let .Cons(head, tail):
            return combine(head, reduce(tail, initial: initial, combine: combine))
        }
    }
}