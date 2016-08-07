//
//  Card.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

struct Card {
    // properties
    var rank: Rank
    var suit: Suit
    
    // methods
    func getRank() -> Rank {  return self.rank  }
    func getSuit() -> Suit {  return self.suit  }
}