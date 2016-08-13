//
//  String+subscript.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/13/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

extension String {

    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }

    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }

}
