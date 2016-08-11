//
//  QuestionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import iAd
import UIKit

class QuestionsViewController: UIViewController, ADBannerViewDelegate, ButtonContainerDelegate { //, PyramidViewControllerDelegate {

    // MARK: - UI variables

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonContainer: ButtonContainer!
    @IBOutlet weak var bannerView: ADBannerView!

    // MARK: - Constant variables

    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

    // MARK: - Instance variables

    var viewsDictionary: [String: AnyObject]! // Used to design Visual Format constraints.

    var players: [Player]!

    var round: Round! {
        didSet {
            buttonContainer.setButtonsFor(round)
        }
    }

    var roundIndex: Int = 0 {
        didSet {
            statusLabel.text = "Round: \(roundIndex + 1)"
        }
    }

    var deck: Deck = Deck()

    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]

    // MARK: - Property inspectors

    var player: Player! {
        didSet {
            title = "Player \(playerIndex + 1)"
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

    var rule: Rule! {
        didSet {
            questionLabel.text = rule.title()
        }
    }

    var totalPlayers: Int! {
        didSet {
            // Initialize players.
            players = [Player]()
            for i in 1 ... totalPlayers {
                players.append(Player(number: i))
            }
            player = players[0]
        }
    }

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonContainer.delegate = self
        startGame()
    }

    // MARK: - Segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "pyramidSegue" {
//            let pvc = segue.destinationViewController as! PyramidViewController
//            pvc.delegate = self
//            pvc.createPyramid(deck, levels: [1, 2, 3, 3, 4, 4])
        }
    }

    // MARK: - Banner View

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

    // MARK: - Button Container

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
            let msg = (round.card.describe() + "\n") +
                (round.isDrinking(player) ? "DRINK" : "YOU WIN THIS TIME")
            let ac = UIAlertController(title: self.title, message: msg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "", style: .Default, handler: nil)
            action.setValue(round.card.frontImage, forKey: "image")
            ac.addAction(action)
            ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: { [unowned self] in
                // Update player variables before next round.
                self.player.hand.append(self.round.card)
                self.playerIndex += 1
            })
        }
    }

    // MARK: - Pyramid View Controller

    func pvDidFinish(controller: PyramidViewController, text: String) {
        controller.navigationController?.popViewControllerAnimated(true)
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
                // Continue to pyramid rounds.
//                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
//                    self.performSegueWithIdentifier("pyramidSegue", sender: nil)
//                }
            }
        } else {
            // Deck ran out of cards.
            gameOver()
        }
    }

    func gameOver() {
        print("Game over")
    }
}
