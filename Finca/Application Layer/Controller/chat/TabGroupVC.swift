//
//  TabGroupVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
enum NSComparisonResult : Int {
   case OrderedAscending
   case OrderedSame
   case OrderedDescending
}
class TabGroupVC: BaseVC {
    @IBOutlet weak var viewnodata: UIView!
    @IBOutlet weak var cvUnits: UICollectionView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var ivClear: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var viewsearch: UIView!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var lblNoGroupAvailable: UILabel!
    var context : TabCarversionVC!
      
    var memberList  = [MemberListModel]()
    var filtermemberList = [MemberListModel]()
    let cellItem = "MemberListCaht"
    var itemInfo: IndicatorInfo = "View"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAdd.isHidden = true
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
      
        tfSearch.placeholder = (doGetValueLanguage(forKey: "search_group"))
        lblNoGroupAvailable.text = doGetValueLanguage(forKey: "no_recent_chat")
      let dateS  =  "2020-04-29 18:10:57"
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.date(from: dateS)

       print("date "  , convertedDate!)
//        if   UserDefaults.standard.string(forKey: StringConstants.CREATE_GROUP) ?? "" == "0" {
//            self.viewAdd.isHidden = true
//        } else {
//            self.viewAdd.isHidden = false
//        }
//
    }
    
    func setupInit(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }
    override func pullToRefreshData(_ sender: Any) {
           refreshControl.beginRefreshing()
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
      
    @objc func doThisWhenNotify(notif: NSNotification) {
         
         guard
             let aps =  notif.userInfo?["aps"] as? NSDictionary,
             let click_action =  notif.userInfo?["click_action"] as? String,
             
             let alert = aps["alert"] as? NSDictionary,
             // let body = alert["body"] as? String
             
             let _ = alert["title"] as? String
             
             
             else {
                 
                 
                 // handle any error here
                 return
         }
         // reloadData(message_type: "1", msg: body)
         
         print("click_action" , click_action)
         
         
         if click_action == "chatMsgGroup" {
             // doGetChat(isRefresh: false)
             
             self.doGetUserList()
         }
         
         
     }
    
    func doGetUserList() {
          self.showProgress()
          
          //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
          let params = ["key":apiKey(),
                        "getGroupListRecent":"getGroupListRecent",
                        "society_id":doGetLocalDataUser().societyID!,
                        "user_id":doGetLocalDataUser().userID!,
                        "unit_id":doGetLocalDataUser().unitID!]
          
          
          print("param" , params)
          
          let requrest = AlamofireSingleTon.sharedInstance
          requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            self.hideProgress()
              if json != nil {
                  
                  do {
                      let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                      if response.status == "200" {
                          
                        
                          
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        self.memberList = response.member
                          
                          
                          if self.memberList.count == 0
                          {
                              self.viewsearch.isHidden = true
                              self.viewnodata.isHidden = true
                              
                          }
                          else{
                              self.viewsearch.isHidden = false
                              self.viewnodata.isHidden = false
                          }
                        
                            
                          
                                      
                        
                         
                        self.memberList.sort { (item, item2) -> Bool in

                            if  item.msg_date != nil && item.msg_date != "" && item2.msg_date != nil && item2.msg_date != ""  {
                                //   print(item.msg_date)
                                // return true
//                                return ((dateFormatter.date(from: item.msg_date)?.compare(dateFormatter.date(from: item2.msg_date!)!)) != nil)
                                
                                return dateFormatter.date(from: item.msg_date!)! > dateFormatter.date(from: item2.msg_date!)!
                            } else {
                                return false
                            }

                        }
                        
                        self.filtermemberList = self.memberList
                       // self.filtermemberList.reverse()
                           
                          self.cvUnits.reloadData()
                        var count  = 0
                        
                        for item in   self.memberList {
                            if item.chatCount != nil && item.chatCount != "0"{
                                count = count + 1
                            }
                        }
                          self.context.setCountGroup(count: "\(count)")
                     
                          
                      }else {
                          self.viewsearch.isHidden = true
                          self.viewNodata.isHidden = true
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
    

    @IBAction func onClickAddGroup(_ sender: Any) {
        let nextVC = storyboardConstants.chat.instantiateViewController(withIdentifier: "idAddGroupChatVC")as! AddGroupChatVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
extension TabGroupVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return  itemInfo
       // return IndicatorInfo(title: "GROUP")
    }
    
}
extension TabGroupVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
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
        cell.imgCallChat.isHidden = true
        if data.flag == "2" {
            Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: data.userProfilePic, palceHolder: "groupPlaceholder")
            //   cell.lbUnitName.isHidden = true
          //  cell.imgCallChat.image = UIImage(named: "group-of-users-silhouette")
            cell.imgCallChat.isHidden = true
            cell.lbUnitName.text = data.msg_data
            cell.lbUserName.text = data.userFullName
        }else{
            
            cell.lbUserName.text = "\(data.userFullName ?? "") \(data.blockName!) \(data.unitName!)"
           
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
            //  vc.memberDetailModal =  memberArray[indexPath.row]
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
     @objc func onClickCall(sender : UIButton) {
           let index = sender.tag
           
           let phone = filtermemberList[index].userMobile!
           if let url = URL(string: "tel:\(phone)") {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
       }
    
}

