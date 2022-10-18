//
//  HomeNavigationMenuController.swift
//  Finca
//
//  Created by harsh panchal on 29/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
import FittedSheets
import DeviceKit
struct menuCell {
    var title : String!
    var image : String!
    var isSelectd : Bool!
}

class HomeNavigationMenuController: BaseVC {
    var multiUnitList = [LoginResponse]()
    @IBOutlet weak var imgProfile: UIImageView!
    var itemCell = "NavigationMenuCell"
    var menuData = [menuCell]()
    var appMenus = [MenuModel]()
    var multiSocietyArray = [LoginResponse]()
    var userType : String!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lblVersionCode: UILabel!
    @IBOutlet weak var lblBuildingName: UILabel!
    @IBOutlet weak var lblUnitName: MarqueeLabel!
    @IBOutlet weak var btnUnitSelect: UIButton!
    
    @IBOutlet weak var lbUnitName: MarqueeLabel!
    @IBOutlet weak var viewUnit: UIView!
    @IBOutlet weak var viewBuilding: UIView!
    @IBOutlet weak var viewAddMoreBuilding: UIView!
    @IBOutlet weak var viewAddMoreUnit: UIView!
    
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var viewMyActivities: UIView!
    
    @IBOutlet weak var lbSociety: UILabel!
    @IBOutlet weak var bSocietyAddMore: UIButton!
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var bUnitAddMore: UIButton!
    @IBOutlet weak var lbHome: UILabel!
    @IBOutlet weak var lbMyActivity: UILabel!
    @IBOutlet weak var lbMyTranction: UILabel!
    @IBOutlet weak var lbMyWallet: UILabel!
    @IBOutlet weak var lbSetting: UILabel!
    @IBOutlet weak var lbReminder: UILabel!
    @IBOutlet weak var lbRateApp: UILabel!
    @IBOutlet weak var lbShareApp: UILabel!
    @IBOutlet weak var lbLogout: UILabel!
    @IBOutlet weak var lbCheckUpdate: UILabel!
    @IBOutlet weak var lbTitleProfileCompleteness: UILabel!
    @IBOutlet weak var lbProfileCompleteness: UILabel!
    
    @IBOutlet weak var lbSocietyAddMore: UILabel!
    @IBOutlet weak var lbUnitAddMore: UILabel!
    
    @IBOutlet weak var progressbarProfile: UIProgressView!
    @IBOutlet weak var lbProfile: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
          //    imgProfile.layer.borderWidth = 2
        //    imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //    imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        //   Utils.setImageFromUrl(imageView: imgProfile, urlString: doGetLocalDataUser().userProfilePic!, palceHolder: "fincasys_notext")
        
        viewBuilding.makeBubbleView()
        viewUnit.makeBubbleView()
        setData()
        setupMarqee(label: lblUnitName)
        setupMarqee(label: lbUnitName)
       
