//
//  Suit.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Suit: UInt8 {
    case HEART = 1, CLUB, DIAMOND, SPADE, __EXHAUST

    static let allValues = [SPADE, HEART, DIAMOND, CLUB]

    func describe() -> String {
        switch self {
        case .SPADE: return "spades";
        case .HEART: return "hearts";
        case .DIAMOND: return "diamonds";
        case .CLUB: return "clubs";
        default: return "";
        }
    }
};
