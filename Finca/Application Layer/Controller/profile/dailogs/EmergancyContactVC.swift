//
//  EmergancyContactVC.swift
//  Finca
//
//  Created by anjali on 21/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import DropDown
class EmergancyContactVC: BaseVC {
    @IBOutlet weak var lbDropDown: UILabel!
    @IBOutlet weak var tfNAme: ACFloatingTextfield!
    @IBOutlet weak var tfMobileNumber: ACFloatingTextfield!
    var user_id:String!
    let dropDown = DropDown()
    let titleMembers = StringConstants.KEY_RELEATION_ARRAY
    var profilePersonalDetailVC:ProfilePersonalDetailVC!
    var context : ProfileVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbDropDown.text = "Dad"
        tfNAme.autocorrectionType = .no
        //tfAge.isEnabled  = false
        tfNAme.delegate = self
        tfMobileNumber.delegate = self
        doneButtonOnKeyboard(textField: tfMobileNumber)
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    override func doneClickKeyboard() {
        view.endEditing(true)
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
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickAdd(_ sender: Any) {
        
        if isValidate() {
            
            doSubmitData()
        }
        
    }
    
    func isValidate() -> Bool {
        var validate = true
        if tfNAme.text == "" {
            showAlertMessage(title: "", msg: "Enter  Name")
            validate = false
        }
        
        if tfMobileNumber.text!.count < 10 {
            showAlertMessage(title: "", msg: "Enter Valid Number")
            validate = false
        }
        
        return validate
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
    func doSubmitData() {
        showProgress()
        let params = ["key":apiKey(),
                      "setEmergencyContact":"setEmergencyContact",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "emergencyContact_id":"0",
                      "person_name":tfNAme.text!,
                      "relation":lbDropDown.text!,
                      "person_mobile":tfMobileNumber.text!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.profilePersonalDetailVC.isAddEmergancyMember = true
                        self.dismiss(animated: true) {
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
}
