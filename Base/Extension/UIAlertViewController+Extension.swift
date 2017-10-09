//
//  UIAlertViewController+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/4.
//  Copyright © 2017年 高广校. All rights reserved.
//  选择器 代理方法执行之后返回点击位置

import UIKit

class UIAlertControllerManager: NSObject {
    //单列模式
    public static let share:UIAlertControllerManager = {
        return UIAlertControllerManager()
    }()
    
    func addAlerts(rVc:UIViewController,alert:UIAlertController) -> Void {
        DispatchQueue.main.async {//异步队列，主线程
            if rVc.presentedViewController != nil{
                self.topPresentedViewController(control: rVc).present(alert, animated: true, completion: nil)
            }else{
                rVc.present(alert, animated: true, completion: nil)
            }
        }
    }

    func topPresentedViewController(control:UIViewController) -> UIViewController {
        var temp = control.presentedViewController
        while temp?.presentedViewController != nil {
            temp = temp?.presentedViewController
        }
        return temp!
    }
}

extension UIAlertController{
    //警示框
    static func alertMessage(viewController:UIViewController, str:String,title:String = "",btnTitles:[String]=[],action:@escaping ((Int)->Void) = {_ in }){
        let vc = UIAlertController(title: title, message: str, preferredStyle: .alert)
        //更改标题颜色
        if btnTitles.count == 0 {
            vc.addAction(UIAlertAction(title: "确定", style: .default, handler: { (ac) in
                action(0)
            }))
        }else{
            for item in btnTitles {
                let changeAction = UIAlertAction.init(title: item, style: .default, handler: { (ac) in
                    action(btnTitles.index(of: ac.title!)!)
                })
                vc.addAction(changeAction)
                let comResult = item.caseInsensitiveCompare("确定")
                let comCancel = item.caseInsensitiveCompare("取消")
                
                    var count : UInt32 = 0;
                    let ivars =  class_copyIvarList(UIAlertAction.classForCoder(), &count)
                    for item in 0..<count {
                        let ivar = ivars?[Int(item)]
                        let ivarName = String.init(cString: ivar_getName(ivar))
                        
                        
                        if ivarName.caseInsensitiveCompare("_titleTextColor").rawValue == 0,comResult.rawValue == 0{
                            changeAction.setValue(UIColor.red, forKey: "_titleTextColor")
                            continue
                        }
                        if ivarName.caseInsensitiveCompare("_titleTextColor").rawValue == 0,comCancel.rawValue == 0 {
                            changeAction.setValue(UIColor.black, forKey: "_titleTextColor")
                            continue
                        }
                    }
//                }
                
            }
        }
        
        UIAlertControllerManager.share.addAlerts(rVc: viewController, alert: vc)
    }

    //下拉弹出的
    static func actionSheetMessage(viewController:UIViewController,title:String,message:String,btnTitles:[String]=[],action:@escaping ((Int) -> Void)){
        let vc = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        if btnTitles.count == 0 {
            vc.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (ac) in
                action(0)
            }))
        }else{
            for item in btnTitles {
                let comResult = item.caseInsensitiveCompare("取消")
                var actionStyle = UIAlertActionStyle.default
                if comResult.rawValue == 0{//相等 -1小于
                    actionStyle = .cancel
                }
                vc.addAction(UIAlertAction(title: item, style: actionStyle, handler: { (ac) in
                    action(btnTitles.index(of: ac.title!)!)
                }))
            }
        }
        UIAlertControllerManager.share.addAlerts(rVc: viewController, alert: vc)
    }
}
