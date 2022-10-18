//
//  ContactFincaTeam.swift
//  Finca
//
//  Created by harsh panchal on 27/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices
class ContactFincaTeamVC: BaseVC {
    
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet var imgView: [UIImageView]!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblAltPhoneNum: UILabel!


    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var lblContactEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblWorkingHours: UILabel!
    @IBOutlet weak var heightOfAltNumber: NSLayoutConstraint!
    @IBOutlet weak var tvFeedback: UITextView!
    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    @IBOutlet weak var lbAlPhoneNumber: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbWebsite: UILabel!
    @IBOutlet weak var lbWorkingHr: UILabel!
    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var lbFilePath: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewAlNumner:UIView!
    var placeHolder = "Description"
    let itemCell = "FincasysTeamCell"
    var teamList = [FincasysTeamModel]()
    var fileUrl : URL!
     var menuTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        //self.tvFeedback.text = placeHolder
        //tvFeedback.text = placeHolder
        //tvFeedback.textColor = UIColor(named: "gray_40")
        viewBubble.makeBubbleView()
        
        
        doneButtonOnKeyboard(textField: tvFeedback)
        doneButtonOnKeyboard(textField: tfSubject)
        btnSubmit.setTitle(doGetValueLanguage(forKey: "submit").uppercased(), for: .normal)
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        lbPhoneNumber.text = doGetValueLanguage(forKey: "phone_number")
        lbAlPhoneNumber.text = doGetValueLanguage(forKey: "alternate_phone_number")
        lbEmail.text = doGetValueLanguage(forKey: "email_contact_finca")
        lbWebsite.text = doGetValueLanguage(forKey: "website_contact_finca")
        lbWorkingHr.text = doGetValueLanguage(forKey: "working_hours")
        tfSubject.placeholder = doGetValueLanguage(forKey: "subject")
        tvFeedback.placeholder = doGetValueLanguage(forKey: "description_contact_finca_fragment")
        tvFeedback.placeholderColor = UIColor(named: "gray_40")
        lbFilePath.text = doGetValueLanguage(forKey: "please_select_attachment_file")
        lbTitle.text = menuTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        doCallTeamMemberApi()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func doCallTeamMemberApi() {
        let params = ["getTeamDetails":"getTeamDetails",
                      "country_code":doGetLocalDataUser().countryCode ?? "",
                      "country_id":instanceLocal().getCountryId()]
        self.showProgress()
        print(params)
        let request = AlamofireSingleTon.sharedInstance

        request.requestPostCommon(serviceName: ServiceNameConstants.contactFincasysTeam, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil{
             
                print(json as Any)
                do {
                    print("something")
                    let response = try JSONDecoder().decode(FincasysTeamResponse.self, from:json!)
                    if response.status == "200" {
                        if response.fincasysTeam != nil && response.fincasysTeam.count > 0{
                            self.teamList.append(contentsOf: response.fincasysTeam)
                        }
                        self.lblWebsite.text = response.fincasysWebsite
                        if response.fincasysAlternateNo ?? "" != "" && response.fincasysAlternateNo ?? "" != "0"{
                            
                            self.viewAlNumner.isHidden = false
                            self.lblAltPhoneNum.text = response.fincasysAlternateNo
                        }
                        
                        self.lblPhoneNumber.text = response.fincasysMobile
                        self.lblContactEmail.text = response.fincasysEmail
                        let strings = response.availbleTime.components(separatedBy: "  ")
                        self.lblWorkingHours.text = strings[0]
                        //                        self.cvFincaTeam.reloadData()
                    }
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            if self.view.frame.origin.y == 0 {
        //                self.view.frame.origin.y -= keyboardSize.height
        //            }
        //        }
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 165
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if isValidateData() {

            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            self.showProgress()
            let params = ["send_feedback":"send_feedback",
                          "society_id":doGetLocalDataUser().societyID!,
                          "name":doGetLocalDataUser().userFullName!,
                          "email":doGetLocalDataUser().userEmail!,
                          "mobile":doGetLocalDataUser().userMobile!,
                          "feedback_msg":tvFeedback.text!,
                          "subject":tfSubject.text!,
                          "country_code":doGetLocalDataUser().countryCode!,
                          "app_version_code":appVersion!,
                          "device":UIDevice().systemName]
            print(params as Any)
            let request = AlamofireSingleTon.sharedInstance
            
            if fileUrl != nil {
                print("file is there")
                request.requestPostMultipartParmsCommon(serviceName: ServiceNameConstants.contactFincasysTeam, parameters: params, fileURL: fileUrl, compression: 0.3, FileName: "attachment") { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.toast(message: response.message, type: .Information)
                                self.tfSubject.text = ""
                                self.lbFilePath.text = ""
                                self.fileUrl = nil
                                self.tvFeedback.text = ""
                                self.tvFeedback.placeholder = self.doGetValueLanguage(forKey: "description_contact_finca_fragment")
                                self.tvFeedback.placeholderColor = UIColor(named: "gray_40")
                                
                            }else{
                                
                            }
                        }catch{
                            print("parse error",Err as Any)
                        }
                    }
                }
            } else {
                print("file is not there")
                request.requestPostCommon(serviceName: ServiceNameConstants.contactFincasysTeam, parameters: params) { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.toast(message: response.message, type: .Information)
                                 self.tfSubject.text = ""
                                self.tvFeedback.text = ""
                                self.tvFeedback.placeholder = self.doGetValueLanguage(forKey: "description_contact_finca_fragment")
                                self.tvFeedback.placeholderColor = UIColor(named: "gray_40")
                              
                            }else{
                                
                            }
                        }catch{
                            print("parse error",Err as Any)
                        }
                    }
                }
            }
        }
    }
    
    func isValidateData() -> Bool {
        var isVlid = true
        if tfSubject.text == ""{
            showAlertMessage(title: "", msg: "Please enter a subject")
            isVlid = false
        }
        if tvFeedback.text.isEmptyOrWhitespace(){
            showAlertMessage(title: "Alert!!", msg: "Please enter a feedback message!!")
            isVlid = false
        }
        return isVlid
    }
    @IBAction func btnHome(_ sender: UIButton) {
        goToDashBoard(storyboard: mainStoryboard)
    }
   
    @IBAction func btnNotification(_ sender: UIButton) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                
