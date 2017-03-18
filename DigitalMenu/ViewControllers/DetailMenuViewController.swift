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

    var detailMenuDic : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("detailMenuDic \(detailMenuDic)")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.view.addGestureRecognizer(tap)
        
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
     
        detailMenuDelegate?.removeSuperView()
    }
    
}
