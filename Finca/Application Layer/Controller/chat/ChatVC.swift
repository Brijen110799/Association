//
//  ChatVC.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//
//msg status 0 > single
//or else
import UIKit
import FittedSheets
import Contacts
import ContactsUI
import iRecordView
import AVFoundation
import AVKit

struct ResponseChat : Codable {
    let status:String!// "status" : "200",
    let message:String!// "message" : "Get chat success."
    let block_status : String!
    let chat:[ChatModel]!
}

struct ChatModel : Codable {

    let msg_by  :String! //": "936",
    let isDate  :Bool! //": false,
    let chat_id  :String! //": "190",
    let my_msg  :String! //": "0",
    let msg_delete  :String! //": "0",
    let msg_for  :String! //": "1015",
    let msg_date_view  :String! //": "14 Mar 2020",
    let society_id  :String! //": "75",
    let msg_date  :String! //": "03:48 PM",
    var msg_status  :String! //": "1",
    let msg_data  :String! //": "g"
    var isReadMore : Bool!
    var isShowReadMore : Bool!
    var msg_type:String! //" : "0",
    var msg_img:String! //" : "0",
    var file_original_name:String! //" : "0",
    var file_size:String! //" : "0",
    var location_lat_long:String!
    var file_duration:String!
    var isPlayAudio : Bool! = false
    var duration : String!
    var currentTime : String!
    var isShowDelete : Bool!
}

struct ResponseCommonMessage:Codable {
    let message:String!//"message" : "chat added success.",
    let status:String!// "status" : "200"
    let image_array : [String]!
}

struct ResponseEmoji : Codable {
    let emoji_category : [EmojiCategory]!
}

struct EmojiCategory : Codable{
    let slug : String! //": "grinning-face",
    let character : String! //": "😀",
    let unicodeName : String! //": "grinning face",
    let codePoint : String! //": "1F600",
    let group : String! //": "smileys-emotion",
    let subGroup : String! //": "face-smiling"
}

struct CustomEmojiData : Codable{
    let title : String
    let emoji_category : [EmojiCategory]!
    
}

class ChatVC : BaseVC , UIGestureRecognizerDelegate ,UITextViewDelegate {
    
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var lblblockIndentifier: UILabel!
    @IBOutlet weak var btnAdditionalSettings: UIButton!
    
    @IBOutlet weak var bottomConstEditView: NSLayoutConstraint!
   // @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    
    @IBOutlet weak var tfMessage: UITextView!
    @IBOutlet weak var viewChatMain: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var widthContrainCall: NSLayoutConstraint!
    
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var ivAttach: UIImageView!
    @IBOutlet weak var heigthConTextview: NSLayoutConstraint!
    

    @IBOutlet weak var bRecordingView: RecordButton!
    @IBOutlet weak var viewMsgBox: UIView!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var viewMic: UIView!
    @IBOutlet weak var viewRecoed: UIView!
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var bAttach: UIButton!
    @IBOutlet weak var viewToolbarDelete: UIView!
    @IBOutlet weak var lbDeletCount: UILabel!
    @IBOutlet weak var viewAttach: UIView!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var bBlock: UIButton!

    
    var isUserBlocked : String!
    var itemCellRecieved = "RecievedCell"
    var itemCellSend = "SendChatCell"
    var itemCellDate = "DateFormChat"
    var itemCellRecievedMultimedia = "RecievedMultimediaCell"
    var itemCellSendMultimedia = "SendMultimediaCell"
    var itemCellRecievedContactCell = "RecievedContactCell"
    var itemCellSendContactCell = "SendContactCell"
    var itemCellRecievedDocumentCell = "RecievedDocumentCell"
    var itemCellSendDocumentCell = "SendDocumentCell"
    var itemCellRecievedLocationCell = "RecievedLocationCell"
    var itemCellSendLocationCell = "SendLocationCell"
    var itemCellSendAudioCell = "SendAudioCell"
    var itemCellRecievedAudioCell = "RecievedAudioCell"
    
    var itemCellSentVideoCell = "SentVideoChatCell"
    var itemCellReceivedVideoCell = "ReceivedVideoChatCell"
    var unitsModelMember:UnitModelMember!
    var chats = [ChatModel]()
    var isFirsttime = true
    // var memberDetailModal: MemberDetailModal!
    
    var isGateKeeper:Bool!
    var userid:String!
    var name:String!
    var profile:String!
    var  params = [String:String]()
    
    var user_id:String!
    var userFullName : String!
    var user_image : String!
    
    var public_mobile : String!
    var mobileNumber  = ""
    let hint = "Type Here"
    //  var dictionaryData = [String : [EmojiCategory]]()
  
    var heightKey = 0.0
  
    var chat_id_reply = "0"

    var fileURlAudio : URL!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isRecording = false
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var audio_duration  = 0
    var playIndex = -1
    // audio recording
    let micOn = UIImage(named: "mic_on")
    let micOff = UIImage(named: "mic_off")
    @IBOutlet weak var imgAudioRecorder: UIImageView!
    @IBOutlet weak var viewRecordMic: UIView!
    @IBOutlet weak var viewCancelRecording: UIView!
    @IBOutlet weak var viewRecordTimer: UIView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var sendActionStackView: UIStackView!
    let documentInteractionController = UIDocumentInteractionController()
    @IBOutlet weak var lblRecordedTime: UILabel!
    var timer = Timer()

    var playerController : AVPlayerViewController!
    var isSelectChat = false
    var deleteCount = 0
    
    let unit_name : String! = nil
    let corner = CGFloat(20)
    var blockStatu =  "Block"
    var isComeFcm =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentInteractionController.delegate = self
        // Do any additional setup after loading the view.
        // changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        //        self.tfMessage.edit
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 110
        tbvData.rowHeight = UITableView.automaticDimension
        
        tbvData.sectionIndexBackgroundColor = UIColor.clear
        let inb = UINib(nibName: itemCellSend, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCellSend)
        let inbRecieved = UINib(nibName: itemCellRecieved, bundle: nil)
        tbvData.register(inbRecieved, forCellReuseIdentifier: itemCellRecieved)
        let nib = UINib(nibName: itemCellDate, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCellDate)
     //   Utils.setRoundImage(imageView: ivProfile)
        
        let inbRecievedMultimedia = UINib(nibName: itemCellRecievedMultimedia, bundle: nil)
        tbvData.register(inbRecievedMultimedia, forCellReuseIdentifier: itemCellRecievedMultimedia)
        
        let inbSendMultimedia = UINib(nibName: itemCellSendMultimedia, bundle: nil)
        tbvData.register(inbSendMultimedia, forCellReuseIdentifier: itemCellSendMultimedia)

        let inbRecievedContactCell = UINib(nibName: itemCellRecievedContactCell, bundle: nil)
        tbvData.register(inbRecievedContactCell, forCellReuseIdentifier: itemCellRecievedContactCell)
        
        let nibSendContactCell = UINib(nibName: itemCellSendContactCell, bundle: nil)
        tbvData.register(nibSendContactCell, forCellReuseIdentifier: itemCellSendContactCell)
        
