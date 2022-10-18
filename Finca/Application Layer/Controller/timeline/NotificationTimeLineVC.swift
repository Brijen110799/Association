//
//  NotificationTimeLineVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 14/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import VersaPlayer
import Lightbox
class NotificationTimeLineVC: BaseVC {
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    var feed_id = ""
    var feedArray = [FeedModel]()
    let itemCell_image  = "TimeLineImageCell"
    let itemCell_text = "TimeLineTextCell"
    let itemCell  = "TimeLineCell"
    var selectedIndex = -1
     var isComeFromAppDelegate = ""
    var playerView : VersaPlayerView!
    var showLoader = true
    override func viewDidLoad() {
        super.viewDidLoad()
       // let nib1 = UINib(nibName: itemCell_image, bundle: nil)
       // tbvData.register(nib1, forCellReuseIdentifier: itemCell_image)
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        
       // let nib2 = UINib(nibName: itemCell_text, bundle: nil)
       // tbvData.register(nib2, forCellReuseIdentifier: itemCell_text)
        
        tbvData.estimatedRowHeight = 300
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        // Do any additional setup after loading the view.
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
    }
    override func viewWillAppear(_ animated: Bool) {
        doGetData()
    }
    @IBAction func onClickBack(_ sender: Any) {
        if isComeFromAppDelegate != "" {
             Utils.setHome()
        } else {
             doPopBAck()
        }
    }
    func doGetData() {
              showProgress()
              //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
              let params = ["getNotificationFeed":"getNotificationFeed",
                            "user_id" :doGetLocalDataUser().userID!,
                            "feed_id" : feed_id,
                            "society_id":doGetLocalDataUser().societyID!,
                            "unit_id":doGetLocalDataUser().unitID!]
        
              print("param" , params)
              let requrest = AlamofireSingleTon.sharedInstance
              requrest.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
                  
                  if json != nil {
                      self.hideProgress()
                      do {
                          let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                          
                          
                          if response.status == "200" {
                              
                               self.viewNoData.isHidden = true
                           
                              self.feedArray =  response.feed
                            
                            
                            for (index,item) in self.feedArray.enumerated() {
                                
                                if item.feedType == "1" {
                                    
                                    if item.feedImg.count != 0 &&  item.feedImg.count == 1 {
                                        let widthOffset = CGFloat(Double(item.feedImg[0].feedWidth ?? "0") ?? 0 ) - self.tbvData.frame.size.width
                                        let widthOffsetPercentage = (widthOffset*100) / CGFloat(Double(item.feedImg[0].feedWidth ?? "0") ?? 0 )
                                        let heightOffset = (widthOffsetPercentage * CGFloat(Double(item.feedImg[0].feedHeight ?? "0") ?? 0 ))/100
                                        self.feedArray[index].imageHeight = CGFloat(Double(item.feedImg[0].feedHeight ?? "0") ?? 0 ) - heightOffset
                                    } else {
                                        self.feedArray[index].imageHeight = 360
                                    }
                                    
                                }
                                
                            }
                            
                              self.tbvData.reloadData()
                              
                          }else {
                            self.feedArray.removeAll()
                            self.viewNoData.isHidden = false
                            self.tbvData.reloadData()
                            ///  self.showAlertMessage(title: "Alert", msg: response.message)
                          }
                      } catch {
                          print("parse error")
                      }
                  }
              }
              
              
          }
    @objc func didClickComment(_ sender:UIButton){
        let Sb = UIStoryboard(name: "sub", bundle: nil)
        let vc = Sb.instantiateViewController(withIdentifier: "idCommentsVC")as! CommentsVC
        
        if feedArray[sender.tag].comment != nil{
            vc.commentList.append(contentsOf: feedArray[sender.tag].comment)
        }
        vc.feedId = feedArray[sender.tag].feedId
        vc.userID = feedArray[sender.tag].userId
        vc.index = sender.tag
        vc.comment_status = feedArray[sender.tag].commentStatus ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func didClickLike(_ sender : UIButton ){
             
        let feedid = feedArray[sender.tag].feedId
        let indexpath = sender.tag
      
        if feedArray[sender.tag].likeStatus == "0" {
              self.feedArray[sender.tag].likeStatus = "1"
            // self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! + 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "0",indexpath:sender.tag)
            
            
            if feedArray[sender.tag].like == nil {
                feedArray[sender.tag].like = [LikeModel]()
            }
//            feedArray[sender.tag].like.append(LikeModel(likeId: "", feedId: feedid ?? "", userId: doGetLocalDataUser().userID!, userName: doGetLocalDataUser().userFullName!, blockName: doGetLocalDataUser().companyName ?? "", modifyDate: "", userProfilePic: doGetLocalDataUser().userProfilePic!))
            
            feedArray[sender.tag].like.append(LikeModel(likeId: "", feedId: feedid ?? "", userId: doGetLocalDataUser().userID!, userName: doGetLocalDataUser().userFullName!, blockName: doGetLocalDataUser().blockName ?? "", modifyDate: "", userProfilePic: doGetLocalDataUser().userProfilePic!))
            
        } else {
               self.feedArray[sender.tag].likeStatus = "0"
          //  self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! - 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "1",indexpath:sender.tag)
            
            if feedArray[sender.tag].like != nil && feedArray[sender.tag].like.count > 0 {
                for (index,item) in feedArray[sender.tag].like.enumerated() {
                    if item.userId == doGetLocalDataUser().userID {
                        feedArray[sender.tag].like.remove(at: index)
                    }
                }
            }
          
        }
        tbvData.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)
    }
        
