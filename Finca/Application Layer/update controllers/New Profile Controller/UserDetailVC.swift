//
//  UserDetailVC.swift
//  Work
//
//  Created by Silverwing Macmini1 on 12/02/20.
//  Copyright © 2020 Silverwing Macmini1. All rights reserved.
//

import UIKit
import FittedSheets
class UserDetailVC: BaseVC {
    
    @IBOutlet weak var vwMid: UIView!
    
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblHouseNumber: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblAltMobileNumber: UILabel!
    @IBOutlet weak var viewOwnerDetails: UIView!
    @IBOutlet weak var lblFbLink: UITextField!
    @IBOutlet weak var lblinstaLink: UITextField!
    @IBOutlet weak var lblLinkedinLink: UITextField!
    @IBOutlet weak var lblBloodGroup: UILabel!
    var PopUpFlag = Bool()
    @IBOutlet weak var viewAltNumber: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblOwnerInfoTitle: UILabel!
    @IBOutlet weak var lblEditTitle: UILabel!
    @IBOutlet weak var lblBasicInfoTitle: UILabel!
    @IBOutlet weak var lblContactInfoTitle: UILabel!
    @IBOutlet weak var lblSocialAccountLink: UILabel!
    @IBOutlet weak var lblEditBasicInfo: UILabel!
    @IBOutlet weak var lblEditContact: UILabel!
    @IBOutlet weak var lblEditSocial: UILabel!
    @IBOutlet weak var lblOwnerFirstName: UILabel!
    @IBOutlet weak var lblOwnerHouseNoTitle: UILabel!
    @IBOutlet weak var lblBasicFirstName: UILabel!
    @IBOutlet weak var lblBasicLastName: UILabel!
    @IBOutlet weak var lblBasicDOB: UILabel!
    @IBOutlet weak var lblBasicGender: UILabel!
    @IBOutlet weak var lblBasicBloodGroup: UILabel!
    @IBOutlet weak var lblEmailIDTItle: UILabel!
    @IBOutlet weak var lblMobileNumberTitle: UILabel!
    @IBOutlet weak var lblAlternateMobileNOTitle: UILabel!
    @IBOutlet weak var viewmid: UIView!
    @IBOutlet weak var lblMiddlename: UILabel!
    @IBOutlet weak var lblBasicmiddname: UILabel!
    @IBOutlet weak var viewEditOnwerDetails: UIView!
    var userProfileReponse : MemberDetailResponse!
    var menuTitle = ""
    var check = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitUI()
        lblScreenTitle.text = doGetValueLanguage(forKey: "about_me")
        lblOwnerInfoTitle.text = doGetValueLanguage(forKey: "owner_detail")
        lblBasicInfoTitle.text = doGetValueLanguage(forKey: "basic_info")
        lblContactInfoTitle.text = doGetValueLanguage(forKey: "contact_info")
        lblSocialAccountLink.text = doGetValueLanguage(forKey: "social_account_link")
        lblOwnerFirstName.text = doGetValueLanguage(forKey: "owner_name")
        lblOwnerHouseNoTitle.text = doGetValueLanguage(forKey: "mobile_no")
        lblBasicFirstName.text = doGetValueLanguage(forKey: "first_name_about_info")
        lblBasicLastName.text = doGetValueLanguage(forKey: "last_name_about_info")
        lblBasicDOB.text = doGetValueLanguage(forKey: "date_of_birth")
        lblBasicGender.text = doGetValueLanguage(forKey: "gender")
        lblBasicBloodGroup.text = doGetValueLanguage(forKey: "blood_group")
        lblEditTitle.text = doGetValueLanguage(forKey: "edit")
        lblEditBasicInfo.text = doGetValueLanguage(forKey: "edit")
        lblEditContact.text = doGetValueLanguage(forKey: "edit")
        lblEditSocial.text = doGetValueLanguage(forKey: "edit")
        lblEmailIDTItle.text = doGetValueLanguage(forKey: "email_ID")
        lblMobileNumberTitle.text = doGetValueLanguage(forKey: "mobile_no")
        lblAlternateMobileNOTitle.text = doGetValueLanguage(forKey: "alternate_mobile_number")
        lblFbLink.placeholder(doGetValueLanguage(forKey: "no_link_added"))
        lblinstaLink.placeholder(doGetValueLanguage(forKey: "no_link_added"))
        lblLinkedinLink.placeholder(doGetValueLanguage(forKey: "no_link_added"))
    }
    func doInitUI(){
        
        
        if let midNameActionFlag = doGetLocalDataUser().middle_name_action {
            self.viewmid.isHidden = (midNameActionFlag == "1")
         self.vwMid.isHidden = (midNameActionFlag == "1")
        }
        

        lblOwnerName.text = self.userProfileReponse.ownerName
        lblHouseNumber.text = userProfileReponse.countryCode + " " + self.userProfileReponse.ownerMobile
        
        if let dateOfBirth = self.userProfileReponse.memberDateOfBirthSet {
           // print(doGetValueLanguage(forKey: "not_available"))
            
            if dateOfBirth != (doGetValueLanguage(forKey: "not_available") + " ") {
            if dateOfBirth != "" && dateOfBirth.count > 4 {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                let date = dateFormat.date(from: dateOfBirth)
                dateFormat.dateFormat = "dd-MM-yyyy"
                lblDateOfBirth.text = dateFormat.string(from: date ?? Date())
            } else {
                lblDateOfBirth.text = doGetValueLanguage(forKey: "not_available")
            }
            }else
            {
                lblDateOfBirth.text = doGetValueLanguage(forKey: "not_available")
            }
        }else {
            lblDateOfBirth.text = doGetValueLanguage(forKey: "not_available")
        }
       
        lblFirstName.text = self.userProfileReponse.userFirstName
        lblMiddlename.text = self.userProfileReponse.user_middle_name
        lblLastName.text = self.userProfileReponse.userLastName
        lblEmailID.text = self.userProfileReponse.userEmail
        lblMobileNumber.text = userProfileReponse.countryCode + " " + self.userProfileReponse.userMobile
        lblAltMobileNumber.text = userProfileReponse.countryCodeAlt + self.userProfileReponse.altMobile
        if self.userProfileReponse.altMobile == "0"  {
            lblAltMobileNumber.text = ""
        }
       
        if self.userProfileReponse.blood_group ?? "" == "" || self.userProfileReponse.blood_group.lowercased() == "select"  {
            lblBloodGroup.text = doGetValueLanguage(forKey: "not_available")
        } else {
            lblBloodGroup.text = self.userProfileReponse.blood_group
        }
        
        
       // viewAltNumber.isHidden = self.userProfileReponse.altMobile == "0" ? true : false
        self.lblGender.text = self.userProfileReponse.gender
        self.lblLinkedinLink.text = ""
        self.lblFbLink.text = ""
        self.lblinstaLink.text = ""
        if self.userProfileReponse.linkedin != ""{
            self.lblLinkedinLink.text = self.userProfileReponse.linkedin
        }
        if self.userProfileReponse.facebook != ""{
            self.lblFbLink.text = self.userProfileReponse.facebook
        }
        if self.userProfileReponse.instagram != ""{
            self.lblinstaLink.text = self.userProfileReponse.instagram
        }
        switch userProfileReponse.userType {
        case "0":
//            userType = "Owner"
            self.viewOwnerDetails.isHidden = true
        case "1":
//            userType = "Tenant"
            self.viewOwnerDetails.isHidden = false
            self.viewEditOnwerDetails.isHidden = true
            
        default:
            break;
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doInitUI()
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func doGetProfile(){
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                        self.userProfileReponse = response
                        self.doInitUI()
                        
//                        if response.middle_name_action == "0"{
//                            self.viewmid.isHidden = false
//                        }
//                        if response.middle_name_action == "2"{
//                            self.viewmid.isHidden = false
//                            self.check = "2"
//                        }
                        
                    }else{
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doCallUpdateApi(firstName:String!,
                         middleName:String!,
                         lastName:String!,
                         email:String!,
                         alt_mobile:String!,
                         DOB:String!,
                         facebook:String!,
                         instagram:String!,
                         linkedin:String!,
                         gender:String!,
                         blood_group:String,
                         usermobile:String,
                         phoneCode1:String!,
                         phoneCode:String!){
        showProgress()
        let full_name = "\(firstName!) \(lastName!)"

        var bG  = ""
        
        if blood_group.contains(doGetValueLanguage(forKey: "not_available")){
            bG = ""
        } else {
            bG = blood_group
        }
        var member_date_of_birth = ""
        if DOB.contains(doGetValueLanguage(forKey: "not_available")){
            member_date_of_birth = ""
        } else {
            member_date_of_birth = DOB
        }
        let params = ["key":apiKey(),
                      "setProsnalDetails":"setProsnalDetails",
                      "user_full_name":  full_name,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_first_name":firstName!,
                      "user_middle_name":middleName!,
                      "user_last_name":lastName!,
                      "user_email":email!,
                      "alt_mobile":alt_mobile!,
                      "member_date_of_birth":member_date_of_birth,
                      "facebook":facebook!,
                      "instagram":instagram!,
                      "linkedin":linkedin!,
                      "gender":gender!,
                      "blood_group":bG,
                      "new_mobile":usermobile,
                      "country_code": userProfileReponse.countryCode ?? "+91",
                      "country_code_alt":userProfileReponse.countryCodeAlt ?? "+91"]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                       // print(response.otp_popup)
                        self.PopUpFlag = response.otp_popup
                        
                       
                        Utils.updateLocalUserData()
                        self.doGetProfile()
                        self.toast(message: response.message, type: .Information)
//                        self.showAlertMessage(title: "", msg: response.message)
                    }else {
//                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func basicInfoEditClicked(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "idEditBasicInfoVC")as! EditBasicInfoVC
       vc.userProfileReponse = self.userProfileReponse
        vc.context = self
     
       
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(520)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = false
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
    }
    @IBAction func onClickContactInfo(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idEditContactInfoVC")as! EditContactInfoVC
        vc.context = self
        vc.userProfileReponse = self.userProfileReponse
        vc.StrComeFromContactInfo = "1"
        addPopView(vc: vc)
        
//        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(310)])
//        sheetController.blurBottomSafeArea = false
//        sheetController.adjustForBottomSafeArea = false
//        sheetController.topCornersRadius = 0
//        sheetController.topCornersRadius = 15
//        sheetController.dismissOnBackgroundTap = false
//        sheetController.dismissOnPan = true
//        sheetController.extendBackgroundBehindHandle = true
//        sheetController.handleColor = UIColor.white
//        self.present(sheetController, animated: false, completion: nil)
    }
    @IBAction func onClickeditSocialLink(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idSocialViewVC")as! SocialViewVC
        vc.context = self
        var sHeight = 300
        if let flag = doGetLocalDataUser().middle_name_action{
            if flag == "1" {
                sHeight = 300
            }
        }
        vc.userProfileReponse = self.userProfileReponse
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(CGFloat(sHeight))])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 0
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.extendBackgroundBehindHandle = true
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
        
    }
 
    
    
    func doUpdateData() {
        doGetProfile()
        DispatchQueue.global(qos: .background).async {
            Utils.updateLocalUserData()
        }
    }
}
