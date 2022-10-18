//
//  FincaProfessionalDetailsVC.swift
//  Fincasys
//
//  Created by silverwing_macmini3 on 11/23/1398 AP.
//  Copyright © 1398 silverwing_macmini3. All rights reserved.
//

import UIKit

struct ResponseProfessional : Codable {
    let business_categories  :String! //" : "ios developers",
    let company_website  :String! //" : "test.con",
    let company_contact_number  :String! //" : "1234467864",
    let company_contact_number_view  :String! //" : "1234467864",
    let business_categories_sub  :String! //" : "comp. Engg",
    let status  :String! //" : "200",
    let employment_id  :String! //" : "26",
    let professional_other  :String! //" : "",
    let unit_id  :String! //" : "3152",
    let business_categories_other  :String! //" : "",
    let search_keyword  :String! //" : "",
    let society_id  :String! //" : "75",
    let employment_description  :String! //" : "Vvhnshha aus hshs susu.",
    let user_id  :String! //" : "1015",
    let user_full_name  :String! //" : "Deepak Panchal",
    let employment_type  :String! //" : "Government",
    let company_name  :String! //" : "Test A",
    let designation  :String! //" : "Test A",
    let user_phone  :String! //" : "9096693518",
    let company_address  :String! //" : "Test",
    let message  :String! //" : "Get About success.",
    let user_email  :String! //" : "deepak@g.in"
    let company_logo : String?
    let user_profile_pic : String!
    let icard_qr_code : String!
    let plot_lattitude : String!
    let plot_longitude : String!
    let visiting_card : String!
    let company_brochure : String!
}

class UserProfessionalDetailsVC: BaseVC {

    @IBOutlet weak var viewSeperatorCategory: UIView!
    @IBOutlet weak var lblEmploymentType: UILabel!
    @IBOutlet weak var lblProfessionCategory: UILabel!
    @IBOutlet weak var lblProfessionType: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblCompanyAddress: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblDescribeMore: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbWebsite: UILabel!
    @IBOutlet weak var lbSearchKeyword: UILabel!
    @IBOutlet weak var imgvwLogotop : UIImageView!

    @IBOutlet weak var viewProfessionType: UIView!
    @IBOutlet weak var viewProfessionCategory: UIView!
    @IBOutlet weak var viewEmploymentType: UIView!

    @IBOutlet weak var NodataView: UIView!
    
    @IBOutlet weak var lbProfessionTypeOther: UILabel!
    @IBOutlet weak var viewCompanyInfo: UIView!
    @IBOutlet weak var viewCompanyName: UIView!
    @IBOutlet weak var viewDesignation: UIView!
    @IBOutlet weak var viewEmailAddress: UIView!
    @IBOutlet weak var viewCompanyWebsite: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var viewKeyword: UIView!
    @IBOutlet weak var viewDescribemore: UIView!
    @IBOutlet weak var viewTopImageShow: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblProfessionalInfoTitle: UILabel!
    @IBOutlet weak var lblEmploymentTypeTitle: UILabel!
    @IBOutlet weak var lblProfessionalCategoryTitle: UILabel!
    @IBOutlet weak var lblProfessionTypeTitle: UILabel!
    @IBOutlet weak var lblCompanyInfoTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblDesignationTitle: UILabel!
    @IBOutlet weak var lblEmailAddTitle: UILabel!
    
    @IBOutlet weak var lblCompanyWebSiteTitle: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    @IBOutlet weak var lblKeywordsTitle: UILabel!
    @IBOutlet weak var lblSearchKeyWordTitle: UILabel!
    @IBOutlet weak var lblDescribeTitle: UILabel!
    @IBOutlet weak var lblMoreAboutProfession: UILabel!
    @IBOutlet weak var lblNoProfessionalData: UILabel!
    @IBOutlet weak var lbMyBankAcc: UILabel!
    
