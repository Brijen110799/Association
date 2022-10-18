//
//  DialogAddEmergencyContact.swift
//  Finca
//
//  Created by harsh panchal on 04/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ContactsUI
import DropDown
class DialogAddEmergencyContact: BaseVC {
    var relationMember = [String]()
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    
    @IBOutlet weak var lblRelation: UILabel!
    
    @IBOutlet weak var relationView: UIView!
    @IBOutlet weak var bAdd: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    
    var emergencyContactsVC : EmergencyContactsVC!
    
    @IBOutlet weak var tfOtherRelation: UILabel!
    let dropDown = DropDown()
     let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    var contactStore = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.relationMember =  doGetLocalDataUser().isSociety ?  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"] : ["Owner","Employee","Other"]
        relationMember = doGetValueLanguageArrayString(forKey: "relation_society")
        lblRelation.text = relationMember[0]
        tfName.delegate = self
//        tfName.selectedTitle = ""
//        tfMobileNumber.selectedTitle = ""

//        tfName.title = ""
//        tfMobileNumber.title = ""
//        tfRelation.title = ""
        
        tfName.placeholder = "\(doGetValueLanguage(forKey: "name"))*"
        tfMobileNumber.placeholder = "\(doGetValueLanguage(forKey: "emergency_number"))*"
        tfRelation.placeholder =  "\(doGetValueLanguage(forKey: "enter_relation_here"))*"
        
       
        
        addKeyboardAccessory(textFields: [tfName,tfMobileNumber,tfRelation], dismissable: true, previousNextable: true)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        self.relationView.isHidden = true
        bAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        
    }
    @IBAction func btnSelectRelationClicked(_ sender: UIButton) {
        dropDown.anchorView = lblRelation
        dropDown.dataSource = relationMember
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblRelation.text = self.dropDown.selectedItem
            if self.lblRelation.text == doGetValueLanguage(forKey: "other_relation"){
                self.relationView.isHidden = false
            }else{
                self.relationView.isHidden = true
            }
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDoCallAdd(_ sender: UIButton) {
        if doValidateParams() {
//            if self.lblRelation.text != doGetValueLanguage(forKey: "other_relation"){
//                self.doCallAPi()
//            }else if tfOtherRelation.text == "" && tfOtherRelation.text!.isEmptyOrWhitespace(){
//                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_member_relation"))
//                    return
//                }
//            self.lblRelation = tfOtherRelation
            doCallAPi()
        }
    }
    @IBAction func btnSelectFromContactList(_ sender: UIButton) {
        
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
    func onClickPickContact(){
       
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        self.present(contactPicker, animated: true, completion: nil)
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
    func doValidateParams() -> Bool {
        var isValid = true
        if tfName.text == ""{
            isValid = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "emergency_contact_name"))
           // tfName.errorMessage = doGetValueLanguage(forKey: "emergency_contact_name")
        }
        if  tfMobileNumber.text!.count < 3 || tfMobileNumber.text!.count > 13 || tfMobileNumber.text!.containsSpecialCharacter{
            isValid = false
            self.showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "emergency_number_between_digits"))
           /// tfMobileNumber.errorMessage = doGetValueLanguage(forKey: "emergency_number_between_digits")

        }
        if tfRelation.text == ""{
            isValid = false
            
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "contact_relation"))
            //tfRelation.errorMessage = doGetValueLanguage(forKey: "contact_relation")
        }
        
        return isValid
    }
    func doCallAPi(){
        showProgress()
        let params = ["key":apiKey(),
                      "setEmergencyContact":"setEmergencyContact",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "emergencyContact_id":"0",
                      "person_name":tfName.text!,
                      "relation":tfRelation.text!,
                      "person_mobile":tfMobileNumber.text!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
                        self.dismiss(animated: true, completion: {
                            self.emergencyContactsVC.doRecallData()
                        })
                    }else {
                       self.showAlertMessage(title: "", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == tfName  {
               let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
               let filtered = string.components(separatedBy: cs).joined(separator: "")
               
               return (string == filtered)
               
           }
           return true
       }
       
}
extension DialogAddEmergencyContact : CNContactPickerDelegate
{
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName
        
        var primaryPhoneNumberStr = ""
        if contact.phoneNumbers.count > 0 {
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            print(firstPhoneNumber)
            primaryPhoneNumberStr = firstPhoneNumber.stringValue
        }
        tfName.text = userName
        tfMobileNumber.text = primaryPhoneNumberStr.replacingOccurrences(of: "+91", with: "")

    }
}
extension DialogAddEmergencyContact: AppDialogDelegate{
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
