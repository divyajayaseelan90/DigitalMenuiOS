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
    @IBOutlet weak var tableBtn : UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)?.characters.count != 0 && UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo) != nil
        {
            
            print("logo URL\(UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo))")
            
            self.logoImageView.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppLogo)!)
           
        }
        
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber)?.characters.count != 0 && UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber) != nil
        {
            
            tableBtn.setTitle((UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber)), for: .normal)
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
