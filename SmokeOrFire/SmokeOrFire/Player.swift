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

}

enum PlayerChoices: UInt8 {
    // Suit?
    case CLUB = 1, DIAMOND, HEART, SPADE
    // Smoke or fire?
    case RED
    case BLACK
    // Higher or lower?
    case HIGHER
    case LOWER
    // Inside or outside?
    case INSIDE
    case OUTSIDE
    // Misc choice
    case SAME
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
}