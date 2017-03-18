//
//  API.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit
public let baseHttpUrl = "http://52.220.104.17:8080/redchilli/api/"

class URLPath {
    static let getTableMenuItems : String = "tablet/getTabletMenuItems"
    static let getRestaurantConfig : String = "tablet/getFeedbackConfig"
    static let getTablenumber : String = "tablet/getTableNumbers"

}

class API : NSObject
{
    struct Static
    {
        static var isReachable : Bool = false
        
    }
    
    class func getTableMenuItems (completionClosure : @escaping (_ displayMessage : String) -> ()) {
        
            SVProgressHUD.show()
        
            let customerHeaders  = ["restaurantid": "33","pin": "335524"]
            
            print("parameters \(customerHeaders)")
            
            NetworkingManager.request(httpmethod: HTTPMethod.get, currentHttpPath:URLPath.getTableMenuItems, customHeaders: customerHeaders , completionClosure: {(message, response,displayMessage) -> () in
                
                print("response of getTableNumbers \(response)")
                
                SVProgressHUD.dismiss()
                
                if message == AlertMessage.success.rawValue
                {
                    completionClosure(displayMessage!)
                    let data = NSKeyedArchiver.archivedData(withRootObject: (response as? NSDictionary)!)
                    UserDefaults.standard.set(data, forKey: DigitalMenu.Userdefaults.TableMenuItem)
                    
                    NotificationCenter.default.post(name: Notification.Name(DigitalMenu.LocalNotification.refreshMenu), object: nil)

                }
                
            })
        }
    class func syncRestaurantConfig (completionClosure : @escaping (_ imageURL : String) -> ()) {
        
//        if API.Static.isReachable{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.show()
            
            let customerHeaders  = ["restaurantid": "33","pin": "335524"]
            
            print("parameters \(customerHeaders)")
            
            NetworkingManager.request(httpmethod: HTTPMethod.get, currentHttpPath:URLPath.getRestaurantConfig, customHeaders: customerHeaders , completionClosure: {(message, response,displayMessage) -> () in
                
                
                print("response of config feedback \(response)")
                
                var desc : String = ""
                var imageURl : String = ""
                
                UserDefaults.standard.setValue("", forKey: DigitalMenu.Userdefaults.RestaurantAppDescription)
                UserDefaults.standard.setValue("", forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)
                
                if message == AlertMessage.success.rawValue
                {
                    let responseArray = response?["data"]  as! [NSDictionary]
                    
                    
                    for index in 0..<responseArray.count
                    {
                        let subdic = responseArray[index]
                        
                        if let configname = subdic["configName"] as? String{
                            
                            if configname == "about"
                            {
                                desc = (subdic["value"] as? String)!
                                
                                UserDefaults.standard.setValue(desc, forKey: DigitalMenu.Userdefaults.RestaurantAppDescription)
                            }
                            else if configname == "logo"
                            {
                                imageURl = (subdic["value"] as? String)!
                                UserDefaults.standard.setValue(imageURl, forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)
                                
                            }
                            
                        }
                        
                    }
                    
                    completionClosure(imageURl)
                    
                }else{
                    SVProgressHUD.dismiss()
                    completionClosure(imageURl)
                    
                }
                
            })
//        }
    
//    else{
//            completionClosure(self.valueOfUserDefaults(defaultsname: DigitalMenu.Userdefaults.RestaurantApppLogo)!)
//            
//        }
    }
    class func valueOfUserDefaults(defaultsname : String) -> String?
    {
        return (UserDefaults.standard.string(forKey: defaultsname) != nil) ?  UserDefaults.standard.string(forKey: defaultsname) : ""
    }
    class func saveImageDocumentDirectory(imageData : NSData ,filename : String ){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(filename)")
        print("image paths\(paths)")
        fileManager.createFile(atPath: paths as String, contents: imageData as Data, attributes: nil)
    }
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .
            userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    class func checkImageIsExist(filename : String) -> Bool{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(filename)")
        if fileManager.fileExists(atPath: imagePAth){
            return true
        }else{
            return false
        }
    }
    }

