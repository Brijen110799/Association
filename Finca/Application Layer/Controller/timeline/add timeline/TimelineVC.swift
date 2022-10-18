//
//  TimelineVC.swift
//  Finca
//
//  Created by harsh panchal on 19/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import AVFoundation
import AVKit
import VersaPlayer
import Lightbox
import XLPagerTabStrip
class TimelineVC: BaseVC {
    
    
    var reportIndex = 0
    @IBOutlet weak var lbvendorbottom: UILabel!
    @IBOutlet weak var lblsgvendortitle: UILabel!
    @IBOutlet weak var lblsgtimelinetitle: UILabel!
    @IBOutlet weak var lbltimelinebottom: UILabel!
    @IBOutlet weak var viewsegment: UIView!
    var isMainTimeline = ""
    @IBOutlet weak var HeigtSegmentview: NSLayoutConstraint!
    @IBOutlet weak var lblMainreportTitle: UILabel!
    @IBOutlet weak var lbselectreporttitle: UILabel!
    @IBOutlet weak var bottomconstrainAddreport: NSLayoutConstraint!
    @IBOutlet weak var btSubmit: UIButton!
    @IBOutlet weak var txtreport: UITextView!
    @IBOutlet weak var lblselectreport: UILabel!
    @IBOutlet weak var tblreport: UITableView!
    @IBOutlet weak var Viewmainreport: UIView!
    @IBOutlet weak var Bottomconstrainreportview: NSLayoutConstraint!
    @IBOutlet weak var imgvwSaveFeed:UIImageView!
    @IBOutlet weak var btnSaveFeed: UIButton!
    @IBOutlet weak var tbvTimeline: UITableView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnFloatingButton: UIView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewNotification: UIView!
    var feedArray = [FeedModel]()
    let itemCell_image  = "TimeLineImageCell"
    let itemCell_text = "TimeLineTextCell"
    let itemreportCell  = "Reportcell"
    var showLoader = true
    var initialLoad = true
    var isPersonalTimeline = false
    var memMainResponse : MemberDetailResponse!
    var totalFeed = ""
    var StrVideoUrl = ""
    var pos1 = 0
    var selectedIndex = -1
    var uploadtype = ""
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
    var membermiddleName : String!
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
    var playerView : VersaPlayerView!
    var strArray = [String]()
    private var updatList = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbvendorbottom.isHidden = true
        self.lbltimelinebottom.isHidden = false
        
        
        strArray = doGetValueLanguageArrayString(forKey: "report_type")
        self.tblreport.reloadData()
        
        print(strArray)
        
        btnFloatingButton.layer.shadowRadius = 5
        btnFloatingButton.layer.shadowOffset = CGSize.zero
        btnFloatingButton.layer.shadowOpacity = 0.3
        btnFloatingButton.clipsToBounds = true
        btnFloatingButton.borderWidth = 0.4
        btnFloatingButton.borderColor = .black
        viewNoData.clipsToBounds = true
        self.viewNoData.isHidden = true
        
        imgvwSaveFeed.setImageWithTint(ImageName: "bookmark", TintColor: ColorConstant.grey_60)
        
//        let nib1 = UINib(nibName: itemCell_image, bundle: nil)
//        tbvTimeline.register(nib1, forCellReuseIdentifier: itemCell_image)
//
//        let nib2 = UINib(nibName: itemCell_text, bundle: nil)
//        tbvTimeline.register(nib2, forCellReuseIdentifier: itemCell_text)
        
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvTimeline.register(nib, forCellReuseIdentifier: itemCell)
        
        tbvTimeline.estimatedRowHeight = 300
        tbvTimeline.rowHeight = UITableView.automaticDimension
        tbvTimeline.delegate = self
        tbvTimeline.dataSource = self
        addRefreshControlTo(tableView: self.tbvTimeline)
        
        
        let nib1 = UINib(nibName: itemreportCell, bundle: nil)
        tblreport.register(nib1, forCellReuseIdentifier: itemreportCell)
        
