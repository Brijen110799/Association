//
//  AddCommentDialog.swift
//  Finca
//
//  Created by harsh panchal on 02/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddCommentDialog: BaseVC , UITextViewDelegate {

    enum CommentType {
        case ReplyComment
        case NewComment

    }
    
    
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var btnAddimage: UIButton!
    @IBOutlet weak var imgAttechment: UIImageView!
    @IBOutlet weak var viewAttechment: UIView!
    var discussionData : DiscussionListModel!
    var commentData : CommentListModel!
    var context : DiscussionDetailVC!
    var commentType : CommentType!
   // @IBOutlet weak var tfComment: UITextField!
     @IBOutlet weak var tfComment: UITextView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var conBottomMainView: NSLayoutConstraint!
   
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    let hint = "Add Comment..."
    var agreementImage = [UIImage]()
    var fileAgreement = [URL]()
    var fileUrl: URL!
    var isSelectDoc = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.text = doGetValueLanguage(forKey: "add_comment")
        tfComment.delegate = self
        tfComment.placeholder = doGetValueLanguage(forKey: "add_comment_edit_text")
        tfComment.placeholderColor = .lightGray
        if commentType == .ReplyComment {
            lbTitle.text = doGetValueLanguage(forKey: "reply_on_comment")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification,object: nil)
        btnAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        
        self.btnAddimage.isHidden = false
        self.imgAttechment.isHidden = true
        self.btndelete.isHidden = true
        
        self.addKeyboardAccessory(textViews: [tfComment])
        
    }
    
    
   
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           
           if text.count > 1 {
               print("paste")
               if text.count > 250 {
                   textView.text = String(text.prefix(250))
               }
               return textView.text.count + (text.count - range.length) <= 250
           }
           
           
           let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
           let numberOfChars = newText.count
           return numberOfChars <= 250    //  Limit Value
       }
    
    
    @objc  func keyboardWillShow(sender: NSNotification) {
      //  viewEmojiBottom.isHidden = false
         
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        
        //conBottomMainView.constant = keyboardHeight
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @objc func keyboardWillHide(sender: NSNotification) {
         //  conBottomMainView.constant = 8
           UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.view.layoutIfNeeded()
           })
       }
    
    @IBAction func btndeleteAttechment(_ sender: UIButton) {
        self.imgAttechment.image = nil
        self.btndelete.isHidden = true
        self.imgAttechment.isHidden = true
        self.btnAddimage.isHidden = false
        self.fileAgreement.removeAll()
         
        
    }
    
    @IBAction func btnAddAttechmentAction(_ sender: UIButton) {
        self.tfComment.resignFirstResponder()
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(tag: sender.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery(tag: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "Choose From Document", style: .default, handler: { _ in
            self.attachDocument()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func openCamera(tag:Int)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.view.tag = tag
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
    
    func openGallery(tag: Int)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.view.tag = tag
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
   


    @IBAction func btnAddComment(_ sender: UIButton) {
        let userName = "\(doGetLocalDataUser().userFullName ?? "")(\(doGetLocalDataUser().designation ?? ""))"
        if  !tfComment.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tfComment.text != doGetValueLanguage(forKey: "add_comment_edit_text") {
            self.showProgress()
            var params = [String:String]()
            switch commentType {
            case .ReplyComment:
                params = ["addReplyComment":"addReplyComment",
                          "society_id":doGetLocalDataUser().societyID!,
                          "user_id":doGetLocalDataUser().userID!,
                          "discussion_forum_id":discussionData.discussionForumId!,
                          "comment_messaage":tfComment.text!,
                          "country_code":doGetLocalDataUser().countryCode!,
                          "comment_id":commentData.commentId!,
                          "user_name":userName]
                break;
            case .NewComment:
                params = ["addDiscussionComment":"addDiscussionComment",
                          "society_id":doGetLocalDataUser().societyID!,
                          "user_id":doGetLocalDataUser().userID!,
                          "discussion_forum_id":discussionData.discussionForumId!,
                          "comment_messaage":tfComment.text!,
                          "discussion_forum_for":discussionData.discussionForumFor!,
                          "user_name":userName,
                          "country_code":doGetLocalDataUser().countryCode!,
                          "user_type":doGetLocalDataUser().userType!,
                          "user_mobile":doGetLocalDataUser().userMobile!]
                break;
            default:
                break;
            }
            print(params as Any)
            let request = AlamofireSingleTon.sharedInstance
            request.requestPostMultipartWithFileArry(serviceName: ServiceNameConstants.discussionController, parameters: params, file_doc: self.fileAgreement, file_name: "comment_attachment", compression: 0.3, completionHandler: { Data, Err in
                if Data != nil{
                    self.hideProgress()
                    do{
                        let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                        if response.status == "200"{
                            self.dismiss(animated: true){
                                self.context.fetchNewDataOnRefresh()
                            }
                        }else{
                            print("faliure message",response.message as Any)
                        }
                    }catch{
                        print("parse error",error as Any)
                    }
                }
            })
        }else{
            showAlertMessage(title: "Alert !!", msg: "Please Write A Comment !!")
        }
    }

    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

   
    
  
}
extension AddCommentDialog : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
      
        var selectedImage = UIImage()
        if let img = info[.editedImage] as? UIImage
        {
            
            print("imagePickerController edit")
            
            self.imgAttechment.image = img
            selectedImage = img
           

        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")

            self.imgAttechment.image = img
            selectedImage = img
            

        }
        
        
        let imgName = UUID().uuidString + ".jpeg"
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgName)
        
        let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
        data.write(toFile: localPath, atomically: true)
        let imageURL = URL.init(fileURLWithPath: localPath)
        print(imageURL)
        
        if isSelectDoc {
            isSelectDoc = false
            self.fileAgreement.removeAll()
        }
        
        self.fileAgreement.append(imageURL)
        
        self.agreementImage.append(selectedImage)
        self.btnAddimage.isHidden = true
        self.imgAttechment.isHidden = false
        self.btndelete.isHidden = false
    
     
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        self.fileUrl = myURL
        self.isSelectDoc = true
        
        let fileType = myURL.pathExtension.lowercased()
        if fileType == "pdf" ||  fileType == "png" || fileType == "jpg" || fileType == "jpeg" || fileType == "doc" || fileType == "docx" {
            self.fileUrl = myURL
            if self.agreementImage.count > 0 {
                self.fileAgreement.removeAll()
                self.agreementImage.removeAll()
            }
            self.fileAgreement.append(myURL)
            
//            self.imgAttechment.image = UIImage.init(named: "document")
            
            
            if fileType == "pdf" {
                self.imgAttechment.image = UIImage.init(named: "pdf")
               
            } else if fileType == "doc" ||  fileType == ".docx" {
                self.imgAttechment.image = UIImage.init(named: "doc")
            }else if fileType == "ppt" ||  fileType == ".pptx" {
                self.imgAttechment.image = UIImage.init(named: "doc")
            }
            else if fileType == "jpg" ||  fileType == ".jpeg" {
                
                do {
                       let imageData = try Data(contentsOf:    self.fileUrl as URL)
                    self.imgAttechment.image = UIImage(data: imageData)
                   } catch {
                       print("Unable to load data: \(error)")
                   }
               
            }
            else if fileType == "png" ||  fileType == ".png" {
                do {
                       let imageData = try Data(contentsOf:    self.fileUrl as URL)
                    self.imgAttechment.image = UIImage(data: imageData)
                   } catch {
                       print("Unable to load data: \(error)")
                   }
            }
            else{
                self.imgAttechment.image  = UIImage(named: "office-material")
            }
            
            self.btnAddimage.isHidden = true
            self.imgAttechment.isHidden = false
            self.btndelete.isHidden = false
          
           
        } else {
            self.showAlertMessage(title: "", msg: "File Format not support.")
        }
                
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}



