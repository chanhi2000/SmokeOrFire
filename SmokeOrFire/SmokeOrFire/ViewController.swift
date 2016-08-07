//
//  ViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
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
            
            print("Current cards holding:")
            for j in 0..<self.numPlayer {
                print("Player \(j): ")
                for card in p[j].hand {
                    print(card.describe())
                }
            }
            
        }
        print("GAME OVER")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func input() -> String {
//        var keyboard = NSFileHandle.fileHandleWithStandardInput()
//        var inputData = keyboard.availableData
//        return NSString(data: inputData, encoding: NSUTF8StringEncoding) as! String
//    }
    
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
}