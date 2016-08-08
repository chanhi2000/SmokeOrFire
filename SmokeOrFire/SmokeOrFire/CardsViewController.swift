//
//  CardsViewController.swift
//  SmokeOrFire
//
//  Created by LeeChan on 8/7/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit
import GameplayKit

class CardsViewController: UIViewController {
    weak var delegate: ViewController!
    
    var front: UIImageView!
    var back: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card = Card(rank: .KING, suit: .CLUB)
        front = UIImageView(image: card.frontTexture)
        back = UIImageView(image: card.backTexture)
        
        view.addSubview(front)
        view.addSubview(back)
        
        front.hidden = true
        back.alpha = 0
        
        UIView.animateWithDuration(0.2) {
            self.back.alpha = 1
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        back.userInteractionEnabled = true
        back.addGestureRecognizer(tap)
        
        performSelector(#selector(wiggle), withObject: nil, afterDelay: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cardTapped() {
//        delegate.cardTapped(self)
    }
    
    func wasTapped() {
        UIView.transitionWithView(view, duration: 0.7, options: [.TransitionFlipFromRight], animations: { [unowned self] in
            self.back.hidden = true
            self.front.hidden = false
            }, completion: nil)
    }
    
    func wasntTapped() {
        UIView.animateWithDuration(0.7) {
            self.view.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
            self.view.alpha = 0
        }
    }
    
    func wiggle() {
        if GKRandomSource.sharedRandom().nextIntWithUpperBound(4) == 1 {
            UIView.animateWithDuration(0.2, delay: 0, options: .AllowUserInteraction, animations: {
                self.back.transform = CGAffineTransformMakeScale(1.01, 1.01);
            }) { _ in
                self.back.transform = CGAffineTransformIdentity;
            }
            
            performSelector(#selector(wiggle), withObject: nil, afterDelay: 8)
        } else {
            performSelector(#selector(wiggle), withObject: nil, afterDelay: 2)
        }
    }
}