        let nibRecievedDocumentCell = UINib(nibName: itemCellRecievedDocumentCell, bundle: nil)
        tbvData.register(nibRecievedDocumentCell, forCellReuseIdentifier: itemCellRecievedDocumentCell)
        
        let nibSendDocumentCell = UINib(nibName: itemCellSendDocumentCell, bundle: nil)
        tbvData.register(nibSendDocumentCell, forCellReuseIdentifier: itemCellSendDocumentCell)
        
        let nibRecievedLocationCell = UINib(nibName: itemCellRecievedLocationCell, bundle: nil)
        tbvData.register(nibRecievedLocationCell, forCellReuseIdentifier: itemCellRecievedLocationCell)
        
        let nibSendLocationCell = UINib(nibName: itemCellSendLocationCell, bundle: nil)
        tbvData.register(nibSendLocationCell, forCellReuseIdentifier: itemCellSendLocationCell)
        
        let nibSendAudioCell = UINib(nibName: itemCellSendAudioCell, bundle: nil)
        tbvData.register(nibSendAudioCell, forCellReuseIdentifier: itemCellSendAudioCell)
        
        let nibRecievedAudioCell = UINib(nibName: itemCellRecievedAudioCell, bundle: nil)
        tbvData.register(nibRecievedAudioCell, forCellReuseIdentifier: itemCellRecievedAudioCell)

        let nibReceivedVideo = UINib(nibName: itemCellReceivedVideoCell, bundle: nil)
        tbvData.register(nibReceivedVideo, forCellReuseIdentifier: itemCellReceivedVideoCell)

        let nibSentVideo = UINib(nibName: itemCellSentVideoCell, bundle: nil)
        tbvData.register(nibSentVideo, forCellReuseIdentifier: itemCellSentVideoCell)
      
        lbNoData.isHidden = true
        doGetChat(isRefresh: false, isRead: "1")
        //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //   hideKeyBoardHideOutSideTouch()
        // tfMessage.delegate = self
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        tbvData.addSubview(refreshControl)
        
        
        initUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: .chatMsgReceived, object: nil)
        
        
