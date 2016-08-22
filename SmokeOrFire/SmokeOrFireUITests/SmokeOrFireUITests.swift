//
//  SmokeOrFireUITests.swift
//  SmokeOrFireUITests
//
//  Created by Justin Lawrence Hester on 8/21/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

@testable import SmokeOrFire
import XCTest

class SmokeOrFireUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testFullGame() {

        let app = XCUIApplication()
        app.buttons["play"].tap()
        app.buttons["SMOKE"].tap()

        let button = app.otherElements.containingType(.NavigationBar, identifier:"Smoke or Fire").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Button).element
        button.tap()

        app.buttons["FIRE"].tap()
        button.tap()
        app.buttons["HIGHER"].tap()
        button.tap()
        app.buttons["LOWER"].tap()
        button.tap()
        app.buttons["INSIDE"].tap()
        button.tap()
        app.buttons["OUTSIDE"].tap()
        button.tap()
        app.buttons["SPADE"].tap()
        button.tap()
        app.buttons["HEART"].tap()
        button.tap()

        let button2 = app.buttons["?"]
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button2.tap()
        button.tap()
        button.tap()

    }
    
}
