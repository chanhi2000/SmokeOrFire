//
//  QuestionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import iAd
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
    var statusContainer: StatusContainer!
    var players: [Player]!
    var deck: Deck = Deck()
    var roundIndex = 0
    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
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
            questionLabel.text = rule.title()
            statusContainer.statusLabel.text = rule.title()
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

        startGame()
    }

    // MARK: - Custom

    func startGame() {
        deck.shuffle()
        nextRound()
    }

    func nextRound() {
        if let card = deck.draw() {
            if rules.count > 0 {
                // Update gui buttons for next question.
                rule = rules.removeFirst()
                round = Round(card: card, rule: rule)
            } else {
                print("Pyramid")
                // TODO: Design pyramid rounds.
            }
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
            default:
                player.choice = PlayerChoices.SAME
            }

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

    // MARK: - Selectors

    func closeButton(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
