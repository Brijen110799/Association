//
//  OwnerFamilyVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 16/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import ContactsUI
import DropDown

class OwnerFamilyVC: BaseVC {
    
    @IBOutlet weak var viewMemberMobile: UIView!
    @IBOutlet weak var btnDropdownRelation: UIButton!
    @IBOutlet weak var tfDesingation: UITextField!
    @IBOutlet weak var tfMemberFirstName: UITextField!
    @IBOutlet weak var tfMemberLastName: UITextField!
    @IBOutlet weak var tfMemberMobile: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblRelationWithMember: UILabel!
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
    @IBOutlet weak var bReject: UIButton!
    
    var context : UserProfileVC!
    var user_status = "1"
    let label = UIBarButtonItem(title: "Enter Mobile Number", style: .plain, target: self, action: nil)
    var checkFlag = true
    let dropDown = DropDown()
   // var relationMember = [String]()
    let datePicker = UIDatePicker()
    var modelFamilyMember:MemberDetailModal!
    var initForUpdate = false
    var user_id = "0"
    var gender = "Male"
    var countryList = CountryList()
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""
    var tag = "addFamilyMember"

    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblRelationWithMember.text = doGetValueLanguage(forKey: "designation")
        btnSubmit.setTitle(doGetValueLanguage(forKey: "approve").uppercased(), for: .normal)
        bReject.setTitle(doGetValueLanguage(forKey: "reject").uppercased(), for: .normal)
        
       showDatePicker()
       initUI()
        selectMale()
    
        if initForUpdate {
            tfDesingation.isUserInteractionEnabled = false
            tfMemberFirstName.isUserInteractionEnabled = false
            tfMemberLastName.isUserInteractionEnabled = false
            tfMemberMobile.isUserInteractionEnabled = false
            
            
           lbTitleToolbar.text = "\(modelFamilyMember.userFirstName ?? "") \(modelFamilyMember.userLastName ?? "") "
           //btnSubmit.setTitle("UPDATE", for: .normal)
        //   tfDOB.text = modelFamilyMember.memberDateOfBirth
           tfMemberFirstName.text = modelFamilyMember.userFirstName
           tfMemberLastName.text = modelFamilyMember.userLastName
          
           user_id = modelFamilyMember.userID!
           tfMemberMobile.text = modelFamilyMember.userMobile
          self.tfDesingation.text = modelFamilyMember.designation ?? ""
        
           if modelFamilyMember.memberDateOfBirth != ""{
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat =  "yyyy-MM-dd"
               let date = dateFormatter.date(from: modelFamilyMember.memberDateOfBirth!)
               datePicker.date = date!
           }
           if modelFamilyMember.userStatus == "1" {
               checkFlag = true
               user_status = "1"
             //  imgCheckBox.image = UIImage(named: "check_box")
             //  imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//                viewMemberMobile.isHidden = false
//                tfMemberMobile.isEnabled = false

               print("date of birth---",modelFamilyMember.memberDateOfBirth!)

           }else{
               checkFlag = true
               user_status = "2"
             //  imgCheckBox.image = UIImage(named: "check_box_uncheck")
             //  imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
           }
           tag = "updateFamilyMember"
           Utils.setImageFromUrl(imageView: imgUserProfile, urlString: modelFamilyMember.userProfilePic,palceHolder: "user_default")
          
       
     //  print("releation " , modelFamilyMember.memberRelationSet)
           
         
           if modelFamilyMember.gender == "Female" {
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
          // btnSubmit.setTitle("ADD", for: .normal)
            setDefultCountry()
       }
       
        self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
       countryList.delegate = self
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

       
   }
   @IBAction func btnPickContact(_ sender: UIButton) {
    if initForUpdate {
        return
    }
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
    
    if tfDesingation.text!.isEmptyOrWhitespace() {
        showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_designation"))
        validate = false
    }
    if user_status == "1" {
        if tfMemberMobile.text!.count < 8 {
            showAlertMessage(title: "", msg:doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
            validate = false
        }
        
    }
    

       return validate
   }
   func doSubmitData() {
       showProgress()
    let member_relation = tfDesingation.text  ?? ""
//       if  self.lblRelation.text == doGetValueLanguage(forKey: "other_relation") {
//           member_relation =  self.tfOtherRelation.text!
//       } else {
//           member_relation =  self.lblRelation.text!
//       }
       let params = ["approveFamilyMember":"approveFamilyMember",
                     "society_id":doGetLocalDataUser().societyID ?? "",
                     "user_id":modelFamilyMember.userID ?? "",
                     "parent_id":doGetLocalDataUser().userID ?? "",
                     "parent_name":doGetLocalDataUser().userFullName ?? "",
                     "unit_id":doGetLocalDataUser().unitID ?? "",
                     "language_id":"",
                     "user_first_name":tfMemberFirstName.text!,
                     "user_last_name":tfMemberLastName.text!,
                     "member_relation":member_relation,
                     "user_status":modelFamilyMember.userStatus,
                     "member_status":doGetLocalDataUser().memberStatus!,
                     "user_mobile":tfMemberMobile.text!,
                     "gender" : gender,
                     "country_code":phoneCode]
       
       print("param" , params)
       
       let requrest = AlamofireSingleTon.sharedInstance
    requrest.requestPostMultipartImage(serviceName: ServiceNameConstants.family_controller, parameters: params as [String : Any],imageFile: imgUserProfile.image,fileName: "family_profile_pic", compression: 0.3) { (json, error) in
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
       addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDesingation,tfMemberMobile], dismissable: true, previousNextable: true)
      
       tfMemberMobile.delegate = self
     
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
     //  tfDOB.inputAccessoryView = toolbar
     //  tfDOB.inputView = datePicker
       
   }
   @objc func donedatePicker(){
       
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
     //  tfDOB.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
   }
   @objc func cancelDatePicker(){
       self.view.endEditing(true)
   }
   @objc func dateChanged(datePicker : UIDatePicker) {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd/MM/yyyy"
    //   txtDate.text = dateFormatter.string(from: datePicker.date)
       view.endEditing(true)
   }
   @IBAction func onChecked(_ sender: Any) {
       if checkFlag == true {
          // imgCheckBox.image = UIImage(named: "check_box_uncheck")
           user_status = "2"
           checkFlag = false
        //   imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//            viewMemberMobile.isHidden = true
           self.sheetViewController?.resize(to: .fixed(450), animated: true)

           self.view.endEditing(true)
//            addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDOB,tfMemberMobile], dismissable: true, previousNextable: true)
       }
       else {
           self.view.endEditing(true)
        //   imgCheckBox.image = UIImage(named: "check_box")
           user_status = "1"
        //   imgCheckBox.setImageColor(color: ColorConstant.primaryColor)
//            viewMemberMobile.isHidden = false
           self.sheetViewController?.resize(to: .fixed(520), animated: true)
           checkFlag = true
//            addKeyboardAccessory(textFields: [tfMemberFirstName,tfMemberLastName,tfDOB], dismissable: true, previousNextable: true)
       }
   }
   
