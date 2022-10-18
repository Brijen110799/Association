//
//  OwnedDataSelectVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices
import SkyFloatingLabelTextField
//import OpalImagePicker
import Photos
import DropDown
import FittedSheets
import EzPopup

struct ResponseRegistration : Codable {
    var user_id:String!//"user_id" : "408",
    var message:String! //"message" : "Registration success.",
    var status:String!// "status" : "200"
}
class OwnedDataSelectVC: BaseVC,MemberDelegate{
   
    @IBOutlet weak var btnCheckMark:UIButton!
    var StrCheckAddMember = ""
    var StrStatus = ""
    var StrtenantAddfamily = ""
    var ArrObj = NSMutableArray()
    
    var ArrFname = [String]()
    var ArrLname = [String]()
    var ArrCountyCode = [String]()
    var ArrMobile = [String]()
    var ArrRelation = [String]()
    
    @IBOutlet weak var VwAddMember: UIView!
    @IBOutlet weak var HeightTblvwConst: NSLayoutConstraint!
    @IBOutlet weak var tbldata:UITableView!
    @IBOutlet weak var HeightConstUpperVw: NSLayoutConstraint!
    @IBOutlet weak var Vwupper : UIView!
    @IBOutlet weak var HeightRelationMemeber: NSLayoutConstraint!
    @IBOutlet weak var HeightRelationConstant: NSLayoutConstraint!
    @IBOutlet weak var HeightCompanyConst: NSLayoutConstraint!
    @IBOutlet weak var VwTenantRelation:UIView!
    @IBOutlet weak var VwTenantEnterRelation:UIView!
    @IBOutlet weak var lblTenantOwnerDetail:UILabel!
    @IBOutlet weak var VwImage:UIView!
    @IBOutlet weak var VwOwnerDetails : UIView!
    var relationMember = [String]()
    @IBOutlet weak var viewOtherRelation: UIView!
    @IBOutlet weak var btnDropdownRelation: UIButton!
    @IBOutlet weak var lblRelation: UILabel!
    var selectedBlock : BlockModel!
    var StrUnitname = ""
    var StrUnitNumber = ""
    var isSociety = ""
    let itemCell = "DocumentNameCell"
    var newcountrycode = ""
    @IBOutlet weak var tfrelation: ACFloatingTextfield!
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var tfOwnerName: ACFloatingTextfield!
    @IBOutlet weak var tfOwnerLastName: ACFloatingTextfield!
    @IBOutlet weak var tfOwnerMobile: ACFloatingTextfield!
    
    @IBOutlet weak var tfFirstName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfHouseNo: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    //  @IBOutlet weak var tfPassword: ACFloatingTextfield!
    @IBOutlet weak var tfPermanentAddress: ACFloatingTextfield!
    @IBOutlet weak var ivredioMale: UIImageView!
    @IBOutlet weak var ivredioFeMale: UIImageView!
    @IBOutlet weak var cvAgreement: UICollectionView!
    @IBOutlet weak var cvVerification: UICollectionView!
    @IBOutlet weak var viewSepratorCompany: UIView!
    
    @IBOutlet weak var viewTenentVerification: UIView!
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbUsetType: UILabel!
    
    @IBOutlet weak var bSelectCountry: UIButton!
    @IBOutlet weak var heightofViewVerification: NSLayoutConstraint!
    @IBOutlet weak var heightOfTenentAgreement: NSLayoutConstraint!
    @IBOutlet weak var heightOfTenentVerification: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFeMale: UIView!
    @IBOutlet weak var lbTitleDetails: UILabel!
    @IBOutlet weak var viewCompanyowner: UIView!
    @IBOutlet weak var viewCompanyTenent: UIView!
    @IBOutlet weak var tfCompanyname: ACFloatingTextfield!
   // @IBOutlet weak var tfOwnerCompanyname: ACFloatingTextfield!
    
    @IBOutlet weak var VwRelationHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewSepratorCompanyUpper: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lbOnwerCountryCode: UILabel!
    @IBOutlet weak var VwRelation : UIView!
   
    @IBOutlet weak var bRegister: UIButton!
    @IBOutlet weak var lbOnwerDetails: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMale: UILabel!
    @IBOutlet weak var lbFemale: UILabel!
    @IBOutlet weak var lbSelectRentAgreement: UILabel!
    @IBOutlet weak var lbSelectPoliceVerification: UILabel!
    @IBOutlet weak var lbAddMember: UILabel!
    
    var countryList = CountryList()
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""
    
    var society_name:String!
    
    var userType : String!
    var unitModel : UnitModel!
    var blockModel:BlockModel!
    var modelInfoMember:ModelInfoMember!
    var society_id:String!
    var mobileNumber:String!
    let dropDown = DropDown()
    var isUserinsert = true
    var isImagePick = false
    
    // for agreement and Verification
    var selectType =  ""
    var fileUrl:URL!
    var fileAgreement = [URL]()
    var filePolice = [URL]()
    var pickerTag = 1
    var imageLimit = 10
    var agreementImage = [UIImage]()
    var policeVerificationImage = [UIImage]()
   
    @IBOutlet weak var bPassword: UIButton!
    var gender = "Male"
    var item = "InfoFamalyMemberCell"
    
    var  heightCVFamily = 0.0
    var  heightCVEmergancy = 0.0
    var iconClick = true
    var societyDetails : ModelSociety!
    
    let datePicker = UIDatePicker()
    var dateSelect = ""
    var isSelectDoc = false
    var owner_country_code = ""
    var tag = 0
    var StrCheckRelation :String!
    var isAddMoreSociety = false // this flag is only used for language
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tbldata.isHidden = true
        VwAddMember.isHidden = true
        HeightRelationConstant.constant = 0
        HeightRelationMemeber.constant = 0
        heightConstraint.constant = 264
        VwRelation.isHidden = true
        VwImage.isHidden = true
        VwTenantEnterRelation.isHidden = true
        VwRelationHeightConstant.constant = 0
       
