//
//  CommentsVC.swift
//  Finca
//
//  Created by harsh panchal on 20/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol OnChangeCount {
    func doChangeCommentCount(index : Int , commentArray : [CommentModel] , comment_status  :String)
}
class CommentsVC: BaseVC ,UITextViewDelegate{

    @IBOutlet weak var tfComment: UITextView!
    var commentList = [CommentModel]()
    @IBOutlet weak var tbvComment: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    var itemCell = "CommentCell"
    var feedId : String!
    var userID : String!
    var selectedIndex = -1
    var selectIndexPath = IndexPath()
    // for the Emoji
    var index = 0
    var comment_status = ""
    @IBOutlet weak var conHeightTextView: NSLayoutConstraint!
    
    var heightKey = 0.0
    var hint = ""
    var delegate : OnChangeCount!
   // @IBOutlet weak var heightConTbale: NSLayoutConstraint!
    
    //  @IBOutlet weak var tbvComment: CustomTableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var viewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var bottomConstEditView: NSLayoutConstraint!
    @IBOutlet weak var viewSendButton: UIView!
    var isSendComment = true
    var parent_comments_id = ""
    var emoji_category  =  [EmojiCategory]()
    var isKeybordOpen = false
    var isDeleteMainComment = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfComment.delegate = self
        //        doneButtonOnKeyboard(textField: tfComment)
       // hideKeyBoardHideOutSideTouch()
//        tfComment.text = "Add New Comments.."
//        tfComment.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvComment.register(nib, forCellReuseIdentifier: itemCell)
        tbvComment.delegate = self
        tbvComment.dataSource = self
        tbvComment.estimatedRowHeight = 50
        tbvComment.rowHeight = UITableView.automaticDimension
        tbvComment.sectionHeaderHeight = UITableView.automaticDimension
        tbvComment.estimatedSectionHeaderHeight = 50
        tbvComment.keyboardDismissMode = .interactive
        tfComment.autocorrectionType = .yes
        
      //  tbvComment.isScrollEnabled = false
        lbTitle.text = doGetValueLanguage(forKey: "comments")
        lblNoData.text = doGetValueLanguage(forKey: "be_the_first_to_comment_on_post")
        addRefreshControlTo(tableView: tbvComment)
        
       // tfComment.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
        tfComment.delegate = self
       // tfComment.text = hint
       // tfComment.textColor = .lightGray
        hint =   doGetValueLanguage(forKey: "add_a_comment")
        tfComment.placeholder = hint
        tfComment.placeholderColor = .lightGray
        // tbvComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
       // self.heightConTbale.constant = 300
        
       // tbvComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        doFatchNewData()
        
        
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
//        dismissKeyboard(sender)
//        viewEmoji.isHidden = true
//        conHeightEmoji.constant = CGFloat(0)
        if sender.state == .ended {
            dismissKeyboard(sender)
           
        }
        sender.cancelsTouchesInView = false
    }
    
  
    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        
        doFatchNewData()
    }
    
    func doFatchNewData() {
        showProgress()
        let params = ["getComments":"getComments",
                      "feed_id":feedId!,
                      "user_id":userID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
            
            self.hideProgress()
            
            if json != nil {
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from:json!)
                    if response.status == "200" {
                        self.commentList = response.comment
                        self.tbvComment.reloadData()

                    }else {
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.viewBottomSpace.constant == 0 {
                self.viewBottomSpace.constant += keyboardSize.height
            }
            
            print("hhh" ,  keyboardSize.height )
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        //  NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    @objc  func keyboardWillShow(sender: NSNotification) {
        isKeybordOpen = true
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
        /*  UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil)*/
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
       // scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeybordOpen = false
         bottomConstEditView.constant = 0
               UIView.animate(withDuration: 0.2, animations: { () -> Void in
                   self.view.layoutIfNeeded()
               })
    }
    
    func doAddFeedComments(msg:String) {
        //        showProgress()
        var params : [String : String]
        if isSendComment {
            params = ["key":ServiceNameConstants.API_KEY,
                      "commentFeed":"commentFeed",
                      "feed_id":feedId!,
                      "msg":msg,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? ""]
            
        } else {
            // do Replay for comment
            params = ["key":ServiceNameConstants.API_KEY,
                      "commentFeed":"commentFeed",
                      "parent_comments_id" : parent_comments_id,
                      "feed_id":feedId!,
                      "msg":msg,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? ""]

        }

        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in

            //            self.hideProgress()

            if json != nil {
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from:json!)
                    if response.status == "200" {
                        // self.tfComment.text = "Add New Comments.."//
                        //   self.tfComment.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        // self.commentList.removeAll()
                        self.isSendComment = false
                        self.parent_comments_id = ""
                        self.viewSendButton.backgroundColor = UIColor(named: "ColorPrimary")
                       // self.hint = "Add a comment..."
                       // self.tfComment.text = self.hint
                       // self.tfComment.textColor = .lightGray
                        self.hint =   self.doGetValueLanguage(forKey: "add_a_comment")
                        self.tfComment.placeholder = self.hint
                        self.tfComment.placeholderColor = .lightGray
                        
                        self.commentList = response.comment
                        self.tbvComment.reloadData()
                        self.comment_status = "1"
                        //self.scrollToBottom()
                    }else {
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    

    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.commentList.count-1, section: 0)
            self.tbvComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        delegate.doChangeCommentCount(index: index, commentArray: commentList, comment_status: comment_status)
        self.navigationController?.popViewController(animated: true)
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



    func textViewDidBeginEditing(_ textView: UITextView) {
//          if textView.text == hint {
//              print("equoal")
//              textView.text = nil
//              textView.textColor = UIColor.black
//          } else {
//              print("not eq")
//          }
      }
      
      func textViewDidEndEditing(_ textView: UITextView) {
//          if textView.text.isEmpty {
//              textView.text = hint
//              textView.textColor = .lightGray
//          }
      }
    
    
    func doValidate() -> Bool{
        
        if tfComment.text == hint || tfComment.text == ""{
            self.showAlertMessage(title: "", msg: "Please add a comment First!!")
            return false
        }
        return true
    }
    
    @IBAction func btnPostComment(_ sender: UIButton) {
        if doValidate(){
            let msg = tfComment.text!
            tfComment.text = ""

            doAddFeedComments(msg:msg)
        }
    }
    
    @objc func doRemoveComment(_ sender:UIButton) {
        isDeleteMainComment = true
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete this comment?", style: .Delete , tag: 1)
               selectedIndex = sender.tag
      //  doDeleteComment(comments_id: commentList[index].commentsId!, index: index ,isSub: false , subIndex: 0, user_id: commentList[index].userId!)
    }


    @objc func onClickReply(_ sender:UIButton) {
        tfComment.text = ""
        self.hint = doGetValueLanguage(forKey: "add_comment_reply")
       // tfComment.text = hint
       // tfComment.textColor = .lightGray
        tfComment.placeholder = hint
        tfComment.placeholderColor = .lightGray
     //   textViewDidBeginEditing(tfComment)
        let index = sender.tag
        isSendComment = false
        parent_comments_id = commentList[index].commentsId!
        viewSendButton.backgroundColor = UIColor(named: "blue_600")
        tfComment.becomeFirstResponder()
    }
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

           // If updated text view will be empty, add the placeholder
           // and set the cursor to the beginning of the text view
           if updatedText.isEmpty {

               textView.text = hint
               textView.textColor = UIColor.lightGray

             //  textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
              textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
           }

           // Else if the text view's placeholder is showing and the
           // length of the replacement string is greater than 0, set
           // the text color to black then set its text to the
           // replacement string
            else if textView.textColor == UIColor.lightGray && !text.isEmpty {
               textView.textColor = UIColor.black
               textView.text = text
           }

           // For every other case, the text should change with the usual
           // behavior...
           else {
               return true
           }

           // ...otherwise return false since the updates have already
           // been made
           return false
        
        
    }*/
    
    func doDeleteComment(comments_id : String , index : Int , isSub : Bool , subIndex : Int , user_id : String) {
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "deleteComment":"deleteComment",
                      "comments_id":comments_id,
                      "user_id":user_id]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in

            self.hideProgress()

            if json != nil {
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from:json!)
                    if response.status == "200" {
                        if isSub {
                            self.commentList[index].sub_comment.remove(at: subIndex)
                        } else {
                            self.commentList.remove(at: index)
                        }

                        self.tbvComment.reloadData()

                    }else {

                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
     //   print("tableview height",self.tbvComment.contentSize.height)
//        if self.tbvComment.contentSize.height != 0.0{
//            tbvComment.setNeedsLayout()
//            tbvComment.layoutIfNeeded()
//          //  print("tableview height",self.tbvComment.contentSize.height)
//            self.heightConTbale.constant = self.tbvComment.contentSize.height
//        }
    }
}

extension CommentsVC : UITableViewDelegate ,UITableViewDataSource , onTapDeleteCommnet{
    
    
    func onTapDeletComnent(indexPath: IndexPath) {
        print("sub table click")
        isDeleteMainComment = false
        
        showAppDialog(delegate: self , dialogTitle: "", dialogMessage: "Do you want to delete this comment?", style: .Delete,tag: 0)
        //selectedIndex = indexPath.row
        selectIndexPath = indexPath
//        let item = commentList[indexPath.section].sub_comment[indexPath.row]
//        doDeleteComment(comments_id: item.commentsId, index: indexPath.section, isSub: true, subIndex: indexPath.row, user_id: item.userId)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentList.count == 0{
            self.lblNoData.isHidden = false
        }else{
            self.lblNoData.isHidden = true
        }
        return commentList[section].sub_comment.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("dddd " , commentList.count)
        return commentList.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let item = commentList[section]
        cell.lblCommentText.text = item.msg
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: item.userProfilePic ?? "", palceHolder: "user_default")
        cell.lblCommentatorName.text = item.userName + "(" + item.blockName + ")"
        cell.autoresizingMask = .flexibleHeight
        cell.lbDate.text = item.modifyDate
        if item.userId == doGetLocalDataUser().userID! || userID == doGetLocalDataUser().userID! {
            cell.bDelete.isHidden = false
            //            // cell.stackViewWidthConstraint.constant = 40
            cell.btnRemoveComment.tag = section
            cell.btnRemoveComment.addTarget(self, action: #selector(doRemoveComment(_:)), for: .touchUpInside)
            
        }else{
            cell.bDelete.isHidden = true
        }
        cell.viewReply.isHidden = false
        cell.bReply.tag = section
        cell.bReply.addTarget(self, action: #selector(onClickReply), for: .touchUpInside)
        cell.conWidthMainView.constant = 0
        cell.bDeleteSub.isHidden = true
        cell.bMemberDetails.isHidden = false
        cell.bMemberDetails.tag = section
        cell.bMemberDetails.addTarget(self, action: #selector(onTapMemberDetails(sender:)), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvComment.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! CommentCell
        
        let item = commentList[indexPath.section].sub_comment[indexPath.row]
        cell.lblCommentatorName.text = item.userName + "(" + item.blockName + ")"
        cell.selectionStyle = .none
        cell.lblCommentText.text = item.msg
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: item.userProfilePic, palceHolder: "user_default")
        
        
        cell.lbDate.text = item.modifyDate
        if item.userId == doGetLocalDataUser().userID! || userID == doGetLocalDataUser().userID! {
            cell.bDelete.isHidden = false
            cell.bDeleteSub.isHidden = false

        }else{
            cell.bDelete.isHidden = true
            cell.bDeleteSub.isHidden = true
        }
        cell.indexPath = indexPath
    cell.viewMain.clipsToBounds = true
        cell.onTapDeleteCommnet = self
        cell.conWidthMainView.constant = 60
        cell.bReply.tag = indexPath.row
        cell.bReply.addTarget(self, action: #selector(onClickReply), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MemberDetailsVC()
        vc.user_id = commentList[indexPath.section].sub_comment[indexPath.row].userId ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
        
    }
    
    @objc func onTapMemberDetails(sender : UIButton) {
        let vc = MemberDetailsVC()
        vc.user_id = commentList[sender.tag].userId ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
    }

}
extension CommentsVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag: Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) { [self] in
             //   let item = self.commentList[self.selectedIndex]
//                if item.userId == self.doGetLocalDataUser().userID! || self.userID == self.doGetLocalDataUser().userID!{
//                    self.doDeleteComment(comments_id: self.commentList[self.selectedIndex].commentsId!, index: self.selectedIndex ,isSub: false , subIndex: 0, user_id: self.commentList[self.selectedIndex].userId!)
//                }else{
//                    let data = self.commentList[self.selectedIndex].sub_comment[self.selectedIndex]
//                    self.doDeleteComment(comments_id: data.commentsId, index: self.selectedIndex, isSub: true, subIndex: self.selectedIndex, user_id: data.userId)
//                }
                
                   if tag == 1 {
                    //main coomet
                   // let item = self.commentList[self.selectedIndex]
                    self.doDeleteComment(comments_id: self.commentList[self.selectedIndex].commentsId!, index: self.selectedIndex ,isSub: false , subIndex: 0, user_id: self.commentList[self.selectedIndex].userId!)
                } else {
                    //sub comment
                    let data = self.commentList[self.selectIndexPath.section].sub_comment[self.self.selectIndexPath.row]
                    self.doDeleteComment(comments_id: data.commentsId, index: self.selectIndexPath.section, isSub: true, subIndex: self.selectIndexPath.row, user_id: data.userId)
                    
                }
                
            }
        }
    }
}
extension UITextView {

    func centerVertical() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}



