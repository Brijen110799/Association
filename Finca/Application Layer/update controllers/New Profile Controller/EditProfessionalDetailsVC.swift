//
//  EditProfessionalDetailsVC.swift
//  Fincasys
//
//  Created by silverwing_macmini3 on 11/25/1398 AP.
//  Copyright © 1398 silverwing_macmini3. All rights reserved.
//

import UIKit
import EzPopup
import MobileCoreServices

class EditProfessionalDetailsVC: BaseVC , UITextViewDelegate {
    @IBOutlet weak var scollvw:UIScrollView!

    @IBOutlet weak var viewComapnyLogo: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var viewLogoMainView: UIView!
    @IBOutlet weak var ImgvwLogoShow: UIImageView!

    @IBOutlet weak var viewIndustry: UIView!
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var lblIndustry: UILabel!

   
    @IBOutlet weak var viewCustomCategoryName: UIView!
   
    @IBOutlet weak var tfCustomCategoryName: UITextField!
 
    @IBOutlet weak var viewDesignation: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var companyWebsite: UIView!
    @IBOutlet weak var viewEmailAddress: UIView!
    @IBOutlet weak var viewKeyword: UIView!
    @IBOutlet weak var viewCompanyInfo: UIView!

    @IBOutlet weak var tfCompanyName: UITextField!
    @IBOutlet weak var tfDesignation: UITextField!
    @IBOutlet weak var tfAddress: UITextView!
    @IBOutlet weak var tfContact: UITextField!
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCompanyWebsite: UITextField!
    @IBOutlet weak var tfKeywords: UITextField!
    var responseProfessional : ResponseProfessional?
    @IBOutlet weak var cvKeywords: UICollectionView!
    @IBOutlet weak var conHeightKeyword: NSLayoutConstraint!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var lblProfessionalInfoTitle: UILabel!
    @IBOutlet weak var lblIndustryTItle: UILabel!
   
    @IBOutlet weak var lblProfessionalCetagoryTitle: UILabel!
   
    @IBOutlet weak var lblCompanyLogo: UILabel!
    @IBOutlet weak var btnSelectLogo: UIButton!
    @IBOutlet weak var lblCompanyInfoTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    
    @IBOutlet weak var lblDesignationTitle: UILabel!
    @IBOutlet weak var lblEmailAddTitle: UILabel!
    @IBOutlet weak var lblCompanyWebsiteTitle: UILabel!
    @IBOutlet weak var lblCopnayAddressTitle: UILabel!
    @IBOutlet weak var lblCompnayConatactTitle: UILabel!
    @IBOutlet weak var lblKeyWordsTitle: UILabel!
    @IBOutlet weak var lblDescribeTitle: UILabel!
    
    @IBOutlet weak var viewMapImage: UIView!
    @IBOutlet weak var lbLatlong: UILabel!
    @IBOutlet weak var ivMap: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbKeywordNote: UILabel!
   
    @IBOutlet weak var lbSelectBroucher: UILabel!
    @IBOutlet weak var lbBroucher: UILabel!
    
    var context : UserProfessionalDetailsVC!
    var userProfileReponse : MemberDetailResponse!
    var business_categories:String!
    var broucherPath : URL?
    let employmentTypeList = [CommonCheckModel(title: "Unemployed", id: ""),
                              CommonCheckModel(title: "Government Official", id: ""),
                              CommonCheckModel(title: "Homemaker", id: ""),
                              CommonCheckModel(title: "Entrepreneur", id: ""),
                              CommonCheckModel(title: "Partner/Director", id: ""),
                              CommonCheckModel(title: "Employee", id: ""),
                              CommonCheckModel(title: "Retired Government Official", id: ""),
                              CommonCheckModel(title: "Freelance", id: ""),
                              CommonCheckModel(title: "Student", id: ""),
                              CommonCheckModel(title: "Others", id: "")]
    var professionCategoryList = [ProfessionCategory]()
    var professionTypeList = [ProfessionType]()
    
