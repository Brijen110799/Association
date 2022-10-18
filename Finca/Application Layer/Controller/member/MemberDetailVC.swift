//
//  MemberDetailVC.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Lightbox
class MemberDetailVC: ButtonBarPagerTabStripViewController {
    let bVC = BaseVC()
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbAboutUS: UILabel!
    @IBOutlet weak var lblFamilyMemberCount: UILabel!
    @IBOutlet weak var lblTotalParkingCount: UILabel!
    @IBOutlet weak var lblResidentType: UILabel!
    @IBOutlet weak var lbAboutStatus: UILabel!
    @IBOutlet weak var lblFloorDetails: UILabel!
    @IBOutlet weak var lblUnitDetails: UILabel!
    @IBOutlet weak var btnCallMember: UIButton!
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewMail: UIView!
    
    var parkingDetails = [MyParkingModal]()
    var emergencyDetails = [MemberEmergencyModal]()
    var familyMemberDetails = [MemberDetailModal]()
    var memMainResponse : MemberDetailResponse!
    
    var alertVC : UIAlertController!
    var selected_residentID : String!
    var isFamilyMemberTapped = false
    
    var user_id:String!
    var PView : NVActivityIndicatorView!
    var viewSub : UIView!
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = ColorConstant.primaryColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        super.viewDidLoad()
        //        doCallApiForMemberDetails()
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        
        viewCall.layer.shadowRadius = 5
        viewCall.layer.shadowOffset = CGSize.zero
        viewCall.layer.shadowOpacity = 0.5
        viewMail.layer.shadowRadius = 5
        viewMail.layer.shadowOffset = CGSize.zero
        viewMail.layer.shadowOpacity = 0.5
        
        
        
        doGetProfileData(user_id: user_id)
        loadPView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    func doSetData() {
        self.emergencyDetails.append(contentsOf: memMainResponse.emergency)
        self.parkingDetails.append(contentsOf: memMainResponse.myParking)
        self.familyMemberDetails.append(contentsOf: memMainResponse.member)
        self.lblUnitDetails.text = memMainResponse.blockName + "-" + memMainResponse.unitName
        self.lblFloorDetails.text = memMainResponse.floorName
        
        self.lbName.text = memMainResponse.userFullName
        self.lblTotalParkingCount.text = "\(memMainResponse.myParking.count)"
        self.lblFamilyMemberCount.text = "\(memMainResponse.member.count)"
        Utils.setImageFromUrl(imageView: self.ivProfile, urlString: memMainResponse.userProfilePic, palceHolder: "user_default")
        Utils.setRoundImageWithBorder(imageView: self.ivProfile, color: UIColor.white)
        if memMainResponse.userType == "0"{
            self.lblResidentType.text = "Owner"
        }else if memMainResponse.userType == "1"{
            self.lblResidentType.text = "Tenant"
        }
        
        
        self.doCreateActionSheetForFamilyMembers()
    }
    
    func doCreateActionSheetForFamilyMembers(){
        alertVC = UIAlertController(title:"", message: "Select Family member", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        for items in familyMemberDetails{
            alertVC.addAction(UIAlertAction(title: "\(String(describing: items.userFirstName!)) \(String(describing: items.userLastName!))", style: .default, handler: { action in
                self.actionSheetItemTapped(itemId : items.userID)
            }))
        }
    }
    
    func loadPView() {
        viewSub = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //    myView.frame.height/2
        viewSub.layer.cornerRadius = 20
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        //    myView.frame.height/2
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        PView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: 32), color: ColorConstant.colorAccent,  padding: 15)
        PView.center = viewSub.center
        PView.backgroundColor = UIColor.white
        PView.layer.cornerRadius = 10
        PView.layer.shadowOpacity = 0.5
        PView.layer.masksToBounds = false
        PView.layer.shadowOffset = CGSize.zero
        viewSub.addSubview(PView)
        PView.startAnimating()
        self.view.addSubview(viewSub)
    }
    
    @IBAction func btnOpenImage(_ sender: UIButton) {
        
        // Create an instance of LightboxController.
        let image = LightboxImage(image:ivProfile.image!)
        let controller = LightboxController(images: [image], startIndex: 0)
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        // Present your controller.
        parent?.present(controller, animated: true, completion: nil)
    }
    func removeView() {
        PView.stopAnimating()
        viewSub.removeFromSuperview()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "sub", bundle: nil)
        let child1 = storyboard.instantiateViewController(withIdentifier: "idBasicDetailsFragmentVC")as! BasicDetailsFragmentVC
        child1.mVC = self
        let child2 = storyboard.instantiateViewController(withIdentifier: "idProfessionalDetailsVC")as! ProfessionalDetailsVC
        child2.mVC = self
        return [child1,child2]
    }
    
    @IBAction func onClickParking(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogMemberAndParkingVC") as! DailogMemberAndParkingVC
        
        vc.myParking = memMainResponse.myParking
        vc.isMember = false
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
    }
    
    @IBAction func btnFamilMemberTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogMemberAndParkingVC") as! DailogMemberAndParkingVC
        
        vc.memberArray = memMainResponse.member
        vc.isMember = true
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    func actionSheetItemTapped(itemId:String!){
        if isFamilyMemberTapped{
            
        }
        print(itemId!)
    }
    
    @IBAction func btnTimeLineTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "sub", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
        vc.isMyTimeLine = true
        vc.user_id = memMainResponse.userID
         //vc.unit_id = memMainResponse.unitId
        //vc.unit_id = bVC.doGetLocalDataUser().unitID!
                
        vc.memberFirstName = memMainResponse.userFirstName
        vc.memerLastName = memMainResponse.userLastName
        vc.user_name = memMainResponse.userFullName
        vc.society_id = memMainResponse.societyId
        vc.block_name = memMainResponse.companyName
        
        vc.isMemberTimeLine = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        //        vc.unitModelMember =  unitModelMember
        vc.isGateKeeper = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHomeClicked(_ sender: UIButton) {
        BaseVC().goToDashBoard(storyboard: bVC.mainStoryboard)
    }

    @IBAction func onClickChatList(_ sender: Any) {
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idMemberChatListVC") as! MemberChatListVC
        vc.memberArray = familyMemberDetails
        vc.isConersion = false
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        //        doPopBAck()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCallTapped(_ sender: UIButton) {
        if memMainResponse.userMobile != nil {
            
            if memMainResponse.publicMobile == "0"{
                if let phoneCallURL = URL(string: "telprompt://\(memMainResponse.userMobile! )") {
                    
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        if #available(iOS 10.0, *) {
                            application.open(phoneCallURL, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            application.openURL(phoneCallURL as URL)
                            
                        }
                    }
                }
            }else{
                UIUtility.toastMessage(onScreen: "Number is Private!!", from: self)
            }
            
        }else{
            UIUtility.toastMessage(onScreen: "No Number Found...", from: self)
        }
    }
    
    func doGetProfileData(user_id:String) {
        let params = ["key":bVC.apiKey(),
                      "getProfileData":"getMemberProfileData",
                      "user_id":user_id,
                      "unit_id":bVC.doGetLocalDataUser().unitID!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.removeView()
            if json != nil {
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200" {
                        self.memMainResponse = response
                        self.doSetData()
                        self.reloadPagerTabStripView()
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
}
extension MemberDetailVC:LightboxControllerPageDelegate,LightboxControllerDismissalDelegate{
    
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    
}
