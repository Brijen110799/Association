//
//  SOSVC.swift
//  Finca
//
//  Created by anjali on 10/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
//import OpalImagePicker
import Photos

struct ResponseSosEvent  :Codable {
    let status : String!//" : "200"
    let message : String!//" : "Events get success.",
    var sos_event : [SOSEventModel]!
    
}

struct SOSEventModel : Codable {
    let event_name : String!//" : "Fire",
    let sos_event_id : String!//" : "16",
    let event_type : String!//" : "",
    let event_status : String!//" : "0",
    let sos_for : String!//" : "1"
    let sos_image : String!  //.fincasys.com\/img\/sos\/Animal Threat_1566561489.png",
    
}

class SOSVC: BaseVC {
    
    @IBOutlet weak var lbGatekeeper:UILabel!
    @IBOutlet weak var lbSociety:UILabel!
    @IBOutlet weak var viewOfQuickSOS: UIView!
    @IBOutlet weak var viewOfHelp: UIView!
    @IBOutlet weak var constraintCVheight: NSLayoutConstraint!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    
    
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var UploadImageView: UIView!
    @IBOutlet weak var btnUploadImageView: UIButton!
    @IBOutlet weak var tfMsg: ACFloatingTextfield!
    
    @IBOutlet weak var btnSOS: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbQuickSoS: UILabel!
    @IBOutlet weak var lbRequestHelp: UILabel!
    @IBOutlet weak var lbFamily: UILabel!
    @IBOutlet weak var lbGateKeeper: UILabel!
    @IBOutlet weak var lbResident: UILabel!
    @IBOutlet weak var lbCommittee: UILabel!
    @IBOutlet weak var lbSosAll: UILabel!
    var youtubeVideoID = ""
    //@IBOutlet weak var bSendSoS: UIButton!
    @IBOutlet weak var VwVideo:UIView!
    
    // @IBOutlet weak var lbTitleEvent: UILabel!
    // @IBOutlet weak var viewMainPicker: UIView!
    var sos_event = [SOSEventModel]()
    var sos_for = ""
    var sos_title = ""
    var sos_image = ""
    
    // @IBOutlet weak var pickerView: UIPickerView!
    var isSendSos = false
    let itemCell = "SosCell"
    var addNewCustomSOS = ""
    var fileUrl : URL!
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    var menuTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetEvent()
        //hideKeyBoardHideOutSideTouch()
        tfMsg.delegate = self
        