    var listKeyWord = [String]()
    let cellItem = "SearchKeywordCell"
    private var lat = ""
    private var long = ""
    var imgUrl:String?
    var locAddress:String?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScreenTitle.text = doGetValueLanguage(forKey: "update_details")
       // lblEmploymentTypeTitle.text = doGetValueLanguage(forKey: "employment_type")
        lblProfessionalInfoTitle.text = doGetValueLanguage(forKey: "professional_info")
       // lblEmploymentType.text = doGetValueLanguage(forKey: "select_employment_type")
        lblIndustryTItle.text = doGetValueLanguage(forKey: "business_type")
        lblProfessionalCetagoryTitle.text = doGetValueLanguage(forKey: "business_type")
        tfCustomCategoryName.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblCompanyLogo.text = doGetValueLanguage(forKey: "company_logo")
        btnSelectLogo.setTitle(doGetValueLanguage(forKey: "select_logo"), for: .normal)
        doGetCategory()
        lblCompanyInfoTitle.text = doGetValueLanguage(forKey: "company_info")
        lblCompanyNameTitle.text = "\(doGetValueLanguage(forKey: "company_name_profe_detail"))*"
        tfCompanyName.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblDesignationTitle.text = "\(doGetValueLanguage(forKey: "designation_profe_detail"))*"
        tfDesignation.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblEmailAddTitle.text = doGetValueLanguage(forKey: "email_address")
        tfEmail.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblCompanyWebsiteTitle.text = doGetValueLanguage(forKey: "company_website")
        tfCompanyWebsite.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblCopnayAddressTitle.text = "\(doGetValueLanguage(forKey: "addresses"))*"
        tfAddress.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfAddress.placeholderColor = .gray
        lblCompnayConatactTitle.text = "\(doGetValueLanguage(forKey: "contact_number"))*"
        tfContact.placeholder(doGetValueLanguage(forKey: "enter_here"))
        lblKeyWordsTitle.text = doGetValueLanguage(forKey: "keywords")
        lbKeywordNote.text =  "\(doGetValueLanguage(forKey: "use_commas_to_generate_keyword")) \(doGetValueLanguage(forKey: "max_5_keywords"))"
        tfKeywords.placeholder(doGetValueLanguage(forKey: "use_commas_to_generate_keyword"))
        lblDescribeTitle.text = doGetValueLanguage(forKey: "describe")
        tfDescription.placeholder = doGetValueLanguage(forKey: "type_here")
        tfDescription.placeholderColor = .gray
        btnSave.setTitle(doGetValueLanguage(forKey: "save").uppercased(), for: .normal)
        Utils.setImageFromUrl(imageView: ImgvwLogoShow, urlString: responseProfessional?.company_logo ?? "",palceHolder: "banner_placeholder")
        lbLocation.text = doGetValueLanguage(forKey: "select_location_marker")
        lbSelectBroucher.text = doGetValueLanguage(forKey: "select_brochure")
        ImgvwLogoShow.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        
        viewLogo.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        tfAddress.delegate = self
        tfDescription.delegate = self
        tfContact.keyboardType = .numberPad
        if responseProfessional != nil {

            self.tfCompanyName.text = self.responseProfessional?.company_name
            self.tfDesignation.text = self.responseProfessional?.designation
            self.tfAddress.text = self.responseProfessional?.company_address
            self.tfContact.text = self.responseProfessional?.company_contact_number
            self.tfDescription.text = self.responseProfessional?.employment_description
            
            self.tfCompanyWebsite.text = self.responseProfessional?.company_website
            self.tfEmail.text = self.responseProfessional?.user_email
            
            self.lat = responseProfessional?.plot_lattitude ?? ""
            self.long = responseProfessional?.plot_longitude ?? ""
            if responseProfessional?.company_brochure ?? "" != "" {
                let fileArray = responseProfessional?.company_brochure.components(separatedBy: "/")
                self.lbBroucher.text = fileArray?.last
            }else {
                self.lbBroucher.text = doGetValueLanguage(forKey: "no_brochure_available")
            }
        
            if self.responseProfessional?.search_keyword != nil && self.responseProfessional?.search_keyword != "" {
                listKeyWord = (self.responseProfessional?.search_keyword.components(separatedBy: ","))!
                conHeightKeyword.constant = 40
                cvKeywords.reloadData()
                cvKeywords.isHidden = false
            }
         //   self.lblEmploymentType.text = self.responseProfessional?.employment_type
            
            if responseProfessional?.employment_type == "Unemployed" || responseProfessional?.employment_type == "Student" || responseProfessional?.employment_type == "Others" || responseProfessional?.employment_type == "Homemaker"{
                self.viewCompanyInfo.isHidden = true
                self.viewIndustry.isHidden = true
           //     self.viewProfessionType.isHidden = true
                //self.viewKeyword.isHidden = true
              //  self.viewCustomCategoryName.isHidden = true
               // self.viewManualProfessionType.isHidden = true
                viewComapnyLogo.isHidden=true

                 }else{
              //  .........commented.........
            //    self.viewManualProfessionType.isHidden = true
            //    self.viewProfessionType.isHidden = true
              //.........................................................
                
                viewComapnyLogo.isHidden=false
               // self.doHideGivenView(given: [seperator1,seperator2], flag: false)
                self.viewCompanyInfo.isHidden = false
                self.viewIndustry.isHidden = false
               //self.viewProfessionType.isHidden = false
               // self.viewKeyword.isHidden = false
                self.lblIndustry.text = self.responseProfessional?.business_categories_sub
              //  self.lblProfessionType.text = self.responseProfessional?.business_categories_sub
                if ((responseProfessional?.business_categories_sub.lowercased().contains("other")) != nil){
                    self.viewCustomCategoryName.isHidden = false
                   // self.viewManualProfessionType.isHidden = false
                //    self.tfCustomProfessionType.text = responseProfessional?.professional_other
                    self.tfCustomCategoryName.text = responseProfessional?.professional_other
                    
                }else{
                   // self.viewCustomCategoryName.isHidden = true
                   // self.viewManualProfessionType.isHidden = true
                }
            }
            
        }
        
