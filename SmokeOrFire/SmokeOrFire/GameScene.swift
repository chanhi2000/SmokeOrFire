//
//  GameScene.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/13/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {

    var card: SKSpriteNode!

    override func didMoveToView(view: SKView) {
        card = SKSpriteNode(imageNamed: "ace_of_spades")
        card.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(card)
    }
}
