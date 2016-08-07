//
//  ViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, QuestionsViewControllerDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "questionsSegue" {
            let qvc = segue.destinationViewController as! QuestionsViewController
            qvc.delegate = self
        }
    }
    
    func qvDidFinish(controller: QuestionsViewController, text: String) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
}