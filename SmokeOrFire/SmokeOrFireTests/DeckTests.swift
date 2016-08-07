//
//  DeckTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class DeckTests: XCTestCase {
    var deck = Deck()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShuffle() {
        let cards = deck.cards
        deck.shuffle()
        XCTAssertNotEqual(deck.cards, cards)
    }

    func testDraw() {
        let card = deck.draw()
        XCTAssert((card as Any) is Card)
        deck.cards = []
        let none = deck.draw()
        XCTAssertEqual(none, nil)
    }
}
