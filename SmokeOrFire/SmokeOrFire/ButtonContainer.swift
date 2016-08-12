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

    // MARK: - IB Outlets

    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!

    // MARK: - Instance variables

    var delegate: ButtonContainerDelegate!

    var viewsDictionary: [String: UIButton]! // Used to design Visual Format constraints.

    // MARK: - UI View

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - IB Actions

    @IBAction func choiceTapped(sender: UIButton) {
        delegate.buttonContainerUpdatePlayerChoice(sender.titleLabel?.text)
    }

    // MARK: - Custom

    func setButtonsFor(round: Round) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in

            // Make all buttons visible.
            self.firstChoiceButton.hidden = false
            self.secondChoiceButton.hidden = false
            self.thirdChoiceButton.hidden = false
            self.fourthChoiceButton.hidden = false

            // Set Autoresize on.
            self.firstChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            self.secondChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            self.thirdChoiceButton.translatesAutoresizingMaskIntoConstraints = true
            self.fourthChoiceButton.translatesAutoresizingMaskIntoConstraints = true

            // Set button titles based on round rule.
            switch (round.rule) {
            case .COLOR:
                // "Smoke or Fire?" choices: Black, Red
                self.firstChoiceButton.setTitle(ChoicesText.BLACK.rawValue, forState: .Normal)
                self.secondChoiceButton.setTitle(ChoicesText.RED.rawValue, forState: .Normal)
                self.thirdChoiceButton.hidden = true
                self.fourthChoiceButton.hidden = true

                // Fit two buttons.
                self.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: 0.5 * self.frame.width, height: self.frame.height)
                self.secondChoiceButton.layer.frame = CGRect(x: self.frame.width / 2, y: 0.0,
                    width: self.frame.width / 2, height: self.frame.height)

                break
            case .UP_DOWN:
                // "Higher or lower?" choices: Higher, Same, Lower
                self.firstChoiceButton.setTitle(ChoicesText.HIGHER.rawValue, forState: .Normal)
                self.secondChoiceButton.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                self.thirdChoiceButton.setTitle(ChoicesText.LOWER.rawValue, forState: .Normal)
                self.fourthChoiceButton.hidden = true

                // Fit three buttons.
                self.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)
                self.secondChoiceButton.layer.frame = CGRect(x: 0.333 * self.frame.width, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)
                self.thirdChoiceButton.layer.frame = CGRect(x: 0.666 * self.frame.width, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)

                break
            case .IN_OUT:
                // "Inside or outside?" choices: Inside, Same, Outside
                self.firstChoiceButton.setTitle(ChoicesText.INSIDE.rawValue, forState: .Normal)
                self.secondChoiceButton.setTitle(ChoicesText.SAME.rawValue, forState: .Normal)
                self.thirdChoiceButton.setTitle(ChoicesText.OUTSIDE.rawValue, forState: .Normal)
                self.fourthChoiceButton.hidden = true

                // Fit three buttons.
                self.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)
                self.secondChoiceButton.layer.frame = CGRect(x: 0.333 * self.frame.width, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)
                self.thirdChoiceButton.layer.frame = CGRect(x: 0.666 * self.frame.width, y: 0.0,
                    width: self.frame.width / 3.0, height: self.frame.height)

                break
            case .SUIT:
                // "Which suit?" choices: Club, Diamond, Heart, Spade
                self.firstChoiceButton.setTitle(ChoicesText.CLUB.rawValue, forState: .Normal)
                self.secondChoiceButton.setTitle(ChoicesText.DIAMOND.rawValue, forState: .Normal)
                self.thirdChoiceButton.setTitle(ChoicesText.HEART.rawValue, forState: .Normal)
                self.fourthChoiceButton.setTitle(ChoicesText.SPADE.rawValue, forState: .Normal)

                // Fit four buttons in a grid.
                let buttonWidth = self.frame.width / 2.0
                let buttonHeight = self.frame.height / 2.0

                /*
                 * SUIT BUTTONS LAYOUT
                 *
                 * 1 | 3
                 * - . -
                 * 2 | 4
                 *
                */
                self.firstChoiceButton.layer.frame = CGRect(x: 0.0, y: 0.0,
                    width: buttonWidth, height: buttonHeight)
                self.secondChoiceButton.layer.frame = CGRect(x: 0.0, y: self.frame.height / 2.0,
                    width: buttonWidth, height: buttonHeight)
                self.thirdChoiceButton.layer.frame = CGRect(x: self.frame.width / 2.0, y: 0.0,
                    width: buttonWidth, height: buttonHeight)
                self.fourthChoiceButton.layer.frame = CGRect(x: self.frame.width / 2.0, y: self.frame.height / 2.0,
                    width: buttonWidth, height: buttonHeight)

                break
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
}
