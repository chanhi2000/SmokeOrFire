//
//  StatusView.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/12/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class StatusView: UIView {

    // Constant Variables
    private let WIDTH_UNITS = 18.0
    private let HEIGHT_UNITS = 8.0

    // MARK: - UI Variables
    var statusButton: UIButton!
    var statusLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGrayColor()

        // Setup status button.
        let minDim = min(CGFloat(5.0 / WIDTH_UNITS) * frame.width,
            CGFloat(5.0 / HEIGHT_UNITS) * frame.height)
        statusButton = UIButton(frame: CGRect(
            x: CGFloat(1.0 / WIDTH_UNITS) * frame.width,
            y: CGFloat(1.0 / HEIGHT_UNITS) * frame.height,
            width: minDim, height: minDim))
        statusButton.contentMode = .ScaleAspectFit
        statusButton.layer.cornerRadius = minDim / 2
        statusButton.backgroundColor = .whiteColor()
        statusButton.setTitle("P1", forState: .Normal)
        statusButton.setTitleColor(.blackColor(), forState: .Normal)
        statusButton.titleLabel!.textAlignment = .Center
        statusButton.titleLabel!.font = UIFont(name: "AmericanTypewriter-Bold", size: 28)
        statusButton.titleLabel!.numberOfLines = 1
        statusButton.titleLabel!.adjustsFontSizeToFitWidth = true
        addSubview(statusButton)
        // Apply status button constraints.
        addConstraint(NSLayoutConstraint(item: statusButton, attribute: .Width,
            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: statusButton.frame.width))
        addConstraint(NSLayoutConstraint(item: statusButton, attribute: .Height,
            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: statusButton.frame.height))

        // Setup status label.
        statusLabel = UILabel(frame: CGRect(
            x: CGFloat(7.0 / WIDTH_UNITS) * frame.width,
            y: CGFloat(1.0 / HEIGHT_UNITS) * frame.height,
            width: CGFloat(10.0 / WIDTH_UNITS) * frame.width,
            height: CGFloat(5.0 / HEIGHT_UNITS) * frame.height))
        statusLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 28)
        statusLabel.numberOfLines = 0
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textAlignment = .Center
        statusLabel.text = Rule.COLOR.title()
        statusLabel.textColor = .whiteColor()
        addSubview(statusLabel)
        // Apply status label constraints.
        addConstraint(NSLayoutConstraint(item: statusLabel, attribute: .Width,
            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: statusLabel.frame.width))
        addConstraint(NSLayoutConstraint(item: statusLabel, attribute: .Height,
            relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: statusLabel.frame.height))

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func clear() {
        statusButton.setImage(nil, forState: .Normal)
        statusButton.setTitle("", forState: .Normal)
        statusLabel.text = ""
    }

}
