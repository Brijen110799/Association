//
//  HomeVC.swift
//  Finca
//
//  Created by harsh panchal on 29/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
import FittedSheets
import DeviceKit
import Speech
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseMessaging
import CoreLocation
struct ResponseNotification : Codable {
    //chat_user_access
   // timeline_user_access
    let chat_user_access : Bool!
    let timeline_user_access : Bool!
    let entry_all_visitor_group : String!
    let group_chat_status : String!
    let screen_sort_capture_in_timeline : String!
    let create_group : String!
    let tenant_registration : String!
    let visitor_on_off : String!
    let read_status:String!// "read_status" : "9",
    let status:String!//"status" : "200",
    let message:String!// "message" : "Get Notification success.",
    let chat_status:String!// "chat_status" : "0"
    let notification : [NotificationModel]!
    let last_feed_id : String!
    let hide_member_parking : Bool!
    let professional_on_off : Bool!
    let virtual_wallet : Bool!
    
}
struct NotificationModel : Codable {
    let notification_logo : String! //"notification_logo" : ""
    let notification_title:String!   //"notification_title" : "Parking Allocated",
    let notification_action:String!  //"notification_action" : "myparking",
    let read_status:String! // "read_status" : "0",
    let notification_date:String!  //"notification_date" : "2019-06-12 01:03:00",
    let user_id:String! // "user_id" : "410",
    let notification_status:String! // "notification_status" : "0",
    let user_notification_id:String! // "user_notification_id" : "1435",
    let notification_desc:String!  // "notification_desc" : "by Admin"
    let feed_id:String!  // "notification_desc" : "by Admin"
}

struct  ResponseMenuData : Codable {
    let status : String!// "status" : "200",
    let message : String!// "message" : "success."
    let hide_timeline : Bool!
    let hide_chat : Bool!
    let hide_myactivity : Bool!
    let festival_date : String!
    let appmenu : [MenuModel]!
    let slider : [Slider]!
    let view_status : String!// "message" : "success."
    let active_status : String!// "message" : "success."
    let advertisement_url : String!// "message" : "success."
    let chat_video : String!//  "chat_video" : "jPd6hn79Mo8",
    let setting_video : String!
    let timeline_video : String!//  "timeline_video" : "czNP5ksue1w",
    let homepage_video : String!//  "timeline_video" : "czNP5ksue1w",
}
struct MenuModel : Codable {
    let is_new : Bool!
    let menu_title : String!
    let menu_title_search : String!//" : "SOS",  // menu_title_search
    let app_menu_id : String!//" : "18",
    let menu_icon : String!//" : https:\/\/www.fincasyscom\/\/img\/app_icon\/sos_graphic.png",
    let menu_click : String!//" : "SosFragment",
    let ios_menu_click : String!//" : "SOSVC",
    let menu_sequence : String!//" : "18"
    let tutorial_video: String!
    var isBlink : Bool!
    let appmenu_sub : [SubMenuModel]!
}
struct SubMenuModel : Codable {
    let menu_icon : String! //" : "https:\/\/developer.fincasys.com\/img\/app_icon\/housie.png",
    let menu_click : String! //" : "HosieInfoPageActivity",
    let menu_sequence : String! //" : "1",
    let ios_menu_click : String! //" : "HousieVC",
    let app_menu_id : String! //" : "32",
    let menu_title : String! //" : "Housie",
    let tutorial_video : String! //" : ""
}
public var isShowReminderAlert = true
public var isComeFromTimeline = false
class HomeVC: BaseVC,SFSpeechRecognizerDelegate,PassDataVoicesearchDelegate  {
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var viewTimelineCircle: UIView!
    @IBOutlet weak var viewMainBottomNavigation: UIView!
    @IBOutlet weak var conHightBottomNavigation: NSLayoutConstraint!
    @IBOutlet weak var lbHome: UILabel!
    @IBOutlet weak var lbChat: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewTimeLine: UIView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var imgClose : UIImageView!
    @IBOutlet weak var lbGreeting: UILabel!
    @IBOutlet weak var lbGeotag: UILabel!
    @IBOutlet weak var viewVideoPlay: UIView!
    @IBOutlet weak var tbvHomeMenu: UITableView!
    
    var index = 0
    var itemCell = "HomeScreenCvCell"
    var itemCellVendor = "HomeVendorCell"
    var itemCellCircular = "HomeCircularCell"
    var itemCellMember = "HomeMemberCell"
    var appMenus = [MenuModel]()
    var appMenusNew = [MenuModel]()
    var NewLogin = [LoginResponse]()
    var StrPass = ""
   // var loadFirstTimeSlide = true
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    var FlagShowAccountPopup = Bool()
    var fullStr = ""
    var multiSocietyArray = [LoginResponse]()
    var slider = [Slider]()
    var urlStr : String!
    var phone : String!
    var Arrappmenu_sub : [SubMenuModel]!
    private let request = AlamofireSingleTon.sharedInstance
    var db: Firestore! // forebase database
    var noticeData =  [ModelNoticeBoard]()
    var serviceProvider =  [LocalServiceProviderListModel]()
    var indexForCircular = 0
    
    var collectionLayout: CollectionLayoutCircular = CollectionLayoutCircular()
    let locationManager = CLLocationManager()
    var memberArray = [HomeMemberModel]()
    let itemCellHome = "SectionSliderCell"
    let itemCellHomeCommon = "HomeViewCommonCell"
    
    //9549549606
    override func viewDidLoad() {
        super.viewDidLoad()
      
        lbTitle.text = doGetValueLanguage(forKey: "app_name")
        
        let nibHome = UINib(nibName: itemCellHomeCommon, bundle: nil)
        tbvHomeMenu.register(nibHome, forCellReuseIdentifier: itemCellHomeCommon)
        let nibNameHeader = UINib(nibName:itemCellHome, bundle: nil)
        tbvHomeMenu.register(nibNameHeader, forCellReuseIdentifier: itemCellHome)
        tbvHomeMenu.delegate = self
        tbvHomeMenu.dataSource = self
        tbvHomeMenu.estimatedRowHeight = 50
        tbvHomeMenu.rowHeight = UITableView.automaticDimension
        tbvHomeMenu.sectionHeaderHeight = UITableView.automaticDimension
        tbvHomeMenu.estimatedSectionHeaderHeight = 1
        tbvHomeMenu.keyboardDismissMode = .interactive
        tbvHomeMenu.separatorStyle = .none
        
        doInintialRevelController(bMenu: bMenu)
        appMenusNew = []
        doInitSpeechRecogniser()
      
        if self.StrPass == "1" {
            self.showCheckForUpdateDialog()
        }
        viewMainBottomNavigation.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
       
        
        initFireaseUser()
        doSetForLanguage()
        
       
       }
  
