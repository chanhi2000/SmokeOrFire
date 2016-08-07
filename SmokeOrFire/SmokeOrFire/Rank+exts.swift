//
//  Rank+successor.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

extension Rank: ForwardIndexType {
    func successor() -> Rank {
        switch self {
        case .__EXHAUST: return .__EXHAUST
        default: return Rank(rawValue: self.rawValue + 1)!
        }
    }
}
