//
//  ViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PyramidViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let deck = Deck()
//        let player = Player(number: 1)
//        player.setChoice(.RED)
//        
//        let card = Card(rank: .KING, suit: .HEART)
//        let round = Round(card: card, rule: .COLOR)
//
//        print(round.isDrinking(player))
//        let pvc = PyramidViewController()
//        presentViewController(pvc, animated: true, completion: nil)
//        navigationController?.pushViewController(pvc, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        addChildViewController(PyramidViewController())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "pyramidSegue"{
            let pvc = segue.destinationViewController as! PyramidViewController
            pvc.delegate = self
        }
    }
    
    func pvDidFinish(controller: PyramidViewController, text: String) {
        controller.navigationController?.popViewControllerAnimated(true)
    }

}

