//
//  BaseVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
import Lightbox
import EzPopup
import Alamofire
import Photos
import AVKit
import AVFoundation
import Speech
import CoreLocation
import ContactsUI
struct alphabetModel {
    var imageIdentifier : String!
    var alphabetImage : UIImage!
}

enum ToastType{
    case Success
    case Faliure
    case Warning
    case Information
    case Defult
}

enum DialogStyle {
    case Success
    case Delete
    case Info
    case Cancel
    case General
    case Add
    case Notice
}
public var isShowOpenInternetScreen = true
class BaseVC: UIViewController , UITextFieldDelegate , SWRevealViewControllerDelegate{
    
    var PView : NVActivityIndicatorView!
    var viewSub : UIView!
    var overlyView = UIView()
    var successStyle = ToastStyle()
    var failureStyle = ToastStyle()
    var warningStyle = ToastStyle()
    var infoStyle = ToastStyle()
    var defultStyle = ToastStyle()
    var alphabetImageArray = [alphabetModel]()
    private  let instance =  LocalStorage.instance
    public let stateId = UserDefaults.standard.string(forKey: StringConstants.STATEID)
    public let countryId = UserDefaults.standard.string(forKey: StringConstants.COUNTRYID)
    public let cityId = UserDefaults.standard.string(forKey: StringConstants.CITYID)
    public let subStoryboard = UIStoryboard(name: "sub", bundle: nil)
    public let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    public let refreshControl = UIRefreshControl()
    public let entertainmentStoryboard = UIStoryboard(name: "Entertaiment", bundle: nil)
    private var contactStore = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        initToastStyles()
        refreshControl.tintColor = .clear
        initInterNet()
       
        PlugNPlay.setDisableCompletionScreen(true)
        PlugNPlay.setMerchantDisplayName(doGetValueLanguage(forKey: "app_name"))
        PlugNPlay.setTopBarColor(ColorConstant.primaryColor)
        PlugNPlay.setButtonColor(ColorConstant.primaryColor)
        PlugNPlay.setButtonTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        PlugNPlay.setDisableCompletionScreen(true)
        PlugNPlay.setIndicatorTintColor(ColorConstant.primaryColor)
       
        
         addAlphabetArray()
        
