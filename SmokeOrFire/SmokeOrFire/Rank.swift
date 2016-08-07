//
//  Rank.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum Rank: UInt8 {
    case ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, __EXHAUST

    static let allValues = [ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING]

    func describe() -> String {
        switch self {
        case .ACE: return "ace";
        case .JACK: return "jack";
        case .QUEEN: return "queen";
        case .KING: return "king";
        default: return String(self.rawValue)
        }
    }
}
