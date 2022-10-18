//
//  SavedTimelineVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 02/02/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import AVFoundation
import AVKit
import VersaPlayer
import Lightbox
class SavedTimelineVC: BaseVC {

    @IBOutlet weak var tbvTimeline: UITableView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnFloatingButton: UIView!
    @IBOutlet weak var bMenu: UIButton!
    var feedArray = [FeedModel]()
    let itemCell_image  = "TimeLineImageCell"
    let itemCell_text = "TimeLineTextCell"
    var showLoader = true
    var initialLoad = true
    var isPersonalTimeline = false
    var memMainResponse : MemberDetailResponse!
    var totalFeed = ""
    var StrVideoUrl = ""
    var pos1 = 0
    var selectedIndex = -1
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    //deepak
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var lbHeader: UILabel!
    @IBOutlet weak var ivMenu: UIImageView!
    @IBOutlet weak var bBack: UIButton!
    
    @IBOutlet weak var viewNotificationCount: UIView!
    @IBOutlet weak var lbNotificationCount: UILabel!
    
    var user_id  : String!
    var isMyTimeLine = false
    var isMemberTimeLine:Bool!
    var memberFirstName : String!
    var memerLastName : String!
    var limit_feed = 0
    var getMyFeed = "getMyFeed"
    var unit_id :String!
    
    var user_name : String!
    var society_id : String!
    var block_name : String!
     var isExpandTrue = true
    var feedId = ""
    var StrVideoimage = ""
    let itemCell  = "TimeLineCell"
    var playerView = VersaPlayerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // ivMenu.image = UIImage(named: "back")
        
        btnFloatingButton.layer.shadowRadius = 5
        btnFloatingButton.layer.shadowOffset = CGSize.zero
        btnFloatingButton.layer.shadowOpacity = 0.3
        btnFloatingButton.clipsToBounds = true
        viewNoData.clipsToBounds = true
        self.viewNoData.isHidden = true

        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvTimeline.register(nib, forCellReuseIdentifier: itemCell)
        
        tbvTimeline.estimatedRowHeight = 300
        tbvTimeline.rowHeight = UITableView.automaticDimension
        tbvTimeline.delegate = self
        tbvTimeline.dataSource = self
        addRefreshControlTo(tableView: self.tbvTimeline)
        viewHome.clipsToBounds = true
        lbHeader.text = doGetValueLanguage(forKey: "saved_feed")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
       // limit_feed = 0
      //  pos1 = 0
        
       // doLoadFeed(limit_feed: limit_feed, isLoadMore: true, pos1: pos1)
   
