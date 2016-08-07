//
//  Pyramid.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import Foundation

struct Pyramid {
    var rounds = [PyramidRound]()

}

struct PyramidRound {
    var level: Int
    var card: Card
    var rule: Rule
}