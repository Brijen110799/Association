//
//  AddNewFamilyMemberVC.swift
//  Fincasys
//
//  Created by silverwing_macmini3 on 11/24/1398 AP.
//  Copyright © 1398 silverwing_macmini3. All rights reserved.
//

import UIKit
import ContactsUI
import DropDown
//import IQKeyboardManagerSwift
class AddNewFamilyMemberVC: BaseVC {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewMemberMobile: UIView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var btnRelationWithMember: UIButton!
    //@IBOutlet weak var btnDropdownRelation: UIButton!
   // @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var tfMemberFirstName: UITextField!
//    @IBOutlet weak var tfmemberMidName: UITextField!
    @IBOutlet weak var tfMemberLastName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfMemberMobile: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
  //  @IBOutlet weak var lblRelationWithMember: UILabel!
    var StrMemberTYpe = ""
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFeMale: UIView!
    @IBOutlet weak var ivredioMale: UIImageView!
    @IBOutlet weak var ivredioFeMale: UIImageView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var lbTitleToolbar: UILabel!
    @IBOutlet weak var viewOtherRelation: UIView!
    @IBOutlet weak var tfOtherRelation: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var lblCreateLoginMember: UILabel!
    @IBOutlet weak var tfDesignation: UITextField!
    
    var context : UserProfileVC!
    var user_status = "1"
    let label = UIBarButtonItem(title: "Enter Mobile Number", style: .plain, target: self, action: nil)
    var checkFlag = true
    let dropDown = DropDown()
    var relationMember = [String]()
  //  let datePicker = UIDatePicker()
    var modelFamilyMember:MemberDetailModal!
    var initForUpdate = false
    var user_id = "0"
    var gender = "Male"
    var countryList = CountryList()
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""
    var tag = "addFamilyMember"
    private var dob = ""
    private  var cDate =  Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.relationMember =  doGetLocalDataUser().isSociety ?  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"] : ["Owner","Employee","Other"]

      //  self.lblRelationWithMember.text = doGetLocalDataUser().isSociety ? "Relation with member" : "Relation with Designation"
        
        relationMember = doGetValueLanguageArrayString(forKey: "relation_society")
        //lblRelation.text = relationMember[0]
        lbTitleToolbar.text = doGetValueLanguage(forKey: "add_new_member")
        tfMemberFirstName.placeholder("\(doGetValueLanguage(forKey: "first_name"))*")
        //tfmemberMidName.placeholder("\(doGetValueLanguage(forKey:"middle_name"))*")
        tfMemberLastName.placeholder("\(doGetValueLanguage(forKey: "last_name"))*")
        tfDOB.placeholder(doGetValueLanguage(forKey: "date_of_birth"))
      //  lblRelationWithMember.text = doGetValueLanguage(forKey: "relation_with_member")
        tfMemberMobile.placeholder(doGetValueLanguage(forKey: "mobile_number"))
        tfOtherRelation.placeholder(doGetValueLanguage(forKey: "select_member_relation"))
        lblCreateLoginMember.text = doGetValueLanguage(forKey: "create_login_for_member")
        lblMale.text = doGetValueLanguage(forKey: "male")
        lblFemale.text = doGetValueLanguage(forKey: "female")
        btnSubmit.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        tfDesignation.placeholder("\(doGetValueLanguage(forKey: "designation"))*")
        tfMemberMobile.keyboardType = .numberPad
       
        initUI()
       // initDropdown()
        selectMale()
        if initForUpdate {
            lbTitleToolbar.text = doGetValueLanguage(forKey: "edit_member_details")
            btnSubmit.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
            tfDOB.text = modelFamilyMember.memberDateOfBirth
            dob = modelFamilyMember.memberDateOfBirth ?? ""
            if dob != "" {
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd"
                let dateDOb = format.date(from: dob)
                format.dateFormat = "dd-MM-yyyy"
                tfDOB.text = format.string(from: dateDOb ?? Date())
            }
            tfMemberFirstName.text = modelFamilyMember.userFirstName
           // tfmemberMidName.text = modelFamilyMember.user_middle_name
            tfMemberLastName.text = modelFamilyMember.userLastName
            tfDesignation.text = modelFamilyMember.designation ?? ""
        //    lblRelation.text = modelFamilyMember.memberRelationSet
            user_id = modelFamilyMember.userID!
            tfMemberMobile.text = modelFamilyMember.userMobile
//            if modelFamilyMember.memberRelationName == ""{
//                self.lblRelation.text = doGetValueLanguage(forKey: "select")
//            }
            
            
            if let dob =  modelFamilyMember.memberDateOfBirth {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "yyyy-MM-dd"
                let date = dateFormatter.date(from: dob)
                cDate = date ?? Date()
            }
            if modelFamilyMember.userStatus == "1" {
                checkFlag = true
                user_status = "1"
                imgCheckBox.image = UIImage(named: "check_box")
                imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//                viewMemberMobile.isHidden = false
//                tfMemberMobile.isEnabled = false

                print("date of birth---",modelFamilyMember.memberDateOfBirth!)

            }else{
                checkFlag = true
                user_status = "2"
                imgCheckBox.image = UIImage(named: "check_box_uncheck")
                imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
            }
            tag = "updateFamilyMember"
            Utils.setImageFromUrl(imageView: imgUserProfile, urlString: modelFamilyMember.userProfilePic,palceHolder: "user_default")
           
//            var isShowOther = true
//            for item in relationMember {
//                if item == modelFamilyMember.memberRelationSet {
//                    isShowOther = false
//                    break
//                }
//            }
      //  print("releation " , modelFamilyMember.memberRelationSet)
            
//            if isShowOther {
//                lblRelation.text = doGetValueLanguage(forKey: "other_relation")
//                tfOtherRelation.text = modelFamilyMember.memberRelationSet
//                viewOtherRelation.isHidden = false
//            }
            
            if modelFamilyMember.gender == doGetValueLanguage(forKey: "female") {
                selectFemale()
            }
            
            if modelFamilyMember.countryCode  != nil && modelFamilyMember.countryCode != "" {
                let count = Countries()
                for item in count.countries {
                    let countC = "+"  + item.phoneExtension
                    if countC == modelFamilyMember.countryCode {
                        lblCountryNameCode.text = "+\(item.phoneExtension)"
                        self.countryName = item.name!
                        self.countryCode = item.countryCode
                        self.phoneCode = "+" + item.phoneExtension
                        break
                    }
                }
            }
            
            
        }else{
           // btnSubmit.setTitle(doGetValueLanguage(forKey: "add"), for: .normal)
             setDefultCountry()
        }
        
