//
//  SendMultimediaChatVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 10/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SendMultimediaChatVC: BaseVC , UITextViewDelegate{

    @IBOutlet weak var lbCountImage: UILabel!
    @IBOutlet weak var pager: iCarousel!
    @IBOutlet weak var heigthConTextview: NSLayoutConstraint!
   @IBOutlet weak var tfMessage: UITextView!
   
    @IBOutlet weak var bottomConView: NSLayoutConstraint!
    var chatVC : ChatVC!
    var slider = [UIImage]()
    var user_id = ""
    var msg_data = [String]()
     let hint = "Type Here"
    var index = 1
    var isOneToOne = true
    var groupChatVC : GroupChatVC!
    var group_id = ""
    var group_name = ""
    
    var fileImage = [URL]()
    var onTapMediaSelect : OnTapMediaSelect!
    var member_count = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pager.isPagingEnabled = true
        pager.isScrollEnabled = true
        pager.bounces = false
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
        
        for _ in 0...slider.count {
            msg_data.append("")
        }
        hideKeyBoardHideOutSideTouch()
        doneButtonOnKeyboard(textField: tfMessage)
        tfMessage.delegate = self
        tfMessage.text = hint
        tfMessage.textColor = .lightGray
        doSetImageCount(current: String(index))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
       
 }
    func doSetImageCount(current : String) {
        lbCountImage.text = current + "/" + String(slider.count)
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickSendMsg(_ sender: Any) {
        
        
        if tfMessage.text == hint {
            tfMessage.text = ""
        }
        msg_data[0] =  tfMessage.text!
              
        if isOneToOne {
            if onTapMediaSelect != nil {
                sendFileCommon()
            } else {
                doSendOneToOneChat()
            }
            
        } else {
            doSeendGroupChat()
        }
    }
    
    func doSendOneToOneChat() {
        showProgress()
//        let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
        
          let unit_name =  doGetLocalDataUser().userFullName!
                        print("is member")
        let  paramsSend = ["addChatWithDoc":"addChatWithDoc",
                           "society_id":doGetLocalDataUser().societyID!,
                           "msg_by":doGetLocalDataUser().userID!,
                           "msg_for":user_id,
                           "unit_name":unit_name,
                           "sent_to":"0",
                           "user_profile":doGetLocalDataUser().userProfilePic!,
                           "user_name":doGetLocalDataUser().userFullName!,
                           "block_name":doGetLocalDataUser().company_name ?? "",
                           "user_mobile":doGetLocalDataUser().userMobile!,
                           "public_mobile" : doGetLocalDataUser().publicMobile!,
                           "msgType" : StringConstants.MSG_TYPE_IMAGE] as [String : Any]
        
                    // "msg_data[]": msg_data,
                    
                    print("param" , paramsSend)
                    let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartWithParam(serviceName: ServiceNameConstants.chatController, parameters: paramsSend, doc_array: slider, fileNameParam: "chat_doc[]", compression: 0.3,  mesgData: msg_data) { (json, error) in
                        
                        if json != nil {
                            self.hideProgress()
                            do {
                                let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                                
                                
                                if response.status == "200" {
                                 self.chatVC.doGetChat(isRefresh: false, isRead: "0")
                                 self.doPopBAck()
                                }else {
                                    self.showAlertMessage(title: "Alert", msg: response.message)
                                }
                            } catch {
                                print("parse error")
                            }
                        }
                    }
    }
    
    func doSeendGroupChat() {
           showProgress()
//           let unit_name = doGetLocalDataUser().userFullName + " (" +  doGetLocalDataUser().blockName.uppercased() + "-" + doGetLocalDataUser().unitName + ")"
         let unit_name =  doGetLocalDataUser().userFullName!
                           print("is member")
        let paramsSend = ["addChatWithDoc":"addChatWithDoc",
                          "society_id":doGetLocalDataUser().societyID!,
                          "msg_by":doGetLocalDataUser().userID!,
                          "msg_for":unit_name,
                          "sent_to":"0",
                          "unit_name":unit_name,
                          "unit_id":doGetLocalDataUser().unitID!,
                          "group_id":group_id,
                          "group_name":group_name,
                          "msgType" : StringConstants.MSG_TYPE_IMAGE,
                          "member_count": member_count]
        
        // "msg_data[]": msg_data,
                       
                       print("param" , paramsSend)
                       let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartWithParam(serviceName: ServiceNameConstants.chat_controller_group, parameters: paramsSend, doc_array: slider, fileNameParam: "chat_doc[]", compression: 0.3,  mesgData: msg_data) { (json, error) in
                           
                           if json != nil {
                               self.hideProgress()
                               do {
                                   let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                                   
                                   
                                   if response.status == "200" {
                                    self.groupChatVC.doGetChat(isRefresh: false)
                                    self.doPopBAck()
                                   }else {
                                       self.showAlertMessage(title: "Alert", msg: response.message)
                                   }
                               } catch {
                                   print("parse error")
                               }
                           }
                       }
       }
    func textViewDidChange(_ textView: UITextView) {
          var frame = textView.frame
          frame.size.height = textView.contentSize.height
           
           if  frame.size.height < 100 {
               if frame.size.height > 24 {
                   self.tfMessage.frame = frame
                   self.heigthConTextview.constant = frame.size.height
               } else {
                    self.heigthConTextview.constant = 26
               }
           }
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
              if text.count > 100 {
               textView.text = String(text.prefix(100))
               }
               return textView.text.count + (text.count - range.length) <= 100
           }
           
         
           let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
           let numberOfChars = newText.count
           return numberOfChars <= 100    //  Limit Value
       }
    @objc  func keyboardWillShow(sender: NSNotification) {
           let userInfo:NSDictionary = sender.userInfo! as NSDictionary
           let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
           let keyboardRectangle = keyboardFrame.cgRectValue
           let keyboardHeight = keyboardRectangle.height
           
           if keyboardHeight > 304 {
               bottomConView.constant = keyboardHeight - 22
                  
           } else {
               bottomConView.constant = keyboardHeight + 10
            }
           print("keyboard hh == " ,  keyboardRectangle.height)
         /*  UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
           self.view.layoutIfNeeded()
           }, completion: nil)*/
           
           UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.view.layoutIfNeeded()
           })
          
       }
       
    @objc func keyboardWillHide(sender: NSNotification) {
        bottomConView.constant = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
    }
    
    func sendFileCommon() {
        showProgress()
            
                     
        let  paramsSend = ["addChatDoc":"addChatDoc",
                           "society_id":doGetLocalDataUser().societyID!,
                           "user_id":doGetLocalDataUser().userID!]
        
                    // "msg_data[]": msg_data,
                    
                    print("param" , paramsSend)
                    let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartWithParam(serviceName: ServiceNameConstants.chat_controller_firebase, parameters: paramsSend, doc_array: slider, fileNameParam: "chat_doc[]", compression: 0.3,  mesgData: msg_data) { (json, error) in
                        
                        if json != nil {
                            self.hideProgress()
                            do {
                                let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                                
                                
                                if response.status == "200" {
                                    self.onTapMediaSelect.onSucessUploadingFile(fileUrl: response.image_array, msg: self.tfMessage.text ?? "")
                               //  self.chatVC.doGetChat(isRefresh: false, isRead: "0")
                                 self.doPopBAck()
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
extension SendMultimediaChatVC : iCarouselDelegate,iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return slider.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
         viewCard.frame = pager.frame
        viewCard.ivImage.image = slider[index]
        viewCard.ivImage.contentMode = .scaleAspectFit
           
        return viewCard
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if (option == .spacing) {
            return value * 1.1
        }
        return value
        
    }

    func carouselDidScroll(_ carousel: iCarousel) {
        index = carousel.currentItemIndex + 1
        doSetImageCount(current: String(index))
    }
}