        let gradientIm = gradientImage(colors: [#colorLiteral(red: 0.3294117647, green: 0.7176470588, blue: 0.7294117647, alpha: 1).cgColor,#colorLiteral(red: 0.5803921569, green: 0.8705882353, blue: 0.5607843137, alpha: 1).cgColor],
                                          locations: nil)
        progressbarProfile.progressImage = gradientIm
        progressbarProfile.transform = progressbarProfile.transform.scaledBy(x: 1, y: 4)
        
     }
    func setData() {
        lbSociety.text = doGetValueLanguage(forKey: "society")
       // bSocietyAddMore.setTitle(doGetValueLanguage(forKey: "add_more"), for: .normal)
        lbUnit.text = doGetValueLanguage(forKey: "unit")
       // bUnitAddMore.setTitle(doGetValueLanguage(forKey: "add_more"), for: .normal)
        lbHome.text = doGetValueLanguage(forKey: "home")
        lbMyActivity.text = doGetValueLanguage(forKey: "my_activities")
        lbMyTranction.text = doGetValueLanguage(forKey: "my_transaction")
        lbMyWallet.text = doGetValueLanguage(forKey: "my_wallet")
        lbSetting.text = doGetValueLanguage(forKey: "settings")
        lbReminder.text = doGetValueLanguage(forKey: "reminder")
        lbRateApp.text = doGetValueLanguage(forKey: "rate_app")
        lbShareApp.text = doGetValueLanguage(forKey: "share_app")
        lbLogout.text = doGetValueLanguage(forKey: "logout")
        lbCheckUpdate.text = doGetValueLanguage(forKey: "check_for_update")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lblVersionCode.text = "V.\(appVersion ?? "1")"
        
        lbSocietyAddMore.text = doGetValueLanguage(forKey: "add_more").uppercased()
        lbUnitAddMore.text = doGetValueLanguage(forKey: "add_more").uppercased()
        lbProfile.text = doGetValueLanguage(forKey: "profile")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch doGetLocalDataUser().userType {
        case "0":
            userType = "(Owner)"
        case "1":
            userType = "(Tenant)"
        default:
            break;
        }
        self.multiUnitList.removeAll()
        btnUnitSelect.isEnabled = false
        doCallMultiUnitApi()
        lblBuildingName.text = doGetLocalDataUser().society_name ?? ""
        lblUnitName.text = "\(doGetLocalDataUser().floorName ?? "")-\(doGetLocalDataUser().blockName ?? "")"
        
        lbUnitName.text = "\(doGetLocalDataUser().designation ?? "")-\(doGetLocalDataUser().company_name ?? "")"
        Utils.setImageFromUrl(imageView: imgProfile, urlString: doGetLocalDataUser().userProfilePic!, palceHolder: "user_default")

        lbUserName.text = doGetLocalDataUser().userFullName
    
        self.multiSocietyArray.removeAll()
        let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
       
        if data != nil{
            let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
           // print(decoded?.SocietyDetails.count)
            multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
        }
        lbProfileCompleteness.text = "\(doGetLocalDataUser().profile_progress ?? "0")%"
        
        if let countP = doGetLocalDataUser().profile_progress {
            let count = Float(countP)! / 100
            self.progressbarProfile.progress = count
            print("process cal count " ,  count)
        }
       
       // print( "progress \(doGetLocalDataUser().profile_progress)")
      
        
       
       
       /* switch doGetLocalDataUser().memberStatus ?? "" {
        case "0":
            //            userType = "Owner"
            self.viewAddMoreUnit.isHidden = false
            self.viewAddMoreBuilding.isHidden = false
        case "1":
            //            userType = "Tenant"
            self.viewAddMoreUnit.isHidden = true
            self.viewAddMoreBuilding.isHidden = true
        default:
            break;
        }*/
        
        if doGetLocalDataUser().memberStatus ?? "" == "0"{
            self.viewAddMoreUnit.isHidden = false
            self.viewAddMoreBuilding.isHidden = false
        } else {
            self.viewAddMoreUnit.isHidden = true
            self.viewAddMoreBuilding.isHidden = true
        }
      //print(doGetLocalMenuData())
        if instanceLocal().getHideMYActivity(){
            viewMyActivities.isHidden = true
        } else {
            viewMyActivities.isHidden = false
        }
        viewWallet.isHidden = true
//        if UserDefaults.standard.bool(forKey: StringConstants.KEY_VIRTUAL_WALLET) {
//            viewWallet.isHidden = false
//        }else {
//            viewWallet.isHidden = true
//        }
    }
    
    @IBAction func btnSelectBuilding(_ sender: UIButton) {
    }
    
