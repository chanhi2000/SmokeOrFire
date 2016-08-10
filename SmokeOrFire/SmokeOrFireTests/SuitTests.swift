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
        XCTAssertEqual(Suit.CLUB.rawValue, 1)
        XCTAssertEqual(Suit.DIAMOND.rawValue,2)
        XCTAssertEqual(Suit.HEART.rawValue, 3)
        XCTAssertEqual(Suit.SPADE.rawValue, 4)
        XCTAssertEqual(Suit.__EXHAUST.rawValue, 5)
    }

    func testAllValues() {
        XCTAssertEqual(Suit.allValues, [Suit.CLUB, Suit.DIAMOND, Suit.HEART, Suit.SPADE])
    }

    func testDescribe() {
        XCTAssertEqual(Suit.CLUB.describe(), "clubs")
        XCTAssertEqual(Suit.DIAMOND.describe(), "diamonds")
        XCTAssertEqual(Suit.HEART.describe(), "hearts")
        XCTAssertEqual(Suit.SPADE.describe(), "spades")
        XCTAssertEqual(Suit.__EXHAUST.describe(), "")
    }

    func testSuccessor() {
        XCTAssertEqual(Suit.CLUB.successor(), Suit.DIAMOND)
        XCTAssertEqual(Suit.DIAMOND.successor(), Suit.HEART)
        XCTAssertEqual(Suit.HEART.successor(), Suit.SPADE)
        XCTAssertEqual(Suit.SPADE.successor(), Suit.__EXHAUST)
        XCTAssertEqual(Suit.__EXHAUST.successor(), Suit.__EXHAUST)
    }
}
