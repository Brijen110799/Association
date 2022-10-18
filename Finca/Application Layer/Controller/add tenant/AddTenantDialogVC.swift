//
//  AddTenantDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 10/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices
import SkyFloatingLabelTextField
//import OpalImagePicker
import Photos

class AddTenantDialogVC: BaseVC {
    
    @IBOutlet weak var tfFirstName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    
  
    @IBOutlet weak var tfAddress: ACFloatingTextfield!
    var gender = "Male"
    let itemCell = "DocumentNameCell"
    
    var fileUrl:URL!
    
    var fileAgreement = [URL]()
    var filePolice = [URL]()
    
    var pickerTag = 0
    var imageLimit = 10
    var agreementImage = [UIImage]()
    var policeVerificationImage = [UIImage]()
      var isSelectDoc = false
    
    @IBOutlet weak var imgUserProfile: UIImageView!

    @IBOutlet weak var cvAgreement: UICollectionView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFeMale: UIView!
    @IBOutlet weak var ivredioMale: UIImageView!
    @IBOutlet weak var ivredioFeMale: UIImageView!
    @IBOutlet weak var cvVerification: UICollectionView!
    @IBOutlet weak var heightOfTenentAgreement: NSLayoutConstraint!
    @IBOutlet weak var heightOfTenentVerification: NSLayoutConstraint!
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    var settingsVC : SettingsVC!
    var selectType =  ""
    let datePicker = UIDatePicker()
    var dateSelect = ""
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""
    var countryList = CountryList()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addKeyboardAccessory(textFields: [tfFirstName,tfLastName,tfEmail,tfMobile,tfAddress])
        
        
        tfFirstName.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfMobile.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfLastName.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfEmail.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        tfMobile.keyboardType = .numberPad
        
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        
        cvAgreement.register(nib, forCellWithReuseIdentifier: itemCell)
        cvVerification.register(nib, forCellWithReuseIdentifier: itemCell)
        
        cvAgreement.delegate = self
        cvAgreement.dataSource = self
        
        cvVerification.delegate = self
        cvVerification.dataSource = self
        
        
        
        
        heightOfTenentAgreement.constant = 0
        heightOfTenentVerification.constant = 0
        selectMale()
        
        initDatePicker()
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        countryList.delegate = self
     //   lblCountryNameCode.text = "\u{1F1EE}\u{1F1F3} +91"
      setDefultCountry()
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
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
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    
    @IBAction func onClickFeMale(_ sender: Any) {
      //  ivredioFeMale.image = UIImage(named: "radio-selected")
      //  ivredioMale.image = UIImage(named: "radio-blank")
        ivredioFeMale.setImageColor(color: .white)
        ivredioMale.setImageColor(color: ColorConstant.primaryColor)
        viewMale.backgroundColor = .clear
        viewFeMale.backgroundColor =  ColorConstant.primaryColor
        gender = "Female"
    }
    @IBAction func onClickMale(_ sender: Any) {
        //  ivredioMale.image = UIImage(named: "radio-selected")
        // ivredioFeMale.image = UIImage(named: "radio-blank")
        gender = "Male"
        //  ivredioMale.setImageColor(color: ColorConstant.primaryColor)
        // ivredioFeMale.setImageColor(color: ColorConstant.primaryColor)
        
        selectMale()
        
    }
    func selectMale() {
        ivredioMale.setImageColor(color: .white)
        ivredioFeMale.setImageColor(color: ColorConstant.primaryColor)
        viewMale.backgroundColor = ColorConstant.primaryColor
        viewFeMale.backgroundColor = .clear
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
    }
    func initDatePicker(){
           //Formate Date
           datePicker.datePickerMode = .date
           //datePicker.maximumDate = Date()
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
           tfEndDate.inputAccessoryView = toolbar
           tfEndDate.inputView = datePicker
          
          tfStartDate.inputAccessoryView = toolbar
          tfStartDate.inputView = datePicker
           
       }
      @objc func donedatePicker(){
             
             let formatter = DateFormatter()
             formatter.dateFormat = "yyyy-MM-dd"
          if dateSelect == "1"  {
              tfStartDate.text = formatter.string(from: datePicker.date)
          }else {
              tfEndDate.text = formatter.string(from: datePicker.date)
          }
           //  tfDOB.text = formatter.string(from: datePicker.date)
             self.view.endEditing(true)
         }
      
      @objc func cancelDatePicker(){
             self.view.endEditing(true)
         }
  
