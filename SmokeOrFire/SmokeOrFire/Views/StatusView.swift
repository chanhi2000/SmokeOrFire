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
        statusButton = UIButton(frame: CGRect(
            x: CGFloat(1.0 / WIDTH_UNITS) * frame.width,
            y: CGFloat(1.0 / HEIGHT_UNITS) * frame.height,
            width: CGFloat(5.0 / WIDTH_UNITS) * frame.width,
            height: CGFloat(5.0 / WIDTH_UNITS) * frame.width))
        statusButton.enabled = false
        statusButton.layer.cornerRadius = statusButton.frame.width / 2
        statusButton.backgroundColor = .whiteColor()
        statusButton.setTitle("P1", forState: .Normal)
        statusButton.setTitleColor(.blackColor(), forState: .Normal)
        statusButton.titleLabel!.textAlignment = .Center
        statusButton.titleLabel!.font = UIFont(name: "AmericanTypewriter-Bold", size: 28)
        statusButton.titleLabel!.numberOfLines = 1
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
            y: CGFloat(1.5 / HEIGHT_UNITS) * frame.height,
            width: CGFloat(10.0 / WIDTH_UNITS) * frame.width,
            height: CGFloat(5.5 / HEIGHT_UNITS) * frame.height))
        statusLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 28)
        statusLabel.numberOfLines = 0
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
}
