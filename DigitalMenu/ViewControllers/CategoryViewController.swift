//
//  CategoryViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/7/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
import UIKit
protocol categorySelectionDelegate {
    func selectedCategory(type : String)
}

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var categoryTableView: UITableView!

    var arrayOfCategory = [NSDictionary]()
    var prevIndexpath : NSIndexPath?
    var delegate : categorySelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.methodOfReceivedNotification), name:NSNotification.Name(rawValue: DigitalMenu.LocalNotification.refreshMenu), object: nil)

        categoryTableView.register(UINib(nibName: CatergoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CatergoryTableViewCell.identifier)

    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        
        let outData = UserDefaults.standard.data(forKey: DigitalMenu.Userdefaults.TableMenuItem)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary
        
        
        var arrayOfData = dict?["data"] as! [NSDictionary]
        
        for index in 0..<arrayOfData.count {
            
            let dic = arrayOfData[index] 
            
            let subdicOfCategory = dic["type"] as! [NSDictionary]
            
            for index in 0..<subdicOfCategory.count {

                let dic = subdicOfCategory[index] 
                
                let categoryName = dic["name"] as! String
                
                if arrayOfCategory.count != 0 {
                    
                    let filterByName = arrayOfCategory.filter { $0["name"] as! String == categoryName }
                    print("filterByName \(filterByName)")
                    
                    if filterByName.count != 0
                    {
                        continue
                    }
                    
                }
                
                arrayOfCategory.append(subdicOfCategory[index] )

            }
            
        }
        categoryTableView.reloadData()

        print("arrayOfCategory\(arrayOfCategory)")
        print("dic of response \(arrayOfData)")
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CatergoryTableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: CatergoryTableViewCell.identifier) as! CatergoryTableViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let dic = arrayOfCategory[indexPath.row] as? NSDictionary
    
        cell.setCategory(dic: dic!)
        
        return cell
            
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if prevIndexpath != nil
        {
            let previousCell = tableView.cellForRow(at: prevIndexpath! as IndexPath) as! CatergoryTableViewCell
            previousCell.categoryAction(previousCell.categoryButton)

        }
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! CatergoryTableViewCell
        currentCell.categoryAction(currentCell.categoryButton)
        
        let dic = arrayOfCategory[(indexPath?.row)!]
        delegate?.selectedCategory(type: dic["name"] as! String)
        
        prevIndexpath  = indexPath as NSIndexPath?
        
        
       
        
    }
}

