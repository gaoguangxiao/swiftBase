//
//  Alamofire+Extension.swift
//  EagleFastSwift
//
//  Created by ggx on 2017/7/18.
//  Copyright © 2017年 高广校. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public enum WDSServiceCode:Int {
    case error              = 0         //操作失败
    case normal             = 1         //正常
    case outTime            = 2         //用户失效
    case noPermission       = 403       //无权限
    case warming            = 418       //警告
    case networkdisconnect  = 404       //网络断开
    case serverException    = 500       //服务器异常
    case channelException   = 204       //该渠道和版本异常
    case unknown            = 99999     //未知错误
    case parameterError     = -2        //参数有误
    var description:String {
        get{
            switch self {
            case .normal:
                return "正常"
            case .noPermission:
                return "无权限"
            case .warming:
                return "警告"
            case .networkdisconnect:
                return "网络断开"
            case .serverException:
                return "服务器异常"
            case .error:
                return "失败"
            case .outTime:
                return "用户失效"
            case .parameterError:
                return "参数有误"
            case .channelException:
                return "该渠道和版本异常"
            default:
                return "未知错误"
            }
        }
    }
}
extension NSError{
    func msg() -> String {
        var str = ""
        for (key,value) in self.userInfo {
            
            if ("\(key)".lowercased().contains("description") && !"\(value)".isEmpty) || ("\(key)".lowercased().contains("reason") && !"\(value)".isEmpty) {
                str.append("\(value)")
            }
        }
        return str
    }
}

extension DataResponse{
    var serviceCode:WDSServiceCode{
        get{
            if self.result.isFailure {
                return WDSServiceCode.init(rawValue: 0)!
            }else{
                let json = JSON(self.result.value!)
                return WDSServiceCode.init(rawValue: json["status"].intValue)!
            }
        }
    }
    //请求成功，而且返回成功 才可正常操作数据
    var isNomalOperate: Bool {
        return self.result.isSuccess
    }
    var serviceData: Any {
        if self.result.isSuccess {
            let json = JSON(self.result.value!)
            if json["data"].type == .dictionary {
                return json["data"].dictionaryValue
            }else if json["data"].type == .array{
                return json["data"].arrayValue
            }else{
                return json["data"].stringValue
            }
            
        }else{
            return (self.result.error! as NSError).msg()
        }
    }
    var serviceMessage:String?{
        get{
            if self.result.isFailure {
                return (self.result.error! as NSError).msg()
            }else{
                var json = JSON(self.result.value!)
                return json["msg"].stringValue
            }
        }
    }
}

//实际上是替换Alamofire的原生request方法的
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .post,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = DataRequest.defaultHTTPHeaders)
    -> DataRequest
{
    return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}



extension DataRequest{
    open static let defaultHTTPHeaders: HTTPHeaders = {
        var header:HTTPHeaders = SessionManager.defaultHTTPHeaders
        return header
    }()
    @discardableResult //使用这个关键字 取消警告
    public func responseWDSJSON(
        showAnimation:Bool,
        title:String,
        options:JSONSerialization.ReadingOptions = .allowFragments,
        _ completionHandler:@escaping (DataResponse<Any>) -> Void)
        -> Self
        
