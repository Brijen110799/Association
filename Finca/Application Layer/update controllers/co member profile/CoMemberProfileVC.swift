//
//  CoMemberProfileVC.swift
//  Finca
//
//  Created by silverwing_macmini3 on 12/13/1398 AP.
//  Copyright © 1398 anjali. All rights reserved.
//

import UIKit
import Lightbox
import FittedSheets
import EzPopup
import MessageUI

enum VehicalType {
    case Bike,Car
    
    func image() -> UIImage {
        switch self {
        case .Bike: return UIImage(named: "ic_bike")!
        case .Car: return UIImage(named: "ic_car")!
        }
    }
}
class CoMemberProfileVC: BaseVC,MFMailComposeViewControllerDelegate {
    var context : MemberVC!
    let itemcell = "ProfileEmergencyNumberCell"
    let itemcellParking = "ParkingInfoCell"
    
    @IBOutlet weak var cvParkingHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewAltNumber: UIView!
    @IBOutlet weak var lblUserName: MarqueeLabel!
    @IBOutlet weak var lblUnitAndFloor: MarqueeLabel!
    //@IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblEmailId: MarqueeLabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblAltMobileNumber: UILabel!
    @IBOutlet weak var cvParkingInformation: UITableView!
    @IBOutlet weak var cvFamilyMembers: UICollectionView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewNoParkingData: UILabel!
    @IBOutlet weak var viewNoFamilyData: UILabel!
    @IBOutlet weak var viewOtherRemarks: UIView!
    @IBOutlet weak var viewOwnerDetails: UIView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var imgOwnerProfile: UIImageView!
    @IBOutlet weak var btnOwnerProfile: UIButton!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var viewFacebookContainer: UIView!
    @IBOutlet weak var viewInstagram: UIView!
    @IBOutlet weak var viewLinkedinContainer: UIView!

    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var lbTitleFamilyMember: UILabel!
    
    @IBOutlet weak var viewTimeline: UIView!
    @IBOutlet weak var viewProfessional: UIView!
    
    var familyMemberList = [MemberDetailModal](){
        didSet {
            cvFamilyMembers.reloadData()
        }
    }
    var parkingList = [MyParkingModal](){
        didSet{
            cvParkingInformation.reloadData()
        }
    }
    var user_id:String!
    var memMainResponse : MemberDetailResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: itemcell, bundle: nil)
        cvFamilyMembers.register(nib, forCellWithReuseIdentifier: itemcell)
        cvFamilyMembers.delegate = self
        cvFamilyMembers.dataSource = self
        
        let nibParking = UINib(nibName: itemcellParking, bundle: nil)
        cvParkingInformation.register(nibParking, forCellReuseIdentifier: itemcellParking)
        cvParkingInformation.delegate = self
        cvParkingInformation.dataSource = self
        if  !doGetLocalDataUser().isSociety {
            lbTitleFamilyMember.text = "Team member"
        }
        
        
        if hideChat() {
            viewChat.isHidden = true
        }
        if hideTimeline() {
            viewTimeline.isHidden = true
        }
        
        if !hideProfessional() {
            viewProfessional.isHidden = true
        }
        setupMarqee(label: lblUserName)
        lblUserName.triggerScrollStart()
        setupMarqee(label: lblEmailId)
        setupMarqee(label: lblUnitAndFloor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CoMemberProfileVC.tapFunction))
        lblEmailId.isUserInteractionEnabled = true
        lblEmailId.addGestureRecognizer(tap)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        print("tap working")
    let email = lblEmailId.text!
    let shareAll = [ email ] as [Any]
    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    
    self.present(activityViewController, animated: true, completion: nil)
    
    
//        if let url = URL(string: "mailto:\(email)") {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
        