        self.relationMember =  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandpa","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"]
        
        initDropdown()
       
        lblRelation.text = relationMember[0]
        setData()
        if StrCheckAddMember == "1"
        {
            tbldata.isHidden = false
            VwAddMember.isHidden = false
            
        }else
        {
            tbldata.isHidden = true
            VwAddMember.isHidden = true
        }
        
        if ArrObj.count > 0
        {
            HeightTblvwConst.constant = CGFloat(73 * ArrObj.count)
        }else
        {
            HeightTblvwConst.constant = 0
        }
      if isUserinsert == false
      {
        
            tfFirstName.text = doGetLocalDataUser().userFirstName
            tfLastName.text = doGetLocalDataUser().userLastName
            tfMobile.text = doGetLocalDataUser().userMobile
            tfMobile.isUserInteractionEnabled = false
            tfHouseNo.isUserInteractionEnabled = false
            Utils.setImageFromUrl(imageView: ivImage, urlString: doGetLocalDataUser().userProfilePic,palceHolder:
                                    StringConstants.KEY_USER_PLACE_HOLDER)
      }
      
        let nib = UINib(nibName: itemCell, bundle: nil)
        countryList.delegate = self
            
                doneButtonOnKeyboard(textField: tfMobile)
        //        //tfMobile.text = "9096693518"
        //        // tfPassword.text = "12345"
                tfMobile.delegate = self
        //        tfPassword.delegate = self
        //        ivLogo.setImageColor(color: UIColor.white)
        //        ivPassword.setImageColor(color: UIColor.white)
                lblCountryCode.text = "\u{1F1EE}\u{1F1F3} +91"
                hideKeyBoardHideOutSideTouch()
        //        bForgot.clipsToBounds = true
        //        bForgot.isHidden = true
        //        viewPassword.isHidden = true
        //        heightPasswordView.constant = 0
                
                //addGradient(viewMain: LoginButtonParentVie, color: [#colorLiteral(red: 0.4078431373, green: 0.1803921569, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.4078431373, green: 0.1803921569, blue: 0.4901960784, alpha: 0.7)])
                
        cvAgreement.register(nib, forCellWithReuseIdentifier: itemCell)
        cvVerification.register(nib, forCellWithReuseIdentifier: itemCell)
        
        cvAgreement.delegate = self
        cvAgreement.dataSource = self
        
        cvVerification.delegate = self
        cvVerification.dataSource = self
        
        
        heightOfTenentAgreement.constant = 0
        heightOfTenentVerification.constant = 0
        
        initDatePicker()
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        
        if isUserinsert == true
       {
            isSociety = "\(societyDetails.is_society ?? true)"
           
            if societyDetails.is_society == false
            {
                
                viewCompanyTenent.isHidden=false
                viewSepratorCompany.isHidden = false
                
            }else{
                
                viewCompanyTenent.isHidden=true
                viewSepratorCompany.isHidden = true
               
            }
           
       }else
       {
        // non commercial
        
        bSelectCountry.isEnabled = false
        isSociety = "\(doGetLocalDataUser().isSociety ?? true)"
        if doGetLocalDataUser().isSociety == false
        {
           
            viewCompanyTenent.isHidden=false
            viewSepratorCompany.isHidden = false
            
        }else{
            
            viewCompanyTenent.isHidden=true
            viewSepratorCompany.isHidden = true
        }
       
       }
        
        if userType == "0" {
            // owner
            if  VwRelation.isHidden == true
            {
                StrCheckRelation = "0"
            }else{
                StrCheckRelation = "1"
            }
            
            if StrStatus == "1"
            {
                VwTenantRelation.isHidden = false
                VwRelation.isHidden = false
                HeightRelationMemeber.constant = 70
                HeightRelationConstant.constant = 0
            
            }else{
                VwTenantRelation.isHidden = true
                VwRelation.isHidden = true
                HeightRelationConstant.constant = 0
                HeightRelationMemeber.constant = 0
              
            }
           // lbUsetType.text = "Owner"
            HeightCompanyConst.constant = 0
            viewOwner.isHidden = true
            heightConstraint.constant = 8.0
            viewTenentVerification.isHidden = true
            // heightofViewVerification.constant = 0
            VwRelation.isHidden = false
          //  VwOwnerDetails.isHidden = false
            heightConstraint.constant = 0
            //lbTitleDetails.text = "Fill Up Your Details"
            lbUsetType.text = doGetValueLanguage(forKey: "owner")
            lbTitleDetails.text = doGetValueLanguage(forKey: "verify_your_details")
           
            if StrStatus == "1" {
                lbUsetType.text = doGetValueLanguage(forKey: "owner_family")
                lbTitleDetails.text = doGetValueLanguage(forKey: "verify_your_details")
            }
            
            
            if isAddMoreSociety {
                lbUsetType.text = doGetValueLanguageForAddMore(forKey: "owner")
                lbTitleDetails.text = doGetValueLanguageForAddMore(forKey: "verify_your_details")
               
                if StrStatus == "1" {
                    lbUsetType.text = doGetValueLanguageForAddMore(forKey: "owner_family")
                    lbTitleDetails.text = doGetValueLanguageForAddMore(forKey: "verify_your_details")
                }
            }
            
        } else {
            
            if  VwTenantEnterRelation.isHidden == true
            {
                StrCheckRelation = "0"
            }else{
                StrCheckRelation = "1"
            }
            if StrStatus == "1"
            {
              
            }else{
                
                VwTenantRelation.isHidden = true
                VwRelation.isHidden = true
                HeightRelationConstant.constant = 0
                HeightRelationMemeber.constant = 0
                VwRelationHeightConstant.constant = 0
                Vwupper.isHidden = true
                HeightConstUpperVw.constant = 0
                heightConstraint.constant = 200
                
            }
            
            // 3 renter
            lbUsetType.text = doGetValueLanguage(forKey: "tenant")
            if isAddMoreSociety {
                lbUsetType.text = doGetValueLanguageForAddMore(forKey: "tenant")
            }
            HeightCompanyConst.constant = 0
            viewTenentVerification.isHidden = false
          //  viewCompanyowner.isHidden=true
            
            //    heightofViewVerification.constant = 245
            
            StrStatus = "1"
            
        }
        
