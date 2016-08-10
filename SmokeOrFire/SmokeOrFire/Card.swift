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
    var imageName: String
    let frontImage: UIImage
    let backImage: UIImage

    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
        self.imageName = "\(rank.describe())_of_\(suit.describe())"
        backImage = UIImage(named: "back")!
        frontImage = UIImage(named: imageName)!
    }

    func describe() -> String {
        return "The \(rank.describe()) of \(suit.describe())"
    }

    func getImageName() -> String { return self.imageName }

    func getRank() -> Rank { return self.rank }

    func getSuit() -> Suit { return self.suit }

    func isRed() -> Bool { return (suit == Suit.HEART || suit == Suit.DIAMOND) }

    func isBlack() -> Bool { return (suit == Suit.CLUB || suit == Suit.SPADE) }
}
