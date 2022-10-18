//
//  SettingsVC.swift
//  Finca
//
//  Created by harsh panchal on 03/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
import LocalAuthentication
import DropDown
class SettingsVC: BaseVC{
    @IBOutlet weak var lbltime : UILabel!
    @IBOutlet weak var txtStartTime : UITextField!
    @IBOutlet weak var txtEndTime : UITextField!
    @IBOutlet weak var lblSun : UILabel!
    @IBOutlet weak var lblMon : UILabel!
    @IBOutlet weak var lblTue : UILabel!
    @IBOutlet weak var lblWed : UILabel!
    @IBOutlet weak var lblThur : UILabel!
    @IBOutlet weak var lblFri : UILabel!
    @IBOutlet weak var lblSat : UILabel!
    
    @IBOutlet weak var viewprivacy: UIView!
    @IBOutlet weak var viewSun : UIView!
    @IBOutlet weak var viewMon : UIView!
    @IBOutlet weak var viewTue : UIView!
    @IBOutlet weak var viewWed : UIView!
    @IBOutlet weak var viewThur : UIView!
    @IBOutlet weak var viewFriday : UIView!
    @IBOutlet weak var viewSat : UIView!
    
    @IBOutlet weak var viewSOS: UIView!
    @IBOutlet weak var btnSun : UIButton!
    @IBOutlet weak var btnMon : UIButton!
    @IBOutlet weak var btnTue : UIButton!
    @IBOutlet weak var btnWed : UIButton!
    @IBOutlet weak var btnThur : UIButton!
    @IBOutlet weak var btnFri : UIButton!
    @IBOutlet weak var btnSat : UIButton!
    
    @IBOutlet weak var viewSelectDays : UIView!
    @IBOutlet weak var viewtime : UIView!
    @IBOutlet weak var viewSavebtn : UIView!
    
    @IBOutlet var bubbleView: [UIView]!
    @IBOutlet weak var switchApartmentState: UISwitch!
//    @IBOutlet weak var switchNotificationSound: UISwitch!
    @IBOutlet weak var switchMobileNumber: UISwitch!
    @IBOutlet weak var switchVisitorApproval: UISwitch!
    @IBOutlet weak var switchDND: UISwitch!
    @IBOutlet weak var switchSOSAlet: UISwitch!
    @IBOutlet weak var switchPrivateAcc: UISwitch!
    @IBOutlet weak var switchDOB: UISwitch!
    @IBOutlet weak var switchMobileNumberGatekeeper: UISwitch!
    @IBOutlet weak var switchSOSPin: UISwitch!
    @IBOutlet weak var switchOtherVisitorApproval: UISwitch!
    @IBOutlet weak var switchBiometricsLock: UISwitch!
    @IBOutlet weak var switchChildSecurity: UISwitch!
    @IBOutlet weak var switchNotificationSound: UISwitch!
    
    @IBOutlet weak var viewNotificationSound: UIView!
    @IBOutlet weak var VwSystemLockView:UIView!
    @IBOutlet weak var viewShowTenant: UIView!
    @IBOutlet weak var viewDND: UIView!
    @IBOutlet weak var viewAddTenant: UIView!
    @IBOutlet weak var viewTenantSwitch: UIView!
    @IBOutlet weak var viewHeightStackview: NSLayoutConstraint!
    @IBOutlet weak var imgTenantImage: UIImageView!
    @IBOutlet weak var lblTenantName: UILabel!
    @IBOutlet weak var lblTenantDetails: UILabel!
    @IBOutlet weak var imgDeleteButton: UIImageView!
    @IBOutlet weak var btnDeleteTenant: UIButton!
    @IBOutlet weak var lblMobileNumber: UILabel!

    @IBOutlet weak var viewVisitorApproval: UIView!
    @IBOutlet weak var viewHide: UIView!
    @IBOutlet weak var heightConAddTenet: NSLayoutConstraint!

    @IBOutlet weak var titleApartmentClosed: UILabel!
    @IBOutlet weak var titlePrivacyResident: UILabel!
    @IBOutlet weak var viewPrivacyGatekeeper: UIView!
    @IBOutlet weak var viewChildSecurity: UIView!
    @IBOutlet weak var viewEntityApproval: UIView!
//    @IBOutlet weak var viewVisitorApproval: UIView!
    @IBOutlet weak var viewLanguage: UIView!
    
