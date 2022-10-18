//
//  ProfileVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkeletonView
import Lightbox
import AVKit
import AVFoundation
struct ResponseAllPayment:Codable {
    var message: String!//  "message" : "Get success.",
    var bill: String!//   "bill" : "0.00",
    var status: String!//   "status" : "200",
    var total: String!//   "total" : "20.00",
    var maintenance: String!
    var deu_penalty: String! //   "maintenance" : "20.00"
}

struct ProfilePhotoUpdateResponse : Codable {
    let user_profile_pic : String!//" : "img\/users\/recident_profile\/user_1908200324.png",
    let message : String!//" : "update successfull",
    let status : String!//" : "200"
}

class ProfileVC:ButtonBarPagerTabStripViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate {
    
    let bvc = BaseVC()
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var ivTimeline: UIImageView!
    @IBOutlet weak var lbResidentNumber: UILabel!
    @IBOutlet weak var lbUnpaidMaintence: UILabel!
    @IBOutlet weak var lbUnpaidBill: UILabel!
    @IBOutlet weak var lbDue: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var switchOwner: UISwitch!
    @IBOutlet weak var switchApartment: UISwitch!
    @IBOutlet weak var viewMaintance: UIView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var viewMainCon: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bSave: UIButton!
    @IBOutlet weak var ivPhoto: UIImageView!
    var UserProfilePic = ""
    
    var item = "InfoFamalyMemberCell"
    var heightCVFamily = 0.0
    var heightCVEmergancy = 0.0
    var emergency = [Emergency]()
    var member = [Member]()
    var emergencyModel:Emergency!
    var memberModel:Member!
    var isImagePick = false
    var isHideAndShow = true
    @IBOutlet weak var heightConContentview: NSLayoutConstraint!
    @IBOutlet weak var conHeightForProfile: NSLayoutConstraint!
    let bVC = BaseVC()
    var PView : NVActivityIndicatorView!
    var viewSub : UIView!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .black
        settings.style.buttonBarItemBackgroundColor = .black
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        super.viewDidLoad()

        ivTimeline.setImageColor(color: ColorConstant.colorP)
        ivPhoto.setImageColor(color: .black)
        
        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        doMaintence()
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
        
