//
//  TanantAgreementEditVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 16/07/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import MobileCoreServices
//import OpalImagePicker
import Photos

class TenantAgreementEditVC: BaseVC {

    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var cvAgreement: UICollectionView!
    @IBOutlet weak var cvVerification: UICollectionView!
    
    let itemCell = "DocumentNameCell"
    var fileAgreement = [URL]()
    var filePolice = [URL]()
    var selectType =  ""
    var agreementImage = [UIImage]()
    var policeVerificationImage = [UIImage]()
    var fileUrl:URL!
    let datePicker = UIDatePicker()
    var tenantDetailsVC : TenantDetailsVC!
    var dateSelect = ""
    var memberDetailResponse : MemberDetailResponse!
    var isSelectDoc = false
    var imageLimit = 10
    @IBOutlet weak var conHeightPoliceVerification: NSLayoutConstraint!
    @IBOutlet weak var conHeightTenantAgreement: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        
        cvAgreement.register(nib, forCellWithReuseIdentifier: itemCell)
        cvVerification.register(nib, forCellWithReuseIdentifier: itemCell)
        
        cvAgreement.delegate = self
        cvAgreement.dataSource = self
        
        cvVerification.delegate = self
        cvVerification.dataSource = self
        
        initDatePicker()
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        if memberDetailResponse.tenantAgreementStartDate != "" {
            tfStartDate.text = memberDetailResponse.tenantAgreementStartDate
        } else {
            tfStartDate.text = "Not Available"
        }
        if memberDetailResponse.tenantAgreementEndDate != "" {
            tfEndDate.text = memberDetailResponse.tenantAgreementEndDate
        } else {
            tfEndDate.text = "Not Available"
        }
        
        
        
