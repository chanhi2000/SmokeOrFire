//
//  GameViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import iAd
import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {

    // UI variables
    @IBOutlet weak var bannerView: ADBannerView!
    @IBOutlet weak var buttonView: ButtonView!
    @IBOutlet weak var skView: SKView!

    // Constant variables
    private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    private let SCREEN_WIDTH_UNITS = 20.0 // Number of width units in design.
    private let SCREEN_HEIGHT_UNITS = 35.0 // Number of height units in design.

    // Instance variables
    var ac: UIAlertController!
    var button: UIButton!
    var deck: Deck = Deck()
    var gameScene: GameScene!
    // TODO: Add option to adjust these card counts per level.
    var levels: [Int] = [4, 4, 3, 3, 2, 1]
    var pyramid: Pyramid!
    var player: Player!
    var players: [Player]!
    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
    var statusView: StatusView!
    var viewsDictionary: [String: AnyObject]! // Used to design Visual Format constraints.

    // Property inspectors

    var playerIndex: Int = 0 {
        didSet {
            if playerIndex == players.count {
                // All the players have played in the round.
                playerIndex = 0
                player = players[playerIndex]
                statusView?.statusButton.setTitle(
                    "P\(playerIndex + 1)", forState: .Normal)
                nextRound()
            } else {
                // Update everything for next player.
                player = players[playerIndex]
                statusView?.statusButton.setTitle(
                    "P\(playerIndex + 1)", forState: .Normal)
                // Display next player's hand.
                gameScene.displayHand(player.hand, reveal: false)
                if let card = deck.draw() {
                    // Update round user interface.
                    round = Round(card: card, rule: round.rule)
                } else {
                    // Deck ran out of cards.
                    print("Ran out cards in playerIndex.didSet")
                    gameOver()
                }
            }
        }
    }

    var pyramidRoundIndex: Int = 0 {
        didSet {
            if pyramidRoundIndex < pyramid.rounds.count - 1 {
                nextRound()
            } else {
                // End of last pyramid round.
                print ("End of last pyramid round in pyramidRoundIndex.didSet")
                gameOver()
            }
        }
    }

    var round: Round! {
        didSet {
            buttonView.setButtonsFor(round)
        }
    }

    var rule: Rule! {
        didSet {
            switch (rule as Rule) {
                case .GIVE, .TAKE:
                    // Set give and take display text.
                    statusView?.statusButton.setTitle("\(rule.title())", forState: .Normal)
                    statusView.statusLabel.text = "\(rule.title()) " +
                        "\(pyramid.rounds[pyramidRoundIndex].level) if you have..."
                    // Update game scene.
                    gameScene.displayPyramid(pyramid.rounds, index: pyramidRoundIndex)
                    break
                default:
                    // Set text for a question round.
                    statusView.statusLabel.text = rule.title()
                    // Update game scene.
                    gameScene.displayHand(player.hand, reveal: false)
            }
        }
    }

    var totalPlayers: Int! {
        didSet {
            // Initialize players.
            players = [Player]()
            for i in 0.stride(to: totalPlayers, by: 1) {
                players.append(Player(number: i + 1))
            }
            player = players[0]
        }
    }

    // View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Smoke or Fire"

        buttonView.delegate = self

        // Setup status container.
        statusView = StatusView(frame: CGRect(
            x: CGFloat(1.0 / SCREEN_WIDTH_UNITS) * view.frame.width,
            y: CGFloat(2.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: CGFloat(18.0 / SCREEN_WIDTH_UNITS) * view.frame.width,
            height: CGFloat(8.0 / SCREEN_HEIGHT_UNITS) * view.frame.height))
        view.addSubview(statusView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[statusView]|", options: [], metrics: nil,
            views: ["statusView": statusView]))
        view.addConstraint(NSLayoutConstraint(item: statusView,
            attribute: .Leading, relatedBy: .Equal,
            toItem: skView, attribute: .Leading, multiplier: 1.0, constant: 0.0))

        // Setup skView.
        skView.frame = CGRect(
            x: CGFloat(10.0 / SCREEN_WIDTH_UNITS) * view.frame.width,
            y: CGFloat(10.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: CGFloat(view.frame.width),
            height: CGFloat(12.0 / SCREEN_HEIGHT_UNITS) * view.frame.height)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true // Improves rendering performance
        // Setup game scene.
        let scene = GameScene(size: skView.frame.size)
        scene.scaleMode = .AspectFill // Fits the scene to the view window
        skView.presentScene(scene)
        gameScene = scene

        startGame()

    }

    // MARK: - Segue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "viewSegue" {
//            let vc = segue.destinationViewController as! ViewController
//            vc.totalPlayers = 2
//        }
//    }

    func startGame() {
        deck.shuffle()
        createPyramid()
        nextRound()
    }

    func nextRound() {
        if let card = deck.draw() {
            // Update gui buttons for next question.
            rule = rules.removeFirst()
            round = Round(card: card, rule: rule)
        } else {
            // Deck ran out of cards.
            print("Ran out cards in nextRound()")
            gameOver()
        }
    }

    func gameOver() {
        print("Game over")
//        performSegueWithIdentifier("viewSegue", sender: self)
        navigationController?.popToRootViewControllerAnimated(true)

//        // TODO: Design game over that displays results.
//        let ac = UIAlertController(title: "Game Over", message: "Player: 1 wins!", preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "Continue", style: .Cancel, handler: { [weak self] (action: UIAlertAction!) -> Void in
//            guard let strongSelf = self else { return }
//            // Return to main menu.
//            strongSelf.navigationController?.popViewControllerAnimated(true)
//            strongSelf.navigationController?.popToRootViewControllerAnimated(true)
//        }))
//        presentViewController(ac, animated: true, completion: nil)
    }

}

