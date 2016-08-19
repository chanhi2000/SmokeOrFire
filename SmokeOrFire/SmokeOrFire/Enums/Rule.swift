//
//  Rule.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

enum Rule {
    case COLOR
    case UP_DOWN
    case IN_OUT
    case SUIT
    case POKER
    case GIVE
    case TAKE

    func title() -> String {
        switch self {
        case .COLOR:   return "Smoke or Fire?"
        case .UP_DOWN: return "HIGHER or LOWER?"
        case .IN_OUT:  return "INSIDE or OUTSIDE?"
        case .SUIT:    return "What's the SUIT?"
        case .POKER:   return "Texax Hold'em!"
        case .GIVE:    return "Give"
        case .TAKE:    return "Take"
        }
    }

    func level() -> Int {
        switch self {
        case .COLOR: return 1
        case .UP_DOWN: return 2
        case .IN_OUT: return 3
        case .SUIT: return 4
        case .POKER: return 5
        case .GIVE, .TAKE: return 0
        }
    }
}
