//
//  UIImage+alpha.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/16/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

import UIKit

extension UIImage{
    
    func alpha(value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height)
        CGContextSetBlendMode(context, .Multiply)
        CGContextSetAlpha(context, value)
        CGContextDrawImage(context, area, self.CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