        if StrtenantAddfamily == "1"
        {
            
            VwOwnerDetails.isHidden = true
            viewOwner.isHidden = true
            lbUsetType.text = doGetValueLanguage(forKey: "tenant")
            if isAddMoreSociety {
                lbUsetType.text = doGetValueLanguageForAddMore(forKey: "tenant")
            }
            //lbTitleDetails.text = "Tenant Details"
        }
        //lbUsetType.text = doGetValueLanguage(forKey: "tenant")
      //  lbTitleDetails.text = doGetValueLanguage(forKey: "tenant_details")
      
        if mobileNumber != nil && !isUserinsert{
            tfMobile.text = mobileNumber
            tfMobile.isEnabled = false
            tfMobile.isUserInteractionEnabled = false
        }
        tfOwnerName.delegate = self
        tfOwnerLastName.delegate = self
        tfOwnerMobile.delegate = self
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfHouseNo.delegate = self
        tfEmail.delegate = self
        tfMobile.delegate = self
        tfCompanyname.delegate = self
        // tfPassword.delegate = self
        tfPermanentAddress.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if userType == "0"{
            addInputAccessoryForTextFields(textFields: [tfCompanyname,tfFirstName,tfLastName,tfEmail,tfMobile], dismissable: true, previousNextable: true)
        }else{
            addInputAccessoryForTextFields(textFields: [tfCompanyname,tfOwnerName,tfOwnerLastName,tfOwnerMobile,tfFirstName,tfLastName,tfEmail,tfMobile,tfPermanentAddress], dismissable: true, previousNextable: true)
        }
        