    func initFireaseUser() {
      /*  let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let cDate = format.string(from: Date())
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
       var userModel = MemberModelChat()
        userModel.userChatId = userChatId()
        userModel.userId = doGetLocalDataUser().userID ?? ""
        userModel.publicMobile = doGetLocalDataUser().publicMobile ?? ""
        userModel.userMobile = doGetLocalDataUser().userMobile ?? ""
        userModel.userProfile = doGetLocalDataUser().userProfilePic ?? ""
        userModel.userType = StringConstants.RESIDENT
        userModel.gender = doGetLocalDataUser().gender ?? ""
        userModel.userBlockName = unitName()
        userModel.userName = doGetLocalDataUser().userFullName ?? ""
        userModel.lastSeen = cDate
        userModel.userToken = UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? ""
        userModel.online = true
        
       
        do {
            try  db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Members").document(userChatId()).setData(from: userModel)
            if let encoded = try? JSONEncoder().encode(userModel) {
                UserDefaults.standard.set(encoded, forKey: StringConstants.USER_CHAT_DATA)
            }
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }*/
        Messaging.messaging().subscribe(toTopic: "allUser") { error in
          print("Subscribed to weather allUser")
        }
      
    }
    func doInitSpeechRecogniser(){
           //  VwBlink.isHidden = true
              //  imgClose.image = UIImage.init(named: "mic_on")
               // imgClose.setImageColor(color: .white)
              //  microphoneButton.isEnabled = true
                speechRecognizer?.delegate = self
                SFSpeechRecognizer.requestAuthorization { (authStatus) in
                  //var isButtonEnabled = false
        
                    switch authStatus {
                    case .authorized:
                        break
                     //  isButtonEnabled = true
        
                    case .denied:
                    // isButtonEnabled = false
                        print("User denied access to speech recognition")
        
                    case .restricted:
                   //   isButtonEnabled = false
                        print("Speech recognition restricted on this device")
        
                    case .notDetermined:
                    //  isButtonEnabled = false
                        print("Speech recognition not yet authorized")
                    @unknown default:
                        fatalError()
                    }
                   
                }
    }
    func Passdata(SelectedItemId: String, menu_icon: String, menu_title: String, tutorialVideo: String, Subcategory: [SubMenuModel]) {
        
        doActionOnSelectedItem(SelectedItemId: SelectedItemId , menu_icon: menu_icon , menu_title: menu_title , tutorialVideo: tutorialVideo , Subcategory: Subcategory )
        
    }
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        DispatchQueue.main.async { [unowned self] in
                
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [self] (result, error) in
                var isFinal = false
                
                if result != nil {
                    
                    isFinal = (result?.isFinal)!
                    let Str = result?.bestTranscription.formattedString ?? ""
                    fullStr = Str.trimmingCharacters(in: .whitespaces)
               
                }
                if error != nil || isFinal {
                   
                    //imgClose.setImageColor(color: .white)
                    self.audioEngine.stop()
                  //  StopPulse()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                  // self.microphoneButton.isEnabled = true
                    recognitionRequest.endAudio()
                    
                    appMenusNew = appMenus
                    
                    if appMenusNew.count > 0 {
                      
                    for item in appMenusNew
                    {
                        
                        if fullStr.lowercased() == "setting"
                        {
                            
                            let vc = subStoryboard.instantiateViewController(withIdentifier: "idSettingsVC") as! SettingsVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            break;
                        }else if fullStr.lowercased() == "timeline" || fullStr.lowercased() == "time line"
                        {
                            let vc = subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
                            vc.isMyTimeLine = false
                            vc.isMemberTimeLine = false
                            self.revealViewController()?.pushFrontViewController(vc, animated: true)
                            break;
                        }
                        else if fullStr.lowercased().contains("chat")
                        {
                            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            //            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "idChatVC")as! ChatVC
                            //            self.revealViewController()?.pushFrontViewController(vc, animated: true)
                            break;
                        }else if fullStr.lowercased().contains("greeting"){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSeasonalGreetingsVC")as! SeasonalGreetingsVC
                            pushVC(vc: vc)
                            
                            break;
                        }else if fullStr.lowercased().contains("geotag"){
                            let nextVC =  GeoTagVC()
                            nextVC.titleToolbar = doGetValueLanguage(forKey: "location")
                            pushVC(vc: nextVC)
                            break;
                        }else if fullStr.lowercased().contains("settings"){
                            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idSettingsVC")as! SettingsVC
                            pushVC(vc: nextVC)
                            break;
                        }
                        else if item.menu_title_search.lowercased().contains(fullStr.lowercased()) || item.menu_title.lowercased().contains(fullStr.lowercased())
                        
                        {
                            let  Strmenu = item.ios_menu_click ?? ""
                            let   menuicon = item.menu_icon ?? ""
                            let   menutitle = item.menu_title ?? ""
                            let   videoyoutube = item.tutorial_video ?? ""
                            let   Arrappmenu_sub = item.appmenu_sub ?? []
                            doActionOnSelectedItem(SelectedItemId: Strmenu, menu_icon: menuicon, menu_title: menutitle,tutorialVideo:videoyoutube,Subcategory:Arrappmenu_sub)
                            break
                        }
                        
                    }
                }
                 
                }else
                {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
             //self.microphoneButton.isEnabled = false
                    recognitionRequest.endAudio()
                
                }
            })
          
            }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
      
        lblPageTitle.text = "\(String(describing: doGetLocalDataUser().society_name?.titleCase())) \(doGetLocalDataUser().cityName?.titleCase() ?? "")"
        getNotificationCount()
        //getBuildingDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil)
        
        var isLogout = true
        if isKeyPresentInUserDefaults(key: StringConstants.KEY_BASE_URL) {
            let subDomain = UserDefaults.standard.string(forKey: StringConstants.KEY_BASE_URL)!
            let url = AlamofireSingleTon.sharedInstance.base_url
            if subDomain.contains(url) {
                isLogout = false
            }
        }
        
        if isLogout {
            self.doLogoutApi()
        }
        
        DispatchQueue.main.async {
            self.doCallMultiUnitApi()
        }
       
        if UserDefaults.standard.value(forKey: "ACCOUNTDEACTIVATE") != nil  &&  UserDefaults.standard.bool(forKey: "ACCOUNTDEACTIVATE"){
            
            self.showDeactiveDailog(StrActivate: "1")
        }
        //isShowOpenInternetScreen = false
        
        
        if isComeFromTimeline {
            isComeFromTimeline = false
            let vc = subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
            vc.isMyTimeLine = false
            vc.isMemberTimeLine = false
            self.revealViewController()?.pushFrontViewController(vc, animated: true)
        }
        
        
        comeFromNotification()
        
        
        
       
    }
    private func doShowPlanDailog(package : [PackageModel],expire_title_main : String,expire_title_sub : String,is_force_dailog : Bool) {
        
       
            
            
        let vc = storyboard?.mainStory().instantiateViewController(withIdentifier: "idPlanRenewVC") as! PlanRenewVC
        vc.expire_title_main = expire_title_main
        vc.expire_title_sub = expire_title_sub
        vc.packages = package
        vc.is_force_dailog = is_force_dailog
        vc.completion = { (packageModel) in
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN
            model.paymentForName = packageModel?.package_name ?? ""
            model.paymentDesc = packageModel?.package_name ?? ""
            model.paymentAmount = packageModel?.package_amount  ?? ""
            model.paymentFor  = "Package"
            model.package_id  = packageModel?.package_id ?? ""
            model.paymentBalanceSheetId  = packageModel?.balancesheet_id ?? ""
            model.PaybleAmountComma = packageModel?.package_amount  ?? ""
            model.userName = "\(self.doGetLocalDataUser().userFullName!)"
            model.userEmail = "\(self.doGetLocalDataUser().userEmail!)"
            model.userMobile = "\(self.doGetLocalDataUser().userMobile!)"
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.isComeFromPlan = "1"
            vc.fromHome = true
           // vc.paymentSucess = self
            self.pushVC(vc: vc)
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    @objc func doThisWhenNotify(notif: NSNotification) {
        if let menuClick =  notif.userInfo?["menuClick"] as? String {
            for (index,item) in  appMenus.enumerated() {
                if item.ios_menu_click == menuClick {
                    print("match  ")
                    appMenus[index].isBlink = true
                    
                    break
                }
            }
           
            print("home vc == " , menuClick)
        }
        getNotificationCount()
    }
    func getNotificationCount() {
        // "read":"0" mean is unread massagee
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getNotificationCount":"getNotificationCount",
                      "society_id":doGetLocalDataUser().societyID!,
                      "read":"0",
                      "user_id" : doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID! ]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.userNotificationController, parameters: params) { (json, error) in
            
            if json != nil {
               // print(json as Any)
                do {
                    let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                   // print(response)
                    if response.status == "200" {
                        
                        if response.tenant_registration == "1"{
                            //allows to add tenant
                            UserDefaults.standard.set(true, forKey: StringConstants.ADD_TENANT_FLAG)
                        }else{
                            //add tenant not allowed
                            UserDefaults.standard.set(false, forKey: StringConstants.ADD_TENANT_FLAG)
                        }

                        if response.visitor_on_off == "1"{
                            UserDefaults.standard.set(false,forKey: StringConstants.VISITOR_ONOFF)
                        }else{
                            UserDefaults.standard.set(true,forKey: StringConstants.VISITOR_ONOFF)
                        }
                        UserDefaults.standard.setValue(response.professional_on_off, forKey: StringConstants.KEY_HIDE_PROFESSIONAL)
                        
                        UserDefaults.standard.set(response.chat_status, forKey: StringConstants.CHAT_STATUS)
                        UserDefaults.standard.set(response.read_status, forKey: StringConstants.READ_STATUS)
                        UserDefaults.standard.set(response.hide_member_parking, forKey: StringConstants.HIDE_MEMBER_PARKING)
                        UserDefaults.standard.set(response.group_chat_status, forKey: StringConstants.GROUP_CHAT_STATUS)
                        UserDefaults.standard.set(response.create_group, forKey: StringConstants.CREATE_GROUP)
                        
                    
                        self.instanceLocal().setChatuseraccess(setdata: (response.chat_user_access ) ?? false)
                        self.instanceLocal().setTimelineuseraccess(setdata: ((response.timeline_user_access ) ?? false))
                        UserDefaults.standard.setValue(response.chat_user_access, forKey: StringConstants.KEY_CHAT_ACCESS )
                      //  UserDefaults.standard.setValue(response.timeline_user_access, forKey: StringConstants.KEY_TIMELINE_USER_ACCESS )
                        
                        UserDefaults.standard.setValue(response.timeline_user_access, forKey: StringConstants.KEY_TIMELINE_USER_ACCESS)
                        
                        if response.read_status !=  "0" {
                            self.viewNotiCount.isHidden =  false
                            self.lbNotiCount.text = response.read_status
                        } else {
                            self.viewNotiCount.isHidden =  true
                        }
                        
                        if response.chat_status != nil && response.chat_status !=  "0" {
                            self.viewChatCount.isHidden =  false
                            self.lbChatCount.text = response.chat_status
                        } else {
                            self.viewChatCount.isHidden =  true
                        }
                        if response.virtual_wallet != nil && response.virtual_wallet  {
                            UserDefaults.standard.set(response.virtual_wallet, forKey: StringConstants.KEY_VIRTUAL_WALLET)
                        } else {
                            UserDefaults.standard.set(false, forKey: StringConstants.KEY_VIRTUAL_WALLET)
                        }
                      
                        if UserDefaults.standard.string(forKey: StringConstants.KEY_FEED_ID) != nil {
                            
                            if UserDefaults.standard.string(forKey: StringConstants.KEY_FEED_ID) != response.last_feed_id {
                                self.viewTimelineCircle.isHidden = false
                                
                                self.viewTimelineCircle.alpha = 1.0
                                UIView.animate(withDuration: 3.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
                                    if  self.viewTimelineCircle.alpha == 0.0 {
                                        self.viewTimelineCircle.alpha = 1.0
                                    } else {
                                        self.viewTimelineCircle.alpha = 0.0
                                    }
                                }, completion: nil)
                                
                            }else {
                                self.viewTimelineCircle.isHidden = true
                            }
                        } else {
                            self.viewTimelineCircle.isHidden = true
                        }
                    }else {
                    }
                    //                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    override func viewWillLayoutSubviews() {
    }
    override func viewDidLayoutSubviews() {
    }
 
    @IBAction func onClickConversion(_ sender: Any) {
        if !isCheckMicro() {
            return
        }
        self.isCheckRecognize { isGrant in
            
            if isGrant {
                DispatchQueue.main.async {
                    gotoToSeach()
                }
            }
        }
        func gotoToSeach() {
            //if checkMicroPhonePermision() {
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let vc = VoiceSearchVC()
            // vc.electionData = data
            vc.context = self
            vc.appMenus = appMenus
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            //  popupVC.canTapOutsideToDismiss = true
            self.present(popupVC, animated: true)
        }
      
   
    }
    func addPulse() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 1.0
    pulse.fromValue = 1.0
    pulse.toValue = 10.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 10
    pulse.damping = 10.0
   // microphoneButton.layer.add(pulse, forKey: nil)
    }
    func StopPulse() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.3
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 2
   // microphoneButton.layer.add(flash, forKey: nil)
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
    func doLoadSlider() {
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getSlider":"getSlider",
                      "society_id":doGetLocalDataUser().societyID!,
                      "block_id":doGetLocalDataUser().blockID ?? ""]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.SLIDER_CONTROLLER, parameters: params) {(json, error) in
            //  self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SliderResponse.self, from:json!)
                    if response.status == "200" {
                        if let encoded = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_SLIDER_DATA)
                        }
                        
                        
                        self.doLoadSliderData()
                        
                      
                        
                        
                    }else {

                    }
                   // print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }

    }
    func doLoadSliderData() {
        slider.removeAll()
       
        let data = UserDefaults.standard.data(forKey: StringConstants.KEY_SLIDER_DATA)
        
        if data != nil{
            
            let response = try? JSONDecoder().decode(SliderResponse.self, from: data!)
            
            
            if let slider =  response?.slider {
                self.slider =  slider
            }
            
            
            if let dataService = response?.local_service_provider {
                if  self.serviceProvider.count > 0 {
                    serviceProvider.removeAll()
                }
                
                DispatchQueue.main.async {
                    if dataService.count > 0 {
                        self.serviceProvider = dataService
                    }
                }
            }
            
            if let dataNotice = response?.notice {
                if dataNotice.count > 0 {
                    self.noticeData = dataNotice
                    // self.cvCircular.reloadData()
                } else {
                    
                    if let member = response?.member {
                        if member.count > 0 {
                            self.memberArray = member
                        }
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                self.tbvHomeMenu.reloadData()
            }
            
        
        }
    }
    func LoadMenu(){
        if appMenus.count > 0 {
            appMenus.removeAll()
        }
        self.appMenus = doGetLocalMenuData().appmenu ?? [MenuModel]()
        
        for (index,_) in self.appMenus.enumerated(){
            if self.appMenus[index].ios_menu_click == "SOSVC"
            {
                print(self.appMenus[index])
                UserDefaults.standard.set("yes", forKey: "sos")
            }
            else{
                if self.isKeyPresentInUserDefaults(key: "sos") {
                UserDefaults.standard.removeObject(forKey: "sos")
                }
            }
            
        }
        tbvHomeMenu.reloadData()
    }
    
    private func comeFromNotification() {
        if let menuclick = UserDefaults.standard.string(forKey: StringConstants.KEY_MENU_CLICK_FOR) {
            print("comeFromNotification")
            if menuclick != "" {
                UserDefaults.standard.setValue("", forKeyPath: StringConstants.KEY_MENU_CLICK_FOR)
                for item in doGetLocalMenuData().appmenu ?? [MenuModel]() {
                  //  print("item = \(item.ios_menu_click ?? "") === \(menuclick)   ")
                    if item.ios_menu_click ?? "" ==  menuclick{
                        doActionOnSelectedItem(SelectedItemId: item.ios_menu_click, menu_icon: item.menu_icon, menu_title: item.menu_title,tutorialVideo:item.tutorial_video,Subcategory:item.appmenu_sub ?? [])
                        break
                    }
                }
            }
        }
    }
    func doLoadMenuView()  {
    
//        if hideTimeline()  && hideChat()  {
//
//            viewMainBottomNavigation.isHidden = true
//            conHightBottomNavigation.constant = 0
//        } else {
//
//            if  hideTimeline() {
//                viewTimeLine.isHidden = true
//            }
//            if hideChat() {
//                viewChat.isHidden = true
//            }
//        }
        
        viewTimeLine.borderWidth = 0.3
        viewTimeLine.borderColor = .black
        
        if  hideTimeline() {
            viewTimeLine.isHidden = true
        }
        if hideChat() {
            viewChat.isHidden = true
        }
        
       
        if UserDefaults.standard.string(forKey: StringConstants.HOMEPAGE_VIDEO) ?? "" != "" {
            viewVideoPlay.isHidden = false
        } else {
            viewVideoPlay.isHidden = true
        }
      //  doLoadSliderData()
    }
    func doGetMenuData(isLoadFirsttime:Bool) {
   
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getAppMenu":"getAppMenu",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "country_id":UserDefaults.standard.string(forKey: StringConstants.COUNTRYID) ?? "",
                      "state_id":UserDefaults.standard.string(forKey: StringConstants.STATEID) ?? "",
                      "city_id":UserDefaults.standard.string(forKey: StringConstants.CITYID) ?? "",
                      "device":"ios"]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPostCommon(serviceName: ServiceNameConstants.appMenuController, parameters: params) { [self] (json, error) in
           
            if json != nil {
            
                do {
                    let response = try JSONDecoder().decode(ResponseMenuData.self, from:json!)
                   // print(response)
                    if response.status == "200" {
                        
                     
                     //   UserDefaults.standard.set(nil, forKey: "menuData")
                        
                        DispatchQueue.main.async {
                            
                            if let encoded = try? JSONEncoder().encode(response) {
                                UserDefaults.standard.set(encoded, forKey:  StringConstants.KEY_MENU_DATA)
                            }
                            self.LoadMenu()
                        }
                       
                       
//                        if  isLoadFirsttime
//                        {
//
//                        }
                  
                          
                        
                        
                        UserDefaults.standard.set(response.timeline_video ?? "",forKey: StringConstants.TIMELINE_VIDEO_ID)
                        UserDefaults.standard.set(response.setting_video ?? "",forKey: StringConstants.SETTING_VIDEO_ID)
                        UserDefaults.standard.set(response.chat_video ?? "",forKey: StringConstants.CHAT_VIDEO_ID)
                        
                        UserDefaults.standard.set(response.homepage_video, forKey: StringConstants.HOMEPAGE_VIDEO)
//                        if let encoded = try? JSONEncoder().encode(response.slider) {
//                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_SLIDER_DATA)
//                        }
                        self.doLoadMenuView()
                        
                        if response.view_status != nil && response.active_status != nil {
                            UserDefaults.standard.set(response.advertisement_url, forKey: StringConstants.BANNER_ADV_URL)
                            UserDefaults.standard.set(response.view_status, forKey: StringConstants.BANNER_VIEW_STATUS)
                            UserDefaults.standard.set(response.active_status, forKey: StringConstants.BANNER_ACTIVE_STATUS)
                            
                            
                            if !self.isKeyPresentInUserDefaults(key: StringConstants.BANNER_VIEWED_ONCE){
                                UserDefaults.standard.set(true, forKey: StringConstants.BANNER_VIEWED_ONCE)
                            }
                            
                            if UserDefaults.standard.string(forKey: StringConstants.KET_FESTIVAL_DATE) ?? "" != response.festival_date {
                                UserDefaults.standard.setValue(response.festival_date, forKey: StringConstants.KET_FESTIVAL_DATE)
                                UserDefaults.standard.set(true, forKey: StringConstants.HOME_BANNER_LOCALLY_VIEWED)
                                UserDefaults.standard.set(true, forKey: StringConstants.BANNER_VIEWED_ONCE)
                            }
                          
                            self.doShowAdvertisementDialog()
                        }
                       
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func btnTabsPressed(_ sender: UIButton) {
        //        let subStoryBoard = UIStoryboard(name: "sub", bundle: nil)
        //        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        switch (sender.tag) {
            
        case 1: // timeline
            print("home")
            let vc = subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
            vc.isMyTimeLine = false
            vc.isMemberTimeLine = false
            vc.isMainTimeline = "yes"
            self.revealViewController()?.pushFrontViewController(vc, animated: true)
            break;
            
        case 2: // chat
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
           // let vc =  RecentChatViewVC() // this class using for fcm
            self.navigationController?.pushViewController(vc, animated: true)
            //            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "idChatVC")as! ChatVC
            //            self.revealViewController()?.pushFrontViewController(vc, animated: true)
            break;
            
        case 3: // help
            
            break;
            
        default:
            break;
        }
    }
    @objc func pagerClickedBy(_ sender : UIButton){
        let data = slider[sender.tag]
        let vc = self.subStoryboard.instantiateViewController(withIdentifier: "idOfferDetailVC")as! OfferDetailVC
        vc.sliderData = data
        vc.context = self
        addPopView(vc: vc)
//        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(350)])
//        sheetController.blurBottomSafeArea = false
//        sheetController.adjustForBottomSafeArea = false
//        sheetController.topCornersRadius = 0
//        sheetController.topCornersRadius = 15
//        sheetController.dismissOnBackgroundTap = false
//        sheetController.dismissOnPan = false
//        sheetController.handleSize = CGSize(width: 0, height: 0)
//        sheetController.extendBackgroundBehindHandle = true
//        self.present(sheetController, animated: false, completion: nil)
        
    }
    @IBAction func btnCallNow(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "telprompt://\(phone!)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)

                }
            }
        }

    }
    @IBAction func btnVisitNowCalled(_ sender: UIButton) {
        guard let url = URL(string: urlStr!) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onClickNotification(_ sender: Any) {

        let  vc = storyboard?.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC

        revealViewController().pushFrontViewController(vc, animated: true)

    }
    func doShowAdvertisementDialog (){
        if UserDefaults.standard.string(forKey: StringConstants.BANNER_ACTIVE_STATUS) == "1" {

            if UserDefaults.standard.string(forKey: StringConstants.BANNER_VIEW_STATUS) == "0"{
                if !UserDefaults.standard.bool(forKey: StringConstants.HOME_BANNER_LOCALLY_VIEWED){
                    UserDefaults.standard.set(true, forKey: StringConstants.HOME_BANNER_LOCALLY_VIEWED)
                    doShowAdvertisement()
                }

            }else{
                if UserDefaults.standard.bool(forKey: StringConstants.BANNER_VIEWED_ONCE){
                    UserDefaults.standard.set(false, forKey: StringConstants.BANNER_VIEWED_ONCE)
                    doShowAdvertisement()
                }
            }
        }
    }
    
    func doShowAdvertisement() {
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAdvertisementDialogVC")as! AdvertisementDialogVC
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = false
        present(popupVC, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        isShowOpenInternetScreen = true
        NotificationCenter.default.removeObserver(self)
    }
    func doCallMultiUnitApi(){
        //        self.showProgress()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let device = Device.current
        
        let params = ["getMultiUnitsNew":"getMultiUnitsNew",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!,
                      "phone_brand":"Apple",
                      "device":"ios",
                      "phone_model":device.description,
                      "country_code":doGetLocalDataUser().countryCode ?? ""]
      //  doGetLocalDataUser().countryCode ?? ""
//        print(params)
       
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                do {
                    let response = try JSONDecoder().decode(MultiUnitResponse.self, from: Data!)
                   // print(response)
                    if response.status == "200" {
                        if let formate = response.membership_joining_date_without_format {
                            UserDefaults.standard.set(formate, forKey: StringConstants.KEY_DATE_WITHOUT_FORMAT)
                        }
                        self.instanceLocal().setCountryId(versionCode: response.countryid)
                        self.instanceLocal().setHideMYActivity(setData: response.hideMyActivity ?? false)
                        UserDefaults.standard.setValue(response.hideChat, forKey: StringConstants.KEY_HIDE_CHAT)
                        UserDefaults.standard.setValue(response.hideTimeline, forKey: StringConstants.KEY_HIDE_TIMELINE)
                     //   UserDefaults.standard.setValue(response.countryCodeAlt, forKey: StringConstants.KEY_LOGIN_DATA)
                        
//                        print(response.association_type)
//                        print(response.membership_expire_date)
//                        print(response.membership_joining_date)
                        
                        UserDefaults.standard.setValue(response.association_type!, forKey: StringConstants.KEY_ASSOS_TYPE)
                        if let memExpireDate = response.membership_expire_date {
                            UserDefaults.standard.setValue(memExpireDate, forKey: StringConstants.KEY_MEM_EXPIRY_DATE)
                        }
                        
                        if let vehicle_photo = response.vehicle_photo_required {
                            UserDefaults.standard.setValue(vehicle_photo, forKey: StringConstants.VEHICLE_PHOTO_REQUIRED)
                        }
                        
                        if let rc_book_photo = response.rc_book_photo_required {
                            UserDefaults.standard.setValue(rc_book_photo, forKey: StringConstants.RC_BOOK_PHOTO_REQUIRED)
                        }
                        
                        if let memJoiningDate = response.membership_joining_date {
                            UserDefaults.standard.setValue(memJoiningDate, forKey: StringConstants.KEY_MEM_JOINING_DATE)
                        }
                        
                        if let providertimeline = response.show_service_provider_timeline_seprate{
                            UserDefaults.standard.setValue(providertimeline, forKey: StringConstants.show_service_provider_timeline_seprate)
                        }
                        
                        let tenantAgreementOver : Bool = response.tenant_agreement_over ?? false
                        if tenantAgreementOver == true {
                            self.showTenanatExpireDailog(StrActivate: "")
                        }
                        var check = true
                        for item in response.units {
                            if item.unitID == self.doGetLocalDataUser().unitID {
                                if item.logoutIosDevice ?? false {
                                    DispatchQueue.main.async {
                                        UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
                                        Utils.setRootSocietyList()
                                        return
                                    }
                                } else {
                                    
                                    if  item.accountDeactive! == false {
                                        if let encoded = try? JSONEncoder().encode(item) {
                                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                                        }
                                        check = false
                                        //print(self.doGetLocalDataUser().unitName , self.doGetLocalDataUser().accountDeactive, self.doGetLocalDataUser().accountDeactive)
                                    }
                                }
                            }
                        }
                        
                        if check
                        {
                            var isValid = false
                            for item in response.units {
                                
                                if item.unitStatus  != "4" && !item.accountDeactive {
                                    
                                    if let encoded = try? JSONEncoder().encode(item) {
                                    UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                                    }
                               
                                isValid = true
                                    break
                                    
                                }
                              
                            }
                            if !isValid {
                                self.showDeactiveDailog(StrActivate: "0")
                            }
                        }
                        if response.reminder != nil && response.reminder.count > 0{
                            self.showReminderDailog(reminder: response.reminder)
                        }
                        
                        if let  association_type = response.association_type {
                            
                            if association_type == "1" {
                                // that mean paid plan
                                if let is_package_expire = response.is_package_expire {
                                    
                                    if is_package_expire {
                                        // that mean plane is expired
                                        if response.package?.count ?? 0 > 0 {
                                            let dateFormater = DateFormatter()
                                            dateFormater.dateFormat = "dd-MM-yyyy"
                                            if !response.is_force_dailog && self.instanceLocal().getPlanLastShowDate() ==   dateFormater.string(from: Date()) {
                                                return
                                            }
                                            self.doShowPlanDailog(package: response.package ?? [],expire_title_main: response.expire_title_main ?? "",expire_title_sub: response.expire_title_sub ?? "", is_force_dailog: response.is_force_dailog ?? false)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }else{
                        self.toast(message: response.message, type: .Faliure)
                        self.doLogoutApi()
                             
                    }
                }catch{
                    print("Parse Error",Err as Any)             		
                }
            }else{
            }
        }
    }
    func showCheckForUpdateDialog()
    {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let nextVC = DialogCheckUpdateVC()
        
       // let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogCheckUpdateVC") as! DialogCheckUpdateVC
        
        let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
            , popupHeight: screenheight
        )
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = false
        present(popupVC, animated: true)
    }
    func showTenanatExpireDailog(StrActivate:String) {
        
                let screenwidth = UIScreen.main.bounds.width
                let screenheight = UIScreen.main.bounds.height
        
                let nextVC = DialogAgreementExpire()
                let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
                    , popupHeight: screenheight
                )
                popupVC.backgroundAlpha = 0.8
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = false
                present(popupVC, animated: true)
        
    }
    func showDeactiveDailog(StrActivate:String) {
        
            let nextVC = DialogAccountDeactivated()
            nextVC.view.frame = view.frame
            //nextVC.view.backgroundColor = UIColor.black
            nextVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        nextVC.Strvalue = StrActivate
            self.addPopView(vc: nextVC)
        
           // addChild(nextVC)
           // view.addSubview(nextVC.view)
        
        
        
//
//                nextVC.Strvalue = StrActivate
//                let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
//                    , popupHeight: screenheight
//                )
//
//                popupVC.backgroundAlpha = 0.8
//                popupVC.backgroundColor = .black
//                popupVC.shadowEnabled = true
//                popupVC.canTapOutsideToDismiss = false
//                present(popupVC, animated: true)
        
    }
    func showReminderDailog(reminder:[GetReminderListModel]) {
        if isShowReminderAlert {
            isShowReminderAlert = false
            let vc = ReminderDailogVC()
            vc.reminder = reminder
            vc.view.frame = view.frame
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            addChild(vc)  // add child for main view
            view.addSubview(vc.view)
        }
       
    }
    func doLogoutApi() {
        var multiSocietyArray = [LoginResponse]()
        let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
        if data != nil{
            let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
            multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
        }
       // print("soci count   " , multiSocietyArray)
        if multiSocietyArray.count > 1 {
            
            let params = ["user_logout":"user_logout",
                          "user_mobile":doGetLocalDataUser().userMobile!,
                          "user_id":doGetLocalDataUser().userID!,
                          "country_code":doGetLocalDataUser().countryCode!]
            print(params)
            let request = AlamofireSingleTon.sharedInstance
            request.requestPost(serviceName: ServiceNameConstants.login, parameters: params) { (Data, Err) in
                if Data != nil{
                    do {
                        let response = try JSONDecoder().decode(MultiUnitResponse.self, from: Data!)
                        
                        if response.status == "200"{
                            
                            UserDefaults.standard.removeObject(forKey: self.instanceLocal().planLastShowDate)
                            for (index,item) in multiSocietyArray.enumerated() {
                                if item.societyID == self.doGetLocalDataUser().societyID{
                                    multiSocietyArray.remove(at: index)
                                }
                            }
                        
                            let multiSociety = SocietyArray(SocietyDetails: multiSocietyArray)
                            if let encoded = try? JSONEncoder().encode(multiSociety) {
                                UserDefaults.standard.set(encoded, forKey: StringConstants.MULTI_SOCIETY_DETAIL)
                            }
                            
                            UserDefaults.standard.set(multiSocietyArray[0].baseURL, forKey: StringConstants.KEY_BASE_URL)
                            UserDefaults.standard.set(multiSocietyArray[0].apiKey, forKey: StringConstants.KEY_API_KEY)
                            
                            if let encoded = try? JSONEncoder().encode(multiSocietyArray[0]) {
                                UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                            }
                            
                            self.lblPageTitle.text = "\(self.doGetLocalDataUser().society_name!.titleCase()) \(self.doGetLocalDataUser().cityName!.titleCase())"
                        }
                    } catch {
                        print("Parse Error",Err as Any)
                    }
                }else{
                }
            }
        } else {
            UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
//            Utils.setHomeRootLocation()
            Utils.setSplashVCRoot()
        }
    }
    func gotoSuggestionMenu(textVoice : String)
    {
        print("textVoice  \(textVoice)")
        var tempArray = [MenuModel]()
            
        for item in appMenus
        {
           // print(item.menu_title_search ?? "")
            
            if item.menu_title_search.contains(textVoice)
            {
                tempArray.append(item)
                //print(appMenusNew)
            }
        }
        if textVoice.contains("Chat")
        {
            self.dismiss(animated: true) {
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
            self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }else if textVoice.contains("Setting")
        {
            self.dismiss(animated: true) {
                let vc = self.subStoryboard.instantiateViewController(withIdentifier: "idSettingsVC") as! SettingsVC
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if textVoice.contains("Timeline")
        {
            self.dismiss(animated: true) {
                let vc = self.subStoryboard .instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
            self.revealViewController()?.pushFrontViewController(vc, animated: true)
            }
        }else if textVoice.lowercased().contains("greeting"){
            self.dismiss(animated: true) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSeasonalGreetingsVC")as! SeasonalGreetingsVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if textVoice.lowercased().contains("geotag") || textVoice.lowercased().contains("geo tag") || textVoice.contains("Geo tag") {
            self.dismiss(animated: true) {
                let vc =  GeoTagVC()
                vc.titleToolbar = self.doGetValueLanguage(forKey: "location")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if textVoice.lowercased().contains("mytransaction") || textVoice.lowercased().contains("my transaction") {
            self.dismiss(animated: true) {
                let vc = MyTransactionVC()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }else if textVoice.lowercased().contains("reminder"){
            self.dismiss(animated: true) {
                let vc = ReminderVC()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }else if textVoice.lowercased().contains("myactivities") || textVoice.lowercased().contains("my activities") {
            if self.instanceLocal().getHideMYActivity(){
                return
            }
            self.dismiss(animated: true) {
                let vc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idUserActivityViewVC")as! UserActivityViewVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
      else  if tempArray.count == 1
        {
            self.dismiss(animated: true) {
                self.doActionOnSelectedItem(SelectedItemId: tempArray[0].ios_menu_click, menu_icon: tempArray[0].menu_icon, menu_title: tempArray[0].menu_title,tutorialVideo:tempArray[0].tutorial_video,Subcategory:tempArray[0].appmenu_sub ?? [])
            }
        }
       else if tempArray.count > 1  {
            self.dismiss(animated: true) {
            //let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuggestedWordsVC") as! SuggestedWordsVC
                let nextVC = SuggestedWordsVC()
                nextVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                nextVC.view.backgroundColor = .black
                
            nextVC.appMenusNew = tempArray
            nextVC.delegate=self
            self.addPopView(vc: nextVC)
        }
        }
    }
    
    @IBAction func tapGreeting(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSeasonalGreetingsVC")as! SeasonalGreetingsVC
        pushVC(vc: vc)
    }
    @IBAction func tapGeoTag(_ sender: Any) {
        let nextVC =  GeoTagVC()
        nextVC.titleToolbar = doGetValueLanguage(forKey: "location")
        nextVC.isComeFrom = "DashBord"
        pushVC(vc: nextVC)
    }
    @IBAction func tapViewAllVendor(_ sender: Any) {
       
        if  StringConstants.KEY_IS_OLD_SERVICE_UI {
            // this old ui
            let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderVC")as! ServiceProviderVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = ""
            nextVC.menuTitle = doGetValueLanguage(forKey: "vendors")
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
          
        } else {
            let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailVC")as! ServiceProviderDetailVC
            nextvc.headingText = doGetValueLanguage(forKey: "vendors")
           // setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            //nextvc.serviceProviderDetail = filteredArray[indexPath.row]
            self.navigationController?.pushViewController(nextvc, animated: true)
            
        }
        
        
    }
    @IBAction func tapViewAllMember(_ sender: Any) {
      //  doGoToMember(menu_title: lbMember.text ?? "")
    }
    // do f
    private func doSetForLanguage() {
     
       // instance.setCurrentAppVersion()
        //instanceLocal.s
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
       
        if instanceLocal().getCurrentAppVersion() != "" &&  instanceLocal().getCurrentAppVersion() != appVersion {
            doGetLanguageData()
        } else {
            let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.doGetLocalDataUser().societyID ?? "0")"
          
            if UserDefaults.standard.value(forKey: dataKey) == nil {
                doGetLanguageData()
            } else {
                self.setupHomeUI()
            }
        }
    }
    func doGetLanguageData() {
        showProgress()
        let params = ["getLanguageValues":"getLanguageValues",
                      "language_id":doGetLanguageId(),
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "country_id":instanceLocal().getCountryId()]
       print("param" , params)
         
      /*  Alamofire.request(request.commonURL + NetworkAPI.language_controller, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            self.hideProgress()
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let dict :NSDictionary = json as! NSDictionary
                   
                    UserDefaults.standard.set(dict, forKey: StringConstants.LANGUAGE_DATA)
                    self.setupHomeUI()
                }
                break
                
            case .failure(_):
                print(response)
                break
            }
        }*/
       
        request.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                let langKey = "\(StringConstants.LANGUAGE_ID)\(self.doGetLocalDataUser().societyID ?? "0")"
                UserDefaults.standard.setValue(self.doGetLanguageId(), forKey: langKey)
              
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.doGetLocalDataUser().societyID ?? "0")"
                UserDefaults.standard.set(dictionary, forKey: dataKey)
                
                self.setupHomeUI()
            }
    
        }
    }
    
    func setupHomeUI() {
        lbHome.text = doGetValueLanguage(forKey: "home")
      //  lbTimeline.text = doGetValueLanguage(forKey: "timeline")
        lbChat.text = doGetValueLanguage(forKey: "chat")
        lbTitle.text = doGetLocalDataUser().society_name ?? ""
        
        
        
        
        lbGreeting.text = doGetValueLanguage(forKey: "greeting")
        lbGeotag.text = doGetValueLanguage(forKey: "geo_tag")
        
        
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        instanceLocal().setCurrentAppVersion(versionCode: appVersion)
        
        if UserDefaults.standard.data(forKey:StringConstants.KEY_MENU_DATA) == nil {
            doGetMenuData(isLoadFirsttime: true)
        } else {
            LoadMenu()
            doGetMenuData(isLoadFirsttime: false)
        }
         
        
        if UserDefaults.standard.data(forKey: StringConstants.KEY_SLIDER_DATA) != nil {
            doLoadSliderData()
            doLoadSlider()
        }else {
            doLoadSlider()
        }
        
      
        self.viewNotiCount.isHidden =  true
        
        
    }
    
    @IBAction func tapVideoPlay(_ sender: Any) {
        
        let youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.HOMEPAGE_VIDEO) ?? ""
        if youtubeVideoID.contains("https"){
            let url = URL(string: youtubeVideoID)!
            
            playVideo(url: url)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        isShowOpenInternetScreen = true
      
    }
    
    func goToSliderDetails(data : Slider) {
        let vc = self.subStoryboard.instantiateViewController(withIdentifier: "idOfferDetailVC")as! OfferDetailVC
        vc.sliderData = data
        vc.context = self
       addPopView(vc: vc)

    }
    
    func goToVendorDetails(serviceProviderUsersID : String) {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                    
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
        }

    }
    
    func goToCircularDetails(data : ModelNoticeBoard) {
        let vc = CircularDetailsVC()
        vc.modelNoticeBoard = data
        pushVC(vc: vc)
    }
    
    func doActionOnSelectedItem(SelectedItemId : String,menu_icon:String,menu_title:String,tutorialVideo:String,Subcategory:[SubMenuModel]) {
        switch (SelectedItemId) {
        case "MemberVC":
//            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMemberVC")as! MemberVC
//            nextVC.menuTitle = menu_title
//            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
//            newFrontViewController.isNavigationBarHidden = true
//            nextVC.youtubeVideoID = tutorialVideo
//            revealViewController().pushFrontViewController(newFrontViewController, animated: true)

            doGoToMember(menu_title: menu_title)
            break;
            
        case "NoticeVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idNoticeVC")as! NoticeVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "vehicleVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idVehiclesVC")as! VehiclesVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "dailynewsVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDailyNewsVC")as! DailyNewsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            nextVC.menu_icon = menu_icon
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "renewPaymentVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idRenewPlanDetailsVC")as! RenewPlanDetailsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
           // nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "ServiceProviderVC":
            let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderVC")as! ServiceProviderVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "EventsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEventTabVC")as! EventTabVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key: menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
        case "DiscussionVC":
            
            if let clickAcion = UserDefaults.standard.string(forKey: StringConstants.KEY_CLICK_ACTION){
                UserDefaults.standard.set(nil, forKey: StringConstants.KEY_CLICK_ACTION)
                let json = try! JSONSerialization.jsonObject(with: clickAcion.data(using: .utf8) ?? Data(), options: []) as? [String]
                //print(json)
                if json?[0] ?? "" != "" {
                    
                    let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionDetailVC")as! DiscussionDetailVC
                    nextVC.discussion_forum_id = json?[0] ?? ""
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    return
                }
            }
            
            let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionListVC")as! DiscussionListVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "VisitingCardVC":
            let vc  = self.storyboard?.login().instantiateViewController(withIdentifier: "idBusinessCardDetailsVC")as! BusinessCardDetailsVC
            vc.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value: menu_icon)
          //  vc.userProfileReponse = userProfileReponse
           // vc.responseProfessional = responseProfessional
            pushVC(vc: vc)
            break
            
            
            
        case "ComplaintsVC":
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplaintsVC")as! ComplaintsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
            
        case "GalleryVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGalleryVC")as! GalleryVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
        case "DocumentsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDocumentsVC")as! DocumentsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            nextVC.menuIcon = menu_icon
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "PollingVc":
            let nextVC = PollingPagerVC(nibName: "PollingPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "SeasonalVC":
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSeasonalGreetingsVC")as! SeasonalGreetingsVC
           
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key: menu_title, value: menu_icon)
            pushVC(vc: nextVC)
            break;
            
        case "referVendorVc":
           let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idReferVendorVC")as! ReferVendorVC
//            nextVC.menuTitle = menu_title
//            setPlaceholderLocal(key: menu_title, value: menu_icon)
//            pushVC(vc: nextVC)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
         
        case "SurveyVC":
            let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSurveyVC")as! SurveyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
        case "ElectionVC":

            let nextVC = ElectionPagerVC(nibName: "ElectionPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "KhataBookVC":
            let nextVC = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idFinBookVC")as! FinBookVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            //            nextVC.youtubeVideoID = appMenus[index].tutorial_video
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "BuildingDetailsVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idBuildingDetailsVC")as! BuildingDetailsVC
            nextVC.menuTitle = menu_title
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "EmergencyContactsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEmergencyContactsVC")as! EmergencyContactsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "EntertainmentVC":
            let nextVC = entertainmentStoryboard.instantiateViewController(withIdentifier: "idEntertainmentVC")as! EntertainmentVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.appmenu_sub =  Subcategory
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
        case "ContactUsVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idContactFincaTeamVC") as! ContactFincaTeamVC
            nextVC.menuTitle = menu_title
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "MainTabClassifiedVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMainTabClassifiedVC") as! MainTabClassifiedVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
            
        case "ProfileVC":
            let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserProfileVC")as! UserProfileVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "SOSVC":
            if UserDefaults.standard.bool(forKey: StringConstants.SECURITY_MPIN_FLAG){
                let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idSOSLockScreenVC") as! SOSLockScreenVC
                let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
                nextVC.youtubevideoId = tutorialVideo
                newFrontViewController.isNavigationBarHidden = true
                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            }else{
                let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "idSOSVC") as! SOSVC
                nextVC.menuTitle = menu_title
                let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
                newFrontViewController.isNavigationBarHidden = true
                nextVC.youtubeVideoID = tutorialVideo
                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            }
            break;
            
        case "RequestVC" :
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idRequestVC") as! RequestVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "SearchOccupationVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idOccupationVC")as! OccupationVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "BalanceSheetVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetVc")as! BalanceSheetVc
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "PenaltyVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idPenaltyVC")as! PenaltyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
       
            
        
        case "GeoVC":
            let nextVC =  GeoTagVC()
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            //nextVC.youtubeVideoID = tutorialVideo
            nextVC.titleToolbar = menu_title
            nextVC.isComeFrom = "DashBord"
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            self.pushVC(vc: nextVC)
//            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
              
        default:
            break;
        }
    }
 
    
    func doGoToMember(menu_title : String) {
       
   
       let vc = NewMemberVC()
       vc.menuTitle = menu_title
       self.pushVC(vc: vc)
   }
    
}


extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)

        self.isHidden = false
    }

    func animHide(){
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}




class CollectionLayoutCircular: UICollectionViewFlowLayout {

    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        if display != .inline {
//               return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//           }

           guard let collectionView = collectionView else {
               return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
           }

           let willtoNextX: CGFloat

           if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
               willtoNextX = proposedContentOffset.x
           } else {

               let width = collectionView.bounds.size.width
               willtoNextX = collectionView.contentOffset.x + (velocity.x > 0 ?  width : -width)
           }

           let targetRect = CGRect(x: willtoNextX, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

           var offsetAdjustCoefficient = CGFloat.greatestFiniteMagnitude

           let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

           let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

           layoutAttributesArray?.forEach({ (layoutAttributes) in
               let itemOffset = layoutAttributes.frame.origin.x
               if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustCoefficient)) {
                   offsetAdjustCoefficient = itemOffset - horizontalOffset
               }
           })

           return CGPoint(x: proposedContentOffset.x + offsetAdjustCoefficient, y: proposedContentOffset.y)
    }
}

struct HomeMemberModel : Codable {
    let user_id : String?
    let user_full_name : String?
    let user_first_name : String?
    let user_last_name : String?
    let user_profile_pic : String?
}


extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellHomeCommon, for: indexPath)as! HomeViewCommonCell
            cell.selectionStyle = .none
            cell.homeVC = self
            cell.viewHomeMenu.isHidden = true
            
            cell.setDataVendor(serviceProvider: serviceProvider)
            cell.setDataCircularAndMember(noticeData: noticeData, memberArray: memberArray)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellHomeCommon, for: indexPath)as! HomeViewCommonCell
            cell.selectionStyle = .none
            cell.homeVC = self
            cell.viewVendor.isHidden = true
            cell.viewCircular.isHidden = true
            cell.viewMember.isHidden = true
            cell.viewHomeMenu.isHidden = false
            
            if appMenus.count != 0 {
                if appMenus.count % 3 == 0 {
                    cell.hieghtConCVMenu.constant = CGFloat(appMenus.count / 3 * 110)
                } else {
                    cell.hieghtConCVMenu.constant = CGFloat(appMenus.count / 3 * 110 + 110)
                }
                cell.setAppMenu(appMenus: appMenus)
            }
          
            
            
            return cell
        }
        
        
       
        
         return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionSliderCell") as! SectionSliderCell
        cell.addSelderData(slider: slider)
        cell.homeVC = self
        return cell
    }
    
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9058823529, alpha: 1)
    return view
    
}
   
    func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