       // if memberDetailResponse.ari
       // conHeightPoliceVerification.constant = 0
        // conHeightTenantAgreement.constant = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfStartDate {
            dateSelect = "1"
        } else {
            dateSelect = "2"
        }
    }

   
   @IBAction func onTapTenentAgreement(_ sender: Any) {
       
          if  fileAgreement.count != 10 {
              
              //  print(agreementImage.count - 10)
              imageLimit =  10 - agreementImage.count
              showDialogChoser()
              selectType = "agrement"
          } else {
              showAlertMessage(title: "", msg: "Select maximum 10 documents")
          }
          
      }
      @IBAction func onTapTenentVerificationDocument(_ sender: Any) {
         
          if  filePolice.count != 1 {
              // imageLimit =   2 - policeVerificationImage.count
              showDialogChoser()
              selectType = "police"
          } else {
              showAlertMessage(title: "", msg: "Select maximum 1 documents")
          }
          
      }
    
   
    func showDialogChoser() {
      
        let alertVC = UIAlertController(title: "", message: "Select ID Proof", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera()
        }))
        alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            if self.selectType == "agrement" {
                self.shoImagePicker()
            } else {
                self.btnOpenGallery()
            }
        }))
        alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
            self.attachDocument()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func btnOpenCamera(tag:Int! = 1) {
        //   self.pickerTag = tag
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
          //  imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func btnOpenGallery(tag: Int! = 1) {
        
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
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        
//        if tfStartDate.text != "Not Available" || tfEndDate.text != "Not Available"  {
//
//            if tfStartDate.text == "" {
//                showAlertMessage(title: "", msg: "Select Agreement Start Date")
//            }
//            if tfEndDate.text == "" {
//               return
//                showAlertMessage(title: "", msg: "Select Agreement End Date")
//            }
//        }
        
         let A4paperSize = CGSize(width: 595, height: 842)
        //for im
        if agreementImage.count > 0  {
           
            let pdf = SimplePDF(pageSize: A4paperSize)
            
            for (index,image) in agreementImage.enumerated() {
                pdf.addImage(image)
                if index + 1 != agreementImage.count {
                    pdf.beginNewPage()
                }
            }
            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let fileName = "example.pdf"
                let documentsFileName = "file://\( documentDirectories + "/" + fileName)"
                let pdfData = pdf.generatePDFdata()
                let pdfURl:URL = URL(string: documentsFileName)!
                do{
                    try pdfData.write(to: pdfURl, options: .atomicWrite)
                    print("\nThe generated pdf can be found at:")
                    print("\n\t\(documentsFileName)\n")
                    //self.fileUrl = pdfURl
                    fileAgreement.removeAll()
                    fileAgreement.append(pdfURl)
                }catch{
                    print(error)
                }
                
            }
        }
        
        
        
        if policeVerificationImage.count > 0 {
            let pdf = SimplePDF(pageSize: A4paperSize)
            
            for (index,image) in policeVerificationImage.enumerated() {
                pdf.addImage(image)
                if index + 1 != policeVerificationImage.count {
                    pdf.beginNewPage()
                }
            }
            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let fileName = "example2.pdf"
                let documentsFileName = "file://\( documentDirectories + "/" + fileName)"
                let pdfData = pdf.generatePDFdata()
                let pdfURl:URL = URL(string: documentsFileName)!
                do{
                    try pdfData.write(to: pdfURl, options: .atomicWrite)
                    print("\nThe generated pdf can be found at:")
                    print("\n\t\(documentsFileName)\n")
                    //self.fileUrl = pdfURl
                    filePolice.removeAll()
                    filePolice.append(pdfURl)
                }catch{
                    print(error)
                }
                
            }
            
        }
        
        
        
        
        
        self.sheetViewController?.dismiss(animated: false, completion: {
            
            if self.tfStartDate.text == "Not Available"{
                self.tfStartDate.text = ""
            }
            if self.tfEndDate.text == "Not Available"{
                self.tfEndDate.text = ""
            }
            self.tenantDetailsVC.doSubmitTenentData(tenant_agreement_start_date: self.tfStartDate.text!, tenant_agreement_end_date: self.tfEndDate.text!, fileAgreement: self.fileAgreement, filePolice: self.filePolice)
         })
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        sheetViewController?.dismiss(animated: false, completion: nil)
    }
    func initDatePicker(){
         //Formate Date
         datePicker.datePickerMode = .date
         //datePicker.maximumDate = Date()
         //ToolBar
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
         toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
         tfEndDate.inputAccessoryView = toolbar
         tfEndDate.inputView = datePicker
        
        tfStartDate.inputAccessoryView = toolbar
        tfStartDate.inputView = datePicker
         
     }
    @objc func donedatePicker(){
           
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
        if dateSelect == "1"  {
            tfStartDate.text = formatter.string(from: datePicker.date)
        }else {
            tfEndDate.text = formatter.string(from: datePicker.date)
        }
         //  tfDOB.text = formatter.string(from: datePicker.date)
           self.view.endEditing(true)
       }
    @objc func cancelDatePicker(){
           self.view.endEditing(true)
       }

    func shoImagePicker() {
           
           let imagePicker = OpalImagePickerController()
           imagePicker.maximumSelectionsAllowed = imageLimit
           imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
           //Change color of image tint to black
           imagePicker.selectionImageTintColor = UIColor.black
           //Change status bar style
           imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
           //Limit maximum allowed selections to 5
           //    imagePicker.maximumSelectionsAllowed = 10
           //Only allow image media type assets
           imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
           imagePicker.imagePickerDelegate = self
           present(imagePicker, animated: true, completion: nil)
           
           
       }
}
extension  TenantAgreementEditVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,OnClickDeleteImage {
    func onClickDeleteImage(index: Int, type: String) {
        
        if type == "agrement" {
            if agreementImage.count > 0 {
                agreementImage.remove(at: index)
            }
            fileAgreement.remove(at: index)
            cvAgreement.reloadData()
            
        } else {
            policeVerificationImage.remove(at: index)
            filePolice.remove(at: index)
            cvVerification.reloadData()
        }
        
    }
    
    
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
           if collectionView == cvAgreement {
               
               return fileAgreement.count
           } else {
               
               return filePolice.count
           }
           
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentNameCell
           
