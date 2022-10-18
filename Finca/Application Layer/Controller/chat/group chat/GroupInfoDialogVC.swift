//
//  GroupInfoDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 09/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Alamofire
class GroupInfoDialogVC: BaseVC {
    
    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgGroupProfile: UIImageView!
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    var selectedMemberList = [MemberListModel]()
    var fileUrl:URL!
    var context: AddGroupChatVC!
    var editContext : GroupDetailsVC!
    var editFlag = false
    var groupDetails : MemberListModel!
    var imageVar : UIImage!{
        didSet{
            self.tempImage.isHidden = true
            self.imgGroupProfile.image = self.imageVar
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editFlag{
            self.btnSave.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
            let url = groupDetails.userProfilePic.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            AF.request(url).responseData(completionHandler: { response in

                if let image = UIImage(data: response.data!){
                    self.imageVar = image

                }
            })
//            Utils.setImageFromUrl(imageView: imgGroupProfile, urlString: groupDetails.userProfilePic!, palceHolder:"groupPlaceholder")
            tfGroupName.text = groupDetails.userFullName
        }else{
            self.btnSave.setTitle(doGetValueLanguage(forKey: "create").uppercased(), for: .normal)
            
        }
        tfGroupName.placeholder(doGetValueLanguage(forKey: "enter_group_name"))
        self.btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        
    }
    @IBAction func btnCreateGroupClicked(_ sender: UIButton) {
        if Validate(){
            doCallApi()
        }
    }
    
    func Validate() -> Bool! {
        var flag = true
        if tfGroupName.text! == ""{
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_group_name"))
            flag = false
        }
        if imgGroupProfile.image?.cgImage != nil{
//            imgGroupProfile.image = .none
        }
        return flag
    }
    
    func doCallApi(){
        
        if editFlag{
            self.showProgress()
            let params = ["editGroup":"editGroup",
                          "society_id":doGetLocalDataUser().societyID!,
                          "user_id":doGetLocalDataUser().userID!,
                          "user_name":doGetLocalDataUser().userFirstName!,
                          "group_name":tfGroupName.text!,
                          "group_id":groupDetails.chatID!]
            let request = AlamofireSingleTon.sharedInstance
            
            if fileUrl == nil && imgGroupProfile.image == nil {
                print(params as Any)
                request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.dismiss(animated: true){
                                    for controller in self.editContext.navigationController!.viewControllers as Array{
                                        if controller.isKind(of: TabCarversionVC.self){
                                            self.editContext.navigationController?.popToViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }else{
                                    
                            }
                        }catch{
                            print("parse error",Err as Any)
                        }
                    }
                }
            }else if imgGroupProfile.image != nil{
                print(params as Any)
                request.requestPostMultipartImage(serviceName: ServiceNameConstants.CreateGroupController, parameters: params, imageFile: imgGroupProfile.image!, fileName: "group_icon", compression: 0) { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.dismiss(animated: true){
                                    for controller in self.editContext.navigationController!.viewControllers as Array{
                                        if controller.isKind(of: TabCarversionVC.self){
                                            self.editContext.navigationController?.popToViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }else{
                                
                            }
                        }catch{
                            print("parse error",Err as Any)
                        }
                    }
                }
            }
        }else{
            self.showProgress()
            var memberIdArray = [String]()
            var memberNames = [String]()
            for item in selectedMemberList{
                memberIdArray.append(item.userID)
                memberNames.append(item.userFirstName)
            }
            let memberIdString = memberIdArray.joined(separator: "~")
            let memName = memberNames.joined(separator: ",")
            print(memberIdString)
            print(memName)
            let params = ["createGroup":"createGroup",
                          "society_id":doGetLocalDataUser().societyID!,
                          "user_id":doGetLocalDataUser().userID!,
                          "group_name":tfGroupName.text!,
                          "created_by":doGetLocalDataUser().userFullName!,
                          "block_id":doGetLocalDataUser().blockID!,
                          "member_id":memberIdString,
                          "user_name":doGetLocalDataUser().userFullName!,
                          "member_name":memName]
            let request = AlamofireSingleTon.sharedInstance
            if fileUrl == nil{
                request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.context.toast(message: response.message, type: .Success)
                                self.dismiss(animated: true){
                                    for controller in self.context.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: TabCarversionVC.self) {
                                            self.context.navigationController!.popToViewController(controller, animated: true)
                                            break;
                                        }
                                    }
                                }
                            }else{
                                
                            }
                        }catch{
                            print(Err as Any)
                        }
                    }
                }
            }else{
                request.requestPostMultipartDocument(serviceName: ServiceNameConstants.CreateGroupController, parameters: params, fileURL: fileUrl, fileParam: "group_icon", compression: 0) { (Data, Err) in
                    if Data != nil{
                        self.hideProgress()
                        print(Data as Any)
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.context.toast(message: response.message, type: .Success)
                                self.dismiss(animated: true){
                                    for controller in self.context.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: TabCarversionVC.self) {
                                            self.context.navigationController!.popToViewController(controller, animated: true)
                                            break;
                                        }
                                    }
                                }
                            }else{
                            }
                        }catch{
                            print(Err as Any)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnAddResource(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "", message:  doGetValueLanguage(forKey: "select_photos"), preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera(tag : sender.tag)
        }))
        alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { (UIAlertAction) in
            self.btnOpenGallery(tag : sender.tag)
        }))
        alertVC.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func btnOpenCamera(tag:Int!) {
        
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
    func btnOpenGallery(tag: Int!) {
        
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
}

extension GroupInfoDialogVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
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
        self.imageVar = selectedImage
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            let imgName = UUID().uuidString + ".jpeg"
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
            data.write(toFile: localPath, atomically: true)
            let imageURL = URL.init(fileURLWithPath: localPath)
            self.fileUrl = imageURL
        }else{
            let imageURL = info[.imageURL] as! URL
            self.fileUrl = imageURL
        }
    }
}
