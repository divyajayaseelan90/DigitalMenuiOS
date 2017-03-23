//
//  MenuViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit

protocol MenuItemDelegate {
    func addMenuItem()
    func animationOrder(tag : Int)
    
}

class MenuViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate /*,UITableViewDataSource,UITableViewDelegate*/ {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var restaurantScrollView: UIScrollView!
    @IBOutlet weak var bgImageView : UIImageView!
    
    var detailMenuContoller : DetailMenuViewController?

    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    var prevBtn : UIButton?
    
    var dicOfRestSplItems = [String : AnyObject]()
    var sortedArrayOfRestSpls = [NSDictionary]()

    var restSpl : String?
    var menuItemDelegate : MenuItemDelegate?
    
    @IBOutlet weak var itemCollectionView: UICollectionView! {
        didSet {
            
          
            itemCollectionView.register(CategoryMenuTableViewCell.nib, forCellWithReuseIdentifier: CategoryMenuTableViewCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      bgImageView.isHidden = true
      NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.methodOfReceivedNotification), name:NSNotification.Name(rawValue: DigitalMenu.LocalNotification.refreshMenu), object: nil)

     //menuTableView.register(UINib(nibName: CategoryMenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryMenuTableViewCell.identifier)
        
        
        
    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        let subViews = self.restaurantScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    
        let outData = UserDefaults.standard.data(forKey: DigitalMenu.Userdefaults.TableMenuItem)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary
        
        var arrayOfData = dict?["data"] as! [NSDictionary]
        

      
        var unSortArrayOfRestSpls = [NSDictionary]()

        
        for index in 0..<arrayOfData.count {
            

            
            let maindic = arrayOfData[index]
            
            let subdicOfCategory = maindic["restaurantSpecials"] as! [NSDictionary]
            

            for index in 0..<subdicOfCategory.count {
                

                var subArrayOfItems = [NSDictionary]()

                let dic = subdicOfCategory[index]
                
                let categoryName = dic["name"] as! String
                
                if unSortArrayOfRestSpls.count != 0 {
                    
                    let filterByName = unSortArrayOfRestSpls.filter { $0["name"] as! String == categoryName }
                    print("filterByName \(filterByName)")
                    
                    if filterByName.count != 0
                    {
                        
                        subArrayOfItems = (dicOfRestSplItems[categoryName] as? [NSDictionary])!
                        subArrayOfItems.append(maindic)
                        dicOfRestSplItems[categoryName] = subArrayOfItems as AnyObject?

                        continue
                    }
                    
                }
                
                unSortArrayOfRestSpls.append(subdicOfCategory[index] )
                subArrayOfItems.append(maindic)
                dicOfRestSplItems[categoryName] = subArrayOfItems as AnyObject?
            
            
            }
            
        }

        let tempArrary : NSArray = unSortArrayOfRestSpls as NSArray
        let sortedArrayOfRestSpl = tempArrary.sortedArray(using: [NSSortDescriptor(key: "orderNumber", ascending: true)]) as! [[String:AnyObject]]
        
        sortedArrayOfRestSpls = (sortedArrayOfRestSpl as NSArray as? [NSDictionary])!
        
        
        
        for index in 0..<sortedArrayOfRestSpls.count {
            
            bgImageView.isHidden = false

            let dic = sortedArrayOfRestSpls[index]
            
            print("dic\(dic)")
            
            self.frame.origin.x = 185 * CGFloat(index)
            self.frame.size.width = 185
            self.frame.size.height = 33
            
            self.restaurantScrollView.isPagingEnabled = true
            
            let subView = UIView(frame: self.frame)
            subView.backgroundColor = UIColor.clear

            let button = UIButton(frame: CGRect(x: 0, y: 1, width: self.frame.size.width, height: self.frame.size.height))
            button.setImage(UIImage.init(named: "Tab_active"), for: UIControlState.selected)
            button.setImage(UIImage.init(named: "Tab_inactive"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(restSplAction(button:)), for: .touchUpInside)
            button.tag = index

            subView.addSubview(button)
            print("button \(button)")

            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.text = dic["name"] as? String
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.textColor = UIColor.white
            titleLabel.tag = (100*(index+1))

            subView.addSubview(titleLabel)

            if index == 0{
                button.isSelected = true
                prevBtn = button
                titleLabel.textColor = UIColor.black

                restSpl = titleLabel.text
            }
            self.restaurantScrollView.addSubview(subView)

        }
 
        self.restaurantScrollView.contentSize = CGSize(width: 185 * CGFloat(sortedArrayOfRestSpls.count), height: self.restaurantScrollView.frame.size.height)
//        menuTableView.reloadData()
        
        itemCollectionView.reloadData()

    }
    
   
    func restSplAction(button : UIButton)
    {
        print("button tag\(button.tag)")
        
        if (prevBtn != nil)
        {
            prevBtn?.isSelected = false
            
            if let theLabel = self.restaurantScrollView.viewWithTag(100*((prevBtn?.tag)!+1)) as? UILabel {
                theLabel.textColor = UIColor.white
            }
        }
        
        button.isSelected = true
        
        if let theLabel = self.restaurantScrollView.viewWithTag(100*((button.tag)+1)) as? UILabel {
            theLabel.textColor = UIColor.black
        }
        
        let dic = sortedArrayOfRestSpls[button.tag]
        
        restSpl = dic["name"] as? String

        itemCollectionView.reloadData()

        prevBtn = button
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (restSpl != nil ){
            
            let arrayOfRestItems = dicOfRestSplItems[restSpl!] as? [NSDictionary]
            return (arrayOfRestItems?.count)!
        }
        return 0
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryMenuTableViewCell.identifier, for: indexPath) as! CategoryMenuTableViewCell
        let arrayOfRestItems = dicOfRestSplItems[restSpl!] as? [NSDictionary]

        cell.loadSpecialItem(dicOfItem: (arrayOfRestItems?[indexPath.row])!)
        cell.itemTapDelegate = self
        cell.addButton.addTarget(self, action:#selector(itemAddAction(button:)), for: .touchUpInside)

        cell.addButton.tag = indexPath.row
        
        return cell

    }
   
   

    
    func itemAddAction(button : UIButton)
    {
        
        menuItemDelegate?.animationOrder(tag: button.tag)
        
        let arrayOfRestItems = dicOfRestSplItems[restSpl!] as? [NSDictionary]
        API.createMenuDic(dic: (arrayOfRestItems?[button.tag])!,type: NetAmountOperation.Plus.rawValue)
        
        menuItemDelegate?.addMenuItem()
        
        
    }
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (restSpl != nil ){
            
            print("dicOfRestSplItems \(dicOfRestSplItems)")
            print("restSpl \(restSpl)")

        let arrayOfRestItems = dicOfRestSplItems[restSpl!] as? [NSDictionary]
        var totalCount = arrayOfRestItems?.count
        
        let modulesOfCount  = totalCount! % 4
        
        if (modulesOfCount == 0)
        {
           totalCount = totalCount!/4
            
        }else{
           totalCount = (totalCount!/4)+1

        }
         return (totalCount)!
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CategoryMenuTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: CategoryMenuTableViewCell.identifier) as! CategoryMenuTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.itemTapDelegate = self
        let arrayOfRestItems = dicOfRestSplItems[restSpl!] as? [NSDictionary]
        cell.loadSpecialItem(arrayOfItems: arrayOfRestItems!)
        
        return cell
        
        
    }
*/
}
extension MenuViewController : itemTapDelegate
{
    func itemTap(detailDic: NSDictionary) {
        
        detailMenuContoller = storyboard?.instantiateViewController(withIdentifier: "DetailItemViewSegue") as? DetailMenuViewController
        detailMenuContoller?.detailMenuDelegate = self
        detailMenuContoller?.detailMenuDic = detailDic
        if let window :UIWindow = UIApplication.shared.keyWindow {
            window.addSubview((detailMenuContoller?.view)!)}
        
    }

}
extension MenuViewController : DetaiMenuDelegate
{
    func removeSuperView() {
        detailMenuContoller?.view.removeFromSuperview()
    }
    
    func DetailMenuAddAction() {
        menuItemDelegate?.addMenuItem()

    }
}


