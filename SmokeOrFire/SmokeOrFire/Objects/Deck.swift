//
//  Deck.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit
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
}