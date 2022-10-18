//
//  TabGateKeeperVC.swift
//  Finca
//
//  Created by anjali on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
struct ResponseGatekeeper : Codable{
    let status:String!//  "status" : "200",
    let message:String!//  "message" : "Gatekeeper Infromation Get success."
    let gatekeeper:[GatekeeperModel]!
}

struct GatekeeperModel : Codable {
    let chat_status:String!// "chat_status" : "0",
    let emp_id:String!// "emp_id" : "127",
    let emp_profile:String!//  "emp_profile" : "http:\/\/www.fincasys.com\/img\/emp\/8401565883_1560445089.png",
    let emp_name:String!//  "emp_name" : "Ajit Guard"
    let msg_date  :String! //" : "",
    let msg_data  :String! //" : "",
    let emp_mobile  :String!
    
}

class TabGateKeeperVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblnodata: UILabel!
    @IBOutlet weak var ivClear: UIImageView!
    
    let itemCell = "GateKeeperCell"
    var context : TabCarversionVC!
    var gatekeepers = [GatekeeperModel]()
    var filteredArray = [GatekeeperModel]()
    var itemInfo: IndicatorInfo = "View"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filteredArray = self.gatekeepers
        lblnodata.isHidden = true
        ivClear.isHidden = true
        doneButtonOnKeyboard(textField: tfSearch)
        // Do any additional setup after loading the view.
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        doGetSecurity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil)
        
        tfSearch.addTarget(self, action: #selector(doFilterArray(_: )), for: .editingChanged )
       tfSearch.placeholder = doGetValueLanguage(forKey: "search_gatekeeper")
        lblnodata.text = doGetValueLanguage(forKey: "no_result_available")
    }
    func setupInit(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }
    @objc func doFilterArray(_ sender : UITextField){
           print("filter")
           
        filteredArray = sender.text!.isEmpty ? gatekeepers : gatekeepers.filter({ (item: GatekeeperModel) -> Bool in
           return item.emp_name.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
                 })
        cvData.reloadData()
        
    
        if filteredArray.count == 0{
            lblnodata.isHidden = false
        }else{
             lblnodata.isHidden = true
             
        }
        if tfSearch.text == ""{
                   ivClear.isHidden = true
                   
               }else{
            ivClear.isHidden = false
               }
       }
   
    
    @IBAction func onClickClear(_ sender: Any) {
        self.filteredArray = self.gatekeepers
        cvData.reloadData()
        tfSearch.text = ""
        ivClear.isHidden = true
        lblnodata.isHidden = true
        
    }
    
    func doGetSecurity() {
        self.showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getekeeperList":"getekeeperList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { [self] (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseGatekeeper.self, from:json!)
                    if response.status == "200" {
                        
                        self.gatekeepers =  response.gatekeeper
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        self.gatekeepers.sort { (item, item2) -> Bool in
                            
                            if  item.msg_date != nil && item.msg_date != "" && item2.msg_date != nil && item2.msg_date != ""  {
                             //   print(item.msg_date)
                               // return true
                              //  return ((dateFormatter.date(from: item.msg_date)?.compare(dateFormatter.date(from: item2.msg_date!)!)) != nil)
                           return dateFormatter.date(from: item.msg_date!)! > dateFormatter.date(from: item2.msg_date!)!
                            } else {
                                return false
                            }
                            
                        }
                        var count  = 0
                        
                        for item in   self.gatekeepers {
                            if item.chat_status != nil && item.chat_status != "0"{
                                count = count + 1
                            }
                        }
                        
                        context.setCountGrad(count: "\(count)")
                      //  self.gatekeepers.reverse()
//                        self.filteredArray = self.filteredArray.sorted(by: { (lhs, rhs) -> Bool in return (Int(lhs.chat_status!)!) > (Int(rhs.chat_status!)!) })
//
                      //  self.gatekeepers = self.gatekeepers.sorted(by: { (lhs, rhs) -> Bool in return (dateFormatter.date(from: lhs.msg_date!)!) > (dateFormatter.date(from: rhs.msg_date!)!) })
                           
                        self.filteredArray = self.gatekeepers
                      //  self.filteredArray.reverse()
                         self.cvData.reloadData()
                         
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    @objc func onClickOnCall(sender:UIButton) {
        
            let index = sender.tag
        //print("clcicl" , index)
        //   let phone = employees[index].emp_mobile!
        
        let phone = filteredArray[index].emp_mobile!
        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
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
                      
               
               if click_action == "chatMsg" {
                  // doGetChat(isRefresh: false)
                
                self.doGetSecurity()
               }
               
               
           }
     
    
    
}
extension TabGateKeeperVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
      //  return IndicatorInfo(title: "GUARD")
    }
    
}
extension TabGateKeeperVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return  filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! GateKeeperCell
        
        let item = filteredArray[indexPath.row]
        
        Utils.setRoundImage(imageView: cell.ivImage)
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: item.emp_profile, palceHolder: "user_default")
        cell.lbName.text = item.emp_name
        if item.msg_data != nil && item.msg_data != "" {
            cell.lbLastMsg.text = item.msg_data
        } else {
            cell.lbLastMsg.text = ""
        }
        if item.chat_status != "0"{
        cell.lbUnreadMessage.text = item.chat_status
            cell.lbUnreadMessage.isHidden = false
        }else{
            cell.lbUnreadMessage.isHidden = true
        }
        cell.bCall.tag = indexPath.row
        
        cell.bCall.addTarget(self, action: #selector(onClickOnCall(sender:)), for: .touchUpInside)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth, height: 70)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        let data = filteredArray[indexPath.row]
        vc.isGateKeeper =  true
        vc.userid =  data.emp_id
        vc.name =  data.emp_name
        vc.profile =  data.emp_profile
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
