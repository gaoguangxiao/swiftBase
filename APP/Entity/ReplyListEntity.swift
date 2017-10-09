//
//  ReplyListEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/7.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
//回执状态
enum ReplyStatus :String {
    case ReplyStatusNo = "0"//未回执
    case ReplyStatusYes  = "1"//已回执
    case ReplyStatusRefused = "2" //拒绝
    case ReplyStatusknown   = "3"
    var descriptionReplyStatus:String {
        get{
            switch self {
            case .ReplyStatusNo:
                return "未回执"
            case .ReplyStatusYes:
                return "已回执"
            case .ReplyStatusRefused:
                return "拒绝"
            default:
                return "未知错误"
            }
        }
    }
    
    var colorReplyStatus: UIColor {
        get{
            switch self {
            case .ReplyStatusNo:
                return UIColor.RGBA(250, green: 140, blue: 61, alpha: 1.0)
            case .ReplyStatusYes:
                return UIColor.RGBA(48, green: 142, blue: 251, alpha: 1.0)
            case .ReplyStatusRefused:
                return UIColor.RGBA(250, green: 140, blue: 61, alpha: 1.0)
            default:
                return UIColor.RGBA(1, green: 1, blue: 1, alpha: 1.0)
            }
        }
    }
}



class ReplyListEntity: ObjectEntity {
    var status :String?
    var update_time :String?
    var id :String?
    var message_id :String?
    var teacher_id :String?
    var student_id :String?
    var user_id :String?
    var create_time:String? //通知创建的时间
    var create_formatter :String?       //本地做的时间变换
    var u_name = ""
    var avatar = ""
    
    var statusTitle : ReplyStatus?
    
    //增加回执数量
    var allNum = ""  //总的数量
    var backNum = "" //回执的数量
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let s = ReplyListEntity()
        
        s.id   = dic["id"].stringValue
        s.update_time   = dic["update_time"].stringValue
        s.message_id   = dic["message_id"].stringValue
        s.teacher_id   = dic["teacher_id"].stringValue
        s.student_id   = dic["student_id"].stringValue
        s.user_id   = dic["user_id"].stringValue
        s.create_time  = dic["create_time"].stringValue
        
        s.status   = dic["status"].stringValue
        s.statusTitle  = ReplyStatus.init(rawValue: s.status!)
        s.u_name = dic["u_name"].stringValue
        if s.u_name.characters.count == 0 {
            s.u_name = dic["user_name"].stringValue
        }
        s.avatar     = dic["avatar"].stringValue
        if s.avatar.characters.count > 0 {
            s.avatar = s.avatar.withHostNameImage
        }
        //计算显示的时间
        let conformTimer = Date.init(timeIntervalSince1970: Double(s.create_time!)!)
        let dayFommater = DateFormatter.init(dateFormat: "yyyy-MM-dd")
        let today = Date.init(timeIntervalSinceNow: 8 * 3600)
        if dayFommater.string(from: today) == dayFommater.string(from: conformTimer) {
            let todayFommater = DateFormatter.init(dateFormat: "HH:mm")
//            print("今天的时间:",todayFommater.string(from: conformTimer))
            s.create_formatter = todayFommater.string(from: conformTimer)
        }else{
            let dformatter = DateFormatter.init(dateFormat: "MM月dd日")
            s.create_formatter = dformatter.string(from: conformTimer)
        }
        
        
        return s
    }
}
