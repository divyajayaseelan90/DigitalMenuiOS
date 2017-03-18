//
//  MenuTableViewCell.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

public let starActive = "Star_active"
public let starInActive = "Star_inactive"

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var fv_menuImage: UIImageView!
    @IBOutlet weak var fv_menuIndicator: UIImageView!

    @IBOutlet weak var fv_menuTitle: UILabel!
    @IBOutlet weak var fv_menuTitlePrice: UILabel!
    @IBOutlet weak var fv_star1: UIImageView!
    @IBOutlet weak var fv_star2: UIImageView!
    @IBOutlet weak var fv_star3: UIImageView!
    @IBOutlet weak var fv_star4: UIImageView!
    @IBOutlet weak var fv_star5: UIImageView!

    @IBOutlet weak var sv_menuImage: UIImageView!
    @IBOutlet weak var sv_menuIndicator: UIImageView!
    @IBOutlet weak var sv_menuTitle: UILabel!
    @IBOutlet weak var sv_menuTitlePrice: UILabel!
    @IBOutlet weak var sv_star1: UIImageView!
    @IBOutlet weak var sv_star2: UIImageView!
    @IBOutlet weak var sv_star3: UIImageView!
    @IBOutlet weak var sv_star4: UIImageView!
    @IBOutlet weak var sv_star5: UIImageView!
    
    @IBOutlet weak var tv_menuImage: UIImageView!
    @IBOutlet weak var tv_menuIndicator: UIImageView!
    @IBOutlet weak var tv_menuTitle: UILabel!
    @IBOutlet weak var tv_menuTitlePrice: UILabel!
    @IBOutlet weak var tv_star1: UIImageView!
    @IBOutlet weak var tv_star2: UIImageView!
    @IBOutlet weak var tv_star3: UIImageView!
    @IBOutlet weak var tv_star4: UIImageView!
    @IBOutlet weak var tv_star5: UIImageView!
    
    @IBOutlet weak var fouthv_menuImage: UIImageView!
    @IBOutlet weak var fouthv_menuIndicator: UIImageView!
    @IBOutlet weak var fouthv_menuTitle: UILabel!
    @IBOutlet weak var fouthv_menuTitlePrice: UILabel!
    @IBOutlet weak var fouthv_star1: UIImageView!
    @IBOutlet weak var fouthv_star2: UIImageView!
    @IBOutlet weak var fouthv_star3: UIImageView!
    @IBOutlet weak var fouthv_star4: UIImageView!
    @IBOutlet weak var fouthv_star5: UIImageView!
    
    @IBOutlet weak var firsView : UIView!
    @IBOutlet weak var secondView : UIView!
    @IBOutlet weak var thirdView : UIView!
    @IBOutlet weak var fourthView : UIView!
    
    
    class var identifier:String {
        return "MenuTableViewCell"
    }
    
    func loadSpecialItem (arrayOfItems : [NSDictionary])
    {


        firsView.isHidden = true
        secondView.isHidden = true
        thirdView.isHidden = true
        fourthView.isHidden = true
        
        for index in 0..<arrayOfItems.count
        {
            
            let subDic = arrayOfItems[index] as NSDictionary
            
            let name = subDic["name"] as? String
            let price = subDic["price"] as! Int
            let rating = subDic["rating"] as! Int
            let menuImage = subDic["image"] as? String
            
            print("menuImage\(menuImage)")
            
            fv_menuImage.image = UIImage.init(named: "")
            sv_menuImage.image = UIImage.init(named: "")
            tv_menuImage.image = UIImage.init(named: "")
            fouthv_menuImage.image = UIImage.init(named: "")

            
            switch index {
            case 0:
                firsView.isHidden = false
                fv_menuTitle.text = name
                fv_menuTitlePrice.text = String(price)

                StarRating(value: rating, star1: fv_star1, star2: fv_star2, star3: fv_star3, star4: fv_star4, star5: fv_star5)
               
                if (menuImage != nil){
                   fv_menuImage.imageFromServerURL(urlString: menuImage!)
                }
                break
                
            case 1:
                secondView.isHidden = false
                sv_menuTitle.text = name
                sv_menuTitlePrice.text = String(price)
                StarRating(value: rating, star1: sv_star1, star2: sv_star2, star3: sv_star3, star4: sv_star4, star5: sv_star5)
                if (menuImage != nil){
                    sv_menuImage.imageFromServerURL(urlString: menuImage!)
                }

                break
            case 2:
                thirdView.isHidden = false
                tv_menuTitle.text = name
                tv_menuTitlePrice.text = String(price)
                StarRating(value: rating, star1: tv_star1, star2: tv_star2, star3: tv_star3, star4: tv_star4, star5: tv_star5)
                if (menuImage != nil){
                    tv_menuImage.imageFromServerURL(urlString: menuImage!)
                }
                break
            case 3:
                fourthView.isHidden = false
                fouthv_menuTitle.text = name
                fouthv_menuTitlePrice.text = String(price)
                StarRating(value: rating, star1: fouthv_star1, star2: fouthv_star2, star3: fouthv_star3, star4: fouthv_star4, star5: fouthv_star5)
                if (menuImage != nil){
                    fouthv_menuImage.imageFromServerURL(urlString: menuImage!)
                }
                break
            default:
                break
            }
        }

        
    }
    
    func StarRating (value : Int,star1 : UIImageView , star2 : UIImageView ,star3 : UIImageView ,star4 : UIImageView ,star5 : UIImageView )
    {
        
        switch value {
        case 1:
            star1.image = UIImage.init(named: starActive)
            star2.image = UIImage.init(named: starInActive)
            star3.image = UIImage.init(named: starInActive)
            star4.image = UIImage.init(named: starInActive)
            star5.image = UIImage.init(named: starInActive)

            break
        case 2:
            star1.image = UIImage.init(named: starActive)
            star2.image = UIImage.init(named: starActive)
            star3.image = UIImage.init(named: starInActive)
            star4.image = UIImage.init(named: starInActive)
            star5.image = UIImage.init(named: starInActive)
            
            break
        case 3:
            star1.image = UIImage.init(named: starActive)
            star2.image = UIImage.init(named: starActive)
            star3.image = UIImage.init(named: starActive)
            star4.image = UIImage.init(named: starInActive)
            star5.image = UIImage.init(named: starInActive)
            
            break
        case 4:
            star1.image = UIImage.init(named: starActive)
            star2.image = UIImage.init(named: starActive)
            star3.image = UIImage.init(named: starActive)
            star4.image = UIImage.init(named: starActive)
            star5.image = UIImage.init(named: starInActive)
            
            break
        case 5:
            star1.image = UIImage.init(named: starActive)
            star2.image = UIImage.init(named: starActive)
            star3.image = UIImage.init(named: starActive)
            star4.image = UIImage.init(named: starActive)
            star5.image = UIImage.init(named: starActive)
            
            break
        default:
            break
        }
    }
}
