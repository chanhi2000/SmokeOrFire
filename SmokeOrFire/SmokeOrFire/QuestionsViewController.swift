//
//  QuestionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

protocol QuestionsViewControllerDelegate {
    func qvDidFinish(controller: QuestionsViewController, text: String)
}

class QuestionsViewController: UIViewController { //, PyramidViewControllerDelegate {

    // MARK: - IBOutlet variables

    @IBOutlet weak var firstChoice: UIButton!
    @IBOutlet weak var secondChoice: UIButton!
    @IBOutlet weak var thirdChoice: UIButton!
    @IBOutlet weak var fourthChoice: UIButton!

    // MARK: - Constant variables

    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

    // MARK: - Instance variables

    var delegate: QuestionsViewControllerDelegate!
    var players: [Player]!
    var round: Round!
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
                nextRound()
            } else {
                // Update everything for next player.
                player = players[playerIndex]
                if let card = deck.draw() {
                    // Update round user interface.
                    round.card = card
                    setChoices()
                } else {
                    // Deck ran out of cards.
                    gameOver()
                }
            }
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (players != nil) {
            startGame()
        }
    }

    // MARK: - IBAction

    @IBAction func choiceTapped(sender: UIButton) {
        if let text = sender.titleLabel!.text {
            
            switch (text) {
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
            ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: { [unowned self] in
                // Update player variables before next round.
                self.player.hand.append(self.round.card)
                self.playerIndex += 1
            })
        }
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "pyramidSegue" {
//            let pvc = segue.destinationViewController as! PyramidViewController
//            pvc.delegate = self
//            pvc.createPyramid(deck, levels: [1, 2, 3, 3, 4, 4])
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
                round = Round(card: card, rule: rules.removeFirst())
                setChoices()
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

    func setChoices() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in

            // Make all buttons visible.
            self.firstChoice.hidden = false
            self.secondChoice.hidden = false
            self.thirdChoice.hidden = false
            self.fourthChoice.hidden = false

            // Set button titles based on round rule.
            switch (self.round.rule) {
                case .COLOR:
                    // "Smoke or Fire?" choices: Black, Red
                    self.firstChoice.setTitle(ChoicesText.BLACK.rawValue, forState: .Normal)
                    self.secondChoice.setTitle(ChoicesText.RED.rawValue, forState: .Normal)
                    self.thirdChoice.hidden = true
                    self.fourthChoice.hidden = true
                    break
                case .UP_DOWN:
                    // "Higher or lower?" choices: Higher, Same, Lower
                    self.firstChoice.setTitle(ChoicesText.HIGHER.rawValue, forState: .Normal)
                    self.secondChoice.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                    self.thirdChoice.setTitle(ChoicesText.LOWER.rawValue, forState: .Normal)
                    self.fourthChoice.hidden = true
                    break
                case .IN_OUT:
                    // "Inside or outside?" choices: Inside, Same, Outside
                    self.firstChoice.setTitle(ChoicesText.INSIDE.rawValue, forState: .Normal)
                    self.secondChoice.setTitle(ChoicesText.OUTSIDE.rawValue, forState: .Normal)
                    self.thirdChoice.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                    self.fourthChoice.hidden = true
                    break
                case .SUIT:
                    // "Which suit?" choices: Club, Diamond, Heart, Spade
                    self.firstChoice.setTitle(ChoicesText.CLUB.rawValue, forState: .Normal)
                    self.secondChoice.setTitle(ChoicesText.DIAMOND.rawValue, forState: .Normal)
                    self.thirdChoice.setTitle(ChoicesText.HEART.rawValue, forState: .Normal)
                    self.fourthChoice.setTitle(ChoicesText.SPADE.rawValue, forState: .Normal)
                case .POKER:
                    // TODO - develop poker hand evaluator and poker results user interface.
                    break
                case .GIVE:
                    break
                case .TAKE:
                    break
            }
        }
    }

    func gameOver() {
        print("Game over")
    }
}
