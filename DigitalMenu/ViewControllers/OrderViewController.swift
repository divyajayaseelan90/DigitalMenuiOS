//
//  OrderViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/20/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation

class OrderViewController : UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var orderListingTableView : UITableView!
    @IBOutlet weak var serviceTax : UILabel!
    @IBOutlet weak var serviceCharge : UILabel!
    @IBOutlet weak var laxuryTax : UILabel!
    @IBOutlet weak var netAmount : UILabel!
    
    
    var arrayOfOrderItem = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListingTableView.register(UINib(nibName: OrderListingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderListingTableViewCell.identifier)

    }
    
    func loadOrderItem()
    {
        

        arrayOfOrderItem = API.Static.arrayOfItemDic
        orderListingTableView.reloadData()
        
        serviceTax.text = "₹ "+String(API.Static.serviceTax)
        serviceCharge.text = "₹ "+String(API.Static.serviceCharge)
        laxuryTax.text = "₹ "+String(API.Static.laxuryTax)
        netAmount.text = "₹ "+String(API.Static.netAmount)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
     func numberOfSections(in tableView: UITableView) -> Int {
      return 1
     }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrayOfOrderItem.count
     
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     var cell : OrderListingTableViewCell
     cell = tableView.dequeueReusableCell(withIdentifier: OrderListingTableViewCell.identifier) as! OrderListingTableViewCell
     cell.sno.text = String(indexPath.row+1)
     cell.setItem(dic: arrayOfOrderItem[indexPath.row])
    cell.orderListingDelegate = self
     cell.backgroundColor = UIColor.clear
     cell.selectionStyle = UITableViewCellSelectionStyle.none
     return cell
     
     
     }
 
}
extension OrderViewController : orderListingDelegate
{
    func updateNetAmount() {
        
        netAmount.text = "₹ "+String(API.Static.netAmount)

        
    }
}
