//
//  String+Extension.swift
//  wisdomstudy
//
//  Created by ggx on 2017/8/30.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation

extension String{
    var withHost : String {
        get{
            return "http://" + Config.host.hostnameAndPort + self
        }
    }
    var withHostPicture : String {
        get{
            return "http://" + Config.host.hostname + "/data/upload/" + self
        }
    }
    //用户头像获取
    var withHostUserLogo :String{
        get{
            return "http://" + Config.host.hostname + "/data/avatar/" + self + ".png"
        }
    }

    var withHostNameImage : String{
        get{
            return "http://" + Config.host.hostname  + self
        }
    }
    
    var withHostOfToken: String {
        get{
            return "http://" + Config.host.hostnameAndPort + self + "/token/\(CustomUtil.getToken())"
        }
    }
    
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    
    func isEqualUserId() -> Bool {
        let userId = CustomUtil.getUserInfo().id
        return self == userId
    }
    
    

}
