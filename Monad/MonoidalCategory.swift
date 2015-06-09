//
//  MonoidalCategory.swift
//  Monad
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import Foundation

struct MonoidalCategory {
    /*
    * Function Composition or •
    */
    func compose<T, U, V>(f f: T -> U, g: U -> V) -> T -> V {
        return { g(f($0)) }
    }
}