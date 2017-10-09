//
//  UIImagePickerController+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/4.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit

var k_UIImagePickerControllerExtensionKeyWraper = "k_UIImagePickerControllerExtensionKeyWraper"
class UIImagePickerControllerWraper: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var block : ((_ image:UIImage) -> Void)?
    
    convenience init(b:@escaping (_ image:UIImage)->Void) {
        self.init()
        block = b
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { 
            if (self.block != nil){
                DispatchQueue.main.async {
                    self.block!((info["UIImagePickerControllerEditedImage"])as!UIImage)
                }
            }
        }
    }
    
}

extension UIImagePickerController{
    func addSelecteBlock(block:@escaping (_ image:UIImage)->Void) -> Void {
        objc_setAssociatedObject(self, &k_UIImagePickerControllerExtensionKeyWraper, UIImagePickerControllerWraper.init(b: block), .OBJC_ASSOCIATION_RETAIN)
        self.delegate = objc_getAssociatedObject(self, &k_UIImagePickerControllerExtensionKeyWraper) as!UIImagePickerControllerWraper
    }
}