        if UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC) != nil {
            Utils.setImageFromUrl(imageView: ivProfile, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC)!, palceHolder: "user_default")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isImagePick {
          //        self.reloadPagerTabStripView()
            }
        //reloadPagerTabStripView()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        initUI()
        print("viewWillAppear main tab profile")
        //   viewMainCon.frame = CGRect()
        
        
        if !isImagePick {
          //    self.reloadPagerTabStripView()
        }
      
        
        heightConContentview.constant = 700
    }
    
    func showProgress() {
        print("showProgress")
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
        view.addSubview(viewSub)
        
    }
    
    func hideProgress() {
        PView.stopAnimating()
        viewSub.removeFromSuperview()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "idProfilePersonalDetailVC")as! ProfilePersonalDetailVC
        child_1.mainvew = self
        //        child_1.loadView()
        
        child_1.context = self
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "idProfileprofessionalDetails")as! ProfileprofessionalDetails
        child_2.mainvew = self
    
        if UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC) != nil {
            Utils.setImageFromUrl(imageView: ivProfile, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC)!, palceHolder: "user_default")
        }
        return [child_1,child_2]
    }
    
    func refreshPage() {
        reloadPagerTabStripView()
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if value {
            //
            doCallSwichApartment(unit_status: "5")
        } else {
            if bVC.doGetLocalDataUser().userType == "0" {
                //owner
                doCallSwichApartment(unit_status: "1")
                
            } else {
                //tenent
                doCallSwichApartment(unit_status: "3")
                
            }
            
        }
        
    }
    
    @objc func switchChangedRenter(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if value {
            //
            confirm(isOnwer: true)
        } else {
            confirm(isOnwer: false)
            
        }
    }
    
    func confirm(isOnwer:Bool){
        
        let refreshAlert = UIAlertController(title: "", message: "Are you sure to become Rent?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.showDailog(isOnwer: isOnwer)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func showDailog(isOnwer:Bool) {
        
        if isOnwer {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogSwitchToRenterVC") as! DailogSwitchToRenterVC
            
            vc.isOnwer = isOnwer
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.addChild(vc)
            self.view.addSubview(vc.view)
        } else {
            doSwitchToOnwer()
        }
    }
    
    func  initUI() {
        
        Utils.setRoundImageWithBorder(imageView: ivProfile, color: .white)
        
        
        print("isImagePick  " , isImagePick)
       /* if !isImagePick {
            
            if UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC) != nil {
                Utils.setImageFromUrl(imageView: ivProfile, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_PROFILE_PIC)!, palceHolder: "user_default")
            }
        }*/
        
        lbResidentNumber.text = bVC.doGetLocalDataUser().blockName + "-" + bVC.doGetLocalDataUser().unitName
        
        lbUserName.text = bVC.doGetLocalDataUser().userFullName
        
        heightCVFamily = 0.0
        heightCVEmergancy = 0.0
        
    }
    
    @IBAction func onClickTimeLine(_ sender: Any) {
        let vc = bVC.subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
        vc.isMyTimeLine = true
        vc.user_id = bVC.doGetLocalDataUser().userID!
        vc.unit_id = bVC.doGetLocalDataUser().unitID!
        vc.user_name = bVC.doGetLocalDataUser().userFullName!
        vc.society_id = bVC.doGetLocalDataUser().societyID!
        vc.block_name = bVC.doGetLocalDataUser().blockName!
        vc.isMemberTimeLine = false
        self.revealViewController()?.pushFrontViewController(vc, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        doSubmitData()
    }
    
    func doMaintence() {
        self.showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":bVC.apiKey(),
                      "userDetail":"userDetail",
                      "unit_id":bVC.doGetLocalDataUser().unitID!,
                      "society_id":bVC.doGetLocalDataUser().societyID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getUserPaymentData, parameters: params) { (json, error) in
            self.hideProgress()
//            self.view.hideSkeleton()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseAllPayment.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.lbUnpaidMaintence.text = response.maintenance
                        self.lbUnpaidBill.text = response.bill
                        self.lbDue.text = response.total
                        
                        
                    }else {
                        self.viewMaintance.isHidden = true
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doSwitchToProfile(public_mobile:String) {
        showProgress()
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        let  params = ["key":bVC.apiKey(),
                       "changePrivacy":"changePrivacy",
                       "society_id":bVC.doGetLocalDataUser().societyID!,
                       "public_mobile":public_mobile,
                       "user_id":bVC.doGetLocalDataUser().userID!,
                       "unit_id":bVC.doGetLocalDataUser().unitID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.aboutController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        /*  guard let selectedImage = info[.originalImage] as? UIImage else {
         fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
         }*/
        
        
        if let img = info[.editedImage] as? UIImage
        {
           //self.ivProfile.image = img
              print("imagePickerController edit")
            
                self.ivProfile.image = img
            
        }
        else if let img = info[.originalImage] as? UIImage
        {
               print("imagePickerController ordi")
            //image = img
                 self.ivProfile.image = img
            
            
        }
        
        /*  if let img = info[UIImagePickerControllerEditedImage] as? UIImage
         {
         image = img
         
         }
         else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
         {
         image = img
         }*/
        
        
     
        self.isImagePick = true
        doUploadProfilePic()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func doUploadProfilePic() {
        var user_profile_pic = ""
        showProgress()
        if ivProfile.image != nil {
                user_profile_pic = self.bVC.convertImageTobase64(imageView: self.ivProfile)
         }
        
        let params = ["key":bVC.apiKey(),
                      "setProfilePicture":"setProfilePicture",
                      "user_profile_pic": user_profile_pic,
                      "society_id":bVC.doGetLocalDataUser().societyID!,
                      "user_id":bVC.doGetLocalDataUser().userID!,
                      "unit_id":bVC.doGetLocalDataUser().unitID!]
       // print(params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ProfilePhotoUpdateResponse.self, from:json!)
                    if response.status == "200" {
                        self.isImagePick = false
                        //self.doDisbleUI()
                        //self.doGetProfileData()
                        // Utils.setHomeRootLogin()
                       // print(response.user_profile_pic)
                        UserDefaults.standard.set(response.user_profile_pic, forKey: StringConstants.KEY_PROFILE_PIC)
                        self.UserProfilePic = response.user_profile_pic
                        
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                        
                        
                    }else {
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func onClickAddMember(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        
    }
  
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews ")
        if emergencyModel != nil {
            
            emergency.append(emergencyModel)
            emergencyModel = nil
            //            cvNumber.reloadData()
            heightCVEmergancy =  heightCVEmergancy + 50.0
            //            heightConstrainstNumber.constant = CGFloat(heightCVEmergancy)
            
        }
        if memberModel != nil      {
            member.append(memberModel)
            memberModel = nil
            //            cvMember.reloadData()
            heightCVFamily =  heightCVFamily + 50.0
            print("family " , member.count)
            //            heightConstrainstMember.constant = CGFloat(heightCVFamily)
        }
        
    }
    
    func doSubmitData() {
        bVC.showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var member_family_id = ""
        var member_name = ""
        var member_age = ""
        var member_relation = ""
        
        
        if member.count > 0 {
            
            for data in member {
                
                if data.userID == "" {
                    if member_family_id == "" {
                        member_family_id =  member_family_id + "0"
                    } else {
                        member_family_id =  member_family_id + "~" + "0"
                    }
                    
                } else {
                    if member_family_id == "" {
                        member_family_id =  member_family_id + data.userID
                    } else {
                        member_family_id =  member_family_id + "~" + data.userID
                    }
                    
                }
                
                if member_name == "" {
                    member_name = member_name + data.userFirstName+" "+data.userLastName
                } else {
                    member_name = member_name + "~" + data.userFirstName + " " + data.userLastName
                }
                
                if member_age == "" {
                    member_age = member_age + data.memberAge
                } else {
                    member_age = member_age + "~" + data.memberAge
                }
                if member_relation == "" {
                    member_relation = member_relation + data.memberRelationName
                } else {
                    member_relation = member_relation + "~" + data.memberRelationName
                }
                
                
                
            }
            
            
        }
        
        var emergencyContact_id = ""
        var person_name = ""
        var person_mobile = ""
        var relation = ""
        
        if emergency.count > 0 {
            
            for data in emergency {
                
                if data.emergencyContact_id == "" {
                    
                    if emergencyContact_id == "" {
                        
                        emergencyContact_id =  emergencyContact_id + "0"
                        
                    } else {
                        emergencyContact_id = emergencyContact_id + "~" + "0"
                    }
                    
                    
                } else {
                    
                    if emergencyContact_id == "" {
                        
                        emergencyContact_id =  emergencyContact_id + data.emergencyContact_id
                        
                    } else {
                        emergencyContact_id = emergencyContact_id + "~" + data.emergencyContact_id
                    }
                    
                }
                
                if person_name == "" {
                    person_name = person_name + data.person_name
                } else {
                    person_name = person_name + "~" + data.person_name
                }
                
                if person_mobile == "" {
                    person_mobile = person_mobile + data.person_mobile
                } else {
                    person_mobile = person_mobile + "~" + data.person_mobile
                }
                if relation == "" {
                    relation = relation + data.relation
                } else {
                    relation = relation + "~" + data.relation
                }
                
                
            }
            
        }
        /*var user_profile_pic = ""
         
         
         if ivProfile.image != nil {
         user_profile_pic = bVC.convertImageTobase64(imageView: ivProfile)
         }*/
        
        //        let fullname = tfName.text! + " " + tfLastName.text!
        //        let params = ["key":bVC.apiKey(),
        //                      "addUser":"update",
        //                      "user_id":bVC.doGetLocalDataUser().userID!,
        //                      "society_id":bVC.doGetLocalDataUser().societyID!,
        //                      "block_id":bVC.doGetLocalDataUser().blockID!,
        //                      "floor_id":bVC.doGetLocalDataUser().floorID!,
        //                      "unit_id":bVC.doGetLocalDataUser().unitID!,
        //                      "user_first_name":tfName.text!,
        //                      "user_last_name":tfLastName.text!,
        //                      "user_full_name": fullname,
        //                      "user_mobile":tfMobile.text!,
        //                      "user_email":tfEmail.text!,
        //                      "user_password":UserDefaults.standard.string(forKey: StringConstants.KEY_PASSWORD)!,
        //                      "user_id_proof":"",
        //                      "member_family_id":member_family_id,
        //                      "member_name":member_name,
        //                      "member_age":member_age,
        //                      "member_relation":member_relation,
        //                      "emergencyContact_id":emergencyContact_id,
        //                      "person_name":person_name,
        //                      "person_mobile":person_mobile,
        //                      "relation":relation,
        //                      "user_profile_pic":user_profile_pic,
        //                      "owner_name":"",
        //                      "owner_email":"",
        //                      "owner_mobile":tfMobile.text!,
        //                      "user_type":bVC.doGetLocalDataUser().userType!]
        //
        //
        //
        //
        //        print("param" , params)
        //
        //        let requrest = AlamofireSingleTon.sharedInstance
        //
        //
        //        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
        //
        //            if json != nil {
        //                self.bVC.hideProgress()
        //                do {
        //                    let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
        //
        //
        //                    if response.status == "200" {
        //                        self.doDisbleUI()
        //                        self.doGetProfileData()
        //                        // Utils.setHomeRootLogin()
        //
        //                    }else {
        //                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
        //                    }
        //                } catch {
        //                    print("parse error")
        //                }
        //            }
        //        }
        
    }
    
    func doGetProfileData() {
        /// showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":bVC.apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":bVC.doGetLocalDataUser().userID!,
                      "society_id":bVC.doGetLocalDataUser().societyID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            
            if json != nil {
                // self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    if loginResponse.status == "200" {
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        // self.initUI()
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.bVC.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func onClickEditPhoto(_ sender: Any) {
        openPhotoSelecter()
    }
    
    @objc func openPhotoSelecter(){
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
        actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (UIAlertAction) in
            self.doCallRemovePhoto()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil )
    }
    
    func doCallRemovePhoto(){
        self.showProgress()
        let params = ["removeProfilePicture":"removeProfilePicture",
                      "user_id":bVC.doGetLocalDataUser().userID!,
                      "society_id":bVC.doGetLocalDataUser().societyID!,
                      "unit_id":bVC.doGetLocalDataUser().unitID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(RemoveImageReponse.self, from: Data!)
                    if response.status == "200"{
                        UserDefaults.standard.set(response.userProfilePic, forKey: StringConstants.KEY_PROFILE_PIC)
                        self.reloadPagerTabStripView()
                    }else{
                    }
                }catch{
                    print("parse Error",Err as Any)
                }
            }
        }
    }
    
    @objc func onClickDeleteMemeber(seder:UIButton) {
        let index = seder.tag
        print("onClickDeleteMemeber" , index)
        
        //        doDeletrMember(user_family_id: member[index].user_family_id, index: index)
        
    }
    
    @objc func onClickDeleteEmergancy(seder:UIButton) {
        let index = seder.tag
        print("onClickDeleteEmergancy" , index)
        //        doDeletrNumber(emergencyContact_id: emergency[index].emergencyContact_id, index: index)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    func doCallSwichApartment(unit_status:String) {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":bVC.apiKey(),
                      "switchClose":"switchClose",
                      "unit_status":unit_status,
                      "unit_id":bVC.doGetLocalDataUser().unitID!,
                      "user_id":bVC.doGetLocalDataUser().userID!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.switchController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                // self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.doGetProfileData()
                        
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doSwitchToOnwer() {
        bVC.showProgress()
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        let  params = ["key":bVC.apiKey(),
                       "switchUser":"switchUser",
                       "society_id":bVC.doGetLocalDataUser().societyID!,
                       "owner_name":bVC.doGetLocalDataUser().ownerName!,
                       "owner_email":bVC.doGetLocalDataUser().ownerEmail!,
                       "owner_mobile":bVC.doGetLocalDataUser().ownerMobile!,
                       "addUser":"0",
                       "user_id":bVC.doGetLocalDataUser().userID!,
                       "unit_id":bVC.doGetLocalDataUser().unitID!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.switchUserController, parameters: params) { (json, error) in
            
            if json != nil {
                self.bVC.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    if response.status == "200" {
                        Utils.setHomeRootLogin()
                        UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.bVC.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    var youtubeVideoID = ""
    
    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
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
            self.bvc.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
        
    }
    func playVideo(url: URL) {
   let player = AVPlayer(url: url)

   let vc = AVPlayerViewController()
   vc.player = player

   self.present(vc, animated: true) { vc.player?.play() }
}
    @IBAction func onClickChat(_ sender: Any) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        //  self.navigationController?.pushViewController(vc, animated: true)
        //  bVC.goToDashBoard(storyboard: mainStoryboard)
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "down-arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc  func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        
        
        self.scrollView.isScrollEnabled = true
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        //viewHieght.constant = contentInsets.bottom
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
    }
    
    @IBAction func onClickAbout(_ sender: Any) {
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idAboutSelfVC") as! AboutSelfVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doSetHeightContentView(constant:CGFloat) {
        
       // print("ddd" , )
        DispatchQueue.main.async {
            self.heightConContentview.constant = constant
        }
        // reloadPagerTabStripView()
    }
}


