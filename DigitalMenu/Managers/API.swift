//
//  API.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit
public let baseHttpUrl = "https://digitalapi.dobango.com/api/"//"http://52.220.104.17:8080/redchilli/api/"

class URLPath {
    static let getTableMenuItems : String = "tablet/getTabletMenuItems"
    static let getRestaurantConfig : String = "tablet/getFeedbackConfig"
    static let getTablenumber : String = "tablet/getTableNumbers"
    static let getTax : String = "tablet/getTaxes"

}

class API : NSObject
{
    struct Static
    {
        static var isReachable : Bool = false
        static var createMenuOrder : CreateMenuOrder?
        static var arrayOfItemDic = [NSDictionary]()
        static var totalItemCount : Int = 0
        static var serviceTax : Float = 0
        static var serviceCharge : Float = 0
        static var laxuryTax : Float = 0
        static var netAmount : Float = 0

    }
    
    class func getTableMenuItems (completionClosure : @escaping (_ displayMessage : String) -> ()) {
        
            SVProgressHUD.show()
        
            let customerHeaders  = ["restaurantid": "53","pin": "537430"]
            
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
    class func getTaxes (completionClosure : @escaping (_ displayMessage : String) -> ()) {
        
        
        let customerHeaders  = ["restaurantid": "53","pin": "537430"]
        
        print("parameters \(customerHeaders)")
        
        NetworkingManager.request(httpmethod: HTTPMethod.get, currentHttpPath:URLPath.getTax, customHeaders: customerHeaders , completionClosure: {(message, response,displayMessage) -> () in
            
            print("response of getTax \(response)")
            
            if message == AlertMessage.success.rawValue
            {
                let responseArray = response?["data"]  as! [NSDictionary]
                
                
                for index in 0..<responseArray.count
                {
                    let subdic = responseArray[index]
                    
                    if let taxType = subdic["taxType"] as? NSDictionary{
                        
                        let taxdisplayName = taxType["displayName"] as? String

                        if taxdisplayName == "Service Tax"
                        {
                            API.Static.serviceTax = (subdic["tax"] as? Float)!
                            
                        }
                        else if taxdisplayName == "Service Charge"
                        {
                            API.Static.serviceCharge = (subdic["tax"] as? Float)!
                            
                        }
                        else if taxdisplayName == "Laxury Tax"
                        {
                            API.Static.laxuryTax = (subdic["tax"] as? Float)!
                            
                        }
                        
                    }
                    
                }
                
                completionClosure(displayMessage!)
                
            }
            
        })
    }
    class func syncRestaurantConfig (completionClosure : @escaping (_ imageURL : String) -> ()) {
        
//        if API.Static.isReachable{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.show()
            
            let customerHeaders  = ["restaurantid": "53","pin": "537430"]
            
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
    
    class func createMenuDic(dic: NSDictionary)
    {
        var detailMenudic : [String : AnyObject] = [:]
        
        detailMenudic["name"] = dic["name"] as? String as AnyObject?
        detailMenudic["price"] = dic["price"] as? Float as AnyObject?
        detailMenudic["count"] = 1 as AnyObject?
        
        let arrayOfSavedMenu :[NSDictionary] = API.Static.arrayOfItemDic
        
        
        if arrayOfSavedMenu.count != 0 {
            
            let filterByName = arrayOfSavedMenu.filter { $0["name"] as! String == detailMenudic["name"] as! String }
            
            print("filterByName \(filterByName)")
            
            if filterByName.count != 0
            {
                let filterDic = filterByName[0]
                
                var totalCount :Int = 0
                
                totalCount = filterDic["count"] as! Int
                
                totalCount += 1
                
                let index = arrayOfSavedMenu.index(of: filterDic)
                detailMenudic["count"] = totalCount as AnyObject?
                
                API.Static.arrayOfItemDic[index!]  = detailMenudic as NSDictionary
                
            }else{
                API.Static.arrayOfItemDic.append(detailMenudic as NSDictionary)

            }
            
            var totalItemCount : Int = 0
            
            for index in  0..<arrayOfSavedMenu.count
            {
                let subdic = arrayOfSavedMenu[index] as NSDictionary
                
                totalItemCount += subdic["count"] as! Int
                
            }
            API.Static.totalItemCount = totalItemCount
            

        }else{
            API.Static.arrayOfItemDic.append(detailMenudic as NSDictionary)
            API.Static.totalItemCount = 1
        }
        
        print("ordered item list\(API.Static.arrayOfItemDic)")

        self.calculateNetAmount()
        
    }
    
    class func calculateNetAmount()
    {
        let arrayOfOrderedItem :[NSDictionary] = API.Static.arrayOfItemDic
        
        var totalItemAmount : Float = 0
        
        var netAmount : Float = 0
        
        for index in  0..<arrayOfOrderedItem.count
        {
            let subdic = arrayOfOrderedItem[index] as NSDictionary

            let countOfItem = subdic["count"] as? Int
            let amountOfItem = subdic["price"] as? Float
            
            totalItemAmount += amountOfItem! * Float(countOfItem!)
            
        }
        
        netAmount = totalItemAmount - API.Static.serviceTax - API.Static.serviceCharge - API.Static.laxuryTax
        API.Static.netAmount = netAmount
        
        print("totalItemAmount \(netAmount)")
        
        
    
    }
    
    }

