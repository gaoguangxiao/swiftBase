//
//  ClassCircleEntity.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/22.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit
import SwiftyJSON

let kSpace   = 5
let imgWidth = Int( (SCREENWIDTH - 20 - 75)/3)

class ClassCircleEntity: ObjectEntity {
    
    var id      : String?
    var class_id:String?
    var user_id :String?
    var title   : String?
    var avatar  = ""
    
    var content :String?
    
    var media   : String?
    var mediaCoverImage : UIImage?
    
    var uploadUrl : Any?
    
    //视频类型
    
    var voteCircle : String?//0圈子 1投票
    
    var vote_type : String? //投票类型 0单选 1多选
    
    var vote_end_time : String?
    var vote_end_time_isEnd_Status = true //
    
    var vote_status   : Bool?
    var vote_total    : String?  //投票总数
    
    
    var status : String?
    var create_time : String?
    var create_formatter : String?
    
    
    var user_name : String?
    
    var vote_item : Array<Any>?//get 参数
    
    var vote    : Array<Any>? //投票的选项
    var picture    : Array<Any>? //图片
    var praise  : Array<Any>? //点赞列表
    var replay  : Array<Any>? //回复列表
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let circleEntity = ClassCircleEntity.init()
        
        circleEntity.voteCircle = dic["vote"].stringValue// 0动态，1投票
        
        circleEntity.id  = dic["id"].stringValue
        circleEntity.class_id = dic["class_id"].stringValue
        circleEntity.user_id = dic["user_id"].stringValue
        circleEntity.title = dic["title"].stringValue
        circleEntity.content = dic["content"].stringValue
        
        circleEntity.avatar  = dic["avatar"].stringValue
        if circleEntity.avatar.characters.count > 0 {
            circleEntity.avatar = circleEntity.avatar.withHostNameImage
        }
        circleEntity.media = dic["media"].stringValue
        
        if (circleEntity.media?.characters.count)! > 0 {
            circleEntity.media = circleEntity.media?.withHostNameImage
        }
        
        let voteJson = dic.dictionaryValue["vote_item"]
        circleEntity.vote_item = VoteItemEntity.arrayObjectFromDic(dic: voteJson ?? JSON([:]))
        
        circleEntity.vote_type = dic["vote_type"].stringValue
        circleEntity.vote_end_time = dic["vote_end_time"].stringValue
        circleEntity.vote_status = dic["vote_status"].boolValue
        if (circleEntity.vote_end_time?.characters.count)! > 0 {
            //            circleEntity.vote_end_time_isEnd_Status = circleEntity.vote_status!
            let conformTimer     = Date.init(timeIntervalSince1970: Double(circleEntity.vote_end_time!)! + 8 * 3600)
            
            let today            = Date.init(timeIntervalSinceNow: 8 * 3600)
            
            let result : ComparisonResult = conformTimer.compare(today);
            
            if circleEntity.vote_status! || result == ComparisonResult.orderedAscending{
                circleEntity.vote_end_time_isEnd_Status = true
            }else{
                // conformTimer > today
                //                if result == ComparisonResult.orderedDescending || {
                //在指定时间前面 过了指定时间 过期
                circleEntity.vote_end_time_isEnd_Status = false
                //到截止时间 或
                //                }else if result == ComparisonResult.orderedAscending{
                //                    circleEntity.vote_end_time_isEnd_Status = true
                //                }
            }
            
            
        }
        circleEntity.status = dic["status"].stringValue
        circleEntity.create_time = dic["create_time"].stringValue
        
        circleEntity.vote_total  = dic["vote_total"].stringValue
        
        if (circleEntity.create_time?.characters.count)! > 0  {
            let conformTimer     = Date.init(timeIntervalSince1970: Double(circleEntity.create_time!)!)
            let dayFommater     = DateFormatter.init(dateFormat: "yyyy-MM-dd")
            let today            = Date.init(timeIntervalSinceNow: 8 * 3600)
            if dayFommater.string(from: today) == dayFommater.string(from: conformTimer) {
                let todayFommater = DateFormatter.init(dateFormat: "HH:mm")
                circleEntity.create_formatter = todayFommater.string(from: conformTimer)
            }else{
                let dformatter = DateFormatter.init(dateFormat: "MM月dd日")
                circleEntity.create_formatter = dformatter.string(from: conformTimer)
            }
            
        }
        
        circleEntity.user_name = dic["user_name"].stringValue
        
        circleEntity.picture = dic["picture"].arrayValue
        circleEntity.vote = dic["vote"].arrayValue
        circleEntity.praise = dic["praise"].arrayValue
        
        //不论服务器给任何数值，保证 属性 replay初始化一次
        circleEntity.replay = CommentEntity.arrayObjectFromDic(dic: JSON(dic["replay"].arrayValue))
        return circleEntity
        
    }
    
    func thumbnailImageForVideo(videoString: String) -> UIImage {

        return  UIImage.init(named: "01")!
        
    }
}

//组合班级信息
class ClassCircleBfEntity: ObjectEntity {
    var is_class = ""
    var userId   = ""
    
    var list : [ClassCircleEntity]  = []
    
}

class VoteItemEntity: ObjectEntity {
    var id      : String?
    var item_name:String?
    var circle_id :String?
    var total_num   : String?
    var create_time :String?
    var isSelect = false
    var placeString = ""
    
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let voteEntity = VoteItemEntity.init()
        
        voteEntity.id  = dic["id"].stringValue
        voteEntity.item_name = dic["item_name"].stringValue
        voteEntity.circle_id = dic["circle_id"].stringValue
        voteEntity.total_num = dic["total_num"].stringValue
        voteEntity.create_time = dic["create_time"].stringValue
        voteEntity.isSelect    = dic["isSelect"].boolValue
        //        voteEntity.placeString = voteEntity.total_num
        return voteEntity
    }
}
//#MARK: - 评论人信息的模型
class CommentEntity : ObjectEntity{
    var id          = ""
    var replay_id   = ""
    var replay_name = ""
    
    var status      = ""
    var content     = ""
    var create_time = ""
    var user_id     = ""
    var user_name   = ""
    var class_circle_id = ""
    override static func getObjectFromDic(dic: JSON) -> ObjectEntity {
        let t =  CommentEntity()
        t.id  = dic["id"].stringValue
        t.status = dic["status"].stringValue
        t.replay_name = dic["replay_name"].stringValue
        t.replay_id = dic["replay_id"].stringValue
        t.content   = dic["content"].stringValue

        t.user_id   = dic["user_id"].stringValue
        t.user_name = dic["user_name"].stringValue
        t.create_time = dic["create_time"].stringValue
        t.class_circle_id   = dic["class_circle_id"].stringValue
        return t
    }
}