//        @objc func didClickLike(_ sender : UIButton ){
//          //  let likestatus = feedArray[sender.tag].likeStatus
//            let feedid = feedArray[sender.tag].feedId
//            let indexpath = sender.tag
//
//            if feedArray[sender.tag].likeStatus == "0" {
//                  self.feedArray[sender.tag].likeStatus = "1"
//                 self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! + 1)
//                doCallLikeAPi(feedid:feedid , likeStatus: "0",indexpath:sender.tag)
//
//
//            } else {
//                   self.feedArray[sender.tag].likeStatus = "0"
//                self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! - 1)
//                doCallLikeAPi(feedid:feedid , likeStatus: "1",indexpath:sender.tag)
//
//            }
//
//             self.tbvData.reloadData()
//            /// print(likestatus)
//
//        }
        
        @objc func onClickUserProfile(_ sender : UIButton ){
            let index = sender.tag
            if feedArray[index].userId != "0" {
                if feedArray[index].userId == doGetLocalDataUser().userID {
                    //self profile
//                    let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "idProfileVC")as! ProfileVC
//                    let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
//                    newFrontViewController.isNavigationBarHidden = true
//                    revealViewController().pushFrontViewController(newFrontViewController, animated: true)
                } else {
                    // other user profile
    //                let vc = mainStoryboard.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
    //                vc.user_id = feedArray[index].userId
    //                self.navigationController?.pushViewController(vc, animated: true)

                    let data = feedArray[index]
//                    let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//                    vc.user_id = data.userId
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    let vc = MemberDetailsVC()
                    vc.user_id = data.userId ?? ""
                    vc.userName =  ""
                    pushVC(vc: vc)
                }
            } else {
    //            toast(message: "Access Denied", type: 1)
            }
        }
    func doCallSaveAPi(feedid:String!,SaveStatus:String!,indexpath:Int!) {
        //        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "saveFeed":"saveFeed",
                      "feed_id":feedid!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? "",
                      "status":SaveStatus!]
        
        print("like param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedControllerNew, parameters: params) { (json, error) in
            //            self.hideProgress()
            
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                      //  print("Save response")
                        self.showLoader = false
                        
                       /* if self.feedArray[indexpath].likeStatus == "1"{
                            self.feedArray[indexpath].likeStatus = "0"
                            self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! - 1)
                            self.tbvTimeline.reloadData()
                        }else{
                            self.feedArray[indexpath].likeStatus = "1"
                            self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! + 1)
                            self.tbvTimeline.reloadData()
                        }*/
                        
                        self.showLoader = true
                    }else {
                    }
                    print(json as Any)
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }
        }
    }
    @objc func didClickSave(_ sender : UIButton ){
             
        let feedid = feedArray[sender.tag].feedId
        let indexpath = sender.tag
      
        if feedArray[sender.tag].is_saved == "0" {
              self.feedArray[sender.tag].is_saved = "1"
        
           // doCallLikeAPi(feedid:feedid , likeStatus: "0",indexpath:sender.tag)
            doCallSaveAPi(feedid: feedid, SaveStatus: "0", indexpath: sender.tag)
     
        } else {
               self.feedArray[sender.tag].is_saved = "0"
          
           // doCallLikeAPi(feedid:feedid , likeStatus: "1",indexpath:sender.tag)
            doCallSaveAPi(feedid: feedid, SaveStatus: "1", indexpath: sender.tag)
            
        }
        tbvData.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)
   
    }
        @objc func onClickDeletePost(_ sender : UIButton ){
            
        
            showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete this post?", style: .Delete)
            selectedIndex = sender.tag
    //        confirmDailog(id: feedArray[index].feedId)
            
        }
        
        @objc func onClickEditPost(_ sender : UIButton ){
            if let cell = tbvData.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? TimeLineCell  {
                cell.isShowView = true
                cell.ConHeightMoreView.constant = 0
            }
            let data = feedArray[sender.tag]
            let storBoard = UIStoryboard(name: "sub", bundle:nil)
            let nextVC = storBoard.instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
            nextVC.TimelineData = data
            nextVC.isEditTimelineCalled = true
            self.navigationController?.pushViewController(nextVC, animated: true)

            }
    func doCallLikeAPi(feedid:String!,likeStatus:String!,indexpath:Int!) {
           //        showProgress()
           
           let params = ["key":ServiceNameConstants.API_KEY,
                         "likeFeed":"likeFeed",
                         "feed_id":feedid!,
                         "society_id":doGetLocalDataUser().societyID!,
                         "user_id":doGetLocalDataUser().userID!,
                         "unit_id":doGetLocalDataUser().unitID!,
                         "user_name":doGetLocalDataUser().userFullName!,
                         "block_name":doGetLocalDataUser().company_name ?? "",
                         "like_status":likeStatus!]
           
           print("like param" , params)
           
           let request = AlamofireSingleTon.sharedInstance
           
           request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
               //            self.hideProgress()
               
               if json != nil {
                   
                   do {
                       let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                       if response.status == "200" {
                         //  print("like response")
                         
                       }else {
                        
                       }
                       print(json as Any)
                   } catch {
                       print("parse error",error.localizedDescription,error)
                   }
               }
           }
           
        
       }
    func doDeletPost(id:String){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "deleteFeed":"deleteFeed",
                      "feed_id" : id,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? ""]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                    if response.status == "200" {
                  //      self.feedArray.removeAll()
//                        if self.isComeFromAppDelegate != "" {
//                            Utils.setRootTimeline()
//                        } else  {
//                            self.doPopBAck()
//                        }
                        isComeFromTimeline = true
                        Utils.setHome()
                    }else {
                        
                    }
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }
        }
    }
    @IBAction func tapHome(_ sender: Any) {
        Utils.setHome()
    }
}
extension NotificationTimeLineVC : UITableViewDelegate,UITableViewDataSource , TimelineCellDelegate {
    func tapReadMore(indexPath: IndexPath) {
        
    }
    func openLikeList(indexPath: IndexPath) {
        
        let data = feedArray[indexPath.row]
        
        if  data.like != nil {
            
            let pickerVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idTimelineLikedByVC")as! TimelineLikedByVC
            pickerVC.context = self
            pickerVC.likedByList = data.like
            let sheetController = SheetViewController(controller: pickerVC, sizes: [.fullScreen])
            sheetController.blurBottomSafeArea = false
            sheetController.adjustForBottomSafeArea = true
            sheetController.topCornersRadius = 10
            sheetController.extendBackgroundBehindHandle = false
            sheetController.handleSize = CGSize(width: 100, height: 8)
            sheetController.handleColor = UIColor.white
            self.present(sheetController, animated: false, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! TimeLineCell
        let item = feedArray[indexPath.row]
        cell.selectionStyle = .none
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.userProfilePic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        cell.lbUserName.text = item.userName
        cell.lbBlockName.text = item.blockName
        cell.lblPostDateAndTime.text = feedArray[indexPath.row].modifyDate
        cell.setuplabel(msg: item.feedMsg ?? "" , isShow: item.isShowReadMore ?? false)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.parentViewController = self
        cell.isShowView = true
        cell.ConHeightMoreView.constant = 0
        if item.feedType == "1" {
            cell.viewcard.isHidden = true
            cell.viewImage.isHidden = false
            cell.viewVideo.isHidden = true
            
            cell.conHeightPager.constant = item.imageHeight ?? 360
            if item.feedImg.count > 0 && item.feedImg.count == 1{
                Utils.setImageFromUrl(imageView: cell.ivSingleImage, urlString: item.feedImg[0].feedImg, palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
                cell.ivSingleImage.isHidden = false
                cell.pager.isHidden = true
                cell.bSingleImageClick.isHidden = false
                cell.bSingleImageClick.tag = indexPath.row
                cell.bSingleImageClick.addTarget(self, action: #selector(doViewImageInViewer(_:)), for: .touchUpInside)
            
            }else {
                cell.ivSingleImage.isHidden = true
                cell.bSingleImageClick.isHidden = true
                cell.pager.isHidden = false
                cell.setDataPager(imgArray: item.feedImg!)
            }
           
        } else if item.feedType == "2" {
            cell.viewImage.isHidden = true
            cell.viewVideo.isHidden = false
            cell.viewcard.isHidden = true
            cell.configurePlayer(isPlayVideo: false, index: indexPath.row, videoPath: item.feed_video)
            self.playerView = cell.playerView
        }else if item.feedType == "3" {
            cell.viewImage.isHidden = true
            cell.viewVideo.isHidden = true
            cell.viewcard.isHidden = false
            cell.viewVD.backgroundColor = hexStringToUIColor(hex: feedArray[indexPath.row].card_colour)
            Utils.setImageFromUrl(imageView: cell.imgVDfeedicn, urlString: item.feedImg[0].feedImg, palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            Utils.setImageFromUrl(imageView: cell.imgVdCardicn, urlString: item.userProfilePic, palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
            cell.lblvdcompanyname.text = item.blockName
            cell.lblVDcommentdesc.text = item.feedMsg
            
            cell.lblvdcompanyname.textColor =  hexStringToUIColor(hex: feedArray[indexPath.row].text_colour)
            cell.lblVDcommentdesc.textColor =  hexStringToUIColor(hex: feedArray[indexPath.row].text_colour)
            
            cell.viewVD.layer.cornerRadius = 10
            cell.viewVD.layer.shadowColor = UIColor.black.cgColor
            cell.viewVD.layer.shadowOpacity = 0.5
            cell.viewVD.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.viewVD.layer.shadowRadius = 2
            cell.viewVD.layer.shadowPath = UIBezierPath(rect: cell.viewVD.bounds).cgPath
            cell.viewVD.layer.shouldRasterize = true
          
            cell.viewVD.layer.rasterizationScale = UIScreen.main.scale
            
        }
        
        
        else {
            cell.viewcard.isHidden = true
            cell.viewImage.isHidden = true
            cell.viewVideo.isHidden = true
        }
        if item.isReadMore ?? false {
            cell.bReadMore.isHidden = false
        } else {
            cell.bReadMore.isHidden = true
        }
        if item.total_comments == "0"{
            cell.lbCommentCount.text = "\(doGetValueLanguage(forKey: "comments_0"))"
        }else{
            cell.lbCommentCount.text = "\(item.total_comments ?? "0") \(doGetValueLanguage(forKey: "comments_timeline"))"
            
        }
        
      
        if item.commentStatus == "1"{
            cell.ivComment.image = UIImage(named: "text_sms_selected")
            cell.ivComment.setImageColor(color: ColorConstant.primaryColor)
        }else{
            cell.ivComment.image = UIImage(named: "text_sms_unselected")
            cell.ivComment.setImageColor(color: ColorConstant.grey_40)
        }
        
        if item.likeStatus == "0"{
            cell.ivLike.image = UIImage(named: "like_unselected")
            cell.ivLike.setImageColor(color: ColorConstant.grey_40)
        }else {
            cell.ivLike.image = UIImage(named: "like_selected")
            cell.ivLike.setImageColor(color: ColorConstant.primaryColor)
            
        }
        
        // ..........Save Status.............
        
        if item.is_saved == "0"{
            cell.ivSave.image = UIImage(named: "Unbookmark")
            cell.ivSave.setImageColor(color: ColorConstant.grey_40)
        }else {
            cell.ivSave.image = UIImage(named: "bookmark")
            cell.ivSave.setImageColor(color: ColorConstant.primaryColor)
        }
        if item.userId == doGetLocalDataUser().userID!{
            cell.bDelete.tag = indexPath.row
            cell.viewDelete.isHidden = false
            cell.btnreport.isHidden = true
            cell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
            cell.bEdit.tag = indexPath.row
            //cell.viewEdit.isHidden = false
            cell.bEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
            cell.viewCall.isHidden = true
        }else{
            cell.viewDelete.isHidden = true
            cell.btnreport.isHidden = false
            cell.bCall.tag = indexPath.row
            cell.bCall.addTarget(self, action: #selector(tapCall(_:)), for: .touchUpInside)
            cell.viewCall.isHidden = true
            if item.user_mobile ?? "" != "" && item.user_mobile?.count ?? 0 > 1 {
                cell.viewCall.isHidden = false
            }
        }
       // cell.viewCall.isHidden = false
       // cell.viewDelete.isHidden = false
//        if item.userId == doGetLocalDataUser().userID
//        {
//            cell.ivSave.isHidden = true
//            cell.bSave.isHidden = true
//            cell.lbSave.isHidden = true
//        }else
//        {
//            cell.ivSave.isHidden = false
//            cell.bSave.isHidden = false
//            cell.lbSave.isHidden = false
//        }
        cell.setUpLikeView(item: item, profilePic: doGetLocalDataUser().userProfilePic ?? "", userID: doGetLocalDataUser().userID ?? "")
        
        if item.societyId == "0"{
            cell.viewLikeComment.isHidden = true
        }else{
            cell.viewLikeComment.isHidden = false
        }
        
        if item.upload_by_type == "1"
        {
            cell.view1.isHidden = true
            cell.view2.isHidden = true
            cell.view3.isHidden = false
            
            
        }
        else{
            cell.view3.isHidden = true
            cell.view1.isHidden = false
            cell.view2.isHidden = false
           
        }
        
//        if item.userId == doGetLocalDataUser().userID!{
//            cell.bDelete.tag = indexPath.row
//            cell.viewDelete.isHidden = false
//            cell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
//            cell.bEdit.tag = indexPath.row
//            //cell.viewEdit.isHidden = false
//            cell.bEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
//
//        }else{
//            cell.viewDelete.isHidden = true
//            //cell.viewEdit.isHidden = true
//        }
        
        //cell.viewDelete.isHidden = true
        cell.bProfile.tag = indexPath.row
        cell.bProfile.addTarget(self, action: #selector(onClickUserProfile(_:)), for: .touchUpInside)
       
        cell.bLike.tag = indexPath.row
        cell.bLike.addTarget(self, action: #selector(didClickLike(_:)), for: .touchUpInside)
      
        cell.bComment.tag = indexPath.row
        cell.bComment.addTarget(self, action: #selector(didClickComment(_:)), for: .touchUpInside)
        
        cell.bSave.tag = indexPath.row
        cell.bSave.addTarget(self, action: #selector(didClickSave(_:)), for: .touchUpInside)
       
        return cell
    }
    @objc func tapCall(_ sender : UIButton ){
       
        let phone = feedArray[sender.tag].user_mobile!.components(separatedBy: .whitespaces).joined()
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func doViewImageInViewer(_ sender:UIButton){
        var images = [LightboxImage]()
        if let imgArray = feedArray[sender.tag].feedImg {
            for image in imgArray{
                images.append(LightboxImage(imageURL:URL(string:image.feedImg)!))
            }
        }
      
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        // Present your controller.
        present(controller, animated: true, completion: nil)
        controller.goTo(sender.tag )
    }
}
extension NotificationTimeLineVC: AppDialogDelegate , OnChangeCount {
    
    func doChangeCommentCount(index : Int , commentArray : [CommentModel] , comment_status  :String) {
//        feedArray[index].comment = commentArray
//        feedArray[index].commentStatus = comment_status
//        tbvData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) {
//              self.filterComplainList[self.selectedIndex]
//                self.doCallDeleteApi(propertyDetail: selectedIndex)
                self.doDeletPost(id: self.feedArray[self.selectedIndex].feedId)
            }
        }
    }
}
