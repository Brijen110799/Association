//
//  TenantEditBasicInfoVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 16/07/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class TenantEditBasicInfoVC: BaseVC {
    enum Gender : String{
        case Male = "Male"
        case Female = "Female"
        case Default = ""
    }
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    
    var tenantDetailsVC : TenantDetailsVC!
    var memberDetailResponse : MemberDetailResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardAccessory(textFields: [tfFirstName,tfLastName,tfDOB], dismissable: true, previousNextable: true)
        self.tfFirstName.text = memberDetailResponse.userFirstName
        self.tfLastName.text = memberDetailResponse.userLastName
        self.tfDOB.text = memberDetailResponse.userEmail
        switch memberDetailResponse.gender {
        case Gender.Male.rawValue:
            self.gender = Gender.Male
            self.imgMale.setImageWithTint(ImageName: "radio-selected", TintColor: ColorConstant.primaryColor)
            break;
        case Gender.Female.rawValue:
            self.gender = Gender.Female
            self.imgFemale.setImageWithTint(ImageName: "radio-selected", TintColor: ColorConstant.primaryColor)
            break;
        default:
            self.gender = Gender.Default
            break
        }
        // Do any additional setup after loading the view.
    }
    var gender : Gender = Gender.Default
    @IBAction func btnChooseGender(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.gender = Gender.Male
            self.imgMale.setImageWithTint(ImageName: "radio-selected", TintColor: ColorConstant.primaryColor)
            self.imgFemale.setImageWithTint(ImageName: "radio-blank", TintColor: ColorConstant.primaryColor)
        default:
            self.gender = Gender.Female
            self.imgFemale.setImageWithTint(ImageName: "radio-selected", TintColor: ColorConstant.primaryColor)
            self.imgMale.setImageWithTint(ImageName: "radio-blank", TintColor: ColorConstant.primaryColor)
        }
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if doValidate(){
            self.sheetViewController?.dismiss(animated: false, completion: {
                self.tenantDetailsVC.doUpdateBasicInfo(firstName: self.tfFirstName.text!, lastName: self.tfLastName.text!, email: self.tfDOB.text!, gender:  self.gender.rawValue)
            })
        }
    }
    @IBAction func onClickCancel(_ sender: Any) {
         sheetViewController?.dismiss(animated: false, completion: nil)
     }
    func doValidate()-> Bool{
           var flag = true
          if (tfFirstName.text?.isEmptyOrWhitespace())! {
            flag = false
            self.showAlertMessage(title: "Validation Alert!!", msg: "Please Provide a Valid First Name!!")
        }
        if (tfLastName.text?.isEmptyOrWhitespace())! {
            flag = false
            self.showAlertMessage(title: "Validation Alert!!", msg: "Please Provide a Valid Last Name!!")
        }
        
        if tfDOB.text != ""{
            if !isValidEmail(email: tfDOB.text!) {
                flag = false
                self.showAlertMessage(title: "Validation Alert!!", msg: "Enter valid email")
            }
            
        }

           return flag
       }
}
