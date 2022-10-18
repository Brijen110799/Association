//
//  AddEmergencyNumberBS.swift
//  Finca
//
//  Created by harsh panchal on 17/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown
import ContactsUI
class AddEmergencyNumberBS: BaseVC {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var tfEmergencyNumber: UITextField!
    
    @IBOutlet weak var tfOtherRelation: UITextField!
    // @IBOutlet weak var tfOtherRelation: UILabel!
    @IBOutlet weak var relationView: UIView!
    @IBOutlet weak var lblEmergenceName: UILabel!
    @IBOutlet weak var lblEmergencyNumberTitle: UILabel!
   // @IBOutlet weak var lblRelationMember: UILabel!
    @IBOutlet weak var lblOtherRelationMember: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    var relationMember = [String]()
    var context : UserProfileVC!
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.relationMember =  doGetLocalDataUser().isSociety ?  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"] : ["Owner","Employee","Other"]
      
        relationMember = doGetValueLanguageArrayString(forKey: "relation_society")
      //  self.lblRelation.text = relationMember[0]
        
       // initDropdown()
        addKeyboardAccessory(textFields: [tfName,tfEmergencyNumber], dismissable: true, previousNextable: true)
       // self.relationView.isHidden = true
        lblEmergenceName.text = "\(doGetValueLanguage(forKey: "name"))*"
        lblEmergencyNumberTitle.text = "\(doGetValueLanguage(forKey: "emergency_numbers"))*"
        //lblRelationMember.text = doGetValueLanguage(forKey: "relation_with_member")
        lblOtherRelationMember.text = "\(doGetValueLanguage(forKey: "relation_with_member"))*"
        tfOtherRelation.placeholder =  "\(doGetValueLanguage(forKey: "enter_relation_here"))*"
      
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        btnAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
    }
    
    @IBAction func btnSelectRelation(_ sender: UIButton) {
        dropDown.show()
        
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.sheetViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        
     
        if isValidate() {

            doSubmitData()
        }
            
    }
    
    func initDropdown(){
        dropDown.anchorView = lblRelation
        dropDown.dataSource = relationMember
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblRelation.text = self.dropDown.selectedItem
            if self.lblRelation.text == doGetValueLanguage(forKey: "other_relation"){
                self.sheetViewController?.setSizes([.fixed(380)], animated: true)
                self.relationView.isHidden = false
            }else{
                self.sheetViewController?.setSizes([.fixed(310)], animated: true)
                self.relationView.isHidden = true
            }
            
        }
        //        dropDown.width = btnDropdownRelation.frame.width
    }
    
    
    func isValidate() -> Bool {
        var validate = true
        if tfName.text == "" {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_name"))
            validate = false
        }
        
        if tfEmergencyNumber.text!.count < 3 || tfEmergencyNumber.text!.count > 13 || tfEmergencyNumber.text!.containsSpecialCharacter {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_emergency_number"))
            validate = false
        }
             
        if tfOtherRelation.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "contact_relation"))
            validate = false
         }
        
        return validate
    }
    
    func doSubmitData() {
        showProgress()
      
        let params = ["key":apiKey(),
                      "setEmergencyContact":"setEmergencyContact",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "emergencyContact_id":"0",
                      "person_name":tfName.text!,
                      "relation": tfOtherRelation.text!,
                      "person_mobile":tfEmergencyNumber.text!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        //                    self.profilePersonalDetailVC.isAddEmergancyMember = true
                        self.sheetViewController!.dismiss(animated: false) {
                            self.context.refreshPage()
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
    @IBAction func tapConatctPick(_ sender: UIButton) {
        
        if checkContactPermision(){
            self.onClickPickContact()
        } else {
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "fincasys_needs_contacts"), style: .Add, cancelText: self.doGetValueLanguage(forKey: "cancel").uppercased(), okText: self.doGetValueLanguage(forKey: "ok").uppercased())
        }
        
    }
}
extension AddEmergencyNumberBS : CNContactPickerDelegate,AppDialogDelegate{
   func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
       if dialogType == .Add{
           dismiss(animated: true) {
               if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
               }
           }
       }
   }
    func onClickPickContact(){

        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)

    }
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {

    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way

        // user name
        let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName

        tfName.text = userName
        // user phone number
        var number = ""
        if contact.phoneNumbers.count > 0 {
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            // user phone number string
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

        tfEmergencyNumber.text = conatct

//        doCall(on: conatct)

    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
