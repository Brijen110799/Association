//
//  ChatRoomVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FittedSheets
import Contacts
import ContactsUI
struct ModelChat : Codable {
    var chatId : String!//
    var societyId : String!//
    var senderId : String!//
    var senderName : String!//
    var senderProfile : String!//
    var msgBy : String!//
    var msgFor : String!//
    var msgType : String!//
    var msgImg : String!//
    var msgData : String!//
    var msgStatus : String!//
    var msgDelete : String!//
    var msgDate : String!//
    var chatIdReply : String!//
    var replyMsg : String!//
    var replyMsgImg : String!//
    var replyMsgType : String!//
    var replyUserName : String!//
    var file_original_name : String!//
    var location_lat_long : String!//
    var isUploading : Bool!//= false;
    var timeStamp : Date!//
}

class ChatRoomVC: BaseVC , UITextViewDelegate {
    
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var lbBlockStatus: UILabel!
    @IBOutlet weak var bMoreSetting: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var conBottomMsgView: NSLayoutConstraint!
    @IBOutlet weak var tvMsg: UITextView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbStartChat: UILabel!
    @IBOutlet weak var lbTyping: UILabel!
    @IBOutlet weak var ivAttached: UIImageView!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var heightConBlockView: NSLayoutConstraint!
    @IBOutlet weak var viewMainInputview: UIView!
    @IBOutlet weak var lbBlockMsg: UILabel!
    @IBOutlet weak var conHeightTextview: NSLayoutConstraint!
    
    @IBOutlet weak var lbDeletCount: UILabel!
    @IBOutlet weak var viewToolbarDelete: UIView!
    var userModel = MemberModelChat()
    var userMyModel = MemberModelChat()
    var sendTo = "" //Chat with link member gatekepper etc
    @IBOutlet weak var tfMessage: UITextView!
    
    var db: Firestore! // forebase database
    var responseRecentChat:ResponseRecentChat!
    var recentId = ""
    var chatData = [ModelChat]()
    var blockString = "block"
    var strCloseConversation = "block"
    private var listener: ListenerRegistration?
    
    private var heightKeyboard: CGFloat = 0
    private var keyboardWillShowB = false
    let requrest = AlamofireSingleTon.sharedInstance
    
    private var isShowBlockView = true
    private var chatDataSelectDelete = [ModelChat]()
    private  var deleteCount = 0
    private var isSelectChat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iniiTableViewCell()
        initView()
        
