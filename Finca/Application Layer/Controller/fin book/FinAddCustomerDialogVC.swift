//
//  FinAddCustomerDialogVC.swift
//  Finca
//
//  Created by Jay Patel on 01/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import ContactsUI
import SkyFloatingLabelTextField
import AddressBookUI
import EzPopup
class FinAddCustomerDialogVC: BaseVC {
    enum DialogType{
        case Update
        case Add
    }
    @IBOutlet weak var tfCustomerName: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAdd: UIButton!

    @IBOutlet weak var tfMobileNumber: SkyFloatingLabelTextField!

    @IBOutlet weak var tfCustomerAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var btnCancel: UIButton!
    var customerData : CustomerListModel!
    var context : FinBookVC!
    var dialogType : DialogType = .Add
    var editContext : CustomerAccountDetailsVC!
    var contactStore = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: [tfCustomerName,tfMobileNumber,tfCustomerAddress])
      
        if self.dialogType == .Update{
            self.tfCustomerName.text = customerData.customerName!
            self.tfMobileNumber.text = customerData.customerMobile!
            self.tfCustomerAddress.text = customerData.customerAddress!
            self.btnAdd.setTitle(doGetValueLanguage(forKey: "update"), for: .normal)
        }else{
            self.btnAdd.setTitle(doGetValueLanguage(forKey: "add"), for: .normal)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tfCustomerName.placeholder("\(doGetValueLanguage(forKey: "customer_name"))*")
        tfMobileNumber.placeholder("\(doGetValueLanguage(forKey: "mobile_number"))*")
        tfCustomerAddress.placeholder(doGetValueLanguage(forKey: "addresses"))
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel"), for: .normal)
        tfMobileNumber.keyboardType = .numberPad
//        tfMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile No*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func btnAddClicked(_ sender: UIButton) {
        if doValidate(){
            self.doAddCustomer()
        }
    }

    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSelectFromContactsClicked(_ sender: UIButton) {
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (granted){
                let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
                
                switch authorizationStatus {
                case .authorized:
                    self.onClickPickContact()
                    
                  case .denied:
                    self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                        if access {
                            self.onClickPickContact()
                        }
                        else {
                            if authorizationStatus == CNAuthorizationStatus.denied {
                                DispatchQueue.main.async {
                                    _ = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                                }
                              
                            }
                        }
                    })
                    
                default: break
                // completionHandler(accessGranted: false)
                }
            } else {
                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "fincasys_needs_contacts"), style: .Add, cancelText: self.doGetValueLanguage(forKey: "cancel").uppercased(), okText: self.doGetValueLanguage(forKey: "ok").uppercased())
            }
        })
        
        
    }
    
//    func ContactPermission()
//    {
//        let screenwidth = UIScreen.main.bounds.width
//        let screenheight = UIScreen.main.bounds.height
//        let nextVC = DialogNotificationSound()
//
//        let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10, popupHeight: screenheight)
//        popupVC.backgroundAlpha = 0.8
//        popupVC.backgroundColor = .black
//        popupVC.shadowEnabled = true
//        popupVC.canTapOutsideToDismiss = false
//        present(popupVC, animated: true)
//    }

    func doValidate() -> Bool{
        var flag = true
        if tfCustomerName.text! == ""{
            flag = false
            self.tfCustomerName.errorMessage = doGetValueLanguage(forKey: "please_enter_valid_name")
        }

        if tfMobileNumber.text == ""{
            flag = false
            self.tfMobileNumber.errorMessage = doGetValueLanguage(forKey: "please_enter_valid_mobile_number")
          
        }

        if tfMobileNumber.text!.count < 8 || tfMobileNumber.text!.containsSpecialCharacter{
            flag = false
            self.tfMobileNumber.errorMessage = ("mobile number must have 8 to 15 digits")
        }else{
            self.tfMobileNumber.errorMessage = ""
        }
        return flag
    }
    func doAddCustomer(){
        var params = [String : String]()
        if dialogType == .Add{
            params = ["addCustomer":"addCustomer",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "customer_name":tfCustomerName.text!,
                      "customer_mobile":tfMobileNumber.text!,
                      "customer_address":tfCustomerAddress.text!]
        }else{
            params = ["editCustomer":"editCustomer",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "finbook_customer_id":customerData.finbookCustomerId!,
                      "customer_name":tfCustomerName.text!,
                      "customer_mobile":tfMobileNumber.text!,
                      "customer_address":tfCustomerAddress.text!]
        }

        print("parmas",params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.dismiss(animated: true){
                            if self.dialogType == .Add{
                                self.context.fetchNewDataOnRefresh()
                                self.context.toast(message: response.message, type: .Success)
                            }else{
                                self.editContext.navigationController?.popViewController(animated: true)
                                self.editContext.context.toast(message: response.message, type: .Information)
                            }
                        }
                    }else{

                    }
                }catch{
                    print("parse Error",error)
                }
            }
        }
    }
}
extension FinAddCustomerDialogVC : CNContactPickerDelegate
{
    func onClickPickContact(){
       
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way

        // user name
        let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName

        var number = ""
        if contact.phoneNumbers.count > 0 {
            // user phone number
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            number = firstPhoneNumber.stringValue
        }
   

        var conatct = ""
        if number.contains("+") {
            conatct = String(number.dropFirst(3))
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        } else if number.contains("-") {
            conatct = number.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else {
            conatct = number.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        tfCustomerName.text = userName
        tfMobileNumber.text = conatct
    }

}
extension FinAddCustomerDialogVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Add{
            dismiss(animated: true) {
                
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                }
                
            }
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

