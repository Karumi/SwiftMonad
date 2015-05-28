//
//  MonadTests.swift
//  MonadTests
//
//  Created by Davide Mendolia on 25/5/15.
//  Copyright (c) 2015 Karumi. All rights reserved.
//

import UIKit
import XCTest
import Monad


class MonadTests: XCTestCase {
        
    func testMonoid() {
        let m = Monoid(unit: {$0 * 1})
        let f1 = {$0 + 1}
        // Identity
        XCTAssertEqual(m.compose(f:m.unit, g:f1)(47), m.compose(f:f1, g:m.unit)(47))

        // Associativity
        XCTAssertEqual(
            m.compose(f: m.compose(f: {$0 * 20}, g: {$0 / 5}), g: {$0 + 75})(47),
            m.compose(f: {$0 * 20}, g: m.compose(f: {$0 / 5}, g: {$0 + 75}))(47)
        )
    }

    func testClockMonoid() {
        // In a wall clock there is only 12 hour units
        let clock = Monoid(unit: {$0 % 12})
        XCTAssertEqual(2, clock.unit(clock.compose(f: {$0 + 1}, g: {$0 + 5})(8)))
    }
    
    func testMonoidalCategory() {
        let m = MonoidalCategory<Int, String, [Character]>()
        XCTAssertEqual(["4", "7"], m.compose(f: {"\($0)"}, g: {Array($0)})(47))
    }
    
    func testIdentityMonad() {
        // Associativity
        let result1 = (IdentityMonad(value: 1).bind{$0 + 4}.bind{$0 * 2}).bind{$0 / 5}
        
        let result2 = (IdentityMonad(value: 1).bind{$0 + 4}).bind{$0 * 2}.bind{$0 / 5}

        XCTAssertEqual(result1.value, result2.value)
        
        IdentityMonad(value: "Hello World").bind(println)
    }
    
    func testMaybeMonad() {
        let i:Int? = 0
        // Using map to optionaly execute the func successor
        let i1:Int = (i?.successor())!
        
        let j:MaybeMonad<Int> = MaybeMonad(0)
        let j1:Int = j.map({$0.successor()}).unwrap()
    }
}
