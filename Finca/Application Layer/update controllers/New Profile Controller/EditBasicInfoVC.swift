//
//  EditBasicInfoVC.swift
//  Work
//
//  Created by Silverwing Macmini1 on 12/02/20.
//  Copyright © 2020 Silverwing Macmini1. All rights reserved.
//

import UIKit
import FittedSheets
import DropDown

class EditBasicInfoVC: BaseVC , OnSelectDate {
    func onSelectDate(dateString: String, date: Date) {
        print("dateString \(dateString)")
    }
    
    enum Gender : String{
        case Male = "Male"
        case Female = "Female"
        case Default = ""
    }
   // @IBOutlet weak var BtnDOBCancel:UIButton!
    @IBOutlet weak var viewMid: UIView!
    @IBOutlet weak var lblMiddleNametitle: UILabel!
    @IBOutlet weak var tfMiddleName: UITextField!
    @IBOutlet weak var Vwdob:UIView!
    @IBOutlet weak var lblSelectBloodGroup: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var ivredioMale: UIImageView!
    @IBOutlet weak var ivredioFeMale: UIImageView!
    @IBOutlet weak var lblFirstNameTitle: UILabel!
    @IBOutlet weak var lblLastNameTitle: UILabel!
    @IBOutlet weak var lblDOBTitle: UILabel!
    @IBOutlet weak var lblBloodGroupTitle: UILabel!
    @IBOutlet weak var lblGenderTitle: UILabel!
    @IBOutlet weak var lblMaleTitle: UILabel!
    @IBOutlet weak var lblFemaleTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    let datePicker = UIDatePicker()
    var context : UserDetailVC!
    var userProfileReponse : MemberDetailResponse!
    let dropDown = DropDown()
    var relationMember = [String]()
    var dob = ""
    var bloodGroup = ""
    //var strdob = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  BtnDOBCancel.isHidden = true
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditBasicInfoVC.rightViewTapped(_:)))
        lblSelectBloodGroup.addGestureRecognizer(tap)
        
        
        self.relationMember =   ["Select","A","A+","B","B+","AB","AB+","O+","O-"]
        if doGetValueLanguageArrayString(forKey: "blood_type").count > 0{
            relationMember = doGetValueLanguageArrayString(forKey: "blood_type")
        }
        addKeyboardAccessory(textFields: [tfFirstName,tfMiddleName,tfLastName], dismissable: true, previousNextable: true)
        initDatePicker()
        self.tfFirstName.text = userProfileReponse.userFirstName
        self.tfMiddleName.text = userProfileReponse.user_middle_name
        self.tfLastName.text = userProfileReponse.userLastName
        
      //  self.tfDOB.text = userProfileReponse.memberDateOfBirthSet
        
        dob = userProfileReponse.memberDateOfBirthSet ?? ""
        if dob != "" {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let dateDOb = format.date(from: dob)
            format.dateFormat = "dd-MM-yyyy"
            tfDOB.text = format.string(from: dateDOb ?? Date())
            Vwdob.isHidden = false
        }else {
            Vwdob.isHidden = true
            tfDOB.placeholder(doGetValueLanguage(forKey: "type_here"))
        }
       
        self.lblSelectBloodGroup.text = userProfileReponse.blood_group
        bloodGroup = userProfileReponse.blood_group == relationMember[0] ? "" : userProfileReponse.blood_group
        switch userProfileReponse.gender {
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
        tfFirstName.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfMiddleName.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfLastName.placeholder(doGetValueLanguage(forKey: "type_here"))
        tfDOB.placeholder(doGetValueLanguage(forKey: "type_here"))
        lblSelectBloodGroup.placeholder(doGetValueLanguage(forKey: "type_here"))
        lblSelectBloodGroup.placeholder(doGetValueLanguage(forKey: "type_here"))
        lblFirstNameTitle.text = doGetValueLanguage(forKey: "first_name_about_info")
        lblLastNameTitle.text = doGetValueLanguage(forKey: "last_name_about_info")
        lblDOBTitle.text = doGetValueLanguage(forKey: "date_of_birth")
        lblBloodGroupTitle.text = doGetValueLanguage(forKey: "blood_group")
        lblGenderTitle.text = doGetValueLanguage(forKey: "gender")
        lblMaleTitle.text = doGetValueLanguage(forKey: "male")
        lblFemaleTitle.text = doGetValueLanguage(forKey: "female")
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        btnUpdate.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
        
        tfDOB.delegate = self
        
//        if let midNameActionFlag = doGetLocalDataUser().middle_name_action {
//            self.viewMid.isHidden = (midNameActionFlag == "1")
//        }
        
        if doGetLocalDataUser().middle_name_action == "0"{
            self.tfMiddleName.placeholder = self.doGetValueLanguage(forKey: "middle_name")
            self.viewMid.isHidden = false
        }
        if doGetLocalDataUser().middle_name_action == "1"{
            self.viewMid.isHidden = true
        }
        if doGetLocalDataUser().middle_name_action == "2"{
            self.tfMiddleName.placeholder = self.doGetValueLanguage(forKey: "middle_name") + " *"
            self.viewMid.isHidden = false
           // self.check = "2"
        }
        
        
    }
    @IBAction func BtnDobClickEvent(_ sender: UIButton) {
        dob = ""
        tfDOB.text = ""
        Vwdob.isHidden = true
        
    }
    @objc func rightViewTapped(_ recognizer: UIGestureRecognizer) {
        dropDown.anchorView = lblSelectBloodGroup
        dropDown.dataSource = relationMember
        dropDown.width = 100
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblSelectBloodGroup.text = self.dropDown.selectedItem
            if index == 0 {
                bloodGroup = ""
            } else {
                bloodGroup = item
            }
            
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
    }
    func initDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: doGetValueLanguage(forKey: "done"), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: doGetValueLanguage(forKey: "cancel"), style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tfDOB.inputAccessoryView = toolbar
        tfDOB.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dob = formatter.string(from: datePicker.date)
        formatter.dateFormat = "dd-MM-yyyy"
        tfDOB.text = formatter.string(from: datePicker.date)
        Vwdob.isHidden = false
        self.view.endEditing(true)
        //let DOB = tfDOB.placeholder(doGetValueLanguage(forKey: "type_here"))
       // let StrDob = tfDOB.text
       
    }
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    ///male is false and female is true
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

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    func doValidate()-> Bool{
        var flag = true
        if tfFirstName.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_first_name"))
        }
        
        if let midNameActionFlag = doGetLocalDataUser().middle_name_action {
            if tfMiddleName.text == "" && midNameActionFlag == "2" {
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "middle_name_required"))
            }
        }
        
        if userProfileReponse.middle_name_action == "2"{
           
        }else{
            
        }
        
        if tfLastName.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_last_name"))
        }

