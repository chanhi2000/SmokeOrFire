//
//  Deck.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import GameplayKit

class Deck {
    var cards: [Card]

    init() {
        cards = [Card]()
        for rank in Rank.allValues {
            for suit in Suit.allValues {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
        shuffle()
    }

    func shuffle() {
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(cards) as! [Card]
    }
    
    func draw() -> Card? {
        if (cards.count > 0) {
            return cards.removeAtIndex(0)
        }
        return nil
    }

    func cardWithName(imageName: String) -> Card {
        var namePieces = imageName.characters.split{ $0 == "_" }.flatMap(String.init)
        // Identify rank.
        var rank: Rank!
        switch (namePieces[0]) {
        case "ace":
            rank = .ACE
            break
        case "jack":
            rank = .JACK
            break
        case "queen":
            rank = .QUEEN
            break
        case "king":
            rank = .KING
            break
        default:
            let rawValue = Int(namePieces[0])!
            rank = Rank(rawValue: rawValue)
            break
        }
        // Identify suit.
        var suit: Suit!
        switch(namePieces[2]) {
        case "clubs":
            suit = .CLUB
            break
        case "diamonds":
            suit = .DIAMOND
            break
        case "hearts":
            suit = .HEART
            break
        case "spades":
            suit = .SPADE
            break
        default:
            print("Unknown string for suit \(namePieces[2])")
            break
        }
        return Card(rank: rank, suit: suit)
    }
}
