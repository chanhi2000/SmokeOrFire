//
//  RankTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/10/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class RankTests: XCTestCase {

    func testCaseValues() {
        XCTAssertEqual(Rank.ACE.rawValue, 1)
        XCTAssertEqual(Rank.TWO.rawValue, 2)
        XCTAssertEqual(Rank.THREE.rawValue, 3)
        XCTAssertEqual(Rank.FOUR.rawValue, 4)
        XCTAssertEqual(Rank.FIVE.rawValue, 5)
        XCTAssertEqual(Rank.SIX.rawValue, 6)
        XCTAssertEqual(Rank.SEVEN.rawValue, 7)
        XCTAssertEqual(Rank.EIGHT.rawValue, 8)
        XCTAssertEqual(Rank.NINE.rawValue, 9)
        XCTAssertEqual(Rank.TEN.rawValue, 10)
        XCTAssertEqual(Rank.JACK.rawValue, 11)
        XCTAssertEqual(Rank.QUEEN.rawValue, 12)
        XCTAssertEqual(Rank.KING.rawValue, 13)
        XCTAssertEqual(Rank.__EXHAUST.rawValue, 14)
    }

    func testAllValues() {
        XCTAssertEqual(Rank.allValues, [Rank.ACE, Rank.TWO, Rank.THREE,
            Rank.FOUR, Rank.FIVE, Rank.SIX, Rank.SEVEN, Rank.EIGHT, Rank.NINE,
            Rank.TEN, Rank.JACK, Rank.QUEEN, Rank.KING])
    }

    func testDescribe() {
        XCTAssertEqual(Rank.ACE.describe(), "ace")
        XCTAssertEqual(Rank.TWO.describe(), "2")
        XCTAssertEqual(Rank.THREE.describe(), "3")
        XCTAssertEqual(Rank.FOUR.describe(), "4")
        XCTAssertEqual(Rank.FIVE.describe(), "5")
        XCTAssertEqual(Rank.SIX.describe(), "6")
        XCTAssertEqual(Rank.SEVEN.describe(), "7")
        XCTAssertEqual(Rank.EIGHT.describe(), "8")
        XCTAssertEqual(Rank.NINE.describe(), "9")
        XCTAssertEqual(Rank.TEN.describe(), "10")
        XCTAssertEqual(Rank.JACK.describe(), "jack")
        XCTAssertEqual(Rank.QUEEN.describe(), "queen")
        XCTAssertEqual(Rank.KING.describe(), "king")
        XCTAssertEqual(Rank.__EXHAUST.describe(), "14")
    }

    func testSuccessor() {
        XCTAssertEqual(Rank.ACE.successor(), Rank.TWO)
        XCTAssertEqual(Rank.TWO.successor(), Rank.THREE)
        XCTAssertEqual(Rank.THREE.successor(), Rank.FOUR)
        XCTAssertEqual(Rank.FOUR.successor(), Rank.FIVE)
        XCTAssertEqual(Rank.FIVE.successor(), Rank.SIX)
        XCTAssertEqual(Rank.SIX.successor(), Rank.SEVEN)
        XCTAssertEqual(Rank.SEVEN.successor(), Rank.EIGHT)
        XCTAssertEqual(Rank.EIGHT.successor(), Rank.NINE)
        XCTAssertEqual(Rank.NINE.successor(), Rank.TEN)
        XCTAssertEqual(Rank.TEN.successor(), Rank.JACK)
        XCTAssertEqual(Rank.JACK.successor(), Rank.QUEEN)
        XCTAssertEqual(Rank.QUEEN.successor(), Rank.KING)
        XCTAssertEqual(Rank.KING.successor(), Rank.__EXHAUST)
        XCTAssertEqual(Rank.__EXHAUST.successor(), Rank.__EXHAUST)
    }
}
