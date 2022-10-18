//
//  ViewController.swift
//  Finca
//
//  Created by anjali on 03/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//
//
import UIKit
//import DropDown
import DropDown
struct ModelInfoMember {
    var name:String!
    var number:String!
    var relation:String!
    var isEmergancy:Bool!
}
class DailogFamilyMember: BaseVC {
    @IBOutlet weak var lbDropDown: UILabel!
    @IBOutlet weak var tfNAme: ACFloatingTextfield!
    var context : ProfileVC!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfAge: ACFloatingTextfield!
    @IBOutlet weak var lbHeader: UILabel!
    
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bAdd: UIButton!
    
    @IBOutlet weak var ivImageClose: UIImageView!
    @IBOutlet weak var tfMobileNumber: ACFloatingTextfield!
    
    @IBOutlet weak var heightConMobile: NSLayoutConstraint!
    var isCheck = true
    var user_status = "2"
    @IBOutlet weak var ivCheck: UIImageView!
    let dropDown = DropDown()
    let titleMembers = StringConstants.KEY_RELEATION_ARRAY
    var profilePersonalDetailVC:ProfilePersonalDetailVC!
    let datePicker = UIDatePicker()
    var modelFamilyMember:ModelFamilyMember!
    var user_id:String!
    var isUpdate : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbDropDown.text = "Dad"
        tfNAme.autocorrectionType = .no
        //tfAge.isEnabled  = false
        tfNAme.delegate = self
        tfAge.delegate = self
        tfLastName.delegate = self
        tfMobileNumber.delegate = self
        ivImageClose.setImageColor(color: .white)
        addKeyboardAccessory(textFields: [tfNAme,tfLastName])
        doneButtonOnKeyboard(textField: tfMobileNumber)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        heightConMobile.constant = 0
        if isUpdate {
            lbHeader.text = "   Update Family Member"
            bAdd.setTitle("UPDATE", for: .normal)
            bCancel.setTitle("DELETE", for: .normal)
            
            tfAge.text = modelFamilyMember.member_date_of_birth
            tfNAme.text = modelFamilyMember.user_first_name
            tfLastName.text = modelFamilyMember.user_last_name
            lbDropDown.text = modelFamilyMember.member_relation_name
            
            if modelFamilyMember.user_status == "1" {
                isCheck = true
                user_status = "1"
                heightConMobile.constant = 40
                ivCheck.image = UIImage(named: "check_box")
                tfMobileNumber.text = modelFamilyMember.user_mobile
                tfMobileNumber.isEnabled = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "yyyy-MM-dd"
                let date = dateFormatter.date(from: modelFamilyMember.member_date_of_birth!)
                datePicker.date = date!
            }
            
        }
        showDatePicker()
        
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
       if tfMobileNumber.isEditing{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tfAge.inputAccessoryView = toolbar
        tfAge.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        tfAge.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @IBAction func onClickcCose(_ sender: Any) {
        //        self.removeFromParent()
        //        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelDatePicker(){
           self.view.endEditing(true)
       }
    
    @IBAction func onClickCreateLogin(_ sender: Any) {
        if isCheck {
            isCheck = false
            heightConMobile.constant = 40
            ivCheck.image = UIImage(named: "check_box")
            user_status = "1"
        } else {
            isCheck = true
            heightConMobile.constant = 0
            ivCheck.image = UIImage(named: "check_box_uncheck")
            user_status = "2"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfMobileNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    @IBAction func onClickDropDoen(_ sender: Any) {
        dropDown.anchorView = lbDropDown
        dropDown.dataSource = titleMembers
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbDropDown.text = item
        }
        
        dropDown.show()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        
        if bCancel.titleLabel?.text == "DELETE" {
            doDeleteMember()
        }else {
            //            self.removeFromParent()
            //            self.view.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func onClickAdd(_ sender: Any) {
        if isValidate() {
            doSubmitData()
        }
    }
    
    func isValidate() -> Bool {
        var validate = true
        
        if tfNAme.text == "" {
            showAlertMessage(title: "", msg: "Enter First Name")
            validate = false
        }
        if tfLastName.text == "" {
            showAlertMessage(title: "", msg: "Enter Last Name")
            validate = false
        } 
        if user_status == "1" {
            if tfMobileNumber.text!.count < 10 {
                showAlertMessage(title: "", msg: "Enter Valid Number")
                validate = false
            }
            
        }
        return validate
    }
    
    func doSubmitData() {
        showProgress()
        let params = ["key":apiKey(),
                      "setFamilymember":"setFamilymember",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":user_id!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":tfNAme.text!,
                      "user_last_name":tfLastName.text!,
                      "member_date_of_birth":tfAge.text!,
                      "member_relation":lbDropDown.text!,
                      "member_status":doGetLocalDataUser().memberStatus!,
                      "user_status":user_status,
                      "user_mobile":tfMobileNumber.text!,
                      "parent_id":doGetLocalDataUser().userID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                      //  self.profilePersonalDetailVC.isAddFamilyMember = true
                         self.profilePersonalDetailVC.doGetFamilyMember()
                        self.dismiss(animated: true) {
                         ///   self.context.refreshPage()
                        }
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doDeleteMember() {
        showProgress()
        let params = ["key":apiKey(),
                      "deleteFamilyMember":"deleteFamilyMember",
                      "user_id":user_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                       // self.profilePersonalDetailVC.isAddFamilyMember = true
                        self.profilePersonalDetailVC.doGetFamilyMember()
                        self.dismiss(animated: true, completion: nil)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

