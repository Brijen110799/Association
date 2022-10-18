//
//  NewRegistrationVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/04/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import DropDown
import MobileCoreServices
import Photos
import SwiftUI
//import OpalImagePicker

class NewRegistrationVC: BaseVC {
    
    @IBOutlet weak var lblplanpackage: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var tfCompanyName: ACFloatingTextfield!
    @IBOutlet weak var tfFirstName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfAreaLocation: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    @IBOutlet weak var tfMemberNumber: ACFloatingTextfield!
    @IBOutlet weak var tfMiddleName: ACFloatingTextfield!
    @IBOutlet weak var tfDateOfJoin: ACFloatingTextfield!
    @IBOutlet weak var tfDateSanad: ACFloatingTextfield!
    @IBOutlet weak var tfAttchJoinProof: ACFloatingTextfield!
    @IBOutlet weak var tfAdvocateCode: ACFloatingTextfield!

    @IBOutlet weak var ivRedioMale: UIImageView!
    @IBOutlet weak var ivRedioFeMale: UIImageView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFeMale: UIView!
   
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrimary: UILabel!
    @IBOutlet weak var lbMemberDetails: UILabel!
    @IBOutlet weak var lbRelationWithMember: UILabel!
    @IBOutlet weak var lbMale: UILabel!
    @IBOutlet weak var lbFemale: UILabel!
    @IBOutlet weak var lbCountyCode: UILabel!
    @IBOutlet weak var bRegister: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var lbAreaSelect: UILabel!
    @IBOutlet weak var viewMainArea: UIView!
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var viewMainCity: UIView!
    @IBOutlet weak var viewMiddleNumber: UIView!
    @IBOutlet weak var viewMemberNumber: UIView!
    @IBOutlet weak var viewAttchJoinProof: UIView!
    @IBOutlet weak var viewDateJoining: UIView!
    @IBOutlet weak var viewDateSanand: UIView!
    @IBOutlet weak var viewAdvocateCode: UIView!

    @IBOutlet weak var viewMainPlan: UIView!
//    @IBOutlet weak var lbPlaneDesc: UILabel!
    @IBOutlet weak var lbSelectedPlan: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var heightConCVData: NSLayoutConstraint!
    @IBOutlet weak var cvJoinProofAttchData: UICollectionView!
    @IBOutlet weak var heightConsJoinProofCV: NSLayoutConstraint!
    var urlString = ""
    private var countryList = CountryList()
    private var countryName = ""
    private var countryCode = ""
    private var phoneCode = ""
    var gender = "Male"
    var society_id = ""
    private var society_address = ""
    var block_id = "0"
    var floor_id = "0"
    var unit_id = "0"
    var block_name = ""
    var country_code = ""
    var packgeid = ""
    var check = ""
    var checkMember = ""
    var unitModel : UnitModel!
    var selectedBlock : BlockModel!
    var areaLocation = [String]()
    var floors = [FloorModel]()
    let dropDown = DropDown()
    var dateSelFieldTag = 0
    var photoType = 0
    var isProfPicSel = false
    var fileName = "Local File"
    private let request = AlamofireSingleTon.sharedInstance
    var isUserInsert = true
    var societyDetails : ModelSociety!
    private var cityData = [CommonCheckModel]()
    private var floorData = [CommonCheckModel]()
    private  let planRenewCell = "PlanRenewCell"
    private var packages = [PackageModel]()
    private var packageModel : PackageModel?
    
    private var associationType = ""
    private var paymentAtRegTime = ""
    private var membJoiningProofReq = ""
    private var membJoiningDateReq = ""
    
    private var advocateCodeReq = ""
    private var profilePhotoReq = ""
    private var sanadDateReq = ""
    
    let itemCell = "DocumentNameCell"

    private var imageLimit = 10
    var agreementImage = [UIImage]()
    var fileAgreement = [URL]()
    var fileUrl: URL!
    
