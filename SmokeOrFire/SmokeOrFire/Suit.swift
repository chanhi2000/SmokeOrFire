//
//  Suit.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Suit {
    case HEART, SPADE, CLUB, DIAMOND, __EXHAUST
    
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
