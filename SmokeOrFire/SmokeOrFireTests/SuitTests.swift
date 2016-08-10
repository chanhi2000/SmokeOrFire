//
//  SuitTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/10/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class SuitTests: XCTestCase {

    func testCaseValues() {
        XCTAssertEqual(Suit.HEART.rawValue, 1)
        XCTAssertEqual(Suit.CLUB.rawValue, 2)
        XCTAssertEqual(Suit.DIAMOND.rawValue, 3)
        XCTAssertEqual(Suit.SPADE.rawValue, 4)
    }

    func testAllValues() {
        XCTAssertEqual(Suit.allValues, [Suit.HEART, Suit.CLUB, Suit.DIAMOND, Suit.SPADE])
    }

    func testDescribe() {
        XCTAssertEqual(Suit.HEART.describe(), "hearts")
        XCTAssertEqual(Suit.CLUB.describe(), "clubs")
        XCTAssertEqual(Suit.DIAMOND.describe(), "diamonds")
        XCTAssertEqual(Suit.SPADE.describe(), "spades")
    }
}
