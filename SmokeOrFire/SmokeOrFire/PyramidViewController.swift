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
import GameplayKit

protocol PyramidViewControllerDelegate {
    func pvDidFinish(controller: PyramidViewController, text: String)
}

class PyramidViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate: PyramidViewControllerDelegate? = nil
    var pyramid: Pyramid? = nil
    var levels: [Int]? = nil

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (pyramid != nil) {
            for round in pyramid!.rounds {
                print("Card: \(round.card.describe())")
                print("Level: \(round.level)")
                print("Rule: \(round.rule)")
                print("\n")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return levels!.count
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels![section]
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card", forIndexPath: indexPath) as! PyramidCell

        cell.imageView.image = UIImage(named: "cardCircle")

        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let card = pyramid!.rounds[indexPath.item].card
        let ac = UIAlertController(title: "Round \(indexPath.item)",
            message: "\(card.describe())", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Cancel, handler: nil))
        
        presentViewController(ac, animated: true, completion: nil)
    }

    func close() {
        if (delegate != nil) {
            delegate!.pvDidFinish(self, text: "Finished")
        }
    }

    func createPyramid(deck: Deck, levels: [Int]) {
        pyramid = Pyramid()
        self.levels = levels
        let seed = GKRandomSource.sharedRandom().nextIntWithUpperBound(2) // Ensures give-take pattern doesn't always start on give.
        for i in 0 ..< levels.count {
            for _ in 0 ..< levels[i] {
                if let card = deck.draw() {
                    let pr = PyramidRound(level: levels[i], card: card, rule: ((pyramid!.rounds.count + seed) % 2) == 0 ? .GIVE : .TAKE)
                    pyramid!.rounds.append(pr)
                } else {
                    print("No more cards in deck to build pyramid.")
                    close()
                }
            }
        }
    }
}
