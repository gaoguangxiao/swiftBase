//
//  Config.swift
//  EqptInspection
//
//  Created by ggx on 2017/10/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
struct Config {
    struct host{
        static let hostTag = "server"
        static let hostname = "zxapp.test2.yikeapp.cn"
        static let hostnameAndPort = "\(hostname)/index.php"
    }
    
}
var LoginType = true

let KTeacherBackgroundColor = UIColor.RGBA(83, green: 153, blue: 227, alpha: 1.0)

let KParentBackgroundColor = UIColor.RGBA(251, green: 165, blue: 45, alpha: 1.0)//淡黄色
let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height

let IOS10 = NSString(string:UIDevice.current.systemVersion).floatValue >= 10
let IOS11 = NSString(string:UIDevice.current.systemVersion).floatValue >= 11
//回调
typealias AddressSuccessBlock  = (_ obj:Array<Any>)->Void
typealias WdsStringResultBlock = (_ obj : String) -> Void
typealias WdsBooleanResultBlock = (_ obj: Bool) -> Void
typealias WdsArrayResultBlock = (_ obj : Array<Any>) -> Void
typealias WdsDictionaryResultBlock = (_ obj:Dictionary<String, Any>) -> Void

typealias WdsReceiveUserEntityResultBlock = (_ obj:ReceiveUserEntity) -> Void
typealias WdsNoticeEntityResultBlock = (_ obj:NoticeEntity) -> Void

typealias WdsReplyListEntityResultBlock = (_ obj : ReplyListEntity) -> Void
typealias WdsClassCircleEntityResultBlock = (_ submitCircleData:ClassCircleEntity)-> Void
