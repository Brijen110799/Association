//
//  ProfessionalDetailBS.swift
//  Finca
//
//  Created by harsh panchal on 06/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Lightbox

class ProfessionalDetailBS: BaseVC {
    var userProfileReponse : MemberDetailResponse!

    @IBOutlet weak var lblMemberUnitInfo: MarqueeLabel!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var viewRoundCorner: UIView!
    @IBOutlet weak var lblEmploymentType: UILabel!
    @IBOutlet weak var lblProfessionCategory: UILabel!
    @IBOutlet weak var lblProfessionType: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblCompanyAddress: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblDescribeMore: UILabel!
    @IBOutlet weak var lblCompanyWebsite: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var ImgLogo:UIImageView!
    @IBOutlet weak var viewCompanyLogo: UIView!
  
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbEmploymentType: UILabel!
    @IBOutlet weak var lbProfessionCategory: UILabel!
    @IBOutlet weak var lbProfessionType: UILabel!
    @IBOutlet weak var lbCompanyName: UILabel!
    @IBOutlet weak var lbDesignation: UILabel!
    @IBOutlet weak var lbCompanyAddress: UILabel!
    @IBOutlet weak var lbContactNumber: UILabel!
    @IBOutlet weak var lbDescribeMore: UILabel!
    @IBOutlet weak var lbCompanyWebsite: UILabel!
    @IBOutlet weak var lbEmailID: UILabel!
    
    var user_id = ""
    var user_profile_pic = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitUI()
       
        if self.userProfileReponse != nil  {
        Utils.setImageFromUrl(imageView: self.imgUserProfile, urlString: self.userProfileReponse.userProfilePic ?? "",palceHolder: "user_default")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewCompanyLogo.isHidden = true
        if user_id != "" {
            doGetProfileData()
        } else {
             self.doCallProDetailsApi()
        }
       
        
        if hideChat() {
        self.viewChat.isHidden = true
        }
    }

    func doGetProfileData() {
           self.showProgress()
           let params = ["key":apiKey(),
                         "getProfileData":"getMemberProfileData",
                         "user_id":user_id,
                         "unit_id":doGetLocalDataUser().unitID!]
           print("param" , params)
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
               if json != nil {
                   self.hideProgress()
                   print(json as Any)
                   do {
                       let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                       if response.status == "200" {
                           self.userProfileReponse = response
                        
                            self.doCallProDetailsApi()
                       }else {
                           let alertVc = UIAlertController(title: "", message: response.message, preferredStyle: .alert)
                           alertVc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
                               self.navigationController?.popViewController(animated: true)
                           }))
                           self.present(alertVc, animated: true, completion: nil)
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
       }