    @IBOutlet weak var viewMainAddressMap: UIView!
    @IBOutlet weak var viewSubAddressMap: UIView!
    @IBOutlet weak var ivAddress: UIImageView!
    @IBOutlet weak var lbBrochureLabel: UILabel!
    @IBOutlet weak var lbBrochure: MarqueeLabel!
    @IBOutlet weak var viewMainBusinessCard: UIView!
    @IBOutlet weak var viewSubBusinessCard: UIView!
    @IBOutlet weak var ivBusinessCard: UIImageView!
    @IBOutlet weak var viewEditDescription: UIView!
   
    
    
    var userProfileReponse : MemberDetailResponse!
    var responseProfessional : ResponseProfessional!
    var companyBrochure = ""
    let requrest = AlamofireSingleTon.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitUI()
        self.viewTopImageShow.isHidden = true
       self.NodataView.isHidden = false
        
        viewEmploymentType.isHidden = true
        viewProfessionType.isHidden = true
        lblScreenTitle.text = doGetValueLanguage(forKey: "professional_information")
        lblNoProfessionalData.text = doGetValueLanguage(forKey: "you_havenot_add_or_updated_your_professional_details")
        lblProfessionalInfoTitle.text = doGetValueLanguage(forKey: "professional_info")
        lblEmploymentTypeTitle.text = doGetValueLanguage(forKey: "employeement_type")
        lblProfessionalCategoryTitle.text = doGetValueLanguage(forKey: "business_type")
        lblProfessionTypeTitle.text = doGetValueLanguage(forKey: "business_type")
        lblCompanyInfoTitle.text = doGetValueLanguage(forKey: "company_info")
        lblCompanyNameTitle.text = doGetValueLanguage(forKey: "company_name")
        lblDesignationTitle.text = doGetValueLanguage(forKey: "designation")
        lblEmailAddTitle.text = doGetValueLanguage(forKey: "email_address")
        lblCompanyWebSiteTitle.text = doGetValueLanguage(forKey: "company_website")
        lblUserAddress.text = doGetValueLanguage(forKey: "addresses")
        lblContactTitle.text = doGetValueLanguage(forKey: "contact_number")
        lblKeywordsTitle.text = doGetValueLanguage(forKey: "max_5_keywords")
        lblSearchKeyWordTitle.text = doGetValueLanguage(forKey: "search_keyword")
        lblDescribeTitle.text = doGetValueLanguage(forKey: "describe")
        lblMoreAboutProfession.text = doGetValueLanguage(forKey: "more_about_profession")
        lbBrochureLabel.text = doGetValueLanguage(forKey: "brochure")
        
        setThreeCorner(viewMain: viewSubAddressMap)
        setupMarqee(label: lbBrochure)
        
