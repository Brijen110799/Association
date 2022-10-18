//
//  UserProfileVC.swift
//  Finca
//
//  Created by harsh panchal on 12/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkeletonView
import FittedSheets
import Lightbox

class UserProfileVC: BaseVC {
    
    @IBOutlet weak var lblmanageAddress: UILabel!
    @IBOutlet weak var viewManageAddress: UIView!
    @IBOutlet weak var lblTitleMemberID: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblJoiningDate: UILabel!
    @IBOutlet weak var lbTitleExpiryDate: UILabel!
    @IBOutlet weak var lbTitleJoiningDate: UILabel!
    @IBOutlet weak var viewExpJoinDates: UIView!
    @IBOutlet weak var stackSanadDateView: UIStackView!
    @IBOutlet weak var lbTitleSananDate: UILabel!
    @IBOutlet weak var lbSananDate: UILabel!

    @IBOutlet weak var memberIDview: UIStackView!
    @IBOutlet weak var lblmemberId: UILabel!
    
    @IBOutlet weak var lblPenalty:UILabel!
    @IBOutlet weak var lblPenaltyTitle:UILabel!
    @IBOutlet weak var BtnProfile:UIButton!
    @IBOutlet weak var scrollParentView: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var cvFamilyMembers: UICollectionView!
    @IBOutlet weak var cvEmergencyNumber: UICollectionView!
    @IBOutlet weak var lblUnitName: MarqueeLabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: MarqueeLabel!
    @IBOutlet weak var lblUnpaidBill: UILabel!
    @IBOutlet weak var lblUnpaidMaintenance: UILabel!
    @IBOutlet weak var lblTotalDue: UILabel!
    @IBOutlet weak var viewNoFamilyMember: UIView!
    @IBOutlet weak var viewNoEmergencyNumber: UIView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblShareCard:UILabel!
    @IBOutlet weak var viewAddFamilyMembers: UIView!
    @IBOutlet weak var viewAddEmNumber: UIView!
    @IBOutlet weak var btnShareCommercialIcard:UIButton!
    @IBOutlet weak var viewSwitchPrimary: UIView!
    var typeuser = ""
    var tempMemberList = [MemberDetailModal]()
    var tempMemberList2 = [MemberDetailModal]()
    var MemberTYpeStr = ""
    @IBOutlet weak var titleFamilyMember: UILabel!
    @IBOutlet weak var cvCommercialEntry: UICollectionView!
    @IBOutlet weak var viewAddCommercialEntry: UIView!
    @IBOutlet weak var viewCommercialEntry: UIView!
    @IBOutlet weak var viewNoCommercialEntry: UIView!
    @IBOutlet weak var viewProfessional: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblDueBillTitle: UILabel!
    @IBOutlet weak var lblDueMainteneceTitle: MarqueeLabel!
    @IBOutlet weak var lblTotalDuaTitle: UILabel!
    @IBOutlet weak var lblAboutMeTitle: UILabel!
    @IBOutlet weak var lblMyNoteTitle: UILabel!
    @IBOutlet weak var lblMyTimeLineTitle: UILabel!
    @IBOutlet weak var lblProfessionalINformationTitle: UILabel!
    @IBOutlet weak var lblSwitchMemberTitle: UILabel!
    @IBOutlet weak var lblSettingTitle: UILabel!
    @IBOutlet weak var lblShareAddressTitle: UILabel!
    @IBOutlet weak var lblNoFamilyMemberTItle: UILabel!
    @IBOutlet weak var lblAddNewMember: UILabel!
    @IBOutlet weak var lblCommercialEntryTitle: UILabel!
    @IBOutlet weak var lblNewCommercialMemberTitle: UILabel!
    @IBOutlet weak var lblNoCommercialData: UILabel!
    @IBOutlet weak var lblNoEmergencyNumber: UILabel!
    @IBOutlet weak var lblEmergenceNumberTitle: UILabel!
    @IBOutlet weak var lblAddEmergenceNumber: UILabel!
    @IBOutlet weak var lblShareICard: UILabel!
    @IBOutlet weak var Vwvideo:UIView!
    @IBOutlet weak var lbDesignation: MarqueeLabel!
    @IBOutlet weak var lbMyBankDeatils: UILabel!
    @IBOutlet weak var viewTimeline:UIView!
    let itemCell = "ProfileEmergencyNumberCell"
   // var userP : MemberDetailResponse!
    var userProfileReponse : MemberDetailResponse!
    var responseProfessional : ResponseProfessional!
    var memberList = [MemberDetailModal](){
        didSet{
            cvFamilyMembers.reloadData()
        }
    }
    var emergencyNumberList = [MemberEmergencyModal](){
        didSet{
            cvEmergencyNumber.reloadData()
        }
    }
    var youtubeVideoID = ""
    var typeDelete = ""
    var commercialUsers  =  [ModelCommercialUsers]()
    var context : AddEmergencyNumberBS!
    var menuTitle : String!
    var isShowRemoveProfile = true
    @IBAction func onClickNotification(_ sender: Any) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "response.message", type: .Warning)
        }
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let destiController = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewExpJoinDates.isHidden = true
        stackSanadDateView.isHidden = true
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_profile")
        self.scrollParentView.isHidden = true
        //self.viewSwitchPrimary.isHidden = true
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvEmergencyNumber.register(nib, forCellWithReuseIdentifier: itemCell)
        cvEmergencyNumber.delegate = self
        cvEmergencyNumber.dataSource = self
        cvFamilyMembers.register(nib, forCellWithReuseIdentifier: itemCell)
        cvFamilyMembers.delegate  = self
        cvFamilyMembers.dataSource = self
        cvCommercialEntry.register(nib, forCellWithReuseIdentifier: itemCell)
        cvCommercialEntry.delegate  = self
        cvCommercialEntry.dataSource = self
      
        btnShareCommercialIcard.addTarget(self, action: #selector(btnShareCommericalIcardClick(_:)), for: .touchUpInside)
        lblShareCard.text =  doGetLocalDataUser().isSociety ? "Share Business Card" : "Share i card"
        
       // self.lblEmail.textColor = ColorConstant.colorP
        if UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC) != nil {
            Utils.setImageFromUrl(imageView: imgProfilePic, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC)!, palceHolder: "user_default")
        }
        
