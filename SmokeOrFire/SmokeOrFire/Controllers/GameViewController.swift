//
//  GameViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {

    // UI variables
    @IBOutlet weak var buttonView: ButtonView!
    @IBOutlet weak var skView: SKView!

    // Constant variables
    private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    private let SCREEN_WIDTH_UNITS = 20.0 // Number of width units in design.
    private let SCREEN_HEIGHT_UNITS = 35.0 // Number of height units in design.
    private let font = UIFont(name: "AmericanTypewriter-Bold", size: 28)!
    private let margin = CGFloat(8.0) // Add spacing to see the border.
    private let playerColors: [UIColor] = [UIColor.blueColor(),
        UIColor.redColor(), UIColor.orangeColor(), UIColor.purpleColor(),
        UIColor.greenColor(), UIColor.cyanColor(), UIColor.magentaColor(),
        UIColor.brownColor()]

    // Instance variables
    var deck: Deck!
    var gameScene: GameScene!
    var guessView: UIView!
    var levels: [Int] = [4, 4, 3, 3, 2, 1]
    var losingView: UIView!
    var picker: UIPickerView!
    weak var player: Player!
    var players: [Player]!
    var pyramid: Pyramid!
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
                    // Clear status view.
                    statusView.clear()
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
        backButton.titleLabel!.font = font
        backButton.titleLabel!.adjustsFontSizeToFitWidth = true
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
            x: 0, y: CGFloat(9.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
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
            x: 0, y: CGFloat(21.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: view.frame.width,
            height: CGFloat(12.0 / SCREEN_HEIGHT_UNITS) * view.frame.height)

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
            } else if subView.tag == 3 {
                pyramidTapped(subView)
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

// MARK: - UIPickerViewDelegate
extension GameViewController: UIPickerViewDelegate {

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        switch (component) {
        case 0:
            pickerLabel.text = Rank.allValues[row].describe()
        case 1:
            pickerLabel.text = "of"
        case 2:
            pickerLabel.text = Suit.allValues[row].describe()
        default:
            pickerLabel.text = ""
        }
        pickerLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 28)
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .Center
        pickerLabel.textColor = (component == 1) ? .lightGrayColor() : .whiteColor()
        return pickerLabel
    }

}

