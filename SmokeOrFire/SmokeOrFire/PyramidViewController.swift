//
//  PyramidViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

//
//  PyramidViewController.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

protocol PyramidViewControllerDelegate {
    func pvDidFinish(controller: PyramidViewController, text: String)
}

class PyramidViewController: UIViewController {
    
    var delegate: PyramidViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        //        navigationController?.popViewControllerAnimated(true)
        //        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        //        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let ac = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
        //        removeFromParentViewController()
        //        navigationController?.popViewControllerAnimated(true)
        //        navigationController?.popToRootViewControllerAnimated(true)
//        dismissViewControllerAnimated(true, completion: nil)
        if (delegate != nil) {
            delegate!.pvDidFinish(self, text: "Finished")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
