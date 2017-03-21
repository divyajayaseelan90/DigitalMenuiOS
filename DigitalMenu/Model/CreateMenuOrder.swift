//
//  CreateMenuOrder.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/20/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit

class CreateMenuOrder: NSObject {

    var itemName : String?
    var itemAmount : Int?
    var itemCount : Int?
    
    
    init(dic : NSDictionary) {
        
        let dic : NSDictionary = [:]
        
        self.itemName = dic["name"] as? String
        self.itemAmount = dic["price"] as? Int
    }
    
}
