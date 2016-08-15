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

    var cards = [SKSpriteNode?]() // Keeps track of current cards in scene.

    func clearCards() {
        for i in 0.stride(to: cards.count, by: 1) {
            cards[i]?.removeFromParent()
        }
        cards.removeAll(keepCapacity: true)
    }

    func displayHand(hand: [Card]) {
        clearCards()
        let rowOneY = size.height / 2.0
        let xUnit = size.width / CGFloat(hand.count + 2) // + 2 includes ends of x-axis
        for i in 0.stride(to: hand.count + 1, by: 1) {
            let xPos = CGFloat(i + 1) * xUnit
            if (i == hand.count) {
                // Add hidden card.
                let hiddenCard = SKSpriteNode(texture: SKTexture(imageNamed: "back"),
                    size: CGSize(width: 80, height: 120))
                hiddenCard.position = CGPoint(x: xPos, y: rowOneY)
                hiddenCard.zPosition = CGFloat(i)
                cards.append(hiddenCard)
                addChild(hiddenCard)
            } else {
                let card = SKSpriteNode(texture: SKTexture(imageNamed: hand[i].imageName),
                    color: .whiteColor(), size: CGSize(width: 80, height: 120))
                card.position = CGPoint(x: CGFloat(i + 1) * xUnit, y: rowOneY)
                card.zPosition = CGFloat(i)
                cards.append(card)
                addChild(card)
            }
        }
    }
}
