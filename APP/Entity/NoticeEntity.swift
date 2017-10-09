//
//  NoticeObject.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON

enum NoticeStatus :String {
    case NoticeStatusCheck = "0"//待审核
    case NoticeStatusPass  = "1"//已通过
    case NoticeStatusRefused = "2" //拒绝
    case NoticeStatusUnkown = "4"
    var descriptionNoticeStatus:String {
        get{
            switch self {
            case .NoticeStatusCheck:
                return "审核中"
            case .NoticeStatusPass:
                return "已发布"
            case .NoticeStatusRefused:
                return "未通过"
            default:
                return "未知错误"
            }
        }
    }
    var desStatusColor: UIColor {
        get{
            switch self {
            case .NoticeStatusCheck:
                return UIColor.RGBA(78, green: 197, blue: 103, alpha: 1.0)
            case .NoticeStatusPass:
                return UIColor.RGBA(179, green: 179, blue: 179, alpha: 1.0)
            case .NoticeStatusRefused:
                return UIColor.RGBA(251, green: 132, blue: 45, alpha: 1.0)

            default:
                return UIColor.white
            }
        }
        
    }

}
//对通知的回执状态
enum NoticeBackStatus : String{
    case NoticeBackStatusNo        = "0" // 尚未回执
    case NoticeBackStatusHave      = "1" // 已经回执
    case NoticeBackStatusUnkown    = "3" // 未知状态
    var desNoticeBackStatus:String {
        get{
            switch self {
            case .NoticeBackStatusNo:
                return "未回执"
            case .NoticeBackStatusHave:
                return "已回执"
            default:
                return "未知错误"
            }
        }
    }
    var desBackStatusColor: UIColor {
        get{
            switch self {
            case .NoticeBackStatusNo:
                if LoginType {
                    return KTeacherBackgroundColor
                }else{
                    return UIColor.RGBA(251, green: 132, blue: 45, alpha: 1.0)
                }
            case .NoticeBackStatusHave:
                return UIColor.RGBA(179, green: 179, blue: 179, alpha: 1.0)
            default:
                return UIColor.white
            }
        }
    }
}
class NoticeEntity: ObjectEntity {
    var class_id :String?
    var content :String?
    var status :String? //状态 0审核中，1已通过，2已拒绝
    var id :String?
    var message_id : String?
    
    var update_time :String?
    var title :String?
    var send_student_ids :String?
    
    var avatar      : String?
    
    var reason :String?
    var reback_status : String?
    
    var user_id :String?
    var user_name : String?
    
    var create_time:String? //通知创建的时间
    var create_formatter :String?       //本地做的时间变换
    
    var statusTitle : NoticeStatus?
    
    
    var allNum = ""  //总的数量
    var backNum = "" //回执的数量
    
    var back = ""    // 9/20 当前用户是否回执
    var backStatus  : NoticeBackStatus? // 8/20当前用户回执状态枚举
    
    var isSender = false // 9/20 当前通知是不是自己发的
    var student :Array<Any> = [] // 9/21 接收通知的人 原始数据
    
    var receiveOnlyName : Array<Any> = [] // 9/21 直接显示接收通知的人的名字
    var receiveStdIdArray : Array<Any> = []
    
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let s = NoticeEntity()
        s.class_id = dic["class_id"].stringValue
        s.content   = dic["content"].stringValue
        s.status   = dic["status"].stringValue
        s.id   = dic["id"].stringValue
        s.message_id = dic["message_id"].stringValue
        
        s.update_time   = dic["update_time"].stringValue
        s.title   = dic["title"].stringValue
        s.send_student_ids   = dic["send_student_ids"].stringValue
        s.avatar             = dic["avatar"].stringValue
        if (s.avatar?.characters.count)! > 0 {
            s.avatar = s.avatar?.withHostNameImage
        }
        s.reason   = dic["reason"].stringValue
        s.reback_status      = dic["reback_status"].stringValue
        s.user_id   = dic["user_id"].stringValue

        s.isSender = (s.user_id?.isEqualUserId())!
        
        s.user_name = dic["user_name"].stringValue
        s.reason    = dic["reason"].stringValue
        
        s.create_time  = dic["create_time"].stringValue
        s.statusTitle  = NoticeStatus.init(rawValue: s.status!)
        
        s.allNum             = dic["all"].stringValue
        s.backNum            = dic["back"].stringValue
        
        s.back               = dic["reback_status"].stringValue
        s.backStatus         = NoticeBackStatus.init(rawValue: s.back)
        //计算显示的时间
        let conformTimer     = Date.init(timeIntervalSince1970: Double(s.create_time!)!)
        let dayFommater     = DateFormatter.init(dateFormat: "yyyy-MM-dd")
        let today            = Date.init(timeIntervalSinceNow: 8 * 3600)
        if dayFommater.string(from: today) == dayFommater.string(from: conformTimer) {
            let todayFommater = DateFormatter.init(dateFormat: "HH:mm")
            s.create_formatter = todayFommater.string(from: conformTimer)
        }else{
            let dformatter = DateFormatter.init(dateFormat: "MM月dd日")
            s.create_formatter = dformatter.string(from: conformTimer)
        }

        s.student = SdtUserEntity.arrayObjectFromDic(dic: JSON(dic["student"].arrayValue))
        var nameArray : Array<String> = []
        var idArray   : Array<String> = []
        
        if s.student.count > 0 {
            for sdtItem in s.student {
                let sdtTem = sdtItem as! SdtUserEntity
                nameArray.append(sdtTem.student_name!)
                idArray.append(sdtTem.id!)
            }
            
            s.receiveOnlyName = nameArray
            s.receiveStdIdArray = idArray
        }
        return s
    }
}