        tblreport.estimatedRowHeight = 50
        tblreport.rowHeight = UITableView.automaticDimension
        tblreport.delegate = self
        tblreport.dataSource = self
        tblreport.clipsToBounds = true
        
        lbHeader.text = doGetValueLanguage(forKey: "timeline")
        if isMyTimeLine {
            unit_id = doGetLocalDataUser().unitID ?? ""
            if isMemberTimeLine {
                
                if doGetLocalDataUser().userID == user_id
                {
                   lbHeader.text = "My Timeline"
                }
                else{
                    lbHeader.text = memberFirstName.capitalizingFirstLetter() + " " + memerLastName.capitalizingFirstLetter() + "\(doGetValueLanguage(forKey: "timeline_s"))"
                }
               
                btnFloatingButton.isHidden = true
                getMyFeed = "getOtherFeed"
            } else {
                lbHeader.text = "My Timeline"
                getMyFeed = "getMyFeed"
            }
            viewHome.isHidden = true
            ivMenu.image = UIImage(named: "back")
            ivMenu.setImageColor(color: UIColor(named: "defultIconTintColor") ?? .gray)
            bBack.isHidden = false
            
        } else {
                  
            bBack.isHidden = true
            unit_id = doGetLocalDataUser().unitID!
            doInintialRevelController(bMenu: bMenu)
        }
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        customView.backgroundColor = UIColor.clear
        tbvTimeline.tableFooterView = customView
        
        
        fetchNewDataOnRefresh()
        
        if isMainTimeline == "yes"
        {
            if self.isKeyPresentInUserDefaults(key: StringConstants.show_service_provider_timeline_seprate) {
                if let vendortimeline = UserDefaults.standard.string(forKey: StringConstants.show_service_provider_timeline_seprate) {
                    if vendortimeline == "0"
                    {
                        viewsegment.isHidden = true
                        HeigtSegmentview.constant = 0
    //                    segmentcontroll.setTitle(doGetValueLanguage(forKey: "timeline"), forSegmentAt: 0)
    //                    segmentcontroll.removeSegment(at: 1, animated: false)
                       
                        
                    }
                    else{
                        viewsegment.isHidden = false
                        HeigtSegmentview.constant = 50
                      
                    }
                }
            }
            
        }
        else{
            viewsegment.isHidden = true
            HeigtSegmentview.constant = 0
        }
        
        self.lblsgvendortitle.text = doGetValueLanguage(forKey: "vendor_timeline")
        self.lblsgtimelinetitle.text = doGetValueLanguage(forKey: "timeline")
        
       
        
      
        self.Viewmainreport.isHidden = true
        self.Bottomconstrainreportview.constant = -1000
        self.bottomconstrainAddreport.constant = -500
        self.addKeyboardAccessory(textViews: [self.txtreport])
        