    var isSelectDoc = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfMiddleName.doneAccessory = true
        self.viewMainPlan.isHidden = true
        self.viewDateJoining.isHidden = true
        self.viewAttchJoinProof.isHidden = true
        self.viewDateJoining.isHidden = true
        self.viewDateSanand.isHidden = true
        self.viewAdvocateCode.isHidden = true
        viewMemberNumber.isHidden = true
        viewMiddleNumber.isHidden = true
        self.initView()
    }
    
    private func initView() {
        
        lblplanpackage.text = doGetValueLanguage(forKey: "plan_package_details")
        lbTitle.text = doGetValueLanguage(forKey: "registration_title")
        lbPrimary.text = doGetValueLanguage(forKey: "owner")
        lbMemberDetails.text = doGetValueLanguage(forKey: "verify_your_details")
        lbRelationWithMember.text = doGetValueLanguage(forKey: "please_select_area")
        lbMale.text = doGetValueLanguage(forKey: "male")
        lbFemale.text = doGetValueLanguage(forKey: "female")
    
        tfCompanyName.placeholder = "\(doGetValueLanguage(forKey: "company_name_cum")) *"
        tfAdvocateCode.placeholder = "\(doGetValueLanguage(forKey: "advocate_code")) *"
        tfFirstName.placeholder = "\(doGetValueLanguage(forKey: "first_name"))*"
        tfLastName.placeholder = "\(doGetValueLanguage(forKey: "last_name"))*"
        tfAreaLocation.placeholder = doGetValueLanguage(forKey: "unit_no")
        tfEmail.placeholder = "\(doGetValueLanguage(forKey: "email_id"))*"
        tfMobile.placeholder = "\(doGetValueLanguage(forKey: "mobile_number"))*"
        bRegister.setTitle(doGetValueLanguage(forKey: "register"), for: .normal)
        tfMemberNumber.placeholder = "\(doGetValueLanguage(forKey: "membership_number"))"
        tfDateOfJoin.placeholder = doGetValueLanguage(forKey: "date_of_join") + " *"
        tfDateSanad.placeholder = doGetValueLanguage(forKey: "sanad_date") + " *"
        tfAttchJoinProof.placeholder = doGetValueLanguage(forKey: "attach_rent_agreement") + " *"
       
//     lbPlaneDesc.text = doGetValueLanguage(forKey: "plan_package_details")
         lbSelectedPlan.text =  doGetValueLanguage(forKey: "select_plan")
//     lbSelectedPlan.text =  doGetValueLanguage(forKey: "select_membership_package")

        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfAreaLocation.text = block_name
        tfAreaLocation.isUserInteractionEnabled = false
        selectMale()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addKeyboardAccessory(textFields: [tfCompanyName, tfAdvocateCode, tfMemberNumber, tfDateOfJoin, tfDateSanad, tfFirstName, tfLastName, tfEmail, tfMobile])
        //doGetFlorUnit()
        lbCountyCode.text = country_code
        countryList.delegate = self
        
        
        if !isUserInsert {
            // it mean add more  unit or member ship
            
            tfFirstName.text = doGetLocalDataUser().userFirstName ?? ""
            tfLastName.text = doGetLocalDataUser().userLastName ?? ""
            tfMobile.text =  doGetLocalDataUser().userMobile ?? ""
            country_code =  doGetLocalDataUser().countryCode ?? ""
            lbCountyCode.text = country_code
            tfMobile.isUserInteractionEnabled = false
            Utils.setImageFromUrl(imageView: ivProfile, urlString: doGetLocalDataUser().userProfilePic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        }
        doGetBlock()
        
        let nib = UINib(nibName: planRenewCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: planRenewCell)
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceVertical = true
        
        let itemnib = UINib(nibName: itemCell, bundle: nil)
        cvJoinProofAttchData.register(itemnib, forCellWithReuseIdentifier: itemCell)
        cvJoinProofAttchData.delegate = self
        cvJoinProofAttchData.dataSource = self
        
        heightConsJoinProofCV.constant = 0
        
    }

    
    @IBAction func onClickFeMale(_ sender: Any) {
        //  ivredioFeMale.image = UIImage(named: "radio-selected")
        //  ivredioMale.image = UIImage(named: "radio-blank")
        ivRedioFeMale.setImageColor(color: .white)
        ivRedioMale.setImageColor(color: ColorConstant.primaryColor)
        viewMale.backgroundColor = .clear
        viewFeMale.backgroundColor =  ColorConstant.primaryColor
        gender = "Female"
    }
    @IBAction func onClickMale(_ sender: Any) {
        gender = "Male"
        selectMale()
    }
    
    @IBAction func tapBack(_ sender: Any) {
            doPopBAck()
    }
    
    @IBAction func onTapSelectPhoto(_ sender: Any) {
        photoType = 1
        showAttachmentDialog(msg: "\(doGetValueLanguage(forKey: "upload_photo"))")
    }
    func PackageRegistration(){
       
        var serverDateJoining = ""
        var serverDateSanad1 = ""
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateJoining = formatter.date(from: tfDateOfJoin.text!) {
            formatter.dateFormat = "yyyy-MM-dd"
            serverDateJoining = formatter.string(from: dateJoining)
        }
        
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateSanad = formatter.date(from: tfDateSanad.text!) {
            formatter.dateFormat = "yyyy-MM-dd"
            serverDateSanad1 = formatter.string(from: dateSanad)
        }
        if associationType != "" && associationType == "1" && paymentAtRegTime == "0" {
            
            let fullname = tfFirstName.text! + " " + tfLastName.text!
            
            let params : [String : String] = ["payPacakgeregistration" : "payPacakgeregistration",
                          "society_id":society_id,
                          "society_address" : society_address,
                          "block_id":block_id,
                          "floor_id" : floor_id,
                          "unit_id" : unit_id ,
                          "membership_joining_date": serverDateJoining,
                          "user_middle_name":tfMiddleName.text ?? "",
                          "company_name" : tfCompanyName.text ?? "",
                          "user_first_name" : tfFirstName.text ?? "",
                          "user_last_name" : tfLastName.text ?? "",
                          "user_full_name" : fullname ,
                          "user_mobile" : tfMobile.text ?? "",
                          "user_email" : tfEmail.text ?? "",
                          "user_type" : "0",
                          "user_token" : UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? "",
                          "device":"ios",
                          "gender" : gender,
                          "country_code" : country_code,
                          "unit_name" : tfMemberNumber.text ?? "",
                          "advocate_code": tfAdvocateCode.text ?? "",
                          "sanad_date": serverDateSanad1,
                          "package_amount": packageModel?.package_amount ?? "",
                          "user_profile_pic":convertImageTobase64(imageView: ivProfile)]
            
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER
            model.fileAgreement = self.fileAgreement
            model.paymentForName = packageModel?.package_name ?? ""
            model.paymentDesc = packageModel?.package_name ?? ""
            model.paymentAmount = packageModel?.package_amount  ?? ""
            model.paymentFor  = "Package"
            model.package_id  = packageModel?.package_id ?? ""
            model.paymentBalanceSheetId  = packageModel?.balancesheet_id ?? ""
            model.PaybleAmountComma = packageModel?.package_amount  ?? ""
            model.society_id = society_id
            model.blockID = block_id
            model.floorID = floor_id
            model.userName = fullname
            model.userFirstName = tfFirstName.text ?? ""
            model.userLastName = tfLastName.text ?? ""
            model.userEmail = tfEmail.text ?? ""
            model.userMobile = tfMobile.text ?? ""
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.registerParamter = params
            vc.userTempMail = "1"
           // vc.paymentSucess = self
            self.pushVC(vc: vc)
            
            
          /*  let fullname = tfFirstName.text! + " " + tfLastName.text!
            let params : [String : String] = ["payPacakgeregistration" : "payPacakgeregistration",
                          "society_id":society_id,
                          "society_address" : society_address,
                          "block_id":block_id,
                          "floor_id" : floor_id,
                          "unit_id" : unit_id ,
                          "membership_joining_date": serverDateJoining,
                          "user_middle_name":tfMiddleName.text ?? "",
                          "company_name" : tfCompanyName.text ?? "",
                          "user_first_name" : tfFirstName.text ?? "",
                          "user_last_name" : tfLastName.text ?? "",
                          "user_full_name" : fullname ,
                          "user_mobile" : tfMobile.text ?? "",
                          "user_email" : tfEmail.text ?? "",
                          "user_type" : "0",
                          "user_token" : UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? "",
                          "device":"ios",
                          "gender" : gender,
                          "country_code" : country_code,
                          "unit_name" : tfMemberNumber.text ?? "",
                          "advocate_code": tfAdvocateCode.text ?? "",
                          "sanad_date": serverDateSanad1,
                          "package_amount": packageModel?.package_amount ?? "",
                          "user_profile_pic":convertImageTobase64(imageView: ivProfile)]
            print(fileName)//                society_id = doGetLocalDataUser().societyID ?? ""
//                block_id = doGetLocalDataUser().blockID ?? ""
//                floor_id = doGetLocalDataUser().floorID ?? ""
//                fullname = doGetLocalDataUser().userFullName ?? ""
//                tfFirstName.text = doGetLocalDataUser().userFirstName ?? ""
//                tfLastName.text = doGetLocalDataUser().userLastName ?? ""
//                tfEmail.text = doGetLocalDataUser().userEmail ?? ""
//                tfMobile.text = doGetLocalDataUser().userMobile ?? ""
            let request = AlamofireSingleTon.sharedInstance
            self.request.requestPostMultipartWithFileArryaReg(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, joining_doc: self.fileAgreement, paramName: "joining_doc[]", compression: 0.3) { data, error in
                
                self.hideProgress()
                if data != nil {
                    do {
                        
                        let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                        
                        if response.status == "200" {
                            self.showAlertMessageWithClick(title: "", msg: response.message)
                        } else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error",error as Any)
                    }
                }
            }
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER
            model.paymentForName = packageModel?.package_name ?? ""
            model.paymentDesc = packageModel?.package_name ?? ""
            model.paymentAmount = packageModel?.package_amount  ?? ""
            model.paymentFor  = "Package"
            model.package_id  = packageModel?.package_id ?? ""
            model.paymentBalanceSheetId  = packageModel?.balancesheet_id ?? ""
            model.PaybleAmountComma = packageModel?.package_amount  ?? ""
            model.society_id = society_id
            model.blockID = block_id
            model.floorID = floor_id
            model.userName = fullname
            model.userFirstName = tfFirstName.text ?? ""
            model.userLastName = tfLastName.text ?? ""
            model.userEmail = tfEmail.text ?? ""
            model.userMobile = tfMobile.text ?? ""
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.registerParamter = params
            vc.userTempMail = "1"
           // vc.paymentSucess = self
            self.pushVC(vc: vc)
        } else {
            doSendDataServer()
        }*/
        }
        else {
            doSendDataServer()
        }
        
        
    }
    
    @IBAction func onTapSubmit(_ sender: Any) {

        if isValidate() && check == "2"{
            if (tfMiddleName.text?.isEmptyOrWhitespace())!  {
                tfMiddleName.showErrorWithText(errorText: doGetValueLanguage(forKey: "middle_name_required"))
            }else {
            PackageRegistration()
            }
        }
        if isValidate() && checkMember == "2"{
            if (tfMemberNumber.text?.isEmptyOrWhitespace())!  {
                tfMemberNumber.showErrorWithText(errorText: "please enter valid Membership Number")
            }else {
            PackageRegistration()
            }
        }
        if isValidate() && checkMember == "" && check == "" {
            PackageRegistration()
        }
        
    }
    @IBAction func tapSelectCountry(_ sender: UIButton) {
        
        //tag = sender.tag
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func tapSelectArea(_ sender: UIButton) {

        let vc  = mainStoryboard.instantiateViewController(withIdentifier: "idDialogCommonFilterVC") as! DialogCommonFilterVC
        vc.listData = floorData
        vc.type  = ""
        vc.selectdTitle = lbAreaSelect.text ?? ""
        vc.dataHandler = { (id , name) in
            self.lbAreaSelect.text = name
            self.floor_id = id
        }
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
    }
   
    @IBAction func tapSelectCity (_ sender: UIButton) {
        let vc  = mainStoryboard.instantiateViewController(withIdentifier: "idDialogCommonFilterVC") as! DialogCommonFilterVC
        vc.listData = cityData
        vc.type  = ""
        vc.selectdTitle = lbCityName.text ?? ""
        vc.id = block_id
        vc.dataHandler = { (id , name) in
            self.lbCityName.text = name
            self.block_id = id
            self.doGetFlorUnit(block_id: id)
            self.resetAreaData()
        }
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
    }
    
    @IBAction func tapJoiningDate(_ sender: UIButton) {
        
        dateSelFieldTag = sender.tag
        let formatter = DateFormatter()
        var selDate : Date?
        formatter.dateFormat = "yyyy-MM-dd"
        if sender.tag == 1 {
            if tfDateOfJoin.text != "" {
                if let date = formatter.date(from: tfDateOfJoin.text!) {
                    selDate = date
                }
            }
        }
        else {
            if tfDateSanad.text != "" {
                if let date = formatter.date(from: tfDateSanad.text!) {
                    selDate = date
                }
            }
        }
        
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: nil, maximumDate: Date(), currentDate: selDate)
        vc.view.frame = view.frame
        addPopView(vc: vc)
        
    }
    
    @IBAction func tapBtnAttachJoiningProof(_ sender: Any) {
        
        if fileAgreement.count != 10 {
            imageLimit =  10 - agreementImage.count
            photoType = 2
            self.showAttachmentDialog(msg: doGetValueLanguage(forKey: "select_option"), isShowFile: true)
        } else {
            showAlertMessage(title: "", msg: "Select maximum 10 documents")
        }
        
    }
    
    private func selectMale() {
        ivRedioMale.setImageColor(color: .white)
        ivRedioFeMale.setImageColor(color: ColorConstant.primaryColor)
        viewMale.backgroundColor = ColorConstant.primaryColor
        viewFeMale.backgroundColor = .clear
    }
    
    override func tapOpenMedia(type: MediaType) {
        if photoType == 1 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            if type == .camera {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            if type == .gallery {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        else {
            if type == .camera {
                self.openCamera()
            }
            if type == .gallery {
                self.openGallery()
            }
            if type == .fileExplore {
                self.attachDocument()
            }
            
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
    
    func openGallery() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case .authorized:
            
            DispatchQueue.main.async {
                
//                    let imagePicker = OpalImagePickerController()
//                     imagePicker.maximumSelectionsAllowed = imageLimit
//                     imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
//                     imagePicker.selectionImageTintColor = UIColor.black
//                     imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
//                     imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
//                     imagePicker.imagePickerDelegate = self
//                     imagePicker.modalPresentationStyle = .formSheet
//                     self.present(imagePicker, animated: true, completion: nil)
                
                let imagePicker = OpalImagePickerController()
                imagePicker.maximumSelectionsAllowed = self.imageLimit
                imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
                imagePicker.selectionImageTintColor = UIColor.black
                imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
                imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                imagePicker.imagePickerDelegate = self
                imagePicker.modalPresentationStyle = .formSheet
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            break
        //handle authorized status
        case .denied, .restricted :
           showAlertMessageWithClick(title: "", msg: "Need to access photos permision for select images.")
//            showAlertMessage(title: "", msg: "Need to access photos permision for select images")
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.openGallery()
                }
                
//                switch status {
//                case .authorized:
//                    self.openGallery()
//                    break
//                // as above
//                case .denied, .restricted: break
//                // as above
//                case .notDetermined: break
//                // won't happen but still
//                case .limited:
//                    break
//                @unknown default:
//                    break
//                }
            }
        case .limited:
            break
        @unknown default:
            break
        }
    }
     
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.accessibilityLabel = "01"
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
    
//    override func tapOpenMedia(type: MediaType) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//
//        if type == .camera {
//            imagePicker.sourceType = .camera
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//
//        if type == .gallery {
//            imagePicker.sourceType = .photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//
//    }
    
    
   
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
    }
    
   
    private func isValidate() -> Bool {
        
        var isValidate = true
        
        if profilePhotoReq == "1" && !isProfPicSel {
            isValidate = false
            self.toast(message: doGetValueLanguage(forKey: "profile_pic_required"), type: .Faliure)
        }else if  (tfCompanyName.text?.isEmptyOrWhitespace())!  {
            isValidate = false
            tfCompanyName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_company_name"))
        }else if (tfAdvocateCode.text?.isEmptyOrWhitespace())! && advocateCodeReq == "1"  {
            isValidate = false
            tfAdvocateCode.showErrorWithText(errorText: doGetValueLanguage(forKey: "advocate_code_required"))
        }else if (tfDateOfJoin.text?.isEmptyOrWhitespace())! && membJoiningDateReq == "1" {
            isValidate = false
            tfDateOfJoin.showErrorWithText(errorText: doGetValueLanguage(forKey: "date_of_join_required"))
        }else if (tfDateSanad.text?.isEmptyOrWhitespace())!  &&  sanadDateReq == "1" {
            isValidate = false
            tfDateSanad.showErrorWithText(errorText: doGetValueLanguage(forKey: "sanad_date_required"))
        } else if fileAgreement.count == 0 && membJoiningProofReq == "1" {
            isValidate = false
            self.toast(message: doGetValueLanguage(forKey: "date_of_join_doc_required"), type: .Faliure)
//            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "date_of_join_doc_required"))")
        }else if  (tfFirstName.text?.isEmptyOrWhitespace())!  {
            isValidate = false
            tfFirstName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_first_name"))
            
        }else if (tfLastName.text?.isEmptyOrWhitespace())!  {
            isValidate = false
            tfLastName.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_last_name"))
        }else if (tfEmail.text?.isEmptyOrWhitespace())! {
            isValidate = false
            tfEmail.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_email_id"))
        }else  if !isValidEmail(email: tfEmail.text!) {
            isValidate = false
            tfEmail.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_email_id"))
        }else if  tfMobile.text!.count < 8 {
            isValidate = false
            tfMobile.showErrorWithText(errorText: doGetValueLanguage(forKey: "please_enter_valid_mobile_number"))
        }else if floor_id == "" && isValidate {
//            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "select_area"))")
            self.toast(message: doGetValueLanguage(forKey: "select_area"), type: .Faliure)
            isValidate = false
        }else if associationType != "" && associationType == "1" && paymentAtRegTime == "0" && isValidate {
            if packageModel == nil {

                self.toast(message: doGetValueLanguage(forKey: "select_plan"), type: .Faliure)
                isValidate = false
            }
        }
        
        return isValidate
    }
    
    private func doSendDataServer() {
        self.showProgress()
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        
        //        let params = ["addPrimaryUser": "addPrimaryUser", "society_id": society_id, "society_address" : society_address, "block_id":block_id, "floor_id" : floor_id, "unit_id" : unit_id, "company_name" : tfCompanyName.text ?? "", "user_first_name" : tfFirstName.text ?? "", "user_last_name" : tfLastName.text ?? "", "user_full_name" : fullname, "user_mobile" : tfMobile.text ?? "", "user_email" : tfEmail.text ?? "", "user_type" : "0", "user_token" : UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? "", "device": "ios", "gender" : gender, "country_code" : country_code, "unit_name" : tfMemberNumber.text ?? "", "advocate_code" : tfAdvocateCode.text ?? "", "membership_joining_date" : tfDateOfJoin.text ?? "", "sanad_date" : tfDateSanad.text ?? "", "package_amount": "", "user_profile_pic":convertImageTobase64(imageView: ivProfile)]
        
        let token = UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? ""
        
        var serverDateJoining = ""
        var serverDateSanad = ""
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateJoining = formatter.date(from: tfDateOfJoin.text!) {
            formatter.dateFormat = "yyyy-MM-dd"
            serverDateJoining = formatter.string(from: dateJoining)
        }
        
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateSanad = formatter.date(from: tfDateSanad.text!) {
            formatter.dateFormat = "yyyy-MM-dd"
            serverDateSanad = formatter.string(from: dateSanad)
        }
        
        
        let params : [String: String] = ["addPrimaryUser": "addPrimaryUser",
                                         "society_id": society_id,
                                         "society_address" : society_address,
                                         "block_id":block_id,
                                         "floor_id" : floor_id,
                                         "unit_id" : unit_id,
                                         "membership_joining_date" : serverDateJoining,
                                         "company_name" : tfCompanyName.text ?? "",
                                         "user_first_name" : tfFirstName.text ?? "",
                                         "user_last_name" : tfLastName.text ?? "",
                                         "user_middle_name":tfMiddleName.text ?? "",
                                         "user_full_name" : fullname,
                                         "user_mobile" : tfMobile.text ?? "",
                                         "user_email" : tfEmail.text ?? "",
                                         "user_type" : "0",
                                         "user_token" : token,
                                         "device": "ios",
                                         "gender" : gender,
                                         "country_code" : country_code,
                                         "unit_name" : tfMemberNumber.text ?? "",
                                         "advocate_code" : tfAdvocateCode.text ?? "",
                                         "sanad_date" :  serverDateSanad,
                                         "package_amount": "",
                                         "user_profile_pic":convertImageTobase64(imageView: ivProfile)]
        
        var baseUrl = ""
        if !isUserInsert {
            baseUrl = self.baseUrl()
        } else {
            baseUrl =  self.societyDetails.sub_domain! + StringConstants.APINEW
        }
        
        //        request.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params,baseUer: baseUrl) { (data, error) in
        
        self.request.requestPostMultipartWithFileArryaReg(serviceName: ServiceNameConstants.residentRegisterController, parameters: params, joining_doc: self.fileAgreement, paramName: "joining_doc[]", compression: 0.3) { data, error in
            
        
            self.hideProgress()
            if data != nil {
                do {
                    
                    let response = try JSONDecoder().decode(ResponseRegistration.self, from:data!)
                    
                    if response.status == "200" {
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    } else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error",error as Any)
                }
            }
        }
    }
   
    
    private  func doGetFlorUnit(block_id  : String) {
        showProgress()
        let params = ["key":apiKey(),
                      "getFloorandUnit":"getFloorandUnit",
                      "society_id":society_id,
                      "block_id":block_id]
         
        print("param" , params)
        var url = ""
        if !isUserInsert{
            url = baseUrl()
        } else {
            url = "\(societyDetails.sub_domain ?? "")\(StringConstants.APINEW)"
        }
       
            
        request.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params,baseUer: url) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(FloorResponse.self, from:json!)
                    
                    if response.status == "200" {
                        
                        if let array = response.floors {
                            self.floors = array
                            
                            
                           // self.lbAreaSelect.text = self.floors[0].floor_name ?? ""
                            //self.floor_id = self.floors[0].floor_id ?? ""
                            if array.count == 1 {
                                self.viewMainArea.isHidden = true
                                 self.lbAreaSelect.text = self.floors[0].floor_name ?? ""
                                 self.floor_id = self.floors[0].floor_id ?? ""
                               
                            }else {
                                self.floorData.removeAll()
                                self.viewMainArea.isHidden = false
                                for item in array {
                                    //self.areaLocation.append(item.floor_name ?? "")
                                    self.floorData.append(CommonCheckModel(title: item.floor_name, id: item.floor_id))
                                }
                                self.resetAreaData()
                                self.lbAreaSelect.text = self.floors[0].floor_name ?? ""
                                self.floor_id = self.floors[0].floor_id ?? ""
                            }
                        }
                    }else {
                        self.showAlertMessageWithClick(title:  "", msg: response.message)
                        
                    }
                    
                } catch {
                    print("floor error",error as Any)
                }
            }
          }
     }
    
    override func onClickDone() {
        if isUserInsert {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginVC.self) || controller.isKind(of: AddBuildingLoginVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            Utils.setHome()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == tfFirstName ||  textField == tfLastName {
            let cs = NSCharacterSet(charactersIn: StringConstants.ACCEPTABLE_CHARACTERS).inverted
               let filtered = string.components(separatedBy: cs).joined(separator: "")
               
               return (string == filtered)
           }
           return true
       }
    
    private func doGetBlock() { 
        
        self.showProgress()
        let params = ["key":apiKey(),
                      "getBlocks":"getBlocks",
                      "society_id":society_id]
        
        var url = ""
        if !isUserInsert{
            url = baseUrl()
        } else {
            url = "\(societyDetails.sub_domain ?? "")\(StringConstants.APINEW)"
        }
        
        AlamofireSingleTon.sharedInstance.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params,baseUer: url) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BlockResponse.self, from:json!)
                    if response.status == "200" {
                        if response.membership_number_auto_generate  == "0"{
                            self.viewMemberNumber.isHidden = true
                        }
                        
                        if response.membership_number_auto_generate == "1"{
                            self.viewMemberNumber.isHidden = false
                        }
                        if response.membership_number_auto_generate == "2"{
                            self.viewMemberNumber.isHidden = false
                            self.checkMember = "2"
                        }
                        if response.middle_name_action == "0"{
                            self.tfMiddleName.placeholder = self.doGetValueLanguage(forKey: "middle_name")
                            self.viewMiddleNumber.isHidden = false
                        }
                        if response.middle_name_action == "1"{
                            self.viewMiddleNumber.isHidden = true
                        }
                        if response.middle_name_action == "2"{
                            self.tfMiddleName.placeholder = self.doGetValueLanguage(forKey: "middle_name") + " *"
                            self.viewMiddleNumber.isHidden = false
                            self.check = "2"
                        }
                        
                        
                        if response.block.count == 1 {
                            self.block_id = response.block[0].block_id ?? ""
                            self.viewMainCity.isHidden = true
                            self.doGetFlorUnit(block_id: self.block_id)
                        } else  {
                            
                            for item in response.block ?? [] {
                                self.cityData.append(CommonCheckModel(title: item.block_name
                                                                      ?? "", id: item.block_id
                                                                      ?? ""))
                            }
                            
                            self.block_id = response.block[0].block_id ?? ""
                            self.lbCityName.text  = response.block[0].block_name ?? ""
                            self.doGetFlorUnit(block_id: self.block_id)
                            self.resetAreaData()
                        }
                        
                        if let defCompName = response.default_company_name {
                            self.tfCompanyName.text = defCompName
                        }
                                                
                        if let profPhotoReq = response.profile_photo_required {
                            self.profilePhotoReq = profPhotoReq
                        }
                        
                        if let advCodeReq = response.advocate_code_required {
                            self.advocateCodeReq = advCodeReq
                            if advCodeReq == "1" {
                                self.viewAdvocateCode.isHidden = false
                            }
                        }
                        
                        if let memJoinDateReq = response.membership_joining_date_require {
                            self.membJoiningDateReq = memJoinDateReq
                            if memJoinDateReq == "1" {
                                self.viewDateJoining.isHidden = false
                            }
                        }
                        
                        if let sanDateReq = response.sanad_date_required {
                            self.sanadDateReq = sanDateReq
                            if sanDateReq == "1" {
                                self.viewDateSanand.isHidden = false
                            }
                        }
                        
                        if let memJoinProofReq = response.membership_joining_proof_required {
                            self.membJoiningProofReq = memJoinProofReq
                            if memJoinProofReq == "1" {
                                self.viewAttchJoinProof.isHidden = false
                            }
                        }
                        
                        if let paymAtRegTime = response.payment_at_registration_time {
                            self.paymentAtRegTime = paymAtRegTime
                        }
                        
                        if let assoType = response.association_type {
                            self.associationType = assoType
                        }
                        
                        if let arrayPackages = response.package {
                            self.packages = arrayPackages
                        }
                        
                        if self.associationType == "1" && self.paymentAtRegTime == "0" {
                            self.viewMainPlan.isHidden = false
                            
                            DispatchQueue.main.async {
                                self.cvData.reloadData()
                            }
                        }
                    } else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("block error",error as Any)
                }
            }
        }
    }
    
    private func resetAreaData() {
        self.lbAreaSelect.text = self.doGetValueLanguage(forKey: "select_area")
        self.floor_id = ""
    }
    override func viewDidLayoutSubviews() {
        if packages.count > 0 {
            DispatchQueue.main.async {
                self.heightConCVData.constant = self.cvData.contentSize.height + 10
            }
        }
    }
    
}

