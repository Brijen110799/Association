//
//  TimelineVC.swift
//  Finca
//
//  Created by harsh panchal on 19/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import ExpandableLabel
class TimelineVC: BaseVC {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnFloatingButton.layer.shadowRadius = 5
        btnFloatingButton.layer.shadowOffset = CGSize.zero
        btnFloatingButton.layer.shadowOpacity = 0.3
        btnFloatingButton.clipsToBounds = true
        viewNoData.clipsToBounds = true
        self.viewNoData.isHidden = true
        let nib1 = UINib(nibName: itemCell_image, bundle: nil)
        tbvTimeline.register(nib1, forCellReuseIdentifier: itemCell_image)
        
        let nib2 = UINib(nibName: itemCell_text, bundle: nil)
        tbvTimeline.register(nib2, forCellReuseIdentifier: itemCell_text)
        
        tbvTimeline.estimatedRowHeight = 300
        tbvTimeline.rowHeight = UITableView.automaticDimension
        tbvTimeline.delegate = self
        tbvTimeline.dataSource = self
        addRefreshControlTo(tableView: self.tbvTimeline)
        viewHome.clipsToBounds = true
        
        if isMyTimeLine {
            if isMemberTimeLine {
                lbHeader.text = memberFirstName.capitalizingFirstLetter() + " " + memerLastName.capitalizingFirstLetter() + "'s Timeline"
                btnFloatingButton.isHidden = true
             getMyFeed = "getOtherFeed"
            } else {
                lbHeader.text = "My Timeline"
                getMyFeed = "getMyFeed"
            }
            viewHome.isHidden = true
            ivMenu.image = UIImage(named: "back")
            bBack.isHidden = false
            
        } else {
                  
            bBack.isHidden = true
               unit_id = doGetLocalDataUser().unitID!
            doInintialRevelController(bMenu: bMenu)
        }
    }
    
    func doLoadPersonalFeed(){
        print("doLoadPersonalFeed")
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getMyFeed":getMyFeed,
                      "society_id":society_id!,
                      "user_id":user_id!,
                      "unit_id":unit_id!,
                      "user_name":user_name!,
                      "block_name":block_name!,
                      "my_user_id" : doGetLocalDataUser().userID!]
        
        print("param feed" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                    if response.status == "200" {
                       // self.feedArray.append(contentsOf: response.feed)
                       // self.tbvTimeline.reloadData()
                        self.viewNoData.isHidden = true
                        self.addSizeLabel(feedArray: response.feed)
                    }else {
                        self.viewNoData.isHidden = false
                        self.tbvTimeline.reloadData()
                    }
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }
        }
    }
    
    func loadNoti() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    
    override func fetchNewDataOnRefresh() {
        feedArray.removeAll()
        tbvTimeline.reloadData()
        refreshControl.beginRefreshing()
        if feedArray.count > 0 {
            feedArray.removeAll()
        }
        if isMyTimeLine {
            doLoadPersonalFeed()
        } else {
            limit_feed = 0
            pos1 = 0
            doLoadFeed(limit_feed: limit_feed, isLoadMore: false , pos1: pos1)
        }
        refreshControl.endRefreshing()
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
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func didClickLike(_ sender : UIButton ){
      //  let likestatus = feedArray[sender.tag].likeStatus
        let feedid = feedArray[sender.tag].feedId
        let indexpath = sender.tag
      
        if feedArray[sender.tag].likeStatus == "0" {
              self.feedArray[sender.tag].likeStatus = "1"
             self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! + 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "0",indexpath:sender.tag)
                     
            
        } else {
               self.feedArray[sender.tag].likeStatus = "0"
            self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! - 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "1",indexpath:sender.tag)
            
        }
        
         //self.tbvTimeline.reloadData()
        /// print(likestatus)
        tbvTimeline.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)    }
    
    @objc func onClickUserProfile(_ sender : UIButton ){
        let index = sender.tag
        if feedArray[index].userId != "0" {
            if feedArray[index].userId == doGetLocalDataUser().userID {
                //self profile
              let destiController = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idUserProfileVC") as! UserProfileVC
                let newFrontViewController = UINavigationController.init(rootViewController: destiController)
                newFrontViewController.isNavigationBarHidden = true
                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            } else {
                // other user profile
//                let vc = mainStoryboard.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//                vc.user_id = feedArray[index].userId
//                self.navigationController?.pushViewController(vc, animated: true)

                let data = feedArray[index]
                let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
                vc.user_id = data.userId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
//            toast(message: "Access Denied", type: 1)
        }
    }
    
    @objc func onClickDeletePost(_ sender : UIButton ){
        
    
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete this post?", style: .Delete)
        selectedIndex = sender.tag
//        confirmDailog(id: feedArray[index].feedId)
        
    }
    
    @objc func onClickEditPost(_ sender : UIButton ){
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
                      "block_name":doGetLocalDataUser().blockName!,
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
                      "getFeed":"getFeed",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().blockName!,
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
                        self.pos1 = response.pos1!
                        if response.unreadNotification > 0 {
                            self.viewNotificationCount.isHidden = false
                            self.lbNotificationCount.text = String(response.unreadNotification)
                        } else {
                              self.viewNotificationCount.isHidden = true
                        }
                        self.addSizeLabel(feedArray: response.feed)
                    }else if response.status == "202"{
                        self.btnFloatingButton.isHidden = true
                         self.viewNoData.isHidden = false
                        self.lbNoData.text = response.message
                    } else {
                        self.tbvTimeline.reloadData()
                        self.viewNoData.isHidden = false
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
                tempArray[index].isReadMore = false
                tempArray[index].isShowReadMore = true
                tempArray[index].minHeight = 110
                tempArray[index].maxHeight = label.requiredHeight
            }else {
                tempArray[index].isShowReadMore = false
                
                if label.maxNumberOfLines > 2 {
                    tempArray[index].minHeight =  label.requiredHeight
                } else {
                    tempArray[index].minHeight =  label.requiredHeight + 5
                }
               // print("line 6 less" , label.contentMod )
            }
           // print("dddd no of lines ==  " , label.maxNumberOfLines)
            print("dddd no of hieght ==  " , label.requiredHeight)
         //   print("dddd no of lines ==  " , label.frame.height)
            
//            let label = UITextView(frame: CGRect(x: 0, y: 0, width: tbvTimeline.frame.width - 20, height: 20))
//            label.text = item.feedMsg
//            print("line " , label.numberOfLine())
//            if label.numberOfLine() > 6 {
//                tempArray[index].isReadMore = false
//                tempArray[index].isShowReadMore = true
//                tempArray[index].minHeight = 110
//                tempArray[index].maxHeight = CGFloat(20 * label.numberOfLine())
//                print("line 6 gr" , label.textContainer.size.height )
//            } else {
//                tempArray[index].isShowReadMore = false
//                tempArray[index].minHeight =  CGFloat(20 * label.numberOfLine())
//                print("line 6 less" , label.textContainer.size.height )
//            }
            
            
        }
        
        
        
        self.feedArray.append(contentsOf: tempArray)
        self.tbvTimeline.reloadData()

        
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    var youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.TIMELINE_VIDEO_ID)
    
    @IBAction func btnNotification(_ sender: UIButton) {
        if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if isMemberTimeLine {
            doPopBAck()
        } else {
            //let destiController = mainStoryboard.instantiateViewController(withIdentifier: "idProfileVC") as! ProfileVC
            //let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            revealViewController().pushFrontViewController(destiController, animated: true)
            doPopBAck()
            
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
                      "block_name":doGetLocalDataUser().blockName!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                    if response.status == "200" {
                        self.feedArray.removeAll()
                        if self.isMyTimeLine{
                            self.doLoadPersonalFeed()
                        }else{
                            self.doLoadFeed(limit_feed: self.limit_feed, isLoadMore: false,pos1: self.pos1)
                        }
                        
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
        vc.timelineVC = self
        pushVC(vc: vc)
    }

}
extension TimelineVC : UITableViewDelegate,UITableViewDataSource,TimelineCellDelegate {
    
    @objc func onClickReadMoreNew(sender : UIButton) {
        let index = sender.tag
        if  feedArray[index].isReadMore == nil {
            feedArray[index].isReadMore = false
        }
        
        if  feedArray[index].isReadMore {
            feedArray[index].isReadMore = false
        } else {
            feedArray[index].isReadMore = true
        }
        tbvTimeline.reloadData()
    }
    func onClickReadMore(indexPath: IndexPath, type: String) {
        if  feedArray[indexPath.row].isReadMore == nil {
              feedArray[indexPath.row].isReadMore = true
         }
        // print("onClickReadMore = = ")
        if type == "text" {
            let cell : TimeLineTextCell = tbvTimeline.cellForRow(at: indexPath) as! TimeLineTextCell
            
            if  feedArray[indexPath.row].isReadMore {
                cell.lblPostMessafe.numberOfLines = 0
//                cell.bReadMore.setTitle("Read Less", for: .normal)
                feedArray[indexPath.row].isReadMore = false
            } else {
                cell.lblPostMessafe.numberOfLines = 7
//                cell.bReadMore.setTitle("Read More", for: .normal)
                feedArray[indexPath.row].isReadMore = true
            }
        } else {
           let cell : TimeLineImageCell = tbvTimeline.cellForRow(at: indexPath) as! TimeLineImageCell
            
            if  feedArray[indexPath.row].isReadMore {
                cell.lblPostDescription.numberOfLines = 0
                cell.bReadMore.setTitle("", for: .normal)
                feedArray[indexPath.row].isReadMore = false
            } else {
                cell.lblPostDescription.numberOfLines = 7
                cell.bReadMore.setTitle("Read More", for: .normal)
                feedArray[indexPath.row].isReadMore = true
            }
            
            
        }
       
         
         tbvTimeline.reloadRows(at: [indexPath], with: .none)
    }
 
    func openLikeList(indexPath: IndexPath) {
        
        let data = feedArray[indexPath.row]
        
        if  data.like != nil {
            
            let pickerVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idTimelineLikedByVC")as! TimelineLikedByVC
            //        pickerVC.multiSocietyList.removeAll()
            //        pickerVC.multiSocietyList = self.multiSocietyArray
            //        pickerVC.context = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 0 for image type cell
        // 1 for text type cell
        let data = feedArray[indexPath.row]
        let cell = UITableViewCell()
        if feedArray[indexPath.row].feedType == "1"{
            
            let imageCell = tbvTimeline.dequeueReusableCell(withIdentifier: itemCell_image, for: indexPath)as! TimeLineImageCell
            let imageArray = feedArray[indexPath.row].feedImg
            imageCell.imgArray = imageArray!
//            print("image arr count == \(imageArray!.count)")
//            print("image arr count == \(imageArray!.count)")
            imageCell.pagerControl.numberOfPages = feedArray[indexPath.row].feedImg.count
            imageCell.pagerControl.hidesForSinglePage = true
            imageCell.lblUserName.text = feedArray[indexPath.row].userName
            Utils.setImageFromUrl(imageView: imageCell.imgUserProfile, urlString: feedArray[indexPath.row].userProfilePic, palceHolder: "user_default")
            imageCell.lblflatName.text =  feedArray[indexPath.row].blockName
            
            
            if imageArray!.count == 1 {
                
                if imageArray![0].feedHeight != nil && imageArray![0].feedHeight != "" && imageArray![0].feedHeight != "0"{
                    
                    let height = Int(imageArray![0].feedHeight)!
                    
                    if height >= 500 &&  height < 650 {
                        imageCell.conHeightPager.constant = 280
                        imageCell.isFitAspect = false
                    } else {
                        imageCell.conHeightPager.constant = 400
                        imageCell.isFitAspect = true
                    }
                    
                } else {
                    imageCell.conHeightPager.constant = 400
                    imageCell.isFitAspect = true
                }
                
            } else {
                imageCell.conHeightPager.constant = 400
                imageCell.isFitAspect = true
            }
            
            imageCell.ImgPager.reloadData()
            //            \(feedArray[indexPath.row].like.count)
            print(feedArray[indexPath.row].feedMsg!)
            imageCell.tvPostDescription.text = feedArray[indexPath.row].feedMsg
//            imageCell.tvPostDescription.translatesAutoresizingMaskIntoConstraints = false
//            imageCell.tvPostDescription.sizeToFit()
            imageCell.lblPostDateAndTime.text = feedArray[indexPath.row].modifyDate
            imageCell.delegate = self
            imageCell.indexPath = indexPath
//            if imageCell.lblPostDescription.calculateMaxLines() > 6 {
//                imageCell.bReadMore.isHidden = false
//            } else {
//                imageCell.bReadMore.isHidden = true
//            }
            
           /* DispatchQueue.main.async {
            
         
            imageCell.tvPostDescription.translatesAutoresizingMaskIntoConstraints = false
            imageCell.tvPostDescription.sizeToFit()
         
            if imageCell.tvPostDescription.numberOfLine() > 6 {
                imageCell.bReadMore.isHidden = false
                imageCell.heightConReadMore.constant = 20
                
                if  self.feedArray[indexPath.row].isReadMore != nil && self.feedArray[indexPath.row].isReadMore {
                    imageCell.bReadMore.setTitle("Read Less", for: .normal)
                    imageCell.heightConTextView.constant =  imageCell.tvPostDescription.textContainer.size.height + 16
                } else {
                    imageCell.bReadMore.setTitle("Read More", for: .normal)
                    imageCell.heightConTextView.constant = 120
                }
                
            } else {
                imageCell.bReadMore.isHidden = true
                imageCell.heightConReadMore.constant = 0
                imageCell.heightConTextView.constant =  imageCell.tvPostDescription.textContainer.size.height + 16
            }
            }*/
            
            if feedArray[indexPath.row].isShowReadMore {
                imageCell.bReadMore.isHidden = false
                imageCell.heightConReadMore.constant = 20
                
                if feedArray[indexPath.row].isReadMore {
                    imageCell.bReadMore.setTitle("", for: .normal)
                    imageCell.heightConTextView.constant = feedArray[indexPath.row].maxHeight
                } else {
                    imageCell.bReadMore.setTitle("Read More", for: .normal)
                    imageCell.heightConTextView.constant = feedArray[indexPath.row].minHeight
                }
                
            } else {
                imageCell.bReadMore.isHidden = true
                imageCell.heightConReadMore.constant = 0
                imageCell.heightConTextView.constant = feedArray[indexPath.row].minHeight
            }
            

            imageCell.bReadMore.tag = indexPath.row
           // imageCell.bReadMore.addTarget(self, action: #selector(onClickReadMoreNew(sender:)), for: .touchUpInside)
            
            
            imageCell.selectionStyle = .none
            
            if feedArray[indexPath.row].userId == doGetLocalDataUser().userID!{
                imageCell.bDelete.tag = indexPath.row
                imageCell.viewDelete.isHidden = false
                imageCell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
                imageCell.bEdit.tag = indexPath.row
                imageCell.viewEdit.isHidden = false
                imageCell.bEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
            }else{
                imageCell.viewDelete.isHidden = true
                imageCell.viewEdit.isHidden = true
            }
            
            if feedArray[indexPath.row].comment != nil{
                imageCell.lblCommentCount.text = "\(feedArray[indexPath.row].comment.count) Comments"
            }else{
                imageCell.lblCommentCount.text = "0 Comments"
            }
            
            if feedArray[indexPath.row].totalLikes != "0"{
                imageCell.delegate = self
                imageCell.indexPath = indexPath
                imageCell.viewLikedBy.isHidden = false
                var tempStr = ""
                switch data.totalLikes {
                case "1":
                    imageCell.imgUser0.isHidden = false
                    imageCell.imgUser1.isHidden = true
                    imageCell.imguser2.isHidden = true
                    
                    if data.like != nil{
                        if data.like[0].userProfilePic != nil{
                            
                            Utils.setImageFromUrl(imageView: imageCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                        }
                    }
                    
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You"
                    }else{
                        let username = data.like[0].userName
//                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!)"
                    }
                    break
                case "2":
                    imageCell.imgUser0.isHidden = false
                    imageCell.imgUser1.isHidden = false
                    imageCell.imguser2.isHidden = true
                    Utils.setImageFromUrl(imageView: imageCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    if data.like.count > 1{
                        Utils.setImageFromUrl(imageView: imageCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    }
                    
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and 1 others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                case "3":
                    imageCell.imgUser0.isHidden = false
                    imageCell.imgUser1.isHidden = false
                    imageCell.imguser2.isHidden = false
                    Utils.setImageFromUrl(imageView: imageCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imageCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    
                    if data.like.count > 2{
                        Utils.setImageFromUrl(imageView: imageCell.imguser2, urlString: data.like[2].userProfilePic, palceHolder: "user_default")
                    }
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and 2 others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                default:
                    imageCell.imgUser0.isHidden = false
                    imageCell.imgUser1.isHidden = false
                    imageCell.imguser2.isHidden = false
                    Utils.setImageFromUrl(imageView: imageCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imageCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imageCell.imguser2, urlString: data.like[2].userProfilePic, palceHolder: "user_default")
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and " + String(data.like.count - 1) + " Others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                }
                imageCell.lblLikeByDesc.text = tempStr
                imageCell.lblPostLIkeCount.text = "\(String(describing: feedArray[indexPath.row].totalLikes!)) Likes"
            }else{
                imageCell.viewLikedBy.isHidden = true
                imageCell.lblPostLIkeCount.text = "0 Likes"
                
            }
            
            if feedArray[indexPath.row].likeStatus == "0"{
                imageCell.imgLike.tintColor = ColorConstant.grey_40
                imageCell.imgLike.image = imageCell.imgLike.image?.withRenderingMode(.alwaysTemplate)
            }else {
                imageCell.imgLike.tintColor = ColorConstant.primaryColor
                imageCell.imgLike.image = imageCell.imgLike.image?.withRenderingMode(.alwaysTemplate)
                
            }
            
            if feedArray[indexPath.row].commentStatus == "1"{
                
                imageCell.imgComment.tintColor = ColorConstant.primaryColor
                imageCell.imgComment.image = imageCell.imgComment.image?.withRenderingMode(.alwaysTemplate)
                
            }else if feedArray[indexPath.row].commentStatus == "0"{
                
                imageCell.imgComment.tintColor = ColorConstant.grey_40
                imageCell.imgComment.image = imageCell.imgComment.image?.withRenderingMode(.alwaysTemplate)
                
            }
            imageCell.parentViewController = self
            imageCell.btnLike.tag = indexPath.row
            imageCell.bProfileClick.tag = indexPath.row
            imageCell.btnLike.addTarget(self, action: #selector(didClickLike(_:)), for: .touchUpInside)
            imageCell.btnComment.tag = indexPath.row
            imageCell.btnComment.addTarget(self, action: #selector(didClickComment(_:)), for: .touchUpInside)
            imageCell.bProfileClick.addTarget(self, action: #selector(onClickUserProfile(_:)), for: .touchUpInside)

            
            
            if isMyTimeLine {
//                if feedArray[indexPath.row].userId == doGetLocalDataUser().userID{
//                    imageCell.viewDelete.isHidden = false
//                    imageCell.viewEdit.isHidden = false
//                    imageCell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
//                imageCell.bDelete.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
//
//                } else {
//                    imageCell.viewDelete.isHidden = true
//                    imageCell.viewEdit.isHidden = false
//
//                }
                
            }else {
                if indexPath.row == feedArray.count - 1 {
                    self.limit_feed += 10
                    self.doLoadFeed(limit_feed:self.limit_feed, isLoadMore: true,pos1: self.pos1)
                    print("your reach last")
                }
//                imageCell.viewDelete.isHidden = true
            }
            if feedArray[indexPath.row].societyId == "0"{
                imageCell.viewLikeComment.isHidden = true
            }else{
                imageCell.viewLikeComment.isHidden = false
            }
            
            
            return imageCell
            
        }else if feedArray[indexPath.row].feedType == "0"{
            
            let textCell = tbvTimeline.dequeueReusableCell(withIdentifier: itemCell_text, for: indexPath)as! TimeLineTextCell
            textCell.delegate = self
            Utils.setImageFromUrl(imageView: textCell.imgUserProfile, urlString: feedArray[indexPath.row].userProfilePic, palceHolder: "user_default")
            textCell.textViewPostMessage.text = feedArray[indexPath.row].feedMsg
            //textCell.textViewPostMessage.translatesAutoresizingMaskIntoConstraints = false
            //textCell.textViewPostMessage.sizeToFit()
            textCell.lblPostDate.text = feedArray[indexPath.row].modifyDate
            
            if feedArray[indexPath.row].comment != nil{
                textCell.lblCommentCount.text = "\(feedArray[indexPath.row].comment.count) Comments"
            }else{
                textCell.lblCommentCount.text = "0 Comments"
            }
            
            
//            DispatchQueue.main.async {
//                if textCell.textViewPostMessage.numberOfLine() > 6 {
//                              textCell.bReadMore.isHidden = false
//                              textCell.heightConReadMore.constant = 20
//
//                    if  self.feedArray[indexPath.row].isReadMore != nil && self.feedArray[indexPath.row].isReadMore {
//                                  textCell.bReadMore.setTitle("Read Less", for: .normal)
//                                  textCell.heightConTextView.constant =  textCell.textViewPostMessage.textContainer.size.height + 16
//                              } else {
//                                  textCell.bReadMore.setTitle("Read More", for: .normal)
//                                     textCell.heightConTextView.constant = 120
//                              }
//
//                          } else {
//                              textCell.bReadMore.isHidden = true
//                              textCell.heightConReadMore.constant = 0
//                               textCell.heightConTextView.constant =  textCell.textViewPostMessage.textContainer.size.height + 16
//                          }
//
//            }
//
            if feedArray[indexPath.row].isShowReadMore {
                textCell.bReadMore.isHidden = false
                textCell.heightConReadMore.constant = 20
                
                if feedArray[indexPath.row].isReadMore {
                    textCell.bReadMore.setTitle("", for: .normal)
                    textCell.heightConTextView.constant = feedArray[indexPath.row].maxHeight
                } else {
                    textCell.bReadMore.setTitle("Read More", for: .normal)
                    textCell.heightConTextView.constant = feedArray[indexPath.row].minHeight
                }
                
            } else {
                textCell.bReadMore.isHidden = true
                textCell.heightConReadMore.constant = 0
                textCell.heightConTextView.constant = feedArray[indexPath.row].minHeight
            }
          
            textCell.indexPath = indexPath
            textCell.bReadMore.tag = indexPath.row
            textCell.bReadMore.addTarget(self, action: #selector(onClickReadMoreNew(sender:)), for: .touchUpInside)
            
            if feedArray[indexPath.row].totalLikes != "0"{
               // textCell.delegate = self
               // textCell.indexPath = indexPath
                textCell.viewLikedByUsers.isHidden = false
                var tempStr = ""
                switch data.totalLikes {
                case "1":
                    textCell.imgUser0.isHidden = false
                    textCell.imgUser1.isHidden = true
                    textCell.imguser2.isHidden = true
                    if data.like != nil{
                        if data.like[0].userProfilePic != nil{
                            Utils.setImageFromUrl(imageView: textCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                        }
                    }
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You "
                    }else{
                        let username = data.like[0].userName
//                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!)"
                    }
                    break
                case "2":
                    textCell.imgUser0.isHidden = false
                    textCell.imgUser1.isHidden = false
                    textCell.imguser2.isHidden = true
                    Utils.setImageFromUrl(imageView: textCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    if data.like.count > 1{
                        Utils.setImageFromUrl(imageView: textCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    }
                    
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and 1 others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                case "3":
                    textCell.imgUser0.isHidden = false
                    textCell.imgUser1.isHidden = false
                    textCell.imguser2.isHidden = false
                    Utils.setImageFromUrl(imageView: textCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: textCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    if data.like.count > 2{
                        Utils.setImageFromUrl(imageView: textCell.imguser2, urlString: data.like[2].userProfilePic, palceHolder: "user_default")
                    }
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and 2 others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                default:
                    textCell.imgUser0.isHidden = false
                    textCell.imgUser1.isHidden = false
                    textCell.imguser2.isHidden = false
                    Utils.setImageFromUrl(imageView: textCell.imgUser0, urlString: data.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: textCell.imgUser1, urlString: data.like[1].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: textCell.imguser2, urlString: data.like[2].userProfilePic, palceHolder: "user_default")
                    if data.likeStatus == "1"{
                        tempStr = "Liked by You and " + String(data.like.count - 1) + " Others"
                    }else{
                        let username = data.like[0].userName
                        let count = String(Int(data.totalLikes!)! - 1)
                        tempStr = "Liked by \(username!) and \(count) Others"
                    }
                    break
                }
                textCell.lblLikeByDesc.text = tempStr
                textCell.lblLikeCount.text = "\(String(describing: feedArray[indexPath.row].totalLikes!)) Likes"
            }else{
                textCell.viewLikedByUsers.isHidden = true
                textCell.lblLikeCount.text = "0 Likes"
            }
            
            if feedArray[indexPath.row].commentStatus == "1"{
                
                textCell.imgComment.setImageColor(color: ColorConstant.primaryColor)
                
            }else if feedArray[indexPath.row].commentStatus == "0"{
                textCell.imgComment.setImageColor(color: ColorConstant.grey_40)
                
            }
           
            if feedArray[indexPath.row].likeStatus == "0" {
                textCell.imgLike.setImageColor(color: ColorConstant.grey_40)
            }else {
                textCell.imgLike.setImageColor(color: ColorConstant.primaryColor)
            }
            
            if feedArray[indexPath.row].userId == doGetLocalDataUser().userID!{
                textCell.viewDelete.isHidden = false
                textCell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
                textCell.viewEdit.isHidden = false
                textCell.BEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
            }else{
                textCell.viewDelete.isHidden = true
                textCell.viewEdit.isHidden = true
            }
            textCell.lblUserName.text = feedArray[indexPath.row].userName
            textCell.lblBlockName.text = feedArray[indexPath.row].blockName
            textCell.btnLike.tag = indexPath.row
            textCell.bDelete.tag = indexPath.row
            textCell.BEdit.tag = indexPath.row
            textCell.bProfileClick.tag = indexPath.row
            textCell.btnLike.addTarget(self, action: #selector(didClickLike(_:)), for: .touchUpInside)
            textCell.btnComment.tag = indexPath.row
            textCell.btnComment.addTarget(self, action: #selector(didClickComment(_:)), for: .touchUpInside)
            textCell.bProfileClick.addTarget(self, action: #selector(onClickUserProfile(_:)), for: .touchUpInside)
            
            if isMyTimeLine {
//                if feedArray[indexPath.row].userId == doGetLocalDataUser().userID{
//                    textCell.viewDelete.isHidden = false
//                    textCell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
//
//                } else {
//                    textCell.viewDelete.isHidden = true
//                }
            } else {
                if indexPath.row == feedArray.count - 1 {
                    
                    self.limit_feed += 10
                    self.doLoadFeed(limit_feed:self.limit_feed, isLoadMore: true,pos1: self.pos1)
                    print("your reach last")
                }
//                textCell.viewDelete.isHidden = true
            }
            
            if feedArray[indexPath.row].societyId == "0"{
                
            }else{
                
            }
            if feedArray[indexPath.row].societyId == "0"{
                textCell.viewLikeComment.isHidden = true
            }else{
                textCell.viewLikeComment.isHidden = false
            }
            textCell.selectionStyle = .none
            return textCell
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
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
    
    var vissibleTextLength: Int {
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
//extension UILabel {
//
//    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
//        let readMoreText: String = trailingText + moreText
//
//        let lengthForVisibleString: Int = self.vissibleTextLength
//        let mutableString: String = self.text!
//        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
//        let readMoreLength: Int = (readMoreText.count)
//        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
//        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
//        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
//        answerAttributed.append(readMoreAttributed)
//        self.attributedText = answerAttributed
//    }
//
//    var vissibleTextLength: Int {
//        let font: UIFont = self.font
//        let mode: NSLineBreakMode = self.lineBreakMode
//        let labelWidth: CGFloat = self.frame.size.width
//        let labelHeight: CGFloat = self.frame.size.height
//        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
//
//        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
//        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
//        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
//
//        if boundingRect.size.height > labelHeight {
//            var index: Int = 0
//            var prev: Int = 0
//            let characterSet = CharacterSet.whitespacesAndNewlines
//            repeat {
//                prev = index
//                if mode == NSLineBreakMode.byCharWrapping {
//                    index += 1
//                } else {
//                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
//                }
//            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
//            return prev
//        }
//        return self.text!.count
//    }
//}
extension TimelineVC: AppDialogDelegate{
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


extension UILabel {

    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }

}

extension UITextView {
    func sizeFit(width: CGFloat) -> CGSize {
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }

    func numberOfLine() -> Int {
        let size = self.sizeFit(width: self.bounds.width)
        let numLines = Int(size.height / (self.font?.lineHeight ?? 1.0))
        return numLines
    }
}
extension UILabel{

public var requiredHeight: CGFloat {
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
