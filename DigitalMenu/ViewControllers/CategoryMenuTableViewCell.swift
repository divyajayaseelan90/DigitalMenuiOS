//
//  CategoryMenuTableViewCell.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/17/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
protocol itemTapDelegate
{
    func itemTap(detailDic : NSDictionary)
}
class CategoryMenuTableViewCell: UICollectionViewCell {
    
    class var identifier:String {
        return "CategoryMenuTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
        
    }

    @IBOutlet weak var fv_menuImage: UIImageView!
    @IBOutlet weak var fv_menuIndicator: UIImageView!
    
    @IBOutlet weak var fv_menuTitle: UILabel!
    @IBOutlet weak var fv_menuTitlePrice: UIButton!
   
   
    @IBOutlet weak var firsView : UIView!
 
    @IBOutlet weak var addButton : UIButton!

    @IBOutlet weak var spicy1 : UIImageView!
    @IBOutlet weak var spicy2 : UIImageView!
    @IBOutlet weak var spicy3 : UIImageView!
    @IBOutlet weak var spicy4 : UIImageView!
    @IBOutlet weak var spicy5 : UIImageView!

    var detailDic : NSDictionary!
  
    var itemTapDelegate : itemTapDelegate?
    
    func loadSpecialItem (dicOfItem : NSDictionary)
    {
        
        spicy1.isHidden = true
        spicy2.isHidden = true
        spicy3.isHidden = true
        spicy4.isHidden = true
        spicy5.isHidden = true
        
        detailDic = dicOfItem
        
          borderforImage(imagename: fv_menuImage)

          tapRecognizerView(filename: firsView)

            let name = dicOfItem["name"] as? String
            let price = dicOfItem["price"] as! Int
            let rating = dicOfItem["rating"] as! Int
            let menuImage = dicOfItem["image"] as? String
            fv_menuTitle.text = name
                fv_menuTitlePrice.setTitle("₹ \(String(price))", for: .normal)
              if (menuImage != nil){

                    fv_menuImage.imageFromServerURL(urlString: menuImage!)

                }
        if let filterArray = detailDic["filter"] as? NSArray
        {
            
            for index in 0..<filterArray.count
            {
                let subDic = filterArray[index] as! NSDictionary
                let orderNumber = subDic["orderNumber"] as? Int

                if orderNumber == 1
                {
                    fv_menuIndicator.image = UIImage.init(named: "veg indicator")
                }
            }
        }
        
        
        if let menuQualifierArray = detailDic["menuQualifiers"] as? NSArray
        {
            
            let subMenuQualifier = menuQualifierArray[0] as! NSDictionary
            
            let orderNumber = subMenuQualifier["orderNumber"] as? Int
            
            if orderNumber == 1
            {
                spicy1.isHidden = false
                spicy2.isHidden = true
                spicy3.isHidden = true
                spicy4.isHidden = true
                spicy5.isHidden = true

            }else if orderNumber == 2
            {
                spicy1.isHidden = false
                spicy2.isHidden = false
                spicy3.isHidden = true
                spicy4.isHidden = true
                spicy5.isHidden = true
            }
            else if orderNumber == 3
            {
                spicy1.isHidden = false
                spicy2.isHidden = false
                spicy3.isHidden = false
                spicy4.isHidden = true
                spicy5.isHidden = true
            }
            else if orderNumber == 4
            {
                spicy1.isHidden = false
                spicy2.isHidden = false
                spicy3.isHidden = false
                spicy4.isHidden = false
                spicy5.isHidden = true
            }else{
                spicy1.isHidden = false
                spicy2.isHidden = false
                spicy3.isHidden = false
                spicy4.isHidden = false
                spicy5.isHidden = false

            }
        }
        
    }
    
    func borderforImage(imagename : UIImageView)
    {
        imagename.contentMode = .scaleAspectFill
        imagename.layer.masksToBounds = false
        imagename.layer.cornerRadius = 3
        imagename.clipsToBounds = true
        imagename.layer.borderWidth = 2
        imagename.layer.borderColor = UIColor.DigitalMenu.AppColor.cgColor
    }
    
    func tapRecognizerView(filename : UIView)
    {

        let tap = UITapGestureRecognizer(target: self, action: #selector(selectedItem(sender:)))
        filename.addGestureRecognizer(tap)
    }
    
    
    func selectedItem(sender: UITapGestureRecognizer? = nil) {
        itemTapDelegate?.itemTap(detailDic: detailDic)
        
    }
    
    
   }
