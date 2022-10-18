//
//  TabOverviewVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 10/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabOverviewVC: BaseVC {
    
    @IBOutlet weak var lblMemberID: UILabel!
    @IBOutlet weak var lblTitlememberID: UILabel!
    @IBOutlet weak var lbBusinessCategory : UILabel!
    @IBOutlet weak var lbBusinessCategoryLabel : UILabel!
    @IBOutlet weak var lbSubBusinessCategory : UILabel!
    @IBOutlet weak var lbSubBusinessCategoryLabel : UILabel!
    @IBOutlet weak var lbContact : UITextView!
    @IBOutlet weak var lbContactLabel : UILabel!
    @IBOutlet weak var lbEmailId : MarqueeLabel!
    @IBOutlet weak var lbEmailIdLabel : UILabel!
    @IBOutlet weak var lbAltNumber : UITextView!
    @IBOutlet weak var lbAltNumberLabel : UILabel!
    @IBOutlet weak var lbAbout : UILabel!
    @IBOutlet weak var lbAboutLabel : UILabel!
    @IBOutlet weak var lbConnect : UILabel!
    
    @IBOutlet weak var viewWhatApp : UIView!
    @IBOutlet weak var viewFacebook : UIView!
    @IBOutlet weak var viewLinkdin : UIView!
    @IBOutlet weak var viewInsta : UIView!
    @IBOutlet weak var viewTwiter : UIView!
    
    @IBOutlet weak var lbDOB : UILabel!
    @IBOutlet weak var lbDOBLabel : UILabel!
    @IBOutlet weak var lbGender : UILabel!
    @IBOutlet weak var lbGenderLabel : UILabel!
    @IBOutlet weak var lbBllodGroup : UILabel!
    @IBOutlet weak var lbBllodGroupLabel : UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lbBasicInfoLabel : UILabel!
    @IBOutlet weak var lbContactsLabel : UILabel!
    var responseMemberNew : ResponseMemberNew?
    var memberDetailsVC : MemberDetailsVC?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        initUI()
    }

    private func initUI() {
        
        lblTitlememberID.text = doGetValueLanguage(forKey: "membership_number")
        lbBusinessCategoryLabel.text = doGetValueLanguage(forKey: "business_type")
        lbSubBusinessCategoryLabel.text = doGetValueLanguage(forKey: "business_type")
        lbContactLabel.text = doGetValueLanguage(forKey: "mobile_no_colune")
        lbEmailIdLabel.text = doGetValueLanguage(forKey: "email_contact_finca")
        lbAltNumberLabel.text = doGetValueLanguage(forKey: "alt_mobile")
        lbAboutLabel.text = doGetValueLanguage(forKey: "more_about_profession")
        lbConnect.text = doGetValueLanguage(forKey: "connect")
        lbBasicInfoLabel.text = doGetValueLanguage(forKey: "basic_info")
        lbContactsLabel.text = doGetValueLanguage(forKey: "contacts")
        
        lbDOBLabel.text = doGetValueLanguage(forKey: "date_of_birth")
        lbGenderLabel.text = doGetValueLanguage(forKey: "gender")
        lbBllodGroupLabel.text = doGetValueLanguage(forKey: "blood_group")
        setupMarqee(label: lbEmailId)
        viewTwiter.isHidden = true
    
        if let data =  responseMemberNew {
            lbBusinessCategory.text = setNoData(keyData: data.business_categories_sub ?? "")
            lbSubBusinessCategory.text = setNoData(keyData: data.business_categories_sub ?? "" )
            lbContact.text = setNoData(keyData: data.user_mobile_view ?? "" )
            lbEmailId.text = setNoData(keyData: data.user_email ?? "")
            lbAltNumber.text = setNoData(keyData: data.alt_mobile_view ?? "")
            lbAbout.text = setNoData(keyData: data.employment_description ?? "" )
           
            lbGender.text = setNoData(keyData: data.gender ?? "" )
            lblMemberID.text = setNoData(keyData: data.unit_name ?? "" )
            lbDOB.text = setNoData(keyData: data.member_date_of_birth ?? "" )
            lbBllodGroup.text = setNoData(keyData: data.blood_group ?? "" )
            
            if data.facebook ?? "" != "" {
                viewFacebook.isHidden = false
            } else {
                viewFacebook.isHidden = true
            }
            if data.instagram ?? "" != "" {
                viewInsta.isHidden = false
            } else {
                viewInsta.isHidden = true
            }
            
            if data.linkedin ?? "" != "" {
                viewLinkdin.isHidden = false
            } else {
                viewLinkdin.isHidden = true
            }
            if data.user_email ?? "" != "" {
                lbEmailId.attributedText = NSAttributedString(string: data.user_email ?? "", attributes:
                                                                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            lbEmailId.font = UIFont(name: Static.sharedInstance.zoobiz_font_regular , size: CGFloat(12))
        }
        
    }
  
    @IBAction func tapInsta(_ sender: Any) {
        if let insta =  responseMemberNew?.instagram {
            if insta.contains("https://")
            {
                guard let url = URL(string:insta) else { return }
                UIApplication.shared.open(url)
                
            }else
            {
                guard let url = URL(string:"https://"+insta) else { return }
                UIApplication.shared.open(url)
            }
        }
        
    }
    //MARK:-BUTTON FB CLICKED
    @IBAction func tapFacebook(_ sender: Any) {
        if let fb =  responseMemberNew?.facebook {
            if fb.contains("https://")
            {
                guard let url = URL(string:fb) else { return }
                UIApplication.shared.open(url)
            }else
            {
             //   print("https://"+memMainResponse.facebook)
                guard let url = URL(string:"https://"+fb) else { return }
                UIApplication.shared.open(url)
            }
        }
        
       
       
    }
    //MARK:-BUTTON LINKEDIN CLICKED
    @IBAction func tapLinke(_ sender: Any) {
        if let linked =  responseMemberNew?.linkedin {
            if linked.contains("https://")
            {
                guard let url = URL(string:linked) else { return }
                UIApplication.shared.open(url)
            }else
            {
                //   print("https://"+memMainResponse.facebook)
                guard let url = URL(string:"https://"+linked) else { return }
                UIApplication.shared.open(url)
            }
        }
        }
    
    @IBAction func tapWhatapp(_ sender: Any) {
        
        
        if let usemobile = responseMemberNew?.user_mobile_view {
            let urlWhats = "whatsapp://send?phone="+usemobile + "&text=" + ""
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        
                        
                        if let public_mobile = responseMemberNew?.public_mobile {
                            //TODO:  public_mobile 1  private 0 is public
                            if public_mobile == StringConstants.KEY_MOBILE_PRIVATE {
                                
                                DispatchQueue.main.async { [self] in
                                    
                                    self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                                }
                            }else{
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(whatsappURL)
                                }
                            }
                        }
                        
                    }
                    else {
                        toast(message: "Whats app is not installed", type: .Defult)
                    }
                }
            }
        }
        
        
       
        
    }
    
    @IBAction func tapEmail(_ sender: Any) {
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
         
           // self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "not_available"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
        }
    }
    
    private func setNoData(keyData:String ) ->  String{
        var value =  doGetValueLanguage(forKey: "private")
        if keyData != "" && keyData.count > 0{
            value = keyData
        }
        return value
    }

    override func viewWillLayoutSubviews() {
        memberDetailsVC?.updateHeighCon(height: scrollView.contentSize.height + 100)
    }
}
extension TabOverviewVC : IndicatorInfoProvider  ,AppDialogDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "overview").uppercased())
    }
   
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
