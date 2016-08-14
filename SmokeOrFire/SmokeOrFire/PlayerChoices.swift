//
//  PlayerChoices.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/14/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

enum PlayerChoices: UInt8 {
    // Suit?
    case CLUB = 1, DIAMOND, HEART, SPADE
    // Smoke or fire?
    case RED
    case BLACK
    // Higher or lower?
    case HIGHER
    case LOWER
    // Inside or outside?
    case INSIDE
    case OUTSIDE
    // Misc choice
    case SAME
    // Pyramid, no actual choice.
    case PYRAMID
}