    @IBAction func btnCancelClicked(_ sender: UIButton) {
         doPopBAck()
        
    }
     @IBAction func onClickCall(_ sender: Any) {
        
        print("local id " , doGetLocalDataUser().userID! )
               print("user id " , userProfileReponse.userID! )
               if doGetLocalDataUser().userID! != userProfileReponse.userID! && doGetLocalDataUser().userMobile! != userProfileReponse.userMobile!{
                   if userProfileReponse.userMobile != nil {
                       if userProfileReponse.publicMobile == "0"{
                           if let phoneCallURL = URL(string: "telprompt://\(userProfileReponse.userMobile! )") {
                               let application:UIApplication = UIApplication.shared
                               if (application.canOpenURL(phoneCallURL)) {
                                   if #available(iOS 10.0, *) {
                                       application.open(phoneCallURL, options: [:], completionHandler: nil)
                                   } else {
                                       application.openURL(phoneCallURL as URL)
                                   }
                               }
                           }
                       }else{
                           self.toast(message: "Number is Private!!", type: .Information)
                       }
                   }else{
                       self.toast(message: "No Number Found...", type: .Information)
                   }
               } else {
                   self.toast(message: "Self call disabled", type: .Information)
               }
//        if userProfileReponse.publicMobile == "1" {
//        if let phoneCallURL = URL(string: "telprompt://\(userProfileReponse.userMobile! )") {
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                if #available(iOS 10.0, *) {
//                    application.open(phoneCallURL, options: [:], completionHandler: nil)
//                } else {
//                    application.openURL(phoneCallURL as URL)
//                }
//            }
//        }
//        else{
//            self.toast(message: "Mobile Number Is Private", type: .Information)
//            }
//        }
       }
    @IBAction func onClickMessage(_ sender: Any) {
        print("local id " , doGetLocalDataUser().userID! )
        print("user id " , userProfileReponse.userID! )
         if doGetLocalDataUser().userID! != userProfileReponse.userID! && doGetLocalDataUser().userMobile! != userProfileReponse.userMobile!{
                   let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                   //  vc.memberDetailModal =  memberArray[indexPath.row]
                   vc.user_id = userProfileReponse.userID!
                   vc.userFullName = userProfileReponse.userFullName!
                   vc.user_image = userProfileReponse.userProfilePic!
                   vc.public_mobile  =  userProfileReponse.publicMobile!
                   vc.mobileNumber =  userProfileReponse.userMobile!
                   vc.isGateKeeper = false
                   self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   self.toast(message: "Self chat disabled", type: .Information)
               }
    }
    
    func doCallProDetailsApi(){
        let params = ["getAbout":"getAbout",
                      "society_id":userProfileReponse.societyId!,
                      "user_id":userProfileReponse.userID!,
                      "unit_id":userProfileReponse.unitId!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(ResponseProfessional.self, from: Data!)
                    if response.status == "200"{
                        self.lblEmploymentType.text = response.employment_type
                        self.lblProfessionCategory.text = response.business_categories
                        self.lblProfessionType.text = response.business_categories_sub
                        self.lblCompanyName.text = response.company_name
                        self.lblDesignation.text = response.designation
                        self.lblCompanyAddress.text = response.company_address
                        self.lblContactNumber.text = response.company_contact_number_view
                        //self.lblDescribeMore.text = response.employment_description
                        self.lblMemberName.text = self.userProfileReponse.userFullName
                        self.lblMemberUnitInfo.text = "\(self.userProfileReponse.blockName!) - \(self.userProfileReponse.unitName!)"
                        self.lblEmailID.text = self.userProfileReponse.userEmail
                        self.lblCompanyWebsite.text = response.company_website
                        if response.employment_description == ""{
                            self.lblDescribeMore.text("Not Available")
                        }else{
                            self.lblDescribeMore.text = response.employment_description
                        }
                        Utils.setImageFromUrl(imageView: self.imgUserProfile, urlString: self.userProfileReponse.userProfilePic,palceHolder: "user_default")
                        
                        if self.userProfileReponse.company_logo != ""
                        {
                                self.viewCompanyLogo.isHidden = false
                                Utils.setImageFromUrl(imageView: self.ImgLogo, urlString: self.userProfileReponse.company_logo ?? "",palceHolder: "")
                        }else{
                            self.viewCompanyLogo.isHidden = true
                        }
                    
                    }else{
                        //print("faliure message",response.message as Any)
                   
                       
                        self.lblMemberName.text = self.userProfileReponse.userFullName
                        self.lblMemberUnitInfo.text = "\(self.userProfileReponse.blockName ?? "") - \(self.userProfileReponse.unitName ?? "")"
                        
                        self.lblEmploymentType.text = "Not Available"
                        self.lblProfessionCategory.text = "Not Available"
                        self.lblProfessionType.text = "Not Available"
                        self.lblCompanyName.text = "Not Available"
                        self.lblDesignation.text = "Not Available"
                        self.lblCompanyAddress.text = "Not Available"
                        self.lblContactNumber.text = "Not Available"
                        self.lblDescribeMore.text = "Not Available"
                        self.lblCompanyWebsite.text = "Not Available"
                        self.lblEmailID.text = "Not Available"
                        
                        
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    @IBAction func onClickUrl(_ sender: Any) {
        guard let url = URL(string:lblCompanyWebsite.text ?? "") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onClickCalls(_ sender: Any) {
        if lblContactNumber.text != doGetValueLanguage(forKey: "not_available")
        {
            let phone = lblContactNumber.text ?? ""
            doCall(on: phone)
//            if let url = URL(string: "tel:\(phone)") {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
        }
       
    }
    @IBAction func onclickEmail(_ sender: Any) {
        let email = self.lblEmailID.text ?? ""
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

   private func doInitUI(){
        self.viewRoundCorner.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        lbTitle.text = doGetValueLanguage(forKey: "professional_details")
        lbEmploymentType.text = doGetValueLanguage(forKey: "employment_type")
        lbProfessionCategory.text = doGetValueLanguage(forKey: "industry")
        lbProfessionType.text = doGetValueLanguage(forKey: "profession_type")
        lbCompanyName.text = doGetValueLanguage(forKey: "company_name")
        lbDesignation.text = doGetValueLanguage(forKey: "designation")
        lbCompanyAddress.text = doGetValueLanguage(forKey: "address")
        lbContactNumber.text = doGetValueLanguage(forKey: "contact_number")
        lbDescribeMore.text = doGetValueLanguage(forKey: "describe_more")
        lbCompanyWebsite.text = doGetValueLanguage(forKey: "company_website")
        lbEmailID.text = doGetValueLanguage(forKey: "email_ID")
        
        setupMarqee(label: lblMemberUnitInfo)
        
    }
    
    @IBAction func tapOpenProfile(_ sender: Any) {
        if imgUserProfile.image != nil{
            let image = LightboxImage(image:imgUserProfile.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }
    }
}

   
