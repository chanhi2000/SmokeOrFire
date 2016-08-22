//
//  UIImage+rotate.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/21/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

extension UIImage {

    func rotate(orientation: UIImageOrientation) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, CGRect(origin: CGPoint(x: 0, y: 0),
            size: self.size), self.CGImage)
        switch (orientation) {
        case .Left:
            CGContextRotateCTM(context, CGFloat(-0.5 * M_PI))
            break
        case .Right:
            CGContextRotateCTM(context, CGFloat(0.5 * M_PI))
            break
        case .Down:
            CGContextRotateCTM(context, CGFloat(M_PI))
            break
        default:
            break
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