//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
//        longPressGesture.minimumPressDuration = 1.0 // 1 second press
//        longPressGesture.delegate = self
//        self.tbvData.addGestureRecognizer(longPressGesture)
        
        tfMessage.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
        tbvData.keyboardDismissMode = .interactive
        tfMessage.delegate = self
        tfMessage.text = hint
        tfMessage.textColor = .lightGray
        tfMessage.placeholder = doGetValueLanguage(forKey: "type_here")
       // ivAttach.transform = CGAffineTransform(rotationAngle: CGFloat(-45))
      
        tbvData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressD))
        tbvData.addGestureRecognizer(longPress)
        
        bBlock.setTitle(blockStatu, for: .normal)
        
        
    }
    @objc func handleLongPressD(sender: UILongPressGestureRecognizer){
        print("dddd ")
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tbvData)
            if let indexPath = tbvData.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                if !chats[indexPath.row].isDate && chats[indexPath.row].my_msg != "0" {
                    isSelectChat = true
                    deleteCount += 1
                    lbDeletCount.text = "\(deleteCount)"
                    viewToolbarDelete.isHidden = false
                    if chats[indexPath.row].isShowDelete == nil {
                        chats[indexPath.row].isShowDelete = false
                    }
                    
                    if chats[indexPath.row].isShowDelete {
                        chats[indexPath.row].isShowDelete = false
                    } else {
                        chats[indexPath.row].isShowDelete = true
                    }
                    //self.tbvData.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    self.tbvData.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.viewRecordTimer.isHidden = true
            self.viewCancelRecording.isHidden = true
            self.sendActionStackView.layoutIfNeeded()
        }
        self.finishAudioRecording(success: true,postMessage:false)
        self.fileURlAudio = nil
        btnRecord.tag = 0
    }

    @IBAction func btnRecordClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            //record audio
            btnRecord.tag = 1
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.viewRecordTimer.isHidden = false
                self.viewCancelRecording.isHidden = false
                self.sendActionStackView.layoutIfNeeded()
            }
            self.setup_recorder()

            break
        case 1:
            //stop and send audio
            btnRecord.tag = 0
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.viewRecordTimer.isHidden = true
                self.viewCancelRecording.isHidden = true
                self.sendActionStackView.layoutIfNeeded()
            }
            self.finishAudioRecording(success: true)

            break
        default:
            break
        }
    }

    @objc func updateAudioMeter(timer: Timer)
    {
        if checkMicroPhonePermssion() {
            if audioRecorder.isRecording
            {
                //  let totalTimeString = String(format: "%02d:",Double(audioRecorder.currentTime))

                // print("durtion = ," , durtion)
                //  print("dicucuc = " , audioRecorder.currentTime)
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d",min, sec)
                self.lblRecordedTime.text = totalTimeString
                audioRecorder.updateMeters()
            } else {
                // print("is stop ")
                finishAudioRecording(success: true)
            }
        }

    }

    func finishAudioRecording(success: Bool,postMessage: Bool! = true)
    {
        if success
        {
            self.imgAudioRecorder.setImageWithTint(ImageName: "mic_on", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            isRecording = false
            audioRecorder.stop()
            audioRecorder = nil
            let array  =  [fileURlAudio!]
            if postMessage{
                let durationLabel = "\(lblRecordedTime.text!)"
                doUploadDocument(fileArray: array, type: StringConstants.MSG_TYPE_AUDIO, file_duration: durationLabel)
            }else{
                // canceled recording
            }
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            self.showAlertMessage(title: doGetValueLanguage(forKey: "error"), msg: "Recording Failed")
        }
    }

    func setup_recorder(){
        if checkMicroPhonePermssion(){
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]
                let url = getFileUrl()
                audioRecorder = try AVAudioRecorder(url:url , settings: settings)
                self.fileURlAudio = url
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true

                audioRecorder.record()
                audioRecorder.prepareToRecord()


                self.imgAudioRecorder.setImageWithTint(ImageName: "mic_off", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                if checkMicroPhonePermssion() {
                    if audioRecorder != nil{
                        audioRecorder.record()
                    }else{
                        self.showAlertMessage(title: "Alert!!", msg: "The Microphone is Occupied by Other Application Please Try Again!!")
                    }

                }
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self,  selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                //            record_btn_ref.setTitle("Stop", for: .normal)
                //            play_btn_ref.isEnabled = false
                isRecording = true
            }catch let error {
                print(error as Any)
                self.showAlertMessage(title: "Alert !!", msg: "Microphone is currently occupied by another application. Please Try Later!!")
            }
        }

    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
//        dismissKeyboard(sender)
//        viewEmoji.isHidden = true
//        conHeightEmoji.constant = CGFloat(0)
        if sender.state == .ended {
            dismissKeyboard(sender)
            viewBlock.isHidden = true
        }
        sender.cancelsTouchesInView = false
    }

   
    
    func addREcoedView() {
        bRecordingView.recordView = recordView
        recordView.delegate = self
    }

    @IBAction func btnOpenProfile(_ sender: UIButton) {
        if !isGateKeeper {
            
            
//            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//            vc.user_id = user_id
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = MemberDetailsVC()
            vc.user_id = user_id
            vc.userName =  ""
            pushVC(vc: vc)
            
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//            vc.user_id = user_id!
//            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            toast(message: "No User found..!", type: .Success)
        }
        
    }

    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer) {
        // if gestureRecognizer.state == .ended {
        let touchPoint = gestureRecognizer.location(in: self.tbvData)
        if let indexPath = tbvData.indexPathForRow(at: touchPoint) {
            // print()
            
            let index = indexPath.row
            if chats[index].my_msg == "1" {
                let alert = UIAlertController(title: "", message:doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "yes"), style: .destructive, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    self.doDelete(chatId: self.chats[index].chat_id)
                }))
                alert.addAction(UIAlertAction(title: doGetValueLanguage(forKey: "no"), style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
            
        }
        // }
    }
    
    func doDelete (chatId:String) {
        let  paramsSend = ["key":apiKey(),
                           "getdelChat":"getdelChat",
                           "chat_id":chatId]
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chat_delete_controller, parameters: paramsSend) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        //  self.tfMessage.text = ""
                        self.doGetChat(isRefresh: false, isRead: "0")
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    @objc func doThisWhenNotify(notif: NSNotification) {
        
        guard
            let _ =  notif.userInfo?["aps"] as? NSDictionary,
            let click_action =  notif.userInfo?["menuClick"] as? String
        else {
            return
        }
        
        //print("chat doThisWhenNotify ")
        // print("chat click a " , click_action)
        // print("click_action" , click_action)
        if click_action == "chatMsg" {
            doGetChat(isRefresh: false, isRead: "2")
        }
        
        
        if click_action == "myMsgRead" {
            if chats.count > 0 {
                for (index,_) in chats.enumerated() {
                    chats[index].msg_status = "1"
                }
                tbvData.reloadData()
            }
        }
       // print("chat click_action " , click_action)
        
    }
    
    private func initUI() {
        if isGateKeeper {
        //    Utils.setImageFromUrl(imageView: ivProfile, urlString: profile, palceHolder: "user_default")
            lbUserName.text = name
            viewCall.isHidden = true
            viewMore.isHidden = true
            viewAttach.isHidden = true
        } else {
            if  public_mobile != "1" {
                viewCall.isHidden = false
                self.widthContrainCall.constant = 40
            } else {
                viewCall.isHidden = true
                self.widthContrainCall.constant = 0
            }
           // Utils.setImageFromUrl(imageView: ivProfile, urlString: user_image, palceHolder: "user_default")
           // Utils.setRoundImage(imageView: ivProfile)
            lbUserName.text = userFullName
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        self.doGetChat(isRefresh: true, isRead: "0")
    }
    
    @IBAction func onClickSendMesage(_ sender: Any) {
        //   print("block status",isUserBlocked)
        if isUserBlocked == "2"{
           /* let alertVC = UIAlertController(title: "User Blocked", message:"Do you want to unblock \(lbUserName.text!)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "Unblock", style: .destructive, handler: { (UIAlertAction) in
              //  self.showActionSheetForSettings()
                self.actionBlockUnblockCLicked(action: "unblock")
            }))
            self.present(alertVC, animated: true, completion: nil)*/
            
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(lbUserName.text ?? "") \(doGetValueLanguage(forKey: "block_chat_msg"))", style: .Info, cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "unblock").uppercased())
        }else if isUserBlocked == "0"{
            if  !tfMessage.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tfMessage.text != "\n"  &&
                tfMessage.text != "\n "  && tfMessage.text != hint  {
                doSendMessage(message:tfMessage.text!,msgType: StringConstants.MSG_TYPE_TEXT,location_lat_long: "")
            }
        }else{
            print("here")
        }
        
    }
    
    func showActionSheetForSettings(){
        let alertVC = UIAlertController(title: nil, message: "Settings", preferredStyle: .actionSheet)
        
        if isUserBlocked == "2"{
            alertVC.addAction(UIAlertAction(title: "Unblock", style: .destructive, handler: { (UIAlertAction) in
                self.actionBlockUnblockCLicked(action: "unblock")
            }))
        }else{
            alertVC.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (UIAlertAction) in
                self.actionBlockUnblockCLicked(action: "block")
            }))
        }
        
        alertVC.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if isComeFcm == "" {
            doPopBAck()
        } else {
            Utils.setHome()
        }
       
    }
    
    func doGetChat(isRefresh:Bool, isRead:String ) {
        
        if isFirsttime {
            showProgress()
        }
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        if isGateKeeper {
            params = ["key":apiKey(),
                      "getPrvChatNew":"getPrvChatNew",
                      "user_id":doGetLocalDataUser().userID!,
                      "userId":userid,
                      "society_id":doGetLocalDataUser().societyID!,
                      "sentTo":"1",
                      "unit_id":doGetLocalDataUser().societyID!,
                      "isRead":isRead]
        } else {
            params = ["key":apiKey(),
                      "getPrvChatNew":"getPrvChatNew",
                      "user_id":doGetLocalDataUser().userID!,
                      "userId":user_id,
                      "society_id":doGetLocalDataUser().societyID!,
                      "sentTo":"0",
                      "unit_id":doGetLocalDataUser().societyID!,
                      "isRead":isRead]
            self.userid = self.user_id
        }
        
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: params) { (json, error) in
            
            if json != nil {
                
                self.hideProgress()
                print(json as Any)
                if isRefresh {
                    self.refreshControl.endRefreshing()
                }
                do {
                    
                    let response = try JSONDecoder().decode(ResponseChat.self, from:json!)
                    self.isUserBlocked = response.block_status
                    
                    if response.status == "200" {
                        self.lbNoData.isHidden = true
                        
                         if self.chats.count > 0 {
                            self.chats.removeAll()
                            //   self.tbvData.reloadData()
                        }
                        
                        self.chats.append(contentsOf: response.chat)
                        self.tbvData.reloadData()
                        self.scrollToBottom()
                        self.isFirsttime = false
                        for (index , _) in self.chats.enumerated() {
                            self.chats[index].isPlayAudio = false
                            self.chats[index].duration = "0.0"
                        }
                        self.doSetDution()
                        self.showAddLine()
                    }else {
                        self.chats.removeAll()
                        self.tbvData.reloadData()
                        self.lbNoData.isHidden = false
                        // self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                    
                    if response.block_status ?? "" == "1"{
                        self.btnSendMessage.isEnabled = false
                        self.bAttach.isEnabled = false
                        self.tfMessage.isEditable = false
                        self.lblblockIndentifier.text = "   \(self.lbUserName.text!) \(self.doGetValueLanguage(forKey: "you_are_block_by"))   "
                        self.btnAdditionalSettings.isEnabled = false
                        self.lblblockIndentifier.isHidden = false
                    }else if response.block_status ?? "" == "2"{
                        self.btnSendMessage.isEnabled = true
                        self.bAttach.isEnabled = true
                        self.tfMessage.isEditable = true
                        self.lblblockIndentifier.text = "   \(self.lbUserName.text!) \(self.doGetValueLanguage(forKey: "block_by_you"))   "
                        self.btnAdditionalSettings.isEnabled = true
                        self.lblblockIndentifier.isHidden = false
                        self.blockStatu = "Unblock"
                        self.bBlock.setTitle(self.blockStatu, for: .normal)
                    }else{
                        self.btnSendMessage.isEnabled = true
                        self.bAttach.isEnabled = true
                        self.tfMessage.isEditable = true
                        self.btnAdditionalSettings.isEnabled = true
                        self.lblblockIndentifier.isHidden = true
                        self.blockStatu = "Block"
                        self.bBlock.setTitle(self.blockStatu, for: .normal)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }

    func showAddLine() {
        for (index,item) in chats.enumerated() {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 18))
            label.text = item.msg_data
            if label.maxNumberOfLines > 6 {
                chats[index].isShowReadMore = true
            } else {
                chats[index].isShowReadMore = false
            }
        }
        tbvData.reloadData()
    }
    
    func doSendMessage(message:String , msgType : String , location_lat_long : String) {
        tfMessage.text = ""
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var   paramsSend  =  [String:String]()
        //let unit_name = "\(doGetLocalDataUser().userFullName!) \n \(doGetLocalDataUser().blockName.uppercased()!)\n \(doGetLocalDataUser().unitName!)"
        let unit_name = "\(doGetLocalDataUser().userFullName!)"
      
        if isGateKeeper {
            print("is gate keeper")
            paramsSend = ["key":apiKey(),
                          "addChat":"addChatNew",
                          "msg_by":doGetLocalDataUser().userID!,
                          "msg_for":userid,
                          "msg_data":message,
                          "unit_name":unit_name,
                          "society_id":doGetLocalDataUser().societyID!,
                          "sent_to":"1",
                          "user_profile":doGetLocalDataUser().userProfilePic!,
                          "user_name":doGetLocalDataUser().userFullName!,
                          "user_mobile":doGetLocalDataUser().userMobile!,
                          "msgType" : msgType,
                          "location_lat_long" : location_lat_long,
                          "public_mobile" : doGetLocalDataUser().publicMobile!]
            
            
            


        }else {
            print("is member")
            paramsSend = ["key":apiKey(),
                          "addChat":"addChatNew",
                          "msg_by":doGetLocalDataUser().userID!,
                          "msg_for":user_id,
                          "msg_data":message,
                          "unit_name":unit_name,
                          "society_id":doGetLocalDataUser().societyID!,
                          "sent_to":"0",
                          "user_profile":doGetLocalDataUser().userProfilePic!,
                          "user_name":doGetLocalDataUser().userFullName!,
                          "user_mobile":doGetLocalDataUser().userMobile!,
                          "msgType" : msgType,
                          "location_lat_long" : location_lat_long,
                          "public_mobile" : doGetLocalDataUser().publicMobile!]
        }
        
        
        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: paramsSend) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        /* self.chats.append(ChatModel(msg_for: "",my_msg: "1",msg_date: "",society_id: "",msg_status: "",msg_by: "",chat_id: "",msg_data: self.tfMessage.text!,msg_delete: ""))
                         self.tbvData.reloadData()
                         self.tfMessage.text = ""
                         self.scrollToBottom()*/
                        self.tfMessage.text = ""
                        self.doGetChat(isRefresh: false, isRead: "0")
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func moveTextField(_textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc  func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        if keyboardHeight > 304 {
            bottomConstEditView.constant = keyboardHeight - 22
        } else {
            bottomConstEditView.constant = keyboardHeight + 10
        }
         /*  UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil)*/
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        scrollToBottom()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        bottomConstEditView.constant = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnShowAdditionalSettingsClicked(_ sender: UIButton) {
        //self.showActionSheetForSettings()
        if viewBlock.isHidden {
            viewBlock.isHidden = false
        } else {
            viewBlock.isHidden = true
        }
    }
    
    func actionBlockUnblockCLicked(action:String!) {
        var params = ["" : ""]
        
        switch (action) {
        case "block":
            params = ["key":apiKey(),
                      "chatBlock":"chatBlock",
                      "block_by":doGetLocalDataUser().userID!,
                      "block_for":self.userid!,
                      "society_id":doGetLocalDataUser().societyID!]
            break;
            
        case "unblock":
            params = ["key":apiKey(),
                      "chatUnBlock":"chatUnBlock",
                      "block_by":doGetLocalDataUser().userID!,
                      "block_for":self.userid!,
                      "society_id":doGetLocalDataUser().societyID!]
            break;
        default:
            break;
        }
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.chatController, parameters: params) { (Data, Error) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.doGetChat(isRefresh: true,isRead: "0")
                    }else{
                        
                    }
                }catch{
                    print(Error as Any)
                }
            }else{
                print(Error as Any)
            }
        }
    }
    
    @IBAction func onClickCallUser(_ sender: Any) {
        let number = mobileNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel:\(number)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        
        if  frame.size.height < 100 {
            if frame.size.height > 30 {
                self.tfMessage.frame = frame
                self.heigthConTextview.constant = frame.size.height
            } else {
                self.heigthConTextview.constant = 26
            }
        }
        
//        if textView.text! == "" {
//
//            viewRecordMic.isHidden = false
//            viewSend.isHidden = true
//        } else {
//            viewRecordMic.isHidden = true
//            viewSend.isHidden = false
//        }
        // print("cxcx" ,  frame.size.height)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == hint {
            print("equoal")
            textView.text = nil
            textView.textColor = UIColor.black
        } else {
            print("not eq")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = hint
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.count > 1 {
            print("paste")
            if text.count > 2000 {
                textView.text = String(text.prefix(2000))
            }
            return textView.text.count + (text.count - range.length) <= 2000
        }
        
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 2000    //  Limit Value
    }

    @IBAction func onClickAttachment(_ sender: Any) {
        if isUserBlocked == "2"{
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(lbUserName.text ?? "") \(doGetValueLanguage(forKey: "block_chat_msg"))", style: .Info, cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "unblock").uppercased())
    
        }else if isUserBlocked == "0"{
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idDailogAttachmentVC")as!
            DailogAttachmentVC
            vc.chatVC = self
            let sheetController = SheetViewController(controller: vc, sizes:[.fixed(250)])
            sheetController.blurBottomSafeArea = false
            sheetController.adjustForBottomSafeArea = false
            sheetController.topCornersRadius = 15
            sheetController.extendBackgroundBehindHandle = false
            sheetController.handleColor = UIColor.white
            self.present(sheetController, animated: false, completion: nil)
        }
    }

    func goToMultimedia(images : [UIImage] , fileImage : [URL]) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idSendMultimediaChatVC") as! SendMultimediaChatVC
        vc.slider = images
        vc.user_id = userid
        vc.fileImage = fileImage
        vc.chatVC = self
        pushVC(vc: vc)
    }
    
  

    func doSetDution() {
        var player:AVPlayer?
        for (index,item) in chats.enumerated() {
            if item.msg_type == "3"{
                if item.msg_img != ""{
                    let url = URL(string: item.msg_img)
                    let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                    player = AVPlayer(playerItem: playerItem)
                    let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)

                    // player.isre
                    chats[index].duration = duratin.stringFromTimeInterval()
                    chats[index].currentTime = "00:00"
                }
            }
        }
        self.tbvData.reloadData()
    }
    
    

    func showContactPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func doSendContact(message:String , msgType : String ) {
        tfMessage.text = ""
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var   paramsSend  =  [String:String]()
//        let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
        let unit_name = "\(doGetLocalDataUser().userFullName!)"
        let public_mobile = doGetLocalDataUser().publicMobile!

        paramsSend = ["addChat":"addChatNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "chat_id_reply":chat_id_reply,
                      "msg_by":doGetLocalDataUser().userID!,
                      "msg_for":user_id,
                      "msg_data":message,
                      "sent_to":"0",
                      "unit_name":unit_name,
                      "user_profile":doGetLocalDataUser().userProfilePic!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? "",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "msgType":msgType,
                      "public_mobile" : public_mobile]

        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: paramsSend) { (json, error) in

            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)


                    if response.status == "200" {
                        self.doGetChat(isRefresh: false, isRead: "0")
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }

    }
    
    func doUploadDocument(fileArray : [URL], type : String ,  file_duration:String) {
        showProgress()
//        let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
        let unit_name = "\(doGetLocalDataUser().userFullName!)"

        // let  user_id = self.user_id
        print("is member")
        let  paramsSend = ["addChatWithDoc":"addChatWithDoc",
                           "society_id":doGetLocalDataUser().societyID!,
                           "msg_by":doGetLocalDataUser().userID!,
                           "msg_for":user_id!,
                           "unit_name":unit_name,
                           "sent_to":"0",
                           "user_profile":doGetLocalDataUser().userProfilePic!,
                           "user_name":doGetLocalDataUser().userFullName!,
                           "block_name":doGetLocalDataUser().company_name ?? "",
                           "user_mobile":doGetLocalDataUser().userMobile!,
                           "public_mobile" : doGetLocalDataUser().publicMobile!,
                           "msgType" : type,
                           "file_duration" : file_duration] as [String : Any]

        // "msg_data[]": msg_data,

        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartWithFileArryaImage(serviceName: ServiceNameConstants.chatController, parameters: paramsSend,  doc_array: fileArray, paramName: "chat_doc[]"  ,compression:  0.3 ) { (json, error) in

            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)


                    if response.status == "200" {
                        self.doGetChat(isRefresh: false, isRead: "0")

                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doSendLocation(address : String , location_lat_long : String ) {

        doSendMessage(message: address, msgType: StringConstants.MSG_TYPE_LOCATION, location_lat_long: location_lat_long)
        
        //for sho location as image

    }

    func doSentVideoChat(FileUrl:URL!){

        let asset = AVAsset(url: FileUrl)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        print(durationTime)
        showProgress()
//        let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
        let unit_name = "\(doGetLocalDataUser().userFullName!)"
        print("is member")
        let  params = ["addChatWithDoc":"addChatWithDoc",
                       "society_id":doGetLocalDataUser().societyID!,
                       "msg_by":doGetLocalDataUser().userID!,
                       "msg_for":user_id!,
                       "unit_name":unit_name,
                       "sent_to":"0",
                       "user_profile":doGetLocalDataUser().userProfilePic!,
                       "user_name":doGetLocalDataUser().userFullName!,
                       "block_name":doGetLocalDataUser().company_name ?? "",
                       "user_mobile":doGetLocalDataUser().userMobile!,
                       "public_mobile" : doGetLocalDataUser().publicMobile!,
                       "msgType" : "6",
                       "file_duration": duration.positionalTime]

        // "msg_data[]": msg_data,

        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartparms(serviceName: ServiceNameConstants.chatController, parameters: params, fileURL: FileUrl, compression: 0, FileName:"chat_doc[]") { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:Data!)
                    if response.status == "200" {
                        self.doGetChat(isRefresh: false, isRead: "0")

                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }

    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        self.showProgress()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.hideProgress()
                self.share(url: tmpURL)
            }
        }.resume()
    }
    
    @IBAction func tapDeleteMessage(_ sender: Any) {
        
        deleteMessage()
        
    }
    @IBAction func taClearDelete(_ sender: Any) {
        resetDeleteView()
    }
    
    func resetDeleteView() {
        isSelectChat = false
        viewToolbarDelete.isHidden = true
        deleteCount = 0
        for (index , _) in chats.enumerated() {
            chats[index].isShowDelete = false
        }
        tbvData.reloadData()
    }
      
    func deleteMessage() {
           var ids = ""
           for item  in  chats {
               if item.isShowDelete != nil &&  item.isShowDelete {
                   if ids == "" {
                       ids = item.chat_id
                   } else {
                       ids = ids + "," + item.chat_id
                   }
               }
           }
           if ids == "" {
               return
           }
           
        showProgress()
        let  params = ["deleteChatMulti":"deleteChatMulti",
                       "user_id" : doGetLocalDataUser().userID!,
                       "society_id" : doGetLocalDataUser().societyID!,
                       "chat_id":ids]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: params) { (json, error) in
               self.hideProgress()
               if json != nil {
                   do {
                       let response = try JSONDecoder().decode(ResponseChat.self, from:json!)
                       
                       if response.status == "200" {
                           self.resetDeleteView()
                           self.doGetChat(isRefresh: true, isRead: "0")
                       }
                   } catch {
                       print("parse error")
                   }
               }else {
                   // print("errr " , error)
               }
           }
       }
    
    @IBAction func tapBlock(_ sender: UIButton) {
      
        viewBlock.isHidden = true
        if isUserBlocked == "2"{
          self.actionBlockUnblockCLicked(action: "unblock")
        }else{
          self.actionBlockUnblockCLicked(action: "block")
        }
    }
    
}
extension ChatVC : CNContactPickerDelegate,CNContactViewControllerDelegate {

    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.dismiss(animated: true, completion: nil)
    }

    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {

    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way

        // user name
        let userName:String = contact.givenName

        // user phone number
        var primaryPhoneNumberStr = ""
        if contact.phoneNumbers.count > 0 {
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
             primaryPhoneNumberStr = firstPhoneNumber.stringValue

        }
        
      

        // user phone number string
       
        let dataS = userName + "@" + primaryPhoneNumberStr
        doSendContact(message: dataS, msgType: StringConstants.MSG_TYPE_CONTACT)

    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }

    func playClicked(_ sender:Int){
        let index = sender
        playIndex = index
        if chats[index].isPlayAudio {
            chats[index].isPlayAudio = false
            player?.pause()
//            if chats[index].my_msg == "0"{
//                let cell : RecievedAudioCell = tbvData.cellForRow(at: IndexPath(row: index, section: 0))  as! RecievedAudioCell
//                cell.imgPlayButton.setImageWithTint(ImageName:  "play.circle.fill", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
//                tbvData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .right)
//            }else{
//                let cell : SendAudioCell = tbvData.cellForRow(at: IndexPath(row: index, section: 0))  as! SendAudioCell
//                cell.imgPlayButton.setImageWithTint(ImageName:  "play.circle.fill", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
//                tbvData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//            }

        } else {
            for (indexInner , _) in self.chats.enumerated() {
                if indexInner != index {
                    self.chats[indexInner].isPlayAudio = false
                }
            }
            chats[index].isPlayAudio = true
            let urlS = chats[index].msg_img!
            let url = URL(string: urlS)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 1
            player?.play()
            //let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown) , userInfo: nil, repeats: true)
        }
        tbvData.reloadData()

    }

    @objc  func countdown() {
        let index = playIndex
        if player?.currentItem?.status == .readyToPlay {

            if chats[playIndex].my_msg == "0"{
                // received
                let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.currentTime())!)
                chats[index].currentTime = duratin.stringFromTimeInterval()
                let cell : RecievedAudioCell = tbvData.cellForRow(at: IndexPath(row: index, section: 0))  as! RecievedAudioCell
                cell.playProgress.minimumValue = 0
                // cell.progressBar.
                let duration : CMTime = (player?.currentItem!.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                cell.playProgress.maximumValue = Float(seconds)
                // cell.progressBar.progress = Float(seconds)
                let durationC : CMTime = (player?.currentItem?.currentTime())!
                let secondsC : Float64 = CMTimeGetSeconds(durationC)
                // cell.progressBar.setProgress(Float(secondsC/100), animated: true)
                cell.playProgress.maximumTrackTintColor = UIColor.black
                cell.playProgress.minimumTrackTintColor = UIColor.white
                cell.playProgress.setValue(Float(secondsC), animated: true)
//                cell.imgPlayButton.setImageWithTint(ImageName:  "stop-button.png", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                tbvData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }else{
                let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.currentTime())!)
                chats[index].currentTime = duratin.stringFromTimeInterval()
                let cell : SendAudioCell = tbvData.cellForRow(at: IndexPath(row: index, section: 0))  as! SendAudioCell
                cell.playProgress.minimumValue = 0
                // cell.progressBar.
                let duration : CMTime = (player?.currentItem!.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                cell.playProgress.maximumValue = Float(seconds)
                // cell.progressBar.progress = Float(seconds)
                let durationC : CMTime = (player?.currentItem?.currentTime())!
                let secondsC : Float64 = CMTimeGetSeconds(durationC)
                // cell.progressBar.setProgress(Float(secondsC/100), animated: true)
                cell.playProgress.minimumTrackTintColor = ColorConstant.colorP
                cell.playProgress.setValue(Float(secondsC), animated: true)
//                cell.imgPlayButton.setImageWithTint(ImageName:  "stop-button.png", TintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                tbvData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}
extension ChatVC:UITableViewDataSource,UITableViewDelegate, ChatClickDelegate, AudioCellDelegate,VideoCellDelegate  {
    @objc func didfinishPlaying(note : NSNotification)  {

        playerController.dismiss(animated: true, completion: nil)
//        let alertView = UIAlertController(title: "Finished", message: "Video finished", preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
//        self.present(alertView, animated: true, completion: nil)
    }

    func playVideo(at indexPath: IndexPath) {
        let data = chats[indexPath.row]
        guard let url = URL(string: data.msg_img) else {
            return
        }
        let player = AVPlayer(url: url as URL)

        playerController = AVPlayerViewController()

        NotificationCenter.default.addObserver(self, selector: #selector(didfinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        playerController.player = player

        playerController.allowsPictureInPicturePlayback = true

        playerController.delegate = self

        playerController.player?.play()

        self.present(playerController, animated: true, completion : nil)
    }

    @objc  func onClickDoc (sender : UIButton) {
        
        let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
        vc.strUrl = chats[sender.tag].msg_img
        vc.isComeFrom = "chat"
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc  func onClickLocation (sender : UIButton) {
        let latLong = chats[sender.tag].location_lat_long.components(separatedBy: ",")
        let lat = latLong[0]
        let lon = latLong[1]
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=\(lat),\(lon)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
            //  UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@\(lat),\(lon),6z")!)

        }
        
    }

    func PlayAudio(at indexPath: IndexPath) {
        self.playClicked(indexPath.row)
        //        let data = chats[indexPath.row]
        //        self.storeAndShare(withURLString: data.msg_img)
    }
    
    func openReadMore(indexPath: IndexPath, type: String) {
        if type == "readmore" {
            if  chats[indexPath.row].isReadMore == nil {
                chats[indexPath.row].isReadMore = true
            }
            
            if  chats[indexPath.row].isReadMore {
                chats[indexPath.row].isReadMore = false
                
            } else {
                chats[indexPath.row].isReadMore = true
                //      self.tbvData.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            
            tbvData.reloadData()
        } else {
            
            let url = chats[indexPath.row].msg_img!
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
            nextVC.imagePath = url
            nextVC.isShowDownload = "true"
            pushVC(vc: nextVC)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chats[indexPath.row].isDate == true{
            let cell = tbvData.dequeueReusableCell(withIdentifier: self.itemCellDate, for: indexPath) as! DateFormChat
            cell.lblDateChange.text = ""
            cell.lbDate.text  = chats[indexPath.row].msg_date_view
            return cell
        }else{
            if chats[indexPath.row].my_msg == "0" {
                //RecievedLocationCell
                if chats[indexPath.row].msg_type == "0" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecieved, for: indexPath) as! RecievedCell
                    cell.backgroundColor = UIColor.clear
                    
                    cell.lbMessage.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.indexPath = indexPath
                    cell.delegate = self
                    if chats[indexPath.row].isShowReadMore != nil && chats[indexPath.row].isShowReadMore {
                        cell.bReadMore.isHidden = false
                        cell.bReadMore.setTitle("Read More", for: .normal)
                        cell.conWidthReadMore.constant = 70
                    } else {
                        cell.bReadMore.isHidden = true
                        cell.bReadMore.setTitle("", for: .normal)
                    }
                    if chats[indexPath.row].isReadMore != nil && chats[indexPath.row].isReadMore {
                        cell.lbMessage.numberOfLines = 0
                        cell.bReadMore.setTitle("Read Less", for: .normal)
                    } else {
                        cell.lbMessage.numberOfLines = 7
                        cell.bReadMore.setTitle("Read More", for: .normal)
                    }
                    // cell.viewMain.roundCorners(corners: [.topLeft , .topRight , .bottomRight], radius: 10)
                    
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    
                    return cell
                }
                else if chats[indexPath.row].msg_type == "1" {
                    
                    // for multimedia
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievedMultimedia, for: indexPath) as! RecievedMultimediaCell
                    cell.backgroundColor = UIColor.clear
                    
                    cell.lbMessage.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.indexPath = indexPath
                    cell.delegate = self
                    if chats[indexPath.row].isShowReadMore != nil && chats[indexPath.row].isShowReadMore {
                        cell.bReadMore.isHidden = false
                        cell.bReadMore.setTitle("Read More", for: .normal)
                        cell.conWidthReadMore.constant = 70
                    } else {
                        cell.bReadMore.isHidden = true
                        cell.bReadMore.setTitle("", for: .normal)
                        
                    }
                    if  chats[indexPath.row].isReadMore != nil && chats[indexPath.row].isReadMore {
                        cell.lbMessage.numberOfLines = 0
                        cell.bReadMore.setTitle("Read Less", for: .normal)
                    } else {
                        cell.lbMessage.numberOfLines = 7
                        cell.bReadMore.setTitle("Read More", for: .normal)
                    }
                    Utils.setImageFromUrl(imageView: cell.ivImage, urlString: chats[indexPath.row].msg_img, palceHolder: "")
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    
                    return cell
                    
                }
                else if chats[indexPath.row].msg_type == "5" {
                    // for contect
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievedContactCell, for: indexPath) as! RecievedContactCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    if  chats[indexPath.row].msg_data != nil &&  chats[indexPath.row].msg_data != "" {
                        let contact = chats[indexPath.row].msg_data.components(separatedBy: "@")
                        if contact.count > 1 {
                            cell.lbName.text = contact[0]
                            cell.lbNumber.text = contact[1]
                            
                        } else {
                            cell.lbName.text = ""
                            cell.lbNumber.text = ""
                        }
                    } else {
                        cell.lbName.text = ""
                        cell.lbNumber.text = ""
                    }

                    cell.bAddContact.tag = indexPath.row
                    cell.bAddContact.addTarget(self, action: #selector(saveCantacts(sender:)), for: .touchUpInside)
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    
                    return cell
                }
                else if chats[indexPath.row].msg_type == "2" {
                    //for documrnt
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievedDocumentCell, for: indexPath) as! RecievedDocumentCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.lbDocName.text = chats[indexPath.row].file_original_name
                    cell.lbDocSize.text = chats[indexPath.row].file_size
                 //   cell.ivDocType.image = goGetDocTypeImage(string: chats[indexPath.row].msg_img)
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    cell.bDownload.tag = indexPath.row
                    cell.bDownload.addTarget(self, action: #selector(onClickDoc(sender:)), for: .touchUpInside)
                    return cell
                    
                }
                else if chats[indexPath.row].msg_type == "4" {
                    //for location
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievedLocationCell, for: indexPath) as! RecievedLocationCell
                    cell.backgroundColor = UIColor.clear
                    
                    cell.lbLocation.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    
                    let latLong = chats[indexPath.row].location_lat_long //.components(separatedBy: ",")
                    // let finalLatitude = latLong[0]
                    // let finalLongitude = latLong[0]
                    let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C"
                        + latLong! + "&key=" + StringConstants.MAP_KEY

                    cell.ivImageLocation.setImage(url: URL(string: mapUrl)!)
                    cell.bLocation.tag = indexPath.row
                    cell.bLocation.addTarget(self, action: #selector(onClickLocation(sender:)), for: .touchUpInside)
                    
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    return cell
                    
                }
                else if chats[indexPath.row].msg_type == "3" {
                    //for location
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievedAudioCell, for: indexPath) as! RecievedAudioCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.lbDuration.text = "\(chats[indexPath.row].currentTime!)/" + chats[indexPath.row].file_duration
                    cell.indexPath = indexPath
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    return cell
                    
                }
                else if chats[indexPath.row].msg_type == "6"{
                    //received video Chat
                    let data = chats[indexPath.row]
                    let cell = tbvData.dequeueReusableCell(withIdentifier: itemCellReceivedVideoCell, for: indexPath)as! ReceivedVideoChatCell
                    cell.delegate = self
                    cell.indexPath = indexPath
                    let url = URL(string: data.msg_img)
                    cell.videoUrl = url
                    cell.selectionStyle = .none
                    return cell
                }
                else {
                    return UITableViewCell()
                }

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSend, for: indexPath) as! SendChatCell
                cell.backgroundColor = UIColor.clear
                //
                ///   print("sdcsff"+chats[indexPath.row].msg_status)
                if chats[indexPath.row].msg_type == "0"  {
                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    cell.lbMessage.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.indexPath = indexPath
                    cell.delegate = self
                    cell.selectionStyle = .none
                    
                    if chats[indexPath.row].isShowReadMore != nil && chats[indexPath.row].isShowReadMore {
                        cell.bReadMore.isHidden = false
                        cell.bReadMore.setTitle("Read More", for: .normal)
                        cell.conWidthReadMore.constant = 70
                    } else {
                        cell.bReadMore.isHidden = true
                        cell.bReadMore.setTitle("", for: .normal)
                        
                    }
                    
                    if  chats[indexPath.row].isReadMore != nil && chats[indexPath.row].isReadMore {
                        cell.lbMessage.numberOfLines = 0
                        cell.bReadMore.setTitle("Read Less", for: .normal)
                    } else {
                        cell.lbMessage.numberOfLines = 7
                        cell.bReadMore.setTitle("Read More", for: .normal)
                    }
                    //cell.viewMain.roundCorners(corners: [.topLeft , .topRight , .bottomLeft], radius: 10)
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    return cell
                    
                } else if chats[indexPath.row].msg_type == "1" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSendMultimedia, for: indexPath) as! SendMultimediaCell
                    cell.backgroundColor = UIColor.clear
                    
                    cell.lbMessage.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.indexPath = indexPath
                    cell.delegate = self
                    if chats[indexPath.row].isShowReadMore != nil && chats[indexPath.row].isShowReadMore {
                        cell.bReadMore.isHidden = false
                        cell.bReadMore.setTitle("Read More", for: .normal)
                        cell.conWidthReadMore.constant = 70
                    } else {
                        cell.bReadMore.isHidden = true
                        cell.bReadMore.setTitle("", for: .normal)
                        
                    }
                    
                    if  chats[indexPath.row].isReadMore != nil && chats[indexPath.row].isReadMore {
                        cell.lbMessage.numberOfLines = 0
                        cell.bReadMore.setTitle("Read Less", for: .normal)
                    } else {
                        cell.lbMessage.numberOfLines = 7
                        cell.bReadMore.setTitle("Read More", for: .normal)
                    }
                    Utils.setImageFromUrl(imageView: cell.ivImage, urlString: chats[indexPath.row].msg_img, palceHolder: "")
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    if isSelectChat {
                        cell.bFullImage.isHidden = true
                    } else {
                        cell.bFullImage.isHidden = false
                    }
                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    return cell
                } else if chats[indexPath.row].msg_type == "2" {
                    //for documrnt
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSendDocumentCell, for: indexPath) as! SendDocumentCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.lbDocName.text = chats[indexPath.row].file_original_name
                    cell.lbDocSize.text = chats[indexPath.row].file_size
                  ///  cell.ivDocType.image = goGetDocTypeImage(string: chats[indexPath.row].msg_img)
                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    
                    cell.bDocument.tag = indexPath.row
                    cell.bDocument.addTarget(self, action: #selector(onClickDoc(sender:)), for: .touchUpInside)
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                  
                    if isSelectChat {
                        cell.bDocument.isHidden = true
                    } else {
                        cell.bDocument.isHidden = false
                    }
                    return cell
                    
                } else if chats[indexPath.row].msg_type == "3" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSendAudioCell, for: indexPath) as! SendAudioCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    cell.lbDuration.text = "\(chats[indexPath.row].currentTime!)/" + chats[indexPath.row].file_duration
                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    cell.delegate = self
                    cell.indexPath = indexPath
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    return cell
                    
                    
                }  else  if chats[indexPath.row].msg_type == "5" {
                    // for contect
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSendContactCell, for: indexPath) as! SendContactCell
                    cell.backgroundColor = UIColor.clear
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    if  chats[indexPath.row].msg_data != nil &&  chats[indexPath.row].msg_data != "" {
                        let contact = chats[indexPath.row].msg_data.components(separatedBy: "@")
                        if contact.count > 1 {
                            cell.lbName.text = contact[0]
                            cell.lbNumber.text = contact[1]
                            
                        } else {
                            cell.lbName.text = ""
                            cell.lbNumber.text = ""
                        }
                    } else {
                        cell.lbName.text = ""
                        cell.lbNumber.text = ""
                    }

                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    return cell
                    
                    
                }   else if chats[indexPath.row].msg_type == "4" {
                    //for location
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSendLocationCell, for: indexPath) as! SendLocationCell
                    cell.backgroundColor = UIColor.clear
                    
                    cell.lbLocation.text = chats[indexPath.row].msg_data
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.selectionStyle = .none
                    
                    let latLong = chats[indexPath.row].location_lat_long
                    let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C"
                        + latLong! + "&key=" + StringConstants.MAP_KEY
                    cell.ivImageLocation.setImage(url: URL(string: mapUrl)!)
                    if chats[indexPath.row].msg_status != nil{
                        
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    cell.bLocation.tag = indexPath.row
                    cell.bLocation.addTarget(self, action: #selector(onClickLocation(sender:)), for: .touchUpInside)
                    
                    cell.viewMain.clipsToBounds = true
                    cell.viewMain.layer.cornerRadius = corner
                    cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    if isSelectChat {
                        cell.bLocation.isHidden = true
                    } else {
                        cell.bLocation.isHidden = false
                    }
                    return cell
                    
                }else if chats[indexPath.row].msg_type == "6"{
                    //send video Chat
                    let data = chats[indexPath.row]
                    let cell = tbvData.dequeueReusableCell(withIdentifier: itemCellSentVideoCell, for: indexPath)as! SentVideoChatCell
                    if chats[indexPath.row].msg_status != nil{
                        if chats[indexPath.row].msg_status == "0"{
                            cell.imgTick.image = UIImage(named: "Singletick")
                        }else{
                            cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                        }
                    }
                    cell.lbTime.text = chats[indexPath.row].msg_date
                    cell.delegate = self
                    cell.indexPath = indexPath
                    let url = URL(string:data.msg_img)
                    cell.videoUrl = url
                    cell.selectionStyle = .none
                    if chats[indexPath.row].isShowDelete != nil && chats[indexPath.row].isShowDelete {
                        cell.viewDelete.isHidden = false
                    } else {
                        cell.viewDelete.isHidden = true
                    }
                    if isSelectChat {
                        cell.bPlayVideo.isHidden = true
                    } else {
                        cell.bPlayVideo.isHidden = false
                    }
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if   isSelectChat {
            if !chats[indexPath.row].isDate &&   chats[indexPath.row].my_msg != "0" {
                
                if chats[indexPath.row].isShowDelete == nil {
                    chats[indexPath.row].isShowDelete = false
                }
                
                if chats[indexPath.row].isShowDelete {
                    chats[indexPath.row].isShowDelete = false
                    deleteCount -= 1
                } else {
                    chats[indexPath.row].isShowDelete = true
                    deleteCount += 1
                }
                
                tbvData.reloadData()
                lbDeletCount.text = "\(deleteCount)"
                
                if deleteCount == 0 {
                    self.resetDeleteView()
                }
            }
            
        }
    }
    
    func scrollToBottom(){
        if chats.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chats.count-1, section: 0)
                self.tbvData.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    @objc func saveCantacts(sender : UIButton) {
        // Create a mutable object to add to the contact


        let index = sender.tag
        if  chats[index].msg_data != nil &&  chats[index].msg_data != "" {
            let contact = chats[index].msg_data.components(separatedBy: "@")
            if contact.count > 1 {
                let name = contact[0]
                let number = contact[1]

                let contact = CNMutableContact()
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :number))

                contact.phoneNumbers = [homePhone]
                contact.givenName = name
                // contact.imageData = data // Set image data here
                let vc = CNContactViewController(forNewContact: contact)
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }

        }

    }

    func goGetDocTypeImage(string : String) -> UIImage {
        var image = UIImage(named: "")
        
        
        if  string.contains(".pdf") {
            image = UIImage(named: "pdf")
        } else  if  string.contains(".doc") || string.contains(".docx") {
            image =   UIImage(named: "doc")
        } else  if  string.contains(".ppt") || string.contains(".pptx") {
            image = UIImage(named: "doc")
        } else  if string.contains(".jpg") || string.contains(".jpeg") {
            image = UIImage(named: "jpg-2")
        } else  if  string.contains(".png")  {
            image = UIImage(named: "png")
        } else  if  string.contains(".zip")  {
            image = UIImage(named: "zip")
        } else {
             image = UIImage(named: "doc")
        }
        
        //         UIImage(named: "jpg")
        //        UIImage(named: "png")
        //        UIImage(named: "zip")
        //
        return image!
        
    }

}


