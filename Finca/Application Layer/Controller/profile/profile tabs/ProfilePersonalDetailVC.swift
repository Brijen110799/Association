//
//  ProfilePersonalDetailVC.swift
//  Finca
//
//  Created by harsh panchal on 09/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EzPopup


struct ResponseFamilyMember:Codable {
    
    let  status:String!//" : "200",
    let  message:String!//" : "update familiy successfull",
    let member:[ModelFamilyMember]!
}
struct ModelFamilyMember:Codable {
    let  member_relation_name:String!//" : "Dad",
    let  user_id:String!//" : "840",
    let  user_first_name:String!//" : "Gg",
    let  user_last_name:String!//" : "Gg",
    let  member_status:String!//" : "1",
    let  user_mobile:String!//" : "0",
    let  user_status:String!//" : "2",
    let  member_date_of_birth:String!//" : "2000-01-01",
    let  member_age:String!//" : "19"
    
}

struct ResponseEmergancyMember:Codable {
    
    let  status:String!//" : "200",Ofaci
    let  message:String!//" : "update familiy successfull",
    let emergency:[ModelEmergancyMember]!
}

struct ModelEmergancyMember:Codable {
    let relation:String!//" : "Dad",
    let relation_id:String!//" : null,
    let emergencyContact_id:String!//" : "76",
    let person_mobile:String!//" : "2580258022",
    let person_name:String!//" : "Hhh"
}


class ProfilePersonalDetailVC: BaseVC {
    
    
    @IBOutlet weak var switchVisitorApproved: UISwitch!
    @IBOutlet weak var switchProfile: UISwitch!
    @IBOutlet weak var tfName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    
    @IBOutlet weak var tfAlaranateMobile: ACFloatingTextfield!
    @IBOutlet weak var tfDOB: ACFloatingTextfield!
    
    @IBOutlet weak var ivCheckFacebook: UIImageView!
    @IBOutlet weak var ivCheckInsta: UIImageView!
    @IBOutlet weak var ivCheckLinkdin: UIImageView!
    
    @IBOutlet weak var ivFacebook: UIImageView!
    @IBOutlet weak var ivInsta: UIImageView!
    @IBOutlet weak var ivLinkdin: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var bFacebook: UIButton!
    @IBOutlet weak var bInsta: UIButton!
    @IBOutlet weak var bLinkdin: UIButton!
    @IBOutlet weak var heightConSave: NSLayoutConstraint!
    @IBOutlet weak var ivPencil: UIImageView!
    var mainvew = ProfileVC()
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewVisitorApproved: UIView!
    @IBOutlet weak var heightVisitorApproval: NSLayoutConstraint!
    @IBOutlet weak var cvFamilyMember: UICollectionView!
    @IBOutlet weak var heightConFamilyMember: NSLayoutConstraint!
    
    @IBOutlet weak var cvEmergancyContact: UICollectionView!
    @IBOutlet weak var heightConEmergancyContact: NSLayoutConstraint!
    
    var isAddFamilyMember = false
    var isAddEmergancyMember = false
    let itemFamilyMember = "FamilyMemberProfileCell"
    let itemEmergancyMember = "EmergencyNumberProfileCell"
    var memberFamilyList = [ModelFamilyMember]()
    var emergancyMemberList = [ModelEmergancyMember]()
    var hieghtMainView  = 700
    var isFirstTime = false
    var facebook = ""
    var instagram = ""
    var linkedin = ""
    let datePicker = UIDatePicker()
    var context : ProfileVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.text = doGetLocalDataUser().userFirstName
        tfLastName.text = doGetLocalDataUser().userLastName
        tfMobile.text = doGetLocalDataUser().userMobile
        tfEmail.text = doGetLocalDataUser().userEmail
        tfName.delegate = self
        tfLastName.delegate = self
        tfEmail.delegate = self
        tfMobile.delegate = self
        tfAlaranateMobile.delegate = self
        
        scrollView.isScrollEnabled  = false
        