//        UserDefaults.standard.setValue(response.association_type!, forKey: StringConstants.KEY_ASSOS_TYPE)
//        UserDefaults.standard.setValue(response.membership_expire_date!, forKey: StringConstants.KEY_MEM_EXPIRY_DATE)
//        UserDefaults.standard.setValue(response.membership_joining_date!, forKey: StringConstants.KEY_MEM_JOINING_DATE)
        
//        UserDefaults.standard.setValue(response.association_type!, forKey: StringConstants.KEY_ASSOS_TYPE)
                
        if self.isKeyPresentInUserDefaults(key: StringConstants.KEY_MEM_EXPIRY_DATE) {
            if let expiryDate = UserDefaults.standard.string(forKey: StringConstants.KEY_MEM_EXPIRY_DATE) {
                self.lblExpiryDate.text = expiryDate
                if expiryDate == "" {
                    self.lblExpiryDate.text = "Not Available"
                }
            }
        }

        if self.isKeyPresentInUserDefaults(key: StringConstants.KEY_MEM_JOINING_DATE) {
            if let joiningDate = UserDefaults.standard.string(forKey: StringConstants.KEY_MEM_JOINING_DATE) {
                self.lblJoiningDate.text = joiningDate
                if joiningDate == "" {
                    self.lblJoiningDate.text = "Not Available"
                }
            }
        }

        if self.isKeyPresentInUserDefaults(key: StringConstants.KEY_ASSOS_TYPE) {
            if let assType = UserDefaults.standard.string(forKey: StringConstants.KEY_ASSOS_TYPE) {
                if assType == "1" {
                    viewExpJoinDates.isHidden = false
                }
            }
        }
        
        
        if let UnitName = doGetLocalDataUser().unitName {
            if UnitName != "" {
                memberIDview.isHidden = false
                lblmemberId.text = UnitName

            }
            else{
                memberIDview.isHidden = true
            }
        }
        else{
            memberIDview.isHidden = true
        }
        
        if let sanadDate = doGetLocalDataUser().sanad_date {
            if sanadDate != "" {
                stackSanadDateView.isHidden = false
                lbSananDate.text = sanadDate

//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd"
//                if let date = formatter.date(from: sanadDate) {
//                    formatter.dateFormat = "dd-MM-yyyy"
//                    let strDate = formatter.string(from: date)
//                    if strDate != "" {
//                        stackSanadDateView.isHidden = false
//                        lbSananDate.text = strDate
//                    }
//                }
            }
        }
 
        if doGetLocalDataUser().memberStatus == StringConstants.PRIMARY_ACCOUNT {
            //self.viewAddEmNumber.isHidden = false
            self.viewAddFamilyMembers.isHidden = false
            self.viewSwitchPrimary.isHidden = false
            
            if UserDefaults.standard.bool(forKey: StringConstants.ADD_TENANT_FLAG){
                self.viewAddFamilyMembers.isHidden = false
            }else{
                self.viewAddFamilyMembers.isHidden = true
            }
        }else{
           // self.viewAddEmNumber.isHidden = true
            self.viewAddFamilyMembers.isHidden = true
            self.viewSwitchPrimary.isHidden = true
        }
        
       
        doInintialRevelController(bMenu: bMenu)
        doSetUserData()
        if !hideProfessional() {
            viewProfessional.isHidden = true
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UserProfileVC.tapFunction))
//        lblEmail.isUserInteractionEnabled = true
//        lblEmail.addGestureRecognizer(tap)
        
      //  lblScreenTitle.text = menuTitle
        
        lblmanageAddress.text = doGetValueLanguage(forKey: "additional_address_manage")
        lblDueBillTitle.text = doGetValueLanguage(forKey: "due_bill")
        lblDueMainteneceTitle.text = doGetValueLanguage(forKey: "due_maintenance")
        lblTotalDuaTitle.text = doGetValueLanguage(forKey: "total_due")
        lblAboutMeTitle.text = doGetValueLanguage(forKey: "about_me")
        lblMyNoteTitle.text = doGetValueLanguage(forKey: "my_notes")
        lblMyTimeLineTitle.text = doGetValueLanguage(forKey: "my_timeline")
        lblProfessionalINformationTitle.text = doGetValueLanguage(forKey: "professional_information")
        lblSettingTitle.text = doGetValueLanguage(forKey: "settings")
        lblShareAddressTitle.text = doGetValueLanguage(forKey: "share_address")
        lblShareCard.text = doGetValueLanguage(forKey: "share_business_card")
        lblShareICard.text = doGetValueLanguage(forKey: "share_i_card")
        lblAddNewMember.text = doGetValueLanguage(forKey: "add_family_member")
        lblNoFamilyMemberTItle.text = doGetValueLanguage(forKey: "no_members_available")
        lblCommercialEntryTitle.text = doGetValueLanguage(forKey: "commercial_entry_portal")
        lblNewCommercialMemberTitle.text = doGetValueLanguage(forKey: "new_entry")
        lblNoCommercialData.text = doGetValueLanguage(forKey: "no_entry_available")
        lblEmergenceNumberTitle.text = doGetValueLanguage(forKey: "emergency_numbers")
        lblAddEmergenceNumber.text = doGetValueLanguage(forKey: "new_number")
        lblNoEmergencyNumber.text = doGetValueLanguage(forKey: "no_emergency_number_available")
        lblSwitchMemberTitle.text = doGetValueLanguage(forKey: "family_members_primary_switch")
        lblPenaltyTitle.text = doGetValueLanguage(forKey: "due_penalty")
        lbTitleExpiryDate.text = doGetValueLanguage(forKey: "membership_expire_date")
        lbTitleJoiningDate.text = doGetValueLanguage(forKey: "membership_joining_date")
        lbTitleSananDate.text = doGetValueLanguage(forKey: "sanad_date")
        lbMyBankDeatils.text = doGetValueLanguage(forKey: "my_bank_account")
        lblTitleMemberID.text = doGetValueLanguage(forKey: "membership_number")
        
        setupMarqee(label: lblEmail)
        setupMarqee(label: lblUnitName)
        setupMarqee(label: lbDesignation)
        
        if youtubeVideoID != "" {
            Vwvideo.isHidden = false
        } else {
            Vwvideo.isHidden = true
        }
        
        if  hideTimeline() {
            viewTimeline.isHidden = true
        }
    }
   
    func doSetScreen() {
        print("doSetScreen")
        let appDel = UIApplication.shared.delegate as! AppDelegate
       appDel.myOrientation = .portrait
       UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       UIView.setAnimationsEnabled(true)
       
       
       }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
            print("tap working")
        if doGetLocalDataUser().userEmail ?? "" == ""{
            return
        }
        let email = doGetLocalDataUser().userEmail ?? ""
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
        
    @IBAction func btnManageaAddressAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "idManageAddressVC")as! ManageAddressVC
        //nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func btnShareCommericalIcardClick(_ sender : UIButton ){
     
        if doGetLocalDataUser().societyID == "6"{
            let vc = iCardVC()
            //let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ShareBusinessICardVC")as! iCardVC
           // vc.StrPassFrom = "2"
            vc.userProfileReponse = userProfileReponse
           // vc.responseProfessional = responseProfessional
            self.navigationController?.pushViewController(vc, animated: true)

        }else{

                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ICardVC")as! ICardVC
                vc.userProfileReponse = userProfileReponse
                vc.responseProfessional = responseProfessional
                self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.scrollParentView.isHidden = true
        doSetScreen()
        if doGetLocalDataUser().userEmail != nil && doGetLocalDataUser().userEmail != "" {
            self.lblEmail.text = doGetLocalDataUser().userEmail
        }else {
            self.lblEmail.text = self.doGetValueLanguage(forKey: "no_data")
        }
        fetchNewDataOnRefresh()
        
        if doGetLocalDataUser().memberStatus == "0"
        {
            self.titleFamilyMember.text = doGetValueLanguage(forKey: "primary_team_members")
        }
        else{
            self.titleFamilyMember.text = doGetValueLanguage(forKey: "sub_team_members")
        }
//        if doGetLocalDataUser().societyID == "6"{
//        self.titleFamilyMember.text = "Clerk"
//        }else {
//            self.titleFamilyMember.text = doGetLocalDataUser().isSociety ? doGetValueLanguage(forKey: "family_members") : doGetValueLanguage(forKey: "team_members")
//        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.doGetTeamMembers()
            }
        }
    }
    
    //MARK:- ADD FAMILY MEMBER
    @IBAction func btnAddNewMember(_ sender: UIButton) {
        let vc = self.storyboard?.login().instantiateViewController(withIdentifier: "idAddNewFamilyMemberVC")as! AddNewFamilyMemberVC
        vc.StrMemberTYpe = MemberTYpeStr
        vc.context = self
        pushVC(vc: vc)
       
//        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(450),.fixed(520)])
//        sheetController.blurBottomSafeArea = false
//        sheetController.adjustForBottomSafeArea = false
//        sheetController.topCornersRadius = 15
//        sheetController.dismissOnBackgroundTap = false
//        sheetController.dismissOnPan = false
//        sheetController.extendBackgroundBehindHandle = false
//        sheetController.handleColor = UIColor.white
//        self.present(sheetController, animated: false, completion: nil)
    }
    //MARK:- ADD EMERGENCY NUMBER
    @IBAction func btnAddEmergencyNumber(_ sender: UIButton) {
        let vc = self.storyboard?.login().instantiateViewController(withIdentifier: "idAddEmergencyNumberBS")as! AddEmergencyNumberBS
        vc.context = self
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(310)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = false
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
    }
    //MARK:- ABOUT CLICKED
    @IBAction func btnAboutInfoClicked(_ sender: UIButton) {
        let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserDetailVC")as! UserDetailVC
        nextVC.userProfileReponse = self.userProfileReponse
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK:- TIMELINE CLICKED
    @IBAction func onClickTimeLine(_ sender: Any) {
        let vc = subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
        vc.isMyTimeLine = true
        vc.user_id = doGetLocalDataUser().userID!
        vc.unit_id = doGetLocalDataUser().unitID!
        vc.user_name = doGetLocalDataUser().userFullName!
        vc.society_id = doGetLocalDataUser().societyID!
        vc.block_name = doGetLocalDataUser().blockName!
        vc.isMemberTimeLine = false
        //        self.revealViewController()?.pushFrontViewController(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- PROFESSIONAL INFO CLICKED
    @IBAction func btnProfessionalDetailClicked(_ sender: UIButton) {
        let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier:"idUserProfessionalDetailsVC")as! UserProfessionalDetailsVC
        nextVC.userProfileReponse = self.userProfileReponse
       self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK:- SETTINGS CLICKED
    @IBAction func btnSettingsClicked(_ sender: UIButton) {
        let nextvc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSettingsVC")as! SettingsVC
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    //MARK:- SHARE CLICKED
    @IBAction func btnShareClicked(_ sender: UIButton) {
        self.showProgress()
     //  let shareText = "Name: \(String(describing: userProfileReponse.userFullName!))  \nCompany Name: \(String(describing: userProfileReponse.companyName ?? "")) \n\nMobile No: \(userProfileReponse.countryCode ?? "")\(userProfileReponse.userMobile ?? "") \nEmail: \(userProfileReponse.userEmail ?? "") \n\nAddress: \( doGetLocalDataUser().company_address ?? "") \n  https://maps.google.com/?q=\(doGetLocalDataUser().plot_lattitude!),\(doGetLocalDataUser().plot_longitude!)"
        
       var shareText = ""
        if userProfileReponse.userFullName  ?? "" != ""  {
            shareText = "\(shareText)Name : \(userProfileReponse.userFullName ?? "")\n"
        }
        if userProfileReponse.companyName ?? "" != ""{
            shareText = "\(shareText)Company Name : \(userProfileReponse.companyName ?? "")\n"
        }
       
        if userProfileReponse.userMobile ?? "" != ""{
            shareText = "\(shareText)Mobile No : \(userProfileReponse.userMobile ?? "")\n"
        }
        if userProfileReponse.userEmail ?? "" != ""{
            shareText = "\(shareText)Email : \(userProfileReponse.userEmail ?? "")\n"
        }
        if doGetLocalDataUser().company_address  ?? "" != ""{
            shareText = "\(shareText)Address : \(doGetLocalDataUser().company_address  ?? "")\n"
        }
        
        if doGetLocalDataUser().plot_longitude  ?? "" != ""{
            shareText = "\(shareText)https://maps.google.com/?q=\(doGetLocalDataUser().plot_lattitude ?? ""),\(doGetLocalDataUser().plot_longitude ?? "")"
        }
        
        let shareAll = [ shareText ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        //        self.present(activityViewController, animated: true, completion: nil)
        self.present(activityViewController, animated: true) {
            self.hideProgress()
        }
    }
    
    
    //MARK:- CHOOSE PHOTO :
    
    @IBAction func onClickEditPhoto(_ sender: UIButton) {
        openPhotoSelecter()
    }
    //MARK:- POP TO HOME :
    
    @IBAction func onclickHomeButton(_ sender: UIButton) {
        let destiController = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    //MARK:- SHOW TUTORIAL VIDEO :
    @IBAction func onClickShowVideo(_ sender: UIButton) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "response.message", type: .Warning)
        }
    }
    // MARK:- SAVE NOTES
    
    @IBAction func btnAddMyNotes(_ sender: Any) {
        let vc = MyNotesVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func tapSwitchAccount(_ sender: Any) {
     
        if memberList.count > 0
        {
            tempMemberList = []
            for dict in memberList
            {
                if dict.userStatus == "1" && dict.you_can_appove == ""
                {
                    tempMemberList.append(dict)
                }
            }
            
        }
     
        if tempMemberList.count > 0
        {
            let vc = SwitchMemberVC()
             vc.memberList = tempMemberList
             pushVC(vc: vc)
        }else
        {
            self.toast(message: "Member is not approved!", type: .Warning)
        }

    }
    
    //MARK:- SHOW BUSINESS CARD
    @IBAction func btnShareBusinessCardClicked(_ sender: UIButton) {
        let vc  = self.storyboard?.login().instantiateViewController(withIdentifier: "idBusinessCardDetailsVC")as! BusinessCardDetailsVC
        vc.userProfileReponse = userProfileReponse
        vc.responseProfessional = responseProfessional
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tapAddCommercial(_ sender: Any) {
        let vc = self.storyboard?.login().instantiateViewController(withIdentifier: "idAddCommercialVC")as! AddCommercialVC
        vc.context = self
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(380)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = false
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
        
    }
   
    @IBAction func tapBankDetails(_ sender: Any) {
        let vc = BankDetailsVC()
        pushVC(vc: vc)
        
    }
    @IBAction func btnOpenImage(_ sender: UIButton) {
      
        if imgProfilePic.image != nil {
            BtnProfile.isEnabled = true
            let image = LightboxImage(image:imgProfilePic.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }else{
            BtnProfile.isEnabled = false
        }
   }
    func doGetProfessionalDetails() {

        let params = ["getAbout":"getAbout",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
         //  print(json!)
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseProfessional.self, from:json!)
                    if response.status == "200" {
                        self.responseProfessional = response
                        print(self.responseProfessional.icard_qr_code ?? "")
                    }else {

                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }


    func openPhotoSelecter(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: doGetValueLanguage(forKey: "select_option"), message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)

            }else{
                print("not")
            }

        }))
        actionSheet.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        }))
        if isShowRemoveProfile {
            actionSheet.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "remove_photo"), style: .destructive, handler: { (UIAlertAction) in
                self.doCallRemovePhoto()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil )
    }

    func doCallRemovePhoto(){
        self.showProgress()
        let params = ["removeProfilePicture":"removeProfilePicture",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(RemoveImageReponse.self, from: Data!)
                    if response.status == "200"{
                        UserDefaults.standard.set(response.userProfilePic, forKey: StringConstants.KEY_PROFILE_PIC)
                        self.refreshPage()
                        Utils.updateLocalUserData()
                    }else{
                    }
                }catch{
                    print("parse Error",Err as Any)
                }
            }
        }
    }

    func doUploadProfilePic() {
       
        showProgress()

        let params = ["key":apiKey(),
                      "setProfilePictureNew":"setProfilePictureNew",
                      "old_pic" : doGetLocalDataUser().userProfilePic ?? "",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
       // print(params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartImage(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params,imageFile: imgProfilePic.image,fileName: "user_profile_pic",compression: 0.3) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
//                        self.isImagePick = false
                        //self.doDisbleUI()
                        //self.doGetProfileData()
                        // Utils.setHomeRootLogin()
                      //  print(response.user_profile_pic!)
                        self.isShowRemoveProfile = true
                        UserDefaults.standard.set(response.user_profile_pic, forKey: StringConstants.KEY_PROFILE_PIC)
                        self.refreshPage()
                        Utils.updateLocalUserData()
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }

    override func fetchNewDataOnRefresh() {
        self.memberList.removeAll()
        self.emergencyNumberList.removeAll()
        doGetProfileData()
        doGetProfessionalDetails()
        doGetMaintence()
        doGetCommercialList()
    }

    func refreshPage(){
        fetchNewDataOnRefresh()
    }

    func doGetMaintence() {
        self.scrollParentView.showAnimatedGradientSkeleton()
        let params = ["key":apiKey(),
                      "userDetail":"userDetail",
                      "unit_id":doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.getUserPaymentData, parameters: params) { (json, error) in
            if json != nil {
                self.scrollParentView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.20))
                do {
                    let response = try JSONDecoder().decode(ResponseAllPayment.self, from:json!)
                    if response.status == "200" {
                        self.lblUnpaidMaintenance.text = response.maintenance
                        self.lblUnpaidBill.text = response.bill
                        self.lblTotalDue.text = response.total
                        self.lblPenalty.text = response.deu_penalty
                    }else {
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }

    func doGetProfileData() {
        scrollParentView.showAnimatedGradientSkeleton()
        let params  = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID ?? "",
                      "isSociety":String(doGetLocalDataUser().isSociety!)]
        
        //"isSociety":doGetLocalDataUser().isSociety!
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            if json != nil {
                print(json!)
                self.scrollParentView.hideSkeleton()
                self.cvEmergencyNumber.hideSkeleton()
                self.cvFamilyMembers.hideSkeleton()
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                       
                        self.userProfileReponse = response
                        self.doInitUI()
                       
                        self.memberList = response.member
                        self.emergencyNumberList = response.emergency
                        self.cvEmergencyNumber.reloadData()
                        self.cvFamilyMembers.reloadData()
                       
                       
                      
                       
                        if !response.isSociety {
                            if response.memberStatus == "0" {
                                self.viewCommercialEntry.isHidden = false
                            }
                        }
                        
                    }else{
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doDeleteFamilyMember(memberUserId:String!,index:Int!){
        self.showProgress()
        let params = ["key":apiKey(),
                      "deleteFamilyMember":"deleteFamilyMember",
                      "user_id":memberUserId!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "parent_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
                        self.memberList.remove(at: index)
                        self.checkSwitchBtn()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doDeleteEmergencyNumber(contactId:String!,index:Int!) {
        showProgress()
        let params = ["key":apiKey(),
                      "deleteEmergencyContact":"deleteEmergencyContact",
                      "emergencyContact_id":contactId!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "parent_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    if response.status == "200" {
                        self.emergencyNumberList.remove(at: index)
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func checkSwitchBtn()
    {
        self.tempMemberList.removeAll()
        for statusItem in self.memberList
        {
            
                if statusItem.user_status_msg != nil && statusItem.user_status_msg.count > 0
                {
                    //nating
                }else {
                    self.tempMemberList.append(statusItem)
                }
            
            
        }
        if self.doGetLocalDataUser().memberStatus == StringConstants.PRIMARY_ACCOUNT && self.tempMemberList.count > 0{
            self.viewSwitchPrimary.isHidden = false
            
        }else
        {
            self.viewSwitchPrimary.isHidden = true
        }
    }
    private  func doInitUI(){
        MemberTYpeStr = userProfileReponse.label_member_type ?? ""
        self.lblUsername.text = "\(userProfileReponse.userFirstName ?? "") \(userProfileReponse.userLastName ?? "")"
        self.lblMobileNumber.text = userProfileReponse.countryCode  + String(userProfileReponse.userMobile)
        
        if userProfileReponse.userProfilePic.contains("user_default.png") || userProfileReponse.userProfilePic.contains( "user.png"){
            self.isShowRemoveProfile = false
        }
//        if userProfileReponse.userEmail != nil && userProfileReponse.userEmail != "" {
//            self.lblEmail.text = userProfileReponse.userEmail
//        }else {
//            self.lblEmail.text = doGetValueLanguage(forKey: "no_data")
//        }
        
         DispatchQueue.main.async {
            self.lblUnitName.text = "\(self.userProfileReponse.floorName ?? "")-\(self.userProfileReponse.blockName ?? "")"
            
            if self.userProfileReponse.designation != nil && self.userProfileReponse.designation != "" {
                self.lbDesignation.text = self.userProfileReponse.designation ?? ""
            }else {
                self.lbDesignation.text = self.doGetValueLanguage(forKey: "no_data")
            }
           
        }
        Utils.setImageFromUrl(imageView: imgProfilePic, urlString: userProfileReponse.userProfilePic, palceHolder: "user_default")

        self.scrollParentView.isHidden = false
    }
   
    private func doSetUserData(){
        self.lblUsername.text = doGetLocalDataUser().userFullName
      
        let mobileno = doGetLocalDataUser().userMobile ?? ""
        let countrycode = doGetLocalDataUser().countryCode ?? ""
        
        self.lblMobileNumber.text = countrycode + String(mobileno)
           
//           if doGetLocalDataUser().userEmail != nil && doGetLocalDataUser().userEmail != "" {
//               self.lblEmail.text = doGetLocalDataUser().userEmail
//           }else {
//               self.lblEmail.text = self.doGetValueLanguage(forKey: "no_data")
//           }
        
        /*var userType = ""
        switch doGetLocalDataUser().userStatus {
        case "0":
            userType = "Owner"
        case "1":
            userType = "Tenant"
        default:
            break;
        }
        
        self.lblUnitName.text = "\(userType) / \(doGetLocalDataUser().blockName ?? "") - \(doGetLocalDataUser().unitName ?? "")"*/
        
        Utils.setImageFromUrl(imageView: imgProfilePic, urlString: doGetLocalDataUser().userProfilePic, palceHolder: "user_default")

        //   self.scrollParentView.isHidden = false
      
       }
    
    override func viewDidLayoutSubviews() {
        scrollParentView.layoutSkeletonIfNeeded()
        //        self.scrollParentView.hideSkeleton()
    }

    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

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
    }
    
    func doGetCommercialList() {
        let params = ["getCommercialUserList":"getCommercialUserList",
                      "unit_id":doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.commercial_portal_controller, parameters: params) { (json, error) in
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(CommercialUsersResponse.self, from:json!)
                    if response.status == "200" {
                        self.viewNoCommercialEntry.isHidden = true
                        self.cvCommercialEntry.isHidden = false
                        self.commercialUsers = response.commercial_users
                        self.cvCommercialEntry.reloadData()
                    }else {
                        self.commercialUsers.removeAll()
                        self.cvCommercialEntry.reloadData()
                        self.viewNoCommercialEntry.isHidden = false
                        self.cvCommercialEntry.isHidden = true
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doDeleteCommercialList(user_entry_id:String) {
        showProgress()
           let params = ["deleteCommercialUser":"deleteCommercialUser",
                         "society_id":doGetLocalDataUser().unitID!,
                         "unit_id":doGetLocalDataUser().unitID!,
                         "user_entry_id":user_entry_id]
           print("param" , params)
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPost(serviceName: ServiceNameConstants.commercial_portal_controller, parameters: params) { (json, error) in
            self.hideProgress()
               if json != nil {
                   
                   do {
                       let response = try JSONDecoder().decode(CommercialUsersResponse.self, from:json!)
                       if response.status == "200" {
                        self.doGetCommercialList()
                       }else {
                        self.toast(message: response.message, type: .Faliure)
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
       }
    
    func doGetTeamMembers() {
        
        let params  = ["key":apiKey(),
                      "getFamilymember":"getFamilymember",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID ?? "",
                      "isSociety":String(doGetLocalDataUser().isSociety!),
                      "member_status" : doGetLocalDataUser().memberStatus ?? "",
                      "floor_id":doGetLocalDataUser().floorID ?? "",
                      "block_id":doGetLocalDataUser().blockID ?? ""]
        
        //"isSociety":doGetLocalDataUser().isSociety!
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            
            if json != nil {
                print(json!)
            
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                        
                        if let memberData =    response.member{
                            

                            self.memberList = memberData
                            self.cvFamilyMembers.reloadData()
                            self.checkSwitchBtn()
                        }
                        
                    }else{
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

extension UserProfileVC : SkeletonCollectionViewDataSource , SkeletonCollectionViewDelegate , UICollectionViewDelegateFlowLayout,UserProfileCellDelegate{

    func callButtonClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        switch collectionView {
        case cvEmergencyNumber:
            let data = emergencyNumberList[indexPath.row]
            callNumber(phoneNumber: data.personMobile)
            break;
        case cvFamilyMembers:
            break;
        default:
            break;
        }
    }
    
    func deleteButtonClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        switch collectionView {
        case cvEmergencyNumber:
            let index = indexPath.row
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: index, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
           // showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure to want to delete?", style: .Delete, tag: index)
            typeDelete = "emergancy"
            break;
        case cvFamilyMembers:
            let index = indexPath.row
            typeDelete = "family"
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: index, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
           // showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure to want to delete?", style: .Delete, tag: index)
            break;
        case cvCommercialEntry:
            let index = indexPath.row
            typeDelete = "commercial"
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: index, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
          //  showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure to want to delete?", style: .Delete, tag: index)
            break;
        default:
            break;
        }
    }
    
    func shareButtonClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        switch collectionView {
        case cvEmergencyNumber:

            break;
        case cvFamilyMembers:
            
//            if doGetLocalDataUser().isSociety == false
//            {
            let data = memberList[indexPath.row]
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ShareBusinessICardVC")as! ShareBusinessICardVC
              
                vc.StrPassFrom = "1"
                vc.modelFamilyMember = data
                vc.blockName = userProfileReponse.blockName ?? ""
                vc.unitName = userProfileReponse.floorName ?? ""
                vc.society_namee = doGetLocalDataUser().society_name ?? ""
                vc.companyname = memberList[indexPath.row].company_name ?? ""
                    //userProfileReponse.companyName ?? ""
                vc.textpath = userProfileReponse.society_address ?? ""
                vc.designations = userProfileReponse.designation ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                
           // }
//            else
//            {
//
//                let text = "Hello \nI am referring you Mobile Application named Fincasys which is a Society Management Mobile Application (Platform). Fincasys is a Building Management and Community Development is a mobile application which provides Community Management Services vide a comprehensive security management system which provides carious maintenance services to\n•    Buildings\n•    Apartments\n•    Societies\n•    Complexes\n•    Industries\n•    Communities\n•    Universities\nby way of technology platform (mobile application/website) to ensure safety, security, convenience, ease and leisure to its users\n\nAndroid App: https://bit.ly/3f0Mbwx\niOS App: https://apple.co/2VN7fiF\nDownload Brochure : https://bit.ly/31XiB7I"
//                       let shareAll = [ text as Any ] as [Any]
//                       let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//                       activityViewController.popoverPresentationController?.sourceView = self.view
//                       activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
//                       self.present(activityViewController, animated: true, completion: nil)
//            }
            break;
        default:
            break;
        }
    }
    
    func editButtonClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        switch collectionView {
        case cvEmergencyNumber:
            break;
        case cvCommercialEntry:
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ShareBusinessICardVC")as! ShareBusinessICardVC
            vc.userProfileReponse = userProfileReponse
            vc.responseProfessional = responseProfessional
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case cvFamilyMembers:
            let data = memberList[indexPath.row]

            let vc = storyboard?.instantiateViewController(withIdentifier: "idAddNewFamilyMemberVC")as! AddNewFamilyMemberVC
            vc.context = self
            vc.modelFamilyMember = data
            vc.initForUpdate = true
            pushVC(vc: vc)
            
            
//            let sheetController = SheetViewController(controller: vc, sizes:[.fixed(450),.fixed(520)])
//            sheetController.blurBottomSafeArea = false
//            sheetController.adjustForBottomSafeArea = false
//            sheetController.topCornersRadius = 15
//            sheetController.dismissOnBackgroundTap = false
//            sheetController.dismissOnPan = false
//            sheetController.extendBackgroundBehindHandle = false
//            sheetController.handleColor = UIColor.white
//            self.present(sheetController, animated: false, completion: nil)
            break;
        default:
            break;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cvEmergencyNumber:
            if emergencyNumberList.count == 0{
                self.cvEmergencyNumber.isHidden = true
                self.viewNoEmergencyNumber.isHidden = false
            }else{
                self.cvEmergencyNumber.isHidden = false
                self.viewNoEmergencyNumber.isHidden = true
            }
            return emergencyNumberList.count
        case cvFamilyMembers:
            if memberList.count == 0{
                self.cvFamilyMembers.isHidden = true
                self.viewNoFamilyMember.isHidden = false
            }else{
                self.cvFamilyMembers.isHidden = false
                self.viewNoFamilyMember.isHidden = true
            }
            return memberList.count
        case cvCommercialEntry:
            return commercialUsers.count
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case cvEmergencyNumber:
            return itemCell
        case cvFamilyMembers:
            return itemCell
        case cvCommercialEntry:
            return itemCell
        default:
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvEmergencyNumber.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ProfileEmergencyNumberCell
        cell.collectionView = collectionView
        switch collectionView {
        case cvFamilyMembers:
            let data = memberList[indexPath.row]
            cell.viewCallButton.isHidden = true
            cell.lblName.text = data.userFirstName
          //  cell.lblRelation.text = data.memberRelationView
//            cel
            Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic,palceHolder: "user_default")
            cell.delegate = self
            cell.indexPath = indexPath
            
            
//            if doGetLocalDataUser().memberStatus! == "0"{
//                if data.userStatus != "0"{
//                    cell.viewEditButton.isHidden = false
//
//                    cell.lblStatus.isHidden = true
//                }else{
////                    cell.viewMessageButton.isHidden = true
//                    cell.viewEditButton.isHidden = true
//                    cell.lblStatus.text = "Request Pending"
//                    cell.lblStatus.isHidden = false
//                }
//
//                if hideChat() {
//                    cell.viewMessageButton.isHidden = true
//                }else {
//                    if data.userStatus != nil &&  data.userStatus == "1"{
//                        cell.viewMessageButton.isHidden = true   //  change from false to true
//                    }else {
//                        cell.viewMessageButton.isHidden = true
//                    }
//                }
//
//            }else{
//                cell.viewEditButton.isHidden = true
//            }
//            if data.memberRelationName != nil &&  data.memberRelationName != "" {
//                cell.lbStatus.text = data.memberRelationName
//            } else {
//                cell.lbStatus.text = ""
//            }
            
         
            // pending
 
            
//            if data.you_can_appove == "false" && data.userStatus == "0" {
//
//
//                print(tempMemberList)
//                if tempMemberList.count > 0
//                {
//                    tempMemberList.remove(at: indexPath.row)
//                    print(tempMemberList)
//                }
//
//
//            }
            
           // not login
            
            
//                if data.you_can_appove == "" && data.userStatus == "2" {
//
//
//                    print(tempMemberList)
//                    if tempMemberList.count > 0
//                    {
//                        tempMemberList.remove(at: indexPath.row)
//                        print(tempMemberList)
//                    }
//
//
//                }
            
            //  login
            
            if memberList.count == 1
            {
                if data.userStatus == "1" && data.user_status_msg == "Request Pending"
                {
                    viewSwitchPrimary.isHidden = true
                    
                }else if data.userStatus == "2" && data.user_status_msg == ""
                {
                    viewSwitchPrimary.isHidden = true
                    
                }else if data.userStatus == "0" && data.user_status_msg == "Request Pending"
                {
                    viewSwitchPrimary.isHidden = true
                }
                
            }else if memberList.count > 1
            {
                if data.userStatus == "1" &&  doGetLocalDataUser().memberStatus == StringConstants.PRIMARY_ACCOUNT
                {
                    viewSwitchPrimary.isHidden = false
                }
                if data.userStatus == "2" &&  doGetLocalDataUser().memberStatus != StringConstants.PRIMARY_ACCOUNT
                {
                    viewSwitchPrimary.isHidden = true
                    
                }else
                {
                   // viewSwitchPrimary.isHidden = false
                }
            
            }
            if data.designation != nil && data.designation.count > 0{
                cell.lblRelation.text = "(\(data.designation ?? ""))"
            }else{
                cell.lblRelation.text = ""
            }
            
            if doGetLocalDataUser().memberStatus ?? "" == "1"{
                cell.stackViewOptions.isHidden = true
            }else{
                cell.stackViewOptions.isHidden = false
            }
            if data.user_status_msg != nil && data.user_status_msg.count > 0
            {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = "(\(data.user_status_msg ?? ""))"
                cell.viewEditButton.isHidden = true
                cell.viewShareButton.isHidden = true
            }else
            {
                cell.lblStatus.isHidden = true
                //cell.lblStatus.text = ""
                cell.viewEditButton.isHidden = false
                cell.viewShareButton.isHidden = false
            }
            break;
        case cvEmergencyNumber:
            let data = emergencyNumberList[indexPath.row]
            cell.delegate = self
            cell.viewShareButton.isHidden = true
            if data.personName != nil &&  data.personName != "" && data.relation != ""{
                cell.imgProfile.image = self.doReturnImage(from: String(data.personName![data.personName.startIndex]))
            }
            cell.stackViewOptions.isHidden = false
            cell.lblName.text = data.personName
            cell.lblRelation.text = "(\(data.relation ?? ""))"
            //cell.lblNumber.text = data.personMobile
            cell.viewCallButton.isHidden = false
            cell.viewEditButton.isHidden = true
            cell.indexPath = indexPath

            break;
      
        case cvCommercialEntry:
            let data = commercialUsers[indexPath.row]
            cell.delegate = self
            cell.viewShareButton.isHidden = true
            if data.name != nil &&  data.name != "" {
                cell.imgProfile.image = self.doReturnImage(from: String(data.name![data.name.startIndex]))
            }
            cell.stackViewOptions.isHidden = false
            cell.lblName.text = data.name
            cell.viewCallButton.isHidden = true
            cell.viewEditButton.isHidden = true
            cell.viewDeleteButton.isHidden = false
            cell.indexPath = indexPath
            //cell.lblRelation.text =  data.phone
            cell.lblRelation.isHidden = true
            break;
            
        default:
            break;
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == cvFamilyMembers {
            return CGSize(width: 150, height: 240)
        }
          return CGSize(width: 140, height: 220)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cvFamilyMembers:
            
            if  memberList[indexPath.row].userStatus == "0" {
                
                if  memberList[indexPath.row].you_can_appove ?? "" == "true" {
                    let vc = OwnerFamilyVC()
                    vc.context = self
                    vc.initForUpdate = true
                    vc.user_id = memberList[indexPath.row].userID ?? ""
                    vc.modelFamilyMember = memberList[indexPath.row]
                    pushVC(vc: vc)
                } else {
                    toast(message: doGetValueLanguage(forKey: "admin_approval_required"), type: .Information)
                }
             
                
            }else{
                //            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
                //            vc.user_id = memberList[indexPath.row].userID ?? ""
                //            self.navigationController?.pushViewController(vc, animated: true)
                
                let vc = MemberDetailsVC()
                vc.user_id = memberList[indexPath.row].userID ?? ""
                vc.userName = memberList[indexPath.row].userFirstName ?? ""
                pushVC(vc: vc)
            }
            
            break;
        case cvEmergencyNumber:
            break;
        case cvCommercialEntry:
            //            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
            //            vc.user_id = commercialUsers[indexPath.row].user_entry_id ?? ""
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            //            let vc = MemberDetailsVC()
            //            vc.user_id = commercialUsers[indexPath.row].user_entry_id ?? ""
            //            vc.userName =  ""
            //            pushVC(vc: vc)
            
            break;
        default:
            break;
        }
    }
}
extension UserProfileVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let img = info[.editedImage] as? UIImage
        {
            //self.ivProfile.image = img
            print("imagePickerController edit")

            self.imgProfilePic.image = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")
            self.imgProfilePic.image = img
        }
//        self.isImagePick = true
        doUploadProfilePic()
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UserProfileVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                if  self.typeDelete == "emergancy" {
                    let data = self.emergencyNumberList[tag]
                    self.doDeleteEmergencyNumber(contactId: data.emergencyContactId, index: tag)
                } else    if  self.typeDelete == "family" {
                    let data = self.memberList[tag]
                    self.doDeleteFamilyMember(memberUserId: data.userID!,index : tag)
                    
                } else  if  self.typeDelete == "commercial" {
                    let data = self.commercialUsers[tag]
                    self.doDeleteCommercialList(user_entry_id: data.user_entry_id!)
                }
            }
        }
    }
}
