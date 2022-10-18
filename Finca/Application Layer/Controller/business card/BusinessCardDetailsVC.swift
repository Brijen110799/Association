//
//  BusinessCardDetailsVC.swift
//  Finca
//
//  Created by Hardik on 3/5/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import  FittedSheets

struct modeldata: Codable {
    let userfullname : String!
    let jobtitle : String!
    let phone : String!
    let email : String!
    let companyname : String!
    let address : String!
}
class BusinessCardDetailsVC: BaseVC {
    
  //  @IBOutlet weak var viewLogoSelector: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewTimeline: UIView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfJobTitle: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCompanyName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tbvCardDetails: UITableView!
    @IBOutlet weak var viewS: UIView!
    @IBOutlet weak var lblTemplate: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var tfWebsite: UITextField!
    @IBOutlet weak var lblShareInTimeLine: UILabel!
    @IBOutlet weak var lblFullNameTitle: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblWebSiteTitle: UILabel!
    @IBOutlet weak var bSaveCard: UIButton!
    @IBOutlet weak var ivPlaceHolder: UIImageView!
    var flag : Bool!
    var StrWebsite = ""
    var shareFlag = ""
    var cardflag = 0
    let itemcell = "Card1Cell"
    let itemcell2 = "Card2Cell"
    let itemcell3 = "Card3Cell"
    let itemcell4 = "Card4Cell"
    let itemcell5 = "Card5Cell"
    let itemcell6 = "card6Cell"
    let itemcell7 = "Card7Cell"
    let itemcell8 = "Card8Cell"
    let itemcell9 = "Card9Cell"
    let itemcell10 = "Card10Cell"
    let itemcell11 = "Card11Cell"
    let itemcell12 = "Card12Cell"
    let itemcell13 = "Card13Cell"
    let itemcell14 = "Card14Cell"
    let itemcell15 = "Card15Cell"
    var chooseImage = UIImage()
    var userProfileReponse : MemberDetailResponse!
    var tempArr = [modeldata]()
    var responseProfessional : ResponseProfessional!
    var logoImage : UIImage!
    var ArrHttps = ["http://","http","https://","https","HTTP://","HTTPS://"]
    var  visitCard = [CardModel]()
    var menuTitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfFullName.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfJobTitle.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfPhone.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfEmail.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfCompanyName.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfAddress.placeholder(doGetValueLanguage(forKey: "no_data"))
        tfWebsite.placeholder(doGetValueLanguage(forKey: "no_data"))
        lblFullNameTitle.text = doGetValueLanguage(forKey: "full_name")
        lblJob.text = doGetValueLanguage(forKey: "job_title")
        lblPhoneNumber.text = doGetValueLanguage(forKey: "mobile_number")
        lblEmailTitle.text = doGetValueLanguage(forKey: "email_ID")
        lblCompanyNameTitle.text = doGetValueLanguage(forKey: "company_name_profe_detail")
        lblAddressTitle.text = doGetValueLanguage(forKey: "addresses")
        lblWebSiteTitle.text = doGetValueLanguage(forKey: "website")
        lblShareInTimeLine.text = doGetValueLanguage(forKey: "share_in_timeline")
        lblTemplate.text = doGetValueLanguage(forKey: "click_here_to_choose_your_template")
        bSaveCard.setTitle(doGetValueLanguage(forKey: "save_visiting_card"), for: .normal)
        
        tfFullName.isUserInteractionEnabled = false
        tfJobTitle.isUserInteractionEnabled = false
        tfPhone.isUserInteractionEnabled = false
        tfEmail.isUserInteractionEnabled = false
        tfCompanyName.isUserInteractionEnabled = false
        tfAddress.isUserInteractionEnabled = false
        tfWebsite.isUserInteractionEnabled = false
        
        
        viewTimeline?.layer.cornerRadius = 20

        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvCardDetails.register(nib, forCellReuseIdentifier: itemcell)
        
        let nib2 = UINib(nibName: itemcell2, bundle: nil)
        tbvCardDetails.register(nib2, forCellReuseIdentifier: itemcell2)
        
        let nib3 = UINib(nibName: itemcell3, bundle: nil)
        tbvCardDetails.register(nib3, forCellReuseIdentifier: itemcell3)
        