        if doGetLocalDataUser().altMobile != nil {
            tfAlaranateMobile.text = doGetLocalDataUser().altMobile
        }
        if doGetLocalDataUser().memberDateOfBirth != nil {
            tfDOB.text = doGetLocalDataUser().memberDateOfBirth
        }
       
        if doGetLocalDataUser().facebook != nil  && doGetLocalDataUser().facebook != ""{
            ivCheckFacebook.setImageColor(color: ColorConstant.green400)
            facebook = doGetLocalDataUser().facebook
        } else {
            ivCheckFacebook.setImageColor(color: ColorConstant.grey_40)
            facebook = ""
            ivFacebook.alpha = 0.4
        }
        
        if doGetLocalDataUser().instagram != nil && doGetLocalDataUser().instagram != "" {
            ivCheckInsta.setImageColor(color: ColorConstant.green400)
            instagram = doGetLocalDataUser().instagram
        }else {
            ivCheckInsta.setImageColor(color: ColorConstant.grey_40)
            instagram = ""
            ivInsta.alpha = 0.4
        }
        
        if doGetLocalDataUser().linkedin != nil && doGetLocalDataUser().linkedin != "" {
            ivCheckLinkdin.setImageColor(color: ColorConstant.green400)
            linkedin = doGetLocalDataUser().linkedin
        }else {
            ivCheckLinkdin.setImageColor(color: ColorConstant.grey_40)
            linkedin = ""
            ivLinkdin.alpha = 0.4
        }
       
        doDisbleUI()
        ivPencil.setImageColor(color: .white)
        
        doneButtonOnKeyboard(textField: tfMobile)
        
        let nibFamilyMember = UINib(nibName: itemFamilyMember, bundle: nil)
        cvFamilyMember.register(nibFamilyMember, forCellWithReuseIdentifier: itemFamilyMember)
        cvFamilyMember.dataSource = self
        cvFamilyMember.delegate = self
        
        
        let nibEmergancyMember = UINib(nibName: itemEmergancyMember, bundle: nil)
        cvEmergancyContact.register(nibEmergancyMember, forCellWithReuseIdentifier: itemEmergancyMember)
        cvEmergancyContact.dataSource = self
        cvEmergancyContact.delegate = self
        
        
        
        cvFamilyMember.isScrollEnabled = false
        cvEmergancyContact.isScrollEnabled = false
        