        if doGetLocalDataUser().memberStatus ?? "" == "0"{
            self.viewEdit.isHidden = false
            self.viewEditDescription.isHidden = true
            
        } else {
            self.viewEdit.isHidden = true
            self.viewEditDescription.isHidden = false
        }
        
    }
    
    func doInitUI(){

        doGetData()
    }
    
    func doGetData() {
        showProgress()
        
        let params = ["getAbout":"getAbout",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "language_id" :doGetLanguageId()]
        print("param" , params)
     
        requrest.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                //self.NodataView.isHidden = true
                do {
                    let response = try JSONDecoder().decode(ResponseProfessional.self, from:json!)
                    if response.status == "200" {
                        self.NodataView.isHidden = true
                        let companylogo = response.company_logo
                        if companylogo != ""
                        {
                            Utils.setImageFromUrl(imageView: self.imgvwLogotop, urlString: response.company_logo ?? "",palceHolder: "")
                            self.viewTopImageShow.isHidden = false
                        }else{
                            self.viewTopImageShow.isHidden = true
                        }
                        self.lblCompanyName.text = response.company_name
                        self.lblDesignation.text = response.designation
                        self.lblCompanyAddress.text = response.company_address
                        self.lblContactNumber.text = response.company_contact_number
                        self.lblDescribeMore.text = response.employment_description
                        self.lbEmail.text = response.user_email
                        self.lbWebsite.text = response.company_website
                        self.lbSearchKeyword.text = response.search_keyword
                        self.responseProfessional = response
                        self.lblEmploymentType.text = response.employment_type

                        
                        if response.plot_lattitude ?? "" != "" && response.plot_lattitude.count > 1 {
                            self.viewMainAddressMap.isHidden = false
                            let latLong = "\(response.plot_lattitude ?? ""),\(response.plot_longitude ?? "")"
                            let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C"
                                + latLong + "&key=" + StringConstants.MAP_KEY

                            self.ivAddress.setImage(url: URL(string: mapUrl)!)
                        }else {
                            self.viewMainAddressMap.isHidden = true
                        }
                        
                        if response.company_brochure ?? "" != "" && response.company_brochure.count > 1 {
                            let fileArray = response.company_brochure?.components(separatedBy: "/")
                            self.lbBrochure.text = fileArray?.last
                           self.companyBrochure = response.company_brochure ?? ""
                        } else {
                            self.lbBrochure.text = self.doGetValueLanguage(forKey: "no_brochure_available")
                        }
                        
                        if response.visiting_card ?? "" != "" && response.visiting_card.count > 1 {
                            self.viewMainBusinessCard.isHidden = false
                            Utils.setImageFromUrl(imageView: self.ivBusinessCard, urlString: response.visiting_card, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
                        } else {
                            self.viewMainBusinessCard.isHidden = true
                        }
                        
                        
                        if response.employment_type == "Unemployed" || response.employment_type == "Student" || response.employment_type == "Others" || response.employment_type == "Homemaker"{
                           // self.viewProfessionType.isHidden = true
                            self.viewProfessionCategory.isHidden = true
                           // self.viewKeyword.isHidden = true
                            self.viewCompanyInfo.isHidden = true
                            self.viewSeperatorCategory.isHidden = true
                           // self.viewKeyword.isHidden = true
                        }else{
                            self.lblProfessionCategory.text =  response.business_categories_sub.lowercased().contains("other") ? response.professional_other : response.business_categories_sub
                            self.lblProfessionType.text = response.business_categories_sub.lowercased().contains("other") ? response.professional_other : response.business_categories_sub
                           // self.viewProfessionType.isHidden = false
                            self.viewSeperatorCategory.isHidden = false
                            //self.viewKeyword.isHidden = false
                            self.viewCompanyInfo.isHidden = false
                            self.viewProfessionCategory.isHidden = false
                        }
                    }else{
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func onClickEdit(_ sender: Any) {
        let vc  = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "idEditProfessionalDetailsVC")as! EditProfessionalDetailsVC
        vc.context = self
        vc.userProfileReponse = userProfileReponse
        vc.responseProfessional = responseProfessional
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapBrochure(_ sender: Any) {
        guard let url = URL(string:companyBrochure) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func tapViewBusinessCard(_ sender: Any) {
        
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        let vc  = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "idBusinessCardDetailsVC")as! BusinessCardDetailsVC
        vc.userProfileReponse = userProfileReponse
        vc.responseProfessional = responseProfessional
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doGetProfile(){
        self.showProgress()
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!]
        
                      //"isSociety":doGetLocalDataUser().isSociety!] as [String : Any]
        
        print("param" , params)
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                        self.userProfileReponse = response
                        self.doInitUI()
                    }else{
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func RefereshData(){
        doGetProfile()
        
        DispatchQueue.global(qos: .background).async {
            Utils.updateLocalUserData()
        }
        
    }
    
    @IBAction func tapEditDEscription(_ sender: UIButton) {
        let vc = EditProfessionalDescriptionVC()
        vc.userProfessionalDetailsVC = self
        vc.decription =  self.lblDescribeMore.text ?? ""
        vc.view.frame = self.view.frame
        addPopView(vc: vc)
    }
    
    func updateDescriotion() {
        doGetData()
       
    }
    
}
