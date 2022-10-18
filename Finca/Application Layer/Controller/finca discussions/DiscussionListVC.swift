//
//  DisussionListVC.swift
//  Finca
//
//  Created by harsh panchal on 28/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkeletonView
class DiscussionListVC: BaseVC {

    var youtubeVideoID = ""
    @IBOutlet weak var Vwvideo:UIView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewSearch: UIStackView!
    @IBOutlet weak var viewFab: UIView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewSuperParent: UIView!
    @IBOutlet weak var tbvData: UITableView!
    let itemCell = "DiscussionListCell"
    private var didShowInitialSkeleton = false
    var discussionList = [DiscussionListModel](){
        didSet{
            self.filterList = self.discussionList
        }
    }
    @IBOutlet weak var viewMute: UIView!
    @IBOutlet weak var viewUnmute: UIView!
    var filterList = [DiscussionListModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }

    @IBOutlet weak var viewDateFilter: UIView!
    @IBOutlet weak var dateFilterStackView: UIStackView!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var lblFilterEndDate: UILabel!
    @IBOutlet weak var viewClearFilter: UIView!
   
    @IBOutlet weak var ivBell: UIImageView!
    
    var StartDateString = ""
    var StartDateObject : Date!
    var EndDate = ""
    var mute = "1"
    var menuTitle  = ""
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblStartDiscussion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.estimatedRowHeight = 200
        self.viewSuperParent.showAnimatedGradientSkeleton()
        tfSearch.addTarget(self, action: #selector(doFilterArray(_: )), for: .editingChanged )
        doneButtonOnKeyboard(textField: tfSearch)
        addRefreshControlTo(tableView: tbvData)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        tbvData.isHidden=true
        lblScreenTitle.text = doGetValueLanguage(forKey: "discussion_forum")
        lblNoData.text = doGetValueLanguage(forKey: "no_data_available")
        lblStartDiscussion.text = doGetValueLanguage(forKey: "start_discussion")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search"))
        if youtubeVideoID != ""
        {
            Vwvideo.isHidden = false
        }else
        {
            Vwvideo.isHidden = true
        }
        self.ivBell.setImageColor(color: ColorConstant.colorP)
    }

    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        tfSearch.text = ""
        self.doCallApi()
    }
    @IBAction func btnMuteAll(_ sender: UIButton) {
        self.doChangeMuteState(to:mute)
    }

    @IBAction func btnUnMuteAll(_ sender: Any) {
        self.doChangeMuteState(to:"0")
    }

    func doChangeMuteState(to State:String!) {
      //  print("State  " , State)
        self.showProgress()
        let params = ["muteAllDiscussion":"muteAllDiscussion",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "discussion_mute":State!]
        print("parmas " , params )
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        
                        self.toast(message: response.message, type: .Information)
                        
                       if State == "1" {
                        self.mute = "0"
                        self.ivBell.image = UIImage(named: "silent")
                        self.ivBell.setImageColor(color: ColorConstant.colorP)
                       } else {
                        self.mute = "1"
                        self.ivBell.image = UIImage(named: "bell")
                        self.ivBell.setImageColor(color: ColorConstant.colorP)
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

    @IBAction func buttonClearFilter(_ sender: Any) {
        self.fetchNewDataOnRefresh()
    }
    func hideFilerView() {
        self.lblFilter.text = "Start Date"
        self.lblFilterEndDate.text = "End Date"
        self.viewClearFilter.isHidden = true
        
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.viewDateFilter.isHidden = true
            self.dateFilterStackView.layoutIfNeeded()
        }
    }

    @IBAction func btnDateFilterClicked(_ sender: UIButton) {
        self.openCalendarDatePicker(delegate: self,tag: 1,minimum: "",selectDate: StartDateString)
    }

    @IBAction func btnEndDateClicked(_ sender: UIButton) {
        if self.StartDateObject != nil{
            self.openCalendarDatePicker(delegate: self,tag: 2,minimum: lblFilter.text, selectDate: EndDate)
            
        }else{
            self.showAlertMessage(title: "Alert !!", msg: "Please Select A Start Date.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
    }

    override func fetchNewDataOnRefresh() {
         hideFilerView()
        tfSearch.text = ""
        self.discussionList.removeAll()
        self.doCallApi()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    @IBAction func btnOpenFilterPreference(_ sender: Any) {
        if viewDateFilter.isHidden {
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.viewDateFilter.isHidden = false
                self.dateFilterStackView.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.viewDateFilter.isHidden = true
                self.dateFilterStackView.layoutIfNeeded()
            }
        }
    }

    
    @IBAction func btnVideo(_ sender: UIButton) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }

    @IBAction func btnHome(_ sender: UIButton) {
        let destiController = storyboardConstants.main
            .instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }

    func doCallApi(StartWith Start:String! = "" , EndWith End:String! = ""){
        showProgress()
        let params = ["getDiscussionFast":"getDiscussionFast",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_type":doGetLocalDataUser().userType!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "filter_date_from":Start!,
                      "filter_date_to":End!]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, error) in
            self.viewSuperParent.hideSkeleton()
            self.hideProgress()
            if Data != nil{
                
                do{
                    let response = try JSONDecoder().decode(DiscussionListResponse.self, from: Data!)

                    if response.status == "200"{
                        self.hideProgress()
                        self.tbvData.isHidden=false
//                        if response.discussionMute == "0"{
//                            self.viewMute.isHidden  = false
//                            self.viewUnmute.isHidden  = true
//                        }else{
//                            self.viewMute.isHidden  = true
//                            self.viewUnmute.isHidden  = false
//                        }
                        

                        if response.discussionMute == "1" {
                            self.mute = "0"
                            self.ivBell.image = UIImage(named: "silent")
                            
                        } else {
                            self.mute = "1"
                            self.ivBell.image = UIImage(named: "bell")
                        }
                        self.ivBell.setImageColor(color: ColorConstant.colorP)
                        
                        self.viewNoData.isHidden = true
                        self.viewSearch.isHidden = false
                        
                        self.discussionList = response.discussion
                        self.tbvData.reloadData()
                    }else{
                        self.hideProgress()
                        self.discussionList.removeAll()
                        self.viewNoData.isHidden = false
                        self.viewSearch.isHidden = true
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }

    @IBAction func btnStartDiscussion(_ sender: UIButton) {
        let nextvc = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idAddDiscussionVC")as! AddDiscussionVC
        self.navigationController?.pushViewController(nextvc, animated: true)
    }

    func doCallApiWith(params : [String : String]) {
        self.showProgress()
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                        self.toast(message: response.message, type: .Success)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    @objc func doFilterArray(_ sender : UITextField){
        print("filter")

        filterList = sender.text!.isEmpty ? discussionList : discussionList.filter({ (item: DiscussionListModel) -> Bool in
            return item.discussionForumTitle.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        if self.filterList.count == 0{
            self.viewNoData.isHidden = false
        } else  {
            self.viewNoData.isHidden = true
        }
        
    }
}
extension DiscussionListVC : SkeletonTableViewDelegate, SkeletonTableViewDataSource,DiscussionListCellDelegate{

    func DeleteButtonClicked(at indexPath: IndexPath) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: indexPath.row,cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }

    func MuteButtonClicked(at indexPath: IndexPath) {
        let data = filterList[indexPath.row]
        let params = ["addMute":"addMute",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "discussion_forum_id":data.discussionForumId!,
                      "mute_type":"1"]
        self.doCallApiWith(params: params)
    }

    func UnMuteButtonClicked(at indexPath: IndexPath) {
        let data = filterList[indexPath.row]
        let params = ["addMute":"addMute",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "discussion_forum_id":data.discussionForumId!,
                      "mute_type":"0"]
        self.doCallApiWith(params: params)
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


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.filterList.count == 0{
//            self.viewNoData.isHidden = false
//
//            if discussionList.count == 0{
//                self.viewSearch.isHidden = true
//            }
//        }else{
//            self.viewNoData.isHidden = true
//            self.viewSearch.isHidden = false
//
//
//        }
        return filterList.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return itemCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filterList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! DiscussionListCell
        cell.hideSkeleton()
        cell.delegate = self
        cell.indexpath = indexPath
        cell.lblTopic.text = data.discussionForumTitle
        cell.lblCreatedBy.text = data.createdBy + " " + data.createdUnit
        cell.lblDate.text = data.createdDate
        cell.lblDescription.text = data.discussionForumDescription
        cell.lblCommentCount.text = data.totalComents ?? "0"
        if data.userId == doGetLocalDataUser().userID!{
            cell.stackView.setNeedsLayout()
            cell.viewDelete.isHidden = false
            cell.viewUnMute.isHidden = true
            cell.viewMute.isHidden = true
        }else{
            if data.muteStatus{
                cell.stackView.setNeedsLayout()
                cell.viewDelete.isHidden = true
                cell.viewUnMute.isHidden = true
                cell.viewMute.isHidden = false
                //true
            }else{
                cell.stackView.setNeedsLayout()
                cell.viewDelete.isHidden = true
                cell.viewUnMute.isHidden = false
                cell.viewMute.isHidden = true
                //false
            }
        }

        if data.discussionFile == ""{
            cell.ivPdf.isHidden = true
            cell.widthOfPdf.constant = 0
        }else{
            cell.ivPdf.isHidden = false
            cell.widthOfPdf.constant = 20
            
            if  data.discussionFile.contains(".pdf") {
                cell.ivPdf.image = UIImage(named: "pdf")
            } else  if  data.discussionFile.contains(".doc") || data.discussionFile.contains(".docx") {
                cell.ivPdf.image = UIImage(named: "doc")
            } else  if  data.discussionFile.contains(".ppt") || data.discussionFile.contains(".pptx") {
                cell.ivPdf.image = UIImage(named: "doc")
            } else  if  data.discussionFile.contains(".jpg") || data.discussionFile.contains(".jpeg") {
                cell.ivPdf.image = UIImage(named: "jpg-2")
            } else  if  data.discussionFile.contains(".png")  {
                cell.ivPdf.image = UIImage(named: "png")
            } else  if  data.discussionFile.contains(".zip")  {
                cell.ivPdf.image = UIImage(named: "zip")
            } else {
                cell.ivPdf.image = UIImage(named: "office-material")
            }
            
            
        }
        
        
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filterList[indexPath.row]
        let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionDetailVC")as! DiscussionDetailVC
        nextVC.discussionData = data
        nextVC.discussion_forum_id = data.discussionForumId ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }

}
extension DiscussionListVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.filterList[tag]
                let params = ["deleteDiscussion":"deleteDiscussion",
                              "society_id":self.doGetLocalDataUser().societyID!,
                              "user_id":self.doGetLocalDataUser().userID!,
                              "discussion_forum_id":data.discussionForumId!]
                self.doCallApiWith(params: params)

            }
        }
    }

    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension DiscussionListVC  : CalendarDialogDelegate{
    func btnDoneClicked(with SelectedDateString: String!, with SelectedDate: Date!,tag : Int!) {
        //print(tag)
        if tag == 1{
            self.lblFilter.text = SelectedDateString
            self.StartDateString = SelectedDateString
            self.StartDateObject = SelectedDate
            self.EndDate = ""
            self.lblFilterEndDate.text = "End Date"
        }else if tag == 2{
            if StartDateObject <= SelectedDate{
                self.viewClearFilter.isHidden = false
                self.lblFilterEndDate.text = SelectedDateString
                self.EndDate = SelectedDateString
                self.discussionList.removeAll()
                self.doCallApi(StartWith: self.StartDateString, EndWith: self.EndDate)
            }else{
                self.showAlertMessage(title: "Alert !!", msg: "Please Select a Date After Start Date")
            }
        }
    }
}