//        let emailTitle = ""
//        let messageBody = ""
//        let toRecipents = [lblEmailId.text!]
//        let mc: MFMailComposeViewController = MFMailComposeViewController()
//
//            mc.mailComposeDelegate = self
//            mc.setSubject(emailTitle)
//            mc.setMessageBody(messageBody, isHTML: false)
//            mc.setToRecipients(toRecipents)
//            mc.modalPresentationStyle = .custom
//            present(mc, animated: true, completion: nil)
        
       }
    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                print("Mail cancelled")
            case MFMailComposeResult.saved.rawValue:
                print("Mail saved")
            case MFMailComposeResult.sent.rawValue:
                print("Mail sent")
            case MFMailComposeResult.failed.rawValue:
                print("Mail sent failure: \(error!.localizedDescription)")
            default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }
    @objc func tapFunctionnnn(sender:UITapGestureRecognizer) {
            print("tap working")
        let email = lblEmailId.text!
        let shareAll = [ email ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
//        if let url = URL(string: "mailto:\(email)") {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
        }
    
    @IBAction func btnCall(_ sender: Any) {
     
        let phone = lblMobileNumber.text!
        
        if phone != doGetValueLanguage(forKey: "not_available") && phone != doGetValueLanguage(forKey: "private")
        {
       
            doCall(on: lblMobileNumber.text!)
        }
    }
    @IBAction func btnAltCall(_ sender: Any) {
        
        // not_available
        // private
     
        let phone = lblAltMobileNumber.text!
        
        if phone != doGetValueLanguage(forKey: "not_available") && phone != doGetValueLanguage(forKey: "private")
        {
       
            doCall(on: lblAltMobileNumber.text!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        doGetProfileData(user_id: user_id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        familyMemberList.removeAll()
        parkingList.removeAll()
    }
    
    func doGetProfileData(user_id:String) {
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
                        self.memMainResponse = response
                        self.familyMemberList = response.member
                       // self.parkingList = response.myParking
                        self.doSetData()
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
    //MARK:-BUTTON INSTA CLICKED
    @IBAction func btnOpenInsta(_ sender: Any) {
        
        if memMainResponse.instagram.contains("https://")
        {
            guard let url = URL(string:memMainResponse.instagram) else { return }
            UIApplication.shared.open(url)
            
        }else
        {
            guard let url = URL(string:"https://"+memMainResponse.instagram) else { return }
            UIApplication.shared.open(url)
        }
    }
    //MARK:-BUTTON FB CLICKED
    @IBAction func btnOpenFB(_ sender: Any) {
      
        if memMainResponse.facebook.contains("https://")
        {
            guard let url = URL(string:memMainResponse.facebook) else { return }
            UIApplication.shared.open(url)
        }else
        {
            print("https://"+memMainResponse.facebook)
            guard let url = URL(string:"https://"+memMainResponse.facebook) else { return }
            UIApplication.shared.open(url)
        }
       
       
    }
    //MARK:-BUTTON LINKEDIN CLICKED
    @IBAction func btnOpenLinkedin(_ sender: Any) {
        if memMainResponse.linkedin.contains("https://")
        {
            guard let url = URL(string:memMainResponse.linkedin) else { return }
            UIApplication.shared.open(url)
        }else
        {
            guard let url = URL(string:"https://"+memMainResponse.linkedin) else { return }
            UIApplication.shared.open(url)
        }
       
    }
    //MARK:-BUTTON HOME CLICKED
    @IBAction func btnHomeClicked(_ sender: UIButton) {
        //        self.context.btnHomeClicked(sender)
        Utils.setHome()
    }
    //MARK:-BUTTON BACK CLICKED
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:-BUTTON MESSAGE MEMBER
    @IBAction func btnMessageClicked(_ sender: UIButton) {
        if doGetLocalDataUser().userID! != memMainResponse.userID! && doGetLocalDataUser().userMobile! != memMainResponse.userMobile!{
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
            //  vc.memberDetailModal =  memberArray[indexPath.row]
            vc.user_id = memMainResponse.userID!
            vc.userFullName = memMainResponse.userFullName!
            vc.user_image = memMainResponse.userProfilePic!
            vc.public_mobile  =  memMainResponse.publicMobile!
            vc.mobileNumber =  memMainResponse.userMobile!
            vc.isGateKeeper = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
          //  self.toast(message: "Self chat disabled", type: .Information)
        }
        if UserDefaults.standard.bool(forKey: StringConstants.KEY_CHAT_ACCESS){
            
        }else {
//        self.toast(message: "access denied", type:.Information)
          UIUtility.toastMessage(onScreen: "access_denied", from: self)
            return
            }
    
    
    }
    //MARK:-BUTTON CALL MEMBER
    @IBAction func btnCallClicked(_ sender: UIButton) {
        
        print("local id " , doGetLocalDataUser().userID! )
        print("user id " , memMainResponse.userID! )
        if doGetLocalDataUser().userID! != memMainResponse.userID! && doGetLocalDataUser().userMobile! != memMainResponse.userMobile!{
            if memMainResponse.userMobile != nil {
                if memMainResponse.publicMobile == "0"{
                    doCall(on: memMainResponse.countryCode + " " + memMainResponse.userMobile)
                    
//                    if let phoneCallURL = URL(string: "telprompt://\(memMainResponse.userMobile! )") {
//                        let application:UIApplication = UIApplication.shared
//                        if (application.canOpenURL(phoneCallURL)) {
//                            if #available(iOS 10.0, *) {
//                                application.open(phoneCallURL, options: [:], completionHandler: nil)
//                            } else {
//                                application.openURL(phoneCallURL as URL)
//                            }
//                        }
//                    }
                }else{
                    self.toast(message: "Number is Private!!", type: .Information)
                }
            }else{
                self.toast(message: "No Number Found...", type: .Information)
            }
        } else {
            self.toast(message: "Self call disabled", type: .Information)
        }
    }
    //MARK:-BUTTON MEMBER TIMELINE
    @IBAction func btnOpenTimeline(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "sub", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
        vc.isMyTimeLine = true
        vc.user_id = memMainResponse.userID!
        vc.unit_id = memMainResponse.unitId!
        vc.memberFirstName = memMainResponse.userFirstName!
        vc.membermiddleName = memMainResponse.user_middle_name!
        vc.memerLastName = memMainResponse.userLastName!
        vc.user_name = memMainResponse.userFullName!
        vc.society_id = memMainResponse.societyId!
        vc.block_name = memMainResponse.blockName!
        vc.isMemberTimeLine = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-BUTTON MEMBER PROFESSIONAL DETAILS
    @IBAction func btnOpenProfessionalDetails(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idProfessionalDetailBS")as! ProfessionalDetailBS
        vc.userProfileReponse = self.memMainResponse
        //vc.modalPresentationStyle = .formSheet
         self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-BUTTON OWNER PROFILE
    @IBAction func btnOwnerProfile(_ sender: UIButton) {
        parkingList.removeAll()
        familyMemberList.removeAll()
        doGetProfileData(user_id: memMainResponse.commonUserId!)
    }
    //MARK:-BUTTON VIEW PROFILE IMAGE
    @IBAction func btnOpenImage(_ sender: UIButton) {
        if imgProfilePicture.image != nil{
            let image = LightboxImage(image:imgProfilePicture.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillLayoutSubviews() {
        cvParkingInformation.setNeedsDisplay()
        cvParkingInformation.setNeedsLayout()
        self.cvParkingHeight.constant = self.cvParkingInformation.contentSize.height
    }
    
    func doSetData() {
        Utils.setImageFromUrl(imageView:imgProfilePicture, urlString: memMainResponse.userProfilePic!, palceHolder: "user_default")
        lblUserName.text = memMainResponse.userFullName
        if memMainResponse.userType == "0"{
            lblUnitAndFloor.text = "\(memMainResponse.blockName!) - \(memMainResponse.unitName!)"
            viewOwnerDetails.isHidden = true
            btnOwnerProfile.isEnabled = false
        }else{
            lblUnitAndFloor.text = "\(memMainResponse.blockName!) - \(memMainResponse.unitName!)"
            viewOwnerDetails.isHidden = false
            lblOwnerName.text = memMainResponse.commonFullName
            Utils.setImageFromUrl(imageView: imgOwnerProfile, urlString: memMainResponse.commonUserProfile, palceHolder: "user_default")
            btnOwnerProfile.isEnabled = true
        }

        lblDOB.text = memMainResponse.memberDateOfBirth
        lblEmailId.text = memMainResponse.userEmail
        lblBloodGroup.text = memMainResponse.blood_group
        lblMobileNumber.text = memMainResponse.userMobileView
        
        lblAltMobileNumber.text = memMainResponse.altMobileView
        
        print(memMainResponse.userMobileView ?? "")
        print(memMainResponse.altMobileView ?? "")

        if memMainResponse.altMobile! == "" || memMainResponse.altMobile!.count <= 2
        {
          
            lblAltMobileNumber.text = "Not Available"
        }
       
        
        lblGender.text = memMainResponse.gender
        if memMainResponse.gender! == ""
        {viewGender.isHidden = true}
        else
        {viewGender.isHidden = false}
        
        if memMainResponse.other_remark == ""
        {viewOtherRemarks.isHidden = true}
        else
        {viewOtherRemarks.isHidden = false
            lblRemark.text = memMainResponse.other_remark
        }

        if memMainResponse.linkedin == ""{
            self.viewLinkedinContainer.alpha = 0.5
        }else{
            self.viewLinkedinContainer.alpha = 1

        }

        if memMainResponse.facebook == ""{
            self.viewFacebookContainer.alpha = 0.5
        }else{
            self.viewFacebookContainer.alpha = 1
        }

        if memMainResponse.instagram == ""{
            self.viewInstagram.alpha = 0.5
        }else{
            self.viewInstagram.alpha = 1
        }

        //        if memMainResponse.altMobile! == ""
        //        {viewAltNumber.isHidden = true}
        //        else
        //        {viewAltNumber.isHidden = false}
        
        //        lblGender.text = memMainResponse.g
        
        //        self.emergencyDetails.append(contentsOf: memMainResponse.emergency)
        //        self.parkingDetails.append(contentsOf: memMainResponse.myParking)
        //        self.familyMemberDetails.append(contentsOf: memMainResponse.member)
        //        self.lblUnitDetails.text = memMainResponse.blockName + "-" + memMainResponse.unitName
        //        self.lblFloorDetails.text = memMainResponse.floorName
        //
        //        self.lbName.text = memMainResponse.userFullName
        //        self.lblTotalParkingCount.text = "\(memMainResponse.myParking.count)"
        //        self.lblFamilyMemberCount.text = "\(memMainResponse.member.count)"
        //        Utils.setImageFromUrl(imageView: self.ivProfile, urlString: memMainResponse.userProfilePic, palceHolder: "user_default")
        //        Utils.setRoundImageWithBorder(imageView: self.ivProfile, color: UIColor.white)
        //        if memMainResponse.userType == "0"{
        //            self.lblResidentType.text = "Owner"
        //        }else if memMainResponse.userType == "1"{
        //            self.lblResidentType.text = "Tenant"
        //        }
        //        self.doCreateActionSheetForFamilyMembers()
    }
}
extension CoMemberProfileVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if parkingList.count == 0 {
            self.cvParkingInformation.isHidden = true
            self.viewNoParkingData.isHidden = false
        }else{
            self.cvParkingInformation.isHidden = false
            self.viewNoParkingData.isHidden = true
        }
        return parkingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = parkingList[indexPath.row]
        let cell = cvParkingInformation.dequeueReusableCell(withIdentifier: itemcellParking, for: indexPath)as! ParkingInfoCell
        if data.parkingType == "1"{
            //bike
            cell.imgVehicalType.image = VehicalType.Bike.image()
        }else{
            //car
            cell.imgVehicalType.image = VehicalType.Car.image()
        }
        let vehicalNo = data.vehicleNo!
        let vehicalNoArr = vehicalNo.components(separatedBy: "~")
        let parkingLocation: String = vehicalNoArr[0]
        let vehicalNumber: String? = vehicalNoArr.count > 1 ? vehicalNoArr[1] : ""
        cell.lblVehicalNumber.text = vehicalNumber?.trimmingCharacters(in: .whitespaces).uppercased()
        cell.lblParkingLocation.text = parkingLocation.trimmingCharacters(in: .whitespaces)
        DispatchQueue.main.async {
            self.setupMarqee(label:cell.lblParkingLocation)
            cell.lblParkingLocation.triggerScrollStart()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension CoMemberProfileVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if familyMemberList.count == 0 {
            self.cvFamilyMembers.isHidden = true
            self.viewNoFamilyData.isHidden = false
        }else{
            self.cvFamilyMembers.isHidden = false
            self.viewNoFamilyData.isHidden = true
        }
        return familyMemberList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let data = familyMemberList[indexPath.row]
        let cell = cvFamilyMembers.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath)as! ProfileEmergencyNumberCell
       
        if hideChat() {
            cell.viewMessageButton.isHidden = true
        }else {
            if data.userStatus != nil &&  data.userStatus == "1"{
                cell.viewMessageButton.isHidden = false
                cell.viewCallButton.isHidden = false
            }else {
                cell.viewMessageButton.isHidden = true
                cell.viewCallButton.isHidden = true
            }
        }
        cell.lblName.text = data.userFirstName
        cell.lblRelation.text = data.memberRelationView
        Utils.setImageFromUrl(imageView:cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        cell.collectionView = collectionView
        cell.delegate = self
        cell.indexPath = indexPath
       
        cell.viewEditButton.isHidden = true
        cell.viewShareButton.isHidden = true
        cell.viewDeleteButton.isHidden = true
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 140, height: 220)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {



    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let data = familyMemberList[indexPath.row]
        if data.userStatus != "2"{
            parkingList.removeAll()
            familyMemberList.removeAll()
            doGetProfileData(user_id: data.userID!)

        }
        if data.userStatus != nil &&  data.userStatus != "1"{
           
            showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "this_user_account_is_not_active"), style: .Info, cancelText: "", okText: "OKAY")
            }
    
    }
}
extension CoMemberProfileVC : UserProfileCellDelegate{
    func messageButtonClicked(for collectionView: UICollectionView, at indexPath: IndexPath) {
        let data = familyMemberList[indexPath.row]
        if data.userID != doGetLocalDataUser().userID!{
            if data.userStatus == "2"{
                self.toast(message: "Account Not Active!!", type: .Information)
            }else{
                let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                vc.user_id = data.userID!
                vc.userFullName = data.userFirstName! + " " + data.userLastName!
                vc.user_image = data.userProfilePic!
                vc.public_mobile  =  data.publicMobile!
                vc.mobileNumber =  data.userMobile!
                vc.isGateKeeper = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func callButtonClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        let data = familyMemberList[indexPath.row]
        if data.userMobile != nil {
            if data.publicMobile == "0" {
                if let phoneCallURL = URL(string: "telprompt://\(data.userMobile! )") {
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
    }
}
extension CoMemberProfileVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Notice{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Info
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
