//
//  MonoidalCategory.swift
//  Monad
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

struct MonoidalCategory<T, U, V> {
    let f: T -> U
    let g: U -> V
    
    /*
    * Function Composition
    */
    func h(a:T) -> V {
        return g(f(a))
    }
}