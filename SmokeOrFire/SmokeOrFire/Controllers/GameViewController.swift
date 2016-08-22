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
    private let margin = CGFloat(8.0) // Add spacing to see the border.
    private let playerColors: [UIColor] = [UIColor.blueColor(),
        UIColor.redColor(), UIColor.orangeColor(), UIColor.purpleColor(),
        UIColor.greenColor(), UIColor.cyanColor(), UIColor.magentaColor(),
        UIColor.brownColor()]

    // Instance variables
    var deck: Deck!
    var gameScene: GameScene!
    // TODO: Add option to adjust these card counts per level.
    var levels: [Int] = [4, 4, 3, 3, 2, 1]
    var pyramid: Pyramid!
    weak var player: Player!
    var players: [Player]!
    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
    var statusView: StatusView!
    var viewsDictionary: [String: AnyObject]! // Used to design Visual Format constraints.

    // Property inspectors

    var playerIndex: Int = 0 {
        didSet {
            statusView.statusButton.setImage(nil, forState: .Normal)
            statusView.statusLabel.text = rule.title()
            if playerIndex == players.count {
                // All the players have played in the round.
                playerIndex = 0
                player = players[playerIndex]
                statusView.backgroundColor = playerColors[playerIndex]
                statusView.statusButton.setTitleColor(playerColors[playerIndex],
                    forState: .Normal)
                statusView.statusButton.setTitle("P1", forState: .Normal)
                if rule == Rule.SUIT {
                    // Start first pyramid round.
                    nextPyramidRound()
                } else {
                    nextRound()
                }
            } else {
                // Update everything for next player.
                player = players[playerIndex]
                statusView.backgroundColor = playerColors[playerIndex]
                statusView.statusButton.setTitle("P\(playerIndex + 1)", forState: .Normal)
                statusView.statusButton.setTitleColor(playerColors[playerIndex],
                    forState: .Normal)
                // Display next player's hand.
                gameScene.displayHand(player.hand)
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
            if pyramidRoundIndex < pyramid.rounds.count {
                if (pyramid.rounds[oldValue].level != pyramid.rounds[pyramidRoundIndex].level) {
                    // Shift up pyramid rows.
                    gameScene.shiftPyramid()
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                        Int64(1.00 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                        guard let strongSelf = self else { return }
                        // Display next round after delay.
                        strongSelf.nextPyramidRound()
                    }
                } else {
                    nextPyramidRound()
                }
            } else {
                // End of last pyramid round.
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
                    statusView?.statusButton.setImage(nil, forState: .Normal)
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
                    gameScene.displayHand(player.hand)
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

        // Customize back button.
        let backButton = UIButton(type: .Custom)
        backButton.addTarget(self, action: #selector(mainMenu), forControlEvents: .TouchUpInside)
        backButton.setTitle("reset", forState: .Normal)
        backButton.titleLabel!.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        backButton.setTitleColor(.whiteColor(), forState: .Normal)
        backButton.sizeToFit()
        navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: backButton)

        // Add tap gesture recognizer.
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tgr.numberOfTapsRequired = 1
        tgr.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tgr)

        // Setup status view.
        // TODO: - Clean up these mathematical expressions.
        statusView = StatusView(frame: CGRect(
            x: margin,
            y: (navigationController?.navigationBar.frame.height)! +
                ( CGFloat(1.0 / SCREEN_HEIGHT_UNITS) * view.frame.height ) + margin,
            width: ( CGFloat(20.0 / SCREEN_WIDTH_UNITS) * SCREEN_WIDTH ) - (2 * margin),
            height: ( CGFloat(8.0 / SCREEN_HEIGHT_UNITS) * view.frame.height ) - (2 * margin)))
        statusView.backgroundColor = playerColors[0]
        statusView.statusButton.setTitleColor(playerColors[0], forState: .Normal)
        statusView.layer.cornerRadius = 8
        statusView.layer.borderWidth = 4
        statusView.layer.borderColor = UIColor.whiteColor().CGColor
        view.addSubview(statusView)
        // Add status view constraints.
        view.addConstraint(NSLayoutConstraint(item: statusView,
            attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: statusView.frame.height))

        // Setup skView.
        skView.frame = CGRect(
            x: 0, y: CGFloat(10.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: view.frame.width,
            height: CGFloat(12.0 / SCREEN_HEIGHT_UNITS) * view.frame.height)
        skView.ignoresSiblingOrder = true // Improves rendering performance
        // Add skView constraints.
        view.addConstraint(NSLayoutConstraint(item: skView,
            attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: skView.frame.height))
        view.addConstraint(NSLayoutConstraint(item: skView,
            attribute: .Top, relatedBy: .Equal,
            toItem: statusView, attribute: .Bottom,
            multiplier: 1.0, constant: 0.0))

        // Setup game scene.
        let scene = GameScene(size: skView.frame.size)
        scene.scaleMode = .AspectFill // Fits the scene to the view window
        skView.presentScene(scene)
        gameScene = scene

        // Setup button view.
        buttonView.customizeButtons()
        buttonView.delegate = self // Notify on button press.
        buttonView.frame = CGRect(
            x: 0, y: CGFloat(22.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: view.frame.width,
            height: CGFloat(9.0 / SCREEN_HEIGHT_UNITS) * view.frame.height)
        // Add button view constraints.
        view.addConstraint(NSLayoutConstraint(item: buttonView,
            attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: buttonView.frame.height))

        // Setup banner view.
        bannerView.delegate = self
        bannerView.frame = CGRect(
            x: 0, y: CGFloat(32.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: view.frame.width,
            height: CGFloat(4.0 / SCREEN_HEIGHT_UNITS) * view.frame.height)
        // Add banner view constraints.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
            attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: bannerView.frame.height))

        startGame()

    }

    func handleTap() {
        for subView in view.subviews {
            if let button = subView as? UIButton {
                // Call unclicked button's selectors.
                if button.tag == 0 {
                    questionTapped(button)
                } else if button.tag == 1 {
                    pyramidTapped(button)
                } else if button.tag == 2 {
                    gameOverTapped(button)
                }
            }
        }
    }

    func isButtonVisible() -> Bool {
        for subView in view.subviews {
            if (subView as? UIButton) != nil {
                return true
            }
        }
        return false
    }

    func mainMenu() {
        navigationController!.popToRootViewControllerAnimated(true)
    }

    func startGame() {
        deck = Deck()
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
            gameOver()
        }
    }

    func nextPyramidRound() {
        rule = rules.removeFirst()
        round = Round(card: deck.cardWithName(pyramid.rounds[pyramidRoundIndex].imageName),
            rule: rule)
    }

    func gameOver() {
        // Create a UIButton subview to use a selector to control game flow.
        let button = UIButton(frame: view.frame)
        button.tag = 3
        button.addTarget(self, action: #selector(gameOverTapped),
            forControlEvents: .TouchUpInside)
        view.addSubview(button)
        // Update status view objects.
        statusView.statusButton.setImage(nil, forState: .Normal)
        statusView.statusButton.setTitle("", forState: .Normal)
        statusView.statusLabel.text = "Game Over"
        // Hide choice buttons.
        buttonView.hidden = true
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
        // Handle unclicked button.
        if isButtonVisible() {
            handleTap()
            return
        }
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
                    let pr = PyramidRound(level: i + 1, imageName: card.imageName,
                        rule: pyramidRule, isClicked: false)
                    pyramid.rounds.append(pr)
                } else {
                    // Not enough cards to build pyramid.
                    gameOver()
                }
            }
        }
    }

}