extension NewRegistrationVC : OpalImagePickerControllerDelegate{

    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
//        if assets.count > 0 {
//            var images = [UIImage]()
//            for asset in assets {
//                images.append(self.getAssetThumbnailNew(asset: asset))
//            }
//            self.convertToPdf(imagerArry: images)
//        }
        
        if assets.count > 0 {
            if isSelectDoc {
                isSelectDoc = false
                self.fileAgreement.removeAll()
            }

            var images = [UIImage]()
            for asset in assets {
                images.append(self.getAssetThumbnailNew(asset: asset))
                self.agreementImage.append(self.getAssetThumbnailNew(asset: asset))
            }
            self.convertToPdf(imagerArry: images)

//            for (index, asset) in assets.enumerated() {
//
//                // self.fileAgreement.append(URL(string: asset.originalFilename!)!)
//                let imgName = asset.originalFilename ?? "proof_image_sel_\(index)"
//                let documentDirectory = NSTemporaryDirectory()
//                let localPath = documentDirectory.appending(imgName)
//                let assetImg = self.getAssetThumbnailNew(asset: asset)
//
//                let data = assetImg.jpegData(compressionQuality: 0)! as NSData
//                data.write(toFile: localPath, atomically: true)
//                let imageURL = URL.init(fileURLWithPath: localPath)
//                self.fileAgreement.append(imageURL)
//                self.agreementImage.append(self.getAssetThumbnailNew(asset: asset))
//            }

//            if self.agreementImage.count > 0 {
//                self.heightConsJoinProofCV.constant = 35
//            }
//
//            DispatchQueue.main.async {
//                self.cvJoinProofAttchData.reloadData()
//            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        //        if images.count > 0 {
        //            convertToPdf(imagerArry: images)
        //        }
        //        dismiss(animated: true, completion: nil)
    }
    
}
 