        print("date \(currentDate())")
    }
    func initView() {
        db = Firestore.firestore()
        if let data = UserDefaults.standard.data(forKey: StringConstants.USER_CHAT_DATA), let decoded = try? JSONDecoder().decode(MemberModelChat.self, from: data){
            userMyModel = decoded
        }
        
        if responseRecentChat != nil {
            
            
        }
        doGetRecentChat()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        watchUserStatus(userChatId: userModel.userChatId)
       
    }
    func  iniiTableViewCell() {
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 110
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.sectionIndexBackgroundColor = UIColor.clear
        let inb = UINib(nibName: CellFileName.itemCellSend, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: CellFileName.itemCellSend)
        let inbRecieved = UINib(nibName: CellFileName.itemCellRecieved, bundle: nil)
        tbvData.register(inbRecieved, forCellReuseIdentifier: CellFileName.itemCellRecieved)
        
        if userModel.publicMobile != nil &&  userModel.publicMobile != "1"  {
            viewCall.isHidden = false
        } else {
            viewCall.isHidden = true
        }
        
        if sendTo == StringConstants.CHAT_WITH_GATEKEEPER || sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER  {
            viewMore.isHidden = true
            viewCall.isHidden = false
            
        } else {
            viewMore.isHidden = false
        }
        lbUserName.text = userModel.userName ?? ""
        Utils.setImageFromUrl(imageView: ivProfile, urlString: userModel.userProfile, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        
       
      //  tfMessage.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
        tbvData.keyboardDismissMode = .interactive
        tfMessage.delegate = self
        tfMessage.placeholder = "Type Message"
        tfMessage.placeholderColor = .lightGray
        ivAttached.transform = CGAffineTransform(rotationAngle: CGFloat(-45))
       
        tbvData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressD))
        tbvData.addGestureRecognizer(longPress)
    }
    
    //TODO: handle gesture
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        if sender.state == .ended {
            dismissKeyboard(sender)
        }
        sender.cancelsTouchesInView = false
    }

    @objc func handleLongPressD(sender: UILongPressGestureRecognizer){
     //   print("dddd ")
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tbvData)
            if let indexPath = tbvData.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
              
               
                if chatData[indexPath.row].msgBy == userChatId() {
                    
                    isSelectChat = true
                
                    deleteCount += 1
                    lbDeletCount.text = "\(deleteCount)"
                    viewToolbarDelete.isHidden = false
                    
                    var isAdd = true
                    for (index,item) in  chatDataSelectDelete.enumerated() {
                        
                        if item.chatId == chatData[indexPath.row].chatId {
                            chatDataSelectDelete.remove(at: index)
                            isAdd = false
                            break
                        }
                    }
                    
                    if isAdd {
                        chatDataSelectDelete.append(chatData[indexPath.row])
                    }
                    self.tbvData.reloadData()
                   // self.tbvData.reloadRows(at: [indexPath], with: .none)
                }
                
                /*if !chats[indexPath.row].isDate && chats[indexPath.row].my_msg != "0" {
                    
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
                    }*/
                    //self.tbvData.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                
            }
        }
    }
    
    private  func resetDeleteView() {
        isSelectChat = false
        viewToolbarDelete.isHidden = true
        deleteCount = 0
        chatDataSelectDelete.removeAll()
        tbvData.reloadData()
    }
    //end
   
    
    //TODO: All button click start here
    @IBAction func tapSendMsg(_ sender: Any) {
        print("tapSendMsg")
        
        if recentId == "" {
            doAddRecentUser(msg: tvMsg.text, type: StringConstants.MSG_TYPE_TEXT,isDocUpload: false,imageUrl: "")
        } else {
            doSendData(msg: tvMsg.text, type: StringConstants.MSG_TYPE_TEXT)
        }
        
    }
   
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
   
    @IBAction func btnOpenProfile(_ sender: UIButton) {
        if sendTo != StringConstants.CHAT_WITH_GATEKEEPER {
            
//            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//            vc.user_id = userModel.userId
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = MemberDetailsVC()
            vc.user_id = userModel.userId ?? ""
            vc.userName =  ""
            pushVC(vc: vc)
        } else {
            toast(message: "No User found!", type: .Success)
        }
        
    }
    
    @IBAction func tapBlockAndUnblock(_ sender: Any) {
        viewBlock.isHidden = true
        heightConBlockView.constant = 0
       
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
            
        } else {
         showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure to \(blockString) this user?", style: .Info, cancelText: "Cancel", okText: blockString)
       }
        
        
    }
    
    
    @IBAction func tapMoreSetting(_ sender: Any) {
        
        if isShowBlockView {
            isShowBlockView = false
            viewBlock.isHidden = false
            heightConBlockView.constant = 40
            UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
            })
            
        } else {
            isShowBlockView = true
            viewBlock.isHidden = true
            heightConBlockView.constant = 0
            UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func tapCall(_ sender: Any) {
        
        let phone = userModel.userMobile ?? ""
        if let url = URL(string: "tel:\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func tapAttched(_ sender: Any) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idDailogAttachmentVC")as!
        DailogAttachmentVC
        vc.onTapMediaSelect = self
        //vc.chatVC = self
        let sheetController = SheetViewController(controller: vc, sizes:[.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = false
        sheetController.topCornersRadius = 15
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func tapDeleteMsg(_ sender: Any) {
        
        for item in chatDataSelectDelete {
             doDeleteMsg(modelChat: item)
        }
    }
    
    @IBAction func tapResetDelete(_ sender: Any) {
        resetDeleteView()
    }
    //end here
    func doGetRecentChat(){
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
            
            
        } else {
            
           
            let docRef =   db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").whereField("userChatIds", arrayContains: userChatId()).whereField("single", isEqualTo: true)
            
            
            docRef.getDocuments(source: .cache) {[self] (task, error) in
                if error != nil {
                    print("error " , error as Any)
                    return
                }
                
                
                for item in task!.documentChanges {
                    let idsData : [String] = item.document.data()["userChatIds"] as! [String]
                   
                    
                    if idsData[0] == userChatId() {
                        
                        if idsData[1] == userModel.userChatId {
                            recentId = item.document.data()["recentId"] as! String
                            
                            print("chat vc recentId  = ", recentId)
                            
                            if recentId != "" {
                                doGetChatData()
                                typingListner()
                                break
                            }
                            
                        }
                        
                    } else {
                        if idsData[1] == userChatId(){
                            
                            if idsData[0] == userModel.userChatId {
                                
                                recentId = item.document.data()["recentId"] as! String
                                
                                print("chat vc recentId  = ", recentId)
                                
                                if recentId != "" {
                                    doGetChatData()
                                    break
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
    
    }

    func doGetChatData() {
        var qurery : Query!
     // showProgress()
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
        } else {
            
            qurery = Firestore.firestore().collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document(recentId).collection(recentId).order(by: "timeStamp").limit(to: 500)
            
            
        }
//        qurery.addSnapshotListener(includeMetadataChanges: false) { (data, error) in
//
//            print("datachaneg relat time" ,  data?.documents[0].data())
//
//        }
        
        /*qurery.getDocuments {[self] (spanshot, error) in
            if error != nil {
                return
            }
            for item in spanshot!.documentChanges {
                let itemMode = try? item.document.data(as: ModelChat.self)
                chatData.append(itemMode!)
            }
            
            tbvData.reloadData()
            
        }*/
        
           
        listener =    qurery.addSnapshotListener { [self] (spanshot, error) in
            
            if error != nil {
                return
            }
            
           
            if !spanshot!.isEmpty {
                lbStartChat.isHidden = true
                for item in spanshot!.documentChanges {
                   
    //                print("item  type  hghg" )
    //                let itemMode = try? item.document.data(as: ModelChat.self)
    //                chatData.append(itemMode!)
                    
                    
                    if item.type == .added {
                      //  print("item  type  added" )
                        let itemMode = try? item.document.data(as: ModelChat.self)
                        chatData.append(itemMode!)

                    } else  if item.type == .modified {
                     //   print("item  type  modified" )
                       // let itemMode = try? item.document.data(as: ModelChat.self)
                       // chatData.append(itemMode!)
                    }  else  if item.type == .removed {
                       // print("item  type  removed" )
                        
                    }
                    
                   
                }
                tbvData.reloadData()
                scrollToBottom(animated: true)
            } else {
                lbStartChat.isHidden = false
            }
            
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    private func scrollToBottom(animated : Bool) {
        
        if chatData.count > 6 {
            DispatchQueue.main.async { [self] in
                tbvData.scrollToRow(at: IndexPath(row: chatData.count - 1, section: 0), at: .top, animated: animated)
            }
        }
        
    }
    
    private func doSendData(msg : String  , type : String) {
        print("doSendData")
        
      
        
        let chatId = db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document().documentID
        var model =  ModelChat()
        
        model.chatId = chatId
        model.societyId = doGetLocalDataUser().societyID ?? ""
        model.msgBy = userChatId() 
        model.senderName = doGetLocalDataUser().userFullName ?? ""
        model.msgFor = userModel.userChatId ?? ""
        model.msgType = type
        model.msgImg = ""
        model.msgData = msg
        model.msgStatus = StringConstants.MSG_SENDED
        model.msgDelete = ""
        model.msgDate = currentDate()
        model.isUploading = false
        model.senderId = ""
        model.senderProfile = ""
        model.chatIdReply = ""
        model.replyMsg = ""
        model.replyMsgImg = ""
        model.replyMsgType = ""
        model.replyUserName = ""
        model.file_original_name = ""
        model.location_lat_long = ""
        model.timeStamp = currentDate()
        
        
        //MARK:-please check come from servicer provider is pending
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
        } else {
            do {
                try  db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document(recentId).collection(recentId).document(chatId).setData(from: model) { (error) in
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("Added ")
                }
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
        
    }
    
    
    private func doSendDataDoc(msg : String  , type : String,imageUrl : String) {
        print("doSendData")
        
      
        
        let chatId = db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document().documentID
        var model =  ModelChat()
        
        model.chatId = chatId
        model.societyId = doGetLocalDataUser().societyID ?? ""
        model.msgBy = userChatId()
        model.senderName = doGetLocalDataUser().userFullName ?? ""
        model.msgFor = userModel.userChatId ?? ""
        model.msgType = type
        model.msgImg = imageUrl
        model.msgData = msg
        model.msgStatus = StringConstants.MSG_SENDED
        model.msgDelete = ""
        model.msgDate = currentDate()
        model.isUploading = false
        model.senderId = ""
        model.senderProfile = ""
        model.chatIdReply = ""
        model.replyMsg = ""
        model.replyMsgImg = ""
        model.replyMsgType = ""
        model.replyUserName = ""
        model.file_original_name = ""
        model.location_lat_long = ""
        model.timeStamp = currentDate()
        
        
        //MARK:-please check come from servicer provider is pending
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
        } else {
            do {
                try  db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document(recentId).collection(recentId).document(chatId).setData(from: model) { (error) in
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("Added ")
                }
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
        
    }
    private func doSendDataLocation(latalong : String ,address : String , type : String) {
        print("doSendData")
        
      
        
        let chatId = db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document().documentID
        var model =  ModelChat()
        
        model.chatId = chatId
        model.societyId = doGetLocalDataUser().societyID ?? ""
        model.msgBy = userChatId()
        model.senderName = doGetLocalDataUser().userFullName ?? ""
        model.msgFor = userModel.userChatId ?? ""
        model.msgType = type
        model.msgImg = ""
        model.msgData = address
        model.msgStatus = StringConstants.MSG_SENDED
        model.msgDelete = ""
        model.msgDate = currentDate()
        model.isUploading = false
        model.senderId = ""
        model.senderProfile = ""
        model.chatIdReply = ""
        model.replyMsg = ""
        model.replyMsgImg = ""
        model.replyMsgType = ""
        model.replyUserName = ""
        model.file_original_name = ""
        model.location_lat_long = latalong
        model.timeStamp = currentDate()
        
        
        //MARK:-please check come from servicer provider is pending
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
        } else {
            do {
                try  db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Chat").document(recentId).collection(recentId).document(chatId).setData(from: model) { (error) in
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("Added ")
                }
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
        
    }
  
    func doDeleteMsg(modelChat:ModelChat) {
        
        
    }
    
    func layoutTableView() {

        let widthView    = view.frame.size.width
        let heightView    = view.frame.size.height

        let leftSafe    = view.safeAreaInsets.left
        let rightSafe    = view.safeAreaInsets.right

       // let heightInput = messageInputBar.bounds.height
        let heightInput = CGFloat(40)

        let widthTable = widthView - leftSafe - rightSafe
        let heightTable = heightView - heightInput - heightKeyboard

        tbvData.frame = CGRect(x: leftSafe, y: 0, width: widthTable, height: heightTable)
    }
    //TODO: keyboard event
    @objc  func keyboardWillShow(sender: NSNotification) {
        if (heightKeyboard != 0) { return }

        keyboardWillShowB = true
        if let info = sender.userInfo {
            if let keyboard = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                    DispatchQueue.main.async(after: duration) {
//                        if (self.keyboardWillShow) {
//                            self.heightKeyboard = keyboard.size.height
//                            self.layoutTableView()
//                            self.scrollToBottom(animated: true)
//                        }
//                    }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // your code here
                    if (self.keyboardWillShowB) {
                        self.heightKeyboard = keyboard.size.height
                       // self.layoutTableView()
                        self.conBottomMsgView.constant = keyboard.size.height
                        self.scrollToBottom(animated: true)
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        print("keyboardWillHide : -- \(keyboardHeight)")
        
        
        heightKeyboard = 0
        keyboardWillShowB = false
        self.conBottomMsgView.constant = 0
        //layoutTableView()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
          self.conBottomMsgView?.constant = 0.0
        } else {
          self.conBottomMsgView?.constant = endFrame?.size.height ?? 0.0
        }

        UIView.animate(
          withDuration: duration,
          delay: TimeInterval(0),
          options: animationCurve,
          animations: { self.view.layoutIfNeeded() },
          completion: nil)
      
   }
    //end
    func currentDate() -> String{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formater.string(from: Date())
    }
    
    func currentDate() -> Date {
        let timestamp = NSDate().timeIntervalSince1970
        
        let myTimeInterval = TimeInterval(timestamp)
        return  NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval)) as Date
    }
    
    func watchUserStatus(userChatId: String) {
        
        if sendTo == StringConstants.CHAT_WITH_GATEKEEPER {
            // gard
        } else  if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            // service provder
        } else {
            // user
            
            listener = db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Members").document(userChatId).addSnapshotListener({ (snapShot, error) in
                
                if error != nil {
                    return
                }
                
                if snapShot?.exists != nil && ((snapShot?.exists) != nil) {
                    if snapShot?.data() != nil {
                        let isOnline = snapShot?.data()!["online"] as! Bool
                        
                        if isOnline {
                            self.lbStatus.text = "Online"
                        } else {
                            let dateS = snapShot?.data()!["lastSeen"] as! String
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            self.lbStatus.text = formatter.date(from: dateS)!.getElapsedInterval()
                            
                        }
                    }
                  
                }
                
            })
            
        }
        
    }
    
    func doAddRecentUser(msg : String  , type : String , isDocUpload : Bool , imageUrl : String ) {
        recentId = userChatId() + userModel.userChatId
        
        
        var recentmodel = RecentdModel()
        recentmodel.recentId = recentId
        if type == StringConstants.MSG_TYPE_LOCATION {
            recentmodel.recentMsg = "Location"
        } else if type == StringConstants.MSG_TYPE_CONTACT {
            recentmodel.recentMsg = "Contact"
        } else {
            recentmodel.recentMsg = msg
        }
        
        recentmodel.recentMsgDate = currentDate()
        recentmodel.recentMsgSenderId = userChatId()
        recentmodel.recentCreatedById = userChatId()
        recentmodel.recentMsgSenderName = doGetLocalDataUser().userFullName ?? ""
        recentmodel.societyId = doGetLocalDataUser().societyID ?? ""
        recentmodel.single = true
        var users = [String]()
        users.append(userModel.userChatId)
        users.append(userChatId())
        recentmodel.userChatIds = users
        recentmodel.withChat = userModel.userType
        recentmodel.sentTo = sendTo
        
        var typeData = [TypeData]()
        var unReadData = [UnReadData]()
        typeData.append(TypeData(userChatId: userMyModel.userChatId, typing: false))
        
        unReadData.append(UnReadData(userChatId: userModel.userChatId, countUnread: "0"))
        unReadData.append(UnReadData(userChatId: userMyModel.userChatId, countUnread: "0"))
        
        recentmodel.typeData = typeData
        recentmodel.unReadData = unReadData
        
        var userDataList = [MemberModelChat]()
        userDataList.append(userModel)
        userDataList.append(userMyModel)
        
        recentmodel.userDataList = userDataList
        
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
            
        } else {
            //
            do {
                try  db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").document(recentId).setData(from: recentmodel) { [self] (error) in
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    doGetChatData()
                    if isDocUpload {
                        doSendDataDoc(msg: msg, type: type, imageUrl: imageUrl)
                    } else {
                        
                        if type == StringConstants.MSG_TYPE_LOCATION {
                            
                        } else{
                            doSendData(msg: msg, type: type)
                        }
                    }
                   
                   
                    print("Added ")
                }
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
        
    }
    
     override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // TODO:- this write for send notification
    func doSendNotification() {
        
//        requrest.sendPushNotification(title: "ios title", body: "body title", device: data.token) { (json, error) in
//
//
//
//        }
        
    }
    
    func typingListner() {
        
        if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
            
            
        } else {
            listener = db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").document(recentId).addSnapshotListener({ [self] (snapShot, error) in
                
                if error != nil {
                    return
                }
                
                
                if ((snapShot?.exists) != nil) {
                    
                    let recentChat = try? snapShot!.data(as: RecentdModel.self)
                  
                    if recentChat != nil && recentChat?.typeData != nil  {
                        
                        for item in recentChat?.typeData ?? [TypeData]() {
                            
                            if item.userChatId == userModel.userChatId && item.typing {
                                lbTyping.text = "\(userModel.userName ?? "") is typing"
                            } else {
                                lbTyping.text = ""
                            }
                        }
                     }
                 
                    if recentChat?.recentBlockById != nil {
                        let recentBlockById =  recentChat?.recentBlockById
                        
                        if  recentBlockById == userModel.userChatId {
                            viewMore.isHidden = true
                            viewMainInputview.isHidden = true
                            lbBlockMsg.text = "\(userModel.userName ?? "") blocked you"
                            lbBlockMsg.isHidden = false
                        } else  if  recentBlockById == userChatId() {
                            blockString = "unblock"
                            viewMore.isHidden = false
                            viewMainInputview.isHidden = true
                            strCloseConversation = "start conversation"
                            if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
                                lbBlockMsg.text = "You closed conversation with \(userModel.userName ?? "")"
                               
                            } else {
                                lbBlockMsg.text = "You blocked \(userModel.userName ?? "")"
                            }
                            lbBlockMsg.isHidden = false
                        } else {
                            blockString = "block"
                            strCloseConversation = "close Conversation"
                            viewMore.isHidden = false
                            viewMainInputview.isHidden = false
                            lbBlockMsg.text = ""
                            lbBlockMsg.isHidden = true
                        }
                        
                    } else {
                        blockString = "block"
                        strCloseConversation = "close Conversation"
                        viewMore.isHidden = false
                        viewMainInputview.isHidden = false
                        lbBlockMsg.text = ""
                        lbBlockMsg.isHidden = true
                    }
                    
                }
            })
            
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
       
        if tfMessage.text.isEmpty {
            conHeightTextview.constant = 40
            frame.size.height = 32
            self.tfMessage.frame = frame
            return
        }
        
        if  frame.size.height < 100 {
            if frame.size.height > 40 {
                self.tfMessage.frame = frame
                self.conHeightTextview.constant = frame.size.height + 8
            } else {
                conHeightTextview.constant = 40
                frame.size.height = 32
                self.tfMessage.frame = frame
            }
        }
    }
}
extension ChatRoomVC:UITableViewDataSource,UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = chatData[indexPath.row]
        
        
        if item.msgBy == userChatId() {
            // my chat show right side data
            
            
            
            if item.msgType == StringConstants.MSG_TYPE_TEXT {
                //text chat msg
                let cell = tableView.dequeueReusableCell(withIdentifier: CellFileName.itemCellSend, for: indexPath) as! SendChatCell
               
                cell.selectionStyle = .none
                
                let contents = chatDataSelectDelete.contains(where: {$0.chatId == item.chatId})
                
                if contents {
                    cell.viewDelete.isHidden = false
                } else {
                    cell.viewDelete.isHidden = true
                }
                
                if item.msgDelete != nil && item.msgDelete == userChatId() {
                    cell.lbMessage.text = "You deleted this message"
                    cell.lbTime.text = ""
                    cell.imgTick.isHidden = true
                    cell.bReadMore.isHidden = true
                }else {
                    cell.lbMessage.text = item.msgData
                    cell.lbTime.text = item.timeStamp.getElapsedInterval()
                    
                    if item.msgStatus == StringConstants.MSG_SENDED {
                        cell.imgTick.isHidden = false
                        cell.imgTick.image = UIImage(named: "Singletick")
                    } else  if item.msgStatus == StringConstants.MSG_READED  {
                        cell.imgTick.isHidden = false
                        cell.imgTick.image = UIImage(named: "double-tick-indicator-2")
                    } else {
                        cell.imgTick.isHidden = true
                    }
                    
                    
                }
                
                return cell
                
            }
          
            
            
    
            return UITableViewCell()
           
        } else {
            // user side left side
            let cell = tableView.dequeueReusableCell(withIdentifier: CellFileName.itemCellRecieved, for: indexPath) as! RecievedCell
            cell.lbMessage.text = item.msgData
            cell.lbTime.text = item.timeStamp.getElapsedInterval()
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if   isSelectChat {
            
            var isAdd = true
            for (index,item) in  chatDataSelectDelete.enumerated() {
                
                if item.chatId == chatData[indexPath.row].chatId {
                    chatDataSelectDelete.remove(at: index)
                    isAdd = false
                    deleteCount -= 1
                    break
                }
            }
            
            if isAdd {
                chatDataSelectDelete.append(chatData[indexPath.row])
                deleteCount += 1
            }
            lbDeletCount.text = "\(deleteCount)"
            
            if deleteCount == 0 {
                self.resetDeleteView()
            }
            tbvData.reloadData()
           // self.tbvData.reloadRows(at: [indexPath], with: .none)
        }
    }
  
}
extension ChatRoomVC: AppDialogDelegate , OnTapMediaSelect{
   
    
  
    
   
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        
        dismiss(animated: true) {  [self] in
            if blockString == "block" {
                doUpdateBlockAndType(blockById: userChatId(), isBlocking: true)
            } else {
                doUpdateBlockAndType(blockById: "", isBlocking: true)
            }
            
        }
        
    }
    
    
    func doUpdateBlockAndType(blockById : String ,  isBlocking : Bool) {
        
        if isBlocking {
            if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
                
                let param = ["recentBlockById":blockById]
                db.collection("SP_Recent").document(recentId).updateData(param) { (error)  in
                    
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("SP_Recent block")
                }
            } else {
               
                let param = ["recentBlockById":blockById]
                
                db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").document(recentId).updateData(param) { (error)  in
                    
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("block tpe ")
                }
               
            }
        } else {
           /* let param = ["typeData" : ["typing":true,
                                       "userChatId":userMyModel.userId ?? ""]] as [String : Any]*/
            
            if sendTo == StringConstants.CHAT_WITH_SERVICE_PROVIDER {
                db.collection("SP_Recent").document(recentId).updateData([
                    "typeData": FieldValue.arrayRemove(["typing","userChatId"])
                ]) { (error)  in
                    
                     if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("type update")
                }
            } else {
               
                
                db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").document(recentId).updateData([
                    "typeData": FieldValue.arrayRemove(["typing","userChatId"])
                ]) { (error)  in
                    
                    
                    if let error = error {
                        print("add error \(error)")
                        return
                    }
                    
                    print("type update")
                }
            }
            
        }
        
      
        
        
    }
    
    
    // TODO : here is media delegate
    func onSuccessMediaSelect(image: [UIImage], fileImage: [URL]) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idSendMultimediaChatVC") as! SendMultimediaChatVC
        vc.slider = image
        //  vc.user_id = use
        vc.fileImage = fileImage
        // vc.chatVC = self
        vc.onTapMediaSelect = self
        pushVC(vc: vc)
    }
    
    func onSucessUploadingFile(fileUrl: [String], msg: String) {
        
        for (index,item) in fileUrl.enumerated(){
            
            if recentId == "" {
                if index == 0 {
                    doAddRecentUser(msg: msg, type: StringConstants.MSG_TYPE_IMAGE,isDocUpload: true,imageUrl: item)
                } else {
                    doAddRecentUser(msg: "", type: StringConstants.MSG_TYPE_IMAGE,isDocUpload: true,imageUrl: item)
                }
                
            } else {
                if index == 0 {
                    doSendDataDoc(msg: msg, type: StringConstants.MSG_TYPE_IMAGE, imageUrl: item)
                } else {
                    doSendDataDoc(msg: "", type: StringConstants.MSG_TYPE_IMAGE, imageUrl: item)
                }
            }
            
            
        }
        
        
        
    }
    
    func selectDocument(fileArray: [URL], type: String, file_duration: String) {
        showProgress()
        let  paramsSend = ["addChatDoc":"addChatDoc",
                           "society_id":doGetLocalDataUser().societyID!,
                           "user_id":doGetLocalDataUser().userID!]
        
        print("param" , paramsSend)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartWithFileArryaImage(serviceName: ServiceNameConstants.chat_controller_firebase, parameters: paramsSend,  doc_array: fileArray, paramName: "chat_doc[]"  ,compression:  0.3 ) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
               
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)

                    if response.status == "200" {
                        
                        for item in response.image_array{
                            
                            if recentId == "" {
                                doAddRecentUser(msg: "", type: StringConstants.MSG_TYPE_FILE,isDocUpload: true,imageUrl: item)
                            } else {
                                doSendDataDoc(msg: "", type: StringConstants.MSG_TYPE_FILE, imageUrl: item)
                            }
                        }
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
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
        doSendDataLocation(latalong: location, address: address, type: StringConstants.MSG_TYPE_LOCATION)
    }
       //
    
    
}
extension ChatRoomVC : CNContactPickerDelegate,CNContactViewControllerDelegate {
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
             primaryPhoneNumberStr = firstPhoneNumber.stringValue
        }
            
      

        let dataS = userName + "@" + primaryPhoneNumberStr
       // doSendContact(message: dataS, msgType: StringConstants.MSG_TYPE_CONTACT)
       // doSendData(msg: dataS, type: StringConstants.MSG_TYPE_CONTACT)
        if recentId == "" {
            doAddRecentUser(msg: dataS, type: StringConstants.MSG_TYPE_CONTACT,isDocUpload: false,imageUrl: "")
        } else {
            doSendData(msg: dataS, type: StringConstants.MSG_TYPE_CONTACT)
        }
    }
}
struct CellFileName {
    static let itemCellRecieved = "RecievedCell"
    static let itemCellSend = "SendChatCell"
    static let itemCellDate = "DateFormChat"
    static let itemCellRecievedMultimedia = "RecievedMultimediaCell"
    static let itemCellSendMultimedia = "SendMultimediaCell"
    static let itemCellRecievedContactCell = "RecievedContactCell"
    static let itemCellSendContactCell = "SendContactCell"
    static let itemCellRecievedDocumentCell = "RecievedDocumentCell"
    static let itemCellSendDocumentCell = "SendDocumentCell"
    static let itemCellRecievedLocationCell = "RecievedLocationCell"
    static let itemCellSendLocationCell = "SendLocationCell"
    static let itemCellSendAudioCell = "SendAudioCell"
    static let itemCellRecievedAudioCell = "RecievedAudioCell"
    static let itemCellSentVideoCell = "SentVideoChatCell"
    static let itemCellReceivedVideoCell = "ReceivedVideoChatCell"
 
}
extension Date {

