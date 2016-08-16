//
//  ButtonView.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/14/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

protocol ButtonViewDelegate: class {
    func buttonViewUpdatePlayerChoice(text: String?)
}

class ButtonView: UIView {

    // IBOutlets
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!

    // Private variables
    private var viewsDictionary: [String: UIButton]! // Used to design Visual Format constraints.

    // Instance variables
    weak var delegate: ButtonViewDelegate?

    // IBActions
    @IBAction func choiceTapped(sender: UIButton) {
        delegate?.buttonViewUpdatePlayerChoice(sender.titleLabel?.text)
    }

    // Custom

    func customizeButtons() {
        let buttons = [firstChoiceButton, secondChoiceButton,
            thirdChoiceButton, fourthChoiceButton]
        for button in buttons {
            button.layer.borderWidth = 4
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.cornerRadius = 10
        }
    }

    func setButtonTitles(buttons: [UIButton!], choices: [String?]) {
        for i in 0.stride(to: choices.count, by: 1) {
            if (choices[i] != nil) {
                buttons[i].setTitle(choices[i], forState: .Normal)
            } else {
                buttons[i].hidden = true
            }
        }
    }

    func setButtonFrames(buttons: [UIButton!], total: Int) {
        switch (total) {
        case 1:
            // Fit one button.
            buttons[0].layer.frame = CGRect(x: 0.0, y: 0.0,
                width: frame.width, height: frame.height)
            break
        case 2:
            // Fit two buttons.
            buttons[0].layer.frame = CGRect(x: 0.0, y: 0.0,
                width: 0.5 * frame.width, height: frame.height)
            buttons[1].layer.frame = CGRect(x: frame.width / 2, y: 0.0,
                width: frame.width / 2, height: frame.height)
            break
        case 3:
            // Fit three buttons.
            buttons[0].layer.frame = CGRect(x: 0.0, y: 0.0,
                width: frame.width / 3.0, height: frame.height)
            buttons[1].layer.frame = CGRect(x: 0.333 * frame.width, y: 0.0,
                width: frame.width / 3.0, height: frame.height)
            buttons[2].layer.frame = CGRect(
                x: 0.666 * frame.width, y: 0.0,
                width: frame.width / 3.0, height: frame.height)
            break
        case 4:
            // Fit four buttons.
            let buttonWidth = frame.width / 2.0
            let buttonHeight = frame.height / 2.0

            /*
             * SUIT BUTTONS LAYOUT
             *
             * 1 | 3
             * - . -
             * 2 | 4
             *
             */
            buttons[0].layer.frame = CGRect(
                x: 0.0, y: 0.0,
                width: buttonWidth, height: buttonHeight)
            buttons[1].layer.frame = CGRect(
                x: 0.0, y: frame.height / 2.0,
                width: buttonWidth, height: buttonHeight)
            buttons[2].layer.frame = CGRect(
                x: frame.width / 2.0, y: 0.0,
                width: buttonWidth, height: buttonHeight)
            buttons[3].layer.frame = CGRect(
                x: frame.width / 2.0, y: frame.height / 2.0,
                width: buttonWidth, height: buttonHeight)
            break
        default:
            break
        }
    }

    func setButtonsFor(round: Round) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }

            let buttons = [strongSelf.firstChoiceButton,
                strongSelf.secondChoiceButton, strongSelf.thirdChoiceButton,
                strongSelf.fourthChoiceButton]

            for button in buttons {
                // Make all buttons visible.
                button.hidden = false
                // Set autoresize on.
                button.translatesAutoresizingMaskIntoConstraints = true
            }

            // Set button titles based on round rule.
            switch (round.rule) {
            case .COLOR:
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.setButtonTitles(buttons,
                    choices: [ChoicesText.BLACK.rawValue,
                        ChoicesText.RED.rawValue, nil, nil])
                strongSelf.setButtonFrames(buttons, total: 2)
                break
            case .UP_DOWN:
                // "Higher or lower?" choices: Higher, Same, Lower
                strongSelf.setButtonTitles(buttons,
                    choices: [ChoicesText.HIGHER.rawValue,
                        ChoicesText.SAME.rawValue,
                        ChoicesText.LOWER.rawValue, nil])
                strongSelf.setButtonFrames(buttons, total: 3)
                break
            case .IN_OUT:
                // "Inside or outside?" choices: Inside, Same, Outside
                strongSelf.setButtonTitles(buttons,
                    choices: [ChoicesText.INSIDE.rawValue, ChoicesText.SAME.rawValue,
                        ChoicesText.OUTSIDE.rawValue, nil])
                strongSelf.setButtonFrames(buttons, total: 3)

                break
            case .SUIT:
                // "Which suit?" choices: Club, Diamond, Heart, Spade
                strongSelf.setButtonTitles(buttons,
                    choices: [ChoicesText.CLUB.rawValue, ChoicesText.DIAMOND.rawValue,
                        ChoicesText.HEART.rawValue, ChoicesText.SPADE.rawValue])
                strongSelf.setButtonFrames(buttons, total: 4)
                break
            case .POKER:
                // TODO - develop poker hand evaluator and poker results user interface.
                break
            case .GIVE, .TAKE:
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.setButtonTitles(buttons,
                    choices: [ChoicesText.PYRAMID.rawValue, nil, nil, nil])
                strongSelf.setButtonFrames(buttons, total: 1)
                break
            }
        }
    }

}
