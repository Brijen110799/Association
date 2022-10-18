//
//  AddAddressVC.swift
//  Finca
//
//  Created by Nanshi Shivhare on 10/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import ContactsUI

class AddAddressVC: BaseVC {

    
    var isEdit = false
    @IBOutlet weak var heightConstMap: NSLayoutConstraint!
    @IBOutlet weak var viewselectlocation: UIView!
    @IBOutlet weak var ivMap: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfphonenumber: UITextField!
    @IBOutlet weak var tfcompanyaddress: UITextField!
    @IBOutlet weak var tfcompanyname: UITextField!
    @IBOutlet weak var lblphonenumber: UILabel!
    @IBOutlet weak var lblcompanyaddress: UILabel!
    @IBOutlet weak var lblcompanyname: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    private var lat = ""
    private var long = ""
    var imgUrl:String?
    var locAddress:String?
    var Addressresp:List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
        
        lbLocation.text = doGetValueLanguage(forKey: "select_location_marker")
        lblcompanyname.text = "\(doGetValueLanguage(forKey: "location_title")+"*")"
        lblcompanyaddress.text = "\(doGetValueLanguage(forKey: "location_address")+"*")"
        lblphonenumber.text = "\(doGetValueLanguage(forKey: "location_contact_no")+"*")"
        
        tfcompanyname.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfcompanyaddress.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfphonenumber.placeholder = doGetValueLanguage(forKey: "enter_here")
        heightConstMap.constant = 50
        ivMap.isHidden = true
        viewselectlocation.isHidden = false
        
        tfcompanyname.delegate = self
        tfcompanyaddress.delegate = self
        tfphonenumber.keyboardType = .numberPad
        
        addKeyboardAccessory(textFields: [tfcompanyname, tfcompanyaddress,tfphonenumber])
        
        if isEdit{
            lblTitle.text = doGetValueLanguage(forKey: "edit_additional_address")
            lbLocation.text = "\(doGetValueLanguage(forKey: "select_location_marker"))*"
            self.tfcompanyname.text = Addressresp?.additional_company_title
            self.tfcompanyaddress.text = Addressresp?.additional_company_address
            self.tfphonenumber.text = Addressresp?.additional_company_phone
            
            self.lat = (Addressresp?.location_latitude)!
            self.long = (Addressresp?.location_longitude)!
          
          
            
            heightConstMap.constant = 150
            ivMap.isHidden = false
            viewselectlocation.isHidden = false
            
            
            let mapLocImgUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C\(lat),\(long)&key=\(StringConstants.GOOGLE_MAP_KEY)"
            
            if let mapUrl = URL(string: mapLocImgUrl) {
                self.ivMap.setImage(url: mapUrl)
            }
            
        }
        else{
            lblTitle.text = doGetValueLanguage(forKey: "add_additional_address")
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    func doValidateData() -> Bool {
        var isValid = true
       
            if tfcompanyname.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_location_name"))
                isValid = false
            }
            
            if tfcompanyaddress.text == "" {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_location_address"))
                isValid = false
            }
            if tfphonenumber.text!.count < 8 {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
                isValid = false
            }
        
        return isValid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return  view.endEditing(true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }

    @IBAction func btnContactAction(_ sender: Any) {
        onClickPickContact()
    }
    @IBAction func btnSaveAction(_ sender: Any) {
        
        if doValidateData(){
            if isEdit{
                doUpdateAddress(straddressID: (Addressresp?.additional_company_address_id)!)
            }
            else{
                doAddAddress()
            }
            
        }
        
        
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.doPopBAck()
    }
    
    @IBAction func tapLocation(_ sender: Any) {
        self.tfphonenumber.resignFirstResponder()
        self.tfcompanyname.resignFirstResponder()
        self.tfcompanyaddress.resignFirstResponder()
        
//        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationMapVC") as! SelectLocationMapVC
//        vc.onTapMediaSelect = self
//         pushVC(vc: vc)
        let vc = SelectProfileLocationVC(nibName: "SelectProfileLocationVC", bundle: nil)
        vc.delegate = self
        pushVC(vc: vc)
    }
    
    
    func doAddAddress(){
        self.showProgress()
        
    
        let params = ["addCompanyAddress": "addCompanyAddress", "society_id": doGetLocalDataUser().societyID ?? "","unit_id": doGetLocalDataUser().unitID ?? "","user_id": doGetLocalDataUser().userID ?? "","additional_company_title": tfcompanyname.text!,
                      "additional_company_address":tfcompanyaddress.text!,"additional_company_phone":tfphonenumber.text!,"location_latitude":self.lat,"location_longitude":self.long]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.additional_company_address_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        DispatchQueue.main.async {
                            self.doPopBAck()
                        }
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }
    
    func doUpdateAddress(straddressID:String){
        self.showProgress()
        
    
        let params = ["updateCompanyAddress": "updateCompanyAddress", "society_id": doGetLocalDataUser().societyID ?? "","unit_id": doGetLocalDataUser().unitID ?? "","user_id": doGetLocalDataUser().userID ?? "","additional_company_title": tfcompanyname.text!,
                      "additional_company_address":tfcompanyaddress.text!,"additional_company_phone":tfphonenumber.text!,"location_latitude":self.lat,"location_longitude":self.long,"additional_company_address_id":straddressID]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.additional_company_address_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        DispatchQueue.main.async {
                            self.doPopBAck()
                        }
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddAddressVC : CNContactPickerDelegate
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
          
        //tfphonenumber.text = userName //contact.givenName + " " + contact.middleName
           tfphonenumber.text = conatct
       }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
extension AddAddressVC: locationDelegate {
    func getLocationdata(lat: String, long: String, imgUrl: String, address: String) {
        
        self.imgUrl = imgUrl
        self.lat = lat
        self.long = long
        self.locAddress = address
      
        
        heightConstMap.constant = 150
        ivMap.isHidden = false
        viewselectlocation.isHidden = true
        
        
        let mapLocImgUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C\(lat),\(long)&key=\(StringConstants.GOOGLE_MAP_KEY)"
        
        if let mapUrl = URL(string: mapLocImgUrl) {
            self.ivMap.setImage(url: mapUrl)
        }
        
    }
}


