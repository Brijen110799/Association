//
//  AddBankDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import DropDown
import SwiftUI
class AddBankDetailsVC: BaseVC {
    
    
    var Qrcode = Data()
    @IBOutlet weak var tfGstNo: ACFloatingTextfield!
    @IBOutlet weak var lblQRTitle: UILabel!
    @IBOutlet weak var imgQrcode: UIImageView!
    @IBOutlet weak var tfPersonName: ACFloatingTextfield!
    @IBOutlet weak var tfAccNo: ACFloatingTextfield!
    @IBOutlet weak var tfBankName: ACFloatingTextfield!
    @IBOutlet weak var tfBranchName: ACFloatingTextfield!
    @IBOutlet weak var tfIFSCCode: ACFloatingTextfield!
    @IBOutlet weak var tfSwiftCode: ACFloatingTextfield!
    @IBOutlet weak var tfOtherRemark: ACFloatingTextfield!
    @IBOutlet weak var lbAccountType: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet  var views: [UIView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bSubmit: UIButton!
    var accountType = ""
    let dropDown = DropDown()
    var arrayAccountType  = [String]()
    let requrest = AlamofireSingleTon.sharedInstance
    var modelBankList : ModelBankList?
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        setupUI()
        
    }
    private func setupUI() {
        for item in  views {
            setThreeCorner(viewMain: item)
        }
        
        
        addKeyboardAccessory(textFields: [tfPersonName,tfAccNo,tfBankName,tfBranchName,tfIFSCCode,tfSwiftCode,tfOtherRemark,tfGstNo])
        lblQRTitle.text = doGetValueLanguage(forKey: "select_upi_qr_code")
        tfGstNo.placeholder = doGetValueLanguage(forKey: "tax_number")
        lbTitle.text = doGetValueLanguage(forKey: "bank_account_details")
        tfPersonName.placeholder = doGetValueLanguage(forKey: "enter_account_holder_name") + "*"
        tfAccNo.placeholder = doGetValueLanguage(forKey: "enter_account_number") + "*"
        tfBankName.placeholder = doGetValueLanguage(forKey: "enter_bank_name")
        tfBranchName.placeholder = doGetValueLanguage(forKey: "enter_bank_branch")
        tfIFSCCode.placeholder = doGetValueLanguage(forKey: "enter_ifsc_code")
        tfSwiftCode.placeholder = doGetValueLanguage(forKey: "enter_swift_code")
        tfOtherRemark.placeholder = doGetValueLanguage(forKey: "enter_other_remark")
        bSubmit.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        
        if doGetValueLanguageArrayString(forKey: "bank_acc_type").count > 0 {
            arrayAccountType = doGetValueLanguageArrayString(forKey: "bank_acc_type")
            lbAccountType.text = arrayAccountType[0]
        }
        
        if isEdit {
            bSubmit.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
            if let data = modelBankList {
                tfPersonName.text = data.account_holder ?? ""
                tfAccNo.text = data.account_number ?? ""
                tfBankName.text = data.bank_name ?? ""
                tfBranchName.text = data.bank_branch ?? ""
                tfIFSCCode.text = data.ifsc_code ?? ""
                tfSwiftCode.text = data.swift_code ?? ""
                tfOtherRemark.text = data.other_remark ?? ""
                lbAccountType.text = data.account_type ?? ""
                accountType = data.account_type ?? ""
                tfGstNo.text = data.gst_number ?? ""
                
                if let strqrcode = data.upi_qr_code
                {
                    if strqrcode != ""
                    {
                        Utils.setImageFromUrl(imageView:imgQrcode , urlString: data.upi_qr_code ?? "")
                    }
                
                }
        
            }
        }
      }
    
    
    @IBAction func tapSubmit(_ sender: Any) {
        if isValidate() {
          if isEdit {
            doUpdateData()
          } else {
            doAddData()
          }
        }
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func tapSelectAccType(_ sender: Any) {
        
        dropDown.anchorView = lbAccountType
        dropDown.dataSource = arrayAccountType
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbAccountType.text = item
            accountType = item
        }
        
        dropDown.show()
        
    }
    
    
    private func isValidate() -> Bool {
        var isValid = true
        
        
        if tfPersonName.text!.isEmptyOrWhitespace() && tfPersonName.text!.count < 2  {
            tfPersonName.showErrorWithText(errorText:doGetValueLanguage(forKey: "enter_valid_account_holder_name"))
            isValid = false
        }
       
        if tfAccNo.text!.isEmptyOrWhitespace() && tfAccNo.text!.count < 2  {
            tfAccNo.showErrorWithText(errorText:doGetValueLanguage(forKey: "enter_valid_account_holder_number"))
            isValid = false
        }
        if accountType == ""  || accountType == arrayAccountType[0]{
            toast(message: doGetValueLanguage(forKey: "select_valid_account_type"), type: .Information)
            isValid = false
        }
        
        
//        if tfIFSCCode.text!.isEmptyOrWhitespace() && tfIFSCCode.text!.count < 1  {
//            tfIFSCCode.showErrorWithText(errorText:doGetValueLanguage(forKey: "enter_ifsc_code"))
//            isValid = false
//        }
        
        return isValid
        
    }
    
