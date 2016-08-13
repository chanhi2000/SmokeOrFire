//
//  ButtonContainer.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/10/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

protocol ButtonContainerDelegate {
    func buttonContainerUpdatePlayerChoice(text: String?)
}

class ButtonContainer: UIView {

    // MARK: - IBOutlets
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!

    // MARK: - Private variables
    private var viewsDictionary: [String: UIButton]! // Used to design Visual Format constraints.

    // MARK: - Instance variables
    var delegate: ButtonContainerDelegate!

    // MARK: - IBActions

    @IBAction func choiceTapped(sender: UIButton) {
        delegate.buttonContainerUpdatePlayerChoice(sender.titleLabel?.text)
    }

    // MARK: - Custom

    // TODO: - Figure out how to refactor this method that minimizes redundancy.
    // One idea is to separate the case code blocks into separate methods
    // TODO: - Research if attributes can be set for a list of UIButtons.
    func setButtonsFor(round: Round) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }

            // Make all buttons visible.
            strongSelf.firstChoiceButton.hidden = false
            strongSelf.secondChoiceButton.hidden = false
            strongSelf.thirdChoiceButton.hidden = false
            strongSelf.fourthChoiceButton.hidden = false

            // Set Autoresize on.
            strongSelf.firstChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            strongSelf.secondChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            strongSelf.thirdChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            strongSelf.fourthChoiceButton.translatesAutoresizingMaskIntoConstraints = true

            // Set button titles based on round rule.
            switch (round.rule) {
            case .COLOR:
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.firstChoiceButton.setTitle(ChoicesText.BLACK.rawValue, forState: .Normal)
                strongSelf.secondChoiceButton.setTitle(ChoicesText.RED.rawValue, forState: .Normal)
                strongSelf.thirdChoiceButton.hidden = true
                strongSelf.fourthChoiceButton.hidden = true

                // Fit two buttons.
                strongSelf.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: 0.5 * strongSelf.frame.width, height: strongSelf.frame.height)
                strongSelf.secondChoiceButton.layer.frame = CGRect(x: strongSelf.frame.width / 2, y: 0.0,
                    width: strongSelf.frame.width / 2, height: strongSelf.frame.height)

                break
            case .UP_DOWN:
                // "Higher or lower?" choices: Higher, Same, Lower
                strongSelf.firstChoiceButton.setTitle(ChoicesText.HIGHER.rawValue, forState: .Normal)
                strongSelf.secondChoiceButton.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                strongSelf.thirdChoiceButton.setTitle(ChoicesText.LOWER.rawValue, forState: .Normal)
                strongSelf.fourthChoiceButton.hidden = true

                // Fit three buttons.
                strongSelf.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)
                strongSelf.secondChoiceButton.layer.frame = CGRect(x: 0.333 * strongSelf.frame.width, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)
                strongSelf.thirdChoiceButton.layer.frame = CGRect(x: 0.666 * strongSelf.frame.width, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)

                break
            case .IN_OUT:
                // "Inside or outside?" choices: Inside, Same, Outside
                strongSelf.firstChoiceButton.setTitle(ChoicesText.INSIDE.rawValue, forState: .Normal)
                strongSelf.secondChoiceButton.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                strongSelf.thirdChoiceButton.setTitle(ChoicesText.OUTSIDE.rawValue, forState: .Normal)
                strongSelf.fourthChoiceButton.hidden = true

                // Fit three buttons.
                strongSelf.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)
                strongSelf.secondChoiceButton.layer.frame = CGRect(x: 0.333 * strongSelf.frame.width, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)
                strongSelf.thirdChoiceButton.layer.frame = CGRect(x: 0.666 * strongSelf.frame.width, y: 0.0,
                    width: strongSelf.frame.width / 3.0, height: strongSelf.frame.height)

                break
            case .SUIT:
                // "Which suit?" choices: Club, Diamond, Heart, Spade
                strongSelf.firstChoiceButton.setTitle(ChoicesText.CLUB.rawValue, forState: .Normal)
                strongSelf.secondChoiceButton.setTitle(ChoicesText.DIAMOND.rawValue, forState: .Normal)
                strongSelf.thirdChoiceButton.setTitle(ChoicesText.HEART.rawValue, forState: .Normal)
                strongSelf.fourthChoiceButton.setTitle(ChoicesText.SPADE.rawValue, forState: .Normal)

                // Fit four buttons in a grid.
                let buttonWidth = strongSelf.frame.width / 2.0
                let buttonHeight = strongSelf.frame.height / 2.0

                /*
                 * SUIT BUTTONS LAYOUT
                 *
                 * 1 | 3
                 * - . -
                 * 2 | 4
                 *
                */
                strongSelf.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: buttonWidth, height: buttonHeight)
                strongSelf.secondChoiceButton.layer.frame = CGRect(x: 0.0, y: strongSelf.frame.height / 2.0,
                    width: buttonWidth, height: buttonHeight)
                strongSelf.thirdChoiceButton.layer.frame = CGRect(x: strongSelf.frame.width / 2.0, y: 0.0,
                    width: buttonWidth, height: buttonHeight)
                strongSelf.fourthChoiceButton.layer.frame = CGRect(x: strongSelf.frame.width / 2.0, y: strongSelf.frame.height / 2.0,
                    width: buttonWidth, height: buttonHeight)

                break
            case .POKER:
                // TODO - develop poker hand evaluator and poker results user interface.
                break
            case .GIVE, .TAKE:
                // "Smoke or Fire?" choices: Black, Red
                strongSelf.firstChoiceButton.setTitle(ChoicesText.PYRAMID.rawValue, forState: .Normal)
                strongSelf.secondChoiceButton.hidden = true
                strongSelf.thirdChoiceButton.hidden = true
                strongSelf.fourthChoiceButton.hidden = true

                // Fit one button.
                strongSelf.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: strongSelf.frame.width, height: strongSelf.frame.height)
                break
            }
        }
    }
}
