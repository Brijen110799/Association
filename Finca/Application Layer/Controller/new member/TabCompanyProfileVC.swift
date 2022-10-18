//
//  TabCompanyProfileVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 10/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Lightbox
class TabCompanyProfileVC: BaseVC {

    @IBOutlet weak var ivCompanyProfile: UIImageView!
    
    
    @IBOutlet weak var lbldigitaltitle: UILabel!
    @IBOutlet weak var Heightkeywords: NSLayoutConstraint!
    @IBOutlet weak var lblnokeyword: UILabel!
    @IBOutlet weak var cvKeywords: UICollectionView!
    @IBOutlet weak var lbCompanyNameLabel: UILabel!
    @IBOutlet weak var lbCompanyName: UILabel!
    @IBOutlet weak var lbCompanyNumberLabel: UILabel!
    @IBOutlet weak var lbCompanyNumber: UILabel!
    @IBOutlet weak var lbCompanyEmailLabel: UILabel!
    @IBOutlet weak var lbCompanyEmail: UILabel!
    @IBOutlet weak var lbCompanyAddressLabel: UILabel!
    @IBOutlet weak var lbCompanyAddress: UILabel!
    @IBOutlet weak var lbCompanyWebSiteLabel: UILabel!
    @IBOutlet weak var lbCompanyWebSite: UILabel!
    @IBOutlet weak var viewMainBusinessCard: UIView!
    @IBOutlet weak var viewSubBusinessCard: UIView!
    @IBOutlet weak var ivBusinessCard: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var responseMemberNew : ResponseMemberNew?
    var memberDetailsVC : MemberDetailsVC?
    var listKeyWord = [String]()
    let cellItem = "SearchKeywordCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellItem, bundle: nil)
        cvKeywords.register(nib, forCellWithReuseIdentifier: cellItem)
        cvKeywords.delegate = self
        cvKeywords.dataSource = self

        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initUI()
        
    }
    
    private func initUI() {
        
        lbldigitaltitle.text = doGetValueLanguage(forKey: "digital_business_card")
        lbCompanyNameLabel.text = doGetValueLanguage(forKey: "company_name")
        lbCompanyNumberLabel.text = doGetValueLanguage(forKey: "contact_number")
        lbCompanyEmailLabel.text = doGetValueLanguage(forKey: "email_contact_finca")
        lbCompanyAddressLabel.text = doGetValueLanguage(forKey: "address")
        lbCompanyWebSiteLabel.text = doGetValueLanguage(forKey: "website")
        
        if let data =  responseMemberNew {
            Utils.setImageFromUrl(imageView: ivCompanyProfile, urlString: data.company_logo ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            
            lbCompanyName.text = setNoData(keyData: data.company_name ?? "" )
            lbCompanyNumber.text = setNoData(keyData: data.company_contact_number ?? "" )
            lbCompanyEmail.text = setNoData(keyData: data.company_email ?? "" )
                //setNoData(keyData: data.company_email ?? "" )
            lbCompanyAddress.text = setNoData(keyData: data.company_address ?? "" )
            lbCompanyWebSite.text = setNoData(keyData: data.company_website ?? "" )
            lblnokeyword.text = doGetValueLanguage(forKey: "not_available")
            
            if data.visiting_card ?? "" != "" && data.visiting_card?.count ?? 0 > 1 {
                self.viewMainBusinessCard.isHidden = false
                Utils.setImageFromUrl(imageView: self.ivBusinessCard, urlString: data.visiting_card ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            } else {
                self.viewMainBusinessCard.isHidden = true
            }
            
            
            if data.company_contact_number ?? "" != "" {
                lbCompanyNumber.attributedText = NSAttributedString(string: data.company_contact_number ?? "", attributes:
                                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            
            
            if data.company_email ?? "" != "" {
                lbCompanyEmail.attributedText = NSAttributedString(string: data.company_email ?? "", attributes:
                                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            
            if data.company_website ?? "" != "" {
                lbCompanyWebSite.attributedText = NSAttributedString(string: data.company_website ?? "", attributes:
                                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
            
            if data.search_keyword != "" {
               
                listKeyWord = (data.search_keyword!.components(separatedBy: ","))
                  
                    cvKeywords.reloadData()
                    cvKeywords.isHidden = false
                lblnokeyword.isHidden = true
                Heightkeywords.constant = 40
                
            }
            else{
                Heightkeywords.constant = 20
                cvKeywords.isHidden = true
                lblnokeyword.isHidden = false
                
            }
            
            
        }
        
    
    }

    private func setNoData(keyData:String ) ->  String{
        var value =  doGetValueLanguage(forKey: "not_available")
        if keyData != "" && keyData.count > 0{
            value = keyData
        }
        return value
    }

    override func viewWillLayoutSubviews() {
       // print("viewWillLayoutSubviews")
    }
    override func viewDidLayoutSubviews() {
        //print("viewDidLayoutSubviews")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.memberDetailsVC?.updateHeighCon(height: self.scrollView.contentSize.height)
        }
    }
    
    @IBAction func tapContact(_ sender: Any) {
        if responseMemberNew?.company_contact_number ?? "" != "" {
            let phone =  responseMemberNew?.company_contact_number ?? ""
            if let url = URL(string: "tel:\(phone)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func btnOpenImage(_ sender: Any) {
        if ivCompanyProfile.image != nil && responseMemberNew?.company_logo != ""{
            let image = LightboxImage(image:ivCompanyProfile.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapEmail(_ sender: Any) {
        if responseMemberNew?.company_email ?? "" != "" {
            let email = responseMemberNew?.company_email ?? ""
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
   
    @IBAction func tapWebsite(_ sender: Any) {
        if responseMemberNew?.company_website ?? "" != "" {
            guard let url = URL(string: responseMemberNew?.company_website ?? "") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    
    
}
extension TabCompanyProfileVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "company_profile").uppercased())
    }
}

extension TabCompanyProfileVC : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listKeyWord.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! SearchKeywordCell
        cell.lbTitle.text = listKeyWord[indexPath.row]
        cell.lbTitle.textAlignment = .center
        cell.bClose.isHidden = true
        cell.bcloseimg.isHidden = true
        cell.bclosewidth.constant = 5
//        cell.bClose.tag = indexPath.row
//        cell.bClose.addTarget(self, action: #selector(onClickClose(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = UILabel(frame: CGRect.zero)
        label.text = listKeyWord[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 40, height: 36)
        
        //return CGSize(width: 100 , height: 30)
    }
    @objc func onClickClose(sender : UIButton) {
        let index = sender.tag
        listKeyWord.remove(at: index)
        cvKeywords.reloadData()
       // tfKeywords.isEnabled = true
        if listKeyWord.count == 0 {
            //            conHeightKeyword.constant = 40
            cvKeywords.isHidden = true
        }
    }
}
