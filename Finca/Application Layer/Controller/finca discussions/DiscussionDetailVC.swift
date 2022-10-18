//
//  DiscussionDetailVC.swift
//  Finca
//
//  Created by harsh panchal on 28/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import EzPopup
import Lightbox
import SwiftUI
class DiscussionDetailVC: BaseVC {
    @IBOutlet weak var imgDiscussion: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var discussionData : DiscussionListModel!
    @IBOutlet weak var tbvCommentData: UITableView!
    @IBOutlet weak var tbvheight: NSLayoutConstraint!
    @IBOutlet weak var viewFab: UIView!
    @IBOutlet weak var viewFileAttachment: UIView!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblViewAttachedFile: UILabel!
    @IBOutlet weak var lblAddComment: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var lbNoCommentData: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var ivAttached: UIImageView!
    let documentInteractionController = UIDocumentInteractionController()
    var itemCell = "DiscussionCommentCell"
    var itemSubCell = "DiscussionSubCommentCell"
    var commentList = [CommentListModel](){
        didSet{
            self.tbvCommentData.reloadData()
        }
    }
    var initialLoad = true
    var discussion_forum_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvCommentData.register(nib, forCellReuseIdentifier: itemCell)
        tbvCommentData.delegate = self
        tbvCommentData.dataSource = self
        tbvCommentData.rowHeight = UITableView.automaticDimension
        tbvCommentData.estimatedRowHeight = 300
        documentInteractionController.delegate = self
        tbvCommentData.estimatedSectionHeaderHeight = 50
        tbvCommentData.sectionHeaderHeight = UITableView.automaticDimension
        lblScreenTitle.text = doGetValueLanguage(forKey: "discussion_details")
        lblViewAttachedFile.text = doGetValueLanguage(forKey: "view_file")
        lblAddComment.text = doGetValueLanguage(forKey: "add_comment")
        lbNoCommentData.text = doGetValueLanguage(forKey: "be_the_first_to_comment")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
    }

    override func fetchNewDataOnRefresh() {
        self.commentList.removeAll()
        self.doCallApi()
    }

    @IBAction func btnViewDiscussionDocument(_ sender: UIButton) {
        self.storeAndShare(withURLString: discussionData.discussionFile)
    }

    override func viewWillLayoutSubviews() {
        if self.tbvCommentData.contentSize.height != 0.0{
            tbvCommentData.setNeedsLayout()
            tbvCommentData.layoutIfNeeded()
            print("tableview height",self.tbvCommentData.contentSize.height)
            self.tbvheight.constant = self.tbvCommentData.contentSize.height
        }
    }

    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func doCallApi(){
        self.showProgress()
        let params = ["getDiscussionDetails":"getDiscussionDetails",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "discussion_forum_id":discussion_forum_id]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(DiscussionListResponse.self, from: Data!)
                    if response.status == "200"{

                        self.discussionData = response.discussion[0]
                        if self.discussionData.discussionFile == ""{
                            self.viewFileAttachment.isHidden = true
                        }else{
                            self.viewFileAttachment.isHidden = false
                            self.ivAttached.image =  self.doGetDocTypeImage(string: self.discussionData.discussionFile ?? "")
                        }
                        self.lblTitle.text = self.discussionData.discussionForumTitle
                        self.lblGroup.text = self.doGetValueLanguage(forKey: "group_colon") + " : " + self.discussionData.discussionForumFor
                        self.lblCreatedBy.text = self.discussionData.createdBy
                        self.lbDate.text = self.discussionData.createdDate ?? ""
                          
                        self.lblDescription.text = self.discussionData.discussionForumDescription
                        Utils.setImageFromUrl(imageView: self.imgProfile, urlString: self.discussionData.userProfile, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
                        if let imgUrl = self.discussionData.discussionPhoto{
                            if imgUrl.replacingOccurrences(of: " ", with: "") == "" {
                                self.imgHeight.constant = 0
                            }else{
                                self.imgHeight.constant = 150
                                Utils.setImageFromUrl(imageView: self.imgDiscussion, urlString: self.discussionData.discussionPhoto)
                            }
                            
                         }
                        
                        if let dataCommet = response.discussion[0].comment {
                            self.commentList = dataCommet
                            self.tbvCommentData.reloadData()
                            
                            if self.commentList.count < 2 {
                                self.lblCommentCount.text = String(self.commentList.count) + " " + self.doGetValueLanguage(forKey: "comment")
                            } else {
                                self.lblCommentCount.text = String(self.commentList.count) + " " + self.doGetValueLanguage(forKey: "comments")
                            }
                           
                        }
                        
                        if self.commentList.count > 0  {
                            self.lbNoCommentData.isHidden = true
                        } else {
                            self.lbNoCommentData.isHidden = false
                        }
                        

                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    @IBAction func btnAddComment(_ sender: UIButton) {

        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idAddCommentDialog")as! AddCommentDialog
        nextVC.commentType = .NewComment
        nextVC.context = self
        nextVC.discussionData = self.discussionData
        let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
            , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = false
        present(popupVC, animated: true)
    }

    func storeAndShare(withURLString: String) {
        print(withURLString)
        let urlString = withURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else {
            return

        }
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

    func share(url: URL) {
        documentInteractionController.url = url
        
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }

    @IBAction func btnShowImage(_ sender: UIButton) {
        var images = [LightboxImage]()
        images.append(LightboxImage(image: self.imgDiscussion.image!))
        let controller = LightboxController(images: images)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func onTapReplay(_ sender:UIButton) {
          let index = sender.tag
           let data = commentList[index]
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idAddCommentDialog")as! AddCommentDialog
        nextVC.commentType = .ReplyComment
        nextVC.context = self
        nextVC.commentData = data
        nextVC.discussionData = self.discussionData
        let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth, popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = false
        present(popupVC, animated: true)
        
    }
    @objc func onTapDeletMain(_ sender:UIButton) {
        let id = Int(commentList[sender.tag].commentId!)!
      //  self.showAppDialog(delegate: self, dialogTitle: "Alert !!", dialogMessage: doGetValueLanguage(forKey: "do_you_want_to_delete_this_comment"), style: .Delete, tag: id)
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "do_you_want_to_delete_this_comment"), style: .Delete, tag: id, cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }
    @objc func didClickComment(_ sender:UIButton){
        let Sb = UIStoryboard(name: "sub", bundle: nil)
        let vc = Sb.instantiateViewController(withIdentifier: "idCommentsVC")as! CommentsVC
        
        if commentList[sender.tag].commentMessaage != nil{
            vc.feedId .append(contentsOf: commentList[sender.tag].commentMessaage)
        }
        vc.feedId = commentList[sender.tag].commentId
        vc.userID = commentList[sender.tag].userId
        initialLoad = false
        self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @objc func onClickUserProfile(_ sender : UIButton ){
           let index = sender.tag
//          let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = commentList[index].userId
////          vc.context = self
//          self.navigationController?.pushViewController(vc, animated: true)
        
        if commentList[index].userId ?? "" != "0" {
            let vc = MemberDetailsVC()
            vc.user_id = commentList[index].userId ?? ""
            vc.userName =  ""
            pushVC(vc: vc)
        }
        
        
    }
    
    @objc func onClickViewimagez(_ sender : UIButton ){
        
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
       nextVC.imagePath = commentList[sender.tag].commentattachment
        nextVC.iscomefrom = "vehicle"
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
        
    }
    
//    @objc func onClickreplyimage(_ sender : UIButton ){
//        
//        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
//        nextVC.imagePath = commentList[sender.tag].commentattachment
//        nextVC.iscomefrom = "vehicle"
//        nextVC.modalPresentationStyle = .overFullScreen
//        self.present(nextVC, animated: true)
//        
//    }
   @objc func btnViewUserProfile (_ sender : UIButton ) {
    let index = sender.tag
//         let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//          vc.user_id = commentList[index].subComment[index].userId!
//         self.navigationController?.pushViewController(vc, animated: true)
    
    let vc = MemberDetailsVC()
    vc.user_id = commentList[index].subComment[index].userId ?? ""
    vc.userName =  ""
    pushVC(vc: vc)
   }
    
    func doGetDocTypeImage(string : String) -> UIImage {
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

extension DiscussionDetailVC : UITableViewDelegate ,UITableViewDataSource,DiscussionCommentCellDelegate,DiscssionSubCommentCellDelegate{
    func onClickViewProfile (at indexPath: IndexPath) {
//         let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//          vc.user_id = commentList[indexPath.section].subComment[indexPath.row].userId!
//         self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MemberDetailsVC()
        vc.user_id = commentList[indexPath.section].subComment[indexPath.row].userId ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
       }
    func btnViewUserProfile (at indexPath: IndexPath) {
        //         let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
        //          vc.user_id = commentList[indexPath.section].subComment[indexPath.row].userId!
        //         self.navigationController?.pushViewController(vc, animated: true)
        let vc = MemberDetailsVC()
        vc.user_id = commentList[indexPath.section].subComment[indexPath.row].userId ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
       }
    
    func ReplyButtonClicked(at indexPath: IndexPath) {
        
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
        nextVC.imagePath = commentList[indexPath.section].subComment[indexPath.row].commentattachment
        nextVC.iscomefrom = "vehicle"
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
        
    }
    
    func DeleteButtonClicked(at indexPath: IndexPath) {
        let id = Int(commentList[indexPath.section].subComment[indexPath.row].commentId!)!
        //self.showAppDialog(delegate: self, dialogTitle: "Alert !!", dialogMessage:doGetValueLanguage(forKey: "do_you_want_to_delete_this_post"), style: .Delete, tag: id)
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "do_you_want_to_delete_this_comment"), style: .Delete, tag: id, cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }
    
    func onClickViewimage(at indexPath: IndexPath) {
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
        nextVC.imagePath = commentList[indexPath.section].subComment[indexPath.row].commentattachment
        nextVC.iscomefrom = "vehicle"
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.2){
                self.viewFab.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.2){
                self.viewFab.isHidden = true
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList[section].subComment.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionCommentCell") as! DiscussionCommentCell
        
        let data = commentList[section]
        cell.lblCreatedBy.text = "\(data.createdBy ?? "")\(data.blockName ?? "")"
        cell.lblCommentText.text = data.commentMessaage
        cell.btnViewProfile.isHidden = false
        cell.bViewProfileSub.isHidden = true
        cell.lblCommentReply.text = doGetValueLanguage(forKey: "reply")
        cell.lblDelete.text = doGetValueLanguage(forKey: "delete")
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfile, palceHolder: "user_default")
      
        cell.btncomment.isHidden = false
        cell.btncommentsub.isHidden = true
        if data.commentattachment != ""
        {
            
            if   data.commentattachment.lowercased().contains(".pdf") {
                cell.imgcomment.image = UIImage(named: "pdf")
            } else  if   data.commentattachment.contains(".doc") ||  data.commentattachment.contains(".docx") {
                cell.imgcomment.image = UIImage(named: "doc")
            } else  if   data.commentattachment.contains(".ppt") ||  data.commentattachment.contains(".pptx") {
                cell.imgcomment.image = UIImage(named: "doc")
            } else  if  data.commentattachment.contains(".jpg") ||  data.commentattachment.contains(".jpeg") {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            }else  if  data.commentattachment.contains(".JPG") ||  data.commentattachment.contains(".JPEG") {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            }
            
            else  if   data.commentattachment.contains(".png")  {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            } else  if   data.commentattachment.contains(".zip")  {
                cell.imgcomment.image = UIImage(named: "zip")
            } else {
                cell.imgcomment.image = UIImage(named: "office-material")
            }
            
            cell.heightimgcomment.constant = 70
        }
        else{
            cell.heightimgcomment.constant = 0
        }
        
        
        cell.lblCreatedDate.text = data.commentCreatedDate
        if data.userId == doGetLocalDataUser().userID!{
            cell.viewDelete.isHidden = false
            cell.bDeleteMain.isHidden = false
            cell.bDeleteMain.tag = section
            cell.bDeleteMain.addTarget(self, action: #selector(onTapDeletMain), for: .touchUpInside)
                  
        }else{
            cell.viewDelete.isHidden = true
        }
       
       
        cell.delegate = self
        cell.context = self
        cell.tbvHeight.constant = 0
         cell.conLeftsideMainview.constant = 8
        cell.viewReply.isHidden = false
        cell.bReply.tag = section
        cell.bReply.addTarget(self, action: #selector(onTapReplay), for: .touchUpInside)
        cell.btnViewProfile.tag = section
        cell.btnViewProfile.addTarget(self, action: #selector(onClickUserProfile), for: .touchUpInside)
        
        cell.btncomment.tag = section
        cell.btncomment.addTarget(self, action: #selector(onClickViewimagez), for: .touchUpInside)
        
        setThreeCorner(viewMain: cell.viewMain)
         return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCommentData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! DiscussionCommentCell
        let data = commentList[indexPath.section].subComment[indexPath.row]
        cell.setNeedsLayout()
        cell.lblCreatedBy.text = "\(data.createdBy ?? "")\(data.blockName ?? "")"
        
        cell.lblCommentText.text = data.commentMessaage
        cell.btnViewProfile.isHidden = true
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfile, palceHolder: "user_default")
       
        
        
        if data.commentattachment != ""
        {
            
            if   data.commentattachment.lowercased().contains(".pdf") {
                cell.imgcomment.image = UIImage(named: "pdf")
            } else  if   data.commentattachment.contains(".doc") ||  data.commentattachment.contains(".docx") {
                cell.imgcomment.image = UIImage(named: "doc")
            } else  if   data.commentattachment.contains(".ppt") ||  data.commentattachment.contains(".pptx") {
                cell.imgcomment.image = UIImage(named: "doc")
            } else  if   data.commentattachment.contains(".jpg") ||  data.commentattachment.contains(".jpeg") {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            }else  if  data.commentattachment.contains(".JPG") ||  data.commentattachment.contains(".JPEG") {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            } else  if   data.commentattachment.contains(".png")  {
                Utils.setImageFromUrl(imageView: cell.imgcomment, urlString: data.commentattachment, palceHolder: "banner_placeholder")
            } else  if   data.commentattachment.contains(".zip")  {
                cell.imgcomment.image = UIImage(named: "zip")
            } else {
                cell.imgcomment.image = UIImage(named: "office-material")
            }
            
            cell.heightimgcomment.constant = 70
        }
        else{
            cell.heightimgcomment.constant = 0
        }
        
//        cell.btncomment.tag = indexPath.section
//        cell.btncomment.addTarget(self, action: #selector(onClickreplyimage), for: .touchUpInside)
        cell.lblCreatedDate.text = data.commentCreatedDate
        
        if data.userId == doGetLocalDataUser().userID!{
            cell.viewDelete.isHidden = false
            cell.bDeleteMain.isHidden = true
        
            
        }else{
            cell.viewDelete.isHidden = true
        }
        cell.viewReply.isHidden = true
        cell.bViewProfileSub.isHidden = false
        cell.btnViewProfile.isHidden = true
        
        cell.btncomment.isHidden = true
        cell.btncommentsub.isHidden = false
        
//        if data.subComment.count == 0{
//            cell.tbvData.isHidden = true
//        }else{
//            cell.subCommentData(commentList: data.subComment)
//        }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.conLeftsideMainview.constant = 60
        cell.tbvHeight.constant = 0
        //cell.delegate = self
        //cell.layoutIfNeeded()
        cell.selectionStyle = .none
        setThreeCorner(viewMain: cell.viewMain)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
}
 

extension DiscussionDetailVC: UIDocumentInteractionControllerDelegate ,URLSessionDownloadDelegate{

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(downloadTask.progress )
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
extension DiscussionDetailVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
              doDeleteComment(comment_id: String(tag))
        }
    }

    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
        
        
        func doDeleteComment(comment_id:String){
            self.showProgress()
           // let data = self.commentList[tag]
            let params = ["deleteComment":"deleteComment",
                          "society_id":self.doGetLocalDataUser().societyID!,
                          "user_id":self.doGetLocalDataUser().userID!,
                          "country_code":doGetLocalDataUser().countryCode!,
                          "comment_id":comment_id]
            let request = AlamofireSingleTon.sharedInstance
            request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, Err) in
                if Data != nil{
                    self.hideProgress()
                    do{
                        let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                        if response.status == "200"{
                            self.fetchNewDataOnRefresh()
                        }else{
                            print("faliure message",response.message as Any)
                        }
                    }catch{
                        print("parse error",error as Any)
                    }
                }
            }
            
        }
        }
}