   @IBAction func onClickDropdown(_ sender: Any) {
     //  dropDown.show()
   }
   func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField == tfMemberMobile{
           if tfMemberMobile.text == ""{
               label.title = "Enter Mobile Number"
           }else{
               label.title = tfMemberMobile.text
           }
       }
   }
   @IBAction func onClickFeMale(_ sender: Any) {
    if initForUpdate {
        return
    }
    //  ivredioFeMale.image = UIImage(named: "radio-selected")
    //  ivredioMale.image = UIImage(named: "radio-blank")
    selectFemale()
   }
    @IBAction func onClickMale(_ sender: Any) {
        if initForUpdate {
            return
        }
        //  ivredioMale.image = UIImage(named: "radio-selected")
        // ivredioFeMale.image = UIImage(named: "radio-blank")
        gender = "Male"
        //  ivredioMale.setImageColor(color: ColorConstant.primaryColor)
        // ivredioFeMale.setImageColor(color: ColorConstant.primaryColor)
        
        selectMale()
        
   }
   @IBAction func onClickChoosePhoto(_ sender: Any) {
    if initForUpdate {
        return
    }
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
       gender = "Female"
   }
   func setDefultCountry(){
       let localRegion =  Locale.current.regionCode
      // /print("local dd " , localRegion)
       let count = Countries()
       for item in count.countries {
           if item.countryCode == localRegion{
               lblCountryNameCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
               self.countryName = item.name!
               self.countryCode = item.countryCode
               self.phoneCode = "+" + item.phoneExtension
               break
           }
       }
   }
   func showDialogChoser() {
         let alertVC = UIAlertController(title: "", message: "Choose", preferredStyle: .actionSheet)
         
         alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
             self.btnOpenCamera()
         }))
         alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
          
                 self.btnOpenGallery()
             
            //self.btnOpenGallery()
             //  self.shoImagePicker()
         }))
      
       if initForUpdate {
           alertVC.addAction(UIAlertAction(title: "Remove Photo", style: .default, handler: { (UIAlertAction) in
               
               self.deleteProfilePhoto()
               //self.btnOpenGallery()
               //  self.shoImagePicker()
           }))
       }
         alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
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
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
           let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }
   @IBAction func btnSelectCountry(_ sender: Any) {
    if initForUpdate {
        return
    }
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
    
    
    @IBAction func tapReject(_ sender: Any) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure"), style: .Delete, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
    }
   
    func doRejctFamilyMember(){
        self.showProgress()
        let params = ["key":apiKey(),
                      "deleteFamilyMember":"deleteFamilyMember",
                      "user_id":modelFamilyMember.userID ?? "0",
                      "society_id":doGetLocalDataUser().societyID!,
                      "parent_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(RemoveImageReponse.self, from:json!)
                    if response.status == "200" {
                      
                        showAlertMessageWithClick(title: "", msg: response.message)
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    override func onClickDone() {
        doPopBAck()
    }
    
}
extension OwnerFamilyVC : CNContactPickerDelegate
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
     //  let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName
    var number = ""
    if  contact.phoneNumbers.count > 0  {
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
        
        // user phone number string
        number =  firstPhoneNumber.stringValue
        
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
extension OwnerFamilyVC : CountryListDelegate {
   func selectedAltCountry(country: Country) {
       
   }
   func selectedCountry(country: Country) {
       lblCountryNameCode.text = "+\(country.phoneExtension)"
       self.countryName = country.name!
       self.countryCode = country.countryCode
       self.phoneCode = "+" + country.phoneExtension
   }
}
extension OwnerFamilyVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
   
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
extension OwnerFamilyVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                self.doRejctFamilyMember()
            }
        }
   }
}
