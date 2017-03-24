//
//  OrderListingTableViewCell.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/21/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

protocol orderListingDelegate {
    func updateNetAmount()
}
class OrderListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sno : UILabel!
    @IBOutlet weak var itemDes : UILabel!
    @IBOutlet weak var quantity : UILabel!
    @IBOutlet weak var amount : UILabel!

    var itemCount : Int = 0
    var totalAmount : Float = 0.0
    var itemAmount : Float = 0.0
    
    var orderListingDelegate : orderListingDelegate?
    
    var orderItemDic : NSDictionary?
    
    @IBAction func minusAction(_ sender: Any) {
        
        print("itemAmount\(itemAmount)")
        
        if itemCount > 1{
            itemCount -= 1
            updateItem()
            updateOrder(type: NetAmountOperation.Minus.rawValue)

        }else{
            itemCount = 0
            updateItem()
            updateOrder(type: NetAmountOperation.Remove.rawValue)
        }

    }
    @IBAction func plusAction(_ sender: Any) {
        itemCount += 1
        updateItem()
        updateOrder(type: NetAmountOperation.Plus.rawValue)
    }
    func updateOrder(type :String)
    {
        API.createMenuDic(dic: orderItemDic!,type: type)
        orderListingDelegate?.updateNetAmount()
    }
    func updateItem()
    {
       
        totalAmount =  itemAmount * Float(itemCount)

        self.quantity.text = String(itemCount)
        self.amount.text = "₹ "+String(totalAmount)

    }
    class var identifier:String {
        return "OrderListingTableViewCell"
    }
    
    func setItem(dic : NSDictionary)
    {
        
        orderItemDic = dic
        
        self.itemDes.text = dic["name"] as? String
        itemCount = (dic["count"] as? Int)!
        itemAmount = (dic["price"] as? Float)!
            
        
        updateItem()

        print("dic \(dic)")
        
    }
}
