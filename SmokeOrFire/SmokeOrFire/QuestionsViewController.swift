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

class QuestionsViewController: UIViewController, PyramidViewControllerDelegate {

    @IBOutlet weak var firstChoice: UIButton!
    @IBOutlet weak var secondChoice: UIButton!
    @IBOutlet weak var thirdChoice: UIButton!
    @IBOutlet weak var fourthChoice: UIButton!

    var delegate: QuestionsViewControllerDelegate? = nil
    var players = [Player(number: 1), Player(number: 2)]

    var deck: Deck = Deck()

    var round = Round(card: Card(rank: .ACE, suit: .SPADE), rule: .COLOR)
    var rules = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]

    var player: Player? {
        didSet {
            title = "Player \(playerIndex + 1)"
        }
    }
    var playerIndex: Int = 0 {
        didSet {
            if playerIndex >= players.count {
                playerIndex = 0
                player = players[playerIndex]
                nextRound()
            } else {
                player = players[playerIndex]
                if let card = deck.draw() {
                    round.card = card
                    setChoices(round)
                } else {
                    gameOver()
                }
            }
        }
    }

//    var numPlayer = 2
//    var choices = [PlayerChoices.RED, PlayerChoices.HIGHER, PlayerChoices.OUTSIDE, PlayerChoices.DIAMOND];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame()

//        var p = [Player]()
//        for i in 0..<self.numPlayer {
//            p.append(Player(number: i))
//        }
//
//        let rounds = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
//        var round: Round
//        for i in 0..<rounds.count {
//            let rule = rounds[i]
//            // Player 1
//            for j in 0..<self.numPlayer {
//                if let card = deck.draw() {
//                    round = Round(card: card, rule: rule)
//                    print("Round \(i + 1)")
//                    print("Rule: \(rule)")
//                    print(p[j])
//                    p[j].setChoice(choices[i])
//                    print("Your Choice is: \(p[j].choice!)")
//                    print("Player \(j) has to drink: \(round.isDrinking(p[j]))")
//                    print("Because the card was: \(card.describe())");
//                    p[j].addCard(round.card)
//                } else {
//                    print("Out of cards")
//                    break
//                }
//            }
//
//        }
//        print("GAME OVER")
    }

    @IBAction func choiceTapped(sender: UIButton) {
        if let text = sender.titleLabel!.text {
            
            switch (text) {
            case ChoicesText.RED.rawValue:
                player!.choice = PlayerChoices.RED
                break
            case ChoicesText.BLACK.rawValue:
                player!.choice = PlayerChoices.BLACK
                break
            case ChoicesText.HIGHER.rawValue:
                player!.choice = PlayerChoices.HIGHER
                break
            case ChoicesText.LOWER.rawValue:
                player!.choice = PlayerChoices.LOWER
                break
            case ChoicesText.INSIDE.rawValue:
                player!.choice = PlayerChoices.INSIDE
                break
            case ChoicesText.OUTSIDE.rawValue:
                player!.choice = PlayerChoices.OUTSIDE
                break
            case ChoicesText.SAME.rawValue:
                player!.choice = PlayerChoices.SAME
                break
            case ChoicesText.HEART.rawValue:
                player!.choice = PlayerChoices.HEART
                break
            case ChoicesText.CLUB.rawValue:
                player!.choice = PlayerChoices.CLUB
                break
            case ChoicesText.DIAMOND.rawValue:
                player!.choice = PlayerChoices.DIAMOND
                break
            case ChoicesText.SPADE.rawValue:
                player!.choice = PlayerChoices.SPADE
                break
            default:
                player!.choice = PlayerChoices.SAME
            }

            let msg = (round.card.describe() + "\n") +
                (round.isDrinking(player!) ? "DRINK" : "YOU WIN THIS TIME")
            let ac = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: { [unowned self] in
                self.player!.hand.append(self.round.card)
                self.playerIndex += 1
            })
        }
    }

    @IBAction func handTapped(sender: UIButton) {
        let ac = UIAlertController(title: title, message: "Hand", preferredStyle: .Alert)
        for card in player!.hand {
            ac.addAction(UIAlertAction(title: card.describe(), style: .Default, handler: nil))
        }
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    
    func startGame() {
        player = players[0]
        deck.shuffle()
        nextRound()
    }
    
    func gameOver() {
        print("Game over")
    }

    func nextRound() {
        if let card = deck.draw() {
            if rules.count > 0 {
                let rule = rules.removeFirst()
                round = Round(card: card, rule: rule)
                setChoices(round)
            } else {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.performSegueWithIdentifier("pyramidSegue", sender: nil)
                }
            }
        } else {
            gameOver()
        }
    }

    func setChoices(round: Round) {
        // Make all buttons visible.
        firstChoice.hidden = false
        secondChoice.hidden = false
        thirdChoice.hidden = false
        fourthChoice.hidden = false

        switch (round.rule) {
            case .COLOR:
                firstChoice.setTitle(ChoicesText.BLACK.rawValue, forState: .Normal)
                secondChoice.setTitle(ChoicesText.RED.rawValue, forState: .Normal)
                thirdChoice.hidden = true
                fourthChoice.hidden = true
                break
            case .UP_DOWN:
                firstChoice.setTitle(ChoicesText.HIGHER.rawValue, forState: .Normal)
                secondChoice.setTitle(ChoicesText.LOWER.rawValue, forState: .Normal)
                thirdChoice.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                fourthChoice.hidden = true
                break
            case .IN_OUT:
                firstChoice.setTitle(ChoicesText.INSIDE.rawValue, forState: .Normal)
                secondChoice.setTitle(ChoicesText.OUTSIDE.rawValue, forState: .Normal)
                thirdChoice.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                fourthChoice.hidden = true
                break
            case .SUIT:
                firstChoice.setTitle(ChoicesText.HEART.rawValue, forState: .Normal)
                secondChoice.setTitle(ChoicesText.CLUB.rawValue, forState: .Normal)
                thirdChoice.setTitle(ChoicesText.DIAMOND.rawValue, forState: .Normal)
                fourthChoice.setTitle(ChoicesText.SPADE.rawValue, forState: .Normal)
            case .POKER:
                break
            case .GIVE:
                break
            case .TAKE:
                break
        }
    }

    func input() -> PlayerChoices {

        var choice: String = ""

        let ac = UIAlertController(title: "Input", message: "Let's get it!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            let field = ac.textFields![0] as UITextField
            choice = field.text!
            })
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        ac.addTextFieldWithConfigurationHandler({(txtField: UITextField!) in
            txtField.placeholder = "Input here"
        })
        self.presentViewController(ac, animated: true, completion: nil)

        switch choice {
        case "1":  return PlayerChoices.HEART
        case "2":  return PlayerChoices.CLUB
        case "3":  return PlayerChoices.DIAMOND
        case "4":  return PlayerChoices.SPADE
        case "r":  return PlayerChoices.RED
        case "b":  return PlayerChoices.BLACK
        case "h":  return PlayerChoices.HIGHER
        case "l":  return PlayerChoices.LOWER
        case "i":  return PlayerChoices.INSIDE
        case "o":  return PlayerChoices.OUTSIDE
        case "s":  return PlayerChoices.SAME
        default:   return input()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "pyramidSegue" {
            let pvc = segue.destinationViewController as! PyramidViewController
            pvc.delegate = self
            pvc.createPyramid(deck, levels: [1, 2, 3, 3, 4, 4])
        }
    }

    func pvDidFinish(controller: PyramidViewController, text: String) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
