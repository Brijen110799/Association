//
//  NotificationVC.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import CoreLocation

class NotificationVC: BaseVC {
    let itemCell = "NotificationHomeCell"
    var notifications  =  [NotificationModel]()
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    var StrISComeFromCustomNotify = ""
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.dataSource = self
        tbvData.delegate = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 40
        tbvData.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        viewNoData.isHidden = true
        doGetData()
        //  addRefreshControlTo(collectionView: cvData)
        addRefreshControlTo(tableView: tbvData)
        lbTitle.text = doGetValueLanguage(forKey: "notifications")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
       
    }

    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        
        doGetData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        //doPopBAck()
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @IBAction func onClickDeleteAll(_ sender: Any) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "are_you_sure_to_delete_all_notification"))", style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "delete").uppercased())
    }
    @IBAction func onClickHome(_ sender: Any) {
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    
    
    
    func doDeleteAll() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "DeleteUserNotificationAll":"DeleteUserNotificationAll",
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
                        self.toast(message: response.message ?? "" , type: .Success)
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
    func doGetData() {
        if self.notifications.count > 0 {
            self.notifications.removeAll()
            self.tbvData.reloadData()
        }
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getNotification":"getNotification",
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
                        //  UserDefaults.standard.set(response.chat_status, forKey: StringConstants.CHAT_STATUS)
                        // UserDefaults.standard.set(response.read_status, forKey: StringConstants.READ_STATUS)
                        
                        /* if self.notifications.count > 0 {
                         self.notifications.removeAll()
                         self.tbvData.reloadData()
                         }*/
                        self.notifications.append(contentsOf: response.notification)
                        self.tbvData.reloadData()
                        
                    }else {
                        self.viewNoData.isHidden = false
                        self.tbvData.reloadData()
                        ///  self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
        
        
    }
    @objc func onclickDelet(sender:UIButton) {
        print("delet", sender.tag)
        
        doDelettNotification(user_notification_id: notifications[sender.tag].user_notification_id)
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
                        self.toast(message: response.message ?? "" , type: .Success)
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
}
extension  NotificationVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! NotificationCell
        cell.lbTitle.text = notifications[indexPath.row].notification_title
        cell.lbDesc.text = notifications[indexPath.row].notification_desc
        cell.lbDate.text = notifications[indexPath.row].notification_date
        Utils.setImageFromUrl(imageView: cell.imgNotiLogo, urlString: notifications[indexPath.row].notification_logo, palceHolder: "notification")
        if notifications[indexPath.row].user_id == "0" {
            cell.deleteView.isHidden = true
        } else {
            cell.deleteView.isHidden = false
        }
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(onclickDelet(sender:)), for: .touchUpInside)
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return notifications.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
}

