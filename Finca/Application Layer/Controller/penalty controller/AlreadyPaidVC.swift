//
//  AlreadyPaidVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 27/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown

protocol  getDataDelegate  {
    func getDataFromAnotherVC(temp: String)
}

class AlreadyPaidVC: BaseVC {
    
    var delegateCustom : getDataDelegate?
    var StrCheque_Number = ""
    var StrBankName = ""
    var StrBalanceSheet_Id = ""
    var StrPenaltyId = ""
    var StrRceiveBillId = ""
    var StrBillMastrId = ""
    var Str_Receive_maintainanceId = ""
    var StrMaintainance_Id = ""
    var StrRequestType = ""
    var StrPaidFor = ""
    var StrPaymentType = ""
    var StrAmounts = ""
    var fileUrl : URL?
    var payloadDataPayment : PayloadDataPayment!
    var minimumPaidAmounts = ""
    var minimum_pay_amount = ""
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var lblTransactionAmount : UILabel!
    @IBOutlet weak var VwBankName:UIView!
    @IBOutlet weak var VwChequeNo:UIView!
    @IBOutlet weak var VwUtrId:UIView!
    @IBOutlet weak var VwTransactionId:UIView!
    @IBOutlet weak var txtTransactionId : UITextField!
    @IBOutlet weak var txtUTRid : UITextField!
    @IBOutlet weak var txtChequeno : UITextField!
    @IBOutlet weak var txtBankName : UITextField!
    @IBOutlet weak var txtTransactionAmount : UITextField!
    @IBOutlet weak var txtTransactionDate : UITextField!
    @IBOutlet weak var txtTransactionRemark : UITextField!
    @IBOutlet weak var ImgVw:UIImageView!
    @IBOutlet weak var btnSelectType : UIButton!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblSelectTransactionPhoto: UILabel!
    @IBOutlet weak var lblTransactionAmountTitle: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblSelectTransactionType: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblChequeNo: UILabel!
    @IBOutlet weak var lblUTRID: UILabel!
    @IBOutlet weak var lblTransactionidTitle: UILabel!
    @IBOutlet weak var lblTransactionRemarkTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    let datePicker = UIDatePicker()
    let dropDown = DropDown()
    var ArrSelection = ["Select Transaction Type","Cash","Cheque","Online","UPI"]
    var itemIndex = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScreenTitle.text = doGetValueLanguage(forKey: "already_paid")
        lblSelectTransactionPhoto.text = doGetValueLanguage(forKey: "select_transaction_photo")
        lblTransactionAmountTitle.text = doGetValueLanguage(forKey: "transaction_amount")
        lblTransactionDate.text = doGetValueLanguage(forKey: "transaction_date")
        lblSelectTransactionType.text = doGetValueLanguage(forKey: "please_select_transaction_type")
        lblBankName.text = doGetValueLanguage(forKey: "bank_name")
        lblChequeNo.text = doGetValueLanguage(forKey: "cheque_no")
        lblUTRID.text = doGetValueLanguage(forKey: "utr_id")
        lblTransactionidTitle.text = doGetValueLanguage(forKey: "transaction_id")
        lblTransactionRemarkTitle.text = doGetValueLanguage(forKey: "transaction_remark")
        btnSave.setTitle(doGetValueLanguage(forKey: "save"), for: .normal)
        txtTransactionAmount.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtTransactionDate.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtBankName.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtChequeno.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtUTRid.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtTransactionId.placeholder(doGetValueLanguage(forKey: "type_here"))
        txtTransactionRemark.placeholder(doGetValueLanguage(forKey: "type_here"))
        ArrSelection = doGetValueLanguageArrayString(forKey: "select_transaction_type")
        txtTransactionAmount.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        initDatePicker()
        addKeyboardAccessory(textFields: [txtTransactionAmount,txtBankName,txtChequeno,txtUTRid,txtTransactionId,txtTransactionRemark], dismissable: true, previousNextable: true)
        
        
        // txtTransactionAmount.text = StrAmounts
        // lblTransactionAmount.text = ""
        //"(" + "Total payable amount is" + " " + "$" + StrAmounts + ")"
        if self.btnSelectType.titleLabel?.text == "Select Transaction Type"
        {
            
            self.VwBankName.isHidden = true
            self.VwChequeNo.isHidden = true
            self.VwUtrId.isHidden = true
            self.VwTransactionId.isHidden = true
        }
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == txtTransactionId {
//            let maxLength = 25
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//        if textField == txtUTRid {
//            let maxLength = 25
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//        return true
//    }
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc  func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        
        
        self.scrollView.isScrollEnabled = true
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        //viewHieght.constant = contentInsets.bottom
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
        
        //        if tfName != nil
        //        {
        //            if (!aRect.contains(tfName!.frame.origin))
        //            {
        //                self.scrollView.scrollRectToVisible(tfName!.frame, animated: true)
        //            }
        //        }
    }
    func initDatePicker(){
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtTransactionDate.inputAccessoryView = toolbar
        txtTransactionDate.inputView = datePicker
        
    }
    func doValidate()-> Bool{
        var flag = true
        
        if txtTransactionAmount.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_transaction_amount"))
            return false
        }
        if txtTransactionDate.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_select_transaction_date"))
            return false
        }
        
        if VwBankName.isHidden == false
        {
            if txtBankName.text == ""
            {
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_bank_name"))
                return false
            }
        }
        if VwChequeNo.isHidden == false
        {
            if txtChequeno.text == ""
            {
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_cheque_no"))
                return false
            }
        }
        if VwUtrId.isHidden == false
        {
            if txtUTRid.text == ""
            {
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_utr_id"))
                return false
            }
        }
        if VwTransactionId.isHidden == false
        {
            if txtTransactionId.text == ""
            {
                flag = false
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_transaction_id"))
                return false
            }
        }
        if txtTransactionRemark.text == ""{
            flag = false
            self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_transaction_remark"))
            return false
        }
        return flag
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtTransactionDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @IBAction func SaveBtnClick(_ sender:UIButton)
    {
        
        if doValidate(){
            
            doCallApi()
        }
    }
    func  doCallApi()
    {
        
        showProgress()
        var StrChequeNo = ""
        if self.btnSelectType.titleLabel?.text! == "Online"
        {
            StrChequeNo = txtTransactionId.text ?? ""
        }else if self.btnSelectType.titleLabel?.text! == "Cheque"
        {
            StrChequeNo = txtChequeno.text ?? ""
        }
        else if self.btnSelectType.titleLabel?.text! == "UPI"
        {
            StrChequeNo = txtUTRid.text ?? ""
        }else
        {
            StrChequeNo = txtTransactionId.text ?? ""
        }
        
        let params = ["key":apiKey(),
                      "addRequest":"addRequest",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_name":doGetLocalDataUser().userFullName ?? "",
                      "user_type":doGetLocalDataUser().userType ?? "",
                      "paid_for":StrPaidFor,
                      "payment_amount":txtTransactionAmount.text ?? "",
                      "payment_date":txtTransactionDate.text ?? "",
                      "payment_type":itemIndex,
                      "remark":txtTransactionRemark.text ?? "",
                      "request_type":payloadDataPayment.request_type,
                      "maintenance_id":payloadDataPayment.paymentMaintenanceId,
                      "receive_maintenance_id":payloadDataPayment.paymentReceivedMaintenanceId,
                      "bill_master_id":payloadDataPayment.paymentBillId,
                      "receive_bill_id":payloadDataPayment.paymentReceivedBillId,
                      "penalty_id":StrPenaltyId,
                      "balancesheet_id":payloadDataPayment.paymentBalanceSheetId,
                      "bank_name":txtBankName.text ?? "",
                      "cheque_number":StrChequeNo] as [String : Any]
        
        print("params == " , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPostMultipartparms(serviceName: ServiceNameConstants.payment_request_controller, parameters: params, fileURL: self.fileUrl, compression: 0, FileName: "payment_photo"){ (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(addAlreadyPaidPayment.self, from: Data!)
                    if response.status == "200"{
                        self.delegateCustom?.getDataFromAnotherVC(temp: "1")
                        
                        let alertVc = UIAlertController(title: "", message: response.message, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
                            
                            if self.StrPaidFor == "Penalty"
                            {
                                
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: PenaltyVC.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                                
                            }
                            
                            
                        }))
                        self.present(alertVc, animated: true, completion: nil)
                        
                    }else{
                        
                        
                        let alertVc = UIAlertController(title: "", message: response.message, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
                            
                            alertVc.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alertVc, animated: true, completion: nil)
                        
                        
                    }
                    
                }catch{
                    
                }
            }
            
        }
        
    }
    @IBAction func btnSelectRelationClicked(_ sender: UIButton) {
        dropDown.anchorView = btnSelectType
        dropDown.dataSource = ArrSelection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnSelectType.setTitle(self.dropDown.selectedItem, for: .normal)
            itemIndex = String(index)
            if item == "Cash"{
                self.VwBankName.isHidden = true
                self.VwChequeNo.isHidden = true
                self.VwUtrId.isHidden = true
                self.VwTransactionId.isHidden = true
                
            }else if item == "Select Transaction Type" {
                self.VwBankName.isHidden = true
                self.VwChequeNo.isHidden = true
                self.VwUtrId.isHidden = true
                self.VwTransactionId.isHidden = true
                
            }else if item == "Cheque" {
                
                self.VwBankName.isHidden = false
                self.VwChequeNo.isHidden = false
                self.VwUtrId.isHidden = true
                self.VwTransactionId.isHidden = true
                
            }else if item == "Online" {
                
                self.VwBankName.isHidden = true
                self.VwChequeNo.isHidden = true
                self.VwUtrId.isHidden = true
                self.VwTransactionId.isHidden = false
                
            }else if item == "UPI" {
                
                self.VwBankName.isHidden = true
                self.VwChequeNo.isHidden = true
                self.VwUtrId.isHidden = false
                self.VwTransactionId.isHidden = true
                
            }else{
                
                //                self.VwBankName.isHidden = true
                //                self.VwChequeNo.isHidden = true
                //                self.VwUtrId.isHidden = true
                //                self.VwTransactionId.isHidden = true
                
            }
            
        }
        dropDown.width = btnSelectType.frame.width - 30
        dropDown.show()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     print("ddddd")
        
        if textField == txtTransactionAmount
        {
            let regex = try! NSRegularExpression(pattern: "^[0-9]*([.,][0-9]{0,2})?$", options: .caseInsensitive)
            
            if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                return regex.firstMatch(in: newText, options: [], range: NSRange(location: 0, length: newText.count)) != nil
                
            } else {
                return false
            }
        }
        return false
     }
    @IBAction func BackClickEvent(_ sender: UIButton) {
        doPopBAck()
    }
    @IBAction func onClickProfile(_ sender: Any) {
        let alert = UIAlertController(title: doGetValueLanguage(forKey: "select_photos"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "", message:doGetValueLanguage(forKey: "allow_fincasys_to_access_photos_media_files"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ok"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension AlreadyPaidVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        ImgVw.image = selectedImage
        
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
