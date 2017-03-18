//
//  CusineViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit



class CusineViewController: UIViewController {
    
    weak var customNavigationViewController: CustomNavVC?
    weak var listOfItemViewController: ListOfItemViewController?
    weak var categoryViewController: CategoryViewController?

    @IBOutlet weak var ListOfItemContainerView : UIView!
    @IBOutlet weak var welcomeContainerView : UIView!
    @IBOutlet weak var splContainerView : UIView!
    
    enum viewType : String
    {
        case homeView = "HomeView", categoryView = "CategoryView"
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        containerView(type: viewType.homeView.rawValue)
        
        API.getTableMenuItems(completionClosure:{_ in ()
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.CustomNavigationSegue.rawValue {
            self.customNavigationViewController = segue.destination as? CustomNavVC
            if let viewController = customNavigationViewController {
                viewController.customNavigationViewDelegate = self
            }
        }else if segue.identifier == Segues.MenuCategoryViewSegue.rawValue {
            self.listOfItemViewController = segue.destination as? ListOfItemViewController
        }
        else if segue.identifier == Segues.CategoryViewSegue.rawValue {
            self.categoryViewController = segue.destination as? CategoryViewController
            if let viewController = categoryViewController {
                viewController.delegate = self            }
        }
    }
    
    func containerView(type : String){
    
        if type == viewType.categoryView.rawValue
        {
            welcomeContainerView.isHidden = true
            splContainerView.isHidden = true
            ListOfItemContainerView.isHidden = false
        }else{
            welcomeContainerView.isHidden = false
            splContainerView.isHidden = false
            ListOfItemContainerView.isHidden = true
        }
    }
}
extension CusineViewController: customNavigationDelegate {
    func  showListOfTable() {
        
    }

}
extension CusineViewController: categorySelectionDelegate {
    
    func selectedCategory(type : String) {
        
        containerView(type: viewType.categoryView.rawValue)

        self.listOfItemViewController?.loadMenuItemsByCategory(type: type)

        
    }
   
    
}
