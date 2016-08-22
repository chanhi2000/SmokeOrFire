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
    var player: Player!

    override func setUp() {
        super.setUp()
        player = Player(number: 1)
    }

    func testGetNumber() {
        XCTAssertEqual(player.getNumber(), 1)
    }

    func testAddCard() {
        let card = Card(rank: .KING, suit: .HEART)
        player.addCard(card)
        XCTAssertEqual(player.hand.count, 1)
        XCTAssertEqual(player.hand[0].rank, card.rank)
        XCTAssertEqual(player.hand[0].suit, card.suit)
    }

    func testSetChoice() {
        XCTAssertEqual(player.choice, nil)
        player.setChoice(.HEART)
        XCTAssertEqual(player.choice, PlayerChoices.HEART)
    }

    func testHasCard() {
        let card = Card(rank: .ACE, suit: .SPADE)
        player.addCard(card)
        XCTAssertTrue(player.hasCard(card))
        XCTAssertFalse(player.hasCard(Card(rank: .TWO, suit: .HEART)))
    }

    func testHasCardWith() {
        let card = Card(rank: .QUEEN, suit: .DIAMOND)
        player.addCard(card)
        XCTAssertTrue(player.hasCardWith("queen_of_diamonds"))
        XCTAssertFalse(player.hasCardWith("queen_of_hearts"))
    }

    func testTotalOf() {
        let card = Card(rank: .THREE, suit: .CLUB)
        player.addCard(card)
        XCTAssertEqual(player.totalOf(card), 1)
        XCTAssertEqual(player.totalOf(Card(rank: .FOUR, suit: .CLUB)), 0)
    }

    func testPlayerChoices() {
        XCTAssertEqual(PlayerChoices.CLUB.rawValue, 1)
        XCTAssertEqual(PlayerChoices.DIAMOND.rawValue, 2)
        XCTAssertEqual(PlayerChoices.HEART.rawValue, 3)
        XCTAssertEqual(PlayerChoices.SPADE.rawValue, 4)
    }

    func testChoicesText() {
        XCTAssertEqual(ChoicesText.HEART.rawValue, "HEART")
        XCTAssertEqual(ChoicesText.CLUB.rawValue, "CLUB")
        XCTAssertEqual(ChoicesText.DIAMOND.rawValue, "DIAMOND")
        XCTAssertEqual(ChoicesText.SPADE.rawValue, "SPADE")
        XCTAssertEqual(ChoicesText.RED.rawValue, "FIRE")
        XCTAssertEqual(ChoicesText.BLACK.rawValue, "SMOKE")
        XCTAssertEqual(ChoicesText.HIGHER.rawValue, "HIGHER")
        XCTAssertEqual(ChoicesText.LOWER.rawValue, "LOWER")
        XCTAssertEqual(ChoicesText.INSIDE.rawValue, "INSIDE")
        XCTAssertEqual(ChoicesText.OUTSIDE.rawValue, "OUTSIDE")
        XCTAssertEqual(ChoicesText.SAME.rawValue, "SAME")
    }
}
