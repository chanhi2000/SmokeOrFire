//
//  GameScene.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/13/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameScene: SKScene {

    // Private variables
    private let goldenRatio = 1.618033988749894848
    private var cardSize: CGSize!

    var rowHeights: [CGFloat]!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backgroundColor = .blackColor()
        rowHeights = [size.height, size.height / 2.0, 0, -size.height / 2.0] // Order: Top, middle, bottom, off-screen
        cardSize = CGSize(
            width: size.width / CGFloat(4 * goldenRatio),
            height: size.width / CGFloat(2.5 * goldenRatio))
    }

    func clearCards() {
        // Initialize the x component for where the cards fly off screen.
        let xSeed = GKRandomSource.sharedRandom().nextIntWithUpperBound(Int(size.width))
        let xOffPos = CGFloat(xSeed)
        for node in self.children {
            if node.name!.hasPrefix("pyramid") {
                // Remove pyramid cards with no animation.
                node.removeAllActions()
                node.removeFromParent()
            } else if node.name == "emitterFireCard" {
                // Remove fire emitter behind hidden pyramid card with no animation.
                node.removeAllActions()
                node.removeFromParent()
            } else {
                // Animate the player's hand cards sliding towards the top screen.
                let path = UIBezierPath()
                path.moveToPoint(CGPoint(x: 0, y: 0))
                path.addLineToPoint(CGPoint(x: xOffPos - node.position.x, y: size.height))
                let move = SKAction.followPath(path.CGPath,
                    asOffset: true, orientToPath: false, duration: 0.300)
                let remove = SKAction.removeFromParent()
                node.runAction(SKAction.sequence([move, remove]))
            }
        }
    }

    func displayHand(hand: [Card]) {
        clearCards()
        let xUnit = size.width / CGFloat(hand.count + 2) // stride unit, include edges of x-axis
        // Initialize the x component for where the cards fly in from off screen.
        let xSeed = GKRandomSource.sharedRandom().nextIntWithUpperBound(Int(size.width))
        let xStartPos = CGFloat(xSeed)
        for i in 0.stride(to: hand.count + 1, by: 1) {

            // Set image texture for hidden or visible card, respectively.
            let imageName = (i == hand.count) ? "Bicyclebackside" : hand[i].imageName
            let xPos = CGFloat(i + 1) * xUnit // The x component of final position.

            // Create sprite for card.
            let card = SKSpriteNode(texture: SKTexture(imageNamed: imageName), size: cardSize)
            card.position = CGPoint(x: xStartPos, y: -cardSize.height)
            card.name = (i == hand.count) ? "hiddenCard" : "visibleCard"

            // Animate the card moving from below the bottom of the screen.
            let wait = SKAction.waitForDuration(0.500)
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: xPos - xStartPos,
                y: rowHeights[1] + cardSize.height))
            let move = SKAction.followPath(path.CGPath,
                asOffset: true, orientToPath: false, duration: 0.300)
            let sequence = SKAction.sequence([wait, move])
            card.runAction(sequence)
            addChild(card)

            if (i == hand.count) {
                // Add smoke particle emitter.
                let smoke = SKEmitterNode(fileNamed: "SmokeParticle")!
                smoke.name = "emitterSmokeCard"
                smoke.particlePositionRange = CGVector(
                    dx: card.frame.width + 5.0, dy: card.frame.height + 5.0)
                smoke.position = card.position
                smoke.runAction(sequence)
                addChild(smoke)
            }
        }
    }

    func revealHiddenCard(card: Card) {
        for node in self.children {
            if (node.name == "hiddenCard") {
                // Flip the card around as if revealing the face side.
                let midFlip = SKAction.scaleXTo(0, duration: 0.150)
                let texture = SKAction.setTexture(SKTexture(imageNamed: card.imageName))
                let fullFlip = SKAction.scaleXTo(1, duration: 0.150)
                let sequence = SKAction.sequence([midFlip, texture, fullFlip])
                node.runAction(sequence)
            }
        }
    }

    func displayPyramid(rounds: [PyramidRound], index: Int) {
        clearCards()
        // Create a list where each element is a list of pyramid rounds.
        let rows = [rounds.filter { $0.level == (rounds[index].level - 1) },
            rounds.filter { $0.level == rounds[index].level },
            rounds.filter { $0.level == (rounds[index].level + 1) },
            rounds.filter { $0.level == (rounds[index].level + 2) }]
        // Iterate through each list of pyramid rounds.
        for i in 0.stride(to: rows.count, by: 1) {
            let xUnit = size.width / CGFloat(rows[i].count + 1) // include trailing edge of x-axis
            // Initialize the x component for where the cards fly in from off screen.
            let xSeed = GKRandomSource.sharedRandom().nextIntWithUpperBound(Int(size.width))
            let xStartPos = CGFloat(xSeed)
            // Loop through each pyramid round.
            for j in 0.stride(to: rows[i].count, by: 1) {
                let round = rows[i][j]
                let imageName = round.isClicked ? round.imageName : "Bicyclebackside"
                // Draw pyramid card.
                let card = SKSpriteNode(texture: SKTexture(imageNamed: imageName),
                    color: .whiteColor(), size: cardSize)
                card.name = (round.imageName == rounds[index].imageName) ?
                    "pyramidHiddenCard" : "pyramidCard"
                let xPos = CGFloat(j + 1) * xUnit
                card.position = CGPoint(x: xPos, y: rowHeights[i])
                card.zPosition = CGFloat(round.level + i + j)
                if (!round.isClicked && (i == 1) && (j == 0 || rows[i][j-1].isClicked)) {
                    // Add emitter to hidden round card.
                    let fire = SKEmitterNode(fileNamed: "FireParticles")!
                    fire.name = "emitterFireCard"
                    fire.particlePositionRange = CGVector(
                        dx: card.frame.width + 5.0, dy: card.frame.height + 5.0)
                    fire.position = card.position
                    fire.zPosition = card.zPosition
                    let hide = SKAction.hide()
                    let wait = SKAction.waitForDuration(0.350)
                    let unhide = SKAction.unhide()
                    fire.runAction(SKAction.sequence([hide, wait, unhide]))
                    addChild(fire)
                }
                if (index == 0) {
                    // Animate the card moving from below the bottom of the screen.
                    card.position = CGPoint(x: xStartPos, y: -frame.height)
                    let wait = SKAction.waitForDuration(0.500)
                    let path = UIBezierPath()
                    path.moveToPoint(CGPoint(x: 0, y: 0))
                    path.addLineToPoint(CGPoint(x: xPos - xStartPos,
                        y: rowHeights[i] + frame.height))
                    let move = SKAction.followPath(path.CGPath,
                        asOffset: true, orientToPath: false, duration: 0.300)
                    let sequence = SKAction.sequence([wait, move])
                    card.runAction(sequence)
                }
                addChild(card)
            }
        }
    }

    func revealHiddenPyramidCard(imageName: String) {
        for node in self.children {
            if (node.name == "pyramidHiddenCard") {
                // Flip the card around as if revealing the face side.
                let midFlip = SKAction.scaleXTo(0, duration: 0.150)
                let texture = SKAction.setTexture(SKTexture(imageNamed: imageName))
                let fullFlip = SKAction.scaleXTo(1, duration: 0.150)
                let sequence = SKAction.sequence([midFlip, texture, fullFlip])
                node.runAction(sequence)
            }
        }
    }

    func shiftPyramid() {
        for node in self.children {
            if (node.name!.hasPrefix("pyramid") || node.name == "emitterFireCard") {
                node.name = "pyramidCard"
                let wait = SKAction.waitForDuration(0.250)
                let path = UIBezierPath()
                path.moveToPoint(CGPoint(x: 0, y: 0))
                path.addLineToPoint(CGPoint(x: 0, y: rowHeights[1]))
                let move = SKAction.followPath(path.CGPath,
                    asOffset: true, orientToPath: false, duration: 0.750)
                node.runAction(SKAction.sequence([wait, move]))
            }
        }
    }
}