        imgUpload.isUserInteractionEnabled = true
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        setThreeCorner(viewMain: btnUploadImageView)
        setThreeCorner(viewMain: UploadImageView)
        btnSOS.backgroundColor = #colorLiteral(red: 1, green: 0.06214447076, blue: 0.04067560499, alpha: 0.1)
        btnSOS.isEnabled = false
        tfMsg.addTarget(self, action: #selector(doFilterArray(_: )), for: .editingChanged )
        lbTitle.text = menuTitle
        setupUI()
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    @objc func doFilterArray(_ sender : UITextField){
        print("filter")
        if tfMsg.text != "" && sosSelectionType != ""{
            self.btnSOS.isEnabled = true
            self.btnSOS.backgroundColor = UIColor(named: "red_500")
    
        }else{
            self.btnSOS.isEnabled = false
            self.btnSOS.backgroundColor = #colorLiteral(red: 1, green: 0.06214447076, blue: 0.04067560499, alpha: 0.1)

            }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onClickUploadImage(_ sender: Any) {
        showAttachmentDialog(msg: doGetValueLanguage(forKey: "upload_photo"))
    }
    override func tapOpenMedia(type: MediaType) {
        if type == .camera {
            if !self.checkPerCamerPermision() {
                return
            }
            self.openCamera()
        }
        if type == .gallery {
            self.openGallery()
        }
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func checkPerCamerPermision() -> Bool{
          var isAccess = true
          if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
              //already authorized
              print("already authorized")
          } else {
              isAccess = false
              AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                  if granted {
                      //access allowed
                       print("access allowed")
                  } else {
                      //access denied
                       print("access denied")
                      
                      DispatchQueue.main.async {
                           self.openPermision()
                      }
                     
                      
                      
                  }
              })
          }
          
          return isAccess
      }
    func openPermision() {
        let ac = UIAlertController(title: "", message: "Please access your camera permission", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default)
        {
            (result : UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default)
        {
            (result : UIAlertAction) -> Void in
            ac.dismiss(animated: true, completion: nil)
        })
        present(ac, animated: true)
    }
    func shoImagePicker() {
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        //Change color of image tint to black
        imagePicker.selectionImageTintColor = UIColor.black
        //Change status bar style
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        //Limit maximum allowed selections to 5
        //    imagePicker.maximumSelectionsAllowed = 10
        //Only allow image media type assets
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        //imagePicker.imagePickerDelegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    @IBAction func onClickSOSToSecurity(_ sender: Any) {
        
        if tfMsg.text == "" && sosSelectionType == ""{
            self.btnSOS.isEnabled = false
            self.btnSOS.backgroundColor = #colorLiteral(red: 1, green: 0.06214447076, blue: 0.04067560499, alpha: 0.1)
            
            toast(message: "Add Message", type: .Faliure)
        } else{
            self.btnSOS.isEnabled = true
            self.btnSOS.backgroundColor = UIColor(named: "red_500")
            sosFunctionBridge()
        }
        self.fetchNewDataOnRefresh()
    }
    
      
    func doGetEvent() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getPreDefineSOSList":"getPreDefineSOSList",
                      "society_id":doGetLocalDataUser().societyID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.sos_event.append(contentsOf: response.sos_event)
                        self.cvData.reloadData()
                        