         self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        countryList.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        doneButtonOnKeyboard(textField: tfMemberMobile)
        
    }
    
    @IBAction func btndateAction(_ sender: Any) {
        self.tfMemberFirstName.resignFirstResponder()
       // self.tfmemberMidName.resignFirstResponder()
        self.tfMemberLastName.resignFirstResponder()
        self.tfDesignation.resignFirstResponder()
        self.tfMemberMobile.resignFirstResponder()
        
       
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: nil, maximumDate: Date(), currentDate: cDate)
        vc.view.frame = view.frame
        addPopView(vc: vc)
    }
    @IBAction func btnPickContact(_ sender: UIButton) {
        self.onClickPickContact()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.sheetViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func onClickAdd(_ sender: Any) {
        if isValidate() {
            doSubmitData()
        }
    }
    
    func isValidate() -> Bool {
        var validate = true
        
        if tfMemberFirstName.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_first_name"))
            validate = false
        }
        if  tfMemberLastName.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_last_name"))
            validate = false
        }
        
        if tfDesignation.text!.isEmptyOrWhitespace() {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_designation"))
            validate = false
        }
        if user_status == "1" {
            if tfMemberMobile.text!.count < 8 {
                showAlertMessage(title: "", msg:doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                validate = false
            }
            
        }
        
       
        
//        if  self.lblRelation.text == doGetValueLanguage(forKey: "other_relation") {
//            if tfOtherRelation.text == "" {
//                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_relation_here"))
//                validate = false
//            }
//        }
        return validate
    }
    
    func doSubmitData() {
        showProgress()
//        var member_relation = ""
//        if  self.lblRelation.text == doGetValueLanguage(forKey: "other_relation") {
//            member_relation =  self.tfOtherRelation.text!
//        } else {
//            member_relation =  self.lblRelation.text!
//        }
        let params = [tag:tag,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":user_id,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":tfMemberFirstName.text!,
                      "user_last_name":tfMemberLastName.text!,
                      "member_date_of_birth":dob,
                      "designation":tfDesignation.text ?? "",
                      "user_status":user_status,
                      "member_status":doGetLocalDataUser().memberStatus!,
                      "user_mobile":tfMemberMobile.text!,
                      "parent_id":doGetLocalDataUser().userID!,
                      "gender" : gender,
                      "country_code":phoneCode]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartImage(serviceName: ServiceNameConstants.family_controller, parameters: params,imageFile: imgUserProfile.image,fileName: "family_profile_pic", compression: 0.3) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
                        self.context.refreshPage()
                        self.doPopBAck()
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
                      "user_id":user_id,
                      "member_status":doGetLocalDataUser().memberStatus!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                       // self.profilePersonalDetailVC.isAddFamilyMember = true
//                        self.profilePersonalDetailVC.doGetFamilyMember()
                        self.dismiss(animated: false, completion: nil)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
   
    
    func initUI(){
        addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDesignation,tfMemberMobile], dismissable: true, previousNextable: true)
       
        tfMemberMobile.delegate = self
        tfMemberLastName.delegate = self
        
        tfDOB.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
    }
    
    
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.view.endEditing(true)
        self.tfMemberLastName.resignFirstResponder()
        
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: nil, maximumDate: Date(), currentDate: cDate)
        vc.view.frame = view.frame
        addPopView(vc: vc)
    }
    
   
   
    @IBAction func onChecked(_ sender: Any) {
        if checkFlag == true {
            imgCheckBox.image = UIImage(named: "check_box_uncheck")
            user_status = "2"
            checkFlag = false
            imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//            viewMemberMobile.isHidden = true
            self.sheetViewController?.resize(to: .fixed(450), animated: true)

            self.view.endEditing(true)
//            addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDOB,tfMemberMobile], dismissable: true, previousNextable: true)
        }
        else {
            self.view.endEditing(true)
            imgCheckBox.image = UIImage(named: "check_box")
            user_status = "1"
            imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//            viewMemberMobile.isHidden = false
            self.sheetViewController?.resize(to: .fixed(520), animated: true)
            checkFlag = true
//            addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDOB], dismissable: true, previousNextable: true)
        }
    }
    
    @IBAction func onClickDropdown(_ sender: Any) {
        dropDown.show()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfMemberMobile{
            if tfMemberMobile.text == ""{
                label.title = doGetValueLanguage(forKey: "enter_your_mobile_number")
            }else{
                label.title = tfMemberMobile.text
            }
        }
    }
    @IBAction func onClickFeMale(_ sender: Any) {
        //  ivredioFeMale.image = UIImage(named: "radio-selected")
        //  ivredioMale.image = UIImage(named: "radio-blank")
       selectFemale()
    }
    @IBAction func onClickMale(_ sender: Any) {
        //  ivredioMale.image = UIImage(named: "radio-selected")
        // ivredioFeMale.image = UIImage(named: "radio-blank")
        gender = "Male"
        //  ivredioMale.setImageColor(color: ColorConstant.primaryColor)
        // ivredioFeMale.setImageColor(color: ColorConstant.primaryColor)
        
        selectMale()
        
    }
    @IBAction func onClickChoosePhoto(_ sender: Any) {
       
        showDialogChoser()
    }
    
       func selectMale() {
           ivredioMale.setImageColor(color: .white)
           ivredioFeMale.setImageColor(color: ColorConstant.primaryColor)
           viewMale.backgroundColor = ColorConstant.primaryColor
           viewFeMale.backgroundColor = .clear
       }
    func selectFemale() {
        ivredioFeMale.setImageColor(color: .white)
        ivredioMale.setImageColor(color: ColorConstant.primaryColor)
        viewMale.backgroundColor = .clear
        viewFeMale.backgroundColor =  ColorConstant.primaryColor
        gender = doGetValueLanguage(forKey: "female")
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
       // /print("local dd " , localRegion)
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryNameCode.text = "+\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode = "+" + item.phoneExtension
                break
            }
        }
    }
    func showDialogChoser() {
          let alertVC = UIAlertController(title: "", message: doGetValueLanguage(forKey: "select_photos"), preferredStyle: .actionSheet)

          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { (UIAlertAction) in
              self.btnOpenCamera()
          }))
          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { (UIAlertAction) in

                  self.btnOpenGallery()

             //self.btnOpenGallery()
              //  self.shoImagePicker()
          }))

        if initForUpdate {
            alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "remove_photo"), style: .default, handler: { (UIAlertAction) in

                self.deleteProfilePhoto()
                //self.btnOpenGallery()
                //  self.shoImagePicker()
            }))
        }
          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: { (UIAlertAction) in
              alertVC.dismiss(animated: true, completion: nil)
          }))
          self.present(alertVC, animated: true, completion: nil)
      }
    func btnOpenCamera() {
           //   self.pickerTag = tag
           if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
               let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
               imagePicker.delegate = self
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
           }
           else
           {
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ok"), style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
    func btnOpenGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: doGetValueLanguage(forKey: "allow_fincasys_to_access_photos_media_files"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ok"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func btnSelectCountry(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    func deleteProfilePhoto(){
        self.showProgress()
        let params = ["removeProfilePicture":"removeProfilePicture",
                      "user_id":user_id,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(RemoveImageReponse.self, from: Data!)
                    if response.status == "200"{
                        self.imgUserProfile.image = UIImage(named: "user_default")
                        
                    }else{
                    }
                }catch{
                    print("parse Error",Err as Any)
                }
            }
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {

        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height

    }
    @objc func keyboardWillHide(notification: NSNotification) {

        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
extension AddNewFamilyMemberVC : CNContactPickerDelegate
{
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
       // let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName

        tfMemberFirstName.text = contact.givenName
        tfMemberLastName.text = contact.familyName
        
        
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

        tfMemberMobile.text = conatct

//        doCall(on: conatct)

    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
extension AddNewFamilyMemberVC : CountryListDelegate , OnSelectDate {
    
    func onSelectDate(dateString: String, date: Date) {
      //  print("dateString \(dateString)")
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        dob = dateString
        tfDOB.text = format.string(from: date)
    }
    
    func selectedAltCountry(country: Country) {
        
    }
    
    func selectedCountry(country: Country) {
        lblCountryNameCode.text = "+\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.phoneCode = "+" + country.phoneExtension
    }
}

extension AddNewFamilyMemberVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
      
        if let img = info[.editedImage] as? UIImage
        {
            //self.ivProfile.image = img
            print("imagePickerController edit")
            
            self.imgUserProfile.image = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")
            self.imgUserProfile.image = img
        }
        
        //self.imgUserProfile.image = selectedImage
        
    }
}
