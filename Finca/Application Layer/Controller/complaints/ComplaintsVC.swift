import UIKit
import AVFoundation
import EzPopup
class ComplaintsVC: BaseVC {
    
    @IBOutlet weak var FloatingButtonView: UIView!
    @IBOutlet weak var bMenu: UIButton!
    var flagViewVerification = false
    @IBOutlet weak var tbvComplain: UITableView!
    let itemCell = "ComplainCell"
    let itemCell2 = "ComplainAudioCell"
    var ComplainList = [ComplainModel]()
    var filterComplainList = [ComplainModel]()
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
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    let documentInteractionController = UIDocumentInteractionController()
    var player : AVPlayer?
    var isAudioPlaying = false
    var audioFileURl = ""
    var playerItem:AVPlayerItem?
    var slider: UISlider?
    var isAllResource = true
    var youtubeVideoID = ""
    var menuTitle : String!
    var blockStatus  = ""
    var blockMessage  = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchView.isHidden = false
        ivClose.isHidden  = true
        heightOfSearchView.constant = 0
        ivSearch.setImageColor(color: ColorConstant.colorP)
        ivClose.setImageColor(color: ColorConstant.colorP)
        doInintialRevelController(bMenu: bMenu)
        // doCallGetComplainApi()
        FloatingButtonView.layer.shadowRadius = 6
        FloatingButtonView.layer.shadowOffset = CGSize.zero
        FloatingButtonView.layer.shadowOpacity = 0.7
        FloatingButtonView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        FloatingButtonView.layer.masksToBounds = false
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvComplain.register(nib, forCellReuseIdentifier: itemCell)
        let nib2 = UINib(nibName: itemCell2, bundle: nil)
        tbvComplain.register(nib2, forCellReuseIdentifier: itemCell2)
        tbvComplain.delegate = self
        tbvComplain.dataSource = self
        documentInteractionController.delegate = self
        addRefreshControlTo(tableView: tbvComplain)
        tbvComplain.estimatedRowHeight = 100
        tbvComplain.rowHeight = UITableView.automaticDimension
        viewNoData.clipsToBounds = true
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        lblScreenTitle.text = doGetValueLanguage(forKey: "complaints")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_complaint"))
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data_available")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }

    func hideView() {
        if filterComplainList.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
    }

    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
        
