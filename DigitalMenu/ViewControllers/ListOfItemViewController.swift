//
//  ListOfItemViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/16/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

protocol CategoryMenuDelegate {
    func addMenuItem()
    func animationOrder(tag : Int)

}

class ListOfItemViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate/*,UITableViewDelegate,UITableViewDataSource*/{

    var customNavigationViewController : CustomNavVC?
    var categoryViewController : CategoryViewController?
    
    var dicOfCategoryItems = [String : AnyObject]()
    var dicOfFilterItems = [String : AnyObject]()

    @IBOutlet weak var filterScrollView : UIScrollView!

    var catType : String?
    
    var detailMenuContoller : DetailMenuViewController?
    
    var arrayOfFilterType = [NSDictionary]()
    
    var TotalPage : Int = 0
    var currenPage : Int = 1
    
    
    var isFilter : Bool = false
    var categoryMenuDelegate : CategoryMenuDelegate?
    
    var prevBtn : UIButton?
    
    @IBOutlet weak var leftArrowBtn : UIButton!
    @IBOutlet weak var rightArrowBtn : UIButton!

    
    
    @IBOutlet weak var menuCategoryTableView : UITableView!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @IBOutlet weak var itemCollectionView: UICollectionView! {
        didSet {
            
            
            itemCollectionView.register(CategoryMenuTableViewCell.nib, forCellWithReuseIdentifier: CategoryMenuTableViewCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 0.5
        transition.subtype = kCATransitionFromTop
        self.view.layer.add(transition, forKey: "animation")
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("isFilter \(isFilter)")
        if !dicOfCategoryItems.isEmpty && !isFilter{
            
            let arrayOfMenuItems = dicOfCategoryItems[catType!] as? [NSDictionary]
            return (arrayOfMenuItems?.count)!
        }
        else if !dicOfFilterItems.isEmpty && isFilter{
            
            let arrayOfMenuFilterItems = dicOfFilterItems[catType!] as? [NSDictionary]
            return (arrayOfMenuFilterItems?.count)!
        }
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryMenuTableViewCell.identifier, for: indexPath) as! CategoryMenuTableViewCell
        var arrayOfRestItems = [NSDictionary]()
        
        if isFilter{
            arrayOfRestItems = (dicOfFilterItems[catType!] as? [NSDictionary]
                
                )!
        }else{
            arrayOfRestItems = (dicOfCategoryItems[catType!] as? [NSDictionary]
                
                )!
        }
       
        cell.loadSpecialItem(dicOfItem: (arrayOfRestItems[indexPath.row]))
        cell.itemTapDelegate = self
        cell.addButton.addTarget(self, action:#selector(itemAddAction(button:)), for: .touchUpInside)
        
        cell.addButton.tag = indexPath.row
        cell.animationLabel.tag = 100*(indexPath.row + 1)
        
        return cell
        
    }
    func itemAddAction(button : UIButton)
    {
        
        categoryMenuDelegate?.animationOrder(tag: button.tag)

        let arrayOfRestItems = dicOfCategoryItems[catType!] as? [NSDictionary]
        API.createMenuDic(dic: (arrayOfRestItems?[button.tag])!)
        
        categoryMenuDelegate?.addMenuItem()
        
        
    }
    
    func loadMenuItemsByCategory(type: String)
    {
        
        isFilter = false
        
        catType = type
        
        print("Load Category Menu\(type) dic \(dicOfCategoryItems)")
        
        if dicOfCategoryItems.isEmpty {
        let outData = UserDefaults.standard.data(forKey: DigitalMenu.Userdefaults.TableMenuItem)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary
        
        var arrayOfData = dict?["data"] as! [NSDictionary]

        var unSortArrayOfCateSpls = [NSDictionary]()

        var unSortArrayOfFilterSpls = [NSDictionary]()

      
        
        for index in 0..<arrayOfData.count {
            
            
            
            let maindic = arrayOfData[index]
            
            let subdicOfCategory = maindic["type"] as! [NSDictionary]
            let subdicOfFilter = maindic["filter"] as! [NSDictionary]

            for index in 0..<subdicOfFilter.count {
                
                let dic = subdicOfFilter[index]
                let filterName = dic["name"] as! String
                if unSortArrayOfFilterSpls.count != 0 {
                    
                    let filterByName = unSortArrayOfFilterSpls.filter { $0["name"] as! String == filterName }
                    print("filterByName \(filterByName)")
                    
                    if filterByName.count != 0
                    {

                        continue
                    }
                    
                }
                unSortArrayOfFilterSpls.append(subdicOfFilter[index])

            }
            
            for index in 0..<subdicOfCategory.count {
                
                
                var subArrayOfItems = [NSDictionary]()
                
                let dic = subdicOfCategory[index]
                
                let categoryName = dic["name"] as! String
                
                if unSortArrayOfCateSpls.count != 0 {
                    
                    let filterByName = unSortArrayOfCateSpls.filter { $0["name"] as! String == categoryName }
                    print("filterByName \(filterByName)")
                    
                    if filterByName.count != 0
                    {
                        
                        subArrayOfItems = (dicOfCategoryItems[categoryName] as? [NSDictionary])!
                        subArrayOfItems.append(maindic)
                        dicOfCategoryItems[categoryName] = subArrayOfItems as AnyObject?
                        
                        continue
                    }
                    
                }
                
                unSortArrayOfCateSpls.append(subdicOfCategory[index] )
                subArrayOfItems.append(maindic)
                dicOfCategoryItems[categoryName] = subArrayOfItems as AnyObject?
            }
            
            
        }
        
            self.loadFilterValue(arrayOfFilter: unSortArrayOfFilterSpls)
        }
        itemCollectionView.reloadData()

    }

    func loadFilterValue(arrayOfFilter : [NSDictionary])
    {
        
        print("arrayOfFilter\(arrayOfFilter)")
        
        arrayOfFilterType = arrayOfFilter
        
        self.filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        var totalCount = arrayOfFilterType.count
        
        let modulesOfCount  = totalCount % 4
        
        if (modulesOfCount == 0)
        {
            totalCount = totalCount/4
            
        }else{
            totalCount = (totalCount/4)+1
            
        }
        
        TotalPage = totalCount
        
        
        var indexOfPage : Int = 0
        
        for pageIndex in 0..<TotalPage {
            
            let pageView = UIView(frame: CGRect(x: 667 * CGFloat(pageIndex), y: 0, width: 667, height: self.filterScrollView.frame.size.height))
            
          
            for index in 0..<4{
                
                if indexOfPage < arrayOfFilterType.count
                {
            self.frame.origin.x = 134 * CGFloat(index) + (26.25 * CGFloat(index+1))
            self.frame.size.width = 134
            self.frame.size.height = 24
            self.frame.origin.y = (self.filterScrollView.frame.size.height - 24)/2
            self.filterScrollView.isPagingEnabled = true

            let subView = UIView(frame: self.frame)
            subView.backgroundColor = UIColor.clear
            
            let button = UIButton(frame: CGRect(x: self.frame.origin.x, y:self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height))
            button.setImage(UIImage.init(named: "Filter bg_active"), for: UIControlState.selected)
            button.setImage(UIImage.init(named: "Filter bg"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(filterAction(button:)), for: .touchUpInside)
            button.tag = indexOfPage
            pageView.addSubview(button)
            
            let dic = arrayOfFilterType[indexOfPage]
            let filterName = dic["name"] as! String

            
            let titleLabel = UILabel(frame: CGRect(x:  self.frame.origin.x, y: self.frame.origin.y-1, width: self.frame.size.width, height: self.frame.size.height))
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.text = filterName
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.textColor = UIColor.white
            titleLabel.tag = (100*(indexOfPage+1))
            
            pageView.addSubview(titleLabel)
                
            indexOfPage += 1
                }

            }
            self.filterScrollView.addSubview(pageView)
            
        }
        self.filterScrollView.contentSize = CGSize(width: self.filterScrollView.frame.size.width * CGFloat(TotalPage) , height: self.filterScrollView.frame.size.height)

        updatePageValue()
        
    }
    

    func filterAction(button : UIButton)
    {
       
        if prevBtn != nil && prevBtn != button
        {
            if (prevBtn?.isSelected)!{
                prevBtn?.isSelected = false
            }
            if let theLabel = self.filterScrollView.viewWithTag(100*((prevBtn?.tag)!+1)) as? UILabel {
                theLabel.textColor = UIColor.white
            }
        }
        if button.isSelected{
            button.isSelected = false
            isFilter = false
            if let theLabel = self.filterScrollView.viewWithTag(100*((button.tag)+1)) as? UILabel {
                theLabel.textColor = UIColor.white
            }

        }else{
            
            button.isSelected = true
            isFilter = true
            if let theLabel = self.filterScrollView.viewWithTag(100*((button.tag)+1)) as? UILabel {
                theLabel.textColor = UIColor.DigitalMenu.AppColor
            }
        }
        
        
        print("dic of filter\(arrayOfFilterType[button.tag])")
        
        let filterDic = arrayOfFilterType[button.tag]
        let arrayOfRestItems = dicOfCategoryItems[catType!] as! [NSDictionary]
        print("arrayOfRestItems\(arrayOfRestItems)")
        
        var subArrayOfFilterItems = [NSDictionary]()

        for index in 0..<arrayOfRestItems.count {
            
            
            
            let maindic = arrayOfRestItems[index]
            
            let subdicOfFilter = maindic["filter"] as! [NSDictionary]
            
            for filterIndex in 0..<subdicOfFilter.count
            {
                let mainFilterDic = subdicOfFilter[filterIndex] as NSDictionary
                
                if mainFilterDic == filterDic
                {
                    subArrayOfFilterItems.append(maindic)
                }
                
            }
        }
        dicOfFilterItems[catType!] = subArrayOfFilterItems as AnyObject?
        itemCollectionView.reloadData()
        
        prevBtn = button
    }

    func updatePageValue()
    {
        
        print("TotalPage\(TotalPage)")
        if self.currenPage < self.TotalPage
        {
            
            if currenPage == TotalPage{
                leftArrowBtn.isHidden = true
                rightArrowBtn.isHidden = true
            }else if currenPage == 1{
                leftArrowBtn.isHidden = true
                rightArrowBtn.isHidden = false
            }
            else{
                leftArrowBtn.isHidden = false
                rightArrowBtn.isHidden = false
            }
            
        }else if currenPage == TotalPage
        {
            leftArrowBtn.isHidden = true
            rightArrowBtn.isHidden = true

        }else  if self.currenPage >= self.TotalPage{
            
            leftArrowBtn.isHidden = false
            rightArrowBtn.isHidden = true

        }
        
        
    }
    @IBAction func rightArrowAction(_ sender: Any) {
        if (currenPage < TotalPage) {
            
            currenPage += 1
            
            self.filterScrollView.scrollRectToVisible(CGRect(x:self.filterScrollView.frame.size.width * CGFloat(currenPage-1), y: self.filterScrollView.frame.origin.y, width: self.filterScrollView.frame.size.width, height: self.filterScrollView.frame.size.height), animated: true)
            updatePageValue()
        }

    }
    @IBAction func leftArrowAction(_ sender: Any) {
        currenPage -= 1
        self.filterScrollView.scrollRectToVisible(CGRect(x:self.filterScrollView.frame.size.width * CGFloat(currenPage-1), y: self.filterScrollView.frame.origin.y, width: self.filterScrollView.frame.size.width, height: self.filterScrollView.frame.size.height), animated: true)

        updatePageValue()
    }

}

extension ListOfItemViewController : UIScrollViewDelegate
{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentpage = scrollView.contentOffset.x / scrollView.frame.size.width
        print("currentpage\(currentpage)")
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
    func DetailMenuAddAction() {
        self.categoryMenuDelegate?.addMenuItem()
        
    }
}
