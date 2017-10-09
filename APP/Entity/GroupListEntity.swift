
//
//  GroupList.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/1.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
class GroupListEntity: ObjectEntity {
    var class_id : String! = ""
    var class_job : String = "" // 1是班主任 
    var class_name : String  = ""
    var create_time = ""
    var id = ""
    var notice = ""
    var school_id = ""
    var sourse = ""
    var teacher_id = ""
    var class_im = ""
    
    var isSelect : Bool = false
    
    //记录 选择成员的id 区分老师和学生 ，所以需要村 接口
    var memberSelectEntity = ReceiveUserEntity()
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let t = GroupListEntity.init()
        t.class_id = dic["class_id"].stringValue
        t.class_job = dic["class_job"].stringValue
        t.class_name = dic["class_name"].stringValue
        t.create_time = dic["create_time"].stringValue
        t.id = dic["id"].stringValue
        t.notice = dic["notice"].stringValue
        t.sourse = dic["sourse"].stringValue
        t.teacher_id = dic["teacher_id"].stringValue
        t.isSelect   = dic["isSelect"].boolValue
        t.class_im   = dic["class_im"].stringValue
        //        t.memberArrry = dic["memberArrry"].arrayValue
        return t
    }
    
}
class GroupSelfEntity: ObjectEntity {
    var id : String?
    var group_name : String?
    var user_id : String?
    var sort  : String?
    var create_time : String?
    var isSelect : Bool = false
    
    var memberSelectEntity = ReceiveUserEntity()
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let t = GroupSelfEntity.init()
        t.id = dic["id"].stringValue
        t.group_name = dic["group_name"].stringValue
        t.user_id = dic["user_id"].stringValue
        t.create_time = dic["create_time"].stringValue
        t.sort = dic["sort"].stringValue
        t.isSelect   = dic["isSelect"].boolValue
        //        t.memberArrry = dic["memberArrry"].arrayValue
        return t
    }
}
class GroupMemberModel {
    var groupName : String?
    var groupCount : Int?
    var groupFriends : Array<Any>?
    var groupType : String?
    var isSelect  : Bool = false
}


