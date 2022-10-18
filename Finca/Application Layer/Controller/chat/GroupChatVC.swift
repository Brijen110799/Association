//
//  GroupChatVC.swift
//  Finca
//
//  Created by anjali on 07/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//
import UIKit
import FittedSheets
import Contacts
import ContactsUI
import iRecordView
import AVFoundation
import AVKit

class GroupChatVC: BaseVC , UIGestureRecognizerDelegate ,UITextViewDelegate{
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    
    @IBOutlet weak var bottomConstEditView: NSLayoutConstraint!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    
    @IBOutlet weak var tfMessage: UITextView!
    @IBOutlet weak var viewChatMain: UIView!
    
    @IBOutlet weak var viewChatDisble: UIView!
    
    var isFirsttime = true
    var group_details : MemberListModel!
    var commonMessage = "commonMessage"
    var chats = [ChatModel]()
    var unreadCount = 0
    @IBOutlet weak var lblMemberCount: UILabel!
    var readFlag = "1"
    @IBOutlet weak var conHeightTVMsg: NSLayoutConstraint!
    @IBOutlet weak var ivAttach: UIImageView!
    let hint = "Type Here"

    @IBOutlet weak var btnGrpChatDisable: UIButton!
    //sent cells
    var itemCellSend = "SendChatCell"
    var itemCellSendMultimedia = "SendMultimediaCell"
    var ICSentDocument = "SendDocumentCell"
    var ICSentAudio = "SendAudioCell"
    var ICSentLocation = "SendLocationCell"
    var ICSentContact = "SendContactCell"
    var ICSentVideo = "SentVideoChatCell"

    var itemCellRecievdMultimedia = "RecievedMultimediaGroupCell"
    var itemCellRecieved = "RecievedGroup"
    var ICReceivedDocument = "ReceivedDocumentGroupCell"
    var ICReceivedAudio  = "ReceivedAudioGroupCell"
    var ICReceivedLocation = "ReceivedLocationGroupCell"
    var ICReceivedContact  = "ReceivedContactGroupCell"
    var ICReceivedVideo  = "ReceivedVideoGroupCell"
    var heightKey = 0.0
    var itemCellDate = "DateFormChat"
    var fileURlAudio : URL!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isRecording = false
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var audio_duration  = 0
    var playIndex = -1
    var playerController : AVPlayerViewController!
    private var chat_id_reply = "0"
    let corner = CGFloat(20)
    var memberCount = "0"
    var isComeFcm = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        unreadCount = Int(group_details.chatCount!)!
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 110
        tbvData.rowHeight = UITableView.automaticDimension
        lbUserName.text = group_details.userFirstName!
        Utils.setImageFromUrl(imageView: ivProfile, urlString: group_details.userProfilePic!, palceHolder: "groupPlaceholder")
        tbvData.sectionIndexBackgroundColor = UIColor.clear
        
         
        if   UserDefaults.standard.string(forKey: StringConstants.GROUP_CHAT_STATUS) ?? "" == "1" {
            self.viewChatDisble.isHidden = false
        } else {
            self.viewChatDisble.isHidden = true
        }
        // Do any additional setup after loading the view.
        let inb = UINib(nibName: itemCellSend, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCellSend)
        let inbRecieved = UINib(nibName: itemCellRecieved, bundle: nil)
        tbvData.register(inbRecieved, forCellReuseIdentifier: itemCellRecieved)
        
        let commonmessage = UINib(nibName: commonMessage, bundle: nil)
        tbvData.register(commonmessage, forCellReuseIdentifier: commonMessage)
        
        let inbSendMultimedia = UINib(nibName: itemCellSendMultimedia, bundle: nil)
        tbvData.register(inbSendMultimedia, forCellReuseIdentifier: itemCellSendMultimedia)
        
        let inbRecMultimedia = UINib(nibName: itemCellRecievdMultimedia, bundle: nil)
        tbvData.register(inbRecMultimedia, forCellReuseIdentifier: itemCellRecievdMultimedia)
        var nib : UINib!

        nib = UINib(nibName: itemCellDate, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCellDate)

        nib = UINib(nibName: ICSentDocument, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICSentDocument)

        nib = UINib(nibName: ICSentAudio, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICSentAudio)