extension NewRegistrationVC : UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
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
            heightConsJoinProofCV.constant = 35
            DispatchQueue.main.async {
                self.cvJoinProofAttchData.reloadData()
            }
        } else {
            self.showAlertMessage(title: "", msg: "File Format not support.")
        }
                
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        picker.dismiss(animated: true, completion: nil)
    //        guard let selectedImage = info[.originalImage] as? UIImage else {
    //            print("Image not found!")
    //            return
    //        }
    //        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
    //
    ////            let imgName = UUID().uuidString + ".jpeg"
    ////            let documentDirectory = NSTemporaryDirectory()
    ////            let localPath = documentDirectory.appending(imgName)
    ////
    ////            let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
    ////            data.write(toFile: localPath, atomically: true)
    ////            let imageURL = URL.init(fileURLWithPath: localPath)
    //           // self.fileUrl = imageURL
    //           //self.lblFileUrl.text = "\(imageURL)"
    //            convertToPdf(imagerArry: [selectedImage])
    //        } else {
    //            let imageURL = info[.imageURL] as! URL
    ////            self.fileUrl = imageURL
    ////            self.lblFileUrl.text = "\(imageURL)"
    //        }
    //    }
    
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
            let fileName = "document.pdf"
            let documentsFileName = "file://\( documentDirectories + "/" + fileName)"
            let pdfData = pdf.generatePDFdata()
            let pdfURl:URL = URL(string: documentsFileName)!
            do{
                try pdfData.write(to: pdfURl, options: .atomicWrite)
                //                print("\nThe generated pdf can be found at:")
                //                print("\n\t\(documentsFileName)\n")
//                                self.fileUrl = pdfURl
                //                self.lblFileUrl.text = "\(pdfURl)"
                self.fileAgreement.append(pdfURl)
                if self.agreementImage.count > 0 {
                    self.heightConsJoinProofCV.constant = 35
                }

                DispatchQueue.main.async {
                    self.cvJoinProofAttchData.reloadData()
                }
            }catch{
                print(error)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage = UIImage()
        if let imageS = info[.originalImage] as? UIImage  {
            selectedImage = imageS
        } else {
            return
        }
        
        if let imageS = info[.editedImage] as? UIImage  {
            selectedImage = imageS
        } else {
            return
        }
        
        if picker.accessibilityLabel == "01" {
            
            if picker.sourceType == .camera {
                
                let imgName = UUID().uuidString + ".jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
                data.write(toFile: localPath, atomically: true)
                let imageURL = URL.init(fileURLWithPath: localPath)
                
                if isSelectDoc {
                    isSelectDoc = false
                    self.fileAgreement.removeAll()
                }
                
                self.fileAgreement.append(imageURL)
                self.agreementImage.append(selectedImage)
                
                if self.agreementImage.count > 0 {
                    self.heightConsJoinProofCV.constant = 35
                }
                
                DispatchQueue.main.async {
                    self.cvJoinProofAttchData.reloadData()
                }
            }
        }
        else {
            self.ivProfile.image = selectedImage
            self.isProfPicSel = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension NewRegistrationVC : OnSelectDate {
    
    func onSelectDate(dateString: String, date: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if dateSelFieldTag == 1 {
            tfDateOfJoin.text = formatter.string(from: date)
        }
        else if dateSelFieldTag == 2 {
            tfDateSanad.text = formatter.string(from: date)
        }
    }
}

extension NewRegistrationVC : CountryListDelegate {
    func selectedCountry(country: Country) {
        country_code = "+\(country.phoneExtension)"
        lbCountyCode.text = country_code
     }
    
}

extension NewRegistrationVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OnClickDeleteImage {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvData {
            return packages.count
        }
        else {
            return fileAgreement.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvData {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planRenewCell, for: indexPath) as! PlanRenewCell
            cell.lblDiscountedPrice.text = ""
            cell.vwDesh.isHidden = true
            cell.btnChoose.setTitle("", for: .normal)
            cell.lbTitleBtn.text = "CHOOSE".uppercased()
            
            if self.packages.count > indexPath.item {
                let package = self.packages[indexPath.item]
                if let packagePrice = package.package_amount {
                    cell.lblPlanPrice.text = "\(societyDetails.currency ?? "")\(packagePrice)"
                }
                cell.lblPlanTitle.text = package.package_name ?? ""
                cell.btnChoose.tag = indexPath.item
                cell.btnChoose.addTarget(self, action: #selector(choosePackage(sender:)), for: .touchUpInside)
                
                cell.contentView.borderWidth = 2.0
                cell.contentView.borderColor = .clear
                cell.contentView.cornerRadius = 10.0
                cell.contentView.clipsToBounds = true
                if packgeid == package.package_id {
                    cell.contentView.borderColor = ColorConstant.primaryColor
                }
            }
            
            return cell
            
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentNameCell
            if fileAgreement.count > indexPath.row {
                cell.index = indexPath.row
                cell.onClickDeleteImage = self
                print(fileAgreement)
         
                
                let url = fileAgreement[indexPath.row]
                if url.lastPathComponent != "" {
                    fileName = url.lastPathComponent
                }
                cell.lbTitle.text = fileName
//                cell.lbTitle.text = fileAgreement[indexPath.row].absoluteString
                cell.type = "agrement"
                urlString = url.absoluteString
                print(urlString)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == cvData {
            return 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
//        if collectionView == cvData {
//            return 1
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvData {
            let cvWidth = (cvData.frame.size.width - 2) / 2
            return CGSize(width: cvWidth, height: cvWidth * 1.5)
        }
        else {
            let cvWidth = collectionView.frame.size.width / 2.5
            return CGSize(width: cvWidth, height: collectionView.frame.size.height)
        }
    }
    
    @objc func choosePackage(sender : UIButton) {
        
        if packages.count > sender.tag {
            let package = packages[sender.tag]
            packageModel = package
            self.packgeid = package.package_id ?? ""
//            if let packagename = package.package_name {
//                let text = doGetValueLanguage(forKey: "select_plan") + " - \(packagename)"
//                self.toast(message: text, type: .Defult)
//            }
            cvData.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    
    func onClickDeleteImage(index: Int, type: String) {
        
        if type == "agrement" {
            fileAgreement.remove(at: index)
            if agreementImage.count > 0 {
                agreementImage.remove(at: index)
            }
            if fileAgreement.count == 0 {
                heightConsJoinProofCV.constant = 0
            }
            cvJoinProofAttchData.reloadData()
        }
    }
    
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