        self.lbselectreporttitle.text = doGetValueLanguage(forKey: "report_post")
        self.lblMainreportTitle.text = doGetValueLanguage(forKey: "report_post")
        self.txtreport.placeholder = doGetValueLanguage(forKey: "add_message")
        self.btSubmit.setTitle(doGetValueLanguage(forKey: "submit"), for: .normal)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= 100
//            self.bottomconstrainAddreport.constant = 350
//        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.bottomconstrainAddreport.constant = keyboardHeight-40
            
            }
        
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
            self.bottomconstrainAddreport.constant = 0
       // }
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
                      "block_name":doGetLocalDataUser().company_name ?? "",
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
                    }else if response.status == "202"{
                        self.btnFloatingButton.isHidden = true
                        self.viewNoData.isHidden = false
                        self.lbNoData.text = response.message
                    }else  {
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
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
        if updatList != "" {
            updatList = ""
            fetchNewDataOnRefresh()
        }
    }
    override func fetchNewDataOnRefresh() {
//        feedArray.removeAll()
//        tbvTimeline.reloadData()
//        refreshControl.beginRefreshing()
//        if feedArray.count > 0 {
//            feedArray.removeAll()
//        }
//
//        refreshControl.endRefreshing()
   
        hidePull()
        feedArray.removeAll()
        tbvTimeline.reloadData()
      
        if isMyTimeLine {
            doLoadPersonalFeed()
        } else {
            limit_feed = 0
            pos1 = 0
            doLoadFeed(limit_feed: limit_feed, isLoadMore: false , pos1: pos1, strUploadtype: self.uploadtype)
        }
        tbvTimeline.beginUpdates()
        tbvTimeline.endUpdates()
     
    }
    
    @IBAction func btnVendorTimelineAction(_ sender: Any) {
        
        self.btnFloatingButton.isHidden = true
        
        self.lbvendorbottom.isHidden = false
        self.lbltimelinebottom.isHidden = true
        
        self.lblsgvendortitle.textColor = UIColor.black
        self.lblsgtimelinetitle.textColor = UIColor(named: "grey_60")
        self.feedArray.removeAll()
        tbvTimeline.reloadData()
        
        self.totalFeed = ""
        self.uploadtype = "1"
        limit_feed = 0
        pos1 = 0
        doLoadFeed(limit_feed: limit_feed, isLoadMore: false , pos1: pos1, strUploadtype: self.uploadtype)
        
        
    }
    
    @IBAction func btnTimelineAction(_ sender: Any) {
        
        self.btnFloatingButton.isHidden = false
        self.lbvendorbottom.isHidden = true
        self.lbltimelinebottom.isHidden = false
        
        self.lblsgtimelinetitle.textColor = UIColor.black
        self.lblsgvendortitle.textColor = UIColor(named: "grey_60")
        
        self.feedArray.removeAll()
        tbvTimeline.reloadData()
        
        self.totalFeed = ""
        self.uploadtype = "0"
        limit_feed = 0
        pos1 = 0
        doLoadFeed(limit_feed: limit_feed, isLoadMore: false , pos1: pos1, strUploadtype: self.uploadtype)
        
        
        
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
        initialLoad = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func didClickLike(_ sender : UIButton ){
             
        let feedid = feedArray[sender.tag].feedId
        let indexpath = sender.tag
        let cell = tbvTimeline.cellForRow(at:IndexPath(row: indexpath, section: 0)) as! TimeLineCell
        if feedArray[sender.tag].likeStatus == "0" {
              self.feedArray[sender.tag].likeStatus = "1"
            // self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! + 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "0",indexpath:sender.tag)
            
            cell.doSetupLike(likeStatus: "1")
            if feedArray[sender.tag].like == nil {
                feedArray[sender.tag].like = [LikeModel]()
            }
//            feedArray[sender.tag].like.append(LikeModel(likeId: "", feedId: feedid ?? "", userId: doGetLocalDataUser().userID!, userName: doGetLocalDataUser().userFullName!, blockName: doGetLocalDataUser().companyName ?? "", modifyDate: "", userProfilePic: doGetLocalDataUser().userProfilePic!))
            
            feedArray[sender.tag].like.append(LikeModel(likeId: "", feedId: feedid ?? "", userId: doGetLocalDataUser().userID!, userName: doGetLocalDataUser().userFullName!, blockName: doGetLocalDataUser().company_name ?? "", modifyDate: "", userProfilePic: doGetLocalDataUser().userProfilePic!))
            
            cell.setUpLikeView(item: feedArray[indexpath], profilePic: doGetLocalDataUser().userProfilePic ?? "", userID: doGetLocalDataUser().userID ?? "")
            
            
        } else {
               self.feedArray[sender.tag].likeStatus = "0"
            cell.doSetupLike(likeStatus: "0")
          //  self.feedArray[indexpath].totalLikes =  String(Int(self.feedArray[indexpath].totalLikes!)! - 1)
            doCallLikeAPi(feedid:feedid , likeStatus: "1",indexpath:sender.tag)
            
            if feedArray[sender.tag].like != nil && feedArray[sender.tag].like.count > 0 {
                for (index,item) in feedArray[sender.tag].like.enumerated() {
                    if item.userId == doGetLocalDataUser().userID {
                        feedArray[sender.tag].like.remove(at: index)
                    }
                }
            }
            
            cell.setUpLikeView(item: feedArray[indexpath], profilePic: doGetLocalDataUser().userProfilePic ?? "", userID: doGetLocalDataUser().userID ?? "")
          
        }
      
       
       // tbvTimeline.reloadRows(at: [IndexPath(row: indexpath, section: 0)], with: .none)
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
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.bottomconstrainAddreport.constant = -500
        self.Bottomconstrainreportview.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    @objc func onClickcallus(_ sender : UIButton ){
        
        if feedArray[sender.tag].user_mobile != ""
        {
            doCall(on: feedArray[sender.tag].user_mobile!)
        }
       
    }
    
    @IBAction func btnclosereport(_ sender: Any) {
        
        self.Viewmainreport.isHidden = true
        self.bottomconstrainAddreport.constant = -500
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onClickUserProfile(_ sender : UIButton ){
        let index = sender.tag
        if  feedArray[index].upload_by_type == "1"
        {
            let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
            nextVC.service_provider_users_id = feedArray[index].userId!
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        else{
            if feedArray[index].userId != "0" {
                if feedArray[index].userId == doGetLocalDataUser().userID {
                    //self profile
                    let destiController = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserProfileVC") as! UserProfileVC
                    let newFrontViewController = UINavigationController.init(rootViewController: destiController)
                    newFrontViewController.isNavigationBarHidden = true
                    revealViewController().pushFrontViewController(newFrontViewController, animated: true)
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
                if let strAdminpost = feedArray[index].admin_post
                {
                    if strAdminpost != ""
                    {
                        toast(message: strAdminpost, type: .Information)
                    }
                    
                }
                
            }
            
            
        }

    }
    
    @IBAction func btreportsubmit(_ sender: Any) {
       
        
        if reportIndex == strArray.count - 1
        {
            if txtreport.text == ""
            {
                self.showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_message"))
            }
            else{
                self.doCallReportApi(commonid: self.feedId, strtype: "1", violencefor: lblselectreport.text!, violencemessage:self.txtreport.text!)
//                self.txtreport.text = ""
            }
        }
        else{
            self.doCallReportApi(commonid: self.feedId, strtype: "1", violencefor: lblselectreport.text!, violencemessage:self.txtreport.text!)
            
        }
        
        //if lblselectreport.text = ""
     
      
        
    }
    @objc func onClickDeletePost(_ sender : UIButton ){
        
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete this post?", style: .Delete)
        selectedIndex = sender.tag
//        confirmDailog(id: feedArray[index].feedId)
        
    }
    @IBAction func btnreportcloseAction(_ sender: Any) {
        self.txtreport.resignFirstResponder()
        self.bottomconstrainAddreport.constant = -500
        self.Viewmainreport.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func onClickReportPost(_ sender : UIButton ){
        if let cell = tbvTimeline.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? TimeLineCell  {
            cell.isShowView = true
            cell.ConHeightMoreView.constant = 0
        }
        self.feedId = self.feedArray[sender.tag].feedId
        self.Viewmainreport.isHidden = false
        self.Bottomconstrainreportview.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
        nextVC.onSuccessTimeline = self
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
    
    func doCallReportApi(commonid:String!,strtype:String!,violencefor:String!,violencemessage:String!) {
        //        showProgress()
        
//        let params = ["addReport":"addReport",
//                      "common_id":commonid!,
//                      "society_id":doGetLocalDataUser().societyID!,
//                      "user_id":doGetLocalDataUser().userID!,
//                      "unit_id":doGetLocalDataUser().unitID!,
//                      "user_name":doGetLocalDataUser().userFullName!,
//                      "violence_type":violencetype,
//                      "violence_for":violencefor,
//                      "violencemessage":violencemessage]
        let params = ["addReport":"addReport",
                      "common_id":commonid!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "violence_type":strtype!,
                      "violence_for":violencefor!,
                      "violence_message":violencemessage!]
        
        print("like param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.violencecontroller, parameters: params) { (json, error) in
            //            self.hideProgress()
            
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        
                      //  print("Save response")
                        self.showLoader = false
                        
                        self.bottomconstrainAddreport.constant = -500
                        self.Viewmainreport.isHidden = true
                        UIView.animate(withDuration: 0.5) {
                            self.view.layoutIfNeeded()
                        }
                        
                        self.showLoader = true
                        self.txtreport.text = ""
                        self.toast(message:response.message, type: .Information)
                    
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
        nextVC.onSuccessTimeline = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func doLoadFeed(limit_feed:Int! , isLoadMore : Bool , pos1 : Int!,strUploadtype:String) {
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
                      "getFeedFastNew":"getFeedFastNew",  //"getFeedFast":"getFeedFast"
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? "",
                      "limit_feed" : String(limit_feed),
                      "pos1":String(pos1),
                      "upload_by_type":strUploadtype]
        
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
                        self.viewNotification.isHidden = true
                        
                         self.viewNoData.isHidden = false
                        self.lbNoData.text = response.message
                        self.btnFloatingButton.isHidden = true
                    } else {
                        self.tbvTimeline.reloadData()
                        self.viewNoData.isHidden = false
                    }
                } catch {
                    print("parse error",error.localizedDescription,error)
                }
            }else if error != nil{
                self.showNoInternetToast()
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
                    
                    let height = CGFloat(Double(item.feedImg[0].feedHeight ?? "0") ?? 0 ) - heightOffset
                  //  print("height == \(height)")
                    tempArray[index].imageHeight = height
//                    if height > 600 {
//                        tempArray[index].imageHeight = 600
//                    } else {
//                        tempArray[index].imageHeight = height
//                    }
                    
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
        goToDashBoard(storyboard: mainStoryboard)
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
        updatList = "1"
        let vc = subStoryboard.instantiateViewController(withIdentifier: "SavedTimelineVC") as! SavedTimelineVC
       // vc.timelineVC = self
        pushVC(vc: vc)
   
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
                      "block_name":doGetLocalDataUser().company_name ?? ""]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.newsFeedController, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(FeedResponse.self, from:json!)
                    if response.status == "200" {
                        self.feedArray.removeAll()
                        if self.isMyTimeLine{
                            self.doLoadPersonalFeed()
                        }else{
                            self.doLoadFeed(limit_feed: self.limit_feed, isLoadMore: false,pos1: self.pos1, strUploadtype: self.uploadtype)
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
    override func viewWillDisappear(_ animated: Bool) {
       
        DispatchQueue.main.async {
            
            if  self.playerView != nil {
                self.playerView.pause()
             }
        }
      
    }
}
extension TimelineVC : UITableViewDelegate,UITableViewDataSource , TimelineCellDelegate {
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
        if tableView == self.tblreport
        {
            return self.strArray.count
        }
        else{
            return feedArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tblreport
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: itemreportCell, for: indexPath)as! Reportcell
            cell.lblreportype.text = self.strArray[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
        else{
            
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
            
            cell.btnreport.setTitle(doGetValueLanguage(forKey: "report_post"), for: .normal)
            cell.bEdit.setTitle(doGetValueLanguage(forKey: "edit"), for: .normal)
            cell.bDelete.setTitle(doGetValueLanguage(forKey: "delete"), for: .normal)
            
            cell.lblcallus.text = doGetValueLanguage(forKey: "call_us")
           
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
                cell.viewImage.isHidden = true
                cell.viewVideo.isHidden = true
                cell.viewcard.isHidden = true
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
                cell.ivComment.setImageColor(color: ColorConstant.primaryColor)
                cell.ivComment.image = UIImage(named: "text_sms_selected")
                
            }else {
                cell.ivComment.setImageColor(color: ColorConstant.grey_40)
                cell.ivComment.image = UIImage(named: "text_sms_unselected")
            }
            
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
                cell.ivSave.image = UIImage(named: "Unbookmark")
            }else {
                cell.ivSave.setImageColor(color: ColorConstant.primaryColor)
                cell.ivSave.image = UIImage(named: "bookmark")
            }
            
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
            
            if item.userId == doGetLocalDataUser().userID!{
                cell.bDelete.tag = indexPath.row
                cell.viewDelete.isHidden = false
                cell.bDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
                cell.bEdit.tag = indexPath.row
                //cell.viewEdit.isHidden = false
                cell.bEdit.addTarget(self, action: #selector(onClickEditPost(_:)), for: .touchUpInside)
                cell.viewCall.isHidden = true
                if item.upload_by_type == "0"
                {
                    cell.bEdit.isHidden = false
                    cell.bDelete.isHidden = false
                    cell.btnreport.isHidden = true
                    
                }
                else{
                    cell.bEdit.isHidden = true
                    cell.bDelete.isHidden = true
                    cell.btnreport.isHidden = false
                }
              
                
                
            }else{
                cell.viewDelete.isHidden = false
                cell.bEdit.isHidden = true
                cell.bDelete.isHidden = true
                cell.bCall.tag = indexPath.row
                cell.bCall.addTarget(self, action: #selector(tapCall(_:)), for: .touchUpInside)
                cell.viewCall.isHidden = true
                if item.user_mobile ?? "" != "" && item.user_mobile?.count ?? 0 > 1 {
                    cell.viewCall.isHidden = true
                }
                
                cell.btnreport.addTarget(self, action: #selector(onClickReportPost(_:)), for: .touchUpInside)
                if item.upload_by_type == "0"
                {
                    cell.bEdit.isHidden = true
                    cell.bDelete.isHidden = true
                    cell.btnreport.isHidden = false
                    
                }
                else{
                        cell.bEdit.isHidden = true
                        cell.bDelete.isHidden = true
                        cell.btnreport.isHidden = false
                }
                
                
            }
            
           
            
    //        cell.btncallus.setTitle(, for: .normal)
            cell.btncallus.tag = indexPath.row
            cell.btncallus.addTarget(self, action: #selector(onClickcallus(_:)), for: .touchUpInside)
            
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
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblreport
        {
            reportIndex = indexPath.row
            
            lblselectreport.text = strArray[indexPath.row]
            self.Bottomconstrainreportview.constant = -500
            
            self.bottomconstrainAddreport.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == tblreport
        {
            
        }
        else{
            if feedArray[indexPath.row].feedType == "2" {
                
              }
            if !isMyTimeLine {
                if indexPath.row == feedArray.count - 1 {
                    
                    if feedArray.count < 10
                    {
                        
                    }
                    else{
                        self.limit_feed += 10
                        self.doLoadFeed(limit_feed:self.limit_feed, isLoadMore: true,pos1: self.pos1, strUploadtype: uploadtype)
                    }
                   
                    print("your reach last")
                }
            }
            
        }
         /// guard let videoCell = (cell as? TimeLineCell) else { return };
        
      
        
      }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if tableView == tblreport
        {
            
        }
        else{
        if feedArray.count == 0 {
            return
        }
        guard let videoCell = cell as? TimeLineCell else { return };
        if feedArray[indexPath.row].feedType == "2" {
            if videoCell.playerView.isPlaying {
                videoCell.playerView.pause()
            }
            
        }
        }
       
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

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
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

extension TimelineVC: AppDialogDelegate , OnChangeCount  , OnSuccessTimeline{
    func onSuccessTimeline() {
        fetchNewDataOnRefresh()
    }
    
    
    func doChangeCommentCount(index : Int , commentArray : [CommentModel] , comment_status  :String) {
        feedArray[index].comment = commentArray
        feedArray[index].commentStatus = comment_status
        tbvTimeline.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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
