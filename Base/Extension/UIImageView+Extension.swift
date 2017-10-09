//
//  UIImageView+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/7.
//  Copyright © 2017年 高广校. All rights reserved.
//

import AlamofireImage
import UIKit

extension UIImageView{
    func setPhotoImage(name:String,imageUrl:String,color:UIColor) -> Void {
        if imageUrl != "" {
           self.af_setImage(withURL: URL(string: "http://" + Config.host.hostnameAndPort + imageUrl.replacingOccurrences(of: "\\", with: "/"))!, placeholderImage: UIImage(named: "app_me_photo"))
        }else{
            
        }
    }
    
    func setFullPhotoImage(name:String,imageUrl:String) -> Void {
        if imageUrl != "" {
            self.af_setImage(withURL: URL(string:imageUrl.replacingOccurrences(of: "\\", with: "/"))!, placeholderImage: UIImage(named: "app_me_photo"))
        }else{
            
        }
//        https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg
    }
}