        //  view.frame.height = view.frame.height + 200
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        doGetFamilyMember()
        doGetEmergancyMember()
        showDatePicker()
        // doDisbleUI()
        // switchProfile.thumbTintColor
        addInputAccessoryForTextFields(textFields: [tfName,tfLastName,tfEmail,tfAlaranateMobile], dismissable: true, previousNextable: true)
        // tfMobile.isEnabled = false
        
    }
    
    @objc func visitorSwitchChanged(_ sender:UISwitch!){
        
        if sender.isOn{
            doCallVisitorApproval(status : "0")
        }else{
            doCallVisitorApproval(status : "1")
        }
    }
    
    func doCallVisitorApproval(status : String!){
        self.showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let  params = ["key":apiKey(),
                       "changePrivacyVisitor":"changePrivacyVisitor",
                       "society_id":doGetLocalDataUser().societyID!,
                       "visitor_approved":status!,
                       "user_id":doGetLocalDataUser().userID!,
                       "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.aboutController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.toast(message: "Status changed Successfully", type: .Success)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == tfName {
            let maxLength = 30
            
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == tfLastName {
            let maxLength = 30
            
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        if textField == tfMobile {
            let maxLength = 10
            
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == tfAlaranateMobile {
            let maxLength = 10
            
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
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
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        tfDOB.inputAccessoryView = toolbar
        tfDOB.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        tfDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        
    }
    
    func resetCon() {
        //  print("resetCon")
        
        if isFirstTime {
            
            hieghtMainView = 650
            
            
            
            if memberFamilyList.count > 0 {
                let height = 50 * memberFamilyList.count
                self.heightConFamilyMember.constant = CGFloat(height)
                self.hieghtMainView =   self.hieghtMainView + height
            }
            
            if emergancyMemberList.count > 0 {
                let height = 65 * emergancyMemberList.count
                self.heightConEmergancyContact.constant = CGFloat(height)
                self.hieghtMainView =   self.hieghtMainView + height
            }
            
            
           // mainvew.heightConContentview.constant = CGFloat(hieghtMainView)
        //  mainvew.doSetHeightContentView(constant: viewMain.frame.height)
                 
            doSetHieght()
           
        }
    }
    
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onEditProfile(_ sender: Any) {
        doEnsbleUI()
    }
    
    @objc func switchChangedProfile(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        print(value)
        
        if value {
            // switchProfile.thumbTintColor  = ColorConstant.green400
            //  switchProfile.tintColor = ColorConstant.green400
            doSwitchToProfile(public_mobile: "0")
        } else {
            //  switchProfile.thumbTintColor  = ColorConstant.red500
            //  switchProfile.tintColor = ColorConstant.red500
            doSwitchToProfile(public_mobile: "1")
        }
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
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        tfName = (textField as! ACFloatingTextfield)
    }
    
    private func textFieldDidEndEditing(textField: UITextField) {
        tfName = nil
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc  func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        
        
        //  self.scrollView.isScrollEnabled = true
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        //viewHieght.constant = contentInsets.bottom
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
        
    }
    
    func doSwitchToProfile(public_mobile:String) {
        self.showProgress()
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        let  params = ["key":apiKey(),
                       "changePrivacy":"changePrivacy",
                       "society_id":doGetLocalDataUser().societyID!,
                       "public_mobile":public_mobile,
                       "user_id":doGetLocalDataUser().userID!,
                       "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.aboutController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func hideProfileView() {
        
        //        conHeightForProfile.constant = 60.0
        tfName.isHidden = true
        tfEmail.isHidden = true
        tfMobile.isHidden = true
        tfLastName.isHidden = true
        //        viewEditProfile.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews ppd")
       // resetCon()
        doSetHieght()
        if isAddFamilyMember {
            isAddFamilyMember = false
            doGetFamilyMember()
        }
        
        if isAddEmergancyMember {
            isAddEmergancyMember = false
            doGetEmergancyMember()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showProfileView() {
        
        //        conHeightForProfile.constant = 240.0
        tfName.isHidden = false
        tfEmail.isHidden = false
        tfMobile.isHidden = false
        tfLastName.isHidden = false
        //        viewEditProfile.isHidden = false
        
    }
    
    @IBAction func btnFamilyMembersTapped(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isUpdate  = false
        vc.user_id = "0"
        vc.profilePersonalDetailVC = self
        vc.context = self.context
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        if isValidatData() {
            doSubmitPersonalDetials()
             
        }
    }
    
    func isValidatData() -> Bool {
        var isValid = true
        
        if tfName.text == "" {
            tfName.showErrorWithText(errorText: "Enter your first name")
            isValid = false
        }
        if tfLastName.text == "" {
            tfLastName.showErrorWithText(errorText: "Enter your last name")
            isValid = false
        }
        
        
        if !isValidEmail(email:tfEmail.text! ) {
            tfEmail.showErrorWithText(errorText: "Enter valid email address")
            isValid = false
        }
        
        if tfAlaranateMobile.text != "" {
            if tfAlaranateMobile.text!.count  < 10 {
                tfAlaranateMobile.showErrorWithText(errorText: "Enter 10 digit alternate mobile number")
                isValid = false
            }
        }
        
        
        return isValid
    }
    
    func doSubmitPersonalDetials() {
        showProgress()
        let full_name = tfName.text! + " " + tfLastName.text!
        let params = ["key":apiKey(),
                      "setProsnalDetails":"setProsnalDetails",
                      "user_full_name":  full_name,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":tfName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_email":tfEmail.text!,
                      "alt_mobile":tfAlaranateMobile.text!,
                      "member_date_of_birth":tfDOB.text!,
                      "facebook":facebook,
                      "instagram":instagram,
                      "linkedin":linkedin]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.hieghtMainView =   self.hieghtMainView - 60
                      //  self.mainvew.heightConContentview.constant = CGFloat(self.hieghtMainView)
                    //    self.mainvew.doSetHeightContentView(constant: self.viewMain.frame.height)
                      
                        self.doDisbleUI()
                        self.doGetProfile()
                         self.showAlertMessage(title: "", msg: response.message)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func onClickEmergancy(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idEmergancyContactVC") as! EmergancyContactVC
        vc.profilePersonalDetailVC = self
        vc.context = self.context
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        
    }
    
    func doDisbleUI() {
        tfName.textColor = UIColor(named: "grey_60")
        tfLastName.textColor = UIColor(named: "grey_60")
        tfMobile.textColor = UIColor(named: "grey_60")
        tfEmail.textColor = UIColor(named: "grey_60")
        btnSave.isEnabled = false
        tfName.isEnabled = false
        tfLastName.isEnabled = false
        tfEmail.isEnabled = false
        //   tfMobile.isEnabled = false
        btnSave.isHidden = true
        heightConSave.constant = 0
        tfAlaranateMobile.isEnabled = false
        tfMobile.isEnabled = false
        tfDOB.isEnabled = false
        bFacebook.isEnabled = false
        bInsta.isEnabled = false
        bLinkdin.isEnabled = false
        
        
    }
    
    func doEnsbleUI() {
        btnSave.isEnabled = true
        tfName.textColor = UIColor.black
        tfLastName.textColor = UIColor.black
        tfMobile.textColor = UIColor.black
        tfEmail.textColor = UIColor.black
        tfName.isEnabled = true
        tfLastName.isEnabled = true
        tfEmail.isEnabled = true
        btnSave.isHidden = false
        tfAlaranateMobile.isEnabled = true
        tfDOB.isEnabled = true
        heightConSave.constant = 40.0
        ivFacebook.alpha = 1.0
        ivInsta.alpha = 1.0
        ivLinkdin.alpha = 1.0
        // tfMobile.isEnabled = true
        
        bFacebook.isEnabled = true
        bInsta.isEnabled = true
        bLinkdin.isEnabled = true
        _ = tfName.becomeFirstResponder()
        
        //   self.hieghtMainView =   self.hieghtMainView + 100
       // mainvew.heightConContentview.constant = CGFloat(hieghtMainView)
         // mainvew.doSetHeightContentView(constant: viewMain.frame.height)
         doSetHieght()
    }
    
    
    
    func doGetFamilyMember() {
        
        if memberFamilyList.count > 0 {
            memberFamilyList.removeAll()
        }
        showProgress()
        let params = ["key":apiKey(),
                      "getFamilymember":"getFamilymember",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "member_status":doGetLocalDataUser().memberStatus!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseFamilyMember.self, from:json!)
                    
                    self.isFirstTime = true
                    if response.status == "200" {
                        
                        let height = 50 * response.member.count
                        
                        self.heightConFamilyMember.constant = CGFloat(height)
                        
                        self.hieghtMainView =   self.hieghtMainView + height
                     //   self.mainvew.heightConContentview.constant = CGFloat(self.hieghtMainView)
                     //   self.mainvew.doSetHeightContentView(constant: self.viewMain.frame.height)
                      //  self.doSetHieght(string: "FamilyMember")
                        print("mainvew h " , self.hieghtMainView)
                        print("height  " , height)
                        self.doSetHieght()
                        self.memberFamilyList.append(contentsOf: response.member)
                        self.cvFamilyMember.reloadData()
                     }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                        self.cvFamilyMember.reloadData()
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doGetEmergancyMember() {
        if emergancyMemberList.count > 0 {
            emergancyMemberList.removeAll()
        }
        // showProgress()
        let params = ["key":apiKey(),
                      "getEmergencyContact":"getEmergencyContact",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            //  self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseEmergancyMember.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        let height = 65 * response.emergency.count
                        
                        self.heightConEmergancyContact.constant = CGFloat(height)
                        
                        self.hieghtMainView =   self.hieghtMainView + height
                      //  self.mainvew.heightConContentview.constant = CGFloat(self.hieghtMainView)
                       // self.mainvew.doSetHeightContentView(constant: self.viewMain.frame.height)
                        
                        print("mainvew h " , self.hieghtMainView)
                        print("height  " , height)
                        self.emergancyMemberList.append(contentsOf: response.emergency)
                        self.cvEmergancyContact.reloadData()
                        
                        self.doSetHieght()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                        self.cvEmergancyContact.reloadData()
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @objc  func onClickDeleteEmergancyConatct(sender:UIButton) {
        let index = sender.tag
        
        print("dsds",index)
        doDeleteEmergancyMember(index: index)
    }
    
    func  doDeleteEmergancyMember(index:Int) {
        
        showProgress()
        let params = ["key":apiKey(),
                      "deleteEmergencyContact":"deleteEmergencyContact",
                      "emergencyContact_id":emergancyMemberList[index].emergencyContact_id!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                      //  self.resetCon()
                        self.doGetEmergancyMember()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                        //self.cvEmergancyContact.reloadData()
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @objc  func onClickEditEmergancyMember(sender:UIButton) {
        let index = sender.tag
        print("jdjdj",index)
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.user_id = memberFamilyList[index].user_id
        vc.isUpdate = true
        vc.modelFamilyMember = memberFamilyList[index]
        vc.profilePersonalDetailVC = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
//        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        self.addChild(vc)
//        self.view.addSubview(vc.view)
    }
    
    @IBAction func onClickFacebook(_ sender: Any) {
        //
        
       
        
    }
    
    @IBAction func onClickInsta(_ sender: Any) {
        //
        
      
        
    }
    
    @IBAction func onClickLinkdin(_ sender: Any) {
        //
        
         
    }
    
    func doGetProfile() {
        showProgress()
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    if response.status == "200" {
                        
                        if let encoded = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        self.mainvew.lbUserName.text = response.userFullName
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    func doSetHieght() {
        
        //print("doSetHieght" ,  string)
        DispatchQueue.main.async {
            self.mainvew.heightConContentview.constant = self.viewMain.frame.height
            
        }
      }
    
    
}

extension ProfilePersonalDetailVC : IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Personal Details"
        //  Details
    }
    
}

extension  ProfilePersonalDetailVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == cvEmergancyContact {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemEmergancyMember, for: indexPath) as! EmergencyNumberProfileCell
            cell.lbName.text = emergancyMemberList[indexPath.row].person_name + " (" +  emergancyMemberList[indexPath.row].relation + ")"
            cell.lbNumber.text = emergancyMemberList[indexPath.row].person_mobile
            cell.bDelete.tag = indexPath.row
            cell.bDelete.addTarget(self, action: #selector(onClickDeleteEmergancyConatct(sender:)), for: .touchUpInside)
            return  cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemFamilyMember, for: indexPath) as! FamilyMemberProfileCell
//        let name  = memberFamilyList[indexPath.row].user_first_name + " " +  memberFamilyList[indexPath.row].user_last_name + " (" + memberFamilyList[indexPath.row].member_relation_name + ")"
        let name  = "\(memberFamilyList[indexPath.row].user_last_name ?? "") \(memberFamilyList[indexPath.row].user_last_name ?? "") \(memberFamilyList[indexPath.row].member_relation_name ?? "")"
        cell.lbName.text = name
        cell.lbAge.text = "Age: " + memberFamilyList[indexPath.row].member_age
       // cell.lbReltion.text =
        cell.bEdit.tag = indexPath.row
        cell.bEdit.addTarget(self, action: #selector(onClickEditEmergancyMember(sender:)), for: .touchUpInside)
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvFamilyMember {
            return memberFamilyList.count
        } else {
            return emergancyMemberList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvEmergancyContact {
            let yourWidth = collectionView.bounds.width
            return CGSize(width: yourWidth - 5, height: 60)
        }
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
}
