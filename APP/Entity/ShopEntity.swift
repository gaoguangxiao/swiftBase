//
//  ShopEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/9/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON
class ShopEntity: ObjectEntity {
    var id : String?
    var number : String?
    var price : String?
    var picture  : String?
    var create_time : String?
    var goods_name :String?
    var goods_id   :String?
    
    var school_id  :String?
    var status     : String?
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let t = ShopEntity.init()
        t.id = dic["id"].stringValue
        t.number = dic["number"].stringValue
        t.price = dic["price"].stringValue
        t.create_time = dic["create_time"].stringValue
        //拼接链接
        t.picture = dic["picture"].stringValue
        
//        http://zxapp.test2.yikeapp.cn/data/upload/admin/20170809/598ad1234f9fa.png
        t.picture = t.picture?.withHostPicture
        t.status  = dic["status"].stringValue
        t.goods_name   = dic["goods_name"].stringValue
        t.school_id = dic["school_id"].stringValue
        t.goods_id  = dic["goods_id"].stringValue
        return t
    }
}
class ListShopEntity: ObjectEntity {
    var score = ""
    var list : [ShopEntity]  = []
    
}
