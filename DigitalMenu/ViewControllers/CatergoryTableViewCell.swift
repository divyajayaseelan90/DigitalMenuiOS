//
//  CatergoryTableViewCell.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation


class CatergoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel : UILabel!
    @IBOutlet weak var subView : UIView!
    @IBOutlet weak var categoryLogo : UIImageView!
    @IBOutlet weak var categoryButton : UIButton!

    
    class var identifier:String {
        return "CatergoryTableViewCell"
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        
        
        let slideInFromLeftTransition = CATransition()
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionMoveIn
        slideInFromLeftTransition.subtype =  (sender.isSelected) ? kCATransitionMoveIn : kCATransitionFromLeft
        slideInFromLeftTransition.duration = 0.5
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
       
        
        // Add the animation to the View's layer
        sender.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        if sender.isSelected
        {
            categoryLogo.frame.origin.x = categoryLogo.frame.origin.x-43
            sender.isSelected = false

        }else{
            
            categoryLogo.frame.origin.x = categoryLogo.frame.origin.x+43
            sender.isSelected = true
            
        }
        categoryLogo.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        
    }
    
    func setCategory(dic : NSDictionary) {
        
        categoryLogo.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = dic["name"] as? String
        let menuImage = dic["icon"] as? String
        if (menuImage != nil){
            categoryLogo.imageFromServerURL(urlString: menuImage!)
        }
        categoryLogo.contentMode = .scaleAspectFill
        categoryLogo.layer.masksToBounds = false
        categoryLogo.layer.cornerRadius = categoryLogo.frame.size.height/2
        categoryLogo.clipsToBounds = true
        categoryLogo.layer.borderWidth = 1
        categoryLogo.layer.borderColor = UIColor.clear.cgColor
        
        let slideInFromLeftTransition = CATransition()
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype =  kCATransitionFromTop
        slideInFromLeftTransition.duration = 0.5
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        subView.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        
        
        
    }
}
