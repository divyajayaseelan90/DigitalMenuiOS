//
//  Enums.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

enum HTTPMethod: Int {
    case post = 0,
    get = 1,
    put = 2,
    delete = 3
}
enum Segues: String {
    case CustomNavigationSegue = "CustomNavigationSegue",CategoryViewSegue = "CategoryViewSegue",MenuCategoryViewSegue = "MenuCategoryViewSegue",RestaurantSpecialSegue = "RestaurantSpecialSegue",OrderViewSegue = "OrderViewSegue",AdminSegue = "AdminSegue"
}
enum PushSegues: String {
    case DetailItemViewSegue = "DetailItemViewSegue"

}
enum AlertMessage: String
{
    case success = "Success",failure = "Error"
}

enum DefaultText : String
{
    case textEmpty = "Please Enter the pin",placeHolderText = "Write here..." ,restaurantDesc = ""
}

enum NetAmountOperation : String
{
    case Plus = "Plus" , Minus = "Minus" , Remove = "Remove"
}


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        let url = NSURL(string: urlString)! as URL
        
        print("url lastComponent \(url.lastPathComponent)")
        if !API.checkImageIsExist(filename: url.lastPathComponent)
        {
            

        
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    self.image = UIImage.init(named: "")
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    if data != nil{
                        
                        API.saveImageDocumentDirectory(imageData: data! as NSData , filename: url.lastPathComponent)
                        let image = UIImage(data: data!)
                        self.image = image
                    }else{
                        self.image = UIImage.init(named: "")
                    }
                })
                
            }).resume()
        }else{
                let imagePAth = (API.getDirectoryPath() as NSString).appendingPathComponent("\(url.lastPathComponent)")
                self.image = UIImage(contentsOfFile: imagePAth)
            
    }

    }
}
