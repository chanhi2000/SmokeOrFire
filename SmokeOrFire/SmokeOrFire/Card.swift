//
//  Card.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//
import UIKit
//import SpriteKit

class Card: NSObject {
    var rank: Rank
    var suit: Suit
    var imageName: String
    let frontTexture: UIImage
    let backTexture: UIImage
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
        self.imageName = "\(rank.describe())_of_\(suit.describe())"
        backTexture = UIImage(named: "back")!
        frontTexture = UIImage(named: imageName)!
    }
    
    func describe() -> String {
        return "The \(rank.describe()) of \(suit.describe())"
    }
    
    func getRank() -> Rank {  return self.rank;  }
    
    func getSuit() -> Suit {  return self.suit;  }
    
    func isRed() -> Bool {  return (suit == Suit.HEART || suit == Suit.DIAMOND)  }
    
    func isBlack() -> Bool {  return (suit == Suit.CLUB || suit == Suit.SPADE)  }
}


//class Card: SKSpriteNode {
//    var rank: Rank
//    var suit: Suit
//    var imageName: String
//    let frontTexture: SKTexture
//    let backTexture: SKTexture
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("NSCoding not supported")
//    }
//    
//    init(rank: Rank, suit: Suit) {
//        self.rank = rank
//        self.suit = suit
//        backTexture = SKTexture(imageNamed: "back")
//        imageName = "\(rank.describe())_of_\(suit.describe())"
//        frontTexture = SKTexture(imageNamed: imageName)
//        
//        super.init(texture: frontTexture, color: .clearColor(), size: frontTexture.size())
//    }
//    
//    func describe() -> String {
//        return "The \(rank.describe()) of \(suit.describe())"
//    }
//    
//    func getRank() -> Rank {  return self.rank;  }
//    
//    func getSuit() -> Suit {  return self.suit;  }
//    
//    func isRed() -> Bool {  return (suit == Suit.HEART || suit == Suit.DIAMOND)  }
//    
//    func isBlack() -> Bool {  return (suit == Suit.CLUB || suit == Suit.SPADE)  }
//
//}

