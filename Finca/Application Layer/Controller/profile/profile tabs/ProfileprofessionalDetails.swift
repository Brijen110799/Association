//
//  ProfileprofessionalDetails.swift
//  Finca
//
//  Created by harsh panchal on 09/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct ResponseProfessionDetails : Codable {
    let society_id:String!//" : "48",
    let status:String!//" : "200",
    let company_name:String!//" : " Tesr",
    let employment_id:String!//" : "13",
    let message:String!//" : "Get About success.",
    let user_phone:String!//" : "9096693518",
    let company_contact_number:String!//" : "25803990",
    let business_categories_sub:String!//" : "Custom Apparel",
    let employment_type:String!//" : "Government",
    let user_id:String!//" : "837",
    let designation:String!//" : " Tedt",
    let user_full_name:String!//" : "Deep Test",
    let unit_id:String!//" : "2139",
    let user_email:String!//" : "deepk@g.in",
    let employment_description:String!//" : "test test",
    let company_address:String!//" : " ggg",
    let business_categories:String!//" : "Apparel"
}

class ProfileprofessionalDetails: BaseVC {
    @IBOutlet weak var lblAboutUS: UILabel!
    var mainvew = ProfileVC()
    
     @IBOutlet weak var ivPencil: UIImageView!
     @IBOutlet weak var lbEmployeeType: UILabel!
     @IBOutlet weak var lbProfessionCategory: UILabel!
     @IBOutlet weak var lbProfessionType: UILabel!
     @IBOutlet weak var lbComapnyName: UILabel!
     @IBOutlet weak var lbDesignation: UILabel!
     @IBOutlet weak var lbCompanyAddress: UILabel!
     @IBOutlet weak var lbContact: UILabel!
     @IBOutlet weak var lbMoreAbout: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var heightConOtherView: NSLayoutConstraint!
    @IBOutlet weak var viewOtherDetails: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       viewOtherDetails.clipsToBounds = true
        
       ivPencil.setImageColor(color: .white)
       goGetDetails()
        heightConOtherView.constant = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
       // mainvew.heightConContentview.constant = 520
       doSetHieght()
        
    }
    
    func doSetHieght() {
           
            self.mainvew.heightConContentview.constant = viewMain.frame.height
        }
    
    func goGetDetails() {
        showProgress()
        let params = ["key":apiKey(),
                      "getAbout":"getAbout",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
              self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseProfessionDetails.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.lbEmployeeType.text = response.employment_type
                        self.lbProfessionCategory.text = response.business_categories
                        self.lbProfessionType.text = response.business_categories_sub
                        self.lbComapnyName.text = response.company_name
                        self.lbDesignation.text = response.designation
                        self.lbCompanyAddress.text = response.company_address
                        self.lbContact.text = response.company_contact_number
                        self.lbMoreAbout.text = response.employment_description
                        self.hideView(item: response.employment_type)
                    }
                    
                } catch {
                    print("parse error")
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
       doSetHieght()
    }
    func hideView(item:String) {
        if item == "Not employed" || item == "Student" || item == "Others"{
            // self.viewOtherDetails.frame.size.height = 10
            heightConOtherView.constant = 0
            self.viewOtherDetails.isHidden = true
            viewDidLayoutSubviews()
        } else {
            // mainvew.heightConContentview.constant = 500
            heightConOtherView.constant = 420
            self.viewOtherDetails.isHidden = false
            viewDidLayoutSubviews()
        }
    }
    
    @IBAction func btnAboutMySelf(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier:
            "idAboutSelfVC")as! AboutSelfVC
        
         nextVC.employment_type = lbEmployeeType.text!
         nextVC.business_categories = lbProfessionCategory.text!
         nextVC.business_categories_sub = lbProfessionType.text!
         nextVC.company_name = lbComapnyName.text!
         nextVC.designation = lbDesignation.text!
         nextVC.company_address = lbCompanyAddress.text!
         nextVC.company_contact_number = lbContact.text!
         nextVC.employment_description = lbMoreAbout.text!
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension ProfileprofessionalDetails : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Professional Details"
    }
}
