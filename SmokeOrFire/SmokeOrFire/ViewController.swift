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

    var totalPlayers = 2

    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "optionSegue" {
            let ovc = segue.destinationViewController as! OptionsViewController
            ovc.delegate = self
            ovc.totalPlayers = totalPlayers
        } else if segue.identifier == "questionSegue" {
            let qvc = segue.destinationViewController as! QuestionsViewController
            qvc.totalPlayers = totalPlayers
        }
    }
}

// MARK: - OptionsViewControllerDelegate
extension ViewController: OptionsViewControllerDelegate {
    func optionsViewUpdateTotalPlayers(count: Int) {
        totalPlayers = count
    }
}
