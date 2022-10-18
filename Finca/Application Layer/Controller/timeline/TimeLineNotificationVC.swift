//
//  TimeLineNotificationVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 13/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class TimeLineNotificationVC: BaseVC {
    let itemCell = "NotificationHomeCell"
    var notifications  =  [NotificationModel]()
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    var timelineVC : TimelineVC!
    @IBOutlet weak var onclickDelete: UIButton!
    @IBOutlet weak var viewD: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.dataSource = self
        tbvData.delegate = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 40
        tbvData.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        lbTitle.text = doGetValueLanguage(forKey: "timeline_notifications")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        
        doGetData()
        addRefreshControlTo(tableView: tbvData)
    }
  
    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        doGetData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
//         let destiController = subStoryboard.instantiateViewController(withIdentifier: "idTimelineVC") as! TimelineVC
//             let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//             newFrontViewController.isNavigationBarHidden = true
//             revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        doPopBAck()
    }
    @IBAction func onClickDeleteAll(_ sender: Any) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "are_you_sure_to_delete_all_notification"))", style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "delete").uppercased())
    }
    func doGetData() {
         
           showProgress()
           //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
           let params = ["key":apiKey(),
                         "getNotificationTimeline":"getNotificationTimeline",
                         "user_id" :doGetLocalDataUser().userID!,
                         "read" : "1",
                         "society_id":doGetLocalDataUser().societyID!]
           print("param" , params)
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPost(serviceName: ServiceNameConstants.user_notification_controller, parameters: params) { (json, error) in
            self.hideProgress()
               if json != nil {
                  
                   do {
                       let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                       
                       
                       if response.status == "200" {
                           
                            self.viewNoData.isHidden = true
                     
                       
                           self.notifications =  response.notification
                        if self.notifications.count > 0
                        {
                            self.onclickDelete.isHidden = false
                            self.viewD.isHidden = false
                        }else{
                            self.onclickDelete.isHidden = true
                            self.viewD.isHidden = true
                        }
                           self.tbvData.reloadData()
                           
                       }else {
                        self.notifications.removeAll()
                            self.viewNoData.isHidden = false
                        self.onclickDelete.isHidden = true
                        self.viewD.isHidden = true
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                           self.tbvData.reloadData()
                         ///  self.showAlertMessage(title: "Alert", msg: response.message)
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
           
           
       }
    func doDelettNotification(user_notification_id:String) {
          showProgress()
          //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
          let params = ["key":apiKey(),
                        "DeleteUserNotification":"DeleteUserNotification",
                        "user_notification_id" :user_notification_id]
          
          
          print("param" , params)
          
          let requrest = AlamofireSingleTon.sharedInstance
          
          
          requrest.requestPost(serviceName: ServiceNameConstants.user_notification_controller, parameters: params) { (json, error) in
              
              if json != nil {
                  self.hideProgress()
                  do {
                      let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                      
                      
                      if response.status == "200" {
                          
                       self.doGetData()
                          
                      }else {
                          self.showAlertMessage(title: "Alert", msg: response.message)
                      }
                  } catch {
                      print("parse error")
                  }
              }
          }
      }
    
    @objc func onclickDelet(sender:UIButton) {
        print("delet", sender.tag)
        
       doDelettNotification(user_notification_id: notifications[sender.tag].user_notification_id)
    }
    
    func doDeleteAll() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "DeleteUserNotificationAllTimline":"DeleteUserNotificationAllTimline",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
       
        requrest.requestPost(serviceName: ServiceNameConstants.user_notification_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                    if response.status == "200" {
                        
                        self.doGetData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func onClickHome(_ sender: Any) {
           goToDashBoard(storyboard: mainStoryboard)
    }
}
extension TimeLineNotificationVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! NotificationHomeCell
        cell.selectionStyle = .none
        cell.lbTitle.text = notifications[indexPath.row].notification_desc
        cell.lbTitle.textColor = .black
        cell.lbDesc.text = ""
        cell.lbDate.text = notifications[indexPath.row].notification_date
        Utils.setImageFromUrl(imageView: cell.imgNotiLogo, urlString: notifications[indexPath.row].notification_logo, palceHolder: "user_default") // user_default
        
        if notifications[indexPath.row].user_id == "0" {
            cell.deleteView.isHidden = true
        } else {
            cell.deleteView.isHidden = false
        }
        cell.imgNotiLogo.layer.cornerRadius = cell.imgNotiLogo.frame.width / 2
        cell.imgNotiLogo.clipsToBounds = true
        cell.imgNotiLogo.contentMode = .scaleAspectFill
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(onclickDelet(sender:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*    if notices[indexPath.row].height != nil {
         print("fff", notices[indexPath.row].height)
         return CGFloat(notices[indexPath.row].height)
         }*/
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idNotificationTimeLineVC") as! NotificationTimeLineVC
        vc.feed_id = notifications[indexPath.row].feed_id
        pushVC(vc: vc)
        
    }
       
}

extension TimeLineNotificationVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete {
            self.dismiss(animated: true) {
                self.doDeleteAll()
            }
        }
    }
}
