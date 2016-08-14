//
//  StatusView.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/12/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class StatusView: UIView {

    // MARK: - Constant Variables

    private let WIDTH_UNITS = 18.0
    private let HEIGHT_UNITS = 8.0

    // MARK: - UI Variables

    var statusButton: UIButton!
    var statusLabel: UILabel!

    // MARK: - Instance Variables

    private var viewsDictionary: [String: AnyObject]!

    // MARK: - UI View

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGrayColor()

        // Setup status button.
        statusButton = UIButton(frame: CGRect(
            x: CGFloat(1.0 / WIDTH_UNITS) * frame.width,
            y: CGFloat(1.0 / HEIGHT_UNITS) * frame.height,
            width: CGFloat(5.0 / WIDTH_UNITS) * frame.width,
            height: CGFloat(6.0 / HEIGHT_UNITS) * frame.height))
        statusButton.enabled = false
        statusButton.layer.cornerRadius = statusButton.frame.width / 2.5
        statusButton.backgroundColor = .whiteColor()
        statusButton.setTitle("P1", forState: .Normal)
        statusButton.setTitleColor(.blackColor(), forState: .Normal)
        statusButton.titleLabel!.textAlignment = .Center
        addSubview(statusButton)

        // Setup status label.
        statusLabel = UILabel(frame: CGRect(
            x: CGFloat(7.0 / WIDTH_UNITS) * frame.width,
            y: CGFloat(1.0 / HEIGHT_UNITS) * frame.height,
            width: CGFloat(10.0 / WIDTH_UNITS) * frame.width,
            height: CGFloat(6.0 / HEIGHT_UNITS) * frame.height))
        statusLabel.textAlignment = .Center
        statusLabel.text = Rule.COLOR.title()
        addSubview(statusLabel)

        viewsDictionary = ["statusButton": statusButton, "statusLabel": statusLabel]

        // Apply horizontal constraints.
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[statusButton][statusLabel]|", options: [], metrics: nil, views: viewsDictionary))

        // Apply vertical constraints.
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[statusButton]|", options: [], metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[statusLabel]", options: [], metrics: nil, views: viewsDictionary))

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
