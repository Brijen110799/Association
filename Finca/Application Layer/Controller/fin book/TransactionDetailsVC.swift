//
//  TransactionDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 22/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import SkyFloatingLabelTextField
//import OpalImagePicker

class TransactionDetailsVC: BaseVC {
    enum TransactionType {
        case Debit
        case credit
    }

    var transactionType : TransactionType!{
        didSet{
            if transactionType == .Debit{
                tfAmount.title = ""
                tfAmount.textColor = UIColor(named: "green 500")
                tfAmount.isUserInteractionEnabled = false
            }else{
                tfAmount.title = ""
                tfAmount.textColor = UIColor(named: "red_a700")
                tfAmount.isUserInteractionEnabled = false
            }
        }
    }

    var imageArray = [UIImage](){
        didSet{
            self.imageCount = self.imageArray.count
            if imageArray.count > 0{

                cvImage.isHidden = false
                if imageArray.count >= 4{

                    self.viewAddPhoto.isHidden = true
                    self.collectionViewHeight.constant = 200
                }else{

                    self.viewAddPhoto.isHidden = false
                    self.collectionViewHeight.constant = 100
                }
            }else{
                cvImage.isHidden = true
            }
            self.cvImage.reloadData()
        }
    }
    @IBOutlet weak var viewAddedDate: UIView!
    @IBOutlet weak var viewDeletedDate: UIView!
    @IBOutlet weak var btnupdate: UIButton!
    @IBOutlet weak var viewDeleteTransaction: UIView!
    @IBOutlet weak var cvImage: UICollectionView!
    @IBOutlet weak var viewAddPhoto: UIView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tfAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRemark: SkyFloatingLabelTextField!
    @IBOutlet weak var lblAddedDate: UILabel!
    @IBOutlet weak var lblDeletedDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblBillTitle: UILabel!
    
    @IBOutlet weak var viewMainConer: UIView!
    var imageCount = 0
    var transactionData : CustomerTansactionModel!
    var customerData : CustomerListModel!
    let itemcell = "FinBookImageCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: [tfAmount,tfRemark])
        let nib = UINib(nibName: itemcell, bundle: nil)
        cvImage.register(nib, forCellWithReuseIdentifier: itemcell)
        cvImage.delegate = self
        cvImage.dataSource = self
        if transactionData.debitAmount != "0.00"{
            self.transactionType = .Debit
            self.tfAmount.text  = StringConstants.RUPEE_SYMBOL + " " + transactionData.debitAmount!

        }else if transactionData.creditAmount != "0.00"{
            self.transactionType = .credit
            self.tfAmount.text  = StringConstants.RUPEE_SYMBOL + " " + transactionData.creditAmount!
        }
        if transactionData.activeStatus == "1"{
            self.lblDeletedDate.text = self.doGetValueLanguage(forKey: "deleted_on") + transactionData.deletedDate
            self.btnupdate.isHidden = true
            self.viewDeleteTransaction.isHidden = true
        }else{
            self.viewDeletedDate.isHidden = true
            self.btnupdate.isHidden = false
        }
        lblAddedDate.text = self.doGetValueLanguage(forKey: "added_on") + self.transactionData.addedOn
        lblCustomerName.text = customerData.customerName
       // print(customerData.customerName)
      //  print(transactionData.customerName)
        if transactionData.remark == ""{
            self.tfRemark.placeholder = doGetValueLanguage(forKey: "please_enter_transaction_remark")
        }else{
            tfRemark.text = self.transactionData.remark
        }

        for item in transactionData.billPhoto{
            let url = item.billPhoto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            AF.request(url).responseData(completionHandler: { response in
                if let image = UIImage(data: response.data!){
                    self.imageArray.append(image)

                }
            })
        }
        