//                removeSpaceFromUrl(stringUrl: youtubeVideoID)
//                let url = URL(string: youtubeVideoID)!

                playVideo(url: removeSpaceFromUrl(stringUrl: youtubeVideoID))
                
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
    }
   
    @IBAction func btnCall(_ sender: Any) {
        // doCall(on: lblPhoneNumber.text!)
        
        let phone = lblPhoneNumber.text!
       
//        let splitedPhoneNoArr = phone.components(separatedBy: " ")
//        let countryCode = splitedPhoneNoArr[0]
        let onlyNo: String? = phone
        //print(onlyNo!)
       // print(countryCode)
       // print(phoneNo)
        if onlyNo != nil {
            let phoneNo: String? = onlyNo!

        if let number = phoneNo {
            if let phoneCallURL = URL(string: "telprompt://\(number)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {

                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versio
                        application.openURL(phoneCallURL as URL)
                    }
                }else{
                    print("dialer N/A")
                }
            }
        }
    }
    }
    
    
    @IBAction func btnAlternateCall(_ sender: UIButton) {
        //doCall(on: lblAltPhoneNum.text!)
        let phone = lblAltPhoneNum.text!
       
//        let splitedPhoneNoArr = phone.components(separatedBy: " ")
//        let countryCode = splitedPhoneNoArr[0]
        let onlyNo: String? = phone
       
        
        if onlyNo != nil
        {
            let phoneNo: String? = onlyNo!
            
        if let number = phoneNo {
            if let phoneCallURL = URL(string: "telprompt://\(number)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versio
                        application.openURL(phoneCallURL as URL)
                    }
                }else{
                    print("dialer N/A")
                }
            }
        }
        }
    }
    @IBAction func btnEmailClicked(_ sender: UIButton) {
        
        let email = lblContactEmail.text!
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    @IBAction func btnOpenLabel(_ sender: UIButton) {
        guard let url = URL(string:"https://"+lblWebsite.text!) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onClickAttach(_ sender: Any) {
        doSelectImageChooser()
    }
    func doSelectImageChooser() {
        let alertVC = UIAlertController(title: "", message: "Please Select Document From:", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera()
        }))
        alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            self.btnOpenGallery()
        }))
        alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
            self.attachDocument()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true){
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func btnOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
}
extension ContactFincaTeamVC : UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == tvFeedback{
//            if textView.text == placeHolder{
//                textView.text = ""
//                textView.textColor = UIColor(named: "text")
//            }
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView == tvFeedback{
//            if textView.text == ""{
//                textView.text = placeHolder
//                textView.textColor = UIColor(named: "gray_40")
//            }
//        }
//    }
}
extension ContactFincaTeamVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
        self.lbFilePath.text = "\(myURL)"
        
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
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString + ".jpeg"
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
            data.write(toFile: localPath, atomically: true)
            let imageURL = URL.init(fileURLWithPath: localPath)
            self.fileUrl = imageURL
            self.lbFilePath.text = "\(imageURL)"
            
        }else{
            let imageURL = info[.imageURL] as! URL
            self.fileUrl = imageURL
            self.lbFilePath.text = "\(imageURL)"
        }
    }
}