        nib = UINib(nibName: ICSentLocation, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICSentLocation)

        nib = UINib(nibName: ICSentContact, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICSentContact)

        nib = UINib(nibName: ICSentVideo, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICSentVideo)

        nib = UINib(nibName: ICReceivedDocument, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICReceivedDocument)

        nib = UINib(nibName: ICReceivedAudio, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICReceivedAudio)

        nib = UINib(nibName: ICReceivedLocation, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICReceivedLocation)

        nib = UINib(nibName: ICReceivedContact, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICReceivedContact)

        nib = UINib(nibName: ICReceivedVideo, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: ICReceivedVideo)

        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: .groupChatMsgReceived, object: nil)

        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tbvData.addGestureRecognizer(longPressGesture)
      
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        tbvData.keyboardDismissMode = .interactive
        tfMessage.delegate = self
        tfMessage.placeholder = doGetValueLanguage(forKey: "type_here")
        tfMessage.placeholderColor = .lightGray
        //ivAttach.transform = CGAffineTransform(rotationAngle: CGFloat(-45))
        tbvData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        btnGrpChatDisable.setTitle(doGetValueLanguage(forKey: "group_chat_is_disable_by_association_admin"), for: .normal)
        memberCount = "\(group_details.memberSize ?? "")"
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        dismissKeyboard(sender)
    }
    override func viewWillAppear(_ animated: Bool) {
        doGetChat(isRefresh:false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        lblMemberCount.text = "\(memberCount) \(doGetValueLanguage(forKey: "members"))"
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer) {
        // if gestureRecognizer.state == .ended {
        let touchPoint = gestureRecognizer.location(in: self.tbvData)
        if let indexPath = tbvData.indexPathForRow(at: touchPoint) {
            // print()
            
            let index = indexPath.row
            if chats[index].my_msg == "1" {
                let alert = UIAlertController(title: "", message:"Are you sure you want to delete", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    self.doDelete(chatId: self.chats[index].chat_id)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    @IBAction func btnMoreGroupDetails(_ sender: UIButton) {
        let nextVC = storyboardConstants.chat.instantiateViewController(withIdentifier: "idGroupDetailsVC")as! GroupDetailsVC
        nextVC.groupDetail = self.group_details
        nextVC.groupChatVC = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func doDelete (chatId:String) {
        let  paramsSend = ["key":apiKey(),
                           "getdelChat":"getdelChat",
                           "chat_id":chatId]
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chat_controller_group, parameters: paramsSend) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    if response.status == "200" {
                        self.readFlag = "0"
                        //  self.tfMessage.text = ""
                        self.doGetChat(isRefresh: false)
                        
                    }else {
                        //     readFlag = "0"                   self.showAlertMessage(title: "Alert", msg: response.message)
                        self.readFlag = "0"
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

        if click_action.lowercased() == "chatmsggroup" {
            doGetChat(isRefresh: false)
        }
    }
    func doSendMessage(message:String,msgType : String , location_lat_long : String) {
        tfMessage.text = ""
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        let msg_for = doGetLocalDataUser().userFullName!
        
        let paramsSend = ["key":apiKey(),
                          "addChat":"addChatNew",
                          "society_id":doGetLocalDataUser().societyID!,
                          "msg_by":doGetLocalDataUser().userID!,
                          "msg_for":msg_for,
                          "msg_data":message,
                          "sent_to":"",
                          "unit_name":msg_for,
                          "unit_id":doGetLocalDataUser().unitID!,
                          "group_id":group_details.chatID!,
                          "group_name":group_details.userFullName!,
                          "msgType" : msgType,
                          "location_lat_long" : location_lat_long,
                          "public_mobile" : doGetLocalDataUser().publicMobile! ,
                          "member_count": group_details.memberSize ?? ""]
        
        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chat_controller_group, parameters: paramsSend) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        /* self.chats.append(ChatModel(msg_for: "",my_msg: "1",msg_date: "",society_id: "",msg_status: "",msg_by: "",chat_id: "",msg_data: self.tfMessage.text!,msg_delete: ""))
                         self.tbvData.reloadData()
                         self.tfMessage.text = ""
                         self.scrollToBottom()*/
                        
                        self.unreadCount += 1
                        self.tfMessage.text = ""
                        self.doGetChat(isRefresh: false)
                        
                    }else {
                        //                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.5
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
    @IBAction func onClickSendMesage(_ sender: Any) {
        
        if  !tfMessage.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tfMessage.text != "\n"  &&
            tfMessage.text != "\n "  && tfMessage.text != hint  {
            
            doSendMessage(message: tfMessage.text!,msgType: StringConstants.MSG_TYPE_TEXT,location_lat_long: "")
        }
        
    }
    @IBAction func onClickBack(_ sender: Any) {
        if isComeFcm == "" {
            doPopBAck()
        } else {
            Utils.setHome()
        }
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
        self.heightKey = Double(bottomConstEditView.constant)
          UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        bottomConstEditView.constant = 0.0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    func doGetChat(isRefresh:Bool ) {
        
        if isFirsttime {
            showProgress()
        }
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        let   params = ["key":apiKey(),
                        "getPrvChatNewDesc":"getPrvChatNewDesc",
                        "user_id":doGetLocalDataUser().userID!,
                        "society_id":doGetLocalDataUser().societyID!,
                        "sentTo":"",
                        "limit_chat":"0",
                        "group_id":group_details.chatID!,
                        "unit_id":doGetLocalDataUser().unitID!,
                        "read_flag":readFlag,
                        "unread_count":String(unreadCount)]
        
        
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chat_controller_group, parameters: params) { (json, error) in
            
            if self.isFirsttime {
                self.hideProgress()
            }
            if isRefresh {
                self.refreshControl.endRefreshing()
            }
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseChat.self, from:json!)
                    
                    //   UserDefaults.standard.set(response.chat_status, forKey: StringConstants.CHAT_STATUS)
                    //  UserDefaults.standard.set(response.read_status, forKey: StringConstants.READ_STATUS)
                    
                    
                    if response.status == "200" {
                        self.lbNoData.isHidden = true
                        if self.chats.count > 0 {
                            self.chats.removeAll()
                            //   self.tbvData.reloadData()
                        }
                        
                        self.chats.append(contentsOf: response.chat)
                        self.chats.reverse()
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
                        self.tbvData.reloadData()
                        self.lbNoData.isHidden = false
                        //                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
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
    @IBAction func onClickAttachment(_ sender: Any) {
     
        
        
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idDailogAttachmentVC")as!
        DailogAttachmentVC
        vc.onTapMediaSelect = self
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
    }
    func goToMultimedia(images : [UIImage]) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idSendMultimediaChatVC") as! SendMultimediaChatVC
        vc.slider = images
        // vc.user_id = userid
        vc.groupChatVC = self
        vc.isOneToOne = false
        vc.group_id = group_details.chatID!
        vc.group_name = group_details.userFullName!
        pushVC(vc: vc)
    }
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        
        if  frame.size.height < 100 {
            if frame.size.height > 30 {
                self.tfMessage.frame = frame
                self.conHeightTVMsg.constant = frame.size.height
            } else {
                self.conHeightTVMsg.constant = 24
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    func textViewDidEndEditing(_ textView: UITextView) {
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
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown) , userInfo: nil, repeats: true)
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
                guard let cell : ReceivedAudioGroupCell = tbvData.cellForRow(at: IndexPath(row: index, section: 0))  as? ReceivedAudioGroupCell else {
                    print("nil returned")
                    return
                }
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
    func doSendContact(message:String , msgType : String ) {
        tfMessage.text = ""
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var   paramsSend  =  [String:String]()
//        let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
        
        let unit_name =  doGetLocalDataUser().userFullName!
        let public_mobile = doGetLocalDataUser().publicMobile!

        paramsSend = ["addChat":"addChatNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "chat_id_reply":chat_id_reply,
                      "msg_by":doGetLocalDataUser().userID!,
                      "msg_for":unit_name,
                      "msg_data":message,
                      "sent_to":"",
                      "unit_id":doGetLocalDataUser().unitID!,
                      "group_id" : group_details.chatID ?? "",
                      "group_name" : group_details.userFirstName ?? "",
                      "group_icon": group_details.userProfilePic!,
                      "member_count": group_details.memberSize,
                      "msgType":msgType,
                      "public_mobile" : public_mobile ,
                      "location_lat_long" : "",
                      "unit_name" : unit_name]

        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chat_controller_group, parameters: paramsSend) { (json, error) in

            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    if response.status == "200" {
                        self.doGetChat(isRefresh: false)
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
         let unit_name = doGetLocalDataUser().userFullName!
      
           // let  user_id = self.user_id
          
            
        let  paramsSend = ["addChatWithDoc":"addChatWithDoc",
                               "society_id":doGetLocalDataUser().societyID!,
                               "msg_by":doGetLocalDataUser().userID!,
                               "msg_for":doGetLocalDataUser().userFullName!,
                               "unit_name":unit_name,
                               "sent_to":"0",
                               "unit_id":doGetLocalDataUser().unitID!,
                               "group_id" : group_details.chatID ?? "",
                               "group_name" : group_details.userFirstName ?? "",
                               "group_icon": group_details.userProfilePic!,
                               "member_count": group_details.memberSize ?? "",
                               "user_profile":doGetLocalDataUser().userProfilePic!,
                               "user_name":doGetLocalDataUser().userFullName!,
                               "block_name":doGetLocalDataUser().company_name ?? "",
                               "user_mobile":doGetLocalDataUser().userMobile!,
                               "msgType" : type,
                               "file_duration" : file_duration,
                               "location_lat_long" : "",
                               "public_mobile": doGetLocalDataUser().publicMobile!] as [String : Any]

           // "msg_data[]": msg_data,

           print("param" , paramsSend)
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPostMultipartWithFileArryaImage(serviceName: ServiceNameConstants.chat_controller_group, parameters: paramsSend,  doc_array: fileArray, paramName: "chat_doc[]"  ,compression:  0.3 ) { (json, error) in

               if json != nil {
                   self.hideProgress()
                   do {
                       let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)


                       if response.status == "200" {
                           self.doGetChat(isRefresh: false)

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
}
extension GroupChatVC:UITableViewDataSource,UITableViewDelegate,GroupChatDelegate , ChatClickDelegate,AudioCellDelegate,VideoCellDelegate,AVPlayerViewControllerDelegate{

    @objc func didfinishPlaying(note : NSNotification)  {

        playerController.dismiss(animated: true, completion: nil)
//        let alertView = UIAlertController(title: "Finished", message: "Video finished", preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
//        self.present(alertView, animated: true, completion: nil)
    }
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController = navigationController?.visibleViewController
        if currentviewController != playerViewController{
            currentviewController?.present(playerViewController, animated: true, completion: nil)
        }
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
    func PlayAudio(at indexPath: IndexPath) {
        self.playClicked(indexPath.row)
        //        let data = chats[indexPath.row]
        //        self.storeAndShare(withURLString: data.msg_img)
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
            pushVC(vc: nextVC)
        }
        
    }
    func doOpenMemberProfile(indexPath: IndexPath) {
        let data = chats[indexPath.row]
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
        //        vc.user_id = data.msg_by
        //        self.navigationController?.pushViewController(vc, animated: true)
        //        let data = filterList[indexPath.row]
//        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = data.msg_by!
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MemberDetailsVC()
        vc.user_id = data.msg_by ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = chats[indexPath.row]
        if data.my_msg == "1"{
            //sent chat
            if data.msg_type == "0"{
                //regular message
                let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSend, for: indexPath) as! SendChatCell
                cell.backgroundColor = UIColor.clear
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
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
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

                return cell
            }// text cell
            else if data.msg_type == "1"{
                //multimedia send
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
                return cell
            }// photo cell
            else if data.msg_type == "2"{
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICSentDocument, for: indexPath) as! SendDocumentCell
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = data.msg_date
                cell.selectionStyle = .none
                cell.lbDocName.text = data.file_original_name
                cell.lbDocSize.text = data.file_size
               // cell.ivDocType.image = goGetDocTypeImage(string: chats[indexPath.row].msg_img)
                if data.msg_status != nil{

                    if data.msg_status == "0"{
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
                return cell
            }// document cell
            else if data.msg_type == "3"{
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICSentAudio, for: indexPath) as! SendAudioCell

                if data.isPlayAudio {
                    cell.imgPlayButton.image = UIImage(named: "pause-button")
                } else {
                    cell.imgPlayButton.image = UIImage(named: "play.circle.fill")
                }
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = data.msg_date
                cell.selectionStyle = .none
                cell.lbDuration.text = "\(data.currentTime!)/" + data.file_duration
                if data.msg_status != nil{

                    if data.msg_status == "0"{
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
                return cell
            }// audio cell
            else if data.msg_type == "4"{
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICSentLocation, for: indexPath) as! SendLocationCell
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
                return cell
            }// location cell
            else if data.msg_type == "5"{
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICSentContact, for: indexPath) as! SendContactCell
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = data.msg_date
                cell.selectionStyle = .none
                if  data.msg_data != nil &&  data.msg_data != "" {
                    let contact = data.msg_data.components(separatedBy: "@")
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

                if data.msg_status != nil{

                    if data.msg_status == "0"{
                        cell.imgTick.image = UIImage(named: "Singletick")
                    }else{
                        cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                    }
                }

                 
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
                return cell

            }// contact cell
            else if data.msg_type == "6"{
                //send video Chat
                let data = chats[indexPath.row]
                let cell = tbvData.dequeueReusableCell(withIdentifier:ICSentVideo , for: indexPath)as! SentVideoChatCell
                if data.msg_status != nil{
                    if data.msg_status == "0"{
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
                return cell
            }// video cell
            else{
                return UITableViewCell()
            }//default case not executable
        }
        else if data.my_msg == "0"{
            //received chat
            if data.msg_type == "0"{

                //text chat
                let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecieved, for: indexPath) as! RecievedGroup
                cell.backgroundColor = UIColor.clear
                cell.delegate = self
                cell.indexPath = indexPath
                cell.delegateChat = self

                cell.lbMessage.text = chats[indexPath.row].msg_data
                cell.lbPersonName.text = chats[indexPath.row].msg_for
                cell.lbTime.text = chats[indexPath.row].msg_date
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
                cell.selectionStyle = .none
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                return cell
            }//text cell
            else if data.msg_type == "1"{

                //multimedia received chat
                let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecievdMultimedia, for: indexPath) as! RecievedMultimediaGroupCell
                cell.backgroundColor = UIColor.clear
                cell.delegate = self
                cell.indexPath = indexPath
                cell.delegateChat = self
                cell.lbMessage.text = chats[indexPath.row].msg_data
                cell.lbPersonName.text = chats[indexPath.row].msg_for
                cell.lbTime.text = chats[indexPath.row].msg_date
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
                cell.selectionStyle = .none
                Utils.setImageFromUrl(imageView: cell.ivImage, urlString: chats[indexPath.row].msg_img, palceHolder: "")
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                return cell
            }
            else if data.msg_type == "2"{
                // document
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICReceivedDocument, for: indexPath) as! ReceivedDocumentGroupCell
                cell.indexPath = indexPath
                cell.delegate = self
                cell.lblSenderName.text = data.msg_for
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = chats[indexPath.row].msg_date
                cell.selectionStyle = .none
                cell.lbDocName.text = chats[indexPath.row].file_original_name
                cell.lbDocSize.text = chats[indexPath.row].file_size
              //  cell.ivDocType.image = goGetDocTypeImage(string: chats[indexPath.row].msg_img)
             
                cell.bDownload.tag = indexPath.row
                cell.bDownload.addTarget(self, action: #selector(onClickDoc(sender:)), for: .touchUpInside)
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                return cell
            }// document cell
            else if data.msg_type == "3"{
                //location
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICReceivedAudio, for: indexPath) as! ReceivedAudioGroupCell
                if data.isPlayAudio {
                    cell.imgPlayButton.image = UIImage(named: "pause-button")
                } else {
                    cell.imgPlayButton.image = UIImage(named: "play.circle.fill")
                }
                cell.lblSenderName.text = data.msg_for
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = chats[indexPath.row].msg_date
                cell.selectionStyle = .none
                //for opening profile
                cell.cellDelegate = self
                //for playing audio
                cell.delegate = self
                cell.lbDuration.text = "\(chats[indexPath.row].currentTime!)/" + chats[indexPath.row].file_duration
                cell.indexPath = indexPath
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                return cell
            }// audio cell
            else if data.msg_type == "4"{
                //for location
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICReceivedLocation, for: indexPath) as! ReceivedLocationGroupCell
                cell.backgroundColor = UIColor.clear
                cell.lbLocation.text = chats[indexPath.row].msg_data
                cell.lbTime.text = chats[indexPath.row].msg_date
                cell.selectionStyle = .none
                cell.lbSenderName.text = data.msg_for
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
            }// location cell
            else if data.msg_type == "5"{
                let cell = tableView.dequeueReusableCell(withIdentifier: self.ICReceivedContact, for: indexPath) as! ReceivedContactGroupCell
                cell.cellDelegate = self
                cell.indexPath = indexPath
                cell.lblSenderName.text = data.msg_for
                cell.backgroundColor = UIColor.clear
                cell.lbTime.text = data.msg_date
                cell.selectionStyle = .none
                if  data.msg_data != nil &&  data.msg_data != "" {
                    let contact = data.msg_data.components(separatedBy: "@")
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
            }// contact cell
            else if data.msg_type == "6"{
                let data = chats[indexPath.row]
                let cell = tbvData.dequeueReusableCell(withIdentifier: ICReceivedVideo, for: indexPath)as! ReceivedVideoGroupCell
                cell.lblSenderName.text = data.msg_for
                cell.delegate = self
                cell.indexPath = indexPath
                let url = URL(string: data.msg_img)
                cell.videoUrl = url
                cell.selectionStyle = .none
                cell.viewMain.clipsToBounds = true
                cell.viewMain.layer.cornerRadius = corner
                cell.viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                return cell
            }// video cell
            else{
                return UITableViewCell()
            }//default case not executable
        }
        else {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellDate, for: indexPath) as! DateFormChat
            cell.lbDate.text = data.msg_date ?? ""
            cell.lblDateChange.text = data.msg_data
            cell.selectionStyle = .none
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        } //common center cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chats.count-1, section: 0)
            self.tbvData.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    @objc func saveCantacts(sender : UIButton) {
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
            image =   UIImage(named: "doc")
        }
        return image!
    }
}
extension GroupChatVC : CNContactPickerDelegate,CNContactViewControllerDelegate {

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
        var primaryPhoneNumberStr = ""
        if contact.phoneNumbers.count > 0 {
            // user phone number
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value


            // user phone number string
             primaryPhoneNumberStr =   firstPhoneNumber.stringValue
        }
        

        let dataS = userName + "@" + primaryPhoneNumberStr
        doSendContact(message: dataS, msgType: StringConstants.MSG_TYPE_CONTACT)

    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
extension GroupChatVC : OnTapMediaSelect{
    // TODO : here is media delegate
    func onSuccessMediaSelect(image: [UIImage], fileImage: [URL]) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idSendMultimediaChatVC") as! SendMultimediaChatVC
        vc.slider = image
        vc.user_id = doGetLocalDataUser().userID ?? ""
        vc.group_id = group_details.chatID ?? ""
        vc.member_count = group_details.memberSize ?? ""
        vc.group_name = group_details.userFirstName ?? ""
        vc.fileImage = fileImage
        vc.groupChatVC = self
        vc.isOneToOne = false
        pushVC(vc: vc)
    }
    
    func onSucessUploadingFile(fileUrl: [String], msg: String) {
         
        
    }
    
    func selectDocument(fileArray: [URL], type: String, file_duration: String) {
        doUploadDocument(fileArray: fileArray, type: type, file_duration: file_duration)
      }
    
    func onTapOthers(type: String) {
        
        if type == "Location" {
            // call location
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationMapVC") as! SelectLocationMapVC
            vc.onTapMediaSelect = self
             pushVC(vc: vc)
        } else if type == "Contact" {
            // open caontact
           
                let contactPicker = CNContactPickerViewController()
                contactPicker.delegate = self
                contactPicker.displayedPropertyKeys =
                    [CNContactGivenNameKey
                     , CNContactPhoneNumbersKey]
                self.present(contactPicker, animated: true, completion: nil)
            
        }
    }
    
    
    func onLocationSuccess(location: String, address: String) {
        doSendMessage(message: address, msgType: StringConstants.MSG_TYPE_LOCATION, location_lat_long: location)
    }
       //
}

// 0 received message
// 1 sent message
// 2 center message

// 0 for text
// 1 for mutlimedia
// 2 for document
// 3 for audio
// 4 for location
// 5 contact
// 6 video
