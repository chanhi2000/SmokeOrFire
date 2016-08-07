//
//  Suit+successor.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

extension Suit: ForwardIndexType {
    func successor() -> Suit {
        switch self {
        case .CLUB: return .DIAMOND
        case .DIAMOND: return .HEART
        case .HEART: return .SPADE
        case .SPADE: return .__EXHAUST
        case .__EXHAUST: return .__EXHAUST
        }
    }
}