    {
        let rootViewController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        if showAnimation , !title.isEmpty {
            rootViewController?.showHud(in: rootViewController?.view, hint: title)
        }else if showAnimation {
            rootViewController?.showHud(in: rootViewController?.view, hint: "")
        }
        
        
        let myCompletionHandler : (DataResponse<Any>) -> Void = {
            response in
            var myResponse = response
            var errorString:String?
            var code : WDSServiceCode?
            
            rootViewController?.hideHud()
            print("链接地址:",response.request?.url)
            if response.result.isSuccess {
                var json = JSON(myResponse.result.value!)
                
                print("\(json)")
                if let c = WDSServiceCode.init(rawValue: json["status"].intValue) {
                    code = c
                }
                
                let errorMsg = json["info"].stringValue
                if !errorMsg.isEmpty {
                    errorString = errorMsg
                }
                
            }
            if response.result.isFailure {
                code = .networkdisconnect
                errorString = code?.description
                //                print("请求失败：\(response.result)")
            }
            if code == .error || code == .networkdisconnect || code == .outTime{
                let testResponse: DataResponse<Any> = {
                    let error: NSError = {
                        return NSError(domain: Config.host.hostname, code: code!.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: errorString ?? ""])
                    }()
                    return DataResponse(
                        request: response.request,
                        response: response.response,
                        data: response.data,
                        result: .failure(error))
                }()
                myResponse = testResponse
                
                rootViewController?.showHint(errorString, yOffset: 0)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
//                    for itesm in  (UIApplication.shared.keyWindow?.subviews)!{
//                        if itesm is MBProgressHUD{
//                            (itesm as! MBProgressHUD).hide(true)
//
//                        }
//                    }
//                })


                if code == .outTime {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
//                        NotificationCenter.default.post(name: NSNotification.Name.init(KNOTIFICATION_LOGINCHANGE), object: false)
                    })
                }
            }
            
            completionHandler(myResponse)
        }
        
        return response(
            responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
            completionHandler: myCompletionHandler
        )
        
    }
    
    
}

class HttpManager{
    
    static let shareManager : HttpManager = {
        return HttpManager()
    }()
    
    
    func uploadSingleImage(
        _ url:URLConvertible,
        _ uploadData :Any,
        _ keyName:String = "file",
        _ completionHandler:@escaping (DataResponse<Any>) -> Void)
    {

//        let tmpkeyName = keyName == nil ? "file" : "images"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                    let timerStr = Date.init().timeIntervalSince1970
                    if uploadData is UIImage {
                        let imageName = String.init(format: "%@%d.jpeg", CustomUtil.getToken(),timerStr)
                        let imageData = UIImageJPEGRepresentation(uploadData as! UIImage, 0.7)


                        multipartFormData.append(imageData!, withName: keyName, fileName: imageName, mimeType: "image/jpeg")
                    }else{//视频上传
                        let vedioName = String.init(format: "%@%d.mp4", CustomUtil.getToken(),timerStr)
                        multipartFormData.append(uploadData as! Data, withName: keyName, fileName: vedioName, mimeType: "vedio/mp4")
                    }
                
        },
            to: url,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let rootViewController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController

                        var myResponse = response
                        var code : WDSServiceCode?
                        var errorString:String?

                        switch response.result{
                        case .success:
                            var json = JSON(myResponse.result.value!)
                            
                            print("\(json)")
                            if let c = WDSServiceCode.init(rawValue: json["status"].intValue) {
                                code = c
                            }
                            
                            let errorMsg = json["info"].stringValue
                            if !errorMsg.isEmpty {
                                errorString = errorMsg
                            }
                            myResponse = response
                        case .failure:
                            let testResponse: DataResponse<Any> = {
                                let error: NSError = {
                                    return NSError(domain: Config.host.hostname, code: 1002, userInfo: [NSLocalizedFailureReasonErrorKey: errorString ?? "nil"])
                                }()
                                return DataResponse(
                                    request: response.request,
                                    response: response.response,
                                    data: response.data,
                                    result: .failure(error))
                            }()
                            myResponse = testResponse
                        }
                        if code == .error || code == .networkdisconnect || code == .outTime{
                            let testResponse: DataResponse<Any> = {
                                let error: NSError = {
                                    return NSError(domain: Config.host.hostname, code: code!.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: errorString ?? ""])
                                }()
                                return DataResponse(
                                    request: response.request,
                                    response: response.response,
                                    data: response.data,
                                    result: .failure(error))
                            }()
                            myResponse = testResponse
                            
                            rootViewController?.showHint(errorString, yOffset: 0)
                            
                        }

                        completionHandler(myResponse)

                    }
                case .failure(let encodingError):
                    debugPrint(encodingError)
                }
        })
    }
}