// MARK: - ADBannerViewDelegate
extension GameViewController: ADBannerViewDelegate {

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
        /*
         Note:
         If you're using a table view, a scroll view, a collection view, a text view
         or something else that scrolls, you should set its contentInset and scrollIndicatorInset
         properties so that it doesn't scrolle under the advert when it's visible.
         */
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = false
    }

}

// MARK: - buttonViewDelegate
extension GameViewController: ButtonViewDelegate {

    func buttonViewUpdatePlayerChoice(text: String?) {
        if let choiceText = text {
            // TODO: Figure out how to shrink this switch-case into something more clever.
            switch (choiceText) {
            case ChoicesText.RED.rawValue:
                player.choice = PlayerChoices.RED
                break
            case ChoicesText.BLACK.rawValue:
                player.choice = PlayerChoices.BLACK
                break
            case ChoicesText.HIGHER.rawValue:
                player.choice = PlayerChoices.HIGHER
                break
            case ChoicesText.LOWER.rawValue:
                player.choice = PlayerChoices.LOWER
                break
            case ChoicesText.INSIDE.rawValue:
                player.choice = PlayerChoices.INSIDE
                break
            case ChoicesText.OUTSIDE.rawValue:
                player.choice = PlayerChoices.OUTSIDE
                break
            case ChoicesText.SAME.rawValue:
                player.choice = PlayerChoices.SAME
                break
            case ChoicesText.HEART.rawValue:
                player.choice = PlayerChoices.HEART
                break
            case ChoicesText.CLUB.rawValue:
                player.choice = PlayerChoices.CLUB
                break
            case ChoicesText.DIAMOND.rawValue:
                player.choice = PlayerChoices.DIAMOND
                break
            case ChoicesText.SPADE.rawValue:
                player.choice = PlayerChoices.SPADE
                break
            case ChoicesText.PYRAMID.rawValue:
                player.choice = PlayerChoices.PYRAMID
                break
            default:
                player.choice = PlayerChoices.SAME
            }

            if (player.choice == .PYRAMID) {
                // Display pyramid round results.
                displayPyramidResults()
            } else {
                // Display player results.
                // TODO: Move this chunk into a UIAlertConroller subclass.
                displayQuestionResults()
            }

        }
    }
}

// MARK: - Pyramid
extension GameViewController {

    func createPyramid() {
        pyramid = Pyramid()
        // This seed ensures give-take pattern doesn't always start on give.
        let seed = GKRandomSource.sharedRandom().nextIntWithUpperBound(2)
        for i in 0.stride(to: levels.count, by: 1) {
            for _ in 0.stride(to: levels[i], by: 1) {
                if let card = deck.draw() {
                    let pyramidRule = (((pyramid.rounds.count +
                        seed) % 2) == 0) ? Rule.GIVE : Rule.TAKE
                    rules.append(pyramidRule)
                    let pr = PyramidRound(level: i + 1, card: card,
                        rule: pyramidRule, isClicked: false)
                    pyramid.rounds.append(pr)
                } else {
                    print("No more cards in deck to build pyramid.")
                    return
                }
            }
        }
    }

}

// MARK: - Results UIAlertController methods
extension GameViewController {