        setThreeCorner(viewMain: viewMainConer)
    }
    
    @IBAction func btnWhatsappShareClicked(_ sender: UIButton) {
        let nextvc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idPaymentReminderVC")as! PaymentReminderVC
        nextvc.transactionData = self.transactionData
        nextvc.reminderType = .TransactionReminder
        nextvc.customerData = self.customerData
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnChooseImage(_ sender: Any) {
        showAttachmentDialog(msg: doGetValueLanguage(forKey: "select_option"))
    }
    
    override func tapOpenMedia(type: MediaType) {
        if type == .camera {
            
            openCamera()
            
        }
        
        if type == .gallery {
            let imagePicker = OpalImagePickerController()
            imagePicker.maximumSelectionsAllowed = 4 - imageCount
            print("allowed selection",imagePicker.maximumSelectionsAllowed)
            imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
            imagePicker.selectionImageTintColor = UIColor.black
            imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
            imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
            imagePicker.imagePickerDelegate = self
            imagePicker.modalPresentationStyle = .formSheet
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func openCamera(){
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
    func doCallApi(){
        self.showProgress()
        let params = ["updateBillPhoto":"updateBillPhoto",
                      "society_id":doGetLocalDataUser().societyID!,
                      "finbook_customer_id":transactionData.finbookCustomerId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "finbook_passbook_id":transactionData.finbookPassbookId!,
                      "remark":tfRemark.text!,
                      "device":"ios"]
        let request = AlamofireSingleTon.sharedInstance
        //        if imageArray.count > 0{
        request.requestPostMultipart(serviceName: ServiceNameConstants.finBookController, parameters: params, imagesArray: imageArray,fileName: "bill_photo", compression: 0.0) { (Data, Err) in
            if Data != nil {
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }catch{
                    print("Parse Error",error as Any)
                }
            }
        }
        //        }else{
        //            request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
        //                if Data != nil {
        //                    self.hideProgress()
        //                    do{
        //                        let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
        //                        if response.status == "200"{
        //                            self.navigationController?.popViewController(animated: true)
        //                        }
        //                    }catch{
        //                        print("Parse Error",error as Any)
        //                    }
        //                }
        //            }
        //        }
    }

    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        self.doCallApi()
    }

    @IBAction func btnDeleteTransaction(_ sender: UIButton) {
        let params = ["deleteTransaction":"deleteTransaction",
                      "society_id":doGetLocalDataUser().societyID!,
                      "finbook_passbook_id":transactionData.finbookPassbookId!,
                      "active_status":"1",
                      "finbook_customer_id":transactionData.finbookCustomerId!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    func doCallImageDeleteAPi(billPhotoData : BillPhotoModel!){
        self.showProgress()
        let params = ["deleteBillPhoto":"deleteBillPhoto",
                      "finbook_bill_photo_id":billPhotoData.finbookBillPhotoId!,
                      "finbook_customer_id":transactionData.finbookCustomerId!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.toast(message: "Bill Photo Removed" ,type: .Faliure)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }

    }
}
extension TransactionDetailsVC : OpalImagePickerControllerDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
      
//        picker.dismiss(animated: true) {
//            self.imageArray.append(contentsOf: images)
//        }
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
            
           for asset in assets {
               self.imageArray.append(self.getAssetThumbnailNew(asset: asset))
           }
           self.dismiss(animated: true, completion: nil)
           
       }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        self.imageArray.append(selectedImage)
    }
    
}
extension TransactionDetailsVC : UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FinBookImageCellDelegate{

    func deleteButtonClicked(at indexpath: IndexPath!) {
        if indexpath != nil{
            print("array count",transactionData.billPhoto.count)
            print("index path",indexpath.row)
            print("print image arr count",imageArray.count)
            if transactionData.billPhoto.count < indexpath.row + 1{
                self.imageArray.remove(at: indexpath.row)
            }else{
                let data = transactionData.billPhoto[indexpath.row]
                self.doCallImageDeleteAPi(billPhotoData: data)
                self.imageArray.remove(at: indexpath.row)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvImage.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath) as! FinBookImageCell
        cell.selectedImage.image = imageArray[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _ = UIScreen.main.bounds.height
        let screenWidth = cvImage.frame.width / 3
        return CGSize(width: screenWidth, height: 100)
    }

}
