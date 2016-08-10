//
//  RoundTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class RoundTests: XCTestCase {
    var player: Player!
    var round: Round!

    override func setUp() {
        super.setUp()
        player = Player(number: 1)
        round = Round(card: Card(rank: .ACE, suit: .DIAMOND), rule: .COLOR)
    }

    func testCard() {
        XCTAssertEqual(round.card.rank.rawValue, Rank.ACE.rawValue)
        XCTAssertEqual(round.card.suit.rawValue, Suit.DIAMOND.rawValue)
    }

    func testRule() {
        XCTAssertEqual(round.rule, Rule.COLOR)
    }

    func testIsDrinking() {

        // Smoke or fire?
        player.setChoice(.RED)
        XCTAssertFalse(round.isDrinking(player))

        round.card = Card(rank: .ACE, suit: .SPADE)
        player.setChoice(.BLACK)
        XCTAssertFalse(round.isDrinking(player))

        player.setChoice(.SAME)
        XCTAssertTrue(round.isDrinking(player))

        // Higher or lower?
        player.hand = [Card(rank: .SIX, suit: .HEART)]
        player.setChoice(.HIGHER)
        round = Round(card: Card(rank: .SEVEN, suit: .HEART), rule: .UP_DOWN)
        XCTAssertFalse(round.isDrinking(player))

        round.card = Card(rank: .TWO, suit: .DIAMOND)
        XCTAssertTrue(round.isDrinking(player))

        player.setChoice(.LOWER)
        round.card = Card(rank: .FIVE, suit: .HEART)
        XCTAssertFalse(round.isDrinking(player))

        round.card = Card(rank: .JACK, suit: .SPADE)
        XCTAssertTrue(round.isDrinking(player))

        player.setChoice(.SAME)
        round.card = Card(rank: .SIX, suit: .SPADE)
        XCTAssertFalse(round.isDrinking(player))

        round.card = Card(rank: .QUEEN, suit: .DIAMOND)
        XCTAssertTrue(round.isDrinking(player))
        
        // INSIDE or OUTSIDE?
        player.hand = [Card(rank: .TWO, suit: .CLUB), Card(rank: .QUEEN, suit: .DIAMOND)]
        player.setChoice(.INSIDE)
        round = Round(card: Card(rank: .JACK, suit: .HEART), rule: .IN_OUT)
        XCTAssertFalse(round.isDrinking(player))
        
        round.card = Card(rank: .ACE, suit:.DIAMOND)
        XCTAssertTrue(round.isDrinking(player))
        
        player.setChoice(.OUTSIDE)
        round.card = Card(rank: .THREE, suit:.DIAMOND)
        XCTAssertTrue(round.isDrinking(player))
        
        round.card = Card(rank: .TWO, suit: .SPADE)
        XCTAssertTrue(round.isDrinking(player))
        
        player.setChoice(.SAME)
        XCTAssertFalse(round.isDrinking(player))
        
        // SUIT?
        player.setChoice(.DIAMOND)
        round = Round(card: Card(rank: .TWO, suit: .DIAMOND), rule: .SUIT)
        XCTAssertFalse(round.isDrinking(player))
        
        player.setChoice(.CLUB)
        XCTAssertTrue(round.isDrinking(player))
    }

}
