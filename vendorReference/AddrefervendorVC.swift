//
//  AddrefervendorVC.swift
//  Finca
//
//  Created by CHPL Group on 02/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import ContactsUI

protocol MoveToBack{
    func PassToastMessage(Message:String)
}

class AddrefervendorVC: BaseVC {
    
    
   
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var vwRefervendor: UIView!
    @IBOutlet weak var imgcomp: UIImageView!
    @IBOutlet weak var lblCompanyname: UILabel!
    @IBOutlet weak var tfcompany: UITextField!
    @IBOutlet weak var imgbusiness: UIImageView!
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var tfcategory: UITextField!
    @IBOutlet weak var imgback: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var tfremark: UITextView!
    @IBOutlet weak var lblremark: UILabel!
    @IBOutlet weak var imgremark: UIImageView!
    @IBOutlet weak var tfphone: UITextField!
    @IBOutlet weak var lblphoneno: UILabel!
    @IBOutlet weak var imgphone: UIImageView!
    @IBOutlet weak var tfmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgmail: UIImageView!
    @IBOutlet weak var tfvendor: UITextField!
    @IBOutlet weak var lblvendorname: UILabel!
    @IBOutlet weak var imgVendor: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var businessCatId = ""
    var Refervendor:refer_list?
    var isComeFromParking = ""
    var initForUpdate = false
    var isEdit = false
    var delegate : MoveToBack?
    var finalLineNumber:Float!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tfcompany.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfmail.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfphone.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfvendor.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfcategory.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfremark.placeholder = doGetValueLanguage(forKey: "enter_here")
        lblCompanyname.text = "\(doGetValueLanguage(forKey: "company_name"))*"
        lblcategory.text = "\(doGetValueLanguage(forKey: "business_category"))*"
        lblremark.text = doGetValueLanguage(forKey: "remark")
        lblphoneno.text = "\(doGetValueLanguage(forKey: "phone_number"))*"
        lblEmail.text = doGetValueLanguage(forKey: "email_ID")
        lblvendorname.text = "\(doGetValueLanguage(forKey: "vendor_name"))*"
//        doneButtonOnKeyboard(textField: tfvendor)
//        doneButtonOnKeyboard(textField: tfmail)
//        doneButtonOnKeyboard(textField: tfcompany)
//        doneButtonOnKeyboard(textField: tfcategory)
//        doneButtonOnKeyboard(textField: tfphone)
        tfremark.delegate = self
        doneButtonOnKeyboard(textField: tfremark)
        addKeyboardAccessory(textFields: [tfcompany, tfcategory, tfvendor, tfmail, tfphone])
        lbltitle.text = doGetValueLanguage(forKey: "add_refer_vendor")
        btnsave.setTitle(doGetValueLanguage(forKey: "save"), for: .normal)
        if isEdit{
            lbltitle.text = doGetValueLanguage(forKey: "edit_refer_vendor")
            if let companyname = Refervendor?.refer_vendor_company
            {
                tfcompany.text = companyname
            }
            if let category = Refervendor?.business_category
            {
                tfcategory.text = category
            }
            
            if let vendorname = Refervendor?.refer_vendor_name
            {
                tfvendor.text = vendorname
            }
            
            if let emailid = Refervendor?.refer_vendor_email
            {
                tfmail.text = emailid
            }
            if let phoneno = Refervendor?.refer_vendor_contact_number
            {
                tfphone.text = phoneno
            }
            if let remark = Refervendor?.remarks
            {
                tfremark.text = remark
            }
        }
    }
    
  func doValidateData() -> Bool {
        var isValid = true
        
            if tfcompany.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_company_name"))
                isValid = false
            }else if tfcategory.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_vendor_category"))
                isValid = false
            }else if tfvendor.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_vendor_name"))
                isValid = false
            }else if (tfphone.text?.isEmptyOrWhitespace())! {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                isValid = false
            }else if tfphone.text!.count < 8 {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                isValid = false
            }
            else if tfphone.text!.count > 15 {
          showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
          isValid = false
      }
            else if (tfmail.text != "") {
                if !isValidEmail(email: tfmail.text!) {
                    isValid = false
                    showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_email_id"))
                }
            }
               return isValid
            }
            
    override func viewWillAppear(_ animated: Bool) {
        let rawLineNumber = (tfremark.contentSize.height - tfremark.textContainerInset.top - tfremark.textContainerInset.bottom) / tfremark.font!.lineHeight;
        finalLineNumber = Float(round(rawLineNumber))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
   
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
         
    @IBAction func onclickContact(_ sender: Any) {
        onClickPickContact()
    }
    @IBAction func onclickback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onclicksave(_ sender: UIButton) {
        if doValidateData() {
            if isEdit{
                self.editReferance(strreferid: Refervendor?.refer_id ?? "")
            }else {
                doAddreference()
            }
       }
    }
    
    func editReferance(strreferid:String) {
        showProgress()
     
        let params = ["key":apiKey(),
                      "editReferance":"editReferance",
                      "society_id":doGetLocalDataUser().societyID!,
                      "refer_id":strreferid,
                      "user_type":"0",
                      "added_by":doGetLocalDataUser().userID!,
                      "vendor_name":tfvendor.text!,
                      "vendor_company_name":tfcompany.text!,
                      "contact_number":tfphone.text!,
                      "email":tfmail.text!,
                      "business_category":tfcategory.text!,
                      "remarks":tfremark.text!
                     ]
        print("param" , params)
       
       
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.vendor_referance_controller, parameters: params) { [self] (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: json!)
                    if response.status == "200"{
                        DispatchQueue.main.async {
                            self.delegate?.PassToastMessage(Message: response.message!)
                            self.doPopBAck()
                        }
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            self.view.endEditing(true)
//            return false
//        }
    func doAddreference() {
        showProgress()
     
        let params = ["key":apiKey(),
                      "addReferance":"addReferance",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_type":"0",
                      "added_by":doGetLocalDataUser().userID!,
                      "vendor_name":tfvendor.text!,
                      "vendor_company_name":tfcompany.text!,
                      "contact_number":tfphone.text!,
                      "email":tfmail.text!,
                      "business_category":tfcategory.text!,
                      "remarks":tfremark.text!
                      
        ]
        print("param" , params)
       
       
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.vendor_referance_controller, parameters: params) { (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: json!)
                    if response.status == "200"{
                        DispatchQueue.main.async {
                            self.delegate?.PassToastMessage(Message: response.message!)
                            self.doPopBAck()
                        }
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
   
}
extension AddrefervendorVC : CNContactPickerDelegate
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
          
           let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName

           var number = ""
           var conatct = ""
           if  contact.phoneNumbers.count > 0  {
               let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
               if userPhoneNumbers.count > 0 {
                   let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
                   number = firstPhoneNumber.stringValue
               }
               
               if number.contains("+") {
                   conatct = String(number.dropFirst(3))
                   conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
               } else if number.contains("-") {
                   conatct = number.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                   conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
               }else {
                   conatct = number.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
               }
           }
          
        tfvendor.text = userName //contact.givenName + " " + contact.middleName
           tfphone.text = conatct
       }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}

extension AddrefervendorVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()

        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        print(numberOfLines)
        
        if numberOfLines < Int(finalLineNumber){
            textView.isScrollEnabled = false
        }else {
            textView.isScrollEnabled = true
        }
        
//        if (textView.contentSize.height < textView.frame.size.height){
//            textView.contentSize = CGSize(width: textView.frame.size.width, height: (textView.frame.size.height + 1))//CGSizeMake(0, initialTVHeight+1); //force initial scroll
//        if ((textView.contentSize.height < textView.frame.size.height))
//            {
//                textView.isScrollEnabled = false
//            } else {
//                textView.isScrollEnabled = true
//            }
//        }
        let newText = (tfremark.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count

        return numberOfChars <= 500    // 10 Limit Value
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        textView.isScrollEnabled = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.isScrollEnabled = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isScrollEnabled = false
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        //if (tvIdeaDescription.contentOffset.y <= tvIdeaDescription.contentSize.height - tvIdeaDescription.frame.size.height)
//
//        }
}