    func getElapsedInterval() -> String {
        
        let dateFormmerter = DateFormatter()
        
        dateFormmerter.dateFormat = ""
        let timestamp = NSDate().timeIntervalSince1970
        
        let myTimeInterval = TimeInterval(timestamp)
        let date =   NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval)) as Date
        
        let interval = Calendar.current.dateComponents([.year, .month, .day,.minute,.second], from: self, to: date)
        
        
        if let year = interval.year, year >= 2 {
            return "\(year) years ago"
        } else if let year = interval.year, year >= 1 {
            return "Last year"
        } else if let month = interval.month, month >= 2 {
            return "\(month) months ago"
        } else if let month = interval.month, month >= 1 {
            return "Last month"
        }else if let weekOfYear = interval.weekOfYear, weekOfYear >= 2 {
            return "\(weekOfYear) weeks ago"
        } else if let weekOfYear = interval.weekOfYear, weekOfYear >= 1 {
            return "Last week"
        }else if let day = interval.day, day >= 2 {
            return "\(day) days ago"
        } else if let day = interval.day, day >= 1 {
            return "Yesterday"
        }else if let hour = interval.hour, hour >= 2 {
            return "\(hour) hours ago"
        } else if let hour = interval.hour, hour >= 1 {
            return "1 hour ago"
        }else if let minute = interval.minute, minute >= 2 {
            return "\(minute) minutes ago"
        } else if let minute = interval.minute, minute >= 1 {
            return "1 minute ago"
        }else if let second = interval.second, second >= 3 {
            return "\(second) seconds ago"
        } else {
            return "Just now"
        }
        