        selectMale()
        setDefultCountry()
    
    }
    func PassData(Fname: String, Lname: String, Mobile: String, relation: String, countryCode:String) {
        
        print(Fname,Lname,Mobile,relation,countryCode)
        
        ArrFname.append(Fname)
        ArrLname.append(Lname)
        ArrMobile.append(Mobile)
        ArrRelation.append(relation)
        ArrCountyCode.append(countryCode)
        
        let fullname = Fname + " " + Lname
        ArrObj.add(fullname)
     
        if ArrObj.count > 0
        {
            HeightTblvwConst.constant = CGFloat(73 * ArrObj.count)
            tbldata.reloadData()
        }
    }
    @IBAction func onClickTerms(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idTermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func AddMemberClick(_ sender: UIButton) {
        
        let screenwidth = UIScreen.main.bounds.width
                let screenheight = UIScreen.main.bounds.height
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMemberVC") as! AddMemberVC
                nextVC.delegate = self
        
             //   nextVC.cabCompanyList = self.dailyCompanyList
              //  nextVC.contextDailyVisitor = self
       
                //nextVC.Strvalue = StrActivate
                let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
                    , popupHeight: screenheight
                )
                
                popupVC.backgroundAlpha = 0.8
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = false
                present(popupVC, animated: true)
    }
    func initDropdown(){
        dropDown.anchorView = btnDropdownRelation
        dropDown.dataSource = relationMember
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblRelation.text = self.dropDown.selectedItem
            
            if  self.dropDown.selectedItem == "Other" {
              
                VwTenantEnterRelation.isHidden = false
                VwImage.isHidden = false
                HeightRelationConstant.constant = 48
            } else {
               // heightConstraint.constant = 264
              //  VwRelationHeightConstant.constant = 0
               // self.VwRelation.isHidden = true
                VwTenantEnterRelation.isHidden = true
                VwImage.isHidden = true
                HeightRelationConstant.constant = 0
            }
        }
        //dropDown.width = btnDropdownRelation.frame.width - 50
     
    }
    @IBAction func onClickDropdown(_ sender: Any) {
        dropDown.show()
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode = "+" + item.phoneExtension
                newcountrycode =  "+\(item.phoneExtension)"
                // newcountrycode = "+1"
                
                if userType != "0" {
                    lbOnwerCountryCode.text = "\(item.flag!) (\(item.countryCode)) +\(item.phoneExtension)"
                    owner_country_code = "+\(item.phoneExtension)"
                }
                break
            }
        }
       }
    
    override func viewWillLayoutSubviews(){
        //         if  fileAgreement.count == 0 {
        //            heightOfTenentAgreement.constant = 0
        //            heightofViewVerification.constant = 245
        //            if filePolice.count == 0{
        //                heightOfTenentVerification.constant = 0
        //                heightofViewVerification.constant = 245
        //            }else{
        //                heightOfTenentVerification.constant = 30
        //                heightofViewVerification.constant = 295
        //            }
        //         }else{
        //            heightOfTenentAgreement.constant = 30
        //            heightofViewVerification.constant = 295
        //             if filePolice.count != 0{
        //            heightOfTenentVerification.constant = 30
        //            heightofViewVerification.constant = 325
        //             }else{
        //                heightOfTenentVerification.constant = 0
        //                heightofViewVerification.constant = 295
        //            }
        //        }
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfStartDate {
            dateSelect = "1"
        } else {
            dateSelect = "2"
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return view.endEditing(true)
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


        }))
        alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
            self.attachDocument()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func btnOpenCamera(tag:Int! = 1) {
        //   self.pickerTag = tag
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //  imagePicker.allowsEditing = true
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
            //   imagePicker.allowsEditing = true
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
    
    func isValidate() -> Bool {
        var isValidate = true
        if userType == "1"{
            
//            if (tfOwnerCompanyname.text?.isEmptyOrWhitespace())! {
//                isValidate = false
//                tfOwnerCompanyname.showErrorWithText(errorText: "Enter Owner's CompanyName")
//            }
            
         
           
            if (tfOwnerName.text?.isEmptyOrWhitespace())! {
                isValidate = false
                
                tfOwnerName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_owner_first_name"))
                
                if isAddMoreSociety {
                    tfOwnerName.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_owner_first_name"))
                }
            }
            
            if (tfOwnerLastName.text?.isEmptyOrWhitespace())! {
                isValidate = false
                tfOwnerLastName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_owner_last_name"))
                if isAddMoreSociety {
                    tfOwnerLastName.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_owner_last_name"))
                }
            }
            if tfOwnerMobile.text == "" {
                isValidate = false
                tfOwnerMobile.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                
                if isAddMoreSociety {
                    tfOwnerMobile.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_mobile_number"))
                }
            }
            if (tfPermanentAddress.text?.isEmptyOrWhitespace())! {
                isValidate = false
                tfPermanentAddress.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_address"))
                if isAddMoreSociety {
                    tfPermanentAddress.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_address"))
               }
            }
            if tfOwnerMobile.text!.count < 8 {
                isValidate = false
                tfOwnerMobile.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                if isAddMoreSociety {
                    tfOwnerMobile.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_mobile_number"))
                }
            }
            
//            if fileAgreement.count == 0 {
//                showAlertMessage(title: "", msg: "Please choose agreement documents")
//
//            }
//            if filePolice.count == 0 {
//                showAlertMessage(title: "", msg: "Please choose police verification documents")
//
//            }
            
            if tfStartDate.text != "" || tfEndDate.text != ""  {
                
                if tfStartDate.text == "" {
                    isValidate = false
                    showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_select_rent_agreement_start_date"))
                    if isAddMoreSociety {
                        showAlertMessage(title: "", msg: doGetValueLanguageForAddMore(forKey: "please_select_rent_agreement_start_date"))
                    }
                }
                if tfEndDate.text == "" {
                    isValidate = false
                    showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_select_rent_agreement_end_date"))
                    if isAddMoreSociety {
                        showAlertMessage(title: "", msg: doGetValueLanguageForAddMore(forKey: "please_select_rent_agreement_end_date"))
                    }
                }
            }

        }
        
//        if (tfCompanyname.text?.isEmptyOrWhitespace())! {
//            isValidate = false
//            tfCompanyname.showErrorWithText(errorText: "Enter Your CompanyName")
//        }
        
//        if (tfrelation.text?.isEmptyOrWhitespace())! {
//            isValidate = false
//            tfrelation.showErrorWithText(errorText: "Enter Relation")
//        }
        if lblRelation.text == "Other"
        {
            if (tfrelation.text?.isEmptyOrWhitespace())! {
                isValidate = false
                tfrelation.showErrorWithText(errorText: "Enter Relation")
            }

        }
    
        if  (tfFirstName.text?.isEmptyOrWhitespace())!  {
            isValidate = false
            tfFirstName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_first_name"))
            if isAddMoreSociety {
                tfFirstName.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_first_name"))
            }
        }
        if (tfLastName.text?.isEmptyOrWhitespace())!  {
            isValidate = false
            tfLastName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_last_name"))
            if isAddMoreSociety {
                tfLastName.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_last_name"))
                
            }
        }
        if tfHouseNo.text == "" {
            isValidate = false
            tfHouseNo.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_select_unit_number"))
            if isAddMoreSociety {
                tfHouseNo.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_select_unit_number"))
            }
        }
        
        if tfEmail.text != "" {
            if !isValidEmail(email: tfEmail.text!) {
                isValidate = false
                tfEmail.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_email_id"))
                if isAddMoreSociety {
                    tfEmail.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_email_id"))
                }
            }
        }
//        else{
//            isValidate = false
//            tfEmail.showErrorWithText(errorText: "Enter Email Address")
//        }
        
        if  tfMobile.text!.count < 8 {
            isValidate = false
            tfMobile.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
            if isAddMoreSociety {
               tfMobile.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_mobile_number"))
            }
        }
        if isUserinsert == true
       {
            // commercial
            viewCompanyTenent.isHidden=true
            viewSepratorCompany.isHidden = true
           
       }else
       {
        // non commercial
        
        if doGetLocalDataUser().isSociety == false
        {
            
            if (tfCompanyname.text?.isEmptyOrWhitespace())! {
                isValidate = false
                tfCompanyname.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_company_name"))
                if isAddMoreSociety {
                    tfCompanyname.showErrorWithText(errorText: doGetValueLanguageForAddMore(forKey: "please_enter_valid_company_name"))
                }
            }
            
        }else{
            
            viewCompanyTenent.isHidden=true
            viewSepratorCompany.isHidden = true
        }
       
       }
        return isValidate
    }
    @IBAction func onClickBack(_ sender: Any) {
        
        if isUserinsert == false
        {
            doPopBAck()
        }else
        {
            doPopBAck()
        }
        
    }
    @IBAction func onClickChoosePhoto(_ sender: Any) {
        self.pickerTag = 0
        openPhotoSelecter()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        print("djgfsjgdfjgjsf")
        
        if StrUnitname != "" {
            
            tfHouseNo.text = selectedBlock.block_name  + "-" + unitModel.unit_name!
            //  print("tetset " , unitModel.unit_name!)
        }
    }
    @IBAction func onClickSelectHouse(_ sender: Any) {
//        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
//
//        if !isUserinsert{
//            vc.society_id = self.society_id
//        }else{
//            vc.society_id = societyDetails.society_id!
//            vc.societyDetails = self.societyDetails
//        }
//        vc.isUserInsert = self.isUserinsert
//        vc.ownedDataSelectVC = self
//        self.view.endEditing(true)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func onClickAddMember(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    @IBAction func clickSelectCountry(_ sender: UIButton) {
        tag = sender.tag
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    //    @IBAction func OnClickselectCountryy(_ sender: UIButton) {
//
//        tag = sender.tag
//        let navController = UINavigationController(rootViewController: countryList)
//        self.present(navController, animated: true, completion: nil)
//    }
    
//    @IBAction func onClickSelectCountry(_ sender: Any) {
//        tag = (sender as AnyObject).tag
//        let navController = UINavigationController(rootViewController: countryList)
//        self.present(navController, animated: true, completion: nil)
//    }
    
//    @IBAction func onClickSelectCountry(_ sender: UIButton) {
//        tag = sender.tag
//        let navController = UINavigationController(rootViewController: countryList)
//        self.present(navController, animated: true, completion: nil)
//    }
    @objc func openPhotoSelecter(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose a source", message: "", preferredStyle: .actionSheet)
        // actionSheet.view.layer.cornerRadius = 10
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                print("not")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil )
    }
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        guard let selectedImage = info[.originalImage] as? UIImage else {
    //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    //        }
    //        self.ivImage.image = selectedImage
    //        self.isImagePick = true
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if isValidate() {
            if userType == "0"{
                if StrtenantAddfamily == "1" {
                    
                    doSubmitTenentDataAddFamily()
                    
                }else{
                    
                    if StrStatus == "1"
                    {
                    
                     doSubmitDataAddMemberOwner()
                    }else
                    {
                     doSubmitData()
                    }
                }
    
            }else{
                doSubmitTenentData()
            }
        }
    }
    func doSubmitData() {
        self.showProgress()
     
        var tagForApi = ""

        if isUserinsert{
            tagForApi = "addUser"
        }else{
            tagForApi = "addMoreUser"
        }
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        let params = ["key":apiKey(),
                      "addUser":tagForApi,
                      "user_id":"0",
                      "society_id":society_id!,
                      "block_id":selectedBlock.block_id ?? "",
                      //"block_id":blockModel.block_id!,
                      "floor_id":unitModel.floor_id!,
                      "unit_id":unitModel.unit_id!,
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_id_proof":"",
                      "user_profile_pic":convertImageTobase64(imageView: ivImage),
                      "owner_first_name":tfOwnerName.text!,
                      "owner_last_name":tfOwnerLastName.text!,
                      "owner_mobile":tfOwnerMobile.text!,
                      "user_type":userType!,
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "gender":gender,
                      "company_name":tfCompanyname.text ?? "",
                      "isSociety":isSociety,
                     // "relation":lblRelation.text ?? "",
                      "country_code":newcountrycode]
       
        print(params)
       
        let requrest = AlamofireSingleTon.sharedInstance
        
        if !isUserinsert{
            print("isUserinsert")
            print(ArrFname)
            
            requrest.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: ArrFname, Arrlname: ArrLname, Arrmobile: ArrMobile, ArrRelation: ArrRelation
                                                        , ArrCountrycode: ArrCountyCode) { (json, error) in
                
             
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                        if response.status == "200" {
                            
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                     
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }else
        {
            requrest.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, baseUrl:societyDetails.sub_domain! + StringConstants.APINEW, Arrfname: ArrFname, Arrlname: ArrLname, Arrmobile: ArrMobile, ArrRelation: ArrRelation, ArrCountrycode: ArrCountyCode) { (json, error) in
            
             
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                      
                        if response.status == "200" {
                            
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }

    }
    func doSubmitDataAddMemberOwner() {
        self.showProgress()
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        let params = ["key":apiKey(),
                      "addFamilyRequest":"addFamilyRequest",
                      "society_id":society_id!,
                      "society_address":"",
                      "block_id":selectedBlock.block_id ?? "",
                      //"block_id":blockModel.block_id!,
                      "floor_id":unitModel.floor_id!,
                      "unit_id":unitModel.unit_id!,
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_profile_pic":convertImageTobase64(imageView: ivImage),
                      "owner_first_name":tfOwnerName.text!,
                      "owner_last_name":tfOwnerLastName.text!,
                      "owner_mobile":tfOwnerMobile.text!,
                      "user_type":userType!,
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "gender":gender,
                      "device":"",
                      "last_address":"",
                      "company_name":tfCompanyname.text ?? "",
                      "isSociety":isSociety,
                      "member_relation":lblRelation.text ?? "",
                      "unit_name"  : unitModel.unit_name!,
                      "country_code":newcountrycode]
        
        print(params)
       
        let requrest = AlamofireSingleTon.sharedInstance
        
        if !isUserinsert{
            print("isUserinsert")
        
            
            requrest.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: []
                                                        , ArrCountrycode: []) { (json, error) in
            
           
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                        
                        
                        if response.status == "200" {
                            
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                            
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }else{
            requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params,baseUer:societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
                
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                        
                        
                        if response.status == "200" {
                            
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                            
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }
    }
   
    func doSubmitTenentData(){
        
        print(ArrFname)
        
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
        
        
        
        var tagForApi = ""
        
        if isUserinsert{
            tagForApi = "addUser"
        }else{
            tagForApi = "addMoreUser"
        }
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        //        let params = ["addTenantNew":"addTenantNew",
        //                      "society_id": society_id!,
        //                      "user_profile_pic":convertImageTobase64(imageView: ivImage),
        //                      "user_first_name":tfFirstName.text!,
        //                      "user_last_name":tfLastName.text!,
        //                      "user_mobile":tfMobile.text!,
        //                      "user_email":tfEmail.text!,
        //                      "gender" : gender,
        //                      "owner_first_name":tfOwnerName.text!,
        //                      "owner_last_name": tfOwnerLastName.text!,
        //                     // "owner_email":doGetLocalDataUser().userEmail!,
        //                      "owner_mobile":tfOwnerMobile.text!,
        //                      "user_id":unitModel.unit_id!,
        //                      "unit_id":doGetLocalDataUser().unitID!,
        //                      "block_id":doGetLocalDataUser().blockID!,
        //                      "floor_id":doGetLocalDataUser().floorID!,
        //                      "society_name":doGetLocalDataUser().society_name!,
        //                      "tenant_prv_address":tfPermanentAddress.text!,
        //                      "gender":gender]
       
        //
        let params = ["key":apiKey(),
                      "addUser":tagForApi,
                      "user_id":"0",
                      "society_id":society_id!,
                      "block_id":selectedBlock.block_id!,
                      //"block_id":blockModel.block_id!,
                      "floor_id":unitModel.floor_id!,
                      "unit_id":unitModel.unit_id!,
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_id_proof":"",
                      "user_profile_pic":convertImageTobase64(imageView: ivImage) ,
                      "owner_first_name":tfOwnerName.text!,
                      "owner_last_name":tfOwnerLastName.text!,
                      "owner_mobile":tfOwnerMobile.text!,
                      "user_type":userType!,
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "tenant_prv_address":tfPermanentAddress.text!,
                      "tenant_agreement_start_date":tfStartDate.text!,
                      "tenant_agreement_end_date":tfEndDate.text!,
                      "gender":gender,
                      "company_name":tfCompanyname.text ?? "",
                      "isSociety":isSociety,
                      "country_code":newcountrycode,
                     // "relation":lblRelation.text ?? "",
                      "owner_country_code" : owner_country_code]
       
        print(params)
        
        let request = AlamofireSingleTon.sharedInstance
        if !isUserinsert{
            print("isUserinsert")
        
            request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: ArrFname, Arrlname:ArrLname, Arrmobile:ArrMobile, ArrRelation:ArrRelation
                                                        , ArrCountrycode:ArrCountyCode) { (data, error) in

                if data != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                        if response.status == "200" {

                            self.showAlertMessageWithClick(title: "", msg: response.message)

                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }else{
      
            request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, baseUrl: societyDetails.sub_domain! + StringConstants.APINEW, Arrfname:ArrFname, Arrlname: ArrLname, Arrmobile: ArrMobile, ArrRelation: ArrRelation, ArrCountrycode:ArrCountyCode) { (data, error) in
                
          

                if data != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                        if response.status == "200" {

                            self.showAlertMessageWithClick(title: "", msg: response.message)

                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }
    }
    func doSubmitTenentDataAddFamily(){
        
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
 
//        var tagForApi = ""
//
//        if isUserinsert{
//            tagForApi = "addFamilyRequest"
//        }else{
//            tagForApi = "addFamilyRequest"
//        }
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        //        let params = ["addTenantNew":"addTenantNew",
        //                      "society_id": society_id!,
        //                      "user_profile_pic":convertImageTobase64(imageView: ivImage),
        //                      "user_first_name":tfFirstName.text!,
        //                      "user_last_name":tfLastName.text!,
        //                      "user_mobile":tfMobile.text!,
        //                      "user_email":tfEmail.text!,
        //                      "gender" : gender,
        //                      "owner_first_name":tfOwnerName.text!,
        //                      "owner_last_name": tfOwnerLastName.text!,
        //                     // "owner_email":doGetLocalDataUser().userEmail!,
        //                      "owner_mobile":tfOwnerMobile.text!,
        //                      "user_id":unitModel.unit_id!,
        //                      "unit_id":doGetLocalDataUser().unitID!,
        //                      "block_id":doGetLocalDataUser().blockID!,
        //                      "floor_id":doGetLocalDataUser().floorID!,
        //                      "society_name":doGetLocalDataUser().society_name!,
        //                      "tenant_prv_address":tfPermanentAddress.text!,
        //                      "gender":gender]
       
        //
        let params = ["key":apiKey(),
                      "addFamilyRequest":"addFamilyRequest",
                      "user_id":"0",
                      "society_id":society_id!,
                      "society_address" : "",
                      "block_id":selectedBlock.block_id!,
                      //"block_id":blockModel.block_id!,
                      "floor_id":unitModel.floor_id!,
                      "unit_id":unitModel.unit_id!,
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_id_proof":"",
                      "user_profile_pic":convertImageTobase64(imageView: ivImage) ,
                     // "owner_first_name":tfOwnerName.text!,
                    //  "owner_last_name":tfOwnerLastName.text!,
                    //  "owner_mobile":tfOwnerMobile.text!,
                      "user_type":"1",
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                     // "tenant_prv_address":tfPermanentAddress.text!,
                     // "tenant_agreement_start_date":tfStartDate.text!,
                     // "tenant_agreement_end_date":tfEndDate.text!,
                      "gender":gender,
                      "company_name":tfCompanyname.text ?? "",
                      "isSociety":isSociety,
                      "country_code":newcountrycode,
                      "member_relation":lblRelation.text ?? "",
                      "device":""]
        // country_code
        
        print(params)
        
        let request = AlamofireSingleTon.sharedInstance
        if !isUserinsert{
            print("isUserinsert")
           
         //   request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3) { (data, error) in
            
            
            request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: []
                                                        , ArrCountrycode: []) { (data, error) in

                if data != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                        if response.status == "200" {

                            self.showAlertMessageWithClick(title: "", msg: response.message)

                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }else{
            
//            request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3,baseUrl: societyDetails.sub_domain! + StringConstants.APINEW) { (data, error) in
            
            
            request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, baseUrl: societyDetails.sub_domain! + StringConstants.APINEW, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: [], ArrCountrycode: []) { (data, error) in
                
                
                

                if data != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                        if response.status == "200" {

                            self.showAlertMessageWithClick(title: "", msg: response.message)

                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
        }
    }
    override func onClickDone() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) || controller.isKind(of: AddBuildingLoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
//        if isUserinsert{
//            //            Utils.setHomeRootLogin()
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: LoginVC.self) || controller.isKind(of: AddBuildingLoginVC.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }else{
//
//            Utils.setHome()
//
//        }
    }
    
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "down-arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
    
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
    }
    private func textFieldDidBeginEditing(textField: UITextField) {
        //tfFirstName = (textField as! ACFloatingTextfield)
      
        if tfCompanyname.text != ""
        {
            tfCompanyname = (textField as! ACFloatingTextfield)
        }else{
            tfFirstName = (textField as! ACFloatingTextfield)
        }
      
    }
    private func textFieldDidEndEditing(textField: UITextField) {
        //tfFirstName = nil
        
        if tfCompanyname.text != ""
        {
            tfCompanyname = nil
        }else{
            tfFirstName = nil
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
        let phoneRegex = "^[1-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    func setData(){
        lbTitle.text = doGetValueLanguage(forKey: "registration_title")
        lbOnwerDetails.text = doGetValueLanguage(forKey: "owner_details")
        tfOwnerName.placeholder = "\(doGetValueLanguage(forKey: "first_name"))*"
        tfOwnerLastName.placeholder = "\(doGetValueLanguage(forKey: "last_name"))*"
        tfOwnerMobile.placeholder = "\(doGetValueLanguage(forKey: "mobile_number"))*"
        
        lbMale.text = doGetValueLanguage(forKey: "male")
        lbFemale.text = doGetValueLanguage(forKey: "female")
    
        tfFirstName.placeholder = "\(doGetValueLanguage(forKey: "first_name"))*"
        tfLastName.placeholder = "\(doGetValueLanguage(forKey: "last_name"))*"
        tfHouseNo.placeholder = doGetValueLanguage(forKey: "unit_no")
        tfEmail.placeholder = doGetValueLanguage(forKey: "email_id")
        tfMobile.placeholder = "\(doGetValueLanguage(forKey: "mobile_number"))*"
        tfPermanentAddress.placeholder = "\(doGetValueLanguage(forKey: "permanent_address"))*" 
      
        lbSelectRentAgreement.text = doGetValueLanguage(forKey: "attach_rent_agreement")
        tfStartDate.placeholder = doGetValueLanguage(forKey: "agreement_start_date")
        tfEndDate.placeholder = doGetValueLanguage(forKey: "agreement_end_date")
        lbSelectPoliceVerification.text = doGetValueLanguage(forKey: "attach_police_verification_document")
        bRegister.setTitle(doGetValueLanguage(forKey: "register"), for: .normal)
        lbAddMember.text = doGetValueLanguage(forKey: "add_family_member")
        tfrelation.placeholder = doGetValueLanguage(forKey: "enter_relation_here")
        
        
        if isAddMoreSociety {
            
            lbTitle.text = doGetValueLanguageForAddMore(forKey: "registration_title")
            lbOnwerDetails.text = doGetValueLanguageForAddMore(forKey: "owner_details")
            tfOwnerName.placeholder = "\(doGetValueLanguageForAddMore(forKey: "first_name"))*"
            tfOwnerLastName.placeholder = "\(doGetValueLanguageForAddMore(forKey: "last_name"))*"
            tfOwnerMobile.placeholder = "\(doGetValueLanguageForAddMore(forKey: "mobile_number"))*"
            
            lbMale.text = doGetValueLanguageForAddMore(forKey: "male")
            lbFemale.text = doGetValueLanguageForAddMore(forKey: "female")
        
            tfFirstName.placeholder = "\(doGetValueLanguageForAddMore(forKey: "first_name"))*"
            tfLastName.placeholder = "\(doGetValueLanguageForAddMore(forKey: "last_name"))*"
            tfHouseNo.placeholder = doGetValueLanguageForAddMore(forKey: "unit_no")
            tfEmail.placeholder = doGetValueLanguageForAddMore(forKey: "email_id")
            tfMobile.placeholder = "\(doGetValueLanguageForAddMore(forKey: "mobile_number"))*"
            tfPermanentAddress.placeholder = "\(doGetValueLanguageForAddMore(forKey: "permanent_address"))*"
          
            lbSelectRentAgreement.text = doGetValueLanguageForAddMore(forKey: "attach_rent_agreement")
            tfStartDate.placeholder = doGetValueLanguageForAddMore(forKey: "agreement_start_date")
            tfEndDate.placeholder = doGetValueLanguageForAddMore(forKey: "agreement_end_date")
            lbSelectPoliceVerification.text = doGetValueLanguageForAddMore(forKey: "attach_police_verification_document")
            bRegister.setTitle(doGetValueLanguageForAddMore(forKey: "register"), for: .normal)
            lbAddMember.text = doGetValueLanguageForAddMore(forKey: "add_family_member")
            tfrelation.placeholder = doGetValueLanguageForAddMore(forKey: "enter_relation_here")
        }
        
    }
}
extension String {
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9\\s].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }

    var isCorrectDecimal : Bool{
        let regex = "^[0-9]+(\\.\\d{1,2})?$"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
}
extension  OwnedDataSelectVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,OnClickDeleteImage {
    func onClickDeleteImage(index: Int, type: String) {
        
        if type == "agrement" {
            fileAgreement.remove(at: index)
            
            if agreementImage.count > 0 {
                agreementImage.remove(at: index)
            }
            
            cvAgreement.reloadData()
            
            //            if  fileAgreement.count == 0 {
            //                heightOfTenentAgreement.constant = 0
            //            }
            
        } else {
            filePolice.remove(at: index)
            cvVerification.reloadData()
            
            //            if  filePolice.count == 0 {
            //                heightOfTenentVerification.constant = 0
            //            }
            
        }
        //  viewWillLayoutSubviews()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvAgreement {
            
            return fileAgreement.count
        } else {
            
            return filePolice.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentNameCell
        
        cell.index = indexPath.row
        cell.onClickDeleteImage = self
        
        if collectionView == cvAgreement {
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
        
        //if
        
        return CGSize(width: 120, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
}
extension OwnedDataSelectVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate , OpalImagePickerControllerDelegate{
    
    
    
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
        print("didFinishPickingImages")
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
        //                heightOfTenentAgreement.constant = 60
        //              //  heightofViewVerification.constant = 305
        //            }
        //
        //        } else {
        //
        //            self.policeVerificationImage.append(contentsOf: images)
        //
        //            DispatchQueue.main.async {
        //                self.cvVerification.reloadData()
        //            }
        //            if policeVerificationImage.count > 0 {
        //                heightOfTenentVerification.constant = 60
        //                heightofViewVerification.constant = 315
        //            }
        //
        //        }
        

        //      self.dismiss(animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
        ///  self.tfTenantAgreement.text = "\(myURL)"
        //  tfTenantAgreement.errorMessage = ""
        
        let fileType = myURL.pathExtension.lowercased()
        if fileType == "pdf" ||  fileType == "png" || fileType == "jpg" || fileType == "jpeg" || fileType == "doc" || fileType == "docx" {
            self.fileUrl = myURL
            
            
            if  selectType == "agrement" {
                isSelectDoc = true
                self.agreementImage.removeAll()
                self.fileAgreement.removeAll()
                self.fileAgreement.append(myURL)
                heightOfTenentAgreement.constant = 35
                //   heightofViewVerification.constant = 275
                DispatchQueue.main.async {
                    self.cvAgreement.reloadData()
                    self.viewWillLayoutSubviews()
                }
            } else {
                heightOfTenentVerification.constant = 35
                //  heightofViewVerification.constant = 295
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
    @objc func onClickDeletePost(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbldata)
        let indexPathSelected = self.tbldata.indexPathForRow(at:buttonPosition)
        if ArrObj.count > 0
        {
            ArrObj.removeObject(at: indexPathSelected!.row)
            ArrFname.remove(at: indexPathSelected!.row)
            ArrLname.remove(at: indexPathSelected!.row)
            ArrMobile.remove(at: indexPathSelected!.row)
            ArrRelation.remove(at: indexPathSelected!.row)
            ArrCountyCode.remove(at: indexPathSelected!.row)
            HeightTblvwConst.constant = CGFloat(73 * ArrObj.count)
            tbldata.reloadData()
            
        }else
        {
            HeightTblvwConst.constant = 0
        }
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
            self.ivImage.image = selectedImage
        }else {
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                
                let imgName = UUID().uuidString + ".jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)

                let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
                data.write(toFile: localPath, atomically: true)
                let imageURL = URL.init(fileURLWithPath: localPath)
                self.fileUrl = imageURL
                
                
                if  selectType == "agrement" {

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
                    
                    
                } else {
                    
                    heightOfTenentVerification.constant = 35
                    //  heightofViewVerification.constant = 295
                    self.filePolice.append(imageURL)
                    
                    DispatchQueue.main.async {
                        self.cvVerification.reloadData()
                    }
                    
                }
                
                
                
            }else{
                let imageURL = info[.imageURL] as! URL
                self.fileUrl = imageURL
                
                if  selectType == "agrement" {
                    self.fileAgreement.append(imageURL)
                    heightOfTenentAgreement.constant = 30
                    // heightofViewVerification.constant = 275
                    DispatchQueue.main.async {
                        self.cvAgreement.reloadData()
                        
                    }
                } else {
                    heightOfTenentVerification.constant = 30
                    //  heightofViewVerification.constant = 285
                    self.filePolice.append(imageURL)
                    DispatchQueue.main.async {
                        self.cvVerification.reloadData()
                    }
                    
                }
                
            }
        }
    }
}

extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}
extension OwnedDataSelectVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        if tag == 0 {
            lblCountryCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
            self.countryName = country.name!
            self.countryCode = country.countryCode
            self.phoneCode = country.phoneExtension
            newcountrycode = "+\(country.phoneExtension)"
        }else {
            lbOnwerCountryCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
            owner_country_code = "+\(country.phoneExtension)"
        }
           
       }
    
}
extension OwnedDataSelectVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrObj.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellAddMember
        let relation = ArrRelation[indexPath.row] 
        let Strname = ArrObj[indexPath.row] as? String ?? ""
        if ArrObj.count > 0
        {
            cell.fname.text =  String(Strname.split(separator: " ")[0]) + " " + String(Strname.split(separator: " ")[1])
            //cell.lname.text =  String(Strname.split(separator: " ")[1])
            cell.lname.text = relation
            cell.lblCharacter.text = Strname.first?.description ?? ""
            cell.btnDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}
class cellAddMember :UITableViewCell
{
    @IBOutlet weak var fname:UILabel!
    @IBOutlet weak var lname:UILabel!
    @IBOutlet weak var lblCharacter:UILabel!
    @IBOutlet weak var btnDelete : UIButton!
}