        if self.responseProfessional?.business_categories_sub == "Other"{
            
            self.viewCustomCategoryName.isHidden = false
            //  self.viewManualProfessionType.isHidden = false
        }else{
            self.viewCustomCategoryName.isHidden = true
            //self.viewManualProfessionType.isHidden = true
        }
        addKeyboardAccessory(textFields: [tfCustomCategoryName,tfCompanyName,tfDesignation,tfEmail,tfCompanyWebsite,tfContact,tfKeywords], dismissable: true, previousNextable: true)
        addKeyboardAccessory(textViews: [tfAddress])
        doneButtonOnKeyboard(textField: tfDescription)
        tfDescription.delegate = self
        
        tfKeywords.addTarget(self, action: #selector(onTextChange(_: )), for: .editingChanged )

        
        let nib = UINib(nibName: cellItem, bundle: nil)
        cvKeywords.register(nib, forCellWithReuseIdentifier: cellItem)
        cvKeywords.delegate = self
        cvKeywords.dataSource = self
    }
    @objc func onTextChange(_ sender : UITextField) {
        var string = sender.text!
        
        if string.count > 1 &&  string.hasSuffix(",") && listKeyWord.count < 5 {
            //_ = string?.dropLast()
            string.remove(at: (string.index(before: string.endIndex)))
            listKeyWord.append(string)
            cvKeywords.isHidden = false
            cvKeywords.reloadData()
            view.endEditing(true)
            sender.text = ""
            conHeightKeyword.constant = 40
            
            if listKeyWord.count == 5 {
                sender.isEnabled = false
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return  view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {

        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height

    }

    @objc func keyboardWillHide(notification: NSNotification) {

        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        print(self.view.frame.origin.y)
//        if !tfCompanyName.isEditing{
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
//        }else{
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y = 0
//            }
//        }
//    }
    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if textField == tfDescription{
    //            if self.view.frame.origin.y == 0 {
    //                self.view.frame.origin.y -= 170
    //            }
    //        }
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfAddress {
            let maxLength = 100
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func  doSubmitDataa(){
        showProgress()
        var keyWord = ""
        
        if listKeyWord.count > 0 {
            for item in listKeyWord {
                if keyWord == "" {
                    keyWord = item
                } else {
                    keyWord = keyWord + "," + item
                }
            }
        }
        let params = ["key":apiKey(),
                      "addAbout":"addAbout",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_phone":doGetLocalDataUser().userMobile!,
                      "user_email":tfEmail.text!,
                      "company_name":tfCompanyName.text!,
                      "employment_description":tfDescription.text!,
                      "designation":tfDesignation.text!,
                      "company_address":tfAddress.text!,
                      "company_contact_number":tfContact.text!,
                      "business_categories":lblIndustry.text!,
                      "business_categories_sub":lblIndustry.text!,
                      "business_categories_other":tfCustomCategoryName.text!,
                      "professional_other":tfCustomCategoryName.text!,
                      "company_website":tfCompanyWebsite.text!,
                      "search_keyword":keyWord]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName:ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                // self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200" {
                        self.navigationController?.popViewController(animated: true)
                        self.context.toast(message: "Professional Details Edited !!", type: .Success)
                        self.context.RefereshData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doSubmitData(){
        showProgress()
        var keyWord = ""
        
        if listKeyWord.count > 0 {
            for item in listKeyWord {
                if keyWord == "" {
                    keyWord = item
                } else {
                    keyWord = keyWord + "," + item
                }
            }
        }
        
        if ImgvwLogoShow.image == UIImage.init(named: "banner_placeholder") {
            ImgvwLogoShow.image = nil
         }
        let params = ["key":apiKey(),
                      "addAbout":"addAbout",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_phone":doGetLocalDataUser().userMobile!,
                      "user_email":tfEmail.text!,
                      
                      "company_name":tfCompanyName.text!,
                      "employment_description":tfDescription.text!,
                      "designation":tfDesignation.text!,
                      "company_address":tfAddress.text!,
                      "company_contact_number":tfContact.text!,
                      "business_categories":lblIndustry.text!,
                      "business_categories_sub":lblIndustry.text!,
                      "business_categories_other":tfCustomCategoryName.text!,
                      "professional_other":tfCustomCategoryName.text!,
                      "company_website":tfCompanyWebsite.text!,
                      "search_keyword":keyWord,
                      "plot_longitude":long,
                      "plot_lattitude":lat]
        print("param" , params)
       
        let request = AlamofireSingleTon.sharedInstance
       // serviceName: S, parameters: params, imageFile: ImgvwLogoShow.image, fileName: "company_logo", compression: 0.3
        request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params, fileURL: broucherPath, compression: 0.3, imageFile: ImgvwLogoShow.image, fileParam: "company_brochure", imageFileParam: "company_logo") { (Data, error) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from: Data!)
                    if response.status == "200"{
                        self.navigationController?.popViewController(animated: true)
                        self.context.toast(message: "Professional Details Edited !!", type: .Success)
                        self.context.RefereshData()
                        
                    }else{
                        self.toast(message: response.message, type: .Faliure)
                    }
                }catch{
                    print("error")
                }
            }else{
                print("Parse Error")
            }
        }
    }
    @IBAction func onClickSave(_ sender: Any) {
        if doValidateData() {
            doSubmitData()
        }
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func doValidateData() -> Bool {
        var isValid = true
        
        
       
            if lblIndustry.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_your_business_type"))
                isValid = false
            } else {
                if lblIndustry.text == "Other" {
                    if tfCustomCategoryName.text == "" {
                        showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "profession_category_name"))
                        isValid = false
                    }
                }
            }
            
            if tfCompanyName.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_company_name"))
                isValid = false
            }
            if tfDesignation.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_designation"))
                isValid = false
            }
            
