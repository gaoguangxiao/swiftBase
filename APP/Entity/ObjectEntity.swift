//
//  EntityObject.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/31.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ICGObjectProtocol : NSObjectProtocol {
   static func getObjectFromDic(dic:JSON) -> ObjectEntity
}

class ObjectEntity: NSObject,NSCoding,ICGObjectProtocol {
    override init() {
        
    }
    func allKeys() -> Array<String> {
        var keys : Array<String> = []
        var ivarsCnt : UInt32 = 0;
        let ivars = class_copyIvarList(self.classForCoder, &ivarsCnt);
        for item in 0..<ivarsCnt {
            let ivar = ivars?[Int(item)]
            let ivarName = String.init(cString: ivar_getName(ivar))
//            if ivarName.hasPrefix("") {
                keys.append(ivarName)
//            }
        }
        free(ivars)
        return keys;
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let properties = allKeys()
        for propertyName in properties{
            let value = aDecoder.decodeObject(forKey: propertyName)
            if value != nil {
                self.setValue(value, forKey: propertyName)
            }
            
            
        }
    }
    func encode(with aCoder: NSCoder) {
        let properties = allKeys()
        for propertyName in properties{
            let value = self.value(forKey: propertyName)
//            print("归档的数值\(value!),归档的key:\(propertyName)")
            aCoder.encode(value, forKey: propertyName)
        }
    }
    class func arrayObjectFromDic(dic:JSON) -> Array<Any> {
        var arr : Array<Any> = []
        if dic.type == .array {
            for item in dic.arrayValue {
                let temp = getObjectFromDic(dic:item)
                arr.append(temp)
            }
        }else if dic.type == .dictionary{
            let temp = getObjectFromDic(dic:dic)
            arr.append(temp)
        }
        return arr
    }
    class func getObjectFromDic(dic:JSON) -> ObjectEntity {
        return ObjectEntity.init()
    }
}
