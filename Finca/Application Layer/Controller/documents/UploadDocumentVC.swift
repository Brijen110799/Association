//
//  UploadDocumentVC.swift
//  Finca
//
//  Created by harsh panchal on 19/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown
//import OpalImagePicker
import Photos

class UploadDocumentVC: BaseVC {
    
    var fileUrl : URL!
    let documentTypeDialog = DropDown()
    @IBOutlet weak var lblFileUrl: UILabel!
    @IBOutlet weak var lblDocumentType: UILabel!
    @IBOutlet weak var tfDocumentName: UITextField!
    @IBOutlet weak var viewChangeDocument: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDocumentType: UILabel!
    @IBOutlet weak var lbSelectDocument: UILabel!
    @IBOutlet weak var bUpload: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var viewMain: UIView!
    
   // var documentType = ["Other","Election Card ","Rent Agreement","Aadhar Card","Passport","Driving  License","RcBook","Vehical PUC","House Index Copy","Tenant Police Verification"]

    var documentType = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tfDocumentName)
        
        if lblFileUrl.text == "No Document Select"{
         //acdoSelectImageChooser()
        }
        if doGetValueLanguageArrayString(forKey: "doc_type").count > 0 {
            documentType = doGetValueLanguageArrayString(forKey: "doc_type")
        }
        
//
//        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: [ColorConstant.start_balnce_sheet.cgColor, ColorConstant.end_balnce_sheet.cgColor], type: .axial)
//        gradient.cornerRadius = 23
//        gradient.frame = viewChangeDocument.bounds
//        viewChangeDocument.layer.addSublayer(gradient)
        viewChangeDocument.backgroundColor = ColorConstant.colorP
        setUpUI()
        setThreeCorner(viewMain: viewMain)
    }
    func setUpUI() {
        lbTitle.text = doGetValueLanguage(forKey: "upload_document")
        lbDocumentType.text = "\(doGetValueLanguage(forKey: "document_type"))*"
        lbSelectDocument.text = doGetValueLanguage(forKey: "select_document")
        tfDocumentName.placeholder = doGetValueLanguage(forKey: "add_document_title")
        lblFileUrl.text = doGetValueLanguage(forKey: "document_path")
        bUpload.setTitle(doGetValueLanguage(forKey: "upload").uppercased(), for: .normal)
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        
    }
    func doSelectImageChooser() {
        
        showAttachmentDialog(msg: doGetValueLanguage(forKey: "select_option"), isShowFile: true)
       /* let alertVC = UIAlertController(title: "", message: "Please Select Document From:", preferredStyle: .actionSheet)
        
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
            alertVC.dismiss(animated: true, completion: nil)
//            alertVC.dismiss(animated: true){
//                self.navigationController?.popViewController(animated: true)
//            }
            //self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertVC, animated: true, completion: nil)*/
    }
    override func tapOpenMedia(type: MediaType) {
        if type == .camera {
            self.btnOpenCamera()
        }
        if type == .gallery {
            self.btnOpenGallery()
        }
        if type == .fileExplore {
            self.attachDocument()
        }
    }
    
    func btnOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
           // imagePicker.allowsEditing = true
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
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//         //   imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        else
//        {
//            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 4
        print("allowed selection",imagePicker.maximumSelectionsAllowed)
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        imagePicker.selectionImageTintColor = UIColor.black
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        imagePicker.imagePickerDelegate = self
        imagePicker.modalPresentationStyle = .formSheet
        present(imagePicker, animated: true, completion: nil)
        
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
    
    
    @IBAction func btnPickDoucment(_ sender: UIButton) {
        
        documentTypeDialog.anchorView = lblDocumentType
        documentTypeDialog.dataSource = documentType
        documentTypeDialog.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.lblDocumentType.text = item
            
        }
        documentTypeDialog.show()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUploadClicked(_ sender: UIButton) {
        doCallApi()
    }
    
    @IBAction func onClickChooseDocu(_ sender: Any) {
        doSelectImageChooser()
    }
    override func onClickDone() {
        
        doSelectImageChooser()
        
    }
    func doCallApi(){
        
        if tfDocumentName.text! == "" {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_add_document_title"))
            return
        }
        if fileUrl == nil{
            showAlertMessageWithClick(title: "", msg: doGetValueLanguage(forKey: "please_select_document"))
            return
        }
        
        self.showProgress()
        let params = ["addDoc":"addDoc",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "ducument_name":tfDocumentName.text!,
                      "document_type":lblDocumentType.text!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipartparms(serviceName: ServiceNameConstants.documentController, parameters: params, fileURL: fileUrl, compression: 0, FileName: "doc_file") { (Data, Err) in
            
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
                    print("parse Error",Err!.localizedDescription)
                }
            }else{
                
            }
        }
    }
}
extension UploadDocumentVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,OpalImagePickerControllerDelegate{
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        if assets.count > 0 {
            var images = [UIImage]()
            for asset in assets {
                images.append(self.getAssetThumbnailNew(asset: asset))
            }
            convertToPdf(imagerArry: images)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
//        if images.count > 0 {
//            convertToPdf(imagerArry: images)
//        }
//        dismiss(animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
        self.lblFileUrl.text = "\(myURL)"
        
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
            
//            let imgName = UUID().uuidString + ".jpeg"
//            let documentDirectory = NSTemporaryDirectory()
//            let localPath = documentDirectory.appending(imgName)
//
//            let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
//            data.write(toFile: localPath, atomically: true)
//            let imageURL = URL.init(fileURLWithPath: localPath)
           // self.fileUrl = imageURL
           //self.lblFileUrl.text = "\(imageURL)"
            convertToPdf(imagerArry: [selectedImage])
        }else{
            let imageURL = info[.imageURL] as! URL
            self.fileUrl = imageURL
            self.lblFileUrl.text = "\(imageURL)"
        }
    }


  
    func convertToPdf(imagerArry : [UIImage]) {
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        for (index,image) in imagerArry.enumerated() {
            pdf.addImage(image)
            if index + 1 != imagerArry.count {
                pdf.beginNewPage()
            }
        }
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let fileName = "docuemnt.pdf"
            let documentsFileName = "file://\( documentDirectories + "/" + fileName)"
            let pdfData = pdf.generatePDFdata()
            let pdfURl:URL = URL(string: documentsFileName)!
            do{
                try pdfData.write(to: pdfURl, options: .atomicWrite)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
                self.fileUrl = pdfURl
                self.lblFileUrl.text = "\(pdfURl)"
            }catch{
                print(error)
            }
            
        }
        
    }
    
    
}
