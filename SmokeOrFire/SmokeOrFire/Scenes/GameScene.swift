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

    // Private variables
    // TODO: - Consider computing this based on SKView frame.
    private let cardSize = CGSize(width: 80, height: 120)

    var rowHeights: [CGFloat]!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backgroundColor = .blackColor()
        rowHeights = [size.height, size.height / 2.0, 0] // Order: Top, middle, bottom
    }

    func clearCards() {
        for node in self.children {
            node.removeFromParent()
        }
    }

    func applyNodeSettings(node card: SKSpriteNode, settings: [String: AnyObject]) {
        // Find out if card is a reliable reference.
        for (_, item) in settings.enumerate() {
            let key = item.0
            let value = settings[key]
            switch (key) {
                case "position":
                    // Value is an array with (x, y) cartesian coordinates.
                    let pos = value as! [CGFloat]
                    card.position = CGPoint(x: pos[0], y: pos[1])
                    break
                case "zPosition":
                    // Value is an integer.
                    let zPos = value as! CGFloat
                    card.zPosition = zPos
                    break
                default:
                    break
            }
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
                    size: cardSize)
                applyNodeSettings(node: hiddenCard, settings:
                    ["position": [xPos, rowHeights[1]],
                        "zPosition": CGFloat(i)])
                addChild(hiddenCard)
            } else {
                // Draw card in player's hand.
                let card = SKSpriteNode(texture: SKTexture(imageNamed: hand[i].imageName),
                    color: .whiteColor(), size: cardSize)
                applyNodeSettings(node: card, settings:
                    ["position": [xPos, rowHeights[1]],
                        "zPosition": CGFloat(i)])
                addChild(card)
            }
        }
    }

    func displayPyramid(rounds: [PyramidRound], index: Int) {
        clearCards()
        // Create a list where each element is a list of pyramid rounds.
        let rows = [rounds.filter { $0.level == (rounds[index].level - 1) },
            rounds.filter { $0.level == rounds[index].level },
            rounds.filter { $0.level == (rounds[index].level + 1) }]
        // Iterate through each list of pyramid rounds.
        for i in 0.stride(to: rows.count, by: 1) {
            let xUnit = size.width / CGFloat(rows[i].count + 1) // include trailing edge of x-axis
            // Loop through each pyramid round.
            for j in 0.stride(to: rows[i].count, by: 1) {
                let round = rows[i][j]
                let imageName = round.isClicked ? round.imageName : "back"
                // Draw pyramid card.
                let card = SKSpriteNode(texture: SKTexture(imageNamed: imageName),
                    color: .whiteColor(), size: cardSize)
                card.position = CGPoint(x: CGFloat(j + 1) * xUnit, y: rowHeights[i])
                card.zPosition = CGFloat(i + j)
                applyNodeSettings(node: card, settings:
                    ["position": [CGFloat(j + 1) * xUnit, rowHeights[i]],
                    "zPosition": CGFloat(i + j)])
                addChild(card)
            }
        }
    }

}
