//
//  TenantDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/07/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FittedSheets
class TenantDetailsVC: BaseVC {
    
    var CountyCode = ""
    @IBOutlet weak var lbFirstName: UILabel!
    @IBOutlet weak var lbLastName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbMobile: UILabel!
    @IBOutlet weak var lbMobileUpside: UILabel!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbEndDate: UILabel!
    @IBOutlet weak var lbFullName: UILabel!
    var user_id = ""
    var memberDetailResponse : MemberDetailResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        doGetdata()
        lbMobileUpside.isHidden = true
    }
    
    func doGetdata(){
        self.showProgress()
        let params = ["getTenantData":"getTenantData",
                      "user_id":user_id]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.tenant_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from: Data!)
                    if response.status == "200"{
                        self.memberDetailResponse = response
                        self.lbFullName.text = response.userFullName
                        self.lbFirstName.text = response.userFirstName
                        self.lbLastName.text = response.userLastName
                        self.lbMobile.text = response.userMobileView
                        self.lbGender.text = response.gender
                        self.lbEmail.text = response.userEmail
                        self.lbStartDate.text = response.tenantAgreementStartDateView
                        self.lbEndDate.text = response.tenantAgreementEndDateView
                        self.lbMobileUpside.text = response.userMobile
                        Utils.setImageFromUrl(imageView: self.ivUser, urlString: response.userProfilePic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
                    }
                }catch{
                    
                }
            }
        }
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onTapPhotoChange(_ sender: Any) {
        openPhotoSelecter()
        
    }
    @IBAction func onTapEditBasic(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idTenantEditBasicInfoVC")as! TenantEditBasicInfoVC
        vc.tenantDetailsVC = self
        vc.memberDetailResponse = self.memberDetailResponse
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(400)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = false
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
    }
    @IBAction func onTapEditDoc(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idTenantAgreementEditVC")as! TenantAgreementEditVC
        vc.tenantDetailsVC = self
        vc.memberDetailResponse = self.memberDetailResponse
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(460)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = false
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
        
        
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
//        actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (UIAlertAction) in
//            // self.doCallRemovePhoto()
//        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil )
    }
    
    func doUpdateBasicInfo(firstName : String ,lastName : String,email : String,gender : String ) {
        
        
        self.showProgress()
        let params = ["setBasicDetails":"setBasicDetails",
                      "user_id":user_id,
                      "user_first_name":firstName,
                      "user_last_name":lastName,
                      "user_email":email,
                      "gender":gender,
                      "society_id" : doGetLocalDataUser().societyID!]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.tenant_controller, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from: Data!)
                    if response.status == "200"{
                        
                        self.doGetdata()
                    }
                }catch{
                    
                }
            }
        }
        
    }
    
    
    
    func doSubmitTenentData(tenant_agreement_start_date:String,tenant_agreement_end_date:String , fileAgreement : [URL],filePolice : [URL]){
        
        self.showProgress()
        let params = ["setAgreementDetails":"setAgreementDetails",
                      "user_id":user_id,
                      "tenant_agreement_start_date":tenant_agreement_start_date,
                      "tenant_agreement_end_date":tenant_agreement_end_date,
                      
                      "society_id" : doGetLocalDataUser().societyID!]
        
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        
        //request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.tenant_controller, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3) { (data, error) in
        
        
        request.requestPostMultipartWithArryaImage(serviceName: ServiceNameConstants.tenant_controller, parameters: params, tenant_doc: fileAgreement, prv_doc: filePolice, compression: 0.3, Arrfname: [], Arrlname: [], Arrmobile: [], ArrRelation: []
                                                    , ArrCountrycode: []) { (data, error) in
        
            
            self.hideProgress()
            if data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                    if response.status == "200"{
                        
                        self.doGetdata()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    
                }
                
            }
            
            
        }
    }
    
    
    
    @IBAction func tapViewAgreement(_ sender: Any) {
        if memberDetailResponse.tenantDoc == nil &&  memberDetailResponse.tenantDoc == "" {
            return
        }
        guard let url = URL(string: memberDetailResponse.tenantDoc) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func tapViewPolice(_ sender: Any) {
        if memberDetailResponse.prvDoc == nil &&  memberDetailResponse.prvDoc == "" {
            return
        }
        guard let url = URL(string: memberDetailResponse.prvDoc) else { return }
        UIApplication.shared.open(url)
    }
}

extension TenantDetailsVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage
        {
            //self.ivProfile.image = img
            print("imagePickerController edit")
            
            self.ivUser.image = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")
            self.ivUser.image = img
        }
        //        self.isImagePick = true
        doUploadProfilePic()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func doUploadProfilePic() {
        showProgress()
        
        if ivUser.image != nil {
            //       user_profile_pic = self.convertImageTobase64(imageView: self.imgProfilePic)
        }
        
        let params = ["setProfilePictureNew":"setProfilePictureNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":user_id,
                      "unit_id":doGetLocalDataUser().unitID!]
        // print(params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartImage(serviceName: ServiceNameConstants.tenant_controller, parameters: params,imageFile: ivUser.image!,fileName: "user_profile_pic",compression: 0.3) { (json, error) in
            self.hideProgress()
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
                        //                        self.isImagePick = false
                        //self.doDisbleUI()
                        //self.doGetProfileData()
                        // Utils.setHomeRootLogin()
                        
                        Utils.setImageFromUrl(imageView: self.ivUser, urlString: response.user_profile_pic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
}