//        if let year = interval.year, year > 0 {
//            return year == 1 ? "\(year)" + " " + "year ago" :
//                "\(year)" + " " + "years ago"
//        } else if let month = interval.month, month > 0 {
//            return month == 1 ? "\(month)" + " " + "month ago" :
//                "\(month)" + " " + "months ago"
//        } else if let day = interval.day, day > 0 {
//            return day == 1 ? "\(day)" + " " + "day ago" :
//                "\(day)" + " " + "days ago"
//        } else {
//            return "a moment ago"
//        }
           
    }
    
    
    
    
}



struct RecentdModel : Codable {
    var recentId : String? = ""
    var recentMsg : String? = ""
    var recentGroupName : String? = ""
    var recentGroupProfile : String? = ""
    var recentMsgDate : String? = ""
    var recentMsgSenderId : String? = ""
    var recentMsgSenderName : String? = ""
    var recentMsgDeletedById : String? = ""
    var recentBlockById : String? = ""
    var recentTypeById : String? = ""
    var recentCreatedById : String? = ""
    var sentTo : String? = ""
    var societyId : String? = ""
    var single : Bool? = false
    var withChat : String? = ""
    var userChatIds = [String]()
    var userSilentSetting = [String]()
    var userDataList = [MemberModelChat]()
    var typeData = [TypeData]()
    var unReadCount : String? = ""
    var unReadData = [UnReadData]()
    var mTimestamp : Date? = Date()
}
