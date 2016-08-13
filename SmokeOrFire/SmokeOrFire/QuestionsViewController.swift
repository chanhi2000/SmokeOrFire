//
//  QuestionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import iAd
import GameplayKit
import UIKit

class QuestionsViewController: UIViewController {

    // MARK: - UI variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonContainer: ButtonContainer!
    @IBOutlet weak var bannerView: ADBannerView!

    // MARK: - Constant variables
    private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    private let SCREEN_WIDTH_UNITS = 20.0 // Number of width units in design.
    private let SCREEN_HEIGHT_UNITS = 35.0 // Number of height units in design.

    // MARK: - Instance variables
    var deck: Deck = Deck()
    // TODO: Add option to adjust these card counts per level.
    var levels: [Int] = [4, 4, 3, 3, 2, 1]
    var pyramid: Pyramid!
    var players: [Player]!
    var pyramidRoundIndex = 0
    var roundIndex = 0
    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
    var statusContainer: StatusContainer!
    var viewsDictionary: [String: AnyObject]! // Used to design Visual Format constraints.

    // MARK: - Property inspectors

    var player: Player! {
        didSet {
            statusContainer?.statusButton.setTitle("P\(playerIndex + 1)", forState: .Normal)
            // TODO: Display hand for new player.
        }
    }

    var playerIndex: Int = 0 {
        didSet {
            if playerIndex == players.count {
                // All the players have played in the round.
                playerIndex = 0
                player = players[playerIndex]
                roundIndex += 1
                pyramidRoundIndex = (round.rule == .GIVE || round.rule == .TAKE) ?
                    pyramidRoundIndex + 1 : pyramidRoundIndex
                nextRound()
            } else {
                // Update everything for next player.
                player = players[playerIndex]
                if let card = deck.draw() {
                    // Update round user interface.
                    round = Round(card: card, rule: round.rule)
                } else {
                    // Deck ran out of cards.
                    gameOver()
                    let ac = UIAlertController(title: "Game Over", message: "Player: 1 wins!", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Continue", style: .Cancel, handler: nil))
                    presentViewController(ac, animated: true, completion: { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.dismissViewControllerAnimated(true, completion: nil)
                    })

                }
            }
        }
    }

    var round: Round! {
        didSet {
            buttonContainer.setButtonsFor(round)
        }
    }

    var rule: Rule! {
        didSet {
            statusContainer.statusLabel.text = rule.title()
            switch (rule as Rule) {
                case .GIVE, .TAKE:
                    // Set give and take based on pyramid level.
                    statusContainer.statusLabel.text = "Give " +
                        "\(pyramid.rounds[pyramidRoundIndex].level) if you have..."
                    break
                default:
                    // Set text for a question round.
                    questionLabel.text = rule.title()
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

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Smoke or Fire"

        buttonContainer.delegate = self

        // Setup status container.
        statusContainer = StatusContainer(frame: CGRect(
            x: CGFloat(1.0 / SCREEN_WIDTH_UNITS) * view.frame.width,
            y: CGFloat(1.0 / SCREEN_HEIGHT_UNITS) * view.frame.height,
            width: CGFloat(18.0 / SCREEN_WIDTH_UNITS) * view.frame.width,
            height: CGFloat(8.0 / SCREEN_HEIGHT_UNITS) * view.frame.height))
        view.addSubview(statusContainer)

        createPyramid()

        startGame()
    }

    // MARK: - Custom

    func createPyramid() {
        pyramid = Pyramid()
        // This seed ensures give-take pattern doesn't always start on give.
        let seed = GKRandomSource.sharedRandom().nextIntWithUpperBound(2)
        for i in 0.stride(to: levels.count, by: 1) {
            for _ in 0.stride(to: levels[i], by: 1) {
                if let card = deck.draw() {
                    let pyramidRule = ((pyramid.rounds.count +
                        seed % 2) == 0) ? Rule.GIVE : Rule.TAKE
                    rules.append(pyramidRule)
                    let pr = PyramidRound(level: levels[i], card: card,
                        rule: pyramidRule, isClicked: false)
                    pyramid.rounds.append(pr)
                } else {
                    print("No more cards in deck to build pyramid.")
                    return
                }
            }
        }
    }

    func startGame() {
        deck.shuffle()
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

    func gameOver() {
        print("Game over")
        // TODO: Design game over that displays results.
    }
}

// MARK: - ADBannerViewDelegate
extension QuestionsViewController: ADBannerViewDelegate {

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

// MARK: - ButtonContainerDelegate
extension QuestionsViewController: ButtonContainerDelegate {

    func buttonContainerUpdatePlayerChoice(text: String?) {
        if let choiceText = text {
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
                let ac = UIAlertController(title: "Pyramid Round",
                    message: "\(round.card.describe())", preferredStyle: .Alert)
                for p in players {
                    if p.hasCard(round.card) {
                        ac.addAction(UIAlertAction(title: "Player \(p.number): \(p.hand)", style: .Default, handler: nil))
                    }
                }
                ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
            } else {
                // Display player results.
                // TODO: Move this chunk into a UIAlertConroller subclass.
                let msg = (round.card.describe() + "\n") +
                    (round.isDrinking(player) ? "DRINK" : "YOU WIN THIS TIME")
                let ac = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
                ac.view.layer.frame = CGRect(origin: ac.view.frame.origin, size: round.card.frontImage.size)
                ac.view.addConstraint(NSLayoutConstraint(item: ac.view, attribute: .Height,
                    relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: round.card.frontImage.size.height))
                let buttonView = UIButton(frame: ac.view.frame)
                buttonView.setImage(round.card.frontImage, forState: .Normal)
                buttonView.addTarget(self, action: #selector(closeButton), forControlEvents: .TouchUpInside)
                ac.view.addSubview(buttonView)
                presentViewController(ac, animated: true, completion: { [unowned self] in
                    // Update player variables before next round.
                    self.player.hand.append(self.round.card)
                    self.playerIndex += 1
                })
            }
        }
    }

    // MARK: - Selectors

    func closeButton(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