extension NotificationVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! NotificationHomeCell
        
        cell.lbTitle.text = notifications[indexPath.row].notification_title
        cell.lbDesc.text = notifications[indexPath.row].notification_desc
        cell.lbTitle.textColor = ColorConstant.primaryColor
        cell.lbDate.text = notifications[indexPath.row].notification_date
        Utils.setImageFromUrl(imageView: cell.imgNotiLogo, urlString: notifications[indexPath.row].notification_logo, palceHolder: "finca_logo")
        if notifications[indexPath.row].user_id == "0" {
            cell.deleteView.isHidden = true
        } else {
            cell.deleteView.isHidden = false
        }
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(onclickDelet(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
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
        doActionOnSelectedItem(SelectedItemId: notifications[indexPath.row].notification_action.lowercased(), index: indexPath.row)
    }
    
    func doActionOnSelectedItem(SelectedItemId : String,index:Int!) {
        setPlaceholderLocal(key: "", value:  notifications[index].notification_logo)
        
        switch (SelectedItemId) {
            
        
        case "MemberVC":
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMemberVC")as! MemberVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Members")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            
            break;
       
        case "event":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEventTabVC")as! EventTabVC
            nextVC.menuTitle = doGetValueLanguage(forKey: ("New Event Created"))
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "events")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
       
        case "events".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEventTabVC")as! EventTabVC
            nextVC.menuTitle = doGetValueLanguage(forKey: ("New Event Created"))
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "events")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "announcement".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idNoticeVC")as! NoticeVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Notice Board")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "dailynews".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDailyNewsVC")as! DailyNewsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.menuTitle = "Daily News"
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Daily News")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "referVendor".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idReferVendorVC")as! ReferVendorVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "ReferVendor")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "vehicle".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idVehiclesVC")as! VehiclesVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Vehicles")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        
        case "Complain".lowercased():
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplaintsVC")as! ComplaintsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Complaints")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "vottingactivity".lowercased():
            let nextVC = PollingPagerVC(nibName: "PollingPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Polls")
            nextVC.menuTitle = ""
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "election".lowercased():
            let nextVC = ElectionPagerVC(nibName: "ElectionPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Election")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "BuildingDetailsVC".lowercased():
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idBuildingDetailsVC")as! BuildingDetailsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Building Details")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "EmergencyContactsVC".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEmergencyContactsVC")as! EmergencyContactsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Emergency Numbers")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ProfileFragment".lowercased():
            let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier: "idProfileVC")as! ProfileVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "My Profile")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "SOSVC".lowercased():
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "idSOSVC") as! SOSVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "SOS")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "gallery".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGalleryVC")as! GalleryVC
            nextVC.menuTitle = doGetValueLanguage(forKey: "ios_gallery")
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Gallery")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "documents".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDocumentsVC")as! DocumentsVC
            nextVC.menuTitle = doGetValueLanguage(forKey: "documents")
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Documents")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ServiceProviderVC".lowercased():
             let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderVC")as! ServiceProviderVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Service Providers")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "BalanceSheetVc".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetVc")as! BalanceSheetVc
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Balance Sheet")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ContactUsVC".lowercased():
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idContactFincaTeamVC") as! ContactFincaTeamVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Contact Fincasys Team")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
      
            
        case "SearchOccupationVC".lowercased():
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idOccupationVC")as! OccupationVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Members by Occupation")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "Penalty".lowercased():
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idPenaltyVC")as! PenaltyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Penalty")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "discussion".lowercased():
            let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionListVC")as! DiscussionListVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Discussion Forum")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        
        case "viewSurvey".lowercased():
           
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idSurveyVC")as! SurveyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: "Survey")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "reminder".lowercased():
            let vc = ReminderDailogVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "custom_notification".lowercased():
            print("custom_notification")
            let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CustomNotificationShowVC") as!  CustomNotificationShowVC
           // let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
           // newFrontViewController.isNavigationBarHidden = true
            
            nextVC.Strtitle = notifications[index].notification_title
            nextVC.Strinfo = notifications[index].notification_desc
            nextVC.Strdate = notifications[index].notification_date
            nextVC.StrImageUrl = notifications[index].notification_logo
            
            //revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            break;
        
        case "Balancesheet".lowercased():
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetVc")as! BalanceSheetVc
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = doGetVideoId(clickAction: notifications[index].notification_action)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "Wallet".lowercased():
            let vc = WalletVC()
            pushVC(vc: vc)
            break;
        case "vendor".lowercased():
            if notifications[index].feed_id ?? "" != "" {
                goToVendorDetails(serviceProviderUsersID: notifications[index].feed_id ?? "")
            }
          
            break
            
        default:
            break;
        }
    }
    
    func doGetVideoId(clickAction : String) -> String{
        var id  = ""
        if UserDefaults.standard.data(forKey: "menuData") != nil {
            for item in  doGetLocalMenuData().appmenu {
                
                
                //  print("my v" , clickAction)
                //   print("item" , item.menu_title)
                if item.menu_title == clickAction || item.menu_title_search == clickAction {
                    id = item.tutorial_video
                    break
                }
            }
        }
        
        return id
    }
    
    func goToVendorDetails(serviceProviderUsersID : String) {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                    
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
                    nextVC.service_provider_users_id = serviceProviderUsersID
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
            
            func showAlertMsg(title:String, msg:String) {
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }

    }
    
}
extension NotificationVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete {
            self.dismiss(animated: true) {
                self.doDeleteAll()
            }
        }
    }
}