    @IBAction func btnShare(_ sender: UIButton) {
        
        
        let data = instanceLocal().getShareappcontent()
        
        
        let image = UIImage(named: "advert_share")
        let shareAll = [ image as Any, data ] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnAddMoreBuilding(_ sender: UIButton) {
        
    }
    @IBAction func btnCheckForUpdate(_ sender: UIButton) {
        
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        destiController.StrPass = "1"
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
     
    }
    @IBAction func btnSelectUserDialog(_ sender: UIButton) {
        let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMultiUserAndSocietyDialogVC")as! MultiUserAndSocietyDialogVC
        pickerVC.multiUnitList.removeAll()
        pickerVC.multiUnitList = self.multiUnitList
        pickerVC.context = self
        let sheetController = SheetViewController(controller: pickerVC, sizes: [.fixed(200),.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 8)
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false) {
            self.revealViewController()?.revealToggle(animated: true)
        }
    }
    
    @IBAction func btnAddMoreBuildings(_ sender: UIButton) {
//        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddBuildingSelectLocationVC")as! AddBuildingSelectLocationVC
//
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
        let langKey = "\(StringConstants.LANGUAGE_ID_ADD_MORE)"
        UserDefaults.standard.setValue(doGetLanguageId(), forKey: langKey)
        
        let dataKey = "\(StringConstants.LANGUAGE_DATA_ADD_MORE)"
        
       
        let key = "\(StringConstants.LANGUAGE_DATA)\( self.doGetLocalDataUser().societyID ?? "0")"
        var dictLo = NSDictionary()
        
        if  let data  = UserDefaults.standard.value(forKey: key)  {
            dictLo  = data  as! NSDictionary
            UserDefaults.standard.set(dictLo, forKey: dataKey)
        }
        
        
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
        vc.isAddBuilding = true
        vc.city_id = "0"
        vc.state_id = "0"
        vc.country_id = "101"
        vc.languageDictionary = dictLo
        vc.languageId = doGetLanguageId()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnSelectSociety(_ sender: Any) {
        let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMultiUserAndSocietyDialogVC")as! MultiUserAndSocietyDialogVC
        pickerVC.multiSocietyList.removeAll()
        pickerVC.multiSocietyList = self.multiSocietyArray
        pickerVC.context = self
        let sheetController = SheetViewController(controller: pickerVC, sizes: [.fixed(200),.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 8)
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false) {
            self.revealViewController()?.revealToggle(animated: true)
        }
    }
    
    @IBAction func btnAddMoreUnit(_ sender: UIButton) {
        
       /* let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSelectUserTypeVC")as! SelectUserTypeVC
        nextVC.userType = "0"
        print(doGetLocalDataUser().userMobile!)
        nextVC.society_id = doGetLocalDataUser().societyID!
        nextVC.mobileNumber = doGetLocalDataUser().userMobile!
        nextVC.isUserinsert = false
        self.navigationController?.pushViewController(nextVC, animated: true)*/
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
        vc.society_id = doGetLocalDataUser().societyID!
        vc.userType = "0"
        vc.isUserInsert = false
        vc.isAddMoreSociety = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doCallMultiUnitApi(){
       
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let device = Device.current
        let params = ["getMultiUnitsNew":"getMultiUnitsNew",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!,
                      "country_code":doGetLocalDataUser().countryCode ?? "",
                      "phone_brand":"Apple",
                      "device":"ios",
                      "phone_model":device.description,]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                //                self.hideProgress()
                print(Data as Any)
                do {
                    let response = try JSONDecoder().decode(MultiUnitResponse.self, from: Data!)
                    if response.status == "200"{
                        self.btnUnitSelect.isEnabled = true
                        self.multiUnitList.append(contentsOf: response.units)
                       
                    }else{
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }else{
            }
        }
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        let destiController = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserProfileVC") as! UserProfileVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    static func getStoryboard() -> UIStoryboard{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard
    }
    
    func showDailogLogout() {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idLogoutDialogVC") as! LogoutDialogVC
        if multiSocietyArray.count == 1 {
            vc.isAllButtonHidden = true
        }
        vc.delegate = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.7
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func onClickReminder(_ sender: Any) {
        let vc = ReminderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickMyTransaction(_ sender: Any) {
        let vc = MyTransactionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSettingsClicked(_ sender: UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSettingsVC")as! SettingsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        // self.swRE
    }
    @IBAction func onClickDashBoard(_ sender: Any) {
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    @IBAction func onClickLogout(_ sender: Any) {
        showDailogLogout()
    }
    @IBAction func onClickMyActivity(_ sender: UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
        let nextVC = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idUserActivityViewVC")as! UserActivityViewVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickRating(_ sender: Any) {
        
        let openAppStoreForRating = doGetValueLanguage(forKey: "app_url_ios")
        if let url = URL(string: openAppStoreForRating), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showAlertMessage(title: "Cannot open AppStore", msg: "Please select our app from the AppStore and write a review for us. Thanks!!")
            // showAlertMessage(title: "Cannot open AppStore",message: "Please select our app from the AppStore and write a review for us. Thanks!!")
        }
//        let destiController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idOfferVC") as! OfferVC
//        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//        newFrontViewController.isNavigationBarHidden = true
//        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        
    }
    func doLogout(userID:String!,isPartialLogout:Bool = false) {
        // "read":"0" mean is unread massage
        
        if isPartialLogout{
            showProgress()
            let params = ["key":ServiceNameConstants.API_KEY,
                          "user_logout":"user_logout",
                          "user_id" : doGetLocalDataUser().userID!,
                          "user_mobile":doGetLocalDataUser().userMobile!,
                          "country_code":doGetLocalDataUser().countryCode!]
            
            print("param" , params)
            
            let request = AlamofireSingleTon.sharedInstance
            
            request.requestPost(serviceName: ServiceNameConstants.login, parameters: params) { (json, error) in
                self.hideProgress()
                if json != nil {
                    
                    do {
                        let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                        if response.status == "200" {
                            
//                            UserDefaults.standard.setValue(nil, forKey: self.instanceLocal().planLastShowDate)
                            UserDefaults.standard.removeObject(forKey: self.instanceLocal().planLastShowDate)
                            
                            print("society before deletion",self.multiSocietyArray.count)
                            for (index,item) in self.multiSocietyArray.enumerated(){
                                if item.societyID == self.doGetLocalDataUser().societyID!{
                                    print("index index",index)
                                    self.multiSocietyArray.remove(at: index)
                                    break
                                }
                            }
                            if self.multiSocietyArray.count == 0{
                                UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                                UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
                               
                                Utils.setRootSocietyList()
                                UserDefaults.standard.set(nil, forKey: StringConstants.SLIDER_DATA)
                            }else{
                                print("society after deletion",self.multiSocietyArray.count)
                                let multiSociety = SocietyArray(SocietyDetails: self.multiSocietyArray)
                                if let encoded = try? JSONEncoder().encode(multiSociety) {
                                    UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                                }
                                let data = self.multiSocietyArray[0]
                                UserDefaults.standard.set(data.baseURL, forKey: StringConstants.KEY_BASE_URL)
                                UserDefaults.standard.set(data.apiKey, forKey: StringConstants.KEY_API_KEY)
                                if let encoded = try? JSONEncoder().encode(data) {
                                    UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                                }
                                UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                                UserDefaults.standard.set(nil, forKey: StringConstants.SLIDER_DATA)
                                UserDefaults.standard.set(data.userProfilePic,forKey: StringConstants.KEY_PROFILE_PIC)
                                Utils.setHome()
                               // self.viewWillAppear(true)
                                
                            }
                        }else {
                            
                        }
                        print(json as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }else{

            let tempList = multiSocietyArray
            for item in tempList{
                doCallLogoutAllApi(SocietyDetails: item)
            }
            UserDefaults.standard.removeObject(forKey: self.instanceLocal().planLastShowDate)
            UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
            Utils.setRootSocietyList()
            UserDefaults.standard.set(nil, forKey: StringConstants.SLIDER_DATA)
        }
    }
    
    func doCallLogoutAllApi(SocietyDetails : LoginResponse!){
        //        showProgress()
        let params = ["key":SocietyDetails.apiKey!,
                      "user_logout":"user_logout",
                      "user_id" : SocietyDetails.userID!,
                      "user_mobile":SocietyDetails.userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.login, parameters: params,baseUer: SocietyDetails.baseURL! + StringConstants.APINEW) { (json, error) in
            //            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    @IBAction func tapWallat(_ sender: Any) {
        let vc = WalletVC()
        pushVC(vc: vc)
    }
    
   private func gradientImage(colors: [CGColor],
                           locations: [NSNumber]?) -> UIImage? {

       let gradientLayer = CAGradientLayer()
       gradientLayer.frame = progressbarProfile.frame
       gradientLayer.colors = colors
       // This makes it horizontal
       gradientLayer.startPoint = CGPoint(x: 0.0,
                                       y: 0.5)
       gradientLayer.endPoint = CGPoint(x: 1.0,
                                       y: 0.5)

       UIGraphicsBeginImageContext(gradientLayer.bounds.size)
       gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
       guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
       UIGraphicsEndImageContext()
       return image
   }
}
extension HomeNavigationMenuController : LogoutDialogDelegate{
    func btnAllSocietyLogoutClicked() {
        doLogout(userID: doGetLocalDataUser().userID)
    }
    
    func btnCurrentSocietyLogoutClicked() {
        doLogout(userID: doGetLocalDataUser().userID,isPartialLogout: true)
    }
}
