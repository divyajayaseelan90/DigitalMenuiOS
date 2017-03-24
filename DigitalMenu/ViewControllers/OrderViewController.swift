//
//  OrderViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/20/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
protocol OrderItemDelegate {
    func addMenuItem()
    func animationOrder(tag : Int)
}
class OrderViewController : UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var orderListingTableView : UITableView!
    @IBOutlet weak var serviceTax : UILabel!
    @IBOutlet weak var serviceCharge : UILabel!
    @IBOutlet weak var laxuryTax : UILabel!
    @IBOutlet weak var netAmount : UILabel!
    
    @IBOutlet weak var taxListingTableView : UITableView!

    var arrayOfOrderItem = [NSDictionary]()
    var delegate : OrderItemDelegate?
    var arrayOfTax = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListingTableView.register(UINib(nibName: OrderListingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderListingTableViewCell.identifier)

    }
    
    func loadOrderItem()
    {
        

        arrayOfOrderItem = API.Static.arrayOfItemDic
        orderListingTableView.reloadData()

        
        let outData = UserDefaults.standard.data(forKey: DigitalMenu.Userdefaults.TaxArray)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary
        arrayOfTax = dict?["data"] as! [NSDictionary]
        taxListingTableView.reloadData()

        

        serviceTax.text = "₹ "+String(API.Static.netAmountserviceTax)
        serviceCharge.text = "₹ "+String(API.Static.netAmountserviceCharge)
        laxuryTax.text = "₹ "+String(API.Static.netAmountlaxuryTax)
        netAmount.text = "₹ "+String(API.Static.netAmount)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
     func numberOfSections(in tableView: UITableView) -> Int {
      return 1
     }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == orderListingTableView{
            return 40
        }else{
            return 30
        }
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderListingTableView{
            return arrayOfOrderItem.count
        }else{
            return arrayOfTax.count

        }
     
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if tableView == orderListingTableView{

         var cell : OrderListingTableViewCell
         cell = tableView.dequeueReusableCell(withIdentifier: OrderListingTableViewCell.identifier) as! OrderListingTableViewCell
         cell.sno.text = String(indexPath.row+1)
         cell.setItem(dic: arrayOfOrderItem[indexPath.row])
         cell.orderListingDelegate = self
         cell.backgroundColor = UIColor.clear
         cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell

        }else{
            
            print("index \(arrayOfTax[indexPath.row]) identifier \(TaxTableViewCell.identifier)")
            
            var cell : TaxTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: TaxTableViewCell.identifier) as! TaxTableViewCell
            
            let subdic = arrayOfTax[indexPath.row]
            
            if let taxType = subdic["taxType"] as? NSDictionary{
                
                let taxdisplayName = taxType["displayName"] as? String
                cell.taxLabel.text = taxdisplayName! + ":"

            }
            cell.taxLabel.backgroundColor = UIColor.clear

            let totalTaxAmount : Float = API.calculateTaxDeduction(amount: API.Static.totalAmount, percentage: (subdic["tax"] as? Float)!)
            
            cell.taxLabelAmount.text = "₹ "+String(totalTaxAmount)
            cell.taxLabelAmount.backgroundColor = UIColor.clear
            
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        }
     
     }
    func calculateTaxDeduction (amount : Float, percentage : Float) -> Float
    {
        let amountOfDeduction : Float = (amount * percentage)/100
        return amountOfDeduction
    }
}
extension OrderViewController : orderListingDelegate
{
    func updateNetAmount() {
        
        netAmount.text = "₹ "+String(API.Static.netAmount)
        delegate?.addMenuItem()
        taxListingTableView.reloadData()
        loadOrderItem()

    }
}