        let nib4 = UINib(nibName: itemcell4, bundle: nil)
        tbvCardDetails.register(nib4, forCellReuseIdentifier: itemcell4)
        
        let nib5 = UINib(nibName: itemcell5, bundle: nil)
        tbvCardDetails.register(nib5, forCellReuseIdentifier: itemcell5)
        
        let nib6 = UINib(nibName:itemcell6, bundle: nil)
        tbvCardDetails.register(nib6, forCellReuseIdentifier: itemcell6)
        
        let nib7 = UINib(nibName: itemcell7, bundle: nil)
        tbvCardDetails.register(nib7, forCellReuseIdentifier: itemcell7)
        
        let nib8 = UINib(nibName: itemcell8, bundle: nil)
        tbvCardDetails.register(nib8, forCellReuseIdentifier: itemcell8)
        
        let nib9 = UINib(nibName: itemcell9, bundle: nil)
        tbvCardDetails.register(nib9, forCellReuseIdentifier: itemcell9)
        
        let nib10 = UINib(nibName: itemcell10, bundle: nil)
        tbvCardDetails.register(nib10, forCellReuseIdentifier: itemcell10)
        
        let nib11 = UINib(nibName: itemcell11, bundle: nil)
        tbvCardDetails.register(nib11, forCellReuseIdentifier: itemcell11)
        
        let nib12 = UINib(nibName: itemcell12, bundle: nil)
        tbvCardDetails.register(nib12, forCellReuseIdentifier: itemcell12)
        
        let nib13 = UINib(nibName: itemcell13, bundle: nil)
        tbvCardDetails.register(nib13, forCellReuseIdentifier: itemcell13)
        
        let nib14 = UINib(nibName: itemcell14, bundle: nil)
        tbvCardDetails.register(nib14, forCellReuseIdentifier: itemcell14)
        
        let nib15 = UINib(nibName: itemcell15, bundle: nil)
        tbvCardDetails.register(nib15, forCellReuseIdentifier: itemcell15)

        tbvCardDetails.isHidden = true
        //        lblTemplate.textColor = .white
        //        lblTemplate.text = "Choose Your Template first"
        
        //btnCard.text("Choose Your Template first")
        // btnCard.tintColor = .white
        
        tbvCardDetails.delegate = self
        tbvCardDetails.dataSource = self

