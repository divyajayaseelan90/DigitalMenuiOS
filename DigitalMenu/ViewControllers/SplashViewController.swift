//
//  SplashViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/13/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoImageView : UIImageView!
    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantId) != nil
        {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: (self.logoImageView.frame.size.width-46)/2, y: (self.logoImageView.frame.size.height-46)/2, width: 46, height: 46)
        activityIndicator.startAnimating()
        self.logoImageView.addSubview(activityIndicator)
        
        API.syncRestaurantConfig(completionClosure: {(imageURL) -> () in
            self.activityIndicator.stopAnimating()
            print("imageURL \(imageURL)")
            if imageURL.characters.count != 0  {
                self.logoImageView.imageFromServerURL(urlString: imageURL)
                self.logoImageView.contentMode = .scaleAspectFit
                self.logoImageView.layer.masksToBounds = false
                self.logoImageView.layer.cornerRadius = 5
                self.logoImageView.clipsToBounds = true
                self.logoImageView.layer.borderWidth = 2
                self.logoImageView.layer.borderColor = UIColor.clear.cgColor
            }
            API.getTaxes(completionClosure: { _ in
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.loadMainView()
                })

            })
            
            
           
        })
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
                self.loadMainView()
            })
        }
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadMainView()
    {
        self.performSegue(withIdentifier: DigitalMenu.storyBoardIdentifier.mainView, sender: nil)
    }
    
}
