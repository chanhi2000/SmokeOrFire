//
//  Card.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit
import Foundation

class Card: NSObject {
    // properties
    var value: UInt16
    var suit: Suit
    
    // initialize
    init(value: UInt16, suit: Suit) {
        self.value = value
        self.suit = suit
    }
    
    // methods
    func getValue() -> UInt16 {  return self.value  }
    
    func getSuit() -> Suit {  return self.suit  }
}
