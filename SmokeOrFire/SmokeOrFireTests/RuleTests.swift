//
//  RuleTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/10/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class RuleTests: XCTestCase {

    func testTitle() {
        XCTAssertEqual(Rule.COLOR.title(), "Smoke or Fire?")
        XCTAssertEqual(Rule.UP_DOWN.title(), "HIGHER or LOWER?")
        XCTAssertEqual(Rule.IN_OUT.title(), "INSIDE or OUTSIDE?")
        XCTAssertEqual(Rule.SUIT.title(), "What's the SUIT?")
        XCTAssertEqual(Rule.POKER.title(), "Texax Hold'em!")
        XCTAssertEqual(Rule.GIVE.title(), "Give")
        XCTAssertEqual(Rule.TAKE.title(), "Take")
    }

    func testLevel() {
        XCTAssertEqual(Rule.COLOR.level(), 1)
        XCTAssertEqual(Rule.UP_DOWN.level(), 2)
        XCTAssertEqual(Rule.IN_OUT.level(), 3)
        XCTAssertEqual(Rule.SUIT.level(), 4)
        XCTAssertEqual(Rule.POKER.level(), 5)
        XCTAssertEqual(Rule.GIVE.level(), 0)
        XCTAssertEqual(Rule.TAKE.level(), 0)
    }
}