            bMenu.isHidden = true
            bBack.isHidden = false
            unit_id = doGetLocalDataUser().unitID!
    }

    func loadNoti() {

    }
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {

        hidePull()
        feedArray.removeAll()
        tbvTimeline.reloadData()

        if isMyTimeLine {
            //doLoadPersonalFeed()
        } else {
            limit_feed = 0
            pos1 = 0
            doLoadFeed(limit_feed: limit_feed, isLoadMore: false , pos1: pos1)
        }
      
        tbvTimeline.beginUpdates()
        tbvTimeline.endUpdates()

    }
    @objc func didClickComment(_ sender:UIButton){
        let Sb = UIStoryboard(name: "sub", bundle: nil)
        let vc = Sb.instantiateViewController(withIdentifier: "idCommentsVC")as! CommentsVC
        
        if feedArray[sender.tag].comment != nil{
            vc.commentList.append(contentsOf: feedArray[sender.tag].comment)
        }
        vc.feedId = feedArray[sender.tag].feedId
        vc.userID = feedArray[sender.tag].userId
        initialLoad = false
        vc.index = sender.tag
        vc.comment_status = feedArray[sender.tag].commentStatus
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
            
            feedArray[sender.tag].like.append(LikeModel(likeId: "", feedId: feedid ?? "", userId: doGetLocalDataUser().userID!, userName: doGetLocalDataUser().userFullName!, blockName: doGetLocalDataUser().company_name ?? "", modifyDate: "", userProfilePic: doGetLocalDataUser().userProfilePic!))
            
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
        tbvTimeline.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)
   
         //self.tbvTimeline.reloadData()
        /// print(likestatus)
        
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
        tbvTimeline.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)
   
    }
    @objc func onClickUserProfile(_ sender : UIButton ){
        let index = sender.tag
        if feedArray[index].userId != "0" {
            if feedArray[index].userId == doGetLocalDataUser().userID {
                //self profile
//                let destiController = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserProfileVC") as! UserProfileVC
//                let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//                newFrontViewController.isNavigationBarHidden = true
//                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            } else {
                // other user profile
//                let vc = mainStoryboard.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//                vc.user_id = feedArray[index].userId
//                self.navigationController?.pushViewController(vc, animated: true)

                let data = feedArray[index]
//                let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//                vc.user_id = data.userId
//                self.navigationController?.pushViewController(vc, animated: true)
                
                let vc = MemberDetailsVC()
                vc.user_id = data.userId ?? ""
                vc.userName =  ""
                pushVC(vc: vc)
            }
        } else {
//            toast(message: "Access Denied", type: 1)
        }
    }
    @objc func onClickDeletePost(_ sender : UIButton ){
        if let cell = tbvTimeline.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? TimeLineCell  {
            cell.isShowView = true
            cell.ConHeightMoreView.constant = 0
        }
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete this post?", style: .Delete)
        selectedIndex = sender.tag
//        confirmDailog(id: feedArray[index].feedId)
        
    }
    @objc func onClickEditPost(_ sender : UIButton ){
        
        if let cell = tbvTimeline.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? TimeLineCell  {
            cell.isShowView = true
            cell.ConHeightMoreView.constant = 0
        }
        
        let data = feedArray[sender.tag]
        let storBoard = UIStoryboard(name: "sub", bundle:nil)
        let nextVC = storBoard.instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
        nextVC.edittimeline = "edittimeline"
        nextVC.TimelineData = data
        nextVC.isEditTimelineCalled = true
        self.navigationController?.pushViewController(nextVC, animated: true)

        }
    func confirmDailog(id:String){
        let refreshAlert = UIAlertController(title: "Delete", message: "Do you want to delete this post.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.doDeletPost(id: id)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
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
                        //
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
                        self.fetchNewDataOnRefresh()
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
    @IBAction func btnAddNewPost(_ sender: UIButton) {
        let storBoard = UIStoryboard(name: "sub", bundle:nil)
        let nextVC = storBoard.instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func doLoadFeed(limit_feed:Int! , isLoadMore : Bool , pos1 : Int!) {

        print("doLoadFeed")
        if totalFeed != "" {
            if Int(totalFeed)! > feedArray.count {
                print("gater")
            } else {
                print("else gater")
                return
            }
        }
        if !isLoadMore {
            if self.showLoader{
                showProgress()
            }
        }
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getSavedFeed":"getSavedFeed",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? "",
                      "limit_feed" : String(limit_feed),
                      "pos1":String(pos1)]
        
        print("param feed" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedControllerNew, parameters: params) { (json, error) in
            if !isLoadMore {
                if self.showLoader{
                    self.hideProgress()
                }
            }
            
            if json != nil {
                do {
                    print(json as Any)
                    let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                    if response.status == "200" {
                        self.totalFeed = response.totalFeed
                        self.viewNoData.isHidden = true
                       // self.feedArray.append(contentsOf: response.feed)
                        //self.tbvTimeline.reloadData()
                        UserDefaults.standard.set(response.feed[0].feedId, forKey: StringConstants.KEY_FEED_ID)
                        self.viewNoData.isHidden = true
                        self.pos1 = response.pos1!
                        
//                        if response.unreadNotification > 0 {
//                            self.viewNotificationCount.isHidden = false
//                            self.lbNotificationCount.text = String(response.unreadNotification)
//                        } else {
//                              self.viewNotificationCount.isHidden = true
//                        }
                        
                        self.addSizeLabel(feedArray: response.feed)
                        
                    }else if response.status == "202"{
                        self.feedArray.removeAll()
                        self.tbvTimeline.reloadData()
                        self.btnFloatingButton.isHidden = true
                         self.viewNoData.isHidden = false
                        self.lbNoData.text = response.message
                    } else {
                        self.feedArray.removeAll()
                        self.tbvTimeline.reloadData()
                        self.viewNoData.isHidden = false
                        self.feedArray.removeAll()
                    }
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }
        }
    }
    func addSizeLabel(feedArray : [FeedModel]) {
       
        var tempArray = [FeedModel]()
        tempArray = feedArray
        for (index,item) in tempArray.enumerated() {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tbvTimeline.frame.width - 16, height: 19))
            label.text = item.feedMsg
            
            if label.maxNumberOfLines > 6 {
                tempArray[index].isReadMore = true
            }else {
                tempArray[index].isReadMore = false
            }
            tempArray[index].isShowReadMore = false
            
            if item.feedType == "1" {
                
                if item.feedImg.count != 0 &&  item.feedImg.count == 1 {
                    let widthOffset = CGFloat(Double(item.feedImg[0].feedWidth ?? "0") ?? 0 ) - tbvTimeline.frame.size.width
                    let widthOffsetPercentage = (widthOffset*100) / CGFloat(Double(item.feedImg[0].feedWidth ?? "0") ?? 0 )
                    let heightOffset = (widthOffsetPercentage * CGFloat(Double(item.feedImg[0].feedHeight ?? "0") ?? 0 ))/100
                    tempArray[index].imageHeight = CGFloat(Double(item.feedImg[0].feedHeight ?? "0") ?? 0 ) - heightOffset
                } else {
                    tempArray[index].imageHeight = 360
                }
                
            }
        }
        self.feedArray.append(contentsOf: tempArray)
        DispatchQueue.main.async {
            self.tbvTimeline.reloadData()
        }
    }
    @IBAction func btnHome(_ sender: UIButton) {
       // goToDashBoard(storyboard: mainStoryboard)
        Utils.setHome()
    }
    var youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.TIMELINE_VIDEO_ID) ?? ""
    @IBAction func btnNotification(_ sender: UIButton) {
//        if youtubeVideoID != ""{
//            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
//            vc.videoId = youtubeVideoID!
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//        }else{
//            self.toast(message: "No Tutorial Available!!", type: .Warning)
//        }
        
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!
                
                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    
    @IBAction func onClickSavebtn(_ sender: Any) {
        
        let vc = subStoryboard.instantiateViewController(withIdentifier: "SavedTimelineVC") as! SavedTimelineVC
       // vc.timelineVC = self
        pushVC(vc: vc)
   
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
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
                       
                        self.fetchNewDataOnRefresh()
                    }else {
                        
                    }
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }
        }
    }
    
    @IBAction func onClickNotifications(_ sender: Any) {
        let vc = subStoryboard.instantiateViewController(withIdentifier: "idTimeLineNotificationVC") as! TimeLineNotificationVC
      
        pushVC(vc: vc)
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
}
extension SavedTimelineVC : UITableViewDelegate,UITableViewDataSource , TimelineCellDelegate {
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
            //        sheetController.dismissOnBackgroundTap = true
            sheetController.extendBackgroundBehindHandle = false
            sheetController.handleSize = CGSize(width: 100, height: 8)
            sheetController.handleColor = UIColor.white
            self.present(sheetController, animated: false, completion: nil)
        }
    }
    
    func tapReadMore(indexPath: IndexPath) {
       // let cell = tbvTimeline.cellForRow(at: indexPath) as! TimeLineCell
        //cell.tvMessage.textContainer.maximumNumberOfLines = 0
        //let cell = tbvTimeline.item
       
        tbvTimeline.beginUpdates()
        tbvTimeline.endUpdates()
        self.feedArray[indexPath.row].isReadMore = false
        self.feedArray[indexPath.row].isShowReadMore = true
        //tbvTimeline.reloadRows(at: [indexPath], with: .top)
       
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
       // cell.tvMessage.text = item.feedMsg
        cell.setuplabel(msg: item.feedMsg ?? "" , isShow: item.isShowReadMore ?? false)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.parentViewController = self
      
        if item.feedType == "1" {
            cell.viewImage.isHidden = false
            cell.viewVideo.isHidden = true
            cell.viewcard.isHidden = true
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
                cell.pager.isHidden = false
                cell.bSingleImageClick.isHidden = true
                cell.setDataPager(imgArray: item.feedImg!)
            }
           
        } else if item.feedType == "2" {
            cell.viewImage.isHidden = true
            cell.viewVideo.isHidden = false
            cell.viewcard.isHidden = true
           //let ur = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
            cell.configurePlayer(isPlayVideo: false, index: indexPath.row, videoPath: item.feed_video)
        }
        else if item.feedType == "3" {
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
            cell.viewImage.isHidden = true
            cell.viewVideo.isHidden = true
            cell.viewcard.isHidden = true
        }
        if item.isReadMore ?? false {
            cell.bReadMore.isHidden = false
        } else {
            cell.bReadMore.isHidden = true
        }
        
        
        if  item.isShowReadMore ?? false  {
            cell.tvMessage.textContainer.maximumNumberOfLines  = 0
        } else {
            cell.tvMessage.textContainer.maximumNumberOfLines  = 6
        }
        if item.total_comments == "0"{
            cell.lbCommentCount.text = "\(doGetValueLanguage(forKey: "comments_0"))"
        }else{
            cell.lbCommentCount.text = "\(item.total_comments ?? "0") \(doGetValueLanguage(forKey: "comments_timeline"))"
            
        }
