//
//  NetworkingManager.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit

class NetworkingManager: NSObject {
    
    
    class func request(httpmethod: HTTPMethod, currentHttpPath: String, customHeaders: [String: String], completionClosure:@escaping (_ message: String?, _ response: AnyObject?,_ displayMessage : String?) -> ()) {
        
        sendRequestWithMethod(httpmethod: httpmethod, currentHttpPath: currentHttpPath, customHeaders: customHeaders, httpBody: NSNull()) { (code, message, response,displayMessage) -> () in
            completionClosure(message, response,displayMessage)
        }
        
    }
    class func request(httpmethod: HTTPMethod, currentHttpPath: String, httpBody: [String: AnyObject], completionClosure:@escaping (_ message: String?, _ response: AnyObject?,_ displayMessage : String?) -> ()) {
        
        sendRequestWithMethod(httpmethod: httpmethod, currentHttpPath: currentHttpPath, customHeaders: [:], httpBody: httpBody as AnyObject) { (code, message, response,displayMessage) -> () in
            completionClosure(message, response,displayMessage)
        }
        
    }
    
    class func sendRequestWithMethod(httpmethod: HTTPMethod, currentHttpPath: String, customHeaders: [String: String], httpBody: AnyObject,completionClosure:@escaping (_ code: Int, _ message: String?, _ response: AnyObject?,_ displayMessage : String?) -> ()) {
        
        let httpOptions = ["POST", "GET", "PUT", "DELETE"]
        var requestBodyData: NSData?
        var path = baseHttpUrl  + currentHttpPath
        
        /*if parameterPath.count > 0 {
         
         var pathToAppendToCurrentPath: String = "";
         
         for i in 0 ..< parameterPath.count {
         
         let key = Array(parameterPath.keys)[i]
         
         if !pathToAppendToCurrentPath.isEmpty {
         pathToAppendToCurrentPath += "/"
         }
         
         if !(parameterPath[key]! is NSNull) {
         //Whatever you want to do with myField when not null
         pathToAppendToCurrentPath += (parameterPath[key]! as! String) as String
         }
         
         }
         if pathToAppendToCurrentPath.characters.count != 1 {
         path = path + pathToAppendToCurrentPath
         }
         }*/
        
        let url: NSURL = NSURL(string: path)!
        
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        
        request.httpMethod = httpOptions[httpmethod.rawValue]
        
        
        print("url\(url)")
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !(httpBody is NSNull)
        {
            
            if httpBody.count > 0 {
                
                // var jsonDict: NSDictionary?
                
                do {
                    requestBodyData = try JSONSerialization.data(withJSONObject: httpBody, options: JSONSerialization.WritingOptions()) as NSData?
                    
                    do {
                        try JSONSerialization.jsonObject(with: requestBodyData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        
                    } catch let error as NSError? {
                        completionClosure(0, "Error with getting JSON data", (error?.userInfo)! as AnyObject?,"")
                    }
                } catch let error1 as NSError? {
                    completionClosure(0, "Error with JSON", (error1?.userInfo)! as AnyObject?,"")
                    return
                }
            }
        }else{
            print("http body is null")
        }// if parameters
        
        if httpOptions[httpmethod.rawValue] == "POST"  || httpOptions[httpmethod.rawValue] == "PUT" || httpOptions[httpmethod.rawValue] == "DELETE"{
            request.httpBody = requestBodyData as Data?
        }
        
        if customHeaders.count > 0 {
            for key in customHeaders.keys {
                request.setValue(customHeaders[key], forHTTPHeaderField:key)
                
                
            }
        }
        
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:{ response, data, connectionError in
            
            if let error = connectionError as? NSError {
                
                completionClosure(error.code, error.localizedDescription, error.userInfo as AnyObject?,"")
                
                
            } else {
                
                do {
                    
                    let httpResponse = (response as! HTTPURLResponse).statusCode
                    
                    debugPrint ("httpResponse \(httpResponse)")
                    
                    if data?.count == 0  && httpResponse == 200 {
                        
                        //Success but response body is null
                        completionClosure(200, "Success" , 0 as AnyObject?,"")
                        
                    }else{
                        
                        let responseDictionary  = try  JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        print("Response From server \(currentHttpPath) \(responseDictionary)")
                        
                        if  let resDic = responseDictionary as? NSDictionary{
                            
                            if  resDic["code"] as! Int == 1000
                            {
                                completionClosure(httpResponse,AlertMessage.success.rawValue,resDic ,resDic["message"] as? String)
                            }else{
                            completionClosure(httpResponse,AlertMessage.failure.rawValue,resDic ,resDic["message"] as? String)
                                
                            }
                        } else {
                            
                            completionClosure(httpResponse, "Success" , responseDictionary as AnyObject?,"")
                            
                        }
                    }
                    
                } catch  let error as NSError {
                    completionClosure(9000, "Could not connect to server", nil,"")
                }
            }
        })
    }
    
    
}
