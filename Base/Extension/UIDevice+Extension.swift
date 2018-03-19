//
//  UIDevice+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/28.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

extension UIDevice {
    public func isIPhoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
