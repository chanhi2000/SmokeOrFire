//
//  Suit.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Suit: Int {
    case CLUB = 1, DIAMOND, HEART, SPADE, __EXHAUST

    static let allValues = [CLUB, DIAMOND, HEART, SPADE]

    func describe() -> String {
        switch self {
        case .CLUB: return "clubs"
        case .DIAMOND: return "diamonds"
        case .HEART: return "hearts"
        case .SPADE: return "spades"
        case .__EXHAUST: return ""
        }
    }
};
