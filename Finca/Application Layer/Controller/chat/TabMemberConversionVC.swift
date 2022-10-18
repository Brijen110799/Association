//
//  TabMemberConversionVC.swift
//  Finca
//
//  Created by anjali on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CenteredCollectionView

class TabMemberConversionVC: BaseVC {
    @IBOutlet weak var viewnodata: UIView!
    @IBOutlet weak var ivClear: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblNoRecentChat: UILabel!
    @IBOutlet weak var cvUnits: UICollectionView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var bottomConCv: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    
    var blocks = [BlockModelMember]()
    var  floors = [FloorModelMember]()
    let cellItem = "MemberListCaht"
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    var memberList  = [MemberListModel]()
    var filtermemberList = [MemberListModel]()
    var context : TabCarversionVC!
    var isFirstTimeload = true
   
    var itemInfo: IndicatorInfo = "View"
     
//    init(itemInfo: IndicatorInfo) {
//        self.itemInfo = itemInfo
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func setupInit(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filtermemberList = self.memberList
        ivClear.isHidden = true
//        viewNodata.isHidden = true
        doneButtonOnKeyboard(textField: tfSearch)

        cvUnits.delegate = self
        cvUnits.dataSource = self
        let inbFloor = UINib(nibName: cellItem, bundle: nil)
        cvUnits.register(inbFloor, forCellWithReuseIdentifier: cellItem)

        // Do any additional setup after loading the view.
        doGetUserList()
        addRefreshControlTo(collectionView: cvUnits)
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil)

