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
    @IBOutlet weak var pickerView: UIPickerView!

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

        // Customize player picker.
        pickerView.layer.borderWidth = 4
        pickerView.layer.borderColor = UIColor.whiteColor().CGColor
        pickerView.layer.cornerRadius = 10
        pickerView.selectRow(totalPlayers - 1, inComponent: 0, animated: false)

    }

    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "gameSegue" {
            let gvc = segue.destinationViewController as! GameViewController
            gvc.totalPlayers = totalPlayers
        }
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8 // Maximum possible players
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        totalPlayers = row + 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = "\(row + 1)"
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: "AmericanTypewriter-Bold"])
    }
}
