//
//  ReceiveEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
class ReceiveUserEntity : ObjectEntity{
    var class_id : String?     //班级id
    
    var receiveNameArray :[String] = []
    
    
    var stdIdsArray :[String] = [] //存放学生家长
    var tchIdsArray :[String] = [] //存放老师字段id
    
    var count       : String = ""    //选择的数量
    var totalCount     : String = ""//里面总的数目
    var isShowCount : Bool = true
    
    
    var tchIdString :String = ""
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let t = ReceiveUserEntity()
        return t
    }
}




