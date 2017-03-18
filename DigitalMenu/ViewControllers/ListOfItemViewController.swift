//
//  ListOfItemViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/16/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

class ListOfItemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var customNavigationViewController : CustomNavVC?
    var categoryViewController : CategoryViewController?
    
    var dicOfCategoryItems = [String : AnyObject]()
    
    @IBOutlet weak var filterScrollView : UIScrollView!

    var catType : String?
    
    var detailMenuContoller : DetailMenuViewController?
    
    
    
    @IBOutlet weak var menuCategoryTableView : UITableView!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 0.5
        transition.subtype = kCATransitionFromTop
        self.view.layer.add(transition, forKey: "animation")
        
        menuCategoryTableView.register(UINib(nibName: CategoryMenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryMenuTableViewCell.identifier)

        loadFilterValue()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if !dicOfCategoryItems.isEmpty {
            
            let arrayOfMenuItems = dicOfCategoryItems[catType!] as? [NSDictionary]
            var totalCount = arrayOfMenuItems?.count
            
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

        let arrayOfRestItems = dicOfCategoryItems[catType!] as? [NSDictionary]
        cell.loadSpecialItem(arrayOfItems: arrayOfRestItems!)
        return cell
        
        
    }
    
    func loadMenuItemsByCategory(type: String)
    {
        
        catType = type
        
        print("Load Category Menu\(type) dic \(dicOfCategoryItems)")
        
        if dicOfCategoryItems.isEmpty {
        let outData = UserDefaults.standard.data(forKey: DigitalMenu.Userdefaults.TableMenuItem)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary
        
        var arrayOfData = dict?["data"] as! [NSDictionary]

        var unSortArrayOfRestSpls = [NSDictionary]()

        
        
        
        for index in 0..<arrayOfData.count {
            
            
            
            let maindic = arrayOfData[index]
            
            let subdicOfCategory = maindic["type"] as! [NSDictionary]
            
            
            for index in 0..<subdicOfCategory.count {
                
                
                var subArrayOfItems = [NSDictionary]()
                
                let dic = subdicOfCategory[index]
                
                let categoryName = dic["name"] as! String
                
                if unSortArrayOfRestSpls.count != 0 {
                    
                    let filterByName = unSortArrayOfRestSpls.filter { $0["name"] as! String == categoryName }
                    print("filterByName \(filterByName)")
                    
                    if filterByName.count != 0
                    {
                        
                        subArrayOfItems = (dicOfCategoryItems[categoryName] as? [NSDictionary])!
                        subArrayOfItems.append(maindic)
                        dicOfCategoryItems[categoryName] = subArrayOfItems as AnyObject?
                        
                        continue
                    }
                    
                }
                
                unSortArrayOfRestSpls.append(subdicOfCategory[index] )
                subArrayOfItems.append(maindic)
                dicOfCategoryItems[categoryName] = subArrayOfItems as AnyObject?
            }
            
            
        }
        
        }
        menuCategoryTableView.reloadData()

    }

    func loadFilterValue()
    {
        for index in 0..<4 {
            
            self.frame.origin.x = 134 * CGFloat(index) + 20
            self.frame.size.width = 134
            self.frame.size.height = 24
            self.frame.origin.y = self.filterScrollView.frame.size.height/2
            self.filterScrollView.isPagingEnabled = true

            let subView = UIView(frame: self.frame)
            subView.backgroundColor = UIColor.clear
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            button.setImage(UIImage.init(named: "Filter bg"), for: UIControlState.selected)
            button.setImage(UIImage.init(named: "Filter bg"), for: UIControlState.normal)
//            button.addTarget(self, action: #selector(restSplAction(button:)), for: .touchUpInside)
            button.tag = index
            
            subView.addSubview(button)
            
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 4, width: self.frame.size.width, height: self.frame.size.height))
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.text = "vegiterian"
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.textColor = UIColor.white
            titleLabel.tag = (100*(index+1))
            
            subView.addSubview(titleLabel)
            subView.backgroundColor = UIColor.red
            self.filterScrollView.addSubview(subView)

        }
        self.filterScrollView.contentSize = CGSize(width: 134 * CGFloat(4), height: self.filterScrollView.frame.size.height)

    }
}

extension ListOfItemViewController : itemTapDelegate
{
    
    func itemTap(detailDic: NSDictionary) {
        
        detailMenuContoller = storyboard?.instantiateViewController(withIdentifier: "DetailItemViewSegue") as? DetailMenuViewController
        detailMenuContoller?.detailMenuDelegate = self
        detailMenuContoller?.detailMenuDic = detailDic
        if let window :UIWindow = UIApplication.shared.keyWindow {
            window.addSubview((detailMenuContoller?.view)!)}
        
     }
}


extension ListOfItemViewController : DetaiMenuDelegate
{
    func removeSuperView() {
        detailMenuContoller?.view.removeFromSuperview()
    }
}
