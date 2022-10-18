//
//  AddTranscationDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Photos
//import OpalImagePicker

import SkyFloatingLabelTextField

class AddTranscationDialogVC: BaseVC {
    enum TransactionType : String{
        //accept payment
        case Credit = "0"
        //give credit
        case Debit = "1"
    }

    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tfRemark: SkyFloatingLabelTextField!
    @IBOutlet weak var tfAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var cvImage: UICollectionView!
    @IBOutlet weak var viewAddPhoto: UIView!
    @IBOutlet weak var lblAddBillTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    var transactionType : TransactionType!
    var customerData : CustomerListModel!
    var imageArray = [UIImage](){
        didSet{
            self.imageCount = self.imageArray.count
            if imageArray.count > 0{
                self.viewMain.setNeedsLayout()
                cvImage.isHidden = false
                if imageArray.count >= 4{
                    self.viewMain.setNeedsLayout()
                    self.viewAddPhoto.isHidden = true
                    self.collectionViewHeight.constant = 200
                }else{
                    self.viewMain.setNeedsLayout()
                    self.viewAddPhoto.isHidden = false
                    self.collectionViewHeight.constant = 100
                }
            }else{
                cvImage.isHidden = true
            }
            self.cvImage.reloadData()
        }
    }
    var context : CustomerAccountDetailsVC!
    var imageCount = 0
    let itemcell = "FinBookImageCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        cvImage.register(nib, forCellWithReuseIdentifier: itemcell)
        cvImage.delegate = self
        cvImage.dataSource = self

        doneButtonOnKeyboard(textField: [tfAmount,tfRemark])
        //lblAddBillTitle.text = doGetValueLanguage(forKey: "")
        tfAmount.placeholder("\(doGetValueLanguage(forKey: "amount"))*")
        tfRemark.placeholder(doGetValueLanguage(forKey: "remark"))
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel"), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        if transactionType == .Debit{
            self.btnAgree.setTitle(doGetValueLanguage(forKey: "accept_payment"), for: .normal)
        }else{
            self.btnAgree.setTitle(doGetValueLanguage(forKey: "give_credit"), for: .normal)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        
        if tfAmount.text != "" {
            if tfAmount.text!.isCorrectDecimal{
                 if Double(tfAmount.text!)! < 1.0 {
                    showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_valid_amount"))
                    return
                }
            }else{
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_valid_amount"))
                return
                //                if Double(tfAmount.text!)! == 0.0 {
                //                    showAlertMessage(title: "", msg: "Enter valid amount")
                //                    return
                //                }
            }
        } else {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "enter_valid_amount"))
            return
        }

//        if tfRemark.text!.count > 50{
//            showAlertMessage(title: "", msg: "Please enter remark within 50 characters")
//            return
//        }
        
        self.showProgress()
        let params = ["addTransaction":"addTransaction",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "finbook_customer_id":customerData.finbookCustomerId!,
                      "amount":tfAmount.text!,
                      "amount_type":self.transactionType.rawValue,
                      "remark":tfRemark.text!]
        let request = AlamofireSingleTon.sharedInstance
        if imageArray.count > 0{
            request.requestPostMultipart(serviceName: ServiceNameConstants.finBookController, parameters: params, imagesArray: imageArray,fileName: "bill_photo", compression: 0.0) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    do{
                        let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                        if response.status == "200"{
                            self.dismiss(animated: true) {
                                self.context.fetchNewDataOnRefresh()
                            }
                        }else {
                            self.showAlertMessage(title: "", msg: response.message)
                        }
                    }catch{
                        print("Parse Error",error as Any)
                    }
                }
            }
        }else{
            request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    do{
                        let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                        if response.status == "200"{
                            self.dismiss(animated: true) {
                                self.context.fetchNewDataOnRefresh()
                            }
                        }
                    }catch{
                        print("Parse Error",error as Any)
                    }
                }
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddTranscationDialogVC : OpalImagePickerControllerDelegate{
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
}

extension AddTranscationDialogVC : UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FinBookImageCellDelegate{
    func deleteButtonClicked(at indexpath: IndexPath!) {
        self.imageArray.remove(at: indexpath.row)
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

extension AddTranscationDialogVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        self.imageArray.append(selectedImage)
    }
}