    func doValidateFields()-> Bool{
        var flag = true
       if (tfFirstName.text?.isEmptyOrWhitespace())! {
            tfFirstName.showErrorWithText(errorText: "Enter first name")
            flag = false
        }
        if (tfLastName.text?.isEmptyOrWhitespace())!{
            tfLastName.showErrorWithText(errorText:  "Enter last name")
            flag = false
        }
        
        if tfEmail.text != ""{
            if !isValidEmail(email:  tfEmail.text!) {
                tfEmail.showErrorWithText(errorText:   "Enter valid email")
                flag = false
            }
        }
      
        if  tfMobile.text!.count < 8 {
            tfMobile.showErrorWithText(errorText:  "Enter mobile number")
            flag = false
        }
        if (tfAddress.text?.isEmptyOrWhitespace())!{
            tfAddress.showErrorWithText(errorText:  "Enter permanent address")
            flag = false
        }
      
        if tfStartDate.text != "" || tfEndDate.text != ""  {
            
            if tfStartDate.text == "" {
                flag = false
                showAlertMessage(title: "", msg: "Select Agreement Start Date")
            }
            if tfEndDate.text == "" {
                flag = false
                showAlertMessage(title: "", msg: "Select Agreement End Date")
            }
        }
        
        //        if tfTenantAgreement.text == ""{
        //            tfTenantAgreement.errorMessage = "Select Tenant Agreement"
        //            flag = false
        //        }
        
//        if fileAgreement.count == 0 {
//            showAlertMessage(title: "", msg: "Please select agreement documents")
//            flag = false
//        }
//        if filePolice.count == 0 {
//            showAlertMessage(title: "", msg: "Please select police verification documents")
//            flag = false
//        }
        return flag
    }
    
