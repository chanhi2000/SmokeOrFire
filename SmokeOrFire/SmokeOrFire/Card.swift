//
//  Card.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class Card: NSObject {
    var rank: Rank
    var suit: Suit
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    func describe() -> String {
        return "The \(rank.describe()) of \(suit.describe())"
    }
    
    func getRank() -> Rank {  return self.rank;  }
    
    func getSuit() -> Suit {  return self.suit;  }
    
    func isRed() -> Bool {  return (suit == Suit.HEART || suit == Suit.DIAMOND)  }
    
    func isBlack() -> Bool {  return (suit == Suit.CLUB || suit == Suit.SPADE)  }
    
}