//        if item.commentStatus == "1"{
//            cell.ivComment.setImageColor(color: ColorConstant.primaryColor)
//        }else if feedArray[indexPath.row].commentStatus == "0"{
//            cell.ivComment.setImageColor(color: ColorConstant.grey_40)
//        }
        
        if item.commentStatus == "1"{
            cell.ivComment.setImageColor(color: ColorConstant.primaryColor)
            cell.ivComment.image = UIImage(named: "text_sms_selected")
            
        }else if feedArray[indexPath.row].commentStatus == "0"{
            cell.ivComment.setImageColor(color: ColorConstant.grey_40)
            cell.ivComment.image = UIImage(named: "text_sms_unselected")
        }
        
//        if item.likeStatus == "0"{
//            cell.ivLike.setImageColor(color: ColorConstant.grey_40)
//        }else {
//            cell.ivLike.setImageColor(color: ColorConstant.primaryColor)
//        }
        if item.likeStatus == "0"{
            cell.ivLike.setImageColor(color: ColorConstant.grey_40)
            cell.ivLike.image = UIImage(named: "like_unselected")
        }else {
           
            cell.ivLike.image = UIImage(named: "like_selected")
            cell.ivLike.setImageColor(color: ColorConstant.primaryColor)
        }
        // ..........Save Status.............
        
        if item.is_saved == "0"{
            cell.ivSave.setImageColor(color: ColorConstant.grey_40)
        }else {
            cell.ivSave.setImageColor(color: ColorConstant.primaryColor)
        }
        
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
        if item.userId == doGetLocalDataUser().userID!{
            cell.bDelete.tag = indexPath.row
            cell.viewDelete.isHidden = false
            cell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
            cell.bEdit.tag = indexPath.row
            //cell.viewEdit.isHidden = false
            cell.bEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
            cell.viewCall.isHidden = true
        }else{
            cell.viewDelete.isHidden = true
        
            cell.bCall.tag = indexPath.row
            cell.bCall.addTarget(self, action: #selector(tapCall(_:)), for: .touchUpInside)
            cell.viewCall.isHidden = true
            if item.user_mobile ?? "" != "" && item.user_mobile?.count ?? 0 > 1 {
                cell.viewCall.isHidden = false
            }
        }
        
        
        cell.bProfile.tag = indexPath.row
        cell.bProfile.addTarget(self, action: #selector(onClickUserProfile(_:)), for: .touchUpInside)
       
        cell.bLike.tag = indexPath.row
        cell.bLike.addTarget(self, action: #selector(didClickLike(_:)), for: .touchUpInside)
      
        cell.bComment.tag = indexPath.row
        cell.bComment.addTarget(self, action: #selector(didClickComment(_:)), for: .touchUpInside)
        
        cell.bSave.tag = indexPath.row
        cell.bSave.addTarget(self, action: #selector(didClickSave(_:)), for: .touchUpInside)
        if feedArray.count - 1 == indexPath.row
        {
            self.limit_feed += 10
            self.doLoadFeed(limit_feed:self.limit_feed, isLoadMore: true,pos1: self.pos1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension UILabel {
    
    func addTrailingg(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        
        let trimmedString: String? = (mutableString as NSString).substring(to: lengthForVisibleString)
        
        if ((self.text?.count)! - lengthForVisibleString) <= 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4.0 // change line spacing between paragraph like 36 or 48
            let answerAttributed = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: self.font as Any, NSAttributedString.Key.paragraphStyle: style])
            self.attributedText = answerAttributed
            return
        }
        
        let leviTrimmedForReadMore = String(trimmedString ?? "") + String("... more")
        self.text = leviTrimmedForReadMore
        let ddlengthForVisibleString: Int = self.vissibleTextLength
        if ((self.text?.count)! - ddlengthForVisibleString) <= 0 {
            
            let trimmedForReadMore: String = trimmedString! + trailingText
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4.0 // change line spacing between paragraph like 36 or 48
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any, NSAttributedString.Key.paragraphStyle: style])
            
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor, NSAttributedString.Key.paragraphStyle: style])
            
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
        else {
            let readMoreLength: Int = (readMoreText.utf16.count)
            
            let trimmedForReadMore: String = (trimmedString! as NSString).substring(to: (trimmedString?.utf16.count ?? 0) - readMoreLength) + trailingText
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4.0 // change line spacing between paragraph like 36 or 48
            
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any, NSAttributedString.Key.paragraphStyle: style])
            
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor, NSAttributedString.Key.paragraphStyle: style])
            
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var vissibleTextLengthh: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

extension SavedTimelineVC: AppDialogDelegate  , OnChangeCount {
    
    func doChangeCommentCount(index : Int , commentArray : [CommentModel] , comment_status  :String) {
//        feedArray[index].comment = commentArray
//        feedArray[index].commentStatus = comment_status
//        tbvTimeline.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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

extension UITextView {
    func sizeFitt(width: CGFloat) -> CGSize {
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }

    func numberOfLinee() -> Int {
        let size = self.sizeFit(width: self.bounds.width)
        let numLines = Int(size.height / (self.font?.lineHeight ?? 1.0))
        return numLines
    }
}
extension UILabel{

public var requiredHeightt: CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
  }
}
