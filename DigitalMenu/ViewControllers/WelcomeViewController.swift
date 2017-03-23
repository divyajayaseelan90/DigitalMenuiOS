//
//  WelcomeViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/9/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CusineViewController.methodOfReceivedNotification), name:NSNotification.Name(rawValue: DigitalMenu.LocalNotification.name), object: nil)

        self.loadValues()
        
    }
    func loadValues()
    {
        
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantAppDescription)?.characters.count != 0
        {
            descTextView.text = UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantAppDescription)
        }else
        {
            descTextView.text = DefaultText.restaurantDesc.rawValue
        }
    }
    func methodOfReceivedNotification(notification: Notification){
        
        loadValues()
    }
}
