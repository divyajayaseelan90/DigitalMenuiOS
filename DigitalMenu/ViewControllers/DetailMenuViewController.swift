//
//  DetailMenuViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/18/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
protocol DetaiMenuDelegate
{
    func removeSuperView()
    func DetailMenuAddAction()
    
}
class DetailMenuViewController: UIViewController
{
    @IBOutlet weak var detailMenuImage: UIImageView!
    @IBOutlet weak var amountBtn: UIButton!
    var detailMenuDelegate : DetaiMenuDelegate?
    
    @IBOutlet weak var indicatorImg: UIImageView!
    
  
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var spicy1 : UIImageView!
    @IBOutlet weak var spicy2 : UIImageView!
    @IBOutlet weak var spicy3 : UIImageView!
    @IBOutlet weak var spicy4 : UIImageView!
    @IBOutlet weak var spicy5 : UIImageView!

    var detailMenuDic : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("detailMenuDic \(detailMenuDic)")
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        //self.view.addGestureRecognizer(tap)
        
        borderforImage(imagename: detailMenuImage)
        let menuImage = detailMenuDic?["image"] as? String
        let name = detailMenuDic?["name"] as? String
        let ingredients = detailMenuDic?["ingredients"] as? String
        let desc = detailMenuDic?["description"] as? String

        let price = detailMenuDic?["price"] as! Int
        
        if (menuImage != nil){
            detailMenuImage.imageFromServerURL(urlString: menuImage!)
        }
        if (ingredients != nil){
            ingredientsTextView.text = ingredients
        }
        if (desc != nil){
            descTextView.text = desc
        }
        menuTitle.text = name
        amountBtn.setTitle("₹ \(String(price))", for: .normal)
        
        if let filterArray = detailMenuDic?["filter"] as? NSArray
        {
            
            for index in 0..<filterArray.count
            {
                let subDic = filterArray[index] as! NSDictionary
                let orderNumber = subDic["orderNumber"] as? Int
                
                if orderNumber == 1
                {
                    indicatorImg.image = UIImage.init(named: "veg indicator_DM")
                }
            }
        }
        if let menuQualifierArray = detailMenuDic?["menuQualifiers"] as? NSArray
        {
            
            if menuQualifierArray.count == 1{

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
    func tapAction(sender: UITapGestureRecognizer? = nil) {
     
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        detailMenuDelegate?.removeSuperView()

    }
    @IBAction func AddMenuAction(_ sender: Any) {
        
        API.createMenuDic(dic: detailMenuDic!)
        detailMenuDelegate?.DetailMenuAddAction()
    }
    
}
