//
//  PyramidTests.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/10/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class PyramidTests: XCTestCase {

    var pyramid: Pyramid!
    var pyramidRound: PyramidRound!

    override func setUp() {
        super.setUp()
        pyramid = Pyramid()
        pyramidRound = PyramidRound(level: 3, imageName: "ace_of_spades", rule: .COLOR, isClicked: true)
    }
    
    func testPyramidRound() {
        XCTAssertEqual(pyramidRound.level, 3)
        XCTAssertEqual(pyramidRound.imageName, "ace_of_spades")
        XCTAssertEqual(pyramidRound.rule.title(), "Smoke or Fire?")
        XCTAssertTrue(pyramidRound.isClicked)
    }
}