    private func doAddData() {
        
        
        showProgress()
        let params = ["addBank":"addBank",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "account_holder" : tfPersonName.text ?? "",
                      "account_number" : tfAccNo.text ?? "",
                      "account_type" : accountType,
                      "ifsc_code" : tfIFSCCode.text ?? "",
                      "bank_name" : tfBankName.text ?? "",
                      "bank_branch":tfBranchName.text ?? "",
                      "swift_code":tfSwiftCode.text ?? "",
                      "other_remark" : tfOtherRemark.text ?? "",
                      "gst_number" : tfGstNo.text ?? ""]
        
        
        print("param" , params)
        
        if Qrcode.isEmpty
        {
            requrest.requestPost(serviceName:  NetworkAPI.bank_controller, parameters: params) { (json, error) in
             
                    self.hideProgress()
                
                if json != nil {
                    do {
                        let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                        
                        if response.status == "200" {
                            self.doPopBAck()
                            //self.MemberTypes = response.member_types
                          
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
        else{
            requrest.requestPostMultipartImage(serviceName: NetworkAPI.bank_controller, parameters: params, imageFile:imgQrcode.image!, fileName: "upi_qr_code", compression: 0.3, completionHandler: { json, error in
                
                self.hideProgress()
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    if response.status == "200" {
                        self.doPopBAck()
                        //self.MemberTypes = response.member_types
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
                
            })
            
        }
        
        
        
    }
    
    @IBAction func btnQrcodeAction(_ sender: Any) {
        
        showDialogChoser()
    }
    func showDialogChoser() {
          let alertVC = UIAlertController(title: "", message: doGetValueLanguage(forKey: "select_photos"), preferredStyle: .actionSheet)

          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { (UIAlertAction) in
              self.btnOpenCamera()
          }))
          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { (UIAlertAction) in

                  self.btnOpenGallery()

             //self.btnOpenGallery()
              //  self.shoImagePicker()
          }))

          alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: { (UIAlertAction) in
              alertVC.dismiss(animated: true, completion: nil)
          }))
          self.present(alertVC, animated: true, completion: nil)
      }
    
    func btnOpenCamera() {
           //   self.pickerTag = tag
           if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
               let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
               imagePicker.delegate = self
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
           }
           else
           {
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ok"), style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
    func btnOpenGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: doGetValueLanguage(forKey: "allow_fincasys_to_access_photos_media_files"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ok"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func doUpdateData() {
        
        
        showProgress()
       let bank_id =  modelBankList?.bank_id ?? ""
        let oldupicode = modelBankList?.old_upi_qr_code ?? ""
        let params = ["updateBank":"updateBank",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "account_holder" : tfPersonName.text ?? "",
                      "account_number" : tfAccNo.text ?? "",
                      "account_type" : accountType,
                      "ifsc_code" : tfIFSCCode.text ?? "",
                      "bank_name" : tfBankName.text ?? "",
                      "bank_branch":tfBranchName.text ?? "",
                      "swift_code":tfSwiftCode.text ?? "",
                      "other_remark" : tfOtherRemark.text ?? "",
                      "bank_id" : bank_id,
                      "gst_number" :tfGstNo.text ?? "",
                      "old_upi_qr_code":oldupicode]
        
        
        print("param" , params)
        
        if Qrcode.isEmpty
        {
            requrest.requestPost(serviceName:  NetworkAPI.bank_controller, parameters: params) { (json, error) in
             
                    self.hideProgress()
                
                if json != nil {
                    do {
                        let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                        
                        if response.status == "200" {
                            
                            //self.MemberTypes = response.member_types
                            self.doPopBAck()
                          
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
        else{
            requrest.requestPostMultipartImage(serviceName: NetworkAPI.bank_controller, parameters: params, imageFile:imgQrcode.image!, fileName: "upi_qr_code", compression: 0.3, completionHandler: { json, error in
                
                self.hideProgress()
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    if response.status == "200" {
                        self.doPopBAck()
                        //self.MemberTypes = response.member_types
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
                
            })
        }
        
       
        
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
    
}

extension AddBankDetailsVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
      
        if let img = info[.editedImage] as? UIImage
        {
            //self.ivProfile.image = img
            print("imagePickerController edit")
            
            self.imgQrcode.image = img
            
            if  let imageData = img.jpegData(compressionQuality:0.3) {
           
                self.Qrcode = imageData
               
            }
            
        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")
            self.imgQrcode.image = img
            
            if  let imageData = img.jpegData(compressionQuality:0.3) {
           
                self.Qrcode = imageData
               
            }
        }
        
        //self.imgUserProfile.image = selectedImage
        
    }
}
