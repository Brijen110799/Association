//
//  BasicDetailsFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 13/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class BasicDetailsFragmentVC: BaseVC {
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblMobileNum: UILabel!
    @IBOutlet weak var lblAltMobileNum: UILabel!
    @IBOutlet weak var lblEmailAdder: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblOwnerMobile: UILabel!
    @IBOutlet weak var lblOtherRemark: UILabel!
    
    @IBOutlet weak var ivFacebook: UIImageView!
    @IBOutlet weak var ivInsta: UIImageView!
    @IBOutlet weak var ivLinkein: UIImageView!
    @IBOutlet weak var viewOwnerName: UIView!
    @IBOutlet weak var viewOwnerRemark: UIView!
    @IBOutlet weak var imgOwnerProfile: UIImageView!
    var memberDetailResponse : MemberDetailResponse!
    var parkingDetails = [MyParkingModal]()
    var emergencyDetails = [MemberEmergencyModal]()
    var familyMemberDetails = [MemberDetailModal]()
    var mVC = MemberDetailVC()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let data =  notification.userInfo?["data"] as? UnitModel
        // ivFacebook.alpha = 0.4
        //  ivLinkein.alpha = 0.4
        // ivInsta.alpha = 0.4
        
    }
    
    @IBOutlet weak var viewSeperator2: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    override func viewWillAppear(_ animated: Bool) {
        
        if mVC.memMainResponse != nil {
            if mVC.memMainResponse.userType != "1"{
                viewOwnerName.isHidden = true
                viewOwnerRemark.isHidden = true
                viewSeperator.isHidden = true
                viewSeperator2.isHidden = true
            }else{
                
                Utils.setImageFromUrl(imageView: imgOwnerProfile, urlString: mVC.memMainResponse.commonUserProfile,palceHolder: "user_default")
                lblOwnerName.text = mVC.memMainResponse.ownerName
                lblOwnerMobile.text = mVC.memMainResponse.ownerMobile
                lblOtherRemark.text = mVC.memMainResponse.other_remark
            }
            lblFirstName.text = mVC.memMainResponse.userFirstName!
            lblDOB.text = mVC.memMainResponse.memberDateOfBirth!
            lblLastName.text = mVC.memMainResponse.userLastName!
            
            if mVC.memMainResponse.publicMobile == "1" {
                lblMobileNum.text = "**********"
            } else {
                lblMobileNum.text = mVC.memMainResponse.userMobile!
            }
            
            
            lblEmailAdder.text = mVC.memMainResponse.userEmail!
            
            if  mVC.memMainResponse.facebook != nil  && mVC.memMainResponse.facebook != ""{
                ivFacebook.alpha = 1
            } else {
                ivFacebook.alpha = 0.4
            }
            
            if mVC.memMainResponse.linkedin != nil && mVC.memMainResponse.linkedin != ""{
                ivLinkein.alpha = 1
            }else {
                ivLinkein.alpha = 0.4
            }
            
            if mVC.memMainResponse.instagram != nil && mVC.memMainResponse.instagram != "" {
                ivInsta.alpha = 1
            }else {
                ivInsta.alpha = 0.4
            }
            
        }
    }
    
    @IBAction func btnOpenOpenProfile(_ sender: UIButton) {
        openProfile(withid: mVC.memMainResponse.commonUserId)
    }
    func openeLink(url:String) {
        print("url" , url)
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func onClickFacebbok(_ sender: Any) {
        if mVC.memMainResponse.facebook != nil  && mVC.memMainResponse.facebook != "" {
            if mVC.memMainResponse.facebook.contains("facebook.com") {
                let url =  mVC.memMainResponse.facebook!
                openeLink(url: url)
            } else {
                let url = "https://www.facebook.com/" + mVC.memMainResponse.facebook!
                openeLink(url: url)
            }
            
        }
        
        
    }
    
    @IBAction func onClickInsta(_ sender: Any) {
        if mVC.memMainResponse.instagram != nil && mVC.memMainResponse.instagram != "" {
            if mVC.memMainResponse.instagram.contains("instagram.com") {
                let url =  mVC.memMainResponse.instagram!
                openeLink(url: url)
            } else {
                let url = "https://www.instagram.com/" + mVC.memMainResponse.instagram!
                openeLink(url: url)
            }
            
        }
    }
    
    @IBAction func onClickLinkedin(_ sender: Any) {
        
        if mVC.memMainResponse.linkedin != nil && mVC.memMainResponse.linkedin != ""{
            let url =  mVC.memMainResponse.linkedin!
            openeLink(url: url)
            if mVC.memMainResponse.linkedin.contains("linkedin.com") {
                let url =  mVC.memMainResponse.linkedin!
                openeLink(url: url)
            } else {
                let url = "https://www.linkedin.com/in/" + mVC.memMainResponse.linkedin!
                openeLink(url: url)
            }
            
        }
    }
    
}
extension BasicDetailsFragmentVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BASIC DETAILS"
    }
}
