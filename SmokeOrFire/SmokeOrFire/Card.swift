//
//  Card.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

struct Card {
    var rank: Rank
    var suit: Suit
    
    func describe() -> String {
        return "The \(rank.describe()) of \(suit.describe())"
    }
    
    func getRank() -> Rank {  return self.rank;  }
    
    func getSuit() -> Suit {  return self.suit;  }
    
    func isRed() -> Bool {  return (suit == Suit.HEART || suit == Suit.DIAMOND)  }
    
    func isBlack() -> Bool {  return (suit == Suit.CLUB || suit == Suit.SPADE)  }
    
}