           cell.index = indexPath.row
           cell.onClickDeleteImage = self
           
           if collectionView == cvAgreement {
               cell.lbTitle.text = fileAgreement[indexPath.row].absoluteString
               cell.type = "agrement"
               
               
           } else {
               //   cell.ivDoc.image = policeVerificationImage[indexPath.row]
               cell.type = "police"
               cell.lbTitle.text =  filePolice[indexPath.row].absoluteString
           }
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           //if
           
           
           return CGSize(width: 120, height: 40)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           
           return 2
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           
           return 4
       }
       
       
   }

extension TenantAgreementEditVC : UIDocumentPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate , OpalImagePickerControllerDelegate{
    
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
          
        if isSelectDoc {
            isSelectDoc = false
            self.fileAgreement.removeAll()
        }
          for asset in assets {
              self.fileAgreement.append(URL(string: asset.originalFilename!)!)
              self.agreementImage.append(self.getAssetThumbnailNew(asset: asset))
          }
          
//          if self.agreementImage.count > 0 {
//              self.heightOfTenentAgreement.constant = 35
//              print("didFinishPickingAssets")
//          }
          
          DispatchQueue.main.async {
              self.cvAgreement.reloadData()
          }
        
          self.dismiss(animated: true, completion: nil)
         
      }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
//        if  selectType == "agrement" {
//
//
//            self.agreementImage.append(contentsOf: images)
//          //  conHeightTenantAgreement.constant = 35
//
//            DispatchQueue.main.async {
//                self.cvAgreement.reloadData()
//            }
//
//
//        } else {
//          //  conHeightPoliceVerification.constant = 35
//            self.policeVerificationImage.append(contentsOf: images)
//
//            DispatchQueue.main.async {
//                self.cvVerification.reloadData()
//            }
//
//
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
        isSelectDoc = true
        ///  self.tfTenantAgreement.text = "\(myURL)"
        //  tfTenantAgreement.errorMessage = ""
        
        let fileType = myURL.pathExtension.lowercased()
        if fileType == "pdf" ||  fileType == "png" || fileType == "jpg" || fileType == "jpeg" || fileType == "doc" || fileType == "docx" {
            self.fileUrl = myURL
            
            
            if  selectType == "agrement" {
                self.agreementImage.removeAll()
                self.fileAgreement.removeAll()
                self.fileAgreement.append(myURL)
                DispatchQueue.main.async {
                    self.cvAgreement.reloadData()
                }
            } else {
                self.filePolice.append(myURL)
                DispatchQueue.main.async {
                    self.cvVerification.reloadData()
                }
                
            }
        } else {
            self.showAlertMessage(title: "", msg: "File Format not support")
        }
        
        print("selectType" , selectType)
        
        
        
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
            
            
            if  selectType == "agrement" {
                self.agreementImage.append(selectedImage)
             //   conHeightTenantAgreement.constant = 35
                self.fileAgreement.append(imageURL)
                DispatchQueue.main.async {
                    self.cvAgreement.reloadData()
                }
                
            } else {
                self.policeVerificationImage.append(selectedImage)
                //conHeightPoliceVerification.constant = 35
                self.filePolice.append(imageURL)
                DispatchQueue.main.async {
                    self.cvVerification.reloadData()
                }
            }
        }else{
            let imageURL = info[.imageURL] as! URL
            self.fileUrl = imageURL
            
            if  selectType == "agrement" {
                   self.agreementImage.append(selectedImage)
                //conHeightTenantAgreement.constant = 35
                self.fileAgreement.append(imageURL)
                DispatchQueue.main.async {
                    self.cvAgreement.reloadData()
                    
                }
            } else {
                self.policeVerificationImage.append(selectedImage)
              //  conHeightPoliceVerification.constant = 35
                self.filePolice.append(imageURL)
                DispatchQueue.main.async {
                    self.cvVerification.reloadData()
                }
                
            }
            
        }
    }
    
}
