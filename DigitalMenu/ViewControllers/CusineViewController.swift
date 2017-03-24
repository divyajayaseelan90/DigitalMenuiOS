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
    weak var menuItemViewController: MenuViewController?
    weak var orderViewController: OrderViewController?
    weak var adminViewController: AdminViewController?
    
    
    @IBOutlet weak var bgImageView : UIImageView!
    
    @IBOutlet weak var ListOfItemContainerView : UIView!
    @IBOutlet weak var welcomeContainerView : UIView!
    @IBOutlet weak var splContainerView : UIView!
    @IBOutlet weak var orderContainerView : UIView!
    @IBOutlet weak var adminContainerView : UIView!

    enum viewType : String
    {
        case homeView = "HomeView", categoryView = "CategoryView", orderView = "OrderView", adminView = "AdminView"
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(CusineViewController.methodOfReceivedNotification), name:NSNotification.Name(rawValue: DigitalMenu.LocalNotification.name), object: nil)

        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantId) != nil
        {
            containerView(type: viewType.homeView.rawValue)
           loadValues()
        }else{
            
            containerView(type: viewType.adminView.rawValue)

            
        }
        
        
    }
    
    func loadValues()
    {
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppBackgroundImage)?.characters.count != 0 && UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppBackgroundImage) != nil
        {
            
            print("logo URL\(UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppBackgroundImage))")
            
            self.bgImageView.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.RestaurantApppBackgroundImage)!)
            self.bgImageView.contentMode = .scaleAspectFill
            
        }else{
            self.bgImageView.image = UIImage(named: "main background")
        }
        API.getTableMenuItems(completionClosure:{_ in ()
            
        })
    }
    func methodOfReceivedNotification(notification: Notification){
        
       loadValues()
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
            if let viewController = listOfItemViewController {
                viewController.categoryMenuDelegate = self
            }
        }
        else if segue.identifier == Segues.RestaurantSpecialSegue.rawValue {
            self.menuItemViewController = segue.destination as? MenuViewController
            if let viewController = menuItemViewController {
                viewController.menuItemDelegate = self
            }
        }
        else if segue.identifier == Segues.OrderViewSegue.rawValue {
            self.orderViewController = segue.destination as? OrderViewController
            if let viewController = orderViewController {
                viewController.delegate = self
            }

        }
        else if segue.identifier == Segues.AdminSegue.rawValue {
            self.adminViewController = segue.destination as? AdminViewController
            if let viewController = adminViewController {
                viewController.delegate = self
            }
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
            orderContainerView.isHidden = true
            adminContainerView.isHidden = true

        }else if type == viewType.homeView.rawValue{
            welcomeContainerView.isHidden = false
            splContainerView.isHidden = false
            ListOfItemContainerView.isHidden = true
            orderContainerView.isHidden = true
            adminContainerView.isHidden = true

        }else if type == viewType.adminView.rawValue
        {
            welcomeContainerView.isHidden = false
            splContainerView.isHidden = false
            ListOfItemContainerView.isHidden = true
            orderContainerView.isHidden = true
            adminContainerView.isHidden = false
        }else{
            welcomeContainerView.isHidden = true
            splContainerView.isHidden = true
            ListOfItemContainerView.isHidden = true
            orderContainerView.isHidden = false
            adminContainerView.isHidden = true

        }
    }
}
extension CusineViewController: CategoryMenuDelegate,MenuItemDelegate,OrderItemDelegate {
    
    func animationOrder(tag: Int) {
        /*
        
        if let animatieView = self.listOfItemViewController?.itemCollectionView.viewWithTag(100*(tag + 1))
        {
            
            animatieView.isHidden = false
            
        print("cell tag\(tag + 1)")
        
        let originX : Int = Int(animatieView.frame.origin.x)
        let originY : Int = Int(animatieView.frame.origin.y)

            
        // now create a bezier path that defines our curve
        // the animation function needs the curve defined as a CGPath
        // but these are more difficult to work with, so instead
        // we'll create a UIBezierPath, and then create a
        // CGPath from the bezier when we need it
        let path = UIBezierPath()
        path.move(to: CGPoint(x: originX+30, y: originY+30))
        path.addCurve(to: CGPoint(x: 1020, y: 230), controlPoint1: CGPoint(x: 600, y: 90), controlPoint2: CGPoint(x: 850, y:210))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationLinear
        anim.duration = 1.5
        
        // we add the animation to the squares 'layer' property
        animatieView.layer.add(anim, forKey: "animate position along path")
        }
        */
    }
    func addMenuItem() {
    
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        
            self.customNavigationViewController?.orderBtn.setTitle(String(API.Static.totalItemCount), for: .normal)
            let slideInFromLeftTransition = CATransition()
            // Customize the animation's properties
            slideInFromLeftTransition.type = kCATransitionMoveIn
            slideInFromLeftTransition.subtype =   kCATransitionFromTop
            slideInFromLeftTransition.duration = 0.5
            slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            slideInFromLeftTransition.fillMode = kCAFillModeRemoved
            
            
            // Add the animation to the View's layer
            self.customNavigationViewController?.orderBtn.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")

           

//        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
//
//            if let theView = self.view.viewWithTag(100*(tag + 1)) {
//                theView.isHidden = true
//            }
//        })
    }
}


extension CusineViewController: customNavigationDelegate {
    
    func  showListOfTable() {
        
        containerView(type: viewType.adminView.rawValue)
        self.adminViewController?.viewType(type: "Pin")
    }

    func showListOfOrder() {
        
        if API.Static.totalItemCount != 0{
            containerView(type: viewType.orderView.rawValue)
            self.orderViewController?.loadOrderItem()
        }

    }
    
    func showHome() {
        
        NotificationCenter.default.post(name: Notification.Name(DigitalMenu.LocalNotification.refreshMenu), object: nil)
        containerView(type: viewType.homeView.rawValue)

    }
}

extension CusineViewController: AdminDelegate
{
    internal func submitPin() {
        
    }

    func closeAdminPage() {
        
        self.showHome()
        if UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber)?.characters.count != 0 && UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber) != nil
        {
            API.clearOrder()
            self.customNavigationViewController?.orderBtn.setTitle(String(API.Static.totalItemCount), for: .normal)

            self.customNavigationViewController?.tableBtn.setTitle((UserDefaults.standard.string(forKey: DigitalMenu.Userdefaults.Tablenumber)), for: .normal)
        }
    }
}

extension CusineViewController: categorySelectionDelegate {
    
    func selectedCategory(type : String) {
        
        containerView(type: viewType.categoryView.rawValue)

        self.listOfItemViewController?.loadMenuItemsByCategory(type: type)

        
    }
   
    
}
