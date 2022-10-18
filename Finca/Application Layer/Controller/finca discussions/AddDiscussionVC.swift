//
//  AddDiscussionVC.swift
//  Finca
//
//  Created by harsh panchal on 30/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown
import MobileCoreServices
class AddDiscussionVC: BaseVC {
    var RelationMember = [String]()
  //  var relationMemberOwner = ["All Resident","Owner"]
  //  var relationMemberTenant = ["All Resident","Tenant"]
    var Indexvalue = 0
    @IBOutlet weak var viewAddImage: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgDiscussion: UIImageView!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var tfTitle: UITextView!
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var viewAddFile: UIView!
    @IBOutlet weak var viewFile: UIView!
    @IBOutlet weak var imgFileType: UIImageView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var lblSubmitDiscussion: UILabel!
    @IBOutlet weak var photoSelectView: UIView!
    @IBOutlet weak var titleVIew: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var participantsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var imagefile : UIImage!
    var fileUrl : URL!
    let dropDown = DropDown()
    var titlePlaceholder = "Title *"
    var descriptionPlaceholder = "Write details *"
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.placeholder = "\(doGetValueLanguage(forKey: "title_star"))*"
        tfTitle.placeholderColor = UIColor(named: colorNames.Placeholder)
        tfDescription.placeholder = "\(doGetValueLanguage(forKey: "write_details"))*"
        tfDescription.placeholderColor = UIColor(named: colorNames.Placeholder)
        
        addKeyboardAccessory(textViews: [tfTitle,tfDescription], dismissable: true, previousNextable: true)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if doGetValueLanguageArrayString(forKey: "discussion").count > 0{
            RelationMember = doGetValueLanguageArrayString(forKey: "discussion")
        }
        lblScreenTitle.text = doGetValueLanguage(forKey: "start_discussion")
        lblImage.text = doGetValueLanguage(forKey: "image")
        lblFile.text = doGetValueLanguage(forKey: "file")
        lblTitle.text = doGetValueLanguage(forKey: "add_comment_title")
        //tfTitle.placeholder = doGetValueLanguage(forKey: "title_star")
        lblDescription.text = doGetValueLanguage(forKey: "description")
        //tfDescription.placeholder = doGetValueLanguage(forKey: "write_details")
        lblParticipants.text = "\(doGetValueLanguage(forKey: "participants"))*"
        lblSubmitDiscussion.text = doGetValueLanguage(forKey: "submit_discussion").uppercased()
        lblGroup.text = RelationMember[0]
        setThreeCorner(viewMain: photoSelectView)
        setThreeCorner(viewMain: titleVIew)
        setThreeCorner(viewMain: descriptionView)
        setThreeCorner(viewMain: participantsView)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
      }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    @IBAction func btnChooseImage(_ sender: Any) {
        openPhotoSelecter()
    }
    @IBAction func btnSelectDropdown(_ sender: Any) {
        dropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.anchorView = lblGroup
        if doGetLocalDataUser().memberStatus == "0"
        {
          //  RelationMember = relationMemberOwner
            RelationMember = doGetValueLanguageArrayString(forKey: "discussion")
        }else
        {
          //  RelationMember = relationMemberTenant
            RelationMember = doGetValueLanguageArrayString(forKey: "discussion_tenant")
        }
        dropDown.dataSource = RelationMember
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            Indexvalue = index
            self.lblGroup.text = self.dropDown.selectedItem
        }
        dropDown.show()
    }
    @IBAction func btnAddFIleClicked(_ sender: UIButton) {
        self.attachDocument()
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
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if doValidate(){
            doCallApi()
        }
    }
    @IBAction func btnDeleteImage(_ sender: UIButton) {
        self.imagefile = nil
        self.viewImage.isHidden = true
        self.viewAddImage.isHidden = false
    }
    @IBAction func btnDeleteFile(_ sender: UIButton) {
        self.fileUrl = nil
        self.viewFile.isHidden = true
        self.viewAddFile.isHidden = false
    }
    func doCallApi(){
        self.showProgress()
        var discussion_forum_for = "0"
        if lblGroup.text! == doGetValueLanguage(forKey: "owner"){
            discussion_forum_for = "1"
        }
        print(discussion_forum_for)
        let userName = "\(doGetLocalDataUser().userFullName ?? "")(\(doGetLocalDataUser().designation ?? ""))"
        let params = ["addDiscussion":"addDiscussion",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "discussion_forum_title":tfTitle.text!,
                      "discussion_forum_description":tfDescription.text!,
                      "discussion_forum_for":String(Indexvalue - 1),
                      "user_name":userName,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "user_type":doGetLocalDataUser().userType!,
                      "user_mobile":doGetLocalDataUser().userMobile!] as [String : Any]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.discussionController, parameters: params, fileURL: self.fileUrl, compression: 0, imageFile: self.imagefile, fileParam: "discussion_file", imageFileParam: "discussion_photo") { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    func  doValidate()-> Bool {
        
        var flag = true
        
        if Indexvalue == 0
        {
            flag = false
            toast(message: doGetValueLanguage(forKey: "select_participate_group"), type: .Information)
            return flag
        }
        if tfTitle.text.isEmptyOrWhitespace() {
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_discussion_title"))
            flag = false
        }
        if tfDescription.text.isEmptyOrWhitespace() {
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_discussion_description"))
            flag = false
        }

        if lblGroup.text! == RelationMember[0]{
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_participate_group"))
            flag = false
        }
        return flag
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddDiscussionVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.editedImage] as? UIImage
        {
            //self.ivProfile.image = img
            print("imagePickerController ")
            self.viewImage.isHidden = false
            self.viewAddImage.isHidden = true
            self.imgDiscussion.image = img
            imagefile = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController")
            self.viewImage.isHidden = false
            self.viewAddImage.isHidden = true
            self.imgDiscussion.image = img
            imagefile = img
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.viewAddFile.isHidden = true
        self.viewFile.isHidden = false
        self.fileUrl = myURL
        if fileUrl.lastPathComponent.contains(".png"){
            imgFileType.image = ImageNameConstanst.img_png
        }else if fileUrl.lastPathComponent.contains(".pdf"){
            imgFileType.image = ImageNameConstanst.img_pdf
        }else if fileUrl.lastPathComponent.contains(".jpg"){
            imgFileType.image = ImageNameConstanst.img_jpg
        }else if fileUrl.lastPathComponent.contains(".jpeg"){
            imgFileType.image = ImageNameConstanst.img_jpg
        }else if fileUrl.lastPathComponent.contains(".docx"){
            imgFileType.image = ImageNameConstanst.img_doc
        }else if fileUrl.lastPathComponent.contains(".ppt"){
            imgFileType.image = ImageNameConstanst.img_ppt
        }else if fileUrl.lastPathComponent.contains(".mp3"){
            imgFileType.image = ImageNameConstanst.img_mp3
        }else if fileUrl.lastPathComponent.contains(".mp4"){
            imgFileType.image = ImageNameConstanst.img_mp4
        }else{
            imgFileType.image = UIImage(named:"")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
extension AddDiscussionVC:UITextViewDelegate{

   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == tfTitle {
        if text.count > 1 {
            print("paste")
            if text.count > 80 {
                textView.text = String(text.prefix(80))
            }
            return textView.text.count + (text.count - range.length) <= 80
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 80    //  Limit Value
        }
        return (2000 != 0)
    }

}
