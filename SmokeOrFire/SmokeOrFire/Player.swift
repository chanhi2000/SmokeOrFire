//
//  Player.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class Player: NSObject {
    var number: Int
    var hand: [Card]
    var choice: PlayerChoices!
    
    init(number: Int) {
        self.number = number
        self.hand = [Card]()
    }

    func getNumber() -> Int {
        return self.number
    }

    func addCard(card: Card) {
        hand.append(card)
    }

    func setChoice(choice: PlayerChoices) {
        self.choice = choice
    }

    func hasCard(card: Card) -> Bool {
        for handCard in hand {
            if handCard.rank == card.rank {
                return true
            }
        }
        return false
    }

    func displayHand() -> String {
        var ans = ""
        for (index, card) in hand.enumerate() {
            let cardRank = card.rank.describe()
            let cardSuit = card.suit.describe()
            ans += "\(cardRank[0])\(cardSuit[0])"
            ans += (index < hand.count - 1) ? ", " : ""
        }
        return ans
    }
}

enum ChoicesText: String {
    case HEART = "HEART"
    case CLUB = "CLUB"
    case DIAMOND = "DIAMOND"
    case SPADE = "SPADE"
    case RED = "FIRE"
    case BLACK = "SMOKE"
    case HIGHER = "HIGHER"
    case LOWER = "LOWER"
    case INSIDE = "INSIDE"
    case OUTSIDE = "OUTSIDE"
    case SAME = "SAME"
    case PYRAMID = "?"
}