//
//  ViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!

    var totalPlayers = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize navigation bar.
        navigationController!.navigationBar.tintColor = .whiteColor()
        navigationController!.navigationBar.barTintColor = .blackColor()

        // Customize play button.
        playButton.layer.borderWidth = 4
        playButton.layer.borderColor = UIColor.whiteColor().CGColor
        playButton.layer.cornerRadius = 10

        // Customize option button.
        optionButton.layer.borderWidth = 4
        optionButton.layer.borderColor = UIColor.whiteColor().CGColor
        optionButton.layer.cornerRadius = 10
    }

    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "optionSegue" {
            let ovc = segue.destinationViewController as! OptionsViewController
            ovc.delegate = self
            ovc.totalPlayers = totalPlayers
        } else if segue.identifier == "gameSegue" {
            let gvc = segue.destinationViewController as! GameViewController
            gvc.totalPlayers = totalPlayers
        }
    }
}

// MARK: - OptionsViewControllerDelegate
extension ViewController: OptionsViewControllerDelegate {
    func optionsViewUpdateTotalPlayers(count: Int) {
        totalPlayers = count
    }
}
