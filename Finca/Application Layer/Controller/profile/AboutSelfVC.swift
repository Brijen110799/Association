//
//  AboutSelfVC.swift
//  Finca
//
//  Created by anjali on 01/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import DropDown
class AboutSelfVC: BaseVC , UITextViewDelegate {
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var tvMore: UITextView!
    @IBOutlet weak var heightConstrainDetailView: NSLayoutConstraint!
    @IBOutlet weak var tfAbout: ACFloatingTextfield!
    
    @IBOutlet weak var tfCompanyName: ACFloatingTextfield!
    @IBOutlet weak var tfDesigation: ACFloatingTextfield!
    @IBOutlet weak var tfAddress: ACFloatingTextfield!
    @IBOutlet weak var tfContact: ACFloatingTextfield!
    
    @IBOutlet weak var lbEmpType: UILabel!
    @IBOutlet weak var lbBusinessType: UILabel!
    
    @IBOutlet weak var lbBusinessSubType: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var professionCategoryList = [ProfessionCategory]()
    var categoryFilterList = [ProfessionCategory]()
    var subCateList = [ProfessionType]()
    var selectedCategoryName = ""
    
    var employment_type:String!
    var business_categories:String!
    var business_categories_sub:String!
    var company_name:String!
    var designation:String!
    var company_address:String!
    var company_contact_number:String!
    var employment_description:String!
    
    let dropDownEmpType = DropDown()
    
    
    let dropDownBusinessType = DropDown()
    let dropDownBusinessSubType = DropDown()
    
 
    var indexForSub = -1
     
    let empSelectData = [CommonCheckModel(title: "Not employed", id: ""),
                         CommonCheckModel(title: "Government", id: ""),
                         CommonCheckModel(title: "Homemaker", id: ""),
                         CommonCheckModel(title: "Owners, Partners & Directors of companies", id: ""),
                         CommonCheckModel(title: "Private", id: ""),
                         CommonCheckModel(title: "Retired Government Servant", id: ""),
                         CommonCheckModel(title: "Retired- Private Service", id: ""),
                         CommonCheckModel(title: "Self Employed", id: ""),
                         CommonCheckModel(title: "Student", id: ""),
                         CommonCheckModel(title: "Others", id: "")]
     
    
    var professionCategory = [CommonCheckModel]()
    var professionSubCategory = [CommonCheckModel]()
    var isReloadData = false
    var type = ""
    var empType = ""
    var categotyID = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ////// tfAbout.delegate = self
        doGetCategory()
        tfCompanyName.delegate = self
        tfDesigation.delegate = self
        tfAddress.delegate = self
        tfContact.delegate = self
        // lbBusinessType.text = businessTypes[0]
        //  sub_type_array = StringConstants.Accounting
        //   lbBusinessSubType.text = sub_type_array[0]
        
        
        doneButtonOnKeyboard(textField: tfContact)
        tvMore.delegate = self
        adjustUITextViewHeight(arg: tvMore)
        
