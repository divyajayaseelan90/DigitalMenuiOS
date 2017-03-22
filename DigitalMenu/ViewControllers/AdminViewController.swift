//
//  AdminViewController.swift
//  DigitalMenu
//
//  Created by divya jayaseelan on 3/22/17.
//  Copyright © 2017 divya jayaseelan. All rights reserved.
//

import Foundation
protocol AdminDelegate {
    func closeAdminPage()
    func submitPin()
}

class AdminViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UIView!

    @IBOutlet weak var pinTxtFld: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var delegate : AdminDelegate?
    
    var tablenumberArray : NSArray?
    @IBOutlet weak var tablenumberCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialize()
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(AdminViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        viewType(type: "Pin")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.window?.frame.origin.y = 0
    }
    
    
    func intialize()
    {
        
        mainView.translatesAutoresizingMaskIntoConstraints = true
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 0.5
        transition.subtype = kCATransitionFromTop
        mainView.layer.add(transition, forKey: "animation")
        
        
        subView.layer.cornerRadius = 10.0
        subView.layer.borderColor = UIColor.white.cgColor
        subView.layer.borderWidth = 0.5
        subView.clipsToBounds = true
        
        setButtonAttributes(button: submitBtn)
        setTextFieldAttributes(textField: pinTxtFld)
        
        
    }
    func setButtonAttributes(button : UIButton) {
        
        button.backgroundColor = UIColor.DigitalMenu.AppColor
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 0.5
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0.5
    }
    func setTextFieldAttributes(textField : UITextField)
    {
        let textBorderColor = UIColor.gray.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 0.5
        textField.clipsToBounds = true
        textField.layer.borderColor = textBorderColor.cgColor
        
        let paddingView = UIView(frame: CGRect(x:0, y: 0, width: 15, height: 15))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
        
    }
    func loadTableNumber()
    {
        if UserDefaults.standard.value(forKey: DigitalMenu.Userdefaults.FeedbackAppTableNumberArray) != nil
        {
            
            tablenumberArray = (UserDefaults.standard.array(forKey: DigitalMenu.Userdefaults.FeedbackAppTableNumberArray) as NSArray?)
            self.tablenumberCollectionView.reloadData()

            print("TableNumber \((UserDefaults.standard.array(forKey: DigitalMenu.Userdefaults.FeedbackAppTableNumberArray) as NSArray?))")

        }else{
            API.getTableNumbers(completionClosure: { (arrayOfTablenumber : NSArray,displayMessage : String) -> () in
                
                SVProgressHUD.dismiss()
                self.tablenumberArray = arrayOfTablenumber
                self.tablenumberCollectionView.reloadData()

                
            })
        }
        
        print("tablenumberArray \(self.tablenumberArray?.count)")
            
        
    }
    func viewType (type :String)
    {
        if type == "Pin"
        {
            mainView.isHidden = false
            tableView.isHidden = true

        }else{
            mainView.isHidden = true
            tableView.isHidden = false
            self.loadTableNumber()
        }
    }
    func clearText ()
    {
        self.pinTxtFld.text = ""
        self.pinTxtFld.resignFirstResponder()
        
    }
    @IBAction func closeAction(_ sender: Any) {
        
        clearText()
        self.delegate?.closeAdminPage()
        
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        if pinTxtFld.text?.characters.count != 0{
            
            SVProgressHUD.show()
            
            API.validatePin(restPin: pinTxtFld.text, completionClosure: {(message, response,displayMessage) ->() in
                
                SVProgressHUD.dismiss()
                
                if message == AlertMessage.success.rawValue
                {
                    API.syncRestaurantConfig(completionClosure: { _ in
                          API.getTaxes(completionClosure: { _ in
                        })
                        
                    })
                    UserDefaults.standard.setValue(response?["session"] as? String, forKey: DigitalMenu.Userdefaults.RestaurantId)
                    UserDefaults.standard.setValue(self.pinTxtFld.text, forKey: DigitalMenu.Userdefaults.Pin)
                    NotificationCenter.default.post(name: Notification.Name(DigitalMenu.LocalNotification.name), object: nil)

                    self.clearText()
                    
                    self.viewType(type: "Table")

                    
                }else{
                    API.showAlert(AlertMessage.failure.rawValue, message: displayMessage!)
                }
                
                
                
            })
        }else{
            API.showAlert(AlertMessage.failure.rawValue, message: DefaultText.textEmpty.rawValue)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if ((tablenumberArray?.count) != nil){
        return (tablenumberArray?.count)!
        }
        return 0
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UserDefaults.standard.setValue(tablenumberArray?[indexPath.row] as? AnyObject as! String?, forKey: DigitalMenu.Userdefaults.Tablenumber)
        
        self.delegate?.closeAdminPage()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TableNumberCollectionCell
        
        cell.myLabel.text = tablenumberArray?[indexPath.row] as? AnyObject as! String?

        
    
        return cell
        
    }


}
extension AdminViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        self.mainView.translatesAutoresizingMaskIntoConstraints = true
        self.mainView.frame.origin.y = 100
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.mainView.frame.origin.y = 244
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.mainView.frame.origin.y = 244
        
        return true;
    }
}
