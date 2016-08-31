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
    @IBOutlet weak var guessTheCardChoiceButton: UIButton!

    // Instance variables
    weak var delegate: ButtonViewDelegate?
    var buttons: [UIButton]!

    // IBActions
    @IBAction func choiceTapped(sender: UIButton) {
        hideButtonsExcept(sender)
        delegate?.buttonViewUpdatePlayerChoice(sender.titleLabel?.text)
    }

    var enabled = true {
        didSet {
            for button in buttons {
                button.enabled = enabled
            }
        }
    }

    // Custom

    func customizeButtons() {
        buttons = [firstChoiceButton, secondChoiceButton,
            thirdChoiceButton, fourthChoiceButton, guessTheCardChoiceButton]
        for button in buttons {
            button.layer.borderWidth = 4
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.cornerRadius = 10
        }
        // Customize the guess button.
        let margin = CGFloat(8.0)
        let buttonHeight = (frame.height * (2.0 / 5.0)) - (2 * margin)
        let buttonWidth = frame.width - (2 * margin)
        guessTheCardChoiceButton.layer.frame = CGRect(x: margin,
            y: frame.height - buttonHeight,
            width: buttonWidth,
            height: buttonHeight)
        guessTheCardChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        guessTheCardChoiceButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }

    func hideButtonsExcept(button: UIButton) {
        for choiceButton in buttons {
            if choiceButton != button {
                choiceButton.hidden = true
            }
        }
    }

    func setButtonImages(choices: [String?]) {
        for i in 0.stride(to: choices.count, by: 1) {
            buttons[i].setImage((choices[i] != nil) ?
                UIImage(named: choices[i]!) : nil, forState: .Normal)
            buttons[i].setImage((choices[i] != nil) ?
                UIImage(named: choices[i]!) : nil, forState: .Disabled)
            buttons[i].imageView!.contentMode = .ScaleAspectFit
        }
    }

    func setButtonTitles(choices: [String?]) {
        for i in 0.stride(to: choices.count, by: 1) {
            if (choices[i] != nil) {
                buttons[i].setTitle(choices[i], forState: .Normal)
            } else {
                buttons[i].hidden = true
            }
        }
    }

    func setButtonFrames(total: Int) {
        let margin = CGFloat(8.0) // Add margin to inset from border.
        switch (total) {
        case 1:
            // Fit one button.
            buttons[1].layer.frame = CGRect(x: margin,
                y: margin,
                width: frame.width - (2 * margin),
                height: frame.height - margin - guessTheCardChoiceButton.layer.frame.height)
            break
        case 2:
            let buttonHeight = frame.height - (2 * margin) - guessTheCardChoiceButton.layer.frame.height
            let buttonWidth = (0.5 * frame.width) - (2 * margin)
            // Fit two buttons.
            buttons[0].layer.frame = CGRect(x: margin, y: margin,
                width: buttonWidth,
                height: buttonHeight)
            buttons[1].layer.frame = CGRect(x: (frame.width / 2) + margin, y: margin,
                width: buttonWidth,
                height: buttonHeight)
            break
        case 3:
            let buttonHeight = frame.height - margin - guessTheCardChoiceButton.layer.frame.height
            let buttonWidth = (frame.width / 3.0) - (3 * margin)
            // Fit three buttons.
            buttons[0].layer.frame = CGRect(
                x: margin,
                y: 0,
                width: buttonWidth,
                height: buttonHeight)
            buttons[1].layer.frame = CGRect(
                x: (0.333 * frame.width) + margin,
                y: 0,
                width: buttonWidth,
                height: buttonHeight)
            buttons[2].layer.frame = CGRect(
                x: (0.666 * frame.width) + margin,
                y: 0,
                width: buttonWidth,
                height: buttonHeight)
            break
        case 4:
            // Fit four buttons.
            let buttonHeight = (frame.height / 2.0) - (guessTheCardChoiceButton.layer.frame.height / 2.0)
            let buttonWidth = (frame.width / 2.0) - (4 * margin)

            /*
             * SUIT BUTTONS LAYOUT
             *
             * 1 | 4
             * - . -
             * 2 | 3
             *
             */
            buttons[0].layer.frame = CGRect(
                x: (frame.width / 4.0) - (buttonWidth / 2.0),
                y: 0,
                width: buttonWidth, height: buttonHeight)
            buttons[1].layer.frame = CGRect(
                x: (frame.width / 4.0) - (buttonWidth / 2.0),
                y: (0.333 * frame.height), // + margin,
                width: buttonWidth, height: buttonHeight)
            buttons[3].layer.frame = CGRect(
                x: (0.75 * frame.width) - (buttonWidth / 2.0),
                y: 0,
                width: buttonWidth, height: buttonHeight)
            buttons[2].layer.frame = CGRect(
                x: (0.75 * frame.width) - (buttonWidth / 2.0),
                y: (0.333 * frame.height), // + margin,
                width: buttonWidth, height: buttonHeight)
            guessTheCardChoiceButton.layer.frame = CGRect(
                x: guessTheCardChoiceButton.layer.frame.origin.x,
                y: guessTheCardChoiceButton.layer.frame.origin.y + margin,
                width: guessTheCardChoiceButton.layer.frame.width,
                height: (0.333 * frame.height))
            break
        default:
            break
        }
    }

    func setButtonsFor(round: Round) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }

//            let buttons = [strongSelf.firstChoiceButton,
//                strongSelf.secondChoiceButton, strongSelf.thirdChoiceButton,
//                strongSelf.fourthChoiceButton, strongSelf.guessTheCardChoiceButton]

            for button in strongSelf.buttons {
                // Make all buttons visible.
                button.hidden = false
                // Set autoresize on.
                button.translatesAutoresizingMaskIntoConstraints = true
            }

            // Set button titles based on round rule.
            switch (round.rule) {
            case .COLOR:
                // Set smoke or fire images.
                strongSelf.setButtonImages(["smoke", "fire", nil, nil])
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.setButtonTitles([ChoicesText.BLACK.rawValue,
                    ChoicesText.RED.rawValue, nil, nil])
                strongSelf.setButtonFrames(2)
                break
            case .UP_DOWN:
                // Set higher or lower images.
                strongSelf.setButtonImages(["up", "equal", "down", nil])
                // "Higher or lower?" choices: Higher, Same, Lower
                strongSelf.setButtonTitles([ChoicesText.HIGHER.rawValue,
                    ChoicesText.SAME.rawValue,
                    ChoicesText.LOWER.rawValue, nil])
                strongSelf.setButtonFrames(3)
                break
            case .IN_OUT:
                // Set inside or outside images.
                strongSelf.setButtonImages(["inside", "equal", "outside"])
                // "Inside or outside?" choices: Inside, Same, Outside
                strongSelf.setButtonTitles([ChoicesText.INSIDE.rawValue, ChoicesText.SAME.rawValue,
                    ChoicesText.OUTSIDE.rawValue, nil])
                strongSelf.setButtonFrames(3)

                break
            case .SUIT:
                // Set suit images.
                strongSelf.setButtonImages(["spade", "heart", "club", "diamond"])
                // "Which suit?" choices: Club, Diamond, Heart, Spade
                strongSelf.setButtonTitles([ChoicesText.SPADE.rawValue, ChoicesText.HEART.rawValue,
                    ChoicesText.CLUB.rawValue, ChoicesText.DIAMOND.rawValue])
                strongSelf.setButtonFrames(4)
                break
            case .POKER:
                // TODO - develop poker hand evaluator and poker results user interface.
                break
            case .GIVE, .TAKE:
                // Set pyramid image.
                strongSelf.setButtonImages([nil, "flip", nil, nil])
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.setButtonTitles([nil, ChoicesText.PYRAMID.rawValue, nil, nil])
                strongSelf.setButtonFrames(1)
                break
            }
        }
    }

}
