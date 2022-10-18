//
//  MemberDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 08/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Contacts
import Lightbox
import ContactsUI
import EzPopup

import Toast_Swift
class MemberDetailsVC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var lineOne: UIView!
    @IBOutlet weak var lineTwo: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    
    @IBOutlet weak var lblDialogMessage: UILabel!
    @IBOutlet weak var lblDialogTitle: UILabel!
  
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnBkgCancel: UIButton!
    @IBOutlet weak var viewChatPrivacy: UIView!
//    @IBOutlet weak var viewAgree: GradientView!
    @IBOutlet weak var lbName: MarqueeLabel!
    @IBOutlet weak var lbDesigation: UILabel!
    @IBOutlet weak var lbArea: MarqueeLabel!
    
    @IBOutlet weak var lbCall: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbTimeline: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbGeotag: UILabel!
    @IBOutlet weak var lbBrouchurDownload: UILabel!
    @IBOutlet weak var viewBroucherDownload: UIView!
    @IBOutlet weak var viewAddUser: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var heightConScrollView: NSLayoutConstraint!
    @IBOutlet weak var heightConHeaderView: NSLayoutConstraint!
    @IBOutlet weak var viewLoader: UIView!
    
    private var baseVC  = BaseVC()
    
    var user_id = ""
    var userName = ""
    private  var responseMemberNew : ResponseMemberNew?
    var lastContentOffset: CGFloat = 0.0
    let maxHeaderHeight: CGFloat = 150.0
    let minHeaderHeight: CGFloat = 0
    var previousScrollOffset: CGFloat = 0
       
    override func viewDidLoad() {
        loadDesing()
        super.viewDidLoad()
        viewChatPrivacy.isHidden = true
        // Do any additional setup after loading the view.
        //
        lbTitle.text = baseVC.doGetValueLanguage(forKey: "profile")
        ivProfile.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        containerView.isScrollEnabled = false
        
   
        drawDottedLine(start: CGPoint(x: lineOne.bounds.minX, y: lineOne.bounds.minY), end: CGPoint(x: lineOne.bounds.maxX, y: lineOne.bounds.minY), view: lineOne)
        drawDottedLine(start: CGPoint(x: lineTwo.bounds.minX, y: lineTwo.bounds.minY), end: CGPoint(x: lineTwo.bounds.maxX, y: lineTwo.bounds.minY), view: lineTwo)
        doGetProfileData()
        lbCall.text = baseVC.doGetValueLanguage(forKey: "call")
        lbEmail.text = baseVC.doGetValueLanguage(forKey: "email_contact_finca")
        lbTimeline.text = baseVC.doGetValueLanguage(forKey: "timeline")
        lbMessage.text = baseVC.doGetValueLanguage(forKey: "chat")
        lbGeotag.text = baseVC.doGetValueLanguage(forKey: "geo_tag")
        lbBrouchurDownload.text = baseVC.doGetValueLanguage(forKey: "download_brochure")
        
        baseVC.setupMarqee(label: lbName)
        baseVC.setupMarqee(label: lbArea)
    }


    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadDesing() {
              
        settings.style.buttonBarBackgroundColor = .clear
              //settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 10)
        settings.style.buttonBarItemBackgroundColor =  .clear
              settings.style.selectedBarBackgroundColor = ColorConstant.colorP
              settings.style.selectedBarHeight = 2.0
              settings.style.buttonBarMinimumLineSpacing = 0
              settings.style.buttonBarItemTitleColor = UIColor.blue
              settings.style.selectedBarHeight = 1
              settings.style.buttonBarItemsShouldFillAvailableWidth = false
              settings.style.buttonBarLeftContentInset = 0
              settings.style.buttonBarRightContentInset = 0
              settings.style.buttonBarHeight = 20
              
              
              changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                  guard changeCurrentIndex == true else { return }
                  oldCell?.label.textColor =  ColorConstant.grey_60
                  newCell?.label.textColor = UIColor.black
                 oldCell?.label.font = UIFont(name:"OpenSans-Regular",size:12)
                newCell?.label.font = UIFont(name:"OpenSans-Regular",size:12)
                
//                  newCell?.label.font = newCell?.label.font.withSize(12)
//                  oldCell?.backgroundColor = .clear
//                  oldCell?.cornerRadius = 20
//                  newCell?.cornerRadius = 20
//                  oldCell?.label.font =  oldCell?.label.font.withSize(12)
//                  oldCell?.label.font =  oldCell?.label.font.withSize(12)
//                  newCell?.backgroundColor =  ColorConstant.colorP
                
                 // oldCell?.sizeToFit()
                  
                  
          }
          
          
      }
   
    override func viewDidAppear(_ animated: Bool) {
        self.reloadPagerTabStripView()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = TabOverviewVC()
        child_1.responseMemberNew = responseMemberNew
        child_1.memberDetailsVC = self
        
        let child_2 = TabCompanyProfileVC()
        child_2.responseMemberNew = responseMemberNew
        child_2.memberDetailsVC = self
        
        let child_3 = TabTeamsVC()
        child_3.responseMemberNew = responseMemberNew
        child_3.didTapMember = self
        child_3.memberDetailsVC = self
        return [child_1,child_2,child_3]
    }
    
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    
    func doGetProfileData() {
       // self.baseVC.showProgress()
        let params = ["getProfileData":"getMemberProfileData",
                      "user_id":user_id,
                      "unit_id":baseVC.doGetLocalDataUser().unitID ?? "",
                      "society_id":baseVC.doGetLocalDataUser().societyID ?? "",
                      "isSociety" : "\(false)"]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in
            self.viewLoader.isHidden = true
            if json != nil {
               
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(ResponseMemberNew.self, from:json!)
                    if response.status == "200" {
                        self.responseMemberNew = response
                        DispatchQueue.main.async {
                            self.moveToViewController(at: 0, animated: true)
                        }
                        self.doSetData()
                        self.reloadPagerTabStripView()
                    }else {
                        self.showAlertMsg(msg: response.message ?? "")
                    }
                } catch {
                    print("parse error")
                    
                }
            }else if error != nil{
                self.baseVC.showNoInternetToast()
            }
        }
    }
    
   
    @IBAction func Tapimage(_ sender: Any) {
        if ivProfile.image != nil{
            let image = LightboxImage(image:ivProfile.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self as? LightboxControllerPageDelegate
           controller.dismissalDelegate = self as? LightboxControllerDismissalDelegate
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }
    }
        
    
    @IBAction func tapCall(_ sender: Any) {
        if let public_mobile = responseMemberNew?.public_mobile {
            //TODO:  public_mobile 1  private 0 is public
            if public_mobile == "1" {
              
                DispatchQueue.main.async { [self] in
                  
                    self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                }
               
               // baseVC.toast(message: baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), type: .Information)
            } else {
                if let user_mobile = responseMemberNew?.user_mobile_view {
                    let number = user_mobile.replacingOccurrences(of: " ", with: "")
                    
                    //doCall(on: user_mobile)
                    //let number = user_mobile_view
                    if let phoneCallURL = URL(string: "telprompt://\(number)") {
                        
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            if #available(iOS 10.0, *) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            } else {
                                // Fallback on earlier versio
                                application.openURL(phoneCallURL as URL)
                                
                            }
                        }else{
                            print("dialer N/A")
                        }
                    }
                }
            }
        }
    }
    func privacyChat(){
        if UserDefaults.standard.bool(forKey: StringConstants.KEY_CHAT_ACCESS)
                {

           self.showAlertMessage(title: "Alert", msg: baseVC.doGetValueLanguage(forKey: "access_denied"))

                }else
                {
                    
                    if baseVC.doGetLocalDataUser().userID ?? "" != responseMemberNew?.user_id ?? "" && baseVC.doGetLocalDataUser().userMobile ?? "" != responseMemberNew?.user_mobile ?? ""{
                        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                        //  vc.memberDetailModal =  memberArray[indexPath.row]
                        vc.user_id = responseMemberNew?.user_id ?? ""
                                    vc.userFullName = responseMemberNew?.user_full_name ?? ""
                                    vc.user_image = responseMemberNew?.user_profile_pic  ?? ""
                                    vc.public_mobile  =  responseMemberNew?.public_mobile ?? ""
                                    vc.mobileNumber =  responseMemberNew?.user_mobile ?? ""
                        vc.isGateKeeper = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.baseVC.doGetValueLanguage(forKey: "self_chat_disabled"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
    }
                }
                    
            }
    @IBAction func tapMsg(_ sender: UIButton) {
        
        if responseMemberNew?.public_mobile == "1" {
            viewChatPrivacy.isHidden = false
            
        }else {
            privacyChat()
        }
    }

    @IBAction func btnAgreeClicked(_ sender: UIButton) {
        viewChatPrivacy.isHidden = true
        privacyChat()
        
    }

    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        viewChatPrivacy.isHidden = true
    }

    
    @IBAction func tapTimeline(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "sub", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
        vc.isMyTimeLine = true
        vc.user_id = responseMemberNew?.user_id ?? ""
        vc.unit_id = responseMemberNew?.unit_id  ?? ""
        vc.memberFirstName = responseMemberNew?.user_first_name ?? ""
        //vc.membermiddleName = responseMemberNew?.user_middle_name ?? ""
        vc.memerLastName = responseMemberNew?.user_last_name ?? ""
        vc.user_name = responseMemberNew?.user_full_name ?? ""
        vc.society_id = responseMemberNew?.society_id ?? ""
        vc.block_name = responseMemberNew?.block_name  ?? ""
        vc.isMemberTimeLine = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapMail(_ sender: Any) {
        let email = responseMemberNew?.user_email ?? ""
        if email != "" {
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
         
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.baseVC.doGetValueLanguage(forKey: "not_available"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
        }
        
    }
    
    @IBAction func tapLocation(_ sender: Any) {
        let vc = GeoTagVC()
        vc.other_user_id = responseMemberNew?.user_id ?? ""
        vc.other_user_name = responseMemberNew?.user_full_name ?? ""
        vc.titleToolbar = responseMemberNew?.user_full_name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapDownloadBroucher(_ sender: Any) {
        guard let url = URL(string:responseMemberNew?.company_brochure ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tapAddUser(_ sender: Any) {
        
        
        if let public_mobile = responseMemberNew?.public_mobile {
            //TODO:  public_mobile 1  private 0 is public
            if public_mobile == "1" {
                
                DispatchQueue.main.async { [self] in
                    self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                }
                
                // baseVC.toast(message: baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), type: .Information)
            } else {
                
                
                let name = responseMemberNew?.user_full_name ?? ""
                let number = responseMemberNew?.user_mobile_view ?? ""
                
                let contact = CNMutableContact()
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :number))
                
                contact.phoneNumbers = [homePhone]
                contact.givenName = name
                // contact.imageData = data // Set image data here
                let vc = CNContactViewController(forNewContact: contact)
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
        }
        
    }
    private func doSetData() {
        let nodata =  baseVC.doGetValueLanguage(forKey: "no_data")
        lbName.text = nodata
        lbDesigation.text = nodata
        lbArea.text = nodata
        
        if responseMemberNew?.user_full_name ?? "" != "" {
            lbName.text = responseMemberNew?.user_full_name ?? ""
        }
        
        if responseMemberNew?.designation ?? "" != "" {
            lbDesigation.text = responseMemberNew?.designation ?? ""
        }
        if responseMemberNew?.company_name ?? "" != "" {
            lbArea.text = responseMemberNew?.company_name ?? ""
        }
        
        if responseMemberNew?.company_brochure ?? "" != "" {
            viewBroucherDownload.isHidden = false
        }
        
//        if let public_mobile = responseMemberNew?.public_mobile {
//            //TODO:  public_mobile 1  private 0 is public
//            if public_mobile == "0" {
//
//                viewAddUser.isHidden = false
//
//            }
//        }
        Utils.setImageFromUrl(imageView: ivProfile, urlString: responseMemberNew?.user_profile_pic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
    }
    func showAlertMsg(msg : String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:  self.baseVC.doGetValueLanguage(forKey: "ok"), style: .default, handler: { action in
            // self.onClickDone()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    func updateHeighCon(height : CGFloat) {
        DispatchQueue.main.async {
            if height > self.heightConScrollView.constant   {
                self.heightConScrollView.constant = height
            }
            
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
      /*  if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //Scrolled to bottom
            print("Scrolled to bottom")
            UIView.animate(withDuration: 0.3) {
                self.heightConHeaderView.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
        else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 0) && (self.heightConHeaderView.constant != self.maxHeaderHeight)  {
            //Scrolling up, scrolled to top
            print("Scrolled up")
            UIView.animate(withDuration: 0.3) {
                self.heightConHeaderView.constant = self.maxHeaderHeight
                self.view.layoutIfNeeded()
            }
        }
        else if (scrollView.contentOffset.y > self.lastContentOffset) && self.heightConHeaderView.constant != 0.0 {
            //Scrolling down
            print("Scrolled down")
            UIView.animate(withDuration: 0.3) {
                self.heightConHeaderView.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }*/
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            
            if self.lastContentOffset < 10 {
                UIView.animate(withDuration: 0.3) {
                    self.heightConHeaderView.constant = self.maxHeaderHeight
                    self.view.layoutIfNeeded()
                }
            }
//
           }
           else if (self.lastContentOffset < scrollView.contentOffset.y) {
              // move down
         //   print("Scrolled to move down \(self.lastContentOffset) ")
//            if self.lastContentOffset > 20 {
//                UIView.animate(withDuration: 0.3) {
//                    self.heightConHeaderView.constant = 0
//                    self.view.layoutIfNeeded()
//                }
//            }
         
            if self.lastContentOffset > 5 {
                
                if  self.heightConHeaderView.constant >= 20 {
                    UIView.animate(withDuration: 0.1) {
                        self.heightConHeaderView.constant =  self.heightConHeaderView.constant - 8
                        self.view.layoutIfNeeded()
                    }
                } else {
                    UIView.animate(withDuration: 0.1) {
                        
                        self.heightConHeaderView.constant =  0
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            
           }

           // update the new position acquired
           self.lastContentOffset = scrollView.contentOffset.y
      
    }
    
    
    func showAppDialog(delegate : AppDialogDelegate!,dialogTitle:String!,dialogMessage:String!,style:DialogStyle,tag:Int! = 0,cancelText : String , okText : String){
           let screenwidth = UIScreen.main.bounds.width
           let screenheight = UIScreen.main.bounds.height
           let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAppDialogVC") as! AppDialogVC
           vc.delegate = delegate
           vc.dialogTitle = dialogTitle
           vc.dialogMessage = dialogMessage
           vc.dialogType = style
           vc.tag = tag
               
        
        switch style {
           case .Cancel:
               vc.dialogImage = UIImage(named: "close-button")
               vc.bgColor = UIColor(named: "red_500")
             //  vc.buttonTitle = "YES"
            vc.buttonTitle = okText.uppercased()
               //   vc.setButtonCancelTitle(title: cancelText)
            vc.buttonTitleCancel = cancelText.uppercased()
               break;

           case .Delete:
               vc.dialogImage = UIImage(named: "delete_button")
               vc.bgColor = UIColor(named: "red_500")
              // vc.buttonTitle = "Delete"
                vc.buttonTitle = okText.uppercased()
                 // vc.setButtonCancelTitle(title: cancelText)
            vc.buttonTitleCancel = cancelText.uppercased()
               break;
               
           case .Info:
               vc.dialogImage = UIImage(named: "info_warning")
               vc.bgColor = UIColor(named: "indigo_500")
              // vc.buttonTitle = "OK"
                vc.buttonTitle = okText.uppercased()
            vc.buttonTitleCancel = cancelText.uppercased()
               break;

        case .Add:
            vc.dialogImage = UIImage(named: "finca_logo")
            vc.bgColor = UIColor(named: "ColorPrimary")
            // vc.buttonTitle = "OK"
            vc.buttonTitle = okText.uppercased()
            vc.buttonTitleCancel = cancelText.uppercased()
            
            break;

            
           default:
               break;
                   
           }
           
           let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
           popupVC.backgroundAlpha = 0.8
           popupVC.backgroundColor = .black
           popupVC.shadowEnabled = true
           popupVC.canTapOutsideToDismiss = true
           present(popupVC, animated: true)
       }
    
    func showAlertMessage(title:String, msg:String) {
       let alert = UIAlertController(title: "", message: self.baseVC.doGetValueLanguage(forKey: "access_denied"), preferredStyle: .alert)
   alert.addAction(UIAlertAction(title:  "ok", style: .default, handler: nil)
       // self.onClickDone()
  )
   self.present(alert, animated: true)
   }
    func showAlerDailog(msg : String) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: msg, style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
    }
}
 

extension MemberDetailsVC: AppDialogDelegate , DidTapMember , CNContactPickerDelegate,CNContactViewControllerDelegate{

    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.dismiss(animated: true, completion: nil)
    }
    //this methos for select inther user
    func didTapMember(from id: String) {
     
       
        user_id  =  id
         doGetProfileData()
        //self.reloadPagerTabStripView()
       
    }
    
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

struct ResponseMemberNew : Codable {
    let owner_name : String? //" : "",
    let society_longitude : String? //" : "",
    let society_latitude : String? //" : "",
    let user_type : String? //" : "0",
    let user_email : String? //" : "",
    let alt_mobile : String? //" : "0",
    let label_setting_resident : String? //" : "Contact Number Privacy for Members",
    let user_full_name : String? //" : "Parth Jadav",
    let user_mobile : String? //" : "9099360078",
    let alt_mobile_view : String? //" : "Not Available",
    let city_name : String? //" : ", Ahmedabad",
    let user_status : String? //" : "1",
    let facebook : String? //" : "",
    let child_gate_approval : String? //" : "0",
    let block_name : String? //" : "Ahmedabad",
    let status : String? //" : "200",
    let employment_status : String? //" : "0",
    let api_key : String? //" : "bmsapikey",
    let user_last_name : String? //" : "Jadav",
    let user_id_proof : String? //" : "",
    let tenant_view : String? //" : "0",
    let society_address : String? //" : "1s",
    let other_remark : String? //" : "",
    let public_mobile : String? //" : "1",
    let linkedin : String? //" : "",
    let message : String? //" : "User Details get successfully...",
    let unit_name : String? //" : "101",
    let country_code : String? //" : "+91",
    let floor_id : String? //" : "150",
    let is_society : Bool? //" : false,
    let owner_email : String? //" : "",
    let society_name : String? //" : "Silverwing Association",
    let unit_id : String? //" : "614",
    let user_id : String? //" : "290",
    let dob_view : String? //" : "0",
    let member_date_of_birth : String? //" : "13 Apr 2021 ",
    let user_mobile_view : String? //" : "Private",
    let gender : String? //" : "Male",
    let visitor_approved : String? //" : "1",
    let unit_status : String? //" : "1",
    let society_id : String? //" : "1",
    let label_member_type : String? //" : "Team Members",
    let owner_mobile : String? //" : "",
    let socieaty_logo : String? //" : "https:\/\/ing\/img\/society\/",
    let icard_qr_code : String? //" : "https:\/\/ch/char8&choe=UTF-8&chld=H.png",
    let member_date_of_birth_set : String? //" : "2021-04-13 ",
    let user_first_name : String? //" : "Parth",
  //  let user_middle_name : String?
    let blood_group : String? //" : "Not Available",
    let dob : String? //" : "0",
    let block_id : String? //" : "30",
    let mobile_for_gatekeeper : String? //" : "1",
    let user_profile_pic : String? //" : "https:\owner\/user_default.png",
    let label_setting_apartment : String? //" : "Unit closed",
    let country_code_alt : String? //" : "+91",
    let member_status : String? //" : "0",
    let sos_alert : String? //" : "1",
    let floor_name : String? //" : "Amraiwadi",
    let unit_close_for_gatekeeper : String? //" : "0",
    let instagram : String? //" : "",
    let group_visitor_approval : String? //" : "1"
    let business_categories : String? //" : "1"
    let business_categories_sub : String? //" : "1"
    let company_address : String? //" : "1"
    let employment_description : String? //" : "1"
    let company_name : String? //" : "1"
    let company_contact_number : String? //" : "1"
    let company_email : String? //" : "1"
    let company_website : String? //" : "1"
    let company_logo : String? //" : "1"
    let designation : String? //" : "1"
    let company_brochure : String? //" : "1"
    let visiting_card : String?
    let search_keyword : String?
    let  member : [TeamMember]?
    

}
struct TeamMember : Codable {
    let user_last_name :String? //" : "Rana",
    let user_mobile :String? //" : "9157146041",
    let sos_alert :String? //" : "0",
    let user_id :String? //" : "289",
    let child_gate_approval :String? //" : "0",
    let company_address :String? //" : "ysddxghxkdkd",
    let company_name :String? //" : "",
    let user_first_name :String? //" : "Ankit",
    let user_status_msg :String? //" : "",
    let designation :String? //" : "CEO",
    let mobile_for_gatekeeper :String? //" : "0",
    let public_mobile :String? //" : "1",
    let user_profile_pic :String? //" : "https:\/\//r/685034709289_profile.jpg",
    let you_can_appove :String? //" : "",
    let tenant_view :String? //" : "0",
    let member_age :String? //" : "",
    let member_status :String? //" : "1",
    let user_email :String? //" : "ankitrana1056@gmail.com",
    let company_contact_number :String? //" : "",
    let member_relation_view :String? //" : "(Owner)",
    let member_relation_set :String? //" : "Owner",
    let company_logo :String? //" : "",
    let icard_qr_code :String? //" : "https:\/\/chart.go1&choe=UTF-8&chld=H.png",
    let user_status :String? //" : "1",
    let gender :String? //" : "Male",
    let member_relation_name :String? //" : "(Primary)",
    let country_code_alt :String? //" : "+91",
    let country_code :String? //" : "+91",
    let member_date_of_birth :String? //" : "1994-08-10",
    let company_website :String? //" : ""
}
