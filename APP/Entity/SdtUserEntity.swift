//
//  SdtUserEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/4.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
class SdtUserEntity: ObjectEntity {
    var class_id :String?  //所属班级id
    var flower :String?    //花的数量
    var score :String?     //积分
    var id :String?        //用户的id
    var avatar : String?
    
    var invitation :String? //
    var reward_num :String?
    var invitation_status :String?
    var student_name :String?
    var total_score :String?
    
    //学生 家长存储属性
    var status       : String?
    var relationship : String? //和学生的关系
    var user_id      : String? //家长身份的id
    var student_id   : String? //学生的id
    var contact_id   : String?

    
    //增加是否选中
    var isSelect : Bool = false
    
    var memberSelectEntity = ReceiveUserEntity() // 9/22 
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let s = SdtUserEntity()
        s.class_id = dic["class_id"].stringValue
        s.flower   = dic["flower"].stringValue
        s.score   = dic["score"].stringValue
        s.id   = dic["id"].stringValue
        s.invitation   = dic["invitation"].stringValue
        s.reward_num   = dic["reward_num"].stringValue
        s.invitation_status   = dic["invitation_status"].stringValue
        s.student_name   = dic["student_name"].stringValue
        s.total_score   = dic["total_score"].stringValue
        s.avatar        = dic["avatar"].stringValue
 
        s.status        = dic["status"].stringValue
        s.relationship  = dic["relationship"].stringValue
        s.user_id       = dic["user_id"].stringValue
        s.student_id    = dic["student_id"].stringValue
        s.contact_id    = dic["contact_id"].stringValue
        s.isSelect  = dic["isSelect"].boolValue
        return s
    }
}

class SdtHonorEntity: ObjectEntity {
    var is_teacher = ""
    var total_score = ""
    var list : [SdtUserEntity]  = []
    
    
}