    @IBOutlet weak var lbGeneralSetting: UILabel!
//    @IBOutlet weak var lbNotificationSound: UILabel!
    @IBOutlet weak var lbApplySystemLock: UILabel!
    @IBOutlet weak var lbChangeLanguage: UILabel!
    @IBOutlet weak var lbPrivacySetting: UILabel!
    @IBOutlet weak var lbContactNumberPrivacy: UILabel!
    @IBOutlet weak var lbDOBPrivacy: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lblNotificationSound: UILabel!
    @IBOutlet weak var swithchPrivateNumber: LabelSwitch!
    @IBOutlet weak var swithchLock: LabelSwitch!
    @IBOutlet weak var swithchPrivateDOB: LabelSwitch!
    @IBOutlet weak var swithchDND: LabelSwitch!
    @IBOutlet weak var switchLabelNotificationSound: LabelSwitch!
    var currentType = LAContext().biometricType
   
    var timerObj = Timer()
    var SelectedTextField = ""
    var seconds = 60
    var StrTime = ""
    var StrHour = Int()
    var DoubleHour = 30.0
    var ArrHour = ["1 Hour","2 Hour","4 Hour","8 Hour","12 Hour","24 Hour","Custom Time"]
    let dropdown = DropDown()
    var youtubeVideoID = ""
    var FlagSun = false
    var FlagMon = false
    var FlagTue = false
    var FlagWed = false
    var FlagThur = false
    var FlagFri = false
    var FlagSat = false
    let formatter = DateFormatter()
    var dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let timePicker = UIDatePicker()
    var timeFormatter = DateFormatter()
    var flagCustomTime = ""
    var flagNormalTime = ""
    var ArrSelectedDays = [String]()
    
    var flag = 1
    var profileDetails : MemberDetailResponse!

    var isShowAddTenetDailog = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtStartTime.text = formatter.string(from: datePicker.date)
        txtStartTime.placeholder = "Start Time"
        txtEndTime.delegate = self
        txtStartTime.delegate = self
        
        for view in bubbleView{
            view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
        }

       //  Do any additional setup after loading the view.
        if doGetLocalDataUser().userType! == "1"{

            imgDeleteButton.isHidden = true
            btnDeleteTenant.isHidden = true
            lblTenantDetails.text = "Owner Details"
            self.viewHide.isHidden = false
        }else{
            if UserDefaults.standard.bool(forKey: StringConstants.ADD_TENANT_FLAG){
                self.viewAddTenant.isHidden = false
                self.viewHide.isHidden = false
            }else{
                self.viewAddTenant.isHidden = true
                self.viewHide.isHidden = true
            }
        }
        
        if (UserDefaults.standard.object(forKey: "SwitchState") != nil) {
            switchNotificationSound.isOn = UserDefaults.standard.bool(forKey: "SwitchState")
        }
        
//        if UserDefaults.standard.bool(forKey: StringConstants.VISITOR_ONOFF){
//            self.viewVisitorApproval.isHidden = false
//        }else{
//            self.viewVisitorApproval.isHidden = true
//        }
        switchMobileNumber.isHidden = true
        switchBiometricsLock.isHidden = true
        switchBiometricsLock.isHidden = true
        switchApartmentState.tag = 1
        switchApartmentState.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchMobileNumber.tag = 2
        switchMobileNumber.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchVisitorApproval.tag = 3
        switchVisitorApproval.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchSOSAlet.tag = 4
        switchSOSAlet.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchPrivateAcc.tag = 5
        switchPrivateAcc.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchDOB.tag = 6
        switchDOB.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchMobileNumberGatekeeper.tag = 7
        switchMobileNumberGatekeeper.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchSOSPin.tag = 8
        switchSOSPin.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchOtherVisitorApproval.tag = 9
        switchOtherVisitorApproval.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchBiometricsLock.tag = 10
        switchBiometricsLock.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchChildSecurity.tag = 11
        switchChildSecurity.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchNotificationSound.tag = 12
        switchNotificationSound.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        switchDOB.tag = 13
        switchDND.addTarget(self, action: #selector(switchDNDChanged(_:)), for: .valueChanged)
        youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.SETTING_VIDEO_ID) ?? ""
        
