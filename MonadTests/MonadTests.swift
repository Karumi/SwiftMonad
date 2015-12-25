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
        let m = MonoidalCategory()
        XCTAssertEqual(["47"], m.compose(f: {"\($0)"}, g: { [$0] })(47))
    }
    
    func testIdentityMonad() {
        // Associativity
        let result1 = (IdentityMonad(value: 1).bind{$0 + 4}.bind{$0 * 2}).bind{$0 / 5}
        
        let result2 = (IdentityMonad(value: 1).bind{$0 + 4}).bind{$0 * 2}.bind{$0 / 5}

        XCTAssertEqual(result1.value, result2.value)
        
        IdentityMonad(value: "Hello World").bind({$0.stringByReplacingOccurrencesOfString("World", withString: "Everybody!")})
    }
    
    func testMaybeMonad() {
        let i:Int? = 0
        // Using map to optionaly execute the func successor
        let i1:Int = (i?.successor())!
        XCTAssertEqual(1, i1)
        
        let j:MaybeMonad<Int> = MaybeMonad(0)
        let j1:Int = j.map({$0.successor()}).unwrap()
        XCTAssertEqual(1, j1)
    }
    
    private func nserrorToRight<T>(value: T?) -> EitherMonad<T, NSError> {
        if let v = value {
            return EitherMonad.Left(v)
        } else {
            return EitherMonad.Right(NSError(domain: "com.karumi.MonadTests", code: 0, userInfo: nil))
        }
    }
    
    func testEitherMonad() {
        var s:String? = "hello"
        
        nserrorToRight(s).match(
            left: { (value:String) -> String in
                print(value)
                return value
            },
            right: { NSLog($0.localizedDescription) }
        )
        // prints "HELLO"

        s = nil

        nserrorToRight(s).match(
            left: { print($0) },
            right: { (error:NSError) -> NSError in
                NSLog(error.localizedDescription)
                return error
            }
        )
        // Log in the Console NSError
    }
}
