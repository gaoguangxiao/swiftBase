//
//  UserCenterEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserEntity : ObjectEntity{
    var avatar : String = ""
    var mobile : String = ""
    var user_name : String = ""
    var position : String = ""
    var class_teacher : String = ""
    var id : String = ""
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let s = UserEntity()

        if dic["id"].stringValue.characters.count > 0 {
            s.avatar =  dic["id"].stringValue.withHostUserLogo
        }else{
            s.avatar = CustomUtil.getUserInfo().id.withHostUserLogo

        }

        s.mobile   = dic["mobile"].stringValue
        s.user_name   = dic["user_name"].stringValue
        s.position   = dic["position"].stringValue
        s.class_teacher   = dic["class_teacher"].stringValue
        return s
    }
    
}
