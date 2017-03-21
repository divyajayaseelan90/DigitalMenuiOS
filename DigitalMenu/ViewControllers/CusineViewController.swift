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

    @IBOutlet weak var ListOfItemContainerView : UIView!
    @IBOutlet weak var welcomeContainerView : UIView!
    @IBOutlet weak var splContainerView : UIView!
    @IBOutlet weak var orderContainerView : UIView!

    enum viewType : String
    {
        case homeView = "HomeView", categoryView = "CategoryView", orderView = "OrderView"
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
//            if let viewController = orderViewController {
//                viewController.menuItemDelegate = self
//            }
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

        }else if type == viewType.homeView.rawValue{
            welcomeContainerView.isHidden = false
            splContainerView.isHidden = false
            ListOfItemContainerView.isHidden = true
            orderContainerView.isHidden = true

        }else{
            welcomeContainerView.isHidden = true
            splContainerView.isHidden = true
            ListOfItemContainerView.isHidden = true
            orderContainerView.isHidden = false

        }
    }
}
extension CusineViewController: CategoryMenuDelegate,MenuItemDelegate {
    
    func animationOrder(tag: Int) {
        
        /*
        print("cell tag\(tag + 1)")
        
        var originX : Int = 350
        if tag == 1
        {
            originX = 510
        }else if tag == 2
        {
            originX = 690
        }
        else if tag == 3
        {
            originX = 870
            
        }
        let square = UIView()
        square.frame = CGRect(x: originX, y: 250, width: 64, height: 64)
        square.backgroundColor = UIColor.red
        
        // add the square to the screen
        self.view.addSubview(square)
        
        let titleLabel = UILabel(frame: CGRect(x:  0, y:0, width: 64, height: 64))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = "+1"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.DigitalMenu.AppColor
        square.addSubview(titleLabel)
        square.tag = 1000
        
        
        // now create a bezier path that defines our curve
        // the animation function needs the curve defined as a CGPath
        // but these are more difficult to work with, so instead
        // we'll create a UIBezierPath, and then create a
        // CGPath from the bezier when we need it
        let path = UIBezierPath()
        path.move(to: CGPoint(x: originX,y: 250))
        path.addCurve(to: CGPoint(x: 1024, y: 34), controlPoint1: CGPoint(x: 650, y: 200), controlPoint2: CGPoint(x: 850, y:150))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationLinear
        anim.duration = 1.5
        
        // we add the animation to the squares 'layer' property
        square.layer.add(anim, forKey: "animate position along path")
        */
    }
    func addMenuItem() {
    
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//            
//            self.customNavigationViewController?.orderBtn.setTitle(String(API.Static.totalItemCount), for: .normal)
//            
//           
//
//        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
//
//            if let theView = self.view.viewWithTag(1000) {
//                theView.removeFromSuperview()
//            }
//        })
    }
}


extension CusineViewController: customNavigationDelegate {
    
    func  showListOfTable() {
        
        
    }

    func showListOfOrder() {
        
        if API.Static.totalItemCount != 0{
            containerView(type: viewType.orderView.rawValue)
            self.orderViewController?.loadOrderItem()
        }

    }
    
    func showHome() {
        
        containerView(type: viewType.homeView.rawValue)

    }
}
extension CusineViewController: categorySelectionDelegate {
    
    func selectedCategory(type : String) {
        
        containerView(type: viewType.categoryView.rawValue)

        self.listOfItemViewController?.loadMenuItemsByCategory(type: type)

        
    }
   
    
}