        filterComplainList = textField.text!.isEmpty ? ComplainList : ComplainList.filter({ (item:ComplainModel) -> Bool in
            
            return item.compalainTitle.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.complain_no.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        hideView()
        tbvComplain.reloadData()
        if textField.text == "" {
            self.ivClose.isHidden  = true
        } else {
            self.ivClose.isHidden  = false
        }
        //    hideView()
        
    }

    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    @IBAction func onClickChat(_ sender: Any) {
        /*  let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    override func fetchNewDataOnRefresh() {
        
        self.toast(message: "Thank you for Feedback", type: .Success)
        tfSearch.text = ""
        ivClose.isHidden = true

        refreshControl.beginRefreshing()
        ComplainList.removeAll()
        tbvComplain.reloadData()
        
        doCallGetComplainApi()
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnAddComplaint(_ sender: UIButton) {
        if  self.blockStatus != "" &&  self.blockStatus == "true" {
             self.showAppDialog(delegate: self, dialogTitle: "Admin message:", dialogMessage:  self.blockMessage, style: .Notice, tag: 0, cancelText: "", okText: "OKAY")
           
        } else {
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idAddComplaintsVC") as! AddComplaintsVC
            self.flagViewVerification = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        doCallGetComplainApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        //             fetchNewDataOnRefresh()

        
        
        
    }

    @IBAction func btnHomeClicked(_ sender: UIButton) {
        //self.popToHomeController()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    @IBAction func onClickClearText(_ sender: Any) {
        tfSearch.text = ""
        
        filterComplainList = ComplainList
        tbvComplain.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        hideView()
    }
    
    func doCallGetComplainApi(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getComplain":"getComplain",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(ComplainResponse.self, from:json!)
                    if response.status == "200" {
                        self.heightOfSearchView.constant = 56
                        
                        self.ComplainList = response.complain
                        self.filterComplainList = self.ComplainList
                        self.tbvComplain.reloadData()
                        self.SearchView.isHidden = false
                        self.viewNoData.isHidden = true
                        self.blockStatus  = response.blockStatus ?? ""
                        self.blockMessage  = response.blockMessage ?? ""
                       
                        
                        //                        for item in response.complain{
                        //                            if item.complainStatus == "1"{
                        //                                if item.ratingStar == "" || item.ratingStar == nil{
                        //                                    self.feedbackPopUp(data : item)
                        //                                    break
                        //                                 }
                        //                            }
                        //                        }
                    }else {
                        self.ComplainList.removeAll()
                        self.filterComplainList.removeAll()
                        self.SearchView.isHidden = true
                        self.viewNoData.isHidden = false
                        self.tbvComplain.reloadData()
                        //                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
    @objc func btnDeleteTapped(sender:UIButton){
        
        
       // showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are you sure you want to delete?", style: .Delete)
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
                      "deleteComplain":"deleteComplain",
                      "society_id":doGetLocalDataUser().societyID!,
                      "complain_id":ComplainList[index].complainID!,
                      "user_id":doGetLocalDataUser().userID!,]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        // self.ComplainList.removeAll()
                        self.doCallGetComplainApi()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @objc func btnEditTapped(sender:UIButton){
        let index = sender.tag
        let alert = UIAlertController(title: "", message:"Are you sure you want to Reopen the complain?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.onClickEdit(index: index)
        }))
        self.present(alert, animated: true)
    }
    
    func onClickEdit(index : Int){
        print("edit")
        let editComplain = storyboardConstants.complain.instantiateViewController(withIdentifier: "idAddComplaintsVC")as! AddComplaintsVC
        editComplain.flagForEditing = true
        editComplain.complainDetails = ComplainList[index]
        self.flagViewVerification = true
        self.navigationController?.pushViewController(editComplain, animated: true)
    }
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
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
    
    @objc func PlayClicked(_ sender:UIButton){
        let index = sender.tag
        let url = ComplainList[index].complaintVoice
        self.storeAndShare(withURLString: url!)
    }
    
    func feedbackPopUp(data : ComplainModel){
        print("times--")
        //        let index = sender.tag
        //        let data = filterComplainList[index]
       // let vc = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplainFeedbackDialogVC")as!ComplainFeedbackDialogVC
        let vc = ComplainFeedbackDialogVC()
        vc.data = data
        vc.context = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
        //        popupVC.shadowEnabled = true
        ////        popupVC.canTapOutsideToDismiss = true
        //        present(popupVC, animated: true)
    }

    @objc func feedbackClicked(_ sender : UIButton!){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
}
extension ComplaintsVC : UITableViewDelegate,UITableViewDataSource,ComplainCellDelegate {
    func doGiveRating(indexpath: IndexPath) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
       // let vc = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplainFeedbackDialogVC")as!ComplainFeedbackDialogVC
        let vc = ComplainFeedbackDialogVC()
        vc.data = filterComplainList[indexpath.row]
        vc.context = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if filterComplainList.count == 0{
//            self.SearchView.isHidden = true
//        }
        return filterComplainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = filterComplainList[indexPath.row]
        let cellWithoutAudio = tbvComplain.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ComplainCell

        cellWithoutAudio.lblCompainNo.text = data.complain_no
        cellWithoutAudio.lblCompainNo.cornerRadius = 5
        cellWithoutAudio.indexPath = indexPath
        cellWithoutAudio.delegate = self
        cellWithoutAudio.viewOfRating.settings.fillMode = .half
        cellWithoutAudio.lblStatusTitle.text = doGetValueLanguage(forKey: "status")  + ":"
        cellWithoutAudio.lblCategoryTitle.text = doGetValueLanguage(forKey: "category")  + ":"
        cellWithoutAudio.lblComplainTitle.text = doGetValueLanguage(forKey: "title")  + ":"
        cellWithoutAudio.lblDescriptionTitle.text = doGetValueLanguage(forKey: "description_colon") + ":"
        cellWithoutAudio.lblAdminMsg.text = doGetValueLanguage(forKey: "admin_message")
        if data.complainStatus == "0"{
            cellWithoutAudio.mainViewOfRating.isHidden = true
            cellWithoutAudio.lblCmpStatus.text =  " Open " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_open_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_open
            //cellWithoutAudio.mainViewOfRating.isHidden = true
            
        }else if data.complainStatus == "1"{
            cellWithoutAudio.mainViewOfRating.isHidden = false
            print("star rating is-"+data.ratingStar)
            if data.ratingStar != ""{
                cellWithoutAudio.viewOfRating.rating = Double(data.ratingStar!)!
            }else{
                cellWithoutAudio.viewOfRating.rating = 0.0
            }
            cellWithoutAudio.lblCmpStatus.text =  " Closed  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_reopen_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_reopen
        }else if data.complainStatus == "2"{
            cellWithoutAudio.mainViewOfRating.isHidden = true
            cellWithoutAudio.lblCmpStatus.text =  " Re Open  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_open_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_open
        }else if data.complainStatus == "3"{
            cellWithoutAudio.mainViewOfRating.isHidden = true
            cellWithoutAudio.lblCmpStatus.text =  " In Progress  " + " "
            cellWithoutAudio.lblCmpStatus.textColor = ColorConstant.complaint_inprocess_text
            cellWithoutAudio.lblCmpStatus.backgroundColor = ColorConstant.complaint_inprocess
        }
        cellWithoutAudio.lblCmpDate.text = data.complainDate
        //        cellWithoutAudio.lblCmpDesc.text = data.complainDescription
        //        cellWithoutAudio.lblCmpDesc.text = ""
        cellWithoutAudio.lblCmpTitle.text = data.compalainTitle
        cellWithoutAudio.lblCategory.text =    data.complaintcategoryview
        
        if data.complainReviewMsg != "" && data.complainReviewMsg != nil{
            cellWithoutAudio.lblCmpAdminMsg.text = data.complainReviewMsg
            cellWithoutAudio.viewAdminReply.isHidden = false
            cellWithoutAudio.heightOfDashView.constant = 28
            cellWithoutAudio.heightOflblAdminReply.constant = 18
        }else{
            cellWithoutAudio.heightOfDashView.constant = 0
            cellWithoutAudio.heightOflblAdmin.constant = 0
            cellWithoutAudio.lblCmpAdminMsg.text = ""
            // cellWithoutAudio.constaintHieghtAdminMessage.constant = 0
            cellWithoutAudio.viewAdminReply.isHidden = true
        }
        cellWithoutAudio.deleteBtn.tag = indexPath.row
        cellWithoutAudio.deleteBtn.addTarget(self, action: #selector(btnDeleteTapped(sender:)), for: .touchUpInside)
        
        cellWithoutAudio.selectionStyle = .none
        cellWithoutAudio.lbDesc.text = data.complainDescription ?? ""
        
        cellWithoutAudio.bTapDesc.tag = indexPath.row
        cellWithoutAudio.bTapDesc.addTarget(self, action: #selector(tapMoreDesciption(sender:)), for: .touchUpInside)
        
        return cellWithoutAudio
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplainDetailVC")as! ComplainDetailVC
        nextVC.complainDetailList = filterComplainList[indexPath.row]
        nextVC.context = self
        nextVC.blockStatus  = blockStatus
        nextVC.blockMessage  = blockMessage
       
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc func tapMoreDesciption(sender:UIButton){
        
        
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: filterComplainList[sender.tag].complainDescription, style: .Info, tag: 0, cancelText: "", okText: "OKAY")
    }
}

extension ComplaintsVC: UIDocumentInteractionControllerDelegate ,URLSessionDownloadDelegate{
    
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
extension ComplaintsVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Info || dialogType == .Notice {
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