        tfSearch.addTarget(self, action: #selector(doFilterArray(_: )), for: .editingChanged )
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_member")
        lblNoRecentChat.text = doGetValueLanguage(forKey: "no_recent_chat")
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
       // context.setCountMember(count: "10")
      //  itemInfo = IndicatorInfo(title: "MEMBER", image: UIImage(named: ""),userInfo: "10")
     // _=  indicatorInfo(for: context)
    }
    
   
    @objc func doFilterArray(_ sender : UITextField){
        print("filter")
        
        filtermemberList = sender.text!.isEmpty ? memberList : memberList.filter({ (item: MemberListModel) -> Bool in
            return item.userFullName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        cvUnits.reloadData()
        
        if filtermemberList.count == 0{
            viewNodata.isHidden = false
        }else{
            viewNodata.isHidden = true
        }
        if tfSearch.text == ""{
            ivClear.isHidden = true
            
        }else{
            ivClear.isHidden = false
        }
    }
    override func pullToRefreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        self.blocks.removeAll()
        self.floors.removeAll()
        self.memberList.removeAll()
        
        cvUnits.reloadData()
        doGetUserList()
        refreshControl.endRefreshing()
    }
    @IBAction func onClickClear(_ sender: Any) {
        self.filtermemberList = self.memberList
        cvUnits.reloadData()
        tfSearch.text = ""
        ivClear.isHidden = true
        viewNodata.isHidden = true
    }
    func doGetUserList() {
        self.showProgress()
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getRecentChatMember":"getRecentChatMember",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_type":doGetLocalDataUser().userType!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
             
                do {
                    let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                    if response.status == "200" {
                        
                        //                        self.toast(message: "list of all conversation is found", type: 0)
                        
                        /* var isAppend = true
                         
                         for item in response.member {
                         for subitem in self.memberList {
                         
                         if subitem.flag == "1"{
                         if subitem.userID == item.userID {
                         isAppend = false
                         }
                         }else{
                         isAppend = true
                         }
                         
                         }
                         if isAppend {
                         self.memberList.append(item)
                         }
                         }*/
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        var tempList  = [MemberListModel]()
                        
                        var count = 0
                        for item  in  response.member {
                            var isAppendData = true
                            // item.customDate = dateFormatter.date(from: item.msg_date)
                            //  item.customDate = dateFormatter.date(from: item.msg_date)
                            if item.flag != nil && item.flag == "1" {
                                
                                for (index,itemTemp) in tempList.enumerated() {
                                    
                                    if itemTemp.userID == item.userID {
                                        isAppendData = false
                                        
                                        
                                     if  item.msg_date != nil && itemTemp.msg_date != nil {
                                            
                                        
                                        let d1 = dateFormatter.date(from: item.msg_date!)
                                        let d2 = dateFormatter.date(from: itemTemp.msg_date!)
                                        
                                         
                                        if d1 != nil && d2 != nil {

                                            if d1! > d2! {
                                                tempList.remove(at: index)
                                                isAppendData = true

                                            }
                                        }
                                        }
                                        
                                    }
                                }
                            }
                            
                            if isAppendData {
                                
                                tempList.append(item)
                                if item.chatCount != nil && item.chatCount != "0" {
                                   count = count + 1
                                }
                            }
                            
                        }
                      //  self.itemInfo = IndicatorInfo(title: "MEMBER", image: UIImage(named: ""),userInfo: "\(count)")
                        self.context.setCountMember(count: "\(count)")
                        self.memberList = tempList
                        self.memberList = tempList
                        
                        self.filtermemberList.sort { (item, item2) -> Bool in
                            if item.msg_date != nil && item.msg_date != ""{
                                return ((dateFormatter.date(from: item.msg_date)?.compare(dateFormatter.date(from: item2.msg_date!)!)) != nil)
                            }else{
                                return false
                            }
                        }
                        
                       
                        self.filtermemberList.reverse()
                        self.filtermemberList = self.memberList
                         
                        if  self.filtermemberList.count > 0 {
                            self.viewSearch.isHidden = false
                        } else {
                            self.viewSearch.isHidden = true
                        }
                        
                        self.cvUnits.reloadData()
                        
                    }else {
                        self.viewSearch.isHidden = true
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error",error as Any)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
    @IBAction func onClickAddChat(_ sender: Any) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idAddMemberChatVC") as! AddMemberChatVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func onClickCall(sender : UIButton) {
        let index = sender.tag
        
        if let phone = filtermemberList[index].userMobile {
            let number = phone.replacingOccurrences(of: " ", with: "")
            
            if let url = URL(string: "tel:\(number)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
       
    }
    
    @objc func doThisWhenNotify(notif: NSNotification) {
        
        guard
            let aps =  notif.userInfo?["aps"] as? NSDictionary,
            let click_action =  notif.userInfo?["menuClick"] as? String,
            
            let alert = aps["alert"] as? NSDictionary,
            // let body = alert["body"] as? String
            
            let _ = alert["title"] as? String
            
            
            else {
                
                
                // handle any error here
                return
        }
        // reloadData(message_type: "1", msg: body)
        
        print("click_action" , click_action)
        
        
        if click_action == "chatMsg" {
            // doGetChat(isRefresh: false)
            
            self.doGetUserList()
        }
        
        
    }
    
}
extension TabMemberConversionVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
       // return IndicatorInfo(title: "MEMBER")
        return itemInfo
    }
    
}
extension TabMemberConversionVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filtermemberList.count == 0{
            viewnodata.isHidden = false
        }else{
            viewnodata.isHidden = true
        }
        //        return 0
        return filtermemberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! MemberListChat
        let data = filtermemberList[indexPath.row]
        
        if indexPath.row == filtermemberList.count - 1 {
            cell.viewEmpty.isHidden = false
        }else {
            cell.viewEmpty.isHidden = true
        }
        
        
        //        Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: memberList[indexPath.row].userProfilePic, palceHolder: "user_default")
        //
        if data.chatCount != nil && data.chatCount != "0" {
            cell.viewChatCount.isHidden = false
            cell.lbChatCount.text = data.chatCount
        } else {
            cell.viewChatCount.isHidden = true
        }
        
        cell.viewDeleteChatClicked.isHidden = true
        if data.flag == "2" {
            Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: data.userProfilePic, palceHolder: "groupPlaceholder")
            //   cell.lbUnitName.isHidden = true
            cell.imgCallChat.image = UIImage(named: "group-of-users-silhouette")
            cell.lbUnitName.text = data.msg_data
            cell.lbUserName.text = data.userFullName
        }else{
            var desigation = ""
            if data.company_name ?? "" != "" {
                desigation = "(\(data.company_name ?? ""))"
            }
            
            cell.lbUserName.text = "\(data.userFullName!) \(desigation)"
            Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: data.userProfilePic, palceHolder: "user_default")
            cell.imgCallChat.image = UIImage(named: "call")
            cell.lbUnitName.isHidden = false
            cell.lbUnitName.text = data.msg_data
            
            if data.publicMobile != "1" {
                cell.viewCall.isHidden = false
                cell.bCall.tag = indexPath.row
                cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
            } else {
                cell.viewCall.isHidden = true
            }
           
//            if data.gender != nil && data.gender != ""  {
//                cell.ivGender.isHidden = false
//                if data.gender == "Male" {
//                    cell.ivGender.image = UIImage(named: "gender_male")
//                } else {
//                    cell.ivGender.image = UIImage(named: "gender_female")
//                }
//            } else {
//                cell.ivGender.isHidden = true
//            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == filtermemberList.count - 1 {
            return CGSize(width: collectionView.bounds.width, height: 160)
        }
        return CGSize(width: collectionView.bounds.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = filtermemberList[indexPath.row]
        
        
        if data.flag == "2"{
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idGroupChatVC") as! GroupChatVC
            vc.group_details = data
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
            vc.isGateKeeper = false
            vc.user_id = data.userID!
            vc.userFullName = data.userFullName!
            vc.user_image = data.userProfilePic!
            vc.public_mobile  = data.publicMobile!
            vc.mobileNumber =  data.userMobile!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}


