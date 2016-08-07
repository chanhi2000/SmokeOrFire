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
    
}

