//
//  Suit.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Suit: UInt8 {
    case HEART = 1, SPADE, CLUB, DIAMOND, __EXHAUST

    static let allValues = [SPADE, HEART, DIAMOND, CLUB]

    func describe() -> String {
        switch self {
        case .SPADE: return "spade";
        case .HEART: return "heart";
        case .DIAMOND: return "diamond";
        case .CLUB: return "club";
        default: return "";
        }
    }
};