    @IBAction func btnAgreement(_ sender: UIButton) {
        
        print("cbc" ,  sender.tag)
        self.pickerTag = 1
        let alertVC = UIAlertController(title: "", message: "Select profile picture", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera()
        }))
        alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            //self.btnOpenGallery()
            self.shoImagePicker()
        }))
        /* alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
         self.attachDocument()
         }))*/
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func tapSave(_ sender: UIButton) {
        if doValidateFields(){
            doSubmitTenentData()
            
//            if fileAgreement.count > 0 && filePolice.count  > 0 {
//                 doCallApi()
//            } else {
//                if fileAgreement.count > 0 {
//                  //  tenant_doc[]
//                    doCallFileUpload(fileAgreement: fileAgreement, paramFile: "tenant_doc[]")
//                } else if  filePolice.count > 0 {
//                      doCallFileUpload(fileAgreement: filePolice, paramFile: "prv_doc[]")
//                } else {
//                    doCallApiWithoutIamge()
//                }
//
//            }
//
        }
    }
    
    func doCallApi(){
        self.showProgress()
        let params = ["addTenantNew":"addTenantNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_profile_pic":convertImageTobase64(imageView: imgUserProfile),
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "gender" : gender,
                      "owner_first_name":doGetLocalDataUser().userFirstName!,
                      "owner_last_name":doGetLocalDataUser().userLastName!,
                      "owner_email":doGetLocalDataUser().userEmail!,
                      "owner_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "society_name":doGetLocalDataUser().society_name!,
                      "last_address":tfAddress.text ?? ""]
        let request = AlamofireSingleTon.sharedInstance
        
        
      //  request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.switchUserController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3) { (data, error) in
        
        
        request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.switchUserController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: []
                                                    , ArrCountrycode: []) { (data, error) in
            
            
            self.hideProgress()
            if data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                    if response.status == "200"{
                        self.dismiss(animated: true, completion: {
                            self.settingsVC.doGetProfile()
                        })
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                }
            }
        }
    }
    
    
    func doCallFileUpload(fileAgreement : [URL] , paramFile  : String ) {
        self.showProgress()
              let params = ["addTenantNew":"addTenantNew",
                            "society_id":doGetLocalDataUser().societyID!,
                            "user_profile_pic":convertImageTobase64(imageView: imgUserProfile),
                            "user_first_name":tfFirstName.text!,
                            "user_last_name":tfLastName.text!,
                            "user_mobile":tfMobile.text!,
                            "user_email":tfEmail.text!,
                            "gender" : gender,
                            "owner_first_name":doGetLocalDataUser().userFirstName!,
                            "owner_last_name":doGetLocalDataUser().userLastName!,
                            "owner_email":doGetLocalDataUser().userEmail!,
                            "owner_mobile":doGetLocalDataUser().userMobile!,
                            "user_id":doGetLocalDataUser().userID!,
                            "unit_id":doGetLocalDataUser().unitID!,
                            "block_id":doGetLocalDataUser().blockID!,
                            "floor_id":doGetLocalDataUser().floorID!,
                            "society_name":doGetLocalDataUser().society_name!,
                            "last_address":tfAddress.text ?? ""]
              let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipartWithFileArryaImage(serviceName: ServiceNameConstants.switchUserController, parameters: params, doc_array: fileAgreement, paramName: paramFile, compression: 0.3) { (data, error) in
                  self.hideProgress()
                  if data != nil{
                      do{
                          let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                          if response.status == "200"{
                              self.dismiss(animated: true, completion: {
                                  self.settingsVC.doGetProfile()
                              })
                          }else{
                              self.showAlertMessage(title: "", msg: response.message)
                          }
                      }catch{
                      }
                  }
              }
        
        
        
    }
    
    func doCallApiWithoutIamge(){
           self.showProgress()
           let params = ["addTenantNew":"addTenantNew",
                         "society_id":doGetLocalDataUser().societyID!,
                         "user_profile_pic":convertImageTobase64(imageView: imgUserProfile),
                         "user_first_name":tfFirstName.text!,
                         "user_last_name":tfLastName.text!,
                         "user_mobile":tfMobile.text!,
                         "user_email":tfEmail.text!,
                         "gender" : gender,
                         "owner_first_name":doGetLocalDataUser().userFirstName!,
                         "owner_last_name":doGetLocalDataUser().userLastName!,
                         "owner_email":doGetLocalDataUser().userEmail!,
                         "owner_mobile":doGetLocalDataUser().userMobile!,
                         "user_id":doGetLocalDataUser().userID!,
                         "unit_id":doGetLocalDataUser().unitID!,
                         "block_id":doGetLocalDataUser().blockID!,
                         "floor_id":doGetLocalDataUser().floorID!,
                         "society_name":doGetLocalDataUser().society_name!,
                         "last_address":tfAddress.text ?? ""]
           let request = AlamofireSingleTon.sharedInstance
           request.requestPost(serviceName: ServiceNameConstants.switchUserController, parameters: params) { (data, error) in
               self.hideProgress()
               if data != nil{
                   do{
                       let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                       if response.status == "200"{
                           self.dismiss(animated: true, completion: {
                               self.settingsVC.doGetProfile()
                           })
                       }else{
                           self.showAlertMessage(title: "", msg: response.message)
                       }
                   }catch{
                   }
               }
           }
       }
    
    
     func doSubmitTenentData(){
            
            self.showProgress()
         
            let A4paperSize = CGSize(width: 595, height: 842)
            //for im
            if agreementImage.count > 0  {
                
                let pdf = SimplePDF(pageSize: A4paperSize)
                
                for (index,image) in agreementImage.enumerated() {
                    pdf.addImage(image)
                    if index + 1 != agreementImage.count {
                        pdf.beginNewPage()
                    }
                }
                
                if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                    let fileName = "example.pdf"
                    let documentsFileName = "file://\( documentDirectories + "/" + fileName)"
                    let pdfData = pdf.generatePDFdata()
                    let pdfURl:URL = URL(string: documentsFileName)!
                    do{
                        try pdfData.write(to: pdfURl, options: .atomicWrite)
                        print("\nThe generated pdf can be found at:")
                        print("\n\t\(documentsFileName)\n")
                        //self.fileUrl = pdfURl
                        fileAgreement.removeAll()
                        fileAgreement.append(pdfURl)
                    }catch{
                        print(error)
                    }
                    
                }
            }
            
            
        let params = ["addTenantNew":"addTenantNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_profile_pic":convertImageTobase64(imageView: imgUserProfile),
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "gender" : gender,
                      "owner_first_name":doGetLocalDataUser().userFirstName!,
                      "owner_last_name":doGetLocalDataUser().userLastName!,
                      "owner_email":doGetLocalDataUser().userEmail!,
                      "owner_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "society_name":doGetLocalDataUser().society_name!,
                      "tenant_agreement_start_date":tfStartDate.text!,
                      "tenant_agreement_end_date":tfEndDate.text!,
                      "country_code" :phoneCode,
                      "last_address":tfAddress.text ?? ""]
        
        
             print(params as Any)
            let request = AlamofireSingleTon.sharedInstance

        
        //    request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.switchUserController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3) { (data, error) in
        
        
        request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.switchUserController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: []
                                                    , ArrCountrycode: []) { (data, error) in
                
                
                self.hideProgress()
                if data != nil{
                    do{
                        let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                        if response.status == "200"{
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                        }else{
                            self.showAlertMessage(title: "", msg: response.message)
                        }
                    }catch{
                        
                    }
                }
             }
        }
    
    @IBAction func tapBack(_ sender: UIButton) {
     doPopBAck()
    }
    
    override func onClickDone() {
        self.doPopBAck()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if tfEmail.isEditing || tfMobile.isEditing{
            //            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
            //            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfMobile || textField == tfLastName{
            textField.addTarget(self, action: #selector(keyboardWillHide(notification:)), for: .editingDidBegin)
        }
       
        if textField == tfStartDate {
            dateSelect = "1"
        } else  if textField == tfEndDate  {
            dateSelect = "2"
        }
        
    }
    
    func btnOpenCamera(tag:Int! = 1) {
        //   self.pickerTag = tag
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            
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
    
    func btnOpenGallery(tag: Int! = 1) {
        
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
    
    private func attachDocument() {
        //        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypePNG]
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeText),String(kUTTypeRTF),String(kUTTypeSpreadsheet),String(kUTTypePNG),String(kUTTypeJPEG)], in: .import)
        
        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = true
        }
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        present(importMenu, animated: true)
    }
    
   
    @IBAction func onClickTenentAgreement(_ sender: Any) {
           pickerTag = 1
           
           if  fileAgreement.count != 10 {
               //  print(agreementImage.count - 10)
               imageLimit =  10 - agreementImage.count
               showDialogChoser()
             //  viewWillLayoutSubviews()
               selectType = "agrement"
           } else {
               showAlertMessage(title: "", msg: "Select maximum 10 documents")
           }
           
       }
    @IBAction func onClickTenentVerificationDocument(_ sender: Any) {
        pickerTag = 1
        if  filePolice.count != 1 {
            // imageLimit =   2 - policeVerificationImage.count
            showDialogChoser()
            // viewWillLayoutSubviews()
            selectType = "police"
        } else {
            showAlertMessage(title: "", msg: "Select maximum 1 documents")
        }
        
    }
    
    
    func showDialogChoser() {
        let alertVC = UIAlertController(title: "", message: "Select ID Proof", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera()
        }))
        alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            if self.selectType == "agrement" {
                self.shoImagePicker()
            } else {
                self.btnOpenGallery()
            }
           //self.btnOpenGallery()
            //  self.shoImagePicker()
        }))
        alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
            self.attachDocument()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickContacts(_ sender: Any) {
        let vc = subStoryboard.instantiateViewController(withIdentifier: "idContactVC") as! ContactVC
        vc.addTenantDialogVC = self
        vc.fromCome = "AddTenant"
        present(vc, animated: true, completion: nil)
    }
    
    func setNameAndNumber(number : String , fName: String,lName: String) {
        tfFirstName.text = fName
        tfLastName.text = lName
        
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
        
        
        tfMobile.text = conatct
        
    }
    
    func shoImagePicker() {
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = imageLimit
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        //Change color of image tint to black
        imagePicker.selectionImageTintColor = UIColor.black
        //Change status bar style
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        //Limit maximum allowed selections to 5
        //    imagePicker.maximumSelectionsAllowed = 10
        //Only allow image media type assets
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        imagePicker.imagePickerDelegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
    }
   
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[1-9][0-9]{7}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    @IBAction func onClickChoosePhoto(_ sender: Any) {
        self.pickerTag = 0
        showDialogChoser()
    }
    
    @IBAction func btnSelectCountry(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
}
extension AddTenantDialogVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate , OpalImagePickerControllerDelegate{
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        if isSelectDoc {
            isSelectDoc = false
            self.fileAgreement.removeAll()
        }
        for asset in assets {
            self.fileAgreement.append(URL(string: asset.originalFilename!)!)
            self.agreementImage.append(self.getAssetThumbnailNew(asset: asset))
        }
        
