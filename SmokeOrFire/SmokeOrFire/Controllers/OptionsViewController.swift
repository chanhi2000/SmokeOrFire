//
//  OptionsViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/9/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

protocol OptionsViewControllerDelegate {
    func optionsViewUpdateTotalPlayers(count: Int)
}

class OptionsViewController: UIViewController {

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!

    var delegate: OptionsViewControllerDelegate?

    var totalPlayers: Int = 2 {
        didSet {
            playerLabel?.text = "Players: \(totalPlayers)"
            delegate?.optionsViewUpdateTotalPlayers(totalPlayers)
        }
    }

    override func loadView() {
        super.loadView()
        // Update player slider based on parent view controller.
        playerSlider.value = Float(totalPlayers)
        updatePlayerCount([])
    }

    @IBAction func updatePlayerCount(sender: AnyObject) {
        totalPlayers = Int(roundf(playerSlider.value) * 1)
    }
}