extension ChatVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag: Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: {
                self.actionBlockUnblockCLicked(action: "unblock")
            })
        }
    }
}


extension ChatVC : RecordViewDelegate , AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    func onStart() {
        stateLabel.text = ""
        print("onStart")
        //audioRecorder.stop()
        //             audioRecorder = nil
        setup_recorder()
        viewRecoed.isHidden = false
        if checkMicroPhonePermssion() {
            audioRecorder.record()
            
        }
    }

    func onCancel() {
        stateLabel.text = ""
        print("onCancel")
        audioRecorder.stop()
        audioRecorder = nil
        viewRecoed.isHidden = true
    }

    func onFinished(duration: CGFloat) {
        stateLabel.text = ""
        let array  =  [fileURlAudio!]
        let d = "\(duration)"
        doUploadDocument(fileArray: array, type: StringConstants.MSG_TYPE_AUDIO, file_duration: d)
        
        print("ddd" , audioRecorder.deviceCurrentTime)
        audioRecorder.stop()
        audioRecorder = nil
        // print("onFinished \(fileURlAudio)")
        // bRecordingView.
        viewRecoed.isHidden = true
    }

    func getFileUrl() -> URL{
        let filename = "Fincasys_\(Date().generateCurrentTimeStamp()).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }

    func checkMicroPhonePermssion() -> Bool {
        var isPermision = true
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            // print("Permission granted")
            isPermision = true
        case AVAudioSession.RecordPermission.denied:
            // print("Pemission denied")
            // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            var flag = false
            AVCaptureDevice.requestAccess(for: .audio) { (Granted) in
                if Granted{
                    flag = true

                }else{
                    flag = false
                }
            }
            isPermision = flag
            break;

        case AVAudioSession.RecordPermission.undetermined:
            //print("Request permission here")
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            var flag = false
            AVCaptureDevice.requestAccess(for: .audio) { (Granted) in
                if Granted{
                    flag = true

                }else{
                    flag = false
                }
            }
            isPermision = flag
            break;
        default:
            break
        }
        return isPermision
        
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func openPermision() {
        let ac = UIAlertController(title: "", message: "Please Provide Microphone Permission", preferredStyle: .alert)
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
    
}

extension ChatVC: UIDocumentInteractionControllerDelegate ,AVPlayerViewControllerDelegate {

    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController = navigationController?.visibleViewController
        if currentviewController != playerViewController{
            currentviewController?.present(playerViewController, animated: true, completion: nil)
        }
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }

}

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

}
extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }

}
extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}
