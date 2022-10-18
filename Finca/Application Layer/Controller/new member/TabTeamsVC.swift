//
//  TabTeamsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 10/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol DidTapMember {
    func  didTapMember(from id:String)
}

class TabTeamsVC: BaseVC {
    
    @IBOutlet weak var cvData: UICollectionView!
    
    @IBOutlet weak var lbNoData: UILabel!
    let cellItem = "TeamMemberCell"
    var responseMemberNew : ResponseMemberNew?
    var  members = [TeamMember]()
    var didTapMember:DidTapMember!
    var memberDetailsVC : MemberDetailsVC?
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellItem, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: cellItem)
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceVertical = false
        
        lbNoData.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let data =  responseMemberNew {
            
            if let memberData = data.member {
                members = memberData
                cvData.reloadData()
            }
            
        }
        if members.count == 0 {
            lbNoData.text = doGetValueLanguage(forKey: "no_data")
        }
        
    }
    
    
   
    @objc func tapMsg(sender: UIButton) {
        if UserDefaults.standard.bool(forKey: StringConstants.KEY_CHAT_ACCESS)
               {
              
                   self.showAlertMessage(title: "Alert", msg: doGetValueLanguage(forKey: "access_denied"))
                   
        }else{
        let model =  members[sender.tag]
        if doGetLocalDataUser().userID ?? "" != model.user_id ?? "" && doGetLocalDataUser().userMobile ?? "" != model.user_mobile ?? ""{
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        //  vc.memberDetailModal =  memberArray[indexPath.row]
        vc.user_id = model.user_id ?? ""
        vc.userFullName = "\( model.user_first_name ?? "") \( model.user_last_name ?? "")"
        vc.user_image = model.user_profile_pic  ?? ""
        vc.public_mobile  =  model.public_mobile ?? ""
        vc.mobileNumber =  model.user_mobile ?? ""
        vc.isGateKeeper = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "self_chat_disabled"), style: .Info, cancelText: "", okText: "OKAY")
            
        }
        
    }
    }
    @objc func tapCall(sender: UIButton) {
        if let public_mobile = members[sender.tag].public_mobile {
            //TODO:  public_mobile 1  private 0 is public
            if public_mobile == "1" {
              
                DispatchQueue.main.async { [self] in
                  
                    self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                }
               
               // baseVC.toast(message: baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), type: .Information)
            } else {
                if let user_mobile = members[sender.tag].user_mobile {
                    //doCall(on: user_mobile)
                    if let phoneCallURL = URL(string: "telprompt://\(user_mobile)") {
                        
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
   
}
extension TabTeamsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! TeamMemberCell
        let item = members[indexPath.row]
        cell.lbDesg.text = item.member_relation_view ?? ""
        cell.lbName.text = item.user_first_name ?? ""
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        
        if item.user_status ?? "" == "1" {
            cell.viewMsg.isHidden = false
        } else {
            cell.viewMsg.isHidden = true
        }
        if item.user_mobile ?? "" != "" && item.user_mobile?.count ?? 0 > 2 {
            cell.viewCall.isHidden = false
        } else {
            cell.viewCall.isHidden = true
        }
        
        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(tapCall(sender:)), for: .touchUpInside)
        
        cell.bMsg.tag = indexPath.row
        cell.bMsg.addTarget(self, action: #selector(tapMsg(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvWidth = collectionView.frame.width
   
        return CGSize(width: cvWidth / 2-1 , height: 231-1 )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if members[indexPath.row].user_status ?? "" != "2" && members[indexPath.row].user_status ?? "" != "0" {
            didTapMember.didTapMember(from: members[indexPath.row].user_id ?? "")
        } else {
            DispatchQueue.main.async { [self] in
                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "this_user_account_is_not_active"), style: .Info , cancelText: self.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "this_user_account_is_not_active"), style: .Info , cancelText: self.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
            }
        }
    }
    
}
extension TabTeamsVC : IndicatorInfoProvider,AppDialogDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if responseMemberNew?.member_status == "0"
        {
            return IndicatorInfo(title: doGetValueLanguage(forKey: "primary_team_members").uppercased())
        }
        else{
            return IndicatorInfo(title: doGetValueLanguage(forKey: "sub_team_members").uppercased())
        }
        
        
    }
    
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}