    func displayPyramidResults() {
//        ac = UIAlertController(title: "Pyramid Round \(pyramidRoundIndex + 1)",
//            message: "\(round.card.describe())", preferredStyle: .Alert)
//
//        // Shape the frame to fit behind the card.
//        ac.view.layer.frame = CGRect(origin: ac.view.frame.origin,
//            size: round.card.frontImage.size)
//        ac.view.addConstraint(NSLayoutConstraint(item: ac.view, attribute: .Height,
//            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
//            multiplier: 1.0, constant: round.card.frontImage.size.height))

        // Set card image.
//        button = UIButton(frame: CGRect(x: CGFloat(0.25) * view.frame.width,
//            y: CGFloat(0.25) * view.frame.height,
//            width: round.card.frontImage.size.width,
//            height: round.card.frontImage.size.height))
//        button.setImage(pyramid.rounds[pyramidRoundIndex].card.frontImage, forState: .Normal)
//        button.addTarget(self, action: #selector(pyramidTapped), forControlEvents: .TouchUpInside)
//        view.addSubview(button)

//        let cardImage = UIImage(named: pyramid.rounds[pyramidRoundIndex].card.frontImage)
//        var action = UIAlertAction(title: "", style: .Default, handler: nil)
//        action.setValue(cardImage, forKey: "image")
//        ac.addAction(action)

//        for p in players {
//            if p.hasCard(round.card) {
//                // Add an action column for each losing player.
//                // TODO: Design handler for UIAlertAction to remove itself.
//                ac.addAction(UIAlertAction(
//                    title: "Player \(p.number): \(p.displayHand())",
//                    style: .Default, handler: nil))
//            }
//        }
        // TODO: Design handler to only dismiss once all players drink.
//        presentViewController(, animated: true, completion: nil)//{ [unowned self] in
//            guard let strongSelf = self else { return }
//            self.pyramid.rounds[self.pyramidRoundIndex].isClicked = true
//            self.pyramidRoundIndex += 1
//            self.dismissViewControllerAnimated(true, completion: nil)
//            self.ac = nil
//            button = nil
//        })
        pyramid.rounds[pyramidRoundIndex].isClicked = true
        pyramidRoundIndex += 1
    }

    func displayQuestionResults() {
//        player.hand.append(round.card)
//        gameScene.displayHand(player.hand, reveal: true)
//        playerIndex += 1

//        let ac = UIAlertController(title: "",
//            message: (round.card.describe() + "\n") +
//                (round.isDrinking(player) ? "DRINK" : "YOU WIN THIS TIME"),
//            preferredStyle: .Alert)

//        // Set background color: GREEN to drink, RED to pass
//        let subView: UIView = view.subviews.last! as UIView
//        let acView = subView.subviews.last! as UIView
//        acView.backgroundColor = round.isDrinking(player) ? .greenColor() : .redColor()

//        // Shape the frame to fit behind the card.
//        ac.view.layer.frame = CGRect(origin: ac.view.frame.origin,
//            size: round.card.frontImage.size)
//        ac.view.addConstraint(NSLayoutConstraint(item: ac.view, attribute: .Height,
//            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
//            multiplier: 1.0, constant: round.card.frontImage.size.height))

        player.hand.append(round.card)
        gameScene.displayHand(player.hand, reveal: true)
        playerIndex += 1
        // Set card image.
//        let button = UIButton(frame: view.frame)
//        button.setImage(round.card.frontImage, forState: .Normal)
//        button.addTarget(self, action: #selector(questionTapped),
//            forControlEvents: .TouchUpInside)
//        view.addSubview(button)

//        presentViewController(ac, animated: true, completion: nil)
    }

    func pyramidTapped(button: UIButton) {
//        dismissViewControllerAnimated(true, completion: { [unowned self] in
////            guard let strongSelf = self else { return }
//            // Update pyramid round.
//            self.pyramid.rounds[self.pyramidRoundIndex].isClicked = true
//            self.pyramidRoundIndex += 1
//        })
//        self.button.removeFromSuperview()
//        self.button = nil
        pyramid.rounds[pyramidRoundIndex].isClicked = true
        pyramidRoundIndex += 1
//        dismissViewControllerAnimated(true, completion: nil)
    }

    func questionTapped(button: UIButton) {
//        dismissViewControllerAnimated(true, completion: { [weak self] in
//            guard let strongSelf = self else { return }
//            // Update player variables before next round.
//            strongSelf.playerIndex += 1
//        })
        button.removeFromSuperview()
        playerIndex += 1
    }

}
