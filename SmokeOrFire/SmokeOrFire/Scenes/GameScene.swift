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

    var rowHeights: [CGFloat]!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        rowHeights = [size.height / 2.0, size.height / 4.0]
    }

    func clearCards() {
        for node in self.children {
            node.removeFromParent()
        }
    }

    func displayHand(hand: [Card], reveal: Bool) {
        clearCards()
        let xUnit = size.width / CGFloat(hand.count + (reveal ? 1 : 2)) // include edges of x-axis
        // Iterate through card in hand.
        for i in 0.stride(to: hand.count + (reveal ? 0 : 1), by: 1) {
            let xPos = CGFloat(i + 1) * xUnit
            if (i == hand.count) {
                // Draw hidden card.
                let hiddenCard = SKSpriteNode(texture: SKTexture(imageNamed: "back"),
                    size: CGSize(width: 80, height: 120))
                hiddenCard.position = CGPoint(x: xPos, y: rowHeights[0])
                hiddenCard.zPosition = CGFloat(i)
                addChild(hiddenCard)
            } else {
                // Draw card in player's hand.
                let card = SKSpriteNode(texture: SKTexture(imageNamed: hand[i].imageName),
                    color: .whiteColor(), size: CGSize(width: 80, height: 120))
                card.position = CGPoint(x: xPos, y: rowHeights[0])
                card.zPosition = CGFloat(i)
                addChild(card)
            }
        }
    }

    func displayPyramid(rounds: [PyramidRound], index: Int) {
        clearCards()
        // Create a list where each element is a list of pyramid rounds.
        let rows = [rounds.filter { $0.level == rounds[index].level },
            rounds.filter{ $0.level == (rounds[index].level + 1) }]
        // Iterate through each list of pyramid rounds.
        for i in 0.stride(to: rows.count, by: 1) {
            let xUnit = size.width / CGFloat(rows[i].count + 2) // + 2 includes ends of x-axis
            // Loop through each pyramid round.
            for j in 0.stride(to: rows[i].count, by: 1) {
                let round = rows[i][j]
                let imageName = round.isClicked ? round.imageName : "back"
                // Draw pyramid card.
                let card = SKSpriteNode(texture: SKTexture(imageNamed: imageName),
                    color: .whiteColor(), size: CGSize(width: 40, height: 80))
                card.position = CGPoint(x: CGFloat(j + 1) * xUnit, y: rowHeights[i])
                card.zPosition = CGFloat(i + j) // DEBUG
                addChild(card)
            }
        }
    }

}
