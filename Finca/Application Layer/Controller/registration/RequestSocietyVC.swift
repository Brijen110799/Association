//
//  RequestSocietyVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 26/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
struct RequestSocietyResponse: Codable {
    var message : String!
    var status : String!
}
class RequestSocietyVC: BaseVC {
// request_your_society
    var country_code = ""
    @IBOutlet weak var tfpersonname:UITextField!
    @IBOutlet weak var tfmobile:UITextField!
    @IBOutlet weak var tfemail:UITextField!
    @IBOutlet weak var tvAddress:UITextView!
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var lblCountryNameCode: UILabel!
    @IBOutlet weak var btnsave:UIButton!
    
    var countryList = CountryList()
    var countryName = ""
    var countryCode = ""
    var phoneCode = ""
    var newcountrycode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // setDefultCountry()
        countryList.delegate = self
        tfpersonname.delegate = self
        lblCountryNameCode.text = country_code
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addKeyboardAccessory(textFields: [tfpersonname,tfmobile,tfemail], dismissable: true, previousNextable: true)
        doneButtonOnKeyboard(textField: tvAddress)
        hideKeyBoardHideOutSideTouch()
        initUI()
    }
    func initUI(){
        btnsave.setTitle(doGetValueLanguage(forKey: "submit").uppercased(), for: .normal)
        lbltitle.text = doGetValueLanguage(forKey: "request_your_society")
        tfpersonname.placeholder = "\(doGetValueLanguage(forKey: "contact_person_name"))"
        tvAddress.placeholder = "\(doGetValueLanguage(forKey: "address"))"
        tfmobile.placeholder = doGetValueLanguage(forKey: "contact_person_mobile")
        tfemail.placeholder = doGetValueLanguage(forKey: "contact_person_email")
        
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
    @IBAction func btnSave(_ sender: Any) {
        if isValidate(){
            doCallAddApi()
        }
    }
    func doCallAddApi(){
        
        self.showProgress()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        let params = ["request_society":"request_society",
                      "person_name":tfpersonname.text!,
                      "person_email":tfemail.text!,
                      "person_mobile":tfmobile.text!,
                      "country_code":country_code,
                      "address": tvAddress.text!,
                      "device":"ios",
                      "app_version_code":appVersion!]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
       
            
        request.requestPostCommon(serviceName: ServiceNameConstants.contactFincasysTeam, parameters: params) { (json, error) in
            if json != nil{
                self.hideProgress()
                print(json as Any)
                do {
                    print("something")
                    let response = try JSONDecoder().decode(RequestSocietyResponse.self, from:json!)
                    if response.status == "200" {
                        self.showAlertMessageWithClick(title: "", msg: response.message ?? "")
//                        self.toast(message: response.message, type: .Success)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//
//                                self.doPopBAck()
//
//                        }
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func goback(_ sender: Any)
    {
        doPopBAck()
    }
    override func onClickDone() {
        doPopBAck()
    }
    @IBAction func btnSelectCountry(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    func isValidate() -> Bool {
        var validate = true
        
        if tfpersonname.text!.isEmptyOrWhitespace(){
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_your_contact_name"))
            validate = false
            return false
        }
        if tfmobile.text == "" {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_your_contact_mobile_number"))
            validate = false
            return false
        }else{
            let Ints = tfmobile.text?.count
            if Ints! < 8 || Ints! > 15 {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_your_contact_mobile_number"))
                validate = false
                return false
           }
        }
        return validate
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
       
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblCountryNameCode.text = "\(item.countryCode)) +\(item.phoneExtension)"
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.phoneCode = "+" + item.phoneExtension
                country_code =  "+\(item.phoneExtension)"
                break
            }
        }
    }
}
extension RequestSocietyVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        lblCountryNameCode.text = "+\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.phoneCode = "+" + country.phoneExtension
        country_code = "+\(country.phoneExtension)"
    }
}