        if self.agreementImage.count > 0 {
            self.heightOfTenentAgreement.constant = 35
            print("didFinishPickingAssets")
        }
        
        DispatchQueue.main.async {
            self.cvAgreement.reloadData()
        }
        
        self.dismiss(animated: true, completion: nil)
         
      }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
//        if  selectType == "agrement" {
//
//
//            self.agreementImage.append(contentsOf: images)
//
//
//            DispatchQueue.main.async {
//                self.cvAgreement.reloadData()
//            }
//            if agreementImage.count > 0 {
//                heightConCvAgreement.constant = 60
//            }
//
//        } else {
//
//            self.policeVerificationImage.append(contentsOf: images)
//
//            DispatchQueue.main.async {
//                self.cvPoliceDocument.reloadData()
//            }
//            if policeVerificationImage.count > 0 {
//                heightConCvPoliceDocument.constant = 60
//            }
//
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
        isSelectDoc = true
        ///  self.tfTenantAgreement.text = "\(myURL)"
        //  tfTenantAgreement.errorMessage = ""
        
        let fileType = myURL.pathExtension.lowercased()
        if fileType == "pdf" ||  fileType == "png" || fileType == "jpg" || fileType == "jpeg" || fileType == "doc" || fileType == "docx" {
            self.fileUrl = myURL
            
            
            if  selectType == "agrement" {
                self.agreementImage.removeAll()
                self.fileAgreement.removeAll()
                self.fileAgreement.append(myURL)
                heightOfTenentAgreement.constant = 30
                DispatchQueue.main.async {
                    self.cvAgreement.reloadData()
                }
            } else {
                heightOfTenentVerification.constant = 30
                self.filePolice.append(myURL)
                DispatchQueue.main.async {
                    self.cvVerification.reloadData()
                }
            }
        } else {
            self.showAlertMessage(title: "", msg: "File Format not support")
        }
        
        print("selectType" , selectType)
        
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        print("pickerTag" , pickerTag)
        if self.pickerTag == 0 {
            self.imgUserProfile.image = selectedImage
        }else{
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                
                let imgName = UUID().uuidString + ".jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
                data.write(toFile: localPath, atomically: true)
                let imageURL = URL.init(fileURLWithPath: localPath)
                self.fileUrl = imageURL
                //   self.tfTenantAgreement.text = "\(imageURL)"
                //   tfTenantAgreement.errorMessage = ""
                
                if  selectType == "agrement" {
                     
                    // self.agreementImage.append(selectedImage)
                   
                    if isSelectDoc {
                        isSelectDoc = false
                        self.fileAgreement.removeAll()
                    }
                    heightOfTenentAgreement.constant = 30
                    // heightofViewVerification.constant = 275
                    self.fileAgreement.append(imageURL)
                    self.agreementImage.append(selectedImage)
                    DispatchQueue.main.async {
                        self.cvAgreement.reloadData()
                    }
                    
                    
                    //   print("camere agre == " ,  self.agreementImage.count)
                } else {
                    //self.policeVerificationImage.append(selectedImage)
                    heightOfTenentVerification.constant = 30
                    self.filePolice.append(imageURL)
                    //  print("camere police ==" , self.policeVerificationImage.count)
                    DispatchQueue.main.async {
                        self.cvVerification.reloadData()
                    }
                    
                }
                
                
                
            }else{
                let imageURL = info[.imageURL] as! URL
                self.fileUrl = imageURL
                //   self.tfTenantAgreement.text = "\(imageURL)"
                //   tfTenantAgreement.errorMessage = ""
                if  selectType == "agrement" {
                    self.fileAgreement.append(imageURL)
                    heightOfTenentAgreement.constant = 30
                    DispatchQueue.main.async {
                        self.cvAgreement.reloadData()
                        
                    }
                } else {
                    heightOfTenentVerification.constant = 30
                    self.filePolice.append(imageURL)
                    DispatchQueue.main.async {
                        self.cvVerification.reloadData()
                    }
                    
                }
                
            }
        }
    }
}



