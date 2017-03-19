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
   
//
//    @IBOutlet weak var sv_menuImage: UIImageView!
//    @IBOutlet weak var sv_menuIndicator: UIImageView!
//    @IBOutlet weak var sv_menuTitle: UILabel!
//    @IBOutlet weak var sv_menuTitlePrice: UIButton!
//  
//    
//    @IBOutlet weak var tv_menuImage: UIImageView!
//    @IBOutlet weak var tv_menuIndicator: UIImageView!
//    @IBOutlet weak var tv_menuTitle: UILabel!
//    @IBOutlet weak var tv_menuTitlePrice: UIButton!
// 
//    
//    @IBOutlet weak var fouthv_menuImage: UIImageView!
//    @IBOutlet weak var fouthv_menuIndicator: UIImageView!
//    @IBOutlet weak var fouthv_menuTitle: UILabel!
//    @IBOutlet weak var fouthv_menuTitlePrice: UIButton!
//   
//    
    @IBOutlet weak var firsView : UIView!
//    @IBOutlet weak var secondView : UIView!
//    @IBOutlet weak var thirdView : UIView!
//    @IBOutlet weak var fourthView : UIView!
    
    var arrayOfMenuItems = [NSDictionary]()
  
    var itemTapDelegate : itemTapDelegate?
    
    func loadSpecialItem (dicOfItem : NSDictionary)
    {
        
//        arrayOfMenuItems = arrayOfItems
//        
//        firsView.isHidden = true
//        secondView.isHidden = true
//        thirdView.isHidden = true
//        fourthView.isHidden = true
//        
          borderforImage(imagename: fv_menuImage)
//        borderforImage(imagename: sv_menuImage)
//        borderforImage(imagename: tv_menuImage)
//        borderforImage(imagename: fouthv_menuImage)
//
        tapRecognizerView(filename: firsView)
//        tapRecognizerView(filename: secondView)
//        tapRecognizerView(filename: thirdView)
//        tapRecognizerView(filename: fourthView)
//
//        for index in 0..<arrayOfItems.count
//        {
//            
//            let subDic = arrayOfItems[index] as NSDictionary
//
            let name = dicOfItem["name"] as? String
            let price = dicOfItem["price"] as! Int
            let rating = dicOfItem["rating"] as! Int
            let menuImage = dicOfItem["image"] as? String
//
//            print("menuImage\(menuImage)")
//            
//            fv_menuImage.image = UIImage.init(named: "")
//            sv_menuImage.image = UIImage.init(named: "")
//            tv_menuImage.image = UIImage.init(named: "")
//            fouthv_menuImage.image = UIImage.init(named: "")
//            
//            if index == 0
//            {
//                firsView.isHidden = false
                fv_menuTitle.text = name
                fv_menuTitlePrice.setTitle("₹ \(String(price))", for: .normal)
//
//                
                if (menuImage != nil){
//
                    fv_menuImage.imageFromServerURL(urlString: menuImage!)
//                    DispatchQueue.main.async(execute: {
//                    
//                    })
                }
//
//            }else if index == 1
//            {
//                secondView.isHidden = false
//                sv_menuTitle.text = name
//                sv_menuTitlePrice.setTitle("₹ \(String(price))", for: .normal)
//                if (menuImage != nil){
//                    sv_menuImage.imageFromServerURL(urlString: menuImage!)
//                }
//            }else if index == 2
//            {
//                thirdView.isHidden = false
//                tv_menuTitle.text = name
//                tv_menuTitlePrice.setTitle("₹ \(String(price))", for: .normal)
//                if (menuImage != nil){
//                    tv_menuImage.imageFromServerURL(urlString: menuImage!)
//                    
//                }
//            }else{
//                fourthView.isHidden = false
//                fouthv_menuTitle.text = name
//                fouthv_menuTitlePrice.setTitle("₹ \(String(price))", for: .normal)
//                if (menuImage != nil){
//                    fouthv_menuImage.imageFromServerURL(urlString: menuImage!)
//                }
//            }
//          
//        }
        
        
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
        if let view = sender?.view {
            
           itemTapDelegate?.itemTap(detailDic: arrayOfMenuItems[view.tag])

        }
        
    }
    
    
   }
