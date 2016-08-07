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
    var hand: [Card] = [];
    var choice: PlayerChoices? = nil
    
    init(number: Int) {
        self.number = number
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
    case HEART = 1, CLUB, DIAMOND, SPADE
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
