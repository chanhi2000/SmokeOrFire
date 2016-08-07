//
//  PlayerTests.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class PlayerTests: XCTestCase {
    let player = Player()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddCard() {
        let card = Card(rank: .KING, suit: .HEART)
        player.addCard(card)
        XCTAssertEqual(player.hand.count, 1)
        XCTAssertEqual(player.hand[0].rank, card.rank)
        XCTAssertEqual(player.hand[0].suit, card.suit)
    }
    
}
