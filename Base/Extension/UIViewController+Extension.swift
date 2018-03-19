//
//  UIViewController+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/4.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit
extension UIViewController{
    //当pushvc的时候对tabbar隐藏
    convenience init(nibName:String) {
        
        if !nibName.isEmpty {
            self.init(nibName: nibName, bundle: nil)
        }else{
            self.init()
        }
        self.hidesBottomBarWhenPushed = true
    }
    
    //隐藏键盘
    func hideKeyBoard()  {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func callTel(to tel:String)  {
        if let url = URL.init(string: "tel://\(tel)"),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
//            self.showHint("设备不支持")
        }
    }
    func push(_ vc:UIViewController, _ animated:Bool = true) {
        if self.navigationController != nil{
            self.navigationController?.pushViewController(vc, animated: animated)
        }else{
            print("NavigationController is nil")
        }
    }
    func dis(_ animated:Bool = true){
        if self.navigationController != nil{
            _ = self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            print("NavigationController is nil")
        }
    }
    func pop(_ animated:Bool = true){
        if self.navigationController != nil{
            _ = self.navigationController?.popViewController(animated: animated)
        }else{
            print("NavigationController is nil")
        }
    }
    func popToRoot(_ animated:Bool = true){
        if self.navigationController != nil{
            _ = self.navigationController?.popToRootViewController(animated: animated)
        }else{
            print("NavigationController is nil")
        }
    }

}
