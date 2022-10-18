//
//  RequestVC.swift
//  Finca
//
//  Created by Jay Patel on 16/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import EzPopup
struct RequestResponse: Codable {
    let status: String! //" : "200",
    let message: String! //" : "Get Request Successfully.",
    let request: [RequestModel]! //" : [
    let audio_duration : Int! //" : 30000,
}
struct RequestModel: Codable {
    let request_no: String! //" : "REQ29",
    let request_status: String! //" : "0",
    let feedback_msg: String! //" : "",
    let society_id: String! //" : "75",
    let track: String! //" : null,
    let request_audio: String! //" : "https:\/\/ahmedabad.fincasys.com\/developer\/img\/request\/",
    let user_id: String! //" : "955",
    let request_title: String! //" : "eeeee",
    let request_status_view: String! //" : "Open",
    let unit_id: String! //" : "3008",
    let request_date: String! // " : "01 Jan 1970 05:30 AM",
    let request_description: String! //" : "ccfknvx",
    let request_closed_by: String! //" : "0",
    let request_image: String! //" : "https:\/\/ahmedabad.fincasys.com\/developer\/img\/request\/",
    let request_id: String! //" : "29"
}
class RequestVC: BaseVC {
    
    @IBOutlet weak var viewSearchbar: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var FloatingButtonView: UIView!
    @IBOutlet weak var bMenu: UIButton!
    var flagViewVerification = false
    var menuTitle : String!
    let itemCell = "MyRequestCell"
    let itemCell2 = "ComplainAudioCell"
    var requestList = [RequestModel]()
    var filterRequestList = [RequestModel]()
    var newRequestList = [RequestTrack]()
    var selectedIndnx = -1
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet var tbvRequest: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    let documentInteractionController = UIDocumentInteractionController()
    @IBOutlet weak var VwvIdeo:UIView!
    var player : AVPlayer?
    var isAudioPlaying = false
    var audioFileURl = ""
    var playerItem:AVPlayerItem?
    var slider: UISlider?
    var isAllResource = true
    var youtubeVideoID = ""
    var audio_duration = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ivClose.isHidden  = true
        heightOfSearchView.constant = 0
        ivSearch.setImageColor(color: ColorConstant.colorP)
        ivClose.setImageColor(color: ColorConstant.colorP)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        doInintialRevelController(bMenu: bMenu)
        //        doCallGetComplainApi()
        FloatingButtonView.layer.shadowRadius = 6
        FloatingButtonView.layer.shadowOffset = CGSize.zero
        FloatingButtonView.layer.shadowOpacity = 0.7
        FloatingButtonView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        FloatingButtonView.layer.masksToBounds = false
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvRequest.register(nib, forCellReuseIdentifier: itemCell)
        let nib2 = UINib(nibName: itemCell2, bundle: nil)
        tbvRequest.register(nib2, forCellReuseIdentifier: itemCell2)
        tbvRequest.delegate = self
        tbvRequest.dataSource = self
        doCallGetRequestApi()
        //        documentInteractionController.delegate = self
        addRefreshControlTo(tableView: tbvRequest)
        tbvRequest.estimatedRowHeight = 100
        tbvRequest.rowHeight = UITableView.automaticDimension
        viewNoData.clipsToBounds = true
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_request"))
        lblScreenTitle.text = menuTitle
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data_available")
        if youtubeVideoID != ""
        {
            VwvIdeo.isHidden = false
        }else
        {
            VwvIdeo.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if flagViewVerification == true{
            fetchNewDataOnRefresh()
            
        }
        
        
    }
    func hideView() {
        if filterRequestList.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
        
        filterRequestList = textField.text!.isEmpty ? requestList : requestList.filter({ (item:RequestModel) -> Bool in
            
            return item.request_title.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        hideView()
        tbvRequest.reloadData()
        if textField.text == "" {
            self.ivClose.isHidden  = true
        } else {
            self.ivClose.isHidden  = false
        }
        //    hideView()
        
    }
    @IBAction func onClickClearText(_ sender: Any) {
        tfSearch.text = ""
        
        filterRequestList = requestList
        tbvRequest.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        hideView()
    }
    @IBAction func btnAddRequest(_ sender: Any) {
        let vc = storyboardConstants.complain.instantiateViewController(withIdentifier: "idAddRequestVC") as! AddRequestVC
        vc.audio_duration = audio_duration
        self.flagViewVerification = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickVideo(_ sender: Any) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    @IBAction func onClickHome(_ sender: Any) {
        goToDashBoard(storyboard: mainStoryboard)
    }
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        ivClose.isHidden = true
        
        refreshControl.beginRefreshing()
        requestList.removeAll()
        tbvRequest.reloadData()
        doCallGetRequestApi()
        refreshControl.endRefreshing()
    }
    @objc func btnDeleteTapped(sender:UIButton){
        
        
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete)
        selectedIndnx = sender.tag
        //         self.filterComplainList[self.selectedIndnx]
        //        let alert = UIAlertController(title: "", message:"Are you sure you want to delete", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
        //            alert.dismiss(animated: true, completion: nil)
        //        }))
        //        alert.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { action in
        //
        //            alert.dismiss(animated: true, completion: nil)
        ///            self.onClickDelete(index: index)
        
        //        }))
        //        self.present(alert, animated: true)
    }
    func onClickDelete(index:Int) {
        print("delete success")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "deleteRequest":"deleteRequest",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "request_id":requestList[index].request_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.requestController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.requestList.removeAll()
                        self.doCallGetRequestApi()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    func doCallGetRequestApi(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getRequest":"getRequest",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.requestController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(RequestResponse.self, from:json!)
                    self.audio_duration = response.audio_duration
                    if response.status == "200" {
                        //                        print("response is --->",response)
                        self.heightOfSearchView.constant = 56
                        self.requestList.append(contentsOf: response.request)
                        self.filterRequestList = self.requestList
                        self.tbvRequest.reloadData()
                        self.viewSearchbar.isHidden = false
                        self.viewNoData.isHidden = true
                    }else {
                        self.requestList.removeAll()
                        self.filterRequestList.removeAll()
                        self.viewNoData.isHidden = false
                        self.viewSearchbar.isHidden = true
                        self.tbvRequest.reloadData()
                        //                        self.toast(message: response.message, type: .Faliure)
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
}
extension RequestVC : UITableViewDelegate,UITableViewDataSource,RequestCellDelegate {
    func doGiveRating(indexpath: IndexPath) {
        //        let vc = self.storyboard!.instantiateViewController(withIdentifier: "idComplainFeedbackDialogVC")as!ComplainFeedbackDialogVC
        //        vc.data = filterrequestList[indexpath.row]
        //        vc.context = self
        ////        vc.data = self
        //        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //        addChild(vc)  // add child for main view
        //        view.addSubview(vc.view)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = filterRequestList[indexPath.row]
        let cellWithoutAudio = tbvRequest.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! MyRequestCell
        cellWithoutAudio.lblCompainNo.text = data.request_no
        cellWithoutAudio.indexPath = indexPath
        cellWithoutAudio.delegate = self
        cellWithoutAudio.mainViewOfRating.isHidden = true
       // cellWithoutAudio.lblCategory.isHidden = true
       // cellWithoutAudio.heightOflblCategory.constant = 0
        cellWithoutAudio.lblDescription.text = filterRequestList[indexPath.row].request_description
        cellWithoutAudio.lblStatusTitle.text = doGetValueLanguage(forKey: "status")
        cellWithoutAudio.lblRequestTitle.text = doGetValueLanguage(forKey: "title")
        cellWithoutAudio.lblDescriptionTitle.text = doGetValueLanguage(forKey: "description_colon")
        if data.request_status == "0"{
            
            cellWithoutAudio.lblCmpStatus.text = data.request_status_view
                //" Open  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_open_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_open
        }else if data.request_status == "1"{
            cellWithoutAudio.lblCmpStatus.text =   " Closed  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_reopen_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_reopen
        }
//        else if data.request_status == "3"{
//            cellWithoutAudio.lblCmpStatus.text = " Reply  " + " "
//            cellWithoutAudio.lblCmpStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.green500
//        }
        else if data.request_status == "2"{
            cellWithoutAudio.lblCmpStatus.text = " In Progress  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_inprocess_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_inprocess
        }
        cellWithoutAudio.mainViewOfRating.isHidden = true
        //        print("date is",data.request_date)
        cellWithoutAudio.lblCmpDate.text! = filterRequestList[indexPath.row].request_date!
       // cellWithoutAudio.trailingOfLblDate.constant = 8
        //cellWithoutAudio.lblCmpDate.textAlignment = .right
        cellWithoutAudio.lblCompainNo.text = data.request_no
        cellWithoutAudio.lblCompainNo.cornerRadius = 5
        // cellWithoutAudio.lblCmpDesc.text = data.request_description
        cellWithoutAudio.lblCmpTitle.text = data.request_title
        cellWithoutAudio.heightOfDashView.constant = 0
        cellWithoutAudio.heightOflblAdmin.constant = 0
        cellWithoutAudio.lblCmpAdminMsg.text = ""
        // cellWithoutAudio.constaintHieghtAdminMessage.constant = 0
        cellWithoutAudio.viewAdminReply.isHidden = true
        
        cellWithoutAudio.deleteBtn.tag = indexPath.row
        cellWithoutAudio.deleteBtn.addTarget(self, action: #selector(btnDeleteTapped(sender:)), for: .touchUpInside)
        
        cellWithoutAudio.selectionStyle = .none
        
        return cellWithoutAudio
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idRequestDetailVC")as! RequestDetailVC
        nextVC.requestDetailList = requestList[indexPath.row]
        nextVC.context = self
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
extension RequestVC: AppDialogDelegate{
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
                self.onClickDelete(index: self.selectedIndnx)
            }
        }
    }
}
