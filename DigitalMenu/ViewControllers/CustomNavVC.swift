//
//  CustomNavVC.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/13/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
protocol customNavigationDelegate{
    func showListOfTable()
    func showListOfOrder()
    func showHome()

}
class CustomNavVC:UIViewController {
    
    @IBOutlet weak var logoImageView : UIImageView!
    
    var customNavigationViewDelegate : customNavigationDelegate?
    
    @IBOutlet weak var orderBtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        self.navigationController?.navigationBar.addSubview(logoImageView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)?.characters.count != 0
        {
            
            print("logo URL\(UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo))")
            
            self.navigationController?.navigationBar.addSubview(logoImageView)
            
            self.logoImageView.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)!)
           
        }
        
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.cornerRadius = 3
        logoImageView.clipsToBounds = true
        logoImageView.layer.borderWidth = 2
        logoImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func showListOfTablesAction(_ sender: Any) {
        customNavigationViewDelegate?.showListOfTable()
    }
    @IBAction func showListOfOrderAction(_ sender: Any) {
        customNavigationViewDelegate?.showListOfOrder()
    }
    @IBAction func showHomeAction(_ sender: Any) {
        customNavigationViewDelegate?.showHome()
    }
}