extension  AddTenantDialogVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,OnClickDeleteImage {
    func onClickDeleteImage(index: Int, type: String) {
        
        if type == "agrement" {
            fileAgreement.remove(at: index)
            if agreementImage.count > 0 {
                agreementImage.remove(at: index)
            }
            cvAgreement.reloadData()
            
//            if  fileAgreement.count == 0 {
//                he.constant = 0
//            }
            
        } else {
            filePolice.remove(at: index)
            cvVerification.reloadData()
            
//            if  filePolice.count == 0 {
//                heightConCvPoliceDocument.constant = 0
//            }
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvAgreement {
            //return agreementImage.count
            return fileAgreement.count
        } else {
            // return policeVerificationImage.count
            return filePolice.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentNameCell
        
        cell.index = indexPath.row
        cell.onClickDeleteImage = self
        
        if collectionView == cvAgreement {
            //  cell.ivDoc.image = agreementImage[indexPath.row]
            cell.lbTitle.text = fileAgreement[indexPath.row].absoluteString
            cell.type = "agrement"
        } else {
            //   cell.ivDoc.image = policeVerificationImage[indexPath.row]
            cell.type = "police"
            cell.lbTitle.text =  filePolice[indexPath.row].absoluteString
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    
}

extension AddTenantDialogVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        lblCountryNameCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.phoneCode = "+" + country.phoneExtension
    }
    func selectedAltCountry(country: Country) {
       
    }
}
