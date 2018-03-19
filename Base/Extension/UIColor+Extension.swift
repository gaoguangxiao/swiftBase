//
//  UIColor+Extension.swift
//  EqptInspection
//
//  Created by ggx on 2017/10/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

extension UIColor{
    static func RGBA(_ red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor  {
        return UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
}
