//
//  Suit.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Suit: UInt8 {
    case HEART = 1, CLUB, DIAMOND, SPADE

    static let allValues = [HEART, CLUB, DIAMOND, SPADE]

    func describe() -> String {
        switch self {
        case .HEART: return "hearts"
        case .CLUB: return "clubs"
        case .DIAMOND: return "diamonds"
        case .SPADE: return "spades"
        }
    }
};