        tfEmail.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfPhone.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfAddress.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfFullName.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfJobTitle.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfCompanyName.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)
        tfWebsite.addTarget(self, action: #selector(Card2(_:)), for: .editingChanged)

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        addInputAccessoryForTextFields(textFields: [tfFullName,tfJobTitle,tfPhone,tfEmail,tfCompanyName,tfAddress,tfWebsite], dismissable: true, previousNextable: true)

        doSetData()
        
        if instanceLocal().getTimelineuseraccess() {
            viewS.isHidden = true
        }
        
        
        
        doCallProDetailsApi()
        
        if instanceLocal().getVisitingList().count > 0 {
            visitCard = instanceLocal().getVisitingList()
            Utils.setImageFromUrl(imageView: ivPlaceHolder, urlString: visitCard[3].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            doGetCards()
        } else {
            doGetCards()
        }
    }

    func  doSetData() {
        if responseProfessional != nil {
            tfEmail.text = responseProfessional.user_email
            tfPhone.text = responseProfessional.company_contact_number
            tfFullName.text = responseProfessional.user_full_name
            tfAddress.text = responseProfessional.company_address
            tfJobTitle.text = responseProfessional.designation
            tfCompanyName.text = responseProfessional.company_name
            let Strwebsitee = responseProfessional.company_website
            
           // tfWebsite.text = Strwebsitee?.lowercased()
            
              if ((Strwebsitee?.contains("http://")) != nil) || ((Strwebsitee?.contains("https://")) != nil)
              {
                StrWebsite = Strwebsitee?.replacingOccurrences(of: "http://", with: "") ?? ""
                StrWebsite = Strwebsitee?.replacingOccurrences(of: "https://", with: "") ?? ""
                tfWebsite.text = StrWebsite
              }else{
                StrWebsite = Strwebsitee ?? ""
              }
            
        } else {
            responseProfessional = ResponseProfessional(business_categories: "", company_website: "", company_contact_number: "", company_contact_number_view: "", business_categories_sub: "", status: "", employment_id: "", professional_other: "", unit_id: "", business_categories_other: "", search_keyword: "", society_id: "", employment_description: "", user_id: "", user_full_name: "", employment_type: "", company_name: "", designation: "", user_phone: "", company_address: "", message: "", user_email: "", company_logo: "",user_profile_pic:"", icard_qr_code: "",plot_lattitude: "",plot_longitude: "",visiting_card: "",company_brochure: "")
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
    @IBAction func btnChooseLogo(_ sender: Any) {
        self.openPhotoSelecter()
    }
    func openPhotoSelecter(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Chose a source", preferredStyle: .actionSheet)
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
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    func dovalidate() -> Bool {
        var isvalidate = true
//        if(!isValidEmail(email: tfEmail.text ?? "")){
//            showAlertMessage(title: "", msg: "Please fill the Email")
//            isvalidate = false
//        }
//        if((tfPhone.text?.isEmptyOrWhitespace())!){
//            showAlertMessage(title: "", msg: "Please fill the Phone no.")
//            isvalidate = false
//        }
//        if((tfAddress.text?.isEmptyOrWhitespace())!){
//            showAlertMessage(title: "", msg: "Please fill the Address")
//            isvalidate = false
//        }
//        if((tfJobTitle.text?.isEmptyOrWhitespace())!){
//            showAlertMessage(title: "", msg: "Please fill the Job Title")
//            isvalidate = false
//        }
//        if((tfCompanyName.text?.isEmptyOrWhitespace())!){
//            showAlertMessage(title: "", msg: "Please fill the CompanyName")
//            isvalidate = false
//        }
        
        
        if  (tfPhone.text?.isEmptyOrWhitespace())! || (tfAddress.text?.isEmptyOrWhitespace())! || (tfJobTitle.text?.isEmptyOrWhitespace())! || (tfCompanyName.text?.isEmptyOrWhitespace())! {
            
            toast(message: doGetValueLanguage(forKey: "fill_out_professional_details"), type: .Faliure)
            isvalidate = false
        }
        
        return isvalidate
    }
    func convertToimg(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            return image
        }
        return nil
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("flag")
        if flag == true{
            
            
        }else{
            
        }
    }
    @IBAction func onClickTimeline(_ sender: Any){
        if shareFlag == "share"{
            if dovalidate(){
                let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
                let data = convertToimg(with: viewimage)!
                print(data)
                nextVC.cardImage = data
                nextVC.comefromCard = "visitingCard"
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }else{
            self.toast(message: doGetValueLanguage(forKey: "choose_your_template_first"), type: .Faliure)
        }
    }
    
//        if shareFlag == "share"{
//            if dovalidate(){
//
//                let memberInfo = "User Name: \(tfFullName.text ?? "")\nMobile No: \(tfPhone.text ?? "")\nEmail: \(tfEmail.text ?? "")\nCompany Name: \(tfCompanyName.text ?? "")"
//
//
//                let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
//                let data = convertToimg(with: viewimage)!
//
//                nextVC.cardImage = data
//                nextVC.comefromCard = "visitingCard"
//                nextVC.memberInfo =  memberInfo
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            }
//        }else{
//            self.toast(message: "Choose your template first", type: .Faliure)
//        }
    
    @IBAction func onClickShare(_ sender: Any) {
        
        if shareFlag == "share"{
            if dovalidate(){
                let image = convertToimg(with: viewimage)!
                let memberInfo = "Name: \(tfFullName.text ?? "")\nMobile No.: \(tfPhone.text ?? "")\nEmail: \(tfEmail.text ?? "")\nCompany Name: \(tfCompanyName.text ?? "")"
                let imageShare = [ image as Any , memberInfo as Any]
                let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }else{
            self.toast(message: "Choose your template first", type: .Faliure)
        }
    }
    
    @objc func Card2(_ textField: UITextField) {

        let indexP = IndexPath(row: 0 , section: 0)
        if cardflag == 1{
            let cell: Card1Cell = tbvCardDetails.cellForRow(at: indexP) as! Card1Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
            
                cell.lbWebSite.text = StrWebsite
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }
        else if cardflag == 2{
            let cell: Card2Cell = tbvCardDetails.cellForRow(at: indexP) as! Card2Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == false{
                tfFullName.isEnabled = true
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
               
                
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 3{
            let cell: Card3Cell = tbvCardDetails.cellForRow(at: indexP) as! Card3Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
        
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 4{
            let cell: Card4Cell = tbvCardDetails.cellForRow(at: indexP) as! Card4Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 5{
            let cell: Card5Cell = tbvCardDetails.cellForRow(at: indexP) as! Card5Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 6{
            let cell: card6Cell = tbvCardDetails.cellForRow(at: indexP) as! card6Cell
            
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 7{
            let cell: Card7Cell = tbvCardDetails.cellForRow(at: indexP) as! Card7Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 8{
            let cell: Card8Cell = tbvCardDetails.cellForRow(at: indexP) as! Card8Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 9{
            let cell: Card9Cell = tbvCardDetails.cellForRow(at: indexP) as! Card9Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 10{
            let cell: Card10Cell = tbvCardDetails.cellForRow(at: indexP) as! Card10Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 11{
            let cell: Card11Cell = tbvCardDetails.cellForRow(at: indexP) as! Card11Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 12{
            let cell: Card12Cell = tbvCardDetails.cellForRow(at: indexP) as! Card12Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 13{
            let cell: Card13Cell = tbvCardDetails.cellForRow(at: indexP) as! Card13Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }else if cardflag == 14{
            let cell: Card14Cell = tbvCardDetails.cellForRow(at: indexP) as! Card14Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }
        else if cardflag == 15 {
            let cell: Card15Cell = tbvCardDetails.cellForRow(at: indexP) as! Card15Cell
            if tfEmail.isEditing == true {
                cell.lblEmail.text = tfEmail.text
            }else if tfPhone.isEditing == true {
                cell.lblPhone.text = tfPhone.text
            }else if tfJobTitle.isEditing == true {
                cell.lblJobTitle.text = tfJobTitle.text
            }else if tfAddress.isEditing == true {
                cell.lblAddress.text = tfAddress.text
            }else if tfFullName.isEditing == true {
                cell.lblUserName.text = tfFullName.text
            }else if tfCompanyName.isEditing == true {
                cell.lblCompanyName.text = tfCompanyName.text
            }else if tfWebsite.isEditing == true {
                tfWebsite.text = tfWebsite.text?.lowercased()
                
                  if ((tfWebsite.text?.contains("http://")) != nil) || ((tfWebsite.text?.contains("Https://")) != nil)
                  {
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "http://", with: "") ?? ""
                    StrWebsite = tfWebsite.text?.replacingOccurrences(of: "Https://", with: "") ?? ""
                  }else{
                    StrWebsite = tfWebsite.text ?? ""
                  }
                cell.lbWebSite.text = tfWebsite.text
                cell.viewWebsite.isHidden = tfWebsite.text == "" ? true : false
            }
        }
    }

    @IBAction func onClickCard(_ sender: Any) {
        // let nextVC = UIStoryboard(name: "mainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "idBusinessCardPhotoVC")as! BusinessCardPhotoVC
        let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier: "idBusinessCardPhotoVC")as! BusinessCardPhotoVC
        nextVC.userProfileReponse = userProfileReponse
        nextVC.dataVC = self
        nextVC.flag = flag
        nextVC.visitCard = visitCard
        let sheetController = SheetViewController(controller: nextVC, sizes: [.fixed(view.frame.size.height / 1.5), .fixed(200), .fullScreen, .fullScreen])
        sheetController.blurBottomSafeArea = true
        
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 5)
        sheetController.handleColor = UIColor.white
        sheetController.dismiss(animated: false, completion: nil)
        self.present(sheetController, animated: false ,completion:nil)
        
    }
    func doCallProDetailsApi(){
        let params = ["getAbout":"getAbout",
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "unit_id":doGetLocalDataUser().unitID ?? ""]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(ResponseProfessional.self, from: Data!)
                    if response.status == "200"{
                        self.responseProfessional = response
                        self.doSetData()
                    }else{
                        //print("faliure message",response.message as Any)
                       
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    @IBAction func tapSaveCard(_ sender: Any) {
        if shareFlag == "share"{
            if dovalidate(){
                doSubmitData()
            }
        }else{
            self.toast(message: "Choose your template first", type: .Faliure)
        }
    }
    
    func doSubmitData(){
        let image = convertToimg(with: viewimage)!
        showProgress()
        let plot_lattitude = doGetLocalDataUser().plot_longitude ?? ""
        let business_categories = doGetLocalDataUser().business_categories_sub ?? ""
        let business_categories_sub = doGetLocalDataUser().business_categories_sub ?? ""
        let business_categories_other = doGetLocalDataUser().professional_other ?? ""
        let professional_other = doGetLocalDataUser().professional_other ?? ""
        
        let search_keyword = doGetLocalDataUser().search_keyword ?? ""
        let plot_longitude = doGetLocalDataUser().plot_lattitude ?? ""
        let company_website = doGetLocalDataUser().company_website ?? ""
        
        
        let params = ["key":apiKey(),
                      "addAbout":"addAbout",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_phone":doGetLocalDataUser().userMobile!,
                      "user_email":doGetLocalDataUser().userEmail ?? "",
                      "company_name":doGetLocalDataUser().company_name ?? "",
                      "employment_description": doGetLocalDataUser().employment_description ?? "",
                      "designation":doGetLocalDataUser().designation ?? "",
                      "company_address":doGetLocalDataUser().company_address ?? "",
                      "company_contact_number":doGetLocalDataUser().company_contact_number ?? "",
                      "plot_lattitude" : plot_lattitude,
                      "business_categories" : business_categories,
                      "business_categories_sub" : business_categories_sub,
                      "business_categories_other" : business_categories_other,
                      "professional_other" : professional_other,
                      "search_keyword" : search_keyword,
                      "plot_longitude" : plot_longitude,
                      "company_website" : company_website]
        
       
        
        print("param" , params)
       
        let request = AlamofireSingleTon.sharedInstance
       // serviceName: S, parameters: params, imageFile: ImgvwLogoShow.image, fileName: "company_logo", compression: 0.3
        request.requestPostMultipartImage(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params, imageFile: image,fileName: "visiting_card", compression: 0.4) { (Data, error) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from: Data!)
                    if response.status == "200"{
                    
                        self.toast(message: response.message, type: .Success)
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
    func doGetCards(){
        let params = ["getCard":"getCard",
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: ServiceNameConstants.visiting_card_controller, parameters: params) { (Data, error) in
            
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(ResponseCard.self, from: Data!)
                    if response.status == "200"{
                        if let dataAarray = response.visit_card {
                            self.visitCard = dataAarray
                            self.instanceLocal().setVisitingList(setData:dataAarray)
                        }
                        
                        //  self.toast(message: response.message, type: .Success)
                    }else{
                        // self.toast(message: response.message, type: .Faliure)
                    }
                }catch{
                    print("error")
                }
            }else{
                print("Parse Error")
            }
        }
    }
}
extension BusinessCardDetailsVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let img = info[.editedImage] as? UIImage
        {
            self.logoImage = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            self.logoImage = img
        }

        picker.dismiss(animated: true) {
            self.tbvCardDetails.reloadData()
        }
    }
}
extension BusinessCardDetailsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()

        if cardflag == 1{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! Card1Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            print("hhhhhh")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            
            cell.ivEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.ivWebsite.isHidden = responseProfessional.company_website == "" ? true : false


            doSetData()
            return cell
        }else if cardflag == 2{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell2, for: indexPath)as! Card2Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")

            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row

            //self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false

            doSetData()

            return cell
        }else if cardflag == 3 {
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell3, for: indexPath)as! Card3Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row

            //Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: professionalData.companyLogo, palceHolder: "zoo_biz_trans")
            Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            
           // self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
           
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 4{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell4, for: indexPath)as! Card4Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
           // self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            Utils.setImageFromUrl(imageView: cell.ivLogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
           
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()


            return cell
        }else if cardflag == 5{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell5, for: indexPath)as! Card5Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfWebsite.tag = indexPath.row
          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            //Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: professionalData.companyLogo, palceHolder: "zoo_biz_trans")
            Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false

            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false

            doSetData()

            return cell
        }else if cardflag == 6{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell6, for: indexPath)as! card6Cell
            
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
           // self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewMail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
           
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false

            doSetData()
            return cell
        }else if cardflag == 7{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell7, for: indexPath)as! Card7Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            //Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: professionalData.companyLogo, palceHolder: "zoo_biz_trans")
            Utils.setImageFromUrl(imageView: cell.imgCompanyLogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 8{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell8, for: indexPath)as! Card8Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
          
            Utils.setImageFromUrl(imageView: cell.companyLogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false

            doSetData()

            return cell
        }else if cardflag == 9{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell9, for: indexPath)as! Card9Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
         //   self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()


            return cell
        }else if cardflag == 10{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell10, for: indexPath)as! Card10Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
         //   self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            Utils.setImageFromUrl(imageView: cell.imgcompanylogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 11{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell11, for: indexPath)as! Card11Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 12{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell12, for: indexPath)as! Card12Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
         //   self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.ivEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.ivWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()
            return cell
        }else if cardflag == 13 {
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell13, for: indexPath)as! Card13Cell
            tbvCardDetails.isHidden = false
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row

          //  self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 14{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell14, for: indexPath)as! Card14Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row

         //   self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            Utils.setImageFromUrl(imageView: cell.imgcompanylogo, urlString: responseProfessional.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()

            return cell
        }else if cardflag == 15{
            self.ivPlaceHolder.isHidden = true
            let cell = tbvCardDetails.dequeueReusableCell(withIdentifier: itemcell15, for: indexPath)as! Card15Cell
            tbvCardDetails.isHidden = false
            //            btnCard.text("")
            tfEmail.tag = indexPath.row
            tfPhone.tag = indexPath.row
            tfAddress.tag = indexPath.row
            tfFullName.tag = indexPath.row
            tfJobTitle.tag = indexPath.row
            tfCompanyName.tag = indexPath.row
            tfWebsite.tag = indexPath.row
         //   self.viewLogoSelector.isHidden = cell.containsImage ? false : true
            if self.responseProfessional.user_email == "" || responseProfessional.user_email == nil{
                cell.lblEmail.text = ""
            }else{
                cell.lblEmail.text = responseProfessional.user_email
            }
            cell.viewEmail.isHidden = responseProfessional.user_email ?? "" == "" ? true : false
            cell.lblPhone.text = responseProfessional.company_contact_number ?? ""
            if self.responseProfessional.user_full_name == "" || responseProfessional.user_full_name == nil{
                cell.lblUserName.text = doGetLocalDataUser().userFullName.uppercased()
            }else{
                cell.lblUserName.text = responseProfessional.user_full_name.uppercased()
            }
            if self.responseProfessional.company_address == "" || responseProfessional.company_address == nil{
                cell.lblAddress.text = ""
            }else{
                cell.lblAddress.text = responseProfessional.company_address
            }
            if self.responseProfessional.designation == "" || responseProfessional.designation == nil{
                cell.lblJobTitle.text = ""
            }else{
                cell.lblJobTitle.text = responseProfessional.designation
            }
            if self.responseProfessional.company_name == "" || responseProfessional.company_name == nil{
                cell.lblCompanyName.text = ""
            }else{
                cell.lblCompanyName.text = responseProfessional.company_name
            }
            Utils.setImageFromUrl(imageView: cell.MainLogo, urlString: visitCard[cardflag-1].card_empty ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            var website = responseProfessional.company_website ?? ""
            if  responseProfessional.company_website.lowercased().contains("http://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "http://", with: "")
            }
            if  responseProfessional.company_website.lowercased().contains("https://"){
                website = responseProfessional.company_website.replacingOccurrences(of: "https://", with: "")
            }
            cell.lbWebSite.text = website
              
            cell.viewWebsite.isHidden = responseProfessional.company_website == "" ? true : false
            doSetData()
            return cell
        }else{
            //            self.viewCardNoData.isHidden = false
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 246
    }
    
}
struct ResponseCard : Codable {
    let  message : String? //" : "Get Card Successfully!",
    let  status : String? //" : "200",
    let  visit_card : [CardModel]?
}

struct CardModel : Codable {
    let card_empty  : String? // " : "https:\/\/master.myassociation.app\/img\/visitcard\/card_one_bg.png",
    let card_bg  : String? // " : "https:\/\/master.myassociation.app\/img\/visitcard\/card_one.png",
    let card_id  : String? // " : "1",
    let is_logo  : Bool? // " : false
}