        isShowOpenInternetScreen = true

    }
    override func viewDidAppear(_ animated: Bool) {
      //  NotificationCenter.default.addObserver(self, selector: #selector(ChildApprovalRequest(_:)), name: .childApprovalRequest, object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
  //      NotificationCenter.default.removeObserver(self, name: .childApprovalRequest, object: nil)
    }
   
  
   
    func initToastStyles(){
        successStyle.messageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        successStyle.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

        failureStyle.messageColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        failureStyle.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        warningStyle.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        warningStyle.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.6784313725, blue: 0.1921568627, alpha: 1)

        infoStyle.messageColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        infoStyle.backgroundColor = UIColor(named: "blue_500")!
        
        defultStyle.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        defultStyle.backgroundColor = UIColor(named: "bg_color") ?? #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    func doReturnImage(from alphabet:String!)->UIImage!{
        var image : UIImage!
        for item in alphabetImageArray{
            if item.imageIdentifier.lowercased() == alphabet.lowercased(){
                image = item.alphabetImage
            }
        }
        return image
    }
    func openCalendarDatePicker(delegate : CalendarDialogDelegate, tag : Int! = 0 , minimum : String! = "",selectDate : String! = ""){
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboardConstants.sub.instantiateViewController(withIdentifier: "idCalendarDailogVC") as! CalendarDailogVC
        vc.delegate = delegate
        vc.tag = tag
        if minimum != "" {
         vc.minimumDate = minimum
        }
        vc.selectDate = selectDate
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    func addKeyboardAccessory(textViews: [UITextView], dismissable: Bool = true, previousNextable: Bool = true) {
        for (index, textField) in textViews.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()

            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textViews.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textViews[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }

                let nextButton = UIBarButtonItem(image: UIImage(named: "down-arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textViews.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textViews[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    func addKeyboardAccessory(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = true) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "down-arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    func openProfile (withid ID : String!){
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
        vc.user_id = ID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func initInterNet() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    func doCall(on PhoneNumber : String!){
        
        print(PhoneNumber ?? "")
        
     //   let phone = lblAltPhoneNum.text!
             
        let splitedPhoneNoArr = PhoneNumber.components(separatedBy: " ")
        let countryCode = splitedPhoneNoArr[0]
        let onlyNo: String? = splitedPhoneNoArr.count > 1 ? splitedPhoneNoArr[1] : ""
        var phoneNo: String? = countryCode
        
        if onlyNo ?? "" != "" {
            phoneNo = "\(phoneNo ?? "")\( onlyNo ?? "")"
        }
        // print(onlyNo!)
             // print(countryCode)
              if let number = phoneNo {
                  if let phoneCallURL = URL(string: "telprompt://\(number)") {
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
      
//        if let phoneCallURL = URL(string: "telprompt://\(PhoneNumber!)") {
//
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                if #available(iOS 10.0, *) {
//                    application.open(phoneCallURL, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versio
//                    application.openURL(phoneCallURL as URL)
//
//                }
//            }else{
//                print("dialer N/A")
//            }
//        }
    }
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            if !isShowOpenInternetScreen {
                return
            }
            let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idNoNetworkVC") as! NoNetworkVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            break
        case .wifi:
            onNetconnected()
        case .wwan:
            onNetconnected()
            print("")
        }
        
    }
    func onNetconnected(){
        
    }
    func addRefreshControlTo(collectionView : UICollectionView){
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefreshData(_:)), for: .valueChanged)
    }
    func addRefreshControlTo(tableView:UITableView){
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefreshData(_:)), for: .valueChanged)
        
    }
    @objc func pullToRefreshData(_ sender:Any){
        
        fetchNewDataOnRefresh()
        
    }
    func hidePull() {
        refreshControl.endRefreshing()
    }
    func fetchNewDataOnRefresh(){
        
    }
    func doInintialRevelController(bMenu:UIButton) {

        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.left
        {
            overlyView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height)
          
            self.view.addSubview(overlyView)
           
        }
        else
        {
            overlyView.removeFromSuperview()
            
        }
    }
    
    func hideKeyBoardHideOutSideTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func doneButtonOnKeyboard(textField: [UITextField]){
        for item in textField{
            let kb = UIToolbar()
            kb.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClickKeyboard))
            kb.items = [flexSpace,doneButton]
            item.inputAccessoryView = kb
        }
    }
    func doneButtonOnKeyboard(textField: UITextField){
        let kb = UIToolbar()
        kb.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClickKeyboard))
        kb.items = [flexSpace,doneButton]
        textField.inputAccessoryView = kb
    }
    func doneButtonOnKeyboard(textField: UITextView){
        let kb = UIToolbar()
        kb.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClickKeyboard))
        kb.items = [flexSpace,doneButton]
        textField.inputAccessoryView = kb
    }
    @objc func doneClickKeyboard(){
        view.endEditing(true)
    }
    //end
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func doGetLocalDataUser()->LoginResponse{
        var userLocalData : LoginResponse? = nil
        if let data = UserDefaults.standard.data(forKey: StringConstants.KEY_LOGIN_DATA), let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data){
            userLocalData = decoded
        }
        return userLocalData!
    }
    func doGetLocalMemberData()->ResponseMember{
        var userLocalData : ResponseMember? = nil
        if let data = UserDefaults.standard.data(forKey: StringConstants.KEY_MEMBER_DATA), let decoded = try? JSONDecoder().decode(ResponseMember.self, from: data){
            userLocalData = decoded
        }
        return userLocalData!
    }
    func showSettingAlertWith(title:String, msg:String) {
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
    func doGetLocalMenuData()->ResponseMenuData{
        var userLocalData : ResponseMenuData? = nil
        if let data = UserDefaults.standard.data(forKey: StringConstants.KEY_MENU_DATA), let decoded = try? JSONDecoder().decode(ResponseMenuData.self, from: data){
            userLocalData = decoded
        }
        return userLocalData!
    }
    func closeKeyboard() {
        view.endEditing(true)
    }
    //star
    
    //Todo show alert for messsage only
    func showAlertMessage(title:String, msg:String) {
        var temp = title
        if temp.lowercased().contains("alert"){
            temp = ""
        }
        var ok = doGetValueLanguage(forKey: "ok")
        if ok == "" {
            ok = "OK"
        }
        
        let alert = UIAlertController(title: temp, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:  ok, style: .default, handler: { action in
            // self.onClickDone()
        }))
        self.present(alert, animated: true)
    }
    //Todo show alert for messsage only with click
    func showAlertMessageWithClick(title:String, msg:String) {
        var ok = doGetValueLanguage(forKey: "ok")
        if ok == "" {
            ok = "OK"
        }
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.onClickDone()
        }))
        
        self.present(alert, animated: true)
    }
    func onClickDone() {
        
    }
    //end
    
    func showProgress() {
        print("showProgress")
        viewSub = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //    myView.frame.height/2
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        //    myView.frame.height/2
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        PView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: 32), color: ColorConstant.colorAccent,  padding: 15)
        PView.center = viewSub.center
        PView.backgroundColor = UIColor.white
        PView.layer.cornerRadius = 10
        PView.layer.shadowOpacity = 0.5
        PView.layer.masksToBounds = false
        PView.layer.shadowOffset = CGSize.zero
        viewSub.addSubview(PView)
        PView.startAnimating()
        self.view.addSubview(viewSub)
        
    }
    func returnImageFromUrl(StringUrl Url : String) -> UIImage!{
        let url = Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var image : UIImage!
        AF.request(url).responseData(completionHandler: { response in
            if let img = UIImage(data: response.data!){
                image = img
            }
        })
        return image
    }
    func OpenImageDisplay(imgArray:[String]!,context:UIViewController){
        var images = [LightboxImage]()
        for image in imgArray{
            images.append(LightboxImage(imageURL:URL(string:image)!))
        }
        let controller = LightboxController(images: images)
      //  controller.pageDelegate = self
       // controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        // Present your controller.
        parent?.present(controller, animated: true, completion: nil)
    }
    
    func popToHomeController(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func hideProgress() {
        PView.stopAnimating()
        viewSub.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    func getHeaders() -> HTTPHeaders {
        
        if  self.isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN)
        {
            let userName = doGetLocalDataUser().userID ?? ""
           
                let password = currentpassword()
                print(currentpassword())
               // print(password)
                let credentialData = "\(userName):\(password)".data(using: .utf8)
                guard let cred = credentialData else { return ["" : "",
                                                               "key":BaseVC().apiKey()] }
                let base64Credentials = cred.base64EncodedData(options: [])
                guard let base64Date = Data(base64Encoded: base64Credentials) else { return ["" : "",
                                                                                             "key":BaseVC().apiKey()] }
                return ["Authorization": "Basic \(base64Date.base64EncodedString())",
                        "key":BaseVC().apiKey()]
            }
        return ["key":BaseVC().apiKey()]
        }
    func GetthreeDigitMobilenumber() -> String {
        
        let str = doGetLocalDataUser().userMobile ?? ""
        let last3 = String(str.suffix(3))
        return last3
    }
    func currentpassword() -> String {
        var pass = ""
        if  self.isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN)
        {
            let subMobile = GetthreeDigitMobilenumber()
            let societyId = doGetLocalDataUser().societyID ?? ""
            let userid = doGetLocalDataUser().userID ?? ""
            pass  = "\(userid)@\(subMobile)@\(societyId)"
        }
        return pass
    }
    
    func doPopBAck(){
        self.navigationController?.popViewController(animated: true)
    }

    func doPopRootBAck(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func changeButtonImageColor(btn:UIButton , image:String,color:UIColor) {        
        let origImage = UIImage(named: image)
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = color
    }
    func convertImageTobase64(imageView:UIImageView) -> String {
       
        let imageData = imageView.image?.jpegData(compressionQuality: 0.25)
        if  imageData == nil{
            return ""
        }
        //let imageData = UIImageJPEGRepresentation(imageView.image!,0.25)
        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func getChatCount() -> String{
        if isKeyPresentInUserDefaults(key: StringConstants.CHAT_STATUS) {
            return UserDefaults.standard.string(forKey: StringConstants.CHAT_STATUS)!
        } else {
            return  "0"
        }
        
    }
    func getNotiCount() -> String{
        if isKeyPresentInUserDefaults(key: StringConstants.READ_STATUS) {
            return UserDefaults.standard.string(forKey: StringConstants.READ_STATUS)!
        } else {
            return  "0"
        }
        
    }
    func toast(message:String!,type:ToastType,duration : Double! = 2){
        switch (type) {
        case .Success: //success toast
            self.view.makeToast(message,duration:duration,position:.bottom,style:self.successStyle)
            break;
        case .Faliure: //faliure toast
            self.view.makeToast(message,duration:duration,position:.bottom,style:self.failureStyle)
            break;
        case .Warning: //warning toast
            self.view.makeToast(message,duration:duration,position:.bottom,style:self.warningStyle)
            break;
        case .Information: //info toast
            self.view.makeToast(message,duration:duration,position:.bottom,style:self.infoStyle)
            break;
        case .Defult: //info toast
            self.view.makeToast(message,duration:duration,position:.bottom,style:self.defultStyle)
            break;

        }
    }
    func openEmailDialog(delegate : EmailDialogDelegate! , tag : Int! = 0){
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idEmailUpdateDialog") as! EmailUpdateDialog
        vc.delegate = delegate
        vc.tag = tag
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    func convertToDictionary(text: String) -> [AnyHashable: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func showAppDialog(delegate : AppDialogDelegate!,dialogTitle:String!,dialogMessage:String!,style:DialogStyle,tag:Int! = 0){
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAppDialogVC") as! AppDialogVC
        vc.delegate = delegate
        vc.dialogTitle = dialogTitle
        vc.dialogMessage = dialogMessage
        vc.dialogType = style
        vc.tag = tag
        switch style {
        case .Cancel:
            vc.dialogImage = UIImage(named: "close-button")
            vc.bgColor = UIColor(named: "red_500")
            vc.buttonTitle = "YES"
            break;

        case .Delete:
            vc.dialogImage = UIImage(named: "delete_button")
            vc.bgColor = UIColor(named: "red_500")
            vc.buttonTitle = "DELETE"
            break;
            
        case .Info:
            vc.dialogImage = UIImage(named: "info")
            vc.bgColor = UIColor(named: "yellow_900")
            vc.buttonTitle = "OK"
            break;
        case .Add:
            vc.dialogImage = UIImage(named: "finca_logo")
            vc.bgColor = UIColor(named: "ColorPrimary")
            vc.buttonTitle = "OK"

        case .Success:
            vc.dialogImage = UIImage(named: "enter")
            vc.bgColor = UIColor(named: "ColorPrimary")
            vc.buttonTitle = "Accept"

        case .Notice:
            vc.dialogImage = UIImage(named: "info")
            vc.bgColor = UIColor(named: "indigo_500")
            vc.buttonTitle = "OKAY"
        default:
            break;

        }
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    func showAppDialog(delegate : AppDialogDelegate!,dialogTitle:String!,dialogMessage:String!,style:DialogStyle,tag:Int! = 0,cancelText : String , okText : String){
           let screenwidth = UIScreen.main.bounds.width
           let screenheight = UIScreen.main.bounds.height
           let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAppDialogVC") as! AppDialogVC
           vc.delegate = delegate
           vc.dialogTitle = dialogTitle
           vc.dialogMessage = dialogMessage
           vc.dialogType = style
           vc.tag = tag
               
        
        switch style {
           case .Cancel:
               vc.dialogImage = UIImage(named: "close-button")
               vc.bgColor = UIColor(named: "red_500")
             //  vc.buttonTitle = "YES"
            vc.buttonTitle = okText.uppercased()
               //   vc.setButtonCancelTitle(title: cancelText)
            vc.buttonTitleCancel = cancelText.uppercased()
               break;

           case .Delete:
               vc.dialogImage = UIImage(named: "delete_button")
               vc.bgColor = UIColor(named: "red_500")
              // vc.buttonTitle = "Delete"
                vc.buttonTitle = okText.uppercased()
                 // vc.setButtonCancelTitle(title: cancelText)
            vc.buttonTitleCancel = cancelText.uppercased()
               break;
               
           case .Info:
               vc.dialogImage = UIImage(named: "info_warning")
               vc.bgColor = UIColor(named: "indigo_500")
              // vc.buttonTitle = "OK"
                vc.buttonTitle = okText.uppercased()
            vc.buttonTitleCancel = cancelText.uppercased()
               break;

        case .Add:
            vc.dialogImage = UIImage(named: "finca_logo")
            vc.bgColor = .white
            vc.isTintColor = "1"
            // vc.buttonTitle = "OK"
            vc.buttonTitle = okText.uppercased()
            vc.buttonTitleCancel = cancelText.uppercased()
            
            break;

        case .Notice:
            vc.dialogImage = UIImage(named: "Alert")
            vc.bgColor = UIColor(named: "yellow_900")
            vc.buttonTitle = "OKAY"
            break;
           default:
               break;
                   
           }
           
           let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
           popupVC.backgroundAlpha = 0.8
           popupVC.backgroundColor = .black
           popupVC.shadowEnabled = true
           popupVC.canTapOutsideToDismiss = true
           present(popupVC, animated: true)
       }
    func removeToast() {
        self.view.hideAllToasts(includeActivity: true, clearQueue: true)
    }
    func baseUrl() -> String {
        var url = ""
        
        if isKeyPresentInUserDefaults(key:  StringConstants.KEY_BASE_URL) {
            url = UserDefaults.standard.string(forKey: StringConstants.KEY_BASE_URL)! + StringConstants.APINEW
        }
        return url
    }
    func apiKey() -> String {
        var url = "bmsapikey"
        
        if isKeyPresentInUserDefaults(key:  StringConstants.KEY_API_KEY) {
            url = UserDefaults.standard.string(forKey: StringConstants.KEY_API_KEY)!
         }
        return url
    }
    func goToDashBoard(storyboard:UIStoryboard!) {
        let destiController = storyboard.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    func getBuildingDetails(){
        print("get polling options")
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "buildingDetails":"buildingDetails",
                      "society_id":doGetLocalDataUser().societyID!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.buildingDetailsController, parameters: params) { (json, error) in
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BuildingDetailResponse.self, from:json!)
                    if response.status == "200" {
                        UserDefaults.standard.set(response.socieatyLogo, forKey: StringConstants.KEY_SOCIATY_LOGO)
                        
                    }else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func pushVC(vc : UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func doneButtonOnKeyboardWithIcon(textField: UITextField){
        let kb = UIToolbar()
        kb.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(doneClickKeyboard))
        let origImage = UIImage(named: "keypad")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        doneButton.image = tintedImage
        doneButton.tintColor = ColorConstant.colorP
        kb.items = [flexSpace,doneButton]
        textField.inputAccessoryView = kb

    }
    func doSetNotificationCounterOnAppIcon(count:String) {
           let badgeCount: Int = Int(count)!
           let application = UIApplication.shared
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
               // Enable or disable features based on authorization.
           }
           application.registerForRemoteNotifications()
           application.applicationIconBadgeNumber = badgeCount
     
       }
    func setPlaceholderLocal(key : String! = "", value : String!){
        UserDefaults.standard.set(value, forKey: StringConstants.KEY_DYANAMIC_PLACEHOLDE)
        
    }
    func getPlaceholderLocal(key : String! = "") -> String{
        return UserDefaults.standard.string(forKey: StringConstants.KEY_DYANAMIC_PLACEHOLDE) ?? ""
    }
    func localCurrency() -> String {
        var curruncy = ""
        if doGetLocalDataUser().currency != nil {
            curruncy =  doGetLocalDataUser().currency
        }
        return curruncy
    }
    func getAssetThumbnailNew(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option) { resultImg, info in
            if let image = resultImg {
                thumbnail = image
            }
        }
        
//        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelWidth), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//            thumbnail = result!
//        })
        return thumbnail
    }
    
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    func doGetLanguageId() -> String {
        var societyID = "0"
        if doCheckIsLocalDataIsThere() {
            societyID = self.doGetLocalDataUser().societyID ?? "0"
        }
        let key = "\(StringConstants.LANGUAGE_ID)\(societyID)"
        
        if let id = UserDefaults.standard.string(forKey: key) {
            return id
        }
        return "1"
    }
    func unitName() -> String {
       return "\(doGetLocalDataUser().blockName ?? "")-\(doGetLocalDataUser().unitName ?? "")"
    }
    func hideChat() -> Bool {
        return UserDefaults.standard.bool(forKey: StringConstants.KEY_HIDE_CHAT)
    }
    func hideTimeline() -> Bool {
        return UserDefaults.standard.bool(forKey: StringConstants.KEY_HIDE_TIMELINE)
    }
    func hideProfessional() -> Bool {
        return UserDefaults.standard.bool(forKey: StringConstants.KEY_HIDE_PROFESSIONAL)
    }
    func addPopView(vc : UIViewController) {
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)  // add child for main view
        self.view.addSubview(vc.view)
    }
    func removePopView() {
        removeFromParent()
        view.removeFromSuperview()
    }
    func playVideo(url: URL) {
   let player = AVPlayer(url: url)

        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    func setupMarqee(label : MarqueeLabel) {
        label.type = .continuous
        label.animationCurve = .easeIn
        label.fadeLength = 10.0
        label.leadingBuffer = 0
        label.trailingBuffer = 0
    }
    func removeSpaceFromUrl(stringUrl:String)->URL
    {
        let urlString = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")
        return url!
    }
    func userChatId() -> String {
        return  "\(doGetLocalDataUser().societyID ?? "")\(doGetLocalDataUser().userMobile ?? "")"
    }
    
    //TODO this function use get language value against key
    func doGetValueLanguage(forKey : String) -> String {
        var societyID = "0"
        if doCheckIsLocalDataIsThere() {
            societyID = self.doGetLocalDataUser().societyID ?? "0"
        }
        let key = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
       
        if  let data  = UserDefaults.standard.value(forKey: key)  {
            let dictLo :NSDictionary = data  as! NSDictionary
            if  let value = dictLo.value(forKey: forKey)as? String {
                return value
            }
        }
        
        return  ""
    }
    func doGetValueLanguageArrayString(forKey : String) -> [String] {
        //let key = "\(StringConstants.LANGUAGE_DATA)\(self.doGetLocalDataUser().societyID ?? "0")"
        var societyID = "0"
        if doCheckIsLocalDataIsThere() {
            societyID = self.doGetLocalDataUser().societyID ?? "0"
        }
        let key = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
       
        if  let data  = UserDefaults.standard.value(forKey: key)  {
            let dictLo :NSDictionary = data  as! NSDictionary
            let value = dictLo.value(forKey: forKey)as! [String]
            return value
        }
        return  [String]()
    }
    
    func doGetValueLanguageForAddMore(forKey : String) -> String {
       
        let key = "\(StringConstants.LANGUAGE_DATA_ADD_MORE)"
       
        if  let data  = UserDefaults.standard.value(forKey: key)  {
            let dictLo :NSDictionary = data  as! NSDictionary
            if  let value = dictLo.value(forKey: forKey)as? String {
                return value
            }
        }
        
        return  ""
    }
    
     //End
    func  instanceLocal() -> LocalStorage {
        return instance
    }
    
    func showAttachmentDialog(msg : String , isShowFile : Bool = false){
        let alert = UIAlertController(title: msg, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_camera"), style: .default, handler: { _ in
            self.tapOpenMedia(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "ios_gallery"), style: .default, handler: { _ in
            self.tapOpenMedia(type: .gallery)
        }))
        if isShowFile {
            alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "choose_from_document"), style: .default, handler: { (UIAlertAction) in
                self.tapOpenMedia(type: .fileExplore)
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: doGetValueLanguage(forKey: "cancel"), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
         
    }
    func tapOpenMedia(type : MediaType){
   
    }
    
    func doCheckIsLocalDataIsThere() -> Bool {
        return  isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN_DATA)
    }
    
    
    func userName() -> String {
        return  "\(doGetLocalDataUser().userFullName ?? "")-\(doGetLocalDataUser().company_name ?? "")"
    }
    
    private func addAlphabetArray() {
        
        alphabetImageArray.append(alphabetModel(imageIdentifier: "a", alphabetImage: UIImage(named: "a")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "b", alphabetImage: UIImage(named: "b")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "c", alphabetImage: UIImage(named: "c")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "d", alphabetImage: UIImage(named: "d")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "e", alphabetImage: UIImage(named: "e")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "f", alphabetImage: UIImage(named: "f")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "g", alphabetImage: UIImage(named: "g")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "h", alphabetImage: UIImage(named: "h")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "i", alphabetImage: UIImage(named: "i")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "j", alphabetImage: UIImage(named: "j")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "k", alphabetImage: UIImage(named: "k")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "l", alphabetImage: UIImage(named: "l")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "m", alphabetImage: UIImage(named: "m")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "n", alphabetImage: UIImage(named: "n")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "o", alphabetImage: UIImage(named: "o")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "p", alphabetImage: UIImage(named: "p")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "q", alphabetImage: UIImage(named: "q")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "r", alphabetImage: UIImage(named: "r")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "s", alphabetImage: UIImage(named: "s")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "t", alphabetImage: UIImage(named: "t")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "u", alphabetImage: UIImage(named: "u")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "v", alphabetImage: UIImage(named: "v")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "w", alphabetImage: UIImage(named: "w")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "x", alphabetImage: UIImage(named: "x")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "y", alphabetImage: UIImage(named: "y")))
        alphabetImageArray.append(alphabetModel(imageIdentifier: "z", alphabetImage: UIImage(named: "z")))
    }
    
     func showNoInternetToast() {
        var toastStyle = ToastStyle()
        toastStyle.messageColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toastStyle.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        var noInter = "No Internet Connection!"
        
        if doGetValueLanguage(forKey: "check_internet_connection") != "" {
            noInter = doGetValueLanguage(forKey: "check_internet_connection")
        }
        self.view.makeToast(noInter,duration:2,position:.bottom,style:toastStyle)
       
    }
    
//    func checkMicroPhonePermision() -> Bool {
//        var isGrant = true
//        SFSpeechRecognizer.requestAuthorization { (authStatus) in
//           // var isButtonEnabled = false
//
//            switch authStatus {
//            case .authorized:
//
//
//                break
//               // isButtonEnabled = true
//
//            case .denied:
//                //isButtonEnabled = false
//                print("User denied access to speech recognition")
//
//                DispatchQueue.main.async {
//                    showAlertMsg(title: "", msg: "My Association needs access to speech recognition.Tap Settings -> turn on Speech Recognition")
//
//                }
//
//                isGrant = false
//            case .restricted:
//               // isButtonEnabled = false
//                print("Speech recognition restricted on this device")
//                isGrant = false
//                return
//            case .notDetermined:
//               // isButtonEnabled = false
//                print("Speech recognition not yet authorized")
//                isGrant = false
//                return
//            @unknown default:
//                break
//            }
//
//
//        }
//
//
//        switch AVAudioSession.sharedInstance().recordPermission {
//        case AVAudioSession.RecordPermission.granted:
//            print("Permission granted")
//        case AVAudioSession.RecordPermission.denied:
//            print("Pemission denied")
//            showAlertMsg(title: "", msg: "My Association needs access to microphone.Tap Settings -> turn on Microphone")
//            return true
//        case AVAudioSession.RecordPermission.undetermined:
//            print("Request permission here")
//            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
//                // Handle granted
//            })
//            return false
//        @unknown default: break
//
//        }
//
//
//
//
//        func showAlertMsg(title:String, msg:String) {
//            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
//
//                alert.dismiss(animated: true, completion: nil)
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            }))
//
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true)
//        }
//
//
//        return isGrant
//    }
    func isCheckRecognize(completionHandler: @escaping (Bool) -> Void){
        
      //  var isGrant = false
        
        OperationQueue.main.addOperation {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
           // var isButtonEnabled = false
            
         
                switch authStatus {
                case .authorized:
                  
                   // isGrant =  true
                    completionHandler(true)
                    break
                   // isButtonEnabled = true
                    
                case .denied:
                    //isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                    DispatchQueue.main.async {
                        self.showAlertMsg(title: "", msg: "\(self.doGetValueLanguage(forKey: "app_name")) needs access to speech recognition.Tap Settings -> turn on Speech Recognition")
                        
                       // isGrant =   false
                        completionHandler(false)
                       
                    }
                    return
                    
                     
                case .restricted:
                   // isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                   // isGrant = false
                    completionHandler(false)
                   // return
                case .notDetermined:
                   // isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                   // isGrant = false
                    completionHandler(false)
                   // return
                @unknown default:
                    
                    break
                }
            }
           
            
           
        }
        
        
      //  return  isGrant
    }
    func isCheckMicro() -> Bool {
        var isGrant = false
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
            isGrant =    true
            break
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            showAlertMsg(title: "", msg: "\(self.doGetValueLanguage(forKey: "app_name")) needs access to microphone.Tap Settings -> turn on Microphone")
            isGrant = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
            isGrant = false
            break
        @unknown default: break
            
        }
        return isGrant
    }
    private  func showAlertMsg(title:String, msg:String) {
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
   
    
    func checkContactPermision() -> Bool {
        var isGrant = true
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (granted){
                let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
                
                switch authorizationStatus {
                case .authorized:
                   
                    isGrant = true
                  case .denied:
                    self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                        if access {
                          
                        }
                        else {
                            isGrant = false
                            if authorizationStatus == CNAuthorizationStatus.denied {
                                DispatchQueue.main.async {
                                    _ = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                                }
                              
                            }
                        }
                    })
                    
                default: break
                // completionHandler(accessGranted: false)
                }
            } else {
                isGrant =  false
            }
        })
        return isGrant
    }
    
}

extension BaseVC:LightboxControllerPageDelegate,LightboxControllerDismissalDelegate{
    
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
       
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}
extension String {

    func isEmptyOrWhitespace() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
extension UIStoryboard {
    func visitors() -> UIStoryboard {
        return UIStoryboard(name: "Visitors", bundle: nil)
    }
    func mainStory() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    func login() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
  
}
enum MediaType{
    case camera
    case gallery
    case fileExplore
}


//MARK: swift 5 navigation pop on specific class
extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
