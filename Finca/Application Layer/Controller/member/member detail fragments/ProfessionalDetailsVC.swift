//
//  ProfessionalDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 13/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ProfessionalDetailsVC: UIViewController {
    var parkingDetails = [MyParkingModal]()
    var emergencyDetails = [MemberEmergencyModal]()
    var familyMemberDetails = [MemberDetailModal]()
    var memberDetailResponse : MemberDetailResponse!
    @IBOutlet weak var lblProfessionCategory: UILabel!
    
    @IBOutlet weak var lblEmploymentType: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblAboutMember: UILabel!
     var mVC = MemberDetailVC()
    override func viewDidLoad() {
        super.viewDidLoad()
     
       /* if memberDetailResponse.employmentStatus == "1"{
            lblEmploymentType.text = memberDetailResponse.employmentType
            //        lblProfessionCategory.text = memberDetailResponse.
            lblCompanyName.text = memberDetailResponse.companyName.trimmingCharacters(in: .whitespaces)
            lblDesignation.text = memberDetailResponse.designation.trimmingCharacters(in: .whitespaces)
            lblContact.text = memberDetailResponse.companyContactNumber
            lblAboutMember.text = memberDetailResponse.employmentDescription
        }*/
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if mVC.memMainResponse != nil {
            if mVC.memMainResponse.employmentStatus == "1"{
                lblEmploymentType.text = mVC.memMainResponse.employmentType
                        lblProfessionCategory.text = mVC.memMainResponse.businessCategories
                lblCompanyName.text = mVC.memMainResponse.companyName.trimmingCharacters(in: .whitespaces)
                lblDesignation.text = mVC.memMainResponse.designation.trimmingCharacters(in: .whitespaces)
                lblContact.text = mVC.memMainResponse.companyContactNumber
                lblAboutMember.text = mVC.memMainResponse.employmentDescription
            }
        }
    }
    
}

extension ProfessionalDetailsVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "PROFESSIONAL DETAILS"
    }
}
