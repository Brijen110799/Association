//
//  AddMemberVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 01/02/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import DropDown
import ContactsUI
protocol MemberDelegate{
    func PassData(Fname:String,Lname:String,Mobile:String,relation:String,countryCode:String)
}

class AddMemberVC: BaseVC {
    
    var delegate:MemberDelegate?
    @IBOutlet weak var txtFirstname:UITextField!
    @IBOutlet weak var txtlastname:UITextField!
    @IBOutlet weak var txtMobile:UITextField!
    @IBOutlet weak var tfOtherRelation: UITextField!
    let dropDown = DropDown()
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var btnDropdownRelation: UIButton!
    @IBOutlet weak var lblRelationWithMember: UILabel!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var viewOtherRelation: UIView!
    
    @IBOutlet weak var bAdd: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    var newcountrycode = ""
    
    var relationMember = [String]()
    
    var countryList = CountryList()
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.relationMember =   ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"]
        
        if doGetValueLanguageArrayString(forKey: "relation_society").count > 0 {
            relationMember = doGetValueLanguageArrayString(forKey: "relation_society")
        }
        lblRelation.text = relationMember[0]
        initDropdown()
        countryList.delegate = self
        lblCountryNameCode.text = "\u{1F1EE}\u{1F1F3} +91"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        initUI()
        setDefultCountry()
    }
    func initUI(){
        addKeyboardAccessory(textFields: [txtFirstname,txtlastname,tfOtherRelation], dismissable: true, previousNextable: true)
        txtMobile.delegate = self
        txtFirstname.placeholder = "\(doGetValueLanguage(forKey: "first_name"))*"
        txtlastname.placeholder = "\(doGetValueLanguage(forKey: "last_name"))*"
        lblRelationWithMember.text = doGetValueLanguage(forKey: "relation_with_member")
        txtMobile.placeholder = doGetValueLanguage(forKey: "mobile_no")
        bAdd.setTitle(doGetValueLanguage(forKey: "add"), for: .normal)
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel"), for: .normal)
    }
    @objc func keyboardWillShow(notification: NSNotification) {

        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
       // let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

     //   self.scrollView.contentInset = contentInsets
      //  self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if self.view.frame.origin.y == 0
        {
            self.view.frame.origin.y -= 60
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {

       // let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
       // self.scrollView.contentInset = contentInsets
       // self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.frame.origin.y = 0
    }
    func isValidate() -> Bool {
        var validate = true
        
        if txtFirstname.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_first_name"))
            validate = false
        }
        if  txtlastname.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_last_name"))
            validate = false
        }
        if txtMobile.text == "" || txtMobile.text == nil{
            print("Not Available")
        }else{
            if txtMobile.text!.count < 8{
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                validate = false
           }
        }
           
            
        if  self.lblRelation.text == doGetValueLanguage(forKey: "other_relation") {
            if tfOtherRelation.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_relation"))
                validate = false
            }
        }
        return validate
    }
    func initDropdown(){
        dropDown.anchorView = btnDropdownRelation
        dropDown.dataSource = relationMember
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblRelation.text = self.dropDown.selectedItem
            
            if  self.dropDown.selectedItem == doGetValueLanguage(forKey: "other_relation") {
                self.viewOtherRelation.isHidden = false
            } else {
                self.viewOtherRelation.isHidden = true
            }
        }
        dropDown.width = btnDropdownRelation.frame.width
    }
    @IBAction func onClickDropdown(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnContact(_ sender: Any) {
        onClickPickContact()
    }
    @IBAction func btnSelectCountry(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
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
                newcountrycode =  "+\(item.phoneExtension)"
                break
            }
        }
    }
    @IBAction func btnAdd(_ sender: UIButton) {
        if isValidate() {
            print(countryCode)
            delegate?.PassData(Fname: txtFirstname.text ?? "", Lname: txtlastname.text ?? "", Mobile: txtMobile.text ?? "", relation: lblRelation.text ?? "", countryCode: newcountrycode)
           dismiss(animated: true, completion: nil)
        }
    }
}
extension AddMemberVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        lblCountryNameCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.phoneCode = "+" + country.phoneExtension
        newcountrycode = "+\(country.phoneExtension)"
    }
}
extension AddMemberVC : CNContactPickerDelegate
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
        var number = ""
        if contact.phoneNumbers.count > 0 {
            // user phone number
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
        

        txtMobile.text = conatct

//        doCall(on: conatct)

    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