//        if tfDOB.text == ""{
//            flag = false
//            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_select_date"))
//        }
        if lblSelectBloodGroup.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "blood_group"))
        }

        return flag
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if doValidate(){
            self.sheetViewController?.dismiss(animated: false, completion: {
                self.context.doCallUpdateApi(firstName: self.tfFirstName.text!,middleName: self.tfMiddleName.text!, lastName: self.tfLastName.text!, email: self.userProfileReponse.userEmail!, alt_mobile: self.userProfileReponse.altMobile!, DOB: self.dob, facebook: self.userProfileReponse.facebook!, instagram: self.userProfileReponse.instagram!, linkedin: self.userProfileReponse.linkedin!,gender: self.gender.rawValue,blood_group:self.bloodGroup, usermobile:"", phoneCode1: self.userProfileReponse.countryCodeAlt, phoneCode: self.userProfileReponse.countryCode)
            })
        }
    }
    @IBAction func onClickCancel(_ sender: Any) {
        sheetViewController?.dismiss(animated: false, completion: nil)
    }
     func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfDOB {
            
            if tfDOB.text ?? "" != "" &&  tfDOB.text?.count ?? 0 > 1 {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd"
                datePicker.date = dateFormater.date(from:dob) ?? Date()
            } else {
                let date =  Calendar.current.date(byAdding: .year, value: -20, to: Date())
                datePicker.date = date ?? Date()
            }
        }
     
    }
    
}
extension UIImageView{
    func setImageWithTint(ImageName : String,TintColor:UIColor!){
        self.image = UIImage(named: ImageName)
        self.tintColor = TintColor
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
    }
}