        if employment_type != nil  &&  employment_type != "" {
            lbEmpType.text = employment_type
            hideView(item: employment_type)
        }
        if business_categories != nil &&  business_categories != "" {
            lbBusinessType.text = business_categories
           
        }
        if business_categories_sub != nil &&  business_categories_sub != "" {
            lbBusinessSubType.text = business_categories_sub
        }
        if company_name != nil {
            tfCompanyName.text = company_name
        }
        if designation != nil {
            tfDesigation.text = designation
        }
        if company_address != nil {
            tfAddress.text = company_address
        }
        if company_contact_number != nil {
            tfContact.text = company_contact_number
        }
        if employment_description != nil {
            tvMore.text = employment_description
        } else {
            tvMore.text = "Enter More About You"
            tvMore.textColor = UIColor.lightGray
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //   tvMore.addTarget(self, action: #selector(onTextChange(_:)), for: UIControl.Event.editingChanged)
        
        // tvMore.add

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustUITextViewHeight(arg: textView)
        // print(textView.text!)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  "Enter More About You"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return   view.endEditing(true)
    }
    
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        if doValidateData() {
            doSubmitData()
        }
        /*if tfAbout.text == "" {
         tfAbout.showErrorWithText(errorText: "Enter your self")
         } else {
         
         }*/
        
        
    }
    
    func doValidateData() -> Bool {
        var isValid = true
        
      //  print("gg" , lbEmpType.text )
        if lbEmpType.text == "Not employed" || lbEmpType.text == "Student" || lbEmpType.text == "Others"{
            isValid = true
        }  else {
            if lbBusinessType.text == "" {
                showAlertMessage(title: "", msg: "Select Profession Category")
                isValid = false
            }
            
            if lbBusinessSubType.text == "" {
                showAlertMessage(title: "", msg: "Select Profession type")
                isValid = false
            }
            
            if tfDesigation.text == "" {
                tfDesigation.showErrorWithText(errorText: "Enter Desigation")
                isValid = false
            }
            
            if tfAddress.text == "" {
                tfAddress.showErrorWithText(errorText: "Enter Address")
                isValid = false
            }
            
            if tfContact.text!.count < 10 {
                tfContact.showErrorWithText(errorText: "Enter 10 digit mobile number")
                isValid = false
            }
            
        }
        return isValid
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        /* arg.translatesAutoresizingMaskIntoConstraints = true
         arg.sizeToFit()*/
        arg.isScrollEnabled = false
        
        var frame = self.tvMore.frame
        frame.size.height = self.tvMore.contentSize.height
        self.tvMore.frame = frame
        
    }
    
    func  doSubmitData(){
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "addAbout":"addAbout",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_phone":doGetLocalDataUser().userMobile!,
                      "user_email":doGetLocalDataUser().userEmail!,
                      "employment_type":lbEmpType.text!,
                      "company_name":tfCompanyName.text!,
                      "employment_description":tvMore.text!,
                      "designation":tfDesigation.text!,
                      "company_address":tfAddress.text!,
                      "company_contact_number":tfContact.text!,
                      "business_categories":lbBusinessType.text!,
                      "business_categories_sub":lbBusinessSubType.text!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName:ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                // self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        
                        self.doGetProfileData()
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doGetProfileData() {
        /// showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            
            if json != nil {
//                 self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        // self.initUI()
                        self.doPopBAck()
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doGetCategory(){
        self.showProgress()
        let params2 = ["getCatgory": "getCatgory", "society_id": doGetLocalDataUser().societyID ?? ""]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: ServiceNameConstants.bussinessCategoryController, parameters: params2) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                    if response.status == "200"{
                        self.professionCategoryList.append(contentsOf: response.category)
                       /* if self.professionCategoryList.count != 0{
                            
                            self.lbBusinessType.text = self.professionCategoryList[0].categoryIndustry
                            self.lbBusinessSubType.text = self.professionCategoryList[0].subCategory[0].categoryName
                        }*/
                        
                        
                        for item in response.category {
                            self.professionCategory.append(CommonCheckModel(title: item.categoryIndustry, id: item.categoryId))
                        }
                        
                        if self.business_categories != nil &&  self.business_categories != "" {
                            self.doSetSubTypeArray(type: self.business_categories)
                            
                        }
                        
                    }else{
                        
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }else{
                
            }
        }
    }
    
    @IBAction func onClickEmpType(_ sender: Any) {
        var selectdTitle = ""
        
        
        if lbEmpType.text != nil && lbEmpType.text != "" {
            selectdTitle = lbEmpType.text!
        }
        type = "EmpType"
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idDialogCommonFilterVC") as! DialogCommonFilterVC
        vc.listData = empSelectData
        vc.type  = type
        vc.selectdTitle = selectdTitle
        vc.aboutSelfVC = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
        
        
        /*dropDownEmpType.anchorView = lbEmpType
        dropDownEmpType.dataSource = empTypes
        dropDownEmpType.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbEmpType.text = item
            self.hideView(item: item)
            self.lbBusinessType.text = self.businessTypes[0]
        }
        dropDownEmpType.show()*/
    }
    
    @IBAction func onClickBusinessType(_ sender: Any) {
        
        var selectdTitle = ""
        if lbBusinessType.text != nil && lbBusinessType.text != "" {
            selectdTitle = lbBusinessType.text!
        }
        type = "professionCategory"
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idDialogCommonFilterVC") as! DialogCommonFilterVC
        vc.listData = professionCategory
        vc.type  = type
        vc.selectdTitle = selectdTitle
        vc.aboutSelfVC = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
        
      /*  businessTypes.removeAll()
        for item in professionCategoryList{
            self.businessTypes.append(item.categoryIndustry)
        }
        dropDownBusinessType.anchorView = lbBusinessType
        dropDownBusinessType.dataSource = businessTypes
        dropDownBusinessType.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbBusinessType.text = item
            self.selectedCategoryName = item
            self.lbBusinessSubType.text = self.professionCategoryList[index].subCategory[0].categoryName
        }
        dropDownBusinessType.show()*/
    }
    
    @IBAction func onClickSubBusinessType(_ sender: Any) {
//        doSatArray(array: sub_type_array)
        
        var selectdTitle = ""
        
        if lbBusinessSubType.text != nil && lbBusinessSubType.text != "" {
            selectdTitle = lbBusinessSubType.text!
        }
        
        
        type = "professionSubCategory"
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idDialogCommonFilterVC") as! DialogCommonFilterVC
        vc.listData = professionSubCategory
        vc.type  = type
        vc.selectdTitle = selectdTitle
        vc.aboutSelfVC = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
        
        
      /*  array.removeAll()
        print("selected Category ",selectedCategoryName)
        for item in professionCategoryList{
            print("category industry ,",item.categoryIndustry)
            if item.categoryIndustry! == selectedCategoryName{
                for subItem in item.subCategory{
                    print("category name ,",subItem.categoryName)
                    array.append(subItem.categoryName)
                }
            }
        }
        
        dropDownBusinessSubType.anchorView = lbBusinessSubType
        dropDownBusinessSubType.dataSource = array
        dropDownBusinessSubType.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.lbBusinessSubType.text = item
        }
        
        dropDownBusinessSubType.show()*/
    }
    
    func hideView(item:String) {
        if item == "Not employed" || item == "Student" || item == "Others"{
            self.viewDetails.isHidden = true
            self.heightConstrainDetailView.constant = 0.0
            
            self.lbBusinessType.text = ""
            self.lbBusinessSubType.text = ""
            self.tfCompanyName.text = ""
            self.tfDesigation.text = ""
            self.tfAddress.text = ""
            self.tfContact.text = ""
            self.professionSubCategory.removeAll()
        } else {
            self.viewDetails.isHidden = false
            self.heightConstrainDetailView.constant = 330.0
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           
           if textField == tfContact {
               let maxLength = 10
               
               
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
           }
           
           if textField == tfAddress {
               let maxLength = 50
               
               
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
           }
           
           
           if textField == tfDesigation {
               let maxLength = 50
               
               
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
           }
           
           return true
       }

    func doSetSubTypeArray(type:String) {
        print("bdhhds")
        var tempArray = [CommonCheckModel]()
        for (index,item) in professionCategoryList.enumerated() {
            if self.business_categories == item.categoryIndustry {
                for item  in professionCategoryList[index].subCategory {
                    tempArray.append(CommonCheckModel(title: item.categoryName, id: ""))
                }
            }
        }
        self.professionSubCategory = tempArray
    }
    
    
    func doSatArray(array:[String]) {
        
        
        dropDownBusinessSubType.anchorView = lbBusinessSubType
        dropDownBusinessSubType.dataSource = array
        dropDownBusinessSubType.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.lbBusinessSubType.text = item
        }
        
        dropDownBusinessSubType.show()
        
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc  func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        
        
        self.scrollView.isScrollEnabled = true
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        //viewHieght.constant = contentInsets.bottom
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
        
        //        if tfName != nil
        //        {
        //            if (!aRect.contains(tfName!.frame.origin))
        //            {
        //                self.scrollView.scrollRectToVisible(tfName!.frame, animated: true)
        //            }
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        
        if isReloadData {
            isReloadData = false
            
            if type == "EmpType" {
                self.lbEmpType.text = empType
                self.hideView(item: empType)
              } else if type == "professionCategory" {
                var tempArray = [CommonCheckModel]()
               
                
                
                for (index,item) in professionCategoryList.enumerated() {
                    
                    if self.categotyID == item.categoryId {
                        
                        for item  in professionCategoryList[index].subCategory {
                             tempArray.append(CommonCheckModel(title: item.categoryName, id: ""))
                        }
                   }
                    
                }
            
                
              /*  for item in professionCategoryList[indexForSub].subCategory {
                    tempArray.append(CommonCheckModel(title: item.categoryName, id: ""))
                }*/
                
                self.professionSubCategory = tempArray
                self.lbBusinessSubType.text = ""
                         
               // print("tetsetse", professionSubCategory.count)
            } else {
                
            }
            
        }
        
        
    }
    
    
  /*  func doGetCategory(){
           self.showProgress()
           let params2 = ["getCatgory":"getCatgory"]
           let request = AlamofireSingleTon.sharedInstance
           request.requestPost(serviceName: ServiceNameConstants.bussinessCategoryController, parameters: params2) { (Data, Err) in
               if Data != nil{
                   self.hideProgress()
                   print(Data as Any)
                   do{
                       let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                       if response.status == "200"{
                           self.professionCategoryList.append(contentsOf: response.category)
                           if self.professionCategoryList.count != 0{
                               self.lbBusinessType.text = self.professionCategoryList[0].categoryIndustry
                               self.lbBusinessSubType.text = self.professionCategoryList[0].subCategory[0].categoryName
                           }
                       }else{
                           
                       }
                   }catch{
                       print("Parse Error",Err as Any)
                   }
               }else{
                   
               }
           }
       }*/
      
    
}
