//
//  QuestionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import Foundation
import UIKit

protocol QuestionsViewControllerDelegate {
    func qvDidFinish(controller: QuestionsViewController, text: String)
}

class QuestionsViewController: UIViewController, PyramidViewControllerDelegate {

    var delegate: QuestionsViewControllerDelegate? = nil

    var numPlayer = 2
    var choices = [PlayerChoices.RED, PlayerChoices.HIGHER, PlayerChoices.OUTSIDE, PlayerChoices.DIAMOND];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var deck = Deck()
        deck.shuffle()
        var p = [Player]()
        for i in 0..<self.numPlayer {
            p.append(Player(number: i))
        }

        let rounds = [Rule.COLOR, Rule.UP_DOWN, Rule.IN_OUT, Rule.SUIT]
        var round: Round
        for i in 0..<rounds.count {
            let rule = rounds[i]
            // Player 1
            for j in 0..<self.numPlayer {
                if let card = deck.draw() {
                    round = Round(card: card, rule: rule)
                    print("Round \(i + 1)")
                    print("Rule: \(rule)")
                    print(p[j])
                    p[j].setChoice(choices[i])
                    print("Your Choice is: \(p[j].choice!)")
                    print("Player \(j) has to drink: \(round.isDrinking(p[j]))")
                    print("Because the card was: \(card.describe())");
                    p[j].addCard(round.card)
                } else {
                    print("Out of cards")
                    break
                }
            }

        }
        print("GAME OVER")
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
        }
    }

    func pvDidFinish(controller: PyramidViewController, text: String) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
