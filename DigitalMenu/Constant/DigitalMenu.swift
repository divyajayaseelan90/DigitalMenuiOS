//
//  DigitalMenu.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

class DigitalMenu {

    class Userdefaults
    {
        static let RestaurantId : String = "RestaurantId"
        static let Pin : String = "Pin"
        static let Tablenumber : String = "Tablenumber"
        
        static let FeedbackAppTableNumberArray : String = "FeedbackAppTableNumberArray"

        static let TableMenuItem : String = "tableMenuItem"
        static let RestaurantAppDescription : String = "RestaurantAppDescription"
        static let RestaurantApppLogo: String = "RestaurantApppLogo"
        static let RestaurantApppBackgroundImage: String = "RestaurantApppBackgroundImage"

    }
    
    class LocalNotification
    {
        static let refreshMenu : String = "refreshMenu"
        static let name : String = "Restaurant_Submit"
        static let TableNumberSubmit : String = "TableNumber_Submit"

    }
    

    class storyBoardIdentifier
    {
        static let mainView : String = "MainView"
    }
    
    
}
extension UIColor {
    
    public convenience init(hex: String) {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        if hex.hasPrefix("#") {
            let stripped = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 1))
            let scanner = Scanner(string: stripped);
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                if stripped.characters.count == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if stripped.characters.count == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                print("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    open class DigitalMenu {
        open class var AppColor:       UIColor     { return UIColor(hex: "#C74F05") }
        
    }
    
    
    
}