// MARK: - UIPickerViewDataSource
extension GameViewController: UIPickerViewDataSource {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return Rank.allValues.count
        case 1:
            return 1
        case 2:
            return Suit.allValues.count
        default:
            return 0
        }
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
            setPlayerChoice(choiceText)

            buttonView.enabled = false
            switch (player.choice as PlayerChoices) {
            case .GUESS:
                displayGuessTheCard()
                break
            case .PYRAMID:
                displayPyramidResults()
                break
            default:
                displayQuestionResults()
                break
            }

        }
    }

    func setPlayerChoice(choiceText: String) {
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
        case ChoicesText.GUESS.rawValue:
            player.choice = PlayerChoices.GUESS
        default:
            player.choice = PlayerChoices.SAME
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

// MARK: - Guess the card
extension GameViewController {

    func displayGuessTheCard() {

        // Set dimension constants.
        let width = SCREEN_WIDTH * 0.65
        let widthMargin = CGFloat((SCREEN_WIDTH - width) / 2.0)
        let height = SCREEN_HEIGHT * 0.42
        let heightMargin = CGFloat((SCREEN_HEIGHT - height) / 2.0)

        guessView = UIView(frame: CGRect(x: widthMargin, y: heightMargin, width: width, height: height))

        // Add picker view.
        picker = UIPickerView(frame: CGRect(x: 0, y: 0,
            width: width, height: 0.80 * height))
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        picker.backgroundColor = .blackColor()
        guessView.addSubview(picker)

        // Add picker tool bar.
        let pickerToolbar = UIToolbar(frame: CGRect(x: 0,
            y: picker.frame.height, width: width, height: 0.20 * height))
        pickerToolbar.barStyle = .Black
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
        fixedSpace.width = 15
        let okItem = UIBarButtonItem(title: "guess", style: .Plain,
            target: self, action: #selector(okSelected))
        okItem.setTitleTextAttributes([NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: self, action: nil)
        let cancelItem = UIBarButtonItem(title: "cancel",
            style: .Plain, target: self, action: #selector(cancelSelected))
        cancelItem.setTitleTextAttributes([NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.redColor()], forState: .Normal)
        pickerToolbar.setItems([fixedSpace, okItem, flexSpace, cancelItem, fixedSpace], animated: true)
        guessView.addSubview(pickerToolbar)

        view.addSubview(guessView)
    }

    func okSelected(sender: UIButton) {

        // Get selected rank and suit.
        let rankRow = picker.selectedRowInComponent(0)
        let suitRow = picker.selectedRowInComponent(2)
        let rank = Rank(rawValue: rankRow + 1)!
        let suit = Suit(rawValue: suitRow + 1)!

        // Create a UIButton subview to use a selector to control game flow.
        let button = UIButton(frame: view.frame)
        button.tag = 0
        button.addTarget(self, action: #selector(questionTapped),
            forControlEvents: .TouchUpInside)

        // Create variables for updateStatusView() args.
        let isPlayerDrinking = (round.card.rank != rank) || (round.card.suit != suit)
        let statusLabelText = isPlayerDrinking ?
            "Take \(rule.level())" : "Give \(rule.level()) to each player"

        // Display updated player's hand.
        player.hand.append(round.card)
        gameScene.revealHiddenCard(round.card)

        updateStatusView(button, text: statusLabelText)

        guessView.removeFromSuperview()
    }

    func cancelSelected(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.buttonView.setButtonsFor(strongSelf.round)
            strongSelf.buttonView.enabled = true
            strongSelf.guessView.removeFromSuperview()
        }
    }

}

// MARK: - Results UIAlertController methods
extension GameViewController {

    func displayPyramidResults() {

        // Display updated pyramid.
        pyramid.rounds[pyramidRoundIndex].isClicked = true
        let imageName = pyramid.rounds[pyramidRoundIndex].imageName
        gameScene.revealHiddenPyramidCard(imageName)

        displayPlayerViews()
    }

    func displayPlayerViews() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.800 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }

            // Hide distracting views.
            strongSelf.statusView.hidden = true
            strongSelf.buttonView.hidden = true

            strongSelf.losingView = UIView(frame: strongSelf.view.frame)
            strongSelf.losingView.tag = 3

            let playerHeight = strongSelf.losingView.frame.height / CGFloat(8.0)

            var lines = [String]()
            for p in strongSelf.players {
                if p.hasCard(strongSelf.round.card) {
                    // Add player line to status label.
                    lines.append("P\(p.number): \(strongSelf.rule.title()) " +
                        "\(p.totalOf(strongSelf.round.card) * strongSelf.pyramid.rounds[strongSelf.pyramidRoundIndex].level)")
                }
            }

            for i in 0.stride(to: strongSelf.players.count, by: 1) {
                // Initialize player view.
                let playerView = UIView(frame: CGRect(x: 0,
                    y: ((CGFloat(i + 1) / CGFloat(strongSelf.players.count + 1)) *
                        strongSelf.losingView.layer.frame.height), // - (playerHeight / 2.0),
                    width: strongSelf.losingView.layer.frame.width, height: playerHeight))
                playerView.backgroundColor = strongSelf.playerColors[i]
                playerView.layer.borderWidth = 2
                playerView.layer.borderColor = UIColor.whiteColor().CGColor
                playerView.layer.cornerRadius = 4

                // Add player label.
                let label = UILabel(frame: CGRect(x: 0, y: 0,
                    width: strongSelf.losingView.layer.frame.width,
                    height: 0.35 * playerHeight))
                label.font = strongSelf.font
                label.numberOfLines = 1
                label.adjustsFontSizeToFitWidth = true
                label.textColor = .whiteColor()
                label.textAlignment = .Center
                let totalMatchedCards = strongSelf.players[i].totalOf(strongSelf.round.card) *
                    strongSelf.pyramid.rounds[strongSelf.pyramidRoundIndex].level
                label.text = "P\(strongSelf.players[i].number)" +
                    (totalMatchedCards > 0 ?
                        ": \(strongSelf.rule.title()) \(totalMatchedCards)" : "")
                playerView.addSubview(label)

                if (totalMatchedCards > 0) {
                    // Add side beer images.
                    let leftBeerView = UIImageView(frame: CGRect(
                        x: -0.10 * playerView.layer.frame.width,
                        y: 0, width: 0.20 * playerView.layer.frame.width,
                        height: playerView.layer.frame.height))
                    leftBeerView.image = UIImage(named: "beer")!
                    playerView.addSubview(leftBeerView)
                    let rightBeerView = UIImageView(frame: CGRect(
                        x: 0.90 * playerView.layer.frame.width,
                        y: 0, width: 0.20 * playerView.layer.frame.width,
                        height: playerView.layer.frame.height))
                    rightBeerView.image = UIImage(named: "beer")!
                    playerView.addSubview(rightBeerView)
                }

                // Add player cards.
                let cardWidth = (0.55 * playerHeight) / 1.5
                let cardMargin = (strongSelf.losingView.layer.frame.width -
                    (CGFloat(strongSelf.players[i].hand.count) * cardWidth)) /
                    CGFloat(strongSelf.players[i].hand.count + 1)
                for j in 0.stride(to: strongSelf.players[i].hand.count, by: 1) {
                    let handCard = strongSelf.players[i].hand[j]
                    let cardView = UIImageView(frame: CGRect(
                        x: (CGFloat(j + 1) * cardMargin) + (CGFloat(j) * cardWidth),
                        y: label.frame.height,
                        width: cardWidth,
                        height: 0.55 * playerHeight))
                    cardView.image = UIImage(named: handCard.imageName)!
                    if (handCard.rank == strongSelf.round.card.rank) {
                        // Add beer image behind card.
                        let beerView = UIImageView(frame: CGRect(
                            x: cardView.frame.minX + (cardView.frame.maxX - cardView.frame.minX) / 2.0,
                            y: cardView.frame.minY,
                            width: cardView.frame.width,
                            height: cardView.frame.height))
                        beerView.image = UIImage(named: "beer")!
                        playerView.addSubview(beerView)
                    }
                    playerView.addSubview(cardView)
                }
                strongSelf.losingView.addSubview(playerView)
            }

            let statusLabelText = lines.count > 0 ? lines.joinWithSeparator("\n") : ""
            strongSelf.updateStatusView(strongSelf.losingView, text: statusLabelText)
        }
    }

    func displayQuestionResults() {

        // Create a UIButton subview to use a selector to control game flow.
        let button = UIButton(frame: view.frame)
        button.tag = 0
        button.addTarget(self, action: #selector(questionTapped),
            forControlEvents: .TouchUpInside)

        // Display updated player's hand.
        player.hand.append(round.card)
        gameScene.revealHiddenCard(round.card)

        let statusLabelText = round.isDrinking(player) ?
            "Take \(rule.level())" : "Give \(rule.level())"
        updateStatusView(button, text: statusLabelText)
    }

    func updateStatusView(object: UIView, text: String) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.500 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animateWithDuration(0.100, animations: { [strongSelf] in
                let beerImage = UIImage(named: "beer")!
                strongSelf.statusView.statusButton.setImage(beerImage, forState: .Normal)
                strongSelf.statusView.statusButton.setImage(beerImage, forState: .Disabled)
                strongSelf.statusView.statusLabel.text = text
                strongSelf.view.addSubview(object)
            })
        }
    }

    func pyramidTapped(sender: AnyObject) {
        sender.removeFromSuperview()
        buttonView.enabled = true
        pyramidRoundIndex += 1
        statusView.hidden = false
        buttonView.hidden = false
    }

    func questionTapped(sender: AnyObject) {
        sender.removeFromSuperview()
        buttonView.enabled = true
        playerIndex += 1
    }

    func gameOverTapped(button: UIButton) {
        navigationController!.popToRootViewControllerAnimated(true)
    }

}