        viewShowTenant.isHidden = true
        viewAddTenant.isHidden = true
        heightConAddTenet.constant = 0
        //  viewLanguage.isHidden = true // this is for use hide language change option
        setUIData()
        
       
        self.setupSwitchButton(labelSwitch: swithchLock, isCheck: false )
        self.setupSwitchButton(labelSwitch: self.swithchPrivateNumber, isCheck: false)
        self.setupSwitchButton(labelSwitch: self.swithchDND, isCheck: false)
        self.setupSwitchButton(labelSwitch: self.swithchPrivateDOB, isCheck: false)
        self.setupSwitchButton(labelSwitch: self.switchLabelNotificationSound, isCheck: false)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField) {
        
        case txtStartTime:
            SelectedTextField = "0"
            datePicker.datePickerMode = .time
            break
        case txtEndTime:
            SelectedTextField = "1"
            datePicker.datePickerMode = .time
            break
        default:
            break;
        }
    }
    func loadTime(){
            timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
                  timePicker.preferredDatePickerStyle = .wheels
              }

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            
    //        if !isEditVisitorCalled{
    //            tfInTime.text = timeFormatter.string(from: timePicker.date)
    //            tfOutTime.text = timeFormatter.string(from: timePicker.date)
    //        }
        
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolbar.setItems([doneButton,spaceButton], animated: false)

            txtStartTime.inputAccessoryView = toolbar
            txtStartTime.inputView = timePicker
            
            txtEndTime.inputAccessoryView = toolbar
            txtEndTime.inputView = timePicker
            
        }

    func initPicker(){
        //let formatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let currentDate = dateFormatter.string(from: datePicker.date)
            // var currentTime = dateFormatter.string(from: datePicker.timeZone)
            let formatter = DateFormatter()
            formatter.timeStyle = .short
           
                txtStartTime.text = currentDate
                txtStartTime.text = formatter.string(from: datePicker.date)
           
            txtStartTime.inputView = datePicker
        txtStartTime.inputView = datePicker
        txtStartTime.delegate = self
        txtStartTime.delegate = self
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            toolBar.setItems([doneButton], animated: true)
        txtStartTime.inputAccessoryView = toolBar
        txtStartTime.inputAccessoryView = toolBar
    }
    @objc func doneButtonTapped() {
            
            if SelectedTextField == "0" {
                timeFormatter.dateStyle = .none
                timeFormatter.timeStyle = .short
                timeFormatter.dateFormat = "hh:mm a"
                txtStartTime.text = timeFormatter.string(from: timePicker.date)
                print(timeFormatter.string(from: timePicker.date))
               // txtStartTime.errorMessage = ""
            }
        
            if SelectedTextField == "1" {
                timeFormatter.dateStyle = .none
                timeFormatter.timeStyle = .short
                timeFormatter.dateFormat = "hh:mm a"
                txtEndTime.text = timeFormatter.string(from: timePicker.date)
                print(timeFormatter.string(from: datePicker.date))
               // txtEndTime.errorMessage = ""
            }
            self.view.endEditing(true)
        }
    @IBAction func btnSundayyClick(_ sender: UIButton) {
        if FlagSun {
            FlagSun = false
            viewSun.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagSun = true
            viewSun.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("SUNDAY")
            
        }
    }
    @IBAction func btnMondayClick(_ sender: UIButton) {
        
        if FlagMon {
            FlagMon = false
            viewMon.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagMon = true
            viewMon.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("MONDAY")
            
        }
        
    }
    @IBAction func btnTueClick(_ sender: UIButton) {
        
        if FlagTue {
            FlagTue = false
            viewTue.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagTue = true
            viewTue.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("TUESDAY")
            
        }
        
    }
    @IBAction func btnWedClick(_ sender: UIButton) {
        
        if FlagWed {
            FlagWed = false
            viewWed.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagWed = true
            viewWed.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("WEDNESDAY")
            
        }
        
    }
    @IBAction func btnThursClick(_ sender: UIButton) {
        
        if FlagThur {
            FlagThur = false
            viewThur.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagThur = true
            viewThur.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("THURSDAY")
            
        }
        
    }
    @IBAction func btnFriClick(_ sender: UIButton) {
        
        if FlagFri {
            FlagFri = false
            viewFriday.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagFri = true
            viewFriday.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("FRIDAY")
        }
    }
    @IBAction func btnSaturdayClick(_ sender: UIButton) {
        
        if FlagSat {
            FlagSat = false
            viewSat.backgroundColor = .lightGray
            ArrSelectedDays.removeLast()
        }else {
            FlagSat = true
            viewSat.backgroundColor = ColorConstant.primaryColor
            ArrSelectedDays.append("SATURDAY")
            
        }
    }
    @IBAction func BtnStartTimeClick(_ sender: UIButton) {
        initPicker()
    }
    @IBAction func BtnEndTimeClick(_ sender: UIButton) {
        initPicker()
    }
    @IBAction func BtnSaveClick(_ sender: UIButton) {
        
     //   UserDefaults.standard.setValue(lbltime.text, forKey: StringConstants.SAVE_NOTIFICATION_TIME)
        
        if flagCustomTime == "1" {
            
            if ArrSelectedDays.count == 0 {
                toast(message: "please select atleast one day.", type: .Information)
                return
            }else {
                // custom days select code here
                
                UserDefaults.standard.setValue(txtStartTime.text!, forKey: "StartTime")
                UserDefaults.standard.setValue(txtEndTime.text!, forKey: "EndTime")
                UserDefaults.standard.setValue(ArrSelectedDays, forKey: "Arrdays")
                
                
            }
        }else {
            timerObj = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.setCalculationLs), userInfo:nil,repeats: true)
        }
    }
   
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
  
    @objc func setCalculationLs(){
        //DoubleHour = 60
        DoubleHour = DoubleHour - 1
        let insecond = timeString(time: TimeInterval(DoubleHour))
        UserDefaults.standard.setValue(insecond, forKey: StringConstants.SAVE_NOTIFICATION_TIME)
        lbltime.text = insecond
        print(insecond)
    }
    @IBAction func BtnSelectTime(_ sender: UIButton) {
        dropdown.anchorView = lbltime
        dropdown.dataSource = ArrHour
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.lbltime.text =   self.dropdown.selectedItem
            StrTime = self.dropdown.selectedItem ?? ""
            let Str = StrTime.components(separatedBy: " ")
            StrHour = Str[0].integerValue ?? 0
            viewVisitorApproval.isHidden = false
           // viewSavebtn.isHidden = false
            
            if self.lbltime.text == "Custom Time" {
                viewSelectDays.isHidden = false
                flagCustomTime = "1"
                
            }else {
                viewSelectDays.isHidden = true
                flagNormalTime = "1"
            }
        }
        dropdown.show()
    }
    private func setupSwitchButton(labelSwitch:LabelSwitch ,isCheck  : Bool) {
        labelSwitch.lText = doGetValueLanguage(forKey: "on_setting").uppercased()
        labelSwitch.rText = doGetValueLanguage(forKey: "off").uppercased()
        labelSwitch.lBackColor = ColorConstant.colorP
        labelSwitch.lTextColor =  .white
       
        labelSwitch.rBackColor = .white
        labelSwitch.rTextColor = ColorConstant.colorP
        
         labelSwitch.borderColor = ColorConstant.colorP
        labelSwitch.borderWidth = 0.5
       
        labelSwitch.delegate = self
        labelSwitch.fullSizeTapEnabled = true
        
       
        if isCheck {
            labelSwitch.curState = .R
            labelSwitch.circleColor = .white
        } else {
            labelSwitch.curState = .L
            labelSwitch.circleColor = ColorConstant.colorP
        }
       
    }
    
    @IBAction func BtnVideoClickEvent(_ sender: UIButton) {
        
        if youtubeVideoID != ""{
                if youtubeVideoID.contains("https"){
                    let url = URL(string: youtubeVideoID)!

                    playVideo(url: url)
                }else{
                    let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                    vc.videoId = youtubeVideoID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
            BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        doGetProfile()
        self.titleApartmentClosed.text = "Unit Closed"
        
        VwSystemLockView.isHidden = true
      
            if self.isKeyPresentInUserDefaults(key: "sos") {
                if let sosmenu = UserDefaults.standard.string(forKey: "sos") {
                    
                    if sosmenu == "yes"
                    {
                        viewSOS.isHidden = false
                    }
                    else{
                        viewSOS.isHidden = true
                    }
                }
            }
        else{
            viewSOS.isHidden = true
        }
        
        
        
        if currentType == .touchID
        {
            VwSystemLockView.isHidden = false
        }
      
        
//        if  doGetLocalDataUser().isSociety {                                         //true
//             self.titlePrivacyResident.text = "Contact Number Privacy for Residents"
//            self.viewPrivacyGatekeeper.isHidden = false
//            self.viewChildSecurity.isHidden = false
//            self.viewEntityApproval.isHidden = false
//            self.viewVisitorApproval.isHidden = false
//        }else{
//            self.titlePrivacyResident.text = "Contact Number Privacy for Member"
//            self.viewPrivacyGatekeeper.isHidden = true
//            self.viewChildSecurity.isHidden = true
//            self.viewEntityApproval.isHidden = true
//
//            self.viewVisitorApproval.isHidden = true
//        }
    }

    func doInitSosMpinSettings(){
        if UserDefaults.standard.bool(forKey: StringConstants.SECURITY_MPIN_FLAG){
            self.switchSOSPin.setOn(true, animated: true)
        }else{
            self.switchSOSPin.setOn(false, animated: true)
        }

        if UserDefaults.standard.bool(forKey: StringConstants.SECURITY_BIOMETRICS_FLAG){
         //   self.switchBiometricsLock.setOn(true, animated: true)
            self.setupSwitchButton(labelSwitch: swithchLock, isCheck: true )
        }else{
            self.setupSwitchButton(labelSwitch: swithchLock, isCheck: false )
           // self.switchBiometricsLock.setOn(false, animated: true)
        }
    }
    @IBAction func btnDeleteTenant(_ sender: UIButton) {
         showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure to detete this tenant account?", style: .Delete, tag: 1)
     }
    
    func doDeleteApi(){
        self.showProgress()
        let params = ["removeTenant":"removeTenant",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.switchUserController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.doGetProfile()
                    }else {
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    
                }
            }
        }
    }
    
    @IBAction func btnOpenProfile(_ sender: UIButton) {
        self.openProfile(withid: profileDetails.commonUserId)
    }

    @IBAction func btnAddTenant(_ sender: UIButton) {
        let vc  = subStoryboard.instantiateViewController(withIdentifier: "idAddTenantDialogVC")as! AddTenantDialogVC
        vc.settingsVC = self
        pushVC(vc: vc)
      //  showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do You Really Want To Add Tenant?", style: .Info)

    }

    func showDailogAddTenant() {
//        let screenwidth = UIScreen.main.bounds.width
//        let screenheight = UIScreen.main.bounds.height
//        let vc = subStoryboard.instantiateViewController(withIdentifier: "idAddTenantDialogVC")as! AddTenantDialogVC
//        vc.settingsVC = self
//        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
//        popupVC.backgroundAlpha = 0.8
//        popupVC.backgroundColor = .black
//        popupVC.shadowEnabled = true
//        popupVC.canTapOutsideToDismiss = true
//        present(popupVC, animated: true)
        
        
        let vc  = subStoryboard.instantiateViewController(withIdentifier: "idAddTenantDialogVC")as! AddTenantDialogVC
        vc.settingsVC = self
        pushVC(vc: vc)
        
        
    }
    
    @IBAction func btnOpenTenantProfile(_ sender: Any) {
    }
    @objc func switchDNDChanged(_ sender:UISwitch){
        
    }
    @objc func switchStateChanged(_ sender:UISwitch){
        if sender.isOn{
            
            //switch on
            print("switch openend")
            switch sender.tag {
            case 1:
                doChangeHouseState(state: 5)
                break
            case 2:
                doChangeMobileNumberPrivacy(state: 1)
                break
            case 3:
                doChangeVisitorApproval(state: 1)
                break
            case 4:
                doChangeSOSAlert(state: 0)
                break
            case 5:
                doChangeAccPrivacy(state: 1)
                //viewHide.isHidden = true
                break
            case 6:
                doChangeDobPrivacy(state: 1)
                break
            case 7:
                doChangeGatekeeperState(state: 1)
                break
            case 8:
                doSetSosPin(state : 1)
                break
            case 9:
                doChangeOtherVisitorApproval(state: 1)
                break
            case 10:
                UserDefaults.standard.set(true, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                break
            case 11:
                doChangeChildSecurityPrivacy(state: 0)
                break
            case 12:
                doChangeNotificationOnOff(state: 1)
                
                break
            default:
                break
            }
        }else{
            //switch off
            print("switch closed")
            switch sender.tag {
            case 1:
                if doGetLocalDataUser().userType == "0"{
                    doChangeHouseState(state: 1)
                }else{
                    doChangeHouseState(state: 3)
                }
                break
            case 2:
                doChangeMobileNumberPrivacy(state: 0)
                break
            case 3:
                doChangeVisitorApproval(state: 0)
                break
            case 4:
                doChangeSOSAlert(state: 1)
                break
            case 5:
                doChangeAccPrivacy(state: 0)
                //viewHide.isHidden = false
                break
            case 6:
                doChangeDobPrivacy(state: 0)
                break
            case 7:
                doChangeGatekeeperState(state: 0)
                break
            case 8:
                doSetSosPin(state: 0)
                break
            case 9:
                doChangeOtherVisitorApproval(state: 0)
                break
            case 10:
                UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                break
            case 11:
                doChangeChildSecurityPrivacy(state: 1)
                break
            case 12:
                doChangeNotificationOnOff(state: 0)
                break
            default:
                break
            }
        }
    }
    @IBAction func BtnSoundNotify(_ sender: Any) {
        
        DialogNotificationSounds()
    }
    func DialogNotificationSounds()
    {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let nextVC = DialogNotificationSound()
        
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
    func  doChangeNotificationOnOff(state isOn: Int!){
        
        let defaults = UserDefaults.standard
    
        if isOn == 1
        {
            print("on")
            defaults.set(true, forKey: "SwitchState")
       
        }else
        {
            print("off")
            UIApplication.shared.unregisterForRemoteNotifications()
        }
        DialogNotificationSounds()
  }
    func doSetSosPin(state isOn: Int!){
        if isOn == 1{
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idMpinDialogVC") as! MpinDialogVC
            vc.context = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.6
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }else if isOn == 0{
            self.showAppDialog(delegate: self, dialogTitle: "Are you sure you want to turn off SOS pin?", dialogMessage: "", style: .Delete,tag: 3)
        }
    }
    func doChangeOtherVisitorApproval(state isOn : Int!) {
        let params = ["changePrivacyVisitorGroup":"changePrivacyVisitorGroup",
                      "visitor_approved":String(isOn!),
                      "user_name":doGetLocalDataUser().userFullName!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "user_id":doGetLocalDataUser().userID!]
                      
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }
    func doChangeHouseState(state isOn : Int!){
        let params = ["switchCloseGatekeeper":"switchCloseGatekeeper",
                      "unit_status":String(isOn!),
                      "user_name":doGetLocalDataUser().userFullName!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!]
        doCallAPi(params: params, serviceName: ServiceNameConstants.switchController)
    }
    
    func doChangeMobileNumberPrivacy(state isOn : Int!){
        let params = ["changePrivacy":"changePrivacy",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "public_mobile":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }
    
    func doChangeVisitorApproval(state isOn : Int!){
        UserDefaults.standard.set(String(isOn), forKey: StringConstants.VISITOR_APPROVAL_FLAG)
        let params = ["changePrivacyVisitor":"changePrivacyVisitor",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "visitor_approved":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }

    func doChangeSOSAlert(state isOn : Int!){
        let params = ["changePrivacySos":"changePrivacySos",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "sos_alert":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }

    func doChangeAccPrivacy(state isOn : Int!){
        let params = ["changePrivacyTenant":"changePrivacyTenant",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "tenant_view":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
        if isOn == 1 {
            viewAddTenant.isHidden = true
        } else {
            viewAddTenant.isHidden = false
        }
        if isOn == 1{
            viewHide.isHidden = true
        }else{
            viewHide.isHidden = false
        }
    }
    
    func doChangeDobPrivacy(state isOn : Int!){
        let params = ["changeDOBPrivacy":"changeDOBPrivacy",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "dob_view":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }
    
    func doChangeGatekeeperState(state isOn : Int!){
        let params = ["changePrivacyGatekeeper":"changePrivacyGatekeeper",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "mobile_for_gatekeeper":String(isOn!)]
        
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }

    func doChangeChildSecurityPrivacy(state isOn : Int!){
        let params = ["changeChildSecurityPrivacy":"changeChildSecurityPrivacy",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "child_gate_approval":String(isOn!)]
        doCallAPi(params: params, serviceName: ServiceNameConstants.aboutController)
    }
    
    func doCallAPi(params : [String:String]!,serviceName:String!){
        showProgress()
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: serviceName, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200" {
                        self.toast(message: response.message, type: .Information)
                    }else{
                    }
                }catch{
                    print("parse error",error.localizedDescription)
                }
            }else{
                
            }
        }
    }
    
    func doGetProfile() {
        showProgress()
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.resident_data_update_controller2, parameters: params) { (json, error) in

            if json != nil {
                self.hideProgress()
                print(json as Any)
                do {
                    
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200" {
                        self.profileDetails = response
                        if response.unitCloseForGatekeeper == "0"{
                            self.switchApartmentState.setOn(false, animated: true)
                        }else{
                            self.switchApartmentState.setOn(true, animated: true)
                        }
                        
                      //  if response.publicMobile == "0"{
                      //      self.switchMobileNumber.setOn(false, animated: true)
                      //  }else{
                      //      self.switchMobileNumber.setOn(true, animated: true)
                     //   }
                        if response.public_mobile_action == "0"{
                            self.viewprivacy.isHidden = false
                            
                        }else{
                            self.viewprivacy.isHidden = true
                        }
                
                        self.setupSwitchButton(labelSwitch: self.swithchPrivateNumber, isCheck: response.publicMobile == "0" ? false : true )
                        
                        if response.sosAlert == "0"{
                            self.switchSOSAlet.setOn(true, animated: true)
                            
                        }else{
                            self.switchSOSAlet.setOn(false, animated: true)
                            
                        }

                        if response.groupVisitorApproval == "1"{
                            self.switchOtherVisitorApproval.setOn(true, animated: true)
                        }else{
                            self.switchOtherVisitorApproval.setOn(false, animated: true)
                        }

                        if response.mobileForGatekeeper == "1"{
                            self.switchMobileNumberGatekeeper.setOn(true, animated: true)
                        }else{
                            self.switchMobileNumberGatekeeper.setOn(false, animated: true)
                        }
                        
                        if response.visitorApproved != "0"{
                            self.switchVisitorApproval.setOn(true, animated: true)
                        }else{
                            self.switchVisitorApproval.setOn(false, animated: true)
                        }
                        
                        if response.tenantView != "1"{
                            self.switchPrivateAcc.setOn(true, animated: true)
                            
                        }else{
                            self.switchPrivateAcc.setOn(false, animated: true)
                            
                        }
                        
                        //if response.dobView == "1"{
                      //      self.switchDOB.setOn(true, animated: true)//
                      //  }else{
                      //      self.switchDOB.setOn(false, animated: true)
                      //  }
                        
                        self.setupSwitchButton(labelSwitch: self.swithchPrivateDOB, isCheck: response.dobView == "1" ? true : false )
                       
                        
                        if response.mobileForGatekeeper == "1"{
                            self.switchMobileNumberGatekeeper.setOn(true, animated: true)
                        }else{
                            self.switchMobileNumberGatekeeper.setOn(false, animated: true)
                        }

                        if response.childGateApproval == "0"{
                            self.switchChildSecurity .setOn(true, animated: true)
                        }else{
                            self.switchChildSecurity .setOn(false, animated: true)
                        }
                        
//                        if response.commonUserId == "" && response.commonFullName == "" {
//                            self.viewShowTenant.isHidden = true
//                            self.viewAddTenant.isHidden = false
//                            self.heightConAddTenet.constant = 46
//                        }else{
//                            self.viewShowTenant.isHidden = false
//                            self.viewAddTenant.isHidden = true
//                          //  self.lblMobileNumber.text = response.countryCode ?? "" + " " + response.commonMobile
//                            self.lblTenantName.text = response.commonFullName
//                            Utils.setImageFromUrl(imageView: self.imgTenantImage, urlString: response.commonUserProfile, palceHolder: "user_default")
//                            self.heightConAddTenet.constant = 80
//                        }

                        self.doInitSosMpinSettings()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func btnBackPassed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func tapViewTenantDetails(_ sender: Any) {
        
        if profileDetails.userType == "0" {
            // tenant
            let vc = storyboard?.instantiateViewController(withIdentifier: "idTenantDetailsVC") as! TenantDetailsVC
            vc.user_id = profileDetails.commonUserId
            pushVC(vc: vc)
        } else {
            //onwer
//            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//            vc.user_id = profileDetails.commonUserId
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = MemberDetailsVC()
            vc.user_id = profileDetails.commonUserId ?? ""
            vc.userName =  ""
            pushVC(vc: vc)
            
        }
       
    }
    
    @IBAction func tapChangeLanguage(_ sender: UIButton) {
        let vc = SelectLanguageVC()
        vc.setIsComeFromSetting(isComeFromSetting: true)
        self.pushVC(vc: vc)
        
//        UserDefaults.standard.set(nil, forKey: StringConstants.LANGUAGE_DATA)
//        toast(message: "Language Data Deleted", type: .Faliure)
    }
    
    private func setUIData() {
        lbGeneralSetting.text = doGetValueLanguage(forKey: "general_setting")
        titleApartmentClosed.text = doGetValueLanguage(forKey: "unit_close")
        lblNotificationSound.text = doGetValueLanguage(forKey: "notification_sound")
        lbApplySystemLock.text = doGetValueLanguage(forKey: "apply_system_lock")
        lbChangeLanguage.text = doGetValueLanguage(forKey: "change_language")
        lbPrivacySetting.text = doGetValueLanguage(forKey: "privacy_setting")
        lbContactNumberPrivacy.text = doGetValueLanguage(forKey: "contact_number_privacy")
        lbDOBPrivacy.text = doGetValueLanguage(forKey: "date_of_birth_privacy")
        lbTitle.text = doGetValueLanguage(forKey: "settings")
    }
    
}
extension SettingsVC: AppDialogDelegate , LabelSwitchDelegate{
    //todo for swich button
    func switchChangToState(sender: LabelSwitch) {
        
        if sender == swithchPrivateNumber {
            
            if sender.curState == .L {
                //off
                doChangeMobileNumberPrivacy(state: 0)
                swithchPrivateNumber.circleColor = ColorConstant.colorP
            } else {
                //on
                doChangeMobileNumberPrivacy(state: 1)
                swithchPrivateNumber.circleColor = .white
            }
            
        }
        if sender == swithchDND {
            
            if sender.curState == .L {
                //off
                doChangeMobileNumberPrivacy(state: 0)
                swithchDND.circleColor = ColorConstant.colorP
            } else {
                //on
                doChangeMobileNumberPrivacy(state: 1)
                swithchDND.circleColor = .white
            }
            
        }
        if sender == swithchPrivateDOB {
            
            if sender.curState == .L {
                swithchPrivateDOB.circleColor = ColorConstant.colorP
                doChangeDobPrivacy(state: 0)
            } else {
                swithchPrivateDOB.circleColor = .white
                doChangeDobPrivacy(state: 1)
            }
            
        }
        if sender == swithchLock {
            if sender.curState == .L {
                UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
                swithchLock.circleColor = ColorConstant.colorP
            } else {
                swithchLock.circleColor = .white
                UserDefaults.standard.set(true, forKey: StringConstants.SECURITY_BIOMETRICS_FLAG)
              
            }
        }
        
        
    }
    

    func btnAgreeClicked(dialogType: DialogStyle, tag:Int) {
        if dialogType == .Info{
            //  isShowAddTenetDailog = true
            if tag == 3{
                self.dismiss(animated: true) {
                    UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_MPIN_FLAG)
                    UserDefaults.standard.set("", forKey: StringConstants.SECURITY_MPIN_VALUE)
                    self.fetchNewDataOnRefresh()
                }
            }
            //else{
//                self.dismiss(animated: true, completion : {
//                    self.showDailogAddTenant()
//                })
            //}
        }else if dialogType == .Cancel{
            if tag == 3{
                self.dismiss(animated: true) {
                    self.toast(message: "MPin Removed SuccessFully!!", type: .Success)
                    UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_MPIN_FLAG)
                    UserDefaults.standard.set("", forKey: StringConstants.SECURITY_MPIN_VALUE)
                    self.fetchNewDataOnRefresh()
                }
            }else{
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) {
                if tag == 1{
                    self.doDeleteApi()
                }else{
                    self.toast(message: "MPin Removed SuccessFully!!", type: .Success)
                    UserDefaults.standard.set(false, forKey: StringConstants.SECURITY_MPIN_FLAG)
                    UserDefaults.standard.set("", forKey: StringConstants.SECURITY_MPIN_VALUE)
                    self.fetchNewDataOnRefresh()
                }
                  
            }
            
        }
    }

    func btnCancelClicked() {
        doInitSosMpinSettings()
    }
}


extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                print("Handle new Biometric type")
                break
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