                        //   self.sos_for = self.sos_event[0].sos_for
                        
                    }else {
                       // self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    @IBOutlet weak var viewSocietySOS: UIView!
    @IBOutlet weak var viewGatekeeperSOS: UIView!
    @IBOutlet weak var viewFamilySOS: UIView!
    @IBOutlet weak var viewComitteeSOS: UIView!
    @IBOutlet weak var viewAllSOS: UIView!
    var sosSelectionType = ""
    
    @IBAction func btnSosSelectorClicked(_ sender: UIButton) {
        
        switch (sender.tag) {
        case 1:
            self.changeViewBorderColor(borderColor: UIColor(named: "red_500"), view: viewSocietySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewGatekeeperSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewFamilySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewComitteeSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewAllSOS)
            sosSelectionType = "1"
            
            break;
        case 2:
            self.changeViewBorderColor(borderColor: UIColor(named: "red_500"), view: viewGatekeeperSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewSocietySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewFamilySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewComitteeSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewAllSOS)
            sosSelectionType = "2"
            break;
        case 3:
            self.changeViewBorderColor(borderColor: UIColor(named: "red_500"), view: viewComitteeSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewGatekeeperSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewFamilySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewSocietySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewAllSOS)
            sosSelectionType = "3"
            break;
        case 4:
            self.changeViewBorderColor(borderColor: UIColor(named: "red_500"), view: viewFamilySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewGatekeeperSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewSocietySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewComitteeSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewAllSOS)
            sosSelectionType = "4"
            break;
        case 5:
            self.changeViewBorderColor(borderColor: UIColor(named: "red_500"), view: viewAllSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewGatekeeperSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewFamilySOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewComitteeSOS)
            self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: viewSocietySOS)
            sosSelectionType = "5"
            // all
            break;
        default:
            break;
        }
        if tfMsg.text != "" && sosSelectionType != ""{
            self.btnSOS.isEnabled = true
            self.btnSOS.backgroundColor = UIColor(named: "red_500")
            return
        }else{
            self.btnSOS.isEnabled = false
            self.btnSOS.backgroundColor = #colorLiteral(red: 1, green: 0.06214447076, blue: 0.04067560499, alpha: 0.1)
            return
        }
        
    }
    
    func changeViewBorderColor(borderColor:UIColor! , view : UIView!){
        view.borderColor = borderColor
    }
    
    func sosFunctionBridge(){
        if sosSelectionType == ""{
            showAlertMessage(title: "", msg: "Please select a Group to send SOS")
            return
        }else if sosSelectionType == "5"{
            let array = ["3","2","1"]
            for item in array{
                addSosGaurd(selection: item)
                
            }
        }else{
            addSosGaurd(selection: sosSelectionType)
        }
    }
    
    func addSosGaurd(selection:String!) {
        self.showProgress()
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = format.string(from: date)
        let formatT = DateFormatter()
        formatT.dateFormat = "HH:mm:ss"
        let formattedTime = formatT.string(from: date)
        let sos_unit = doGetLocalDataUser().blockName + "-" + doGetLocalDataUser().unitName
        let params = ["key":apiKey(),
                      "sentSOSToGaurd":"sentSOSToGaurd",
                      "society_id":doGetLocalDataUser().societyID!,
                      "sos_title":tfMsg.text!,
                      "sos_type":"1",
                      "sos_status":"1",
                      "sos_unit":sos_unit,
                      "sos_by":doGetLocalDataUser().userFirstName!,
                      "time":formattedTime,
                      "otime":formattedDate,
                      "sos_for":selection!,
                      "sos_image":sos_image,
                      "minimumMin": "",
                      "sos_latitude": "",
                      "sos_longitude": "",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_name":doGetLocalDataUser().society_name!,
                      "unit_id":doGetLocalDataUser().unitID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        if fileUrl == nil{
        requrest.requestPost(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                       
                        //self.tfMsg.text = ""
                       // self.sosSelectionType = ""
                        self.resetData()
                        self.toast(message: response.message, type: .Success)
                        
                    }else {
                        
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        } else {
            if fileUrl != nil {
                print("image upload")
                requrest.requestPostMultipartDocument(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params, fileURL:fileUrl, fileParam: "sos_image_upload", compression: 0) { (Data, Err) in
                    if Data != nil {
                        self.hideProgress()
                        print(Data as Any)
                        do {
                            
                            let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                            if response.status == "200" {
                                self.resetData()
                                self.toast(message: response.message, type: .Success)
                             //   self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                               // self.doPopBAck()
                            }else {
                                self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                            }
                            print(Data as Any)
                        } catch {
                            print("parse error")
                        }
                    }
                }
            }
        }
    }
    func resetData() {
        self.fileUrl = nil
        self.imgUpload.image = UIImage(named: "banner_placeholder")
        self.btnSOS.isEnabled = false
        self.btnSOS.backgroundColor = #colorLiteral(red: 1, green: 0.06214447076, blue: 0.04067560499, alpha: 0.1)
        self.tfMsg.text = ""
        self.sosSelectionType = ""
        self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: self.viewComitteeSOS)
        self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: self.viewGatekeeperSOS)
        self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: self.viewFamilySOS)
        self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: self.viewSocietySOS)
        self.changeViewBorderColor(borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view: self.viewAllSOS)
        
        
    }
    func addImage(selection:String!) {
//        var imageData : UIImage? = nil
//               if UIImage(named: "newphoto")?.cgImage != imgUpload.image?.cgImage{
//                   imageData = imgUpload.image
//        }
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate = format.string(from: date)
            let formatT = DateFormatter()
            formatT.dateFormat = "HH:mm:ss"
            let formattedTime = formatT.string(from: date)
            let sos_unit = doGetLocalDataUser().blockName + "-" + doGetLocalDataUser().unitName
            let params = ["key":apiKey(),
                          "addNewCustomSOS":"addNewCustomSOS",
                          "society_id":doGetLocalDataUser().societyID!,
                          "sos_title":tfMsg.text!,
                          "sos_type":"1",
                          "sos_status":"1",
                          "sos_unit":sos_unit,
                          "sos_by":doGetLocalDataUser().userFirstName!,
                          "sos_image":sos_image,
                          "time":formattedTime,
                          "otime":formattedDate,
                          "sos_for":selection!,
                          "minimumMin":"10",
                          "sos_latitude":"",
                          "sos_longitude":"",
                          "user_id":doGetLocalDataUser().userID!,
                          "society_name":doGetLocalDataUser().society_name!,
                          "unit_id":doGetLocalDataUser().unitID!]
            
            
            print("param" , params)
            
            let requrest = AlamofireSingleTon.sharedInstance
            
            if fileUrl == nil{
            requrest.requestPost(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params) { (json, error) in
                
                if json != nil {
    //                self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                        
                        
                        if response.status == "200" {
                            
                            self.tfMsg.text = ""
                            self.toast(message: response.message, type: .Success)
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
            else if fileUrl != nil {
                print("image upload")
                requrest.requestPostMultipartDocument(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params, fileURL:fileUrl, fileParam: "imgUpload", compression: 0) { (Data, Err) in
                    if Data != nil {
                        self.hideProgress()
                        print(Data as Any)
                        do {
                            
                            let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                            if response.status == "200" {
                                
                                self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                                self.doPopBAck()
                            }else {
                                self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                            }
                            print(Data as Any)
                        } catch {
                            print("parse error")
                        }
                    }
                }
            }
        }
    
    @IBAction func btnSideMenuClickde(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    func addSosEvent(sos_title:String , addNewCustomSOS : String , isProgress: Bool) {
      
        if isProgress {
            showProgress()
                  
        }
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = format.string(from: date)
        // print("date " , formattedDate)
        
        let formatT = DateFormatter()
        formatT.dateFormat = "HH:mm:ss"
        let formattedTime = formatT.string(from: date)
        // print("date " , formattedTime)
        
        let sos_unit = doGetLocalDataUser().blockName + "-" + doGetLocalDataUser().unitName
        let params = ["key":apiKey(),
                      "addNewCustomSOS":addNewCustomSOS,
                      "society_id":doGetLocalDataUser().societyID!,
                      "sos_title":sos_title,
                      "sos_type":"1",
                      "sos_status":"1",
                      "sos_for":sos_for,
                      "sos_image":sos_image,
                      "sos_by":doGetLocalDataUser().userFullName!,
                      "time":formattedTime,
                      "sos_unit":sos_unit,
                      "otime":formattedDate,
                      "society_name":doGetLocalDataUser().society_name!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        if fileUrl == nil{

        requrest.requestPost(serviceName: ServiceNameConstants.resident_sos_controller, parameters: params) { (json, error) in
            if  isProgress {
                self.hideProgress()
                
            }
            if json != nil {
                
                  do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.tfMsg.text = ""
                        self.toast(message: response.message, type: .Success)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        }else{
                
        }
    }
    
    
    @IBAction func onClickNotification(_ sender: Any) {
    //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
    //        self.navigationController?.pushViewController(vc, animated: true)
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
                self.toast(message: "No Tutorial Available!!", type: .Warning)
            }
         
            
        }
    
    @IBAction func onClickChat(_ sender: Any) {
        /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
        
    }
    
    func setupUI() {
        btnSOS.setTitle(doGetValueLanguage(forKey: "send_sos"), for: .normal)
       
        lbQuickSoS.text = doGetValueLanguage(forKey: "send_quick_sos")
        lbRequestHelp.text = doGetValueLanguage(forKey: "request_for_help")
        lbFamily.text = doGetValueLanguage(forKey: "family")
        lbGateKeeper.text = doGetValueLanguage(forKey: "gate_keeper")
        lbResident.text = doGetValueLanguage(forKey: "resident")
        lbCommittee.text = doGetValueLanguage(forKey: "committee")
        lbSosAll.text = doGetValueLanguage(forKey: "sos_all")
        tfMsg.placeholder = doGetValueLanguage(forKey: "add_message")
        
        
        
    }
    
}
extension SOSVC: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sos_event.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return sos_event[row].event_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //  self.lbTitleEvent.text = self.sos_event[row].event_name
        self.sos_for = self.sos_event[row].sos_for
        //    self.city_id = self.cities[row].city_id
    }
    
    override func viewDidLayoutSubviews() {
        if isSendSos {
            isSendSos = false
            
            
            if sos_for == "0" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "user" , isProgress: true)
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "admin",isProgress: false)
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "emp",isProgress: false)
                
                
            } else  if sos_for == "1" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "user", isProgress: true)
                                      
            } else  if sos_for == "2" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "emp", isProgress: true)
                          
            }else  if sos_for == "3" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "admin", isProgress: true)
                             
            }else  if sos_for == "4" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "admin", isProgress: true)
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "emp", isProgress: false)
                
            }else  if sos_for == "5" {
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "admin", isProgress: true)
                addSosEvent(sos_title: sos_title , addNewCustomSOS: "user", isProgress: false)
                
            }
            
              
        }
    }
    
    override func viewWillLayoutSubviews() {
        print(cvData.contentSize.height)
        self.constraintCVheight.constant =  cvData.collectionViewLayout.collectionViewContentSize.height
    }
    
}
extension SOSVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sos_event.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! SosCell
        
        DispatchQueue.main.async {
                  
                   self.viewOfQuickSOS.clipsToBounds = true
                   self.viewOfQuickSOS.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
                   
                   self.viewOfHelp.clipsToBounds = true
                   self.viewOfHelp.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
               }
        cell.lbTitle.text = sos_event[indexPath.row].event_name.uppercased()
        
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: sos_event[indexPath.row].sos_image, palceHolder: "fincasys_notext")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width / 3
        return CGSize(width: yourWidth - 5, height: yourWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// .  print("tetet")
    
        sos_title = sos_event[indexPath.row].event_name
        sos_for = sos_event[indexPath.row].sos_for
        sos_image =   sos_event[indexPath.row].sos_image
        
       // addNewCustomSOS = sos_for
        
       // showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure want to send SOS?", style: .Info,"YES" , "No")
        
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_you_want_to_send_SOS"), style: .Info,  cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "send"))
        
        
      /*  let vc = storyboard?.instantiateViewController(withIdentifier: "idDailogSureVC") as! DailogSureVC
        vc.sosTitle = sos_event[indexPath.row].event_name.uppercased()
        vc.vc = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //     print("gdjsgdsd")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
}

extension SOSVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Info{
          //  isShowAddTenetDailog = true
          
            self.dismiss(animated: true, completion : {
                self.isSendSos = true
                self.viewDidLayoutSubviews()
            })
        }
    }
}
//extension SOSVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        picker.dismiss(animated: true, completion: nil)
//        print("Upload Image")
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            print("Image not found!")
//            return
//        }
//        imgUpload.image = selectedImage
//
//        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
//
//            let imgName = UUID().uuidString + ".jpeg"
//            let documentDirectory = NSTemporaryDirectory()
//            let localPath = documentDirectory.appending(imgName)
//
//            let data = selectedImage.jpegData(compressionQuality: 0)! as NSData
//            data.write(toFile: localPath, atomically: true)
//            let imageURL = URL.init(fileURLWithPath: localPath)
//            self.fileUrl = imageURL
//
//        }else{
//            let imageURL = info[.imageURL] as! URL
//            self.fileUrl = imageURL
//
//        }
//    }
//}

extension SOSVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)

        if let img = info[.editedImage] as? UIImage
        {
            let fixOrientationImage = img.fixOrientation()
            imgUpload.image = fixOrientationImage
            
            
        }else if let img = info[.originalImage] as? UIImage
        {
            //image = img
            let fixOrientationImage = img.fixOrientation()
            imgUpload.image = fixOrientationImage
            
        }
        let imgName = UUID().uuidString + ".jpeg"
                        let documentDirectory = NSTemporaryDirectory()
                        let localPath = documentDirectory.appending(imgName)
                        
        let data = imgUpload.image!.jpegData(compressionQuality: 0)! as NSData
                        data.write(toFile: localPath, atomically: true)
                        let imageURL = URL.init(fileURLWithPath: localPath)
                        self.fileUrl = imageURL
       // print(fileUrl)
       picker.dismiss(animated: true, completion: nil)

    
}

}
