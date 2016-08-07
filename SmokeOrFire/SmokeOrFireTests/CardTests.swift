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
    let card = Card(rank: .ACE, suit: .SPADE)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRank() {
        XCTAssertEqual(card.rank, Rank.ACE)
    }
    
    func testSuit() {
        XCTAssertEqual(card.suit, Suit.SPADE)
    }
    
    
}