// MARK: - Results UIAlertController methods
extension GameViewController {

    func displayPyramidResults() {
        buttonView.enabled = false
        // Get pyramid round card.
        let imageName = pyramid.rounds[pyramidRoundIndex].imageName
        // Display updated pyramid.
        pyramid.rounds[pyramidRoundIndex].isClicked = true
        gameScene.revealHiddenPyramidCard(imageName)
        // Set card image.
        let button = UIButton(frame: view.frame)
        button.tag = 1
        button.addTarget(self, action: #selector(pyramidTapped),
            forControlEvents: .TouchUpInside)
        // Display player list.
        var lines = [String]()
        for p in players {
            if p.hasCard(round.card) {
                lines.append("P\(p.number): \(rule.title()) " +
                    "\(pyramid.rounds[pyramidRoundIndex].level)")
            }
        }
        view.addSubview(button)
        // Display beer icon, if anyone has to drink.
        let newSize = CGSize(width: 180, height: 250)
        let frontImage = UIImage(named: "beer")!
            .scaledToSize(newSize).alpha((lines.count > 0) ? 1.0 : 0.0)
        let statusLabelText = (lines.count > 0) ? lines.joinWithSeparator("\n") : "PASS"
        // After some delay, update the status view objects.
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.400 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animateWithDuration(0.100, animations: { [strongSelf] in
                strongSelf.statusView.statusButton.setImage(frontImage, forState: .Normal)
                strongSelf.statusView.statusLabel.text = statusLabelText
            })
        }
    }

    func displayQuestionResults() {
        buttonView.enabled = false
        let newSize = statusView.statusButton.frame.size
        let frontImage = UIImage(named: "beer")!
            .scaledToSize(newSize).alpha(round.isDrinking(player) ? 1.0 : 0.0)
        // Create a UIButton subview to use a selector to control game flow.
        let button = UIButton(frame: view.frame)
        button.tag = 0
        button.addTarget(self, action: #selector(questionTapped),
            forControlEvents: .TouchUpInside)
        // Update status window.
        let statusLabelText = round.isDrinking(player) ? "TAKE \(rule.level())" : "PASS"
        // Display updated player's hand.
        player.hand.append(round.card)
        gameScene.revealHiddenCard(round.card)
        // After card flip animation completes, display visual feedback.
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.400 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animateWithDuration(0.100, animations: { [strongSelf] in
                strongSelf.statusView.statusButton.setImage(frontImage, forState: .Normal)
                strongSelf.statusView.statusLabel.text = statusLabelText
                strongSelf.view.addSubview(button)
            })
        }
    }

    func pyramidTapped(button: UIButton) {
        button.removeFromSuperview()
        buttonView.enabled = true
        pyramidRoundIndex += 1
    }

    func questionTapped(button: UIButton) {
        button.removeFromSuperview()
        buttonView.enabled = true
        playerIndex += 1
    }

    func gameOverTapped(button: UIButton) {
        navigationController!.popToRootViewControllerAnimated(true)
    }

}
