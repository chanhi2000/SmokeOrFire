//
//  CardTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class CardTests: XCTestCase {
    var card: Card!
    
    override func setUp() {
        super.setUp()
        card = Card(rank: .ACE, suit: .SPADE)
    }

    func testDescribe() {
        XCTAssertEqual(card.describe(), "The ace of spades")
    }

    func testIsRed() {
        XCTAssertFalse(card.isRed())
    }

    func testIsBlack() {
        XCTAssertTrue(card.isBlack())
    }

}