            if tfEmail.text != "" {
                if !isValidEmail(email: tfEmail.text!) {
                    showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_email"))
                    isValid = false
                }
            }
        if tfCompanyWebsite.text != "" {
            if  !validateURL(url: tfCompanyWebsite.text ?? "") {
                // you can use checkedUrl here
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "Please_enter_valid_company_website"))
                isValid = false
            }
            
            func validateURL(url: String) -> Bool {
                //let regex = "((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let regex = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
                let test = NSPredicate(format:"SELF MATCHES %@", regex)
                let result = test.evaluate(with: url)
                return result
            }
            
        }

            //            if tfCompanyWebsite.text == "" {
            //                showAlertMessage(title: "", msg: "Enter Company Website")
            //                isValid = false
            //            }
            if tfAddress.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "Please_enter_valid_company_address"))
                isValid = false
            }
            if tfContact.text!.count < 8 {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_company_contact"))
                isValid = false
            }
        
        return isValid
    }
    func doGetCategory(){
        self.showProgress()
        let params = ["getCatgory": "getCatgory", "society_id": doGetLocalDataUser().societyID ?? ""]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.bussinessCategoryController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                    if response.status == "200"{
                        self.professionCategoryList.append(contentsOf: response.category)
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }

    func doHideGivenView(given views: [UIView], flag : Bool){
        for view in views{
            view.isHidden = flag
        }
    }
    
    func doInitProfessionTypeArr(tag:Int!,selectedIndexPath : IndexPath!,identifier:String! = ""){
        
        switch tag {
        case 0:
            for data in employmentTypeList{
                if data.title == identifier{
                    if data.title == "Unemployed" || data.title == "Student" || data.title == "Homemaker" || data.title == "Others"{
                        self.viewIndustry.isHidden = true
                        //self.viewProfessionType.isHidden = true
                        self.viewCustomCategoryName.isHidden = true
                      //  self.viewManualProfessionType.isHidden = true
                        self.viewCompanyInfo.isHidden = true
                      //  self.viewKeyword.isHidden = true
                        self.viewComapnyLogo.isHidden = true
                      //  doHideGivenView(given: [seperator1 , seperator2, seperator3,seperator4], flag: true)
                    }else{
                        self.viewComapnyLogo.isHidden = false
                        self.viewIndustry.isHidden = false
                        //self.viewProfessionType.isHidden = false
                        self.viewCompanyInfo.isHidden = false
                        //self.viewKeyword.isHidden = false
                       // doHideGivenView(given: [seperator1, seperator2], flag: false)
                    }
                  //  lblEmploymentType.text = data.title
                    lblIndustry.text = ""
                    //lblProfessionType.text = ""
                }
            }
            break;
        case 1:
            self.professionTypeList.removeAll()
           // self.lblProfessionType.text = ""
            for data in professionCategoryList{
                if data.categoryId == identifier{
                    ///self.professionTypeList.append(contentsOf: data.subCategory)
                    self.lblIndustry.text = data.categoryIndustry
                    if  data.categoryIndustry.lowercased().contains("other"){
                    //    self.viewManualProfessionType.isHidden = false
                        self.viewCustomCategoryName.isHidden = false
                      //  self.doHideGivenView(given: [seperator3, seperator4], flag: false)
                    } else {
                       // self.viewManualProfessionType.isHidden = true
                        self.viewCustomCategoryName.isHidden = true
                    }
                }
            }
            break;
        case 2:
            for (_,data) in professionTypeList.enumerated(){
                if data.categoryName == identifier{
                //    self.lblProfessionType.text = data.categoryName
                }
            }
        default:
            break;
        }
    }
    
    @IBAction func onClickEmployeementType(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 0
        vc.context = self
        vc.employmentTypeList = self.employmentTypeList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func onClickProfessionaCategory(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 1
        vc.context = self
        vc.professionCategoryList = self.professionCategoryList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func onClickProfessionType(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 2
        vc.context = self
        vc.professionTypeList = self.professionTypeList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func onClickSelectLogo(_ sender: Any) {
        
        openPhotoSelecter()
    }
    
    func openPhotoSelecter(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Chose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)

            }else{
                print("not")
            }

        }))
        actionSheet.addAction(UIAlertAction(title: "Choose From Gallery", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil )
    }
    @IBAction func tapLocation(_ sender: Any) {
//        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationMapVC") as! SelectLocationMapVC
//        vc.onTapMediaSelect = self
//         pushVC(vc: vc)
        let vc = SelectProfileLocationVC(nibName: "SelectProfileLocationVC", bundle: nil)
        vc.delegate = self
        pushVC(vc: vc)
    }
    
    @IBAction func tapAttachedment(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeText),String(kUTTypeRTF),String(kUTTypeSpreadsheet),String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypeJPEG),"com.microsoft.word.doc","public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true)
        
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == tfAddress {
//        let maxLength = 100
//        let currentString: NSString = (textField.text ?? "") as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//        }
//        return true
//    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var maxLength = 100
        if textView == tfDescription {
            maxLength = 200
        }
        if textView == tfAddress {
            maxLength = 100
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxLength    // 10 Limit Value
    }
    
}
extension EditProfessionalDetailsVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Image not found!")
            return
        }
        ImgvwLogoShow.image = selectedImage
    }
}
extension EditProfessionalDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listKeyWord.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! SearchKeywordCell
        cell.lbTitle.text = listKeyWord[indexPath.row]
        
        cell.bClose.tag = indexPath.row
        cell.bClose.addTarget(self, action: #selector(onClickClose(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = UILabel(frame: CGRect.zero)
        label.text = listKeyWord[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 40, height: 36)
        
        //return CGSize(width: 100 , height: 30)
    }
    @objc func onClickClose(sender : UIButton) {
        let index = sender.tag
        listKeyWord.remove(at: index)
        cvKeywords.reloadData()
        tfKeywords.isEnabled = true
        if listKeyWord.count == 0 {
            //            conHeightKeyword.constant = 40
            cvKeywords.isHidden = true
        }
    }
}
extension EditProfessionalDetailsVC : /*OnTapMediaSelect ,*/ UIDocumentPickerDelegate {
    /*func onSuccessMediaSelect(image: [UIImage], fileImage: [URL]) {

    }

    func onSucessUploadingFile(fileUrl: [String], msg: String) {

    }

    func selectDocument(fileArray: [URL], type: String, file_duration: String) {

    }

    func onTapOthers(type: String) {

    }
    
    func onLocationSuccess(location: String, address: String) {
        lat = String(location.split(separator: ",")[0])
        long = String(location.split(separator: ",")[1])

        lbLatlong.text = "\(lat)\n\(long)"
        viewMapImage.isHidden = false
        let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C"
            + location + "&key=" + StringConstants.MAP_KEY

        ivMap.setImage(url: URL(string: mapUrl)!)
    }*/
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
         guard let myURL = urls.first else {
             return
          }
        broucherPath = myURL
        self.lbBroucher.text = broucherPath?.absoluteString
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
          controller.dismiss(animated: true, completion: nil)
      }
}

extension EditProfessionalDetailsVC: locationDelegate {
    func getLocationdata(lat: String, long: String, imgUrl: String, address: String) {
        
        self.imgUrl = imgUrl
        self.lat = lat
        self.long = long
        self.lbLatlong.text = "\(lat)\n\(long)"
        self.locAddress = address
        viewMapImage.isHidden = false
        //        let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C" + "\(lat),\(long)" + "&key=" + StringConstants.GOOGLE_MAP_KEY
        //        Utils.setImageFromUrl(imageView: imgMap, urlString: mapUrl)
        
        let mapLocImgUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C\(lat),\(long)&key=\(StringConstants.GOOGLE_MAP_KEY)"
        
        if let mapUrl = URL(string: mapLocImgUrl) {
            self.ivMap.setImage(url: mapUrl)
        }
        
    }
}
