//
//  NoticeVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import YoutubePlayerView
import  WebKit
import Lightbox

struct ResponseNoticeBaord  : Codable {
    let  message : String!//" : "Get Notice Board Success.",
    let  status : String!//" : "200"
    let notice : [ModelNoticeBoard]!
}

struct ModelNoticeBoard : Codable {
    
    
    
    let notice_title : String! //" : "Notice for Sop 12 , 2019",
    let notice_board_id : String! //" : "24",
    let notice_time : String! //" : "28 Aug 2019 12:12 PM",
    let society_id : String! //" : "48",
    let notice_description : String! //" : ""
    let updated_time : String!
    let notice_attachment:String!
    var heghtCon : CGFloat! = 0.0
    let date_view:String!
    let notice_description_text : String?
    let read_status : Bool? //true,
    
}
class NoticeVC: BaseVC  {
    var youtubeVideoID = ""
    var strfromdate = ""
    var strTodate = ""
    
    var strcutomfromdate  = ""
    var strcutomtodate  = ""
    @IBOutlet weak var VwVideo: UIView!
    @IBOutlet weak var bVideo:UIButton!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var viewNoData: UIView!
    var menuTitle : String!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
   
    @IBOutlet weak var bRecent: UIButton!
    @IBOutlet weak var bMonthOne: UIButton!
    @IBOutlet weak var bMonthTwo: UIButton!
    @IBOutlet weak var bCustom: UIButton!
    
    @IBOutlet weak var viewCustom: UIView!
    
    @IBOutlet weak var lbFromDate: UILabel!
    @IBOutlet weak var lbToDate: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    
    var cellItem = "NoticeBoardCell"
    var notices  =  [ModelNoticeBoard]()
    var filterNotices  =  [ModelNoticeBoard]()
    var videoPlayer : YoutubePlayerView!
    var StrAttachment = ""
    let tempMonthList = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var filter_type = "0"
    var from_date = "" //:"",
    var to_date = "" // : ""
    var isSelectFromDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnPlayVideo.isEnabled = false
      
        let nib = UINib(nibName: cellItem, bundle: nil)
        tblData.register(nib, forCellReuseIdentifier: cellItem)
        tblData.dataSource = self
        tblData.delegate = self
        tblData.separatorStyle = .none
        tblData.estimatedRowHeight = 300
        tblData.rowHeight = UITableView.automaticDimension
        tblData.keyboardDismissMode = .onDrag
        doInintialRevelController(bMenu: bMenu)
        viewNoData.isHidden = true
        addRefreshControlTo(tableView: tblData)
        getNoticeBoard()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        
        
        let dateformat  = DateFormatter()
        dateformat.dateFormat = "MM"
        let mouth = dateformat.string(from: Date())
        
        
        if mouth == "01" {
            bMonthOne.setTitle(tempMonthList[Int(mouth)! - 1], for: .normal)
            bMonthTwo.setTitle(tempMonthList[11], for: .normal)
        } else {
            let month = Int(mouth)! - 1
            let monthTwo = Int(mouth)! - 2
            bMonthOne.setTitle(tempMonthList[month], for: .normal)
            bMonthTwo.setTitle(tempMonthList[monthTwo], for: .normal)
        }
        
        
        lbTitle.text = doGetValueLanguage(forKey: "notice_board")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        bRecent.setTitle(doGetValueLanguage(forKey: "recent_fifteen"), for: .normal)
        bCustom.setTitle(doGetValueLanguage(forKey: "custom"), for: .normal)
        
        selectedStyle(sender: bRecent)
        defultStyle(sender: [bMonthOne,bMonthTwo,bCustom])
        
        viewCustom.isHidden = true
        setDefultDate()
        tfSearch.addTarget(self, action: #selector(didChanges(textField:)), for: .editingChanged)
        tfSearch.delegate = self
       
    }
    private func setDefultDate() {
        
        print(strfromdate)
        lbFromDate.text = doGetValueLanguage(forKey: "from").uppercased()
        lbToDate.text = doGetValueLanguage(forKey: "to").uppercased()
//        from_date = ""
//        to_date = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return view.endEditing(true)
   }
   
   @objc func didChanges(textField : UITextField) {
       filterNotices = textField.text!.isEmpty ? notices : notices.filter({ (item:ModelNoticeBoard) -> Bool in
         
           return item.notice_title.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.notice_description.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
       })
       
       
       if filterNotices.count == 0 {
           viewNoData.isHidden = false
              
       } else {
           viewNoData.isHidden = true
              
       }
       tblData.reloadData()
       
   }
    
    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
        
        getNoticeBoard()
    }
    func getNoticeBoard() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getNoticeFilter":"getNoticeFilter",
                      "unit_id":doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "from_date":from_date,
                      "filter_type":filter_type,
                      "to_date" : to_date]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.noticeBoardController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
               
                do {
                    let response = try JSONDecoder().decode(ResponseNoticeBaord.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.notices = response.notice
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        for (index,_) in response.notice.enumerated() {
                            self.notices[index].heghtCon = 0.0
                        }
                        
                        
//                        if self.notices.count == 0{
//                            self.viewNoData.isHidden = false
//                               }else{
//                            self.viewNoData.isHidden = true
//                               }
                        
                       
                       // var tempList  = [ModelNoticeBoard]()

                        let sortedArray = self.notices.sorted{[dateFormatter] one, two in
                            return dateFormatter.date(from:one.updated_time )! > dateFormatter.date(from: two.updated_time )! }
                       self.notices = sortedArray
                        self.filterNotices = sortedArray
                        self.tblData.reloadData()
                        
                        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateCellHeight), userInfo: nil, repeats: false)
                        
                    }else {
                        self.notices.removeAll()
                        self.filterNotices.removeAll()
                        self.tblData.reloadData()
                        //                                 self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            } else if error != nil{
                self.showNoInternetToast()
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func updateCellHeight() {
        
        self.tblData.reloadData()
        
    }
    @IBAction func onClickNotification(_ sender: Any) {
      
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
            BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    
    
    @IBAction func onClickChat(_ sender: Any) {
        // let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        //   self.navigationController?.pushViewController(vc, animated: true)
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    
    @IBAction func tapFilters(_ sender: UIButton) {
        
        switch sender.tag {
        case  0 : // recent
            selectedStyle(sender: bRecent)
            defultStyle(sender: [bMonthOne,bMonthTwo,bCustom])
            filter_type = "0"
            getNoticeBoard()
            viewCustom.isHidden = true
            setDefultDate()
            textFieldReset()
            break
        case  1 : // month one
            selectedStyle(sender: bMonthOne)
            defultStyle(sender: [bRecent,bMonthTwo,bCustom])
            filter_type = "1"
            getNoticeBoard()
            viewCustom.isHidden = true
            setDefultDate()
            textFieldReset()
            break
        case  2 : // month two
            selectedStyle(sender: bMonthTwo)
            defultStyle(sender: [bRecent,bMonthOne,bCustom])
            filter_type = "2"
            getNoticeBoard()
            viewCustom.isHidden = true
            setDefultDate()
            textFieldReset()
            break
            
        case  3 : // custom
            
            to_date = ""
            from_date = ""
            selectedStyle(sender: bCustom)
            defultStyle(sender: [bRecent,bMonthOne,bMonthTwo])
            filter_type = "3"
            viewCustom.isHidden = false
            textFieldReset()
            
             filterNotices.removeAll()
             notices.removeAll()
             tblData.reloadData()
            lbFromDate.text = doGetValueLanguage(forKey: "from").uppercased()
            lbToDate.text = doGetValueLanguage(forKey: "to").uppercased()
            
            self.getNoticeBoard()
            
            
//            if strcutomfromdate != ""
//            {
//               // lbFromDate.text = strcutomfromdate
//               // self.from_date = strcutomfromdate
//
//
//            }
//            else{
//                lbFromDate.text = doGetValueLanguage(forKey: "from").uppercased()
//            }
//
//
//            if strcutomtodate != ""
//            {
//              //  lbToDate.text = strcutomtodate
//              //  self.to_date = strcutomtodate
//
//            }
//            else{
//                lbToDate.text = doGetValueLanguage(forKey: "to").uppercased()
//
//            }
            
            
            
//            if strcutomfromdate != "" ||  strcutomtodate != ""
//            {
              
//                self.from_date = strcutomfromdate
//                self.to_date = strcutomtodate
//
//                self.getNoticeBoard()
              
               
          //  }
           
    
            
           
            break
        default:
            break
        }
        lbToDate.text = doGetValueLanguage(forKey: "to").uppercased()
        lbFromDate.text = doGetValueLanguage(forKey: "from").uppercased()
        
        
    }
    
    
    private func selectedStyle(sender : UIButton) {
        sender.backgroundColor = ColorConstant.primaryColor
        sender.setTitleColor(.white, for: .normal)
    }
    private func defultStyle(sender : [UIButton]) {
        for item in sender {
            item.backgroundColor = .white
            item.setTitleColor(ColorConstant.primaryColor, for: .normal)
        }
    }
    
    @IBAction func tapFromDate(_ sender: Any) {
        isSelectFromDate = true
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: nil, maximumDate: Date(), currentDate: nil)
        vc.view.frame = view.frame
        addPopView(vc: vc)
        
    }
    
    @IBAction func tapToDate(_ sender: Any) {
        var dateFrom : Date? = nil
        
        if from_date != "" {
            let dateformat  = DateFormatter()
            dateformat.locale = Locale(identifier: "en_US_POSIX")
            dateformat.dateFormat = "yyyy-MM-dd"
            dateFrom = dateformat.date(from: from_date)!
        }
        
        isSelectFromDate = false
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: dateFrom, maximumDate: Date() , currentDate: dateFrom)
        vc.view.frame = view.frame
        addPopView(vc: vc)
    }
    private func textFieldReset() {
        tfSearch.text = ""
        _ = textFieldShouldReturn(tfSearch)
    }
}

extension NoticeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    
    func upadateHeightCon(he : CGFloat , index : Int) {
        print("index" , index)
        if   notices[index].heghtCon == 0.0 {
            
            notices[index].heghtCon = he
              tblData.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
           // tblData.reloadData()
        }
       }
    
    
}

extension NoticeVC : UITableViewDelegate , UITableViewDataSource , OnSelectDate {
    
    func onSelectDate(dateString: String, date: Date) {
        let dateformat  = DateFormatter()
        dateformat.locale = Locale(identifier: "en_US_POSIX")
        dateformat.dateFormat = "dd-MM-yyyy"
        
        if isSelectFromDate {
//            strcutomfromdate = dateString
            from_date = dateString
            lbFromDate.text = dateformat.string(from: date)
        } else {
           // strcutomtodate = dateString
            lbToDate.text = dateformat.string(from: date)
            to_date = dateString
            if  from_date != ""{
                getNoticeBoard()
            }
        }
     }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterNotices.count == 0{
            viewNoData.isHidden = false
        }else{
            viewNoData.isHidden = true
        }
        return filterNotices.count
    }
    	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem, for: indexPath) as! NoticeBoardCell
        let data =  filterNotices[indexPath.row]
        cell.lbNoticeTile.text = data.notice_title
        cell.lbDate.text = data.notice_time
        cell.selectionStyle = .none
        cell.viewSubView.layer.cornerRadius = 4.0
        StrAttachment = data.notice_attachment ?? ""
        cell.lbDesc.text = data.notice_description
        cell.btnAttachment.addTarget(self, action: #selector(tapToAttached(_:)), for: .touchUpInside)
        if data.read_status ?? false {
            cell.lbNoticeTile.textColor = ColorConstant.grey_60
        } else {
            cell.lbNoticeTile.textColor = ColorConstant.colorP
        }
        
        if StrAttachment != ""
        {
            cell.viewMain_Attachment.isHidden = false
        }else
        {
            cell.viewMain_Attachment.isHidden = true
        }
      
        if  data.notice_attachment.contains(".pdf") {
            cell.imgvw_Attachment_icon.image = UIImage(named: "pdf")
        } else  if  data.notice_attachment.contains(".doc") || data.notice_attachment.contains(".docx") {
            cell.imgvw_Attachment_icon.image = UIImage(named: "doc")
        } else  if  data.notice_attachment.contains(".ppt") || data.notice_attachment.contains(".pptx") {
            cell.imgvw_Attachment_icon.image = UIImage(named: "doc")
        } else  if  data.notice_attachment.contains(".jpg") || data.notice_attachment.contains(".jpeg") {
            cell.imgvw_Attachment_icon.image = UIImage(named: "jpg-2")
        } else  if  data.notice_attachment.contains(".png")  {
            cell.imgvw_Attachment_icon.image = UIImage(named: "png")
        } else  if  data.notice_attachment.contains(".zip")  {
            cell.imgvw_Attachment_icon.image = UIImage(named: "zip")
        } else {
            cell.imgvw_Attachment_icon.image = UIImage(named: "office-material")
        }
        
        cell.bViewMore.setTitle(doGetValueLanguage(forKey: "view_more").uppercased(), for: .normal)
        cell.bViewMore.tag = indexPath.row
        cell.bViewMore.addTarget(self, action: #selector(tapNoticeDetails(_:)), for: .touchUpInside)
        cell.bTapDesc.tag = indexPath.row
        cell.bTapDesc.addTarget(self, action: #selector(tapNoticeDetails(_:)), for: .touchUpInside)
     
       // cell.configure(htmlContent: notices[indexPath.row].notice_description , index: indexPath.row)
       // cell.tableView = tableView
       // cell.noticeVC = self
        //cell.heightConWV.constant =   notices[indexPath.row].heghtCon
        
       /* cell.webView = WKWebView(frame:cell.viewWebview.bounds,configuration: WKWebViewConfiguration())
        cell.webView.configuration.preferences.javaScriptEnabled = true
        cell.webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
              cell.webView.contentMode = .scaleToFill
        cell.webView.navigationDelegate = self
        
        //cell.textDesc.attributedText = notices[indexPath.row].notice_description.htmlToAttributedString
        let htmlHeight = notices[indexPath.row].heghtCon

        cell.webView.tag = indexPath.row
       // cell.webView.scrollView.isScrollEnabled = false
       // cell.webView.delegate = self
        cell.webView.loadHTMLString( notices[indexPath.row].notice_description, baseURL: nil)
       // cell.webView.frame = CGRectMake(0, 0, cell.frame.size.width, htmlHeight!)
        cell.webView.frame = CGRect(x: 0, y: 0, width: cell.viewWebview.frame.width, height:  cell.viewWebview.frame.height)
       // cell.viewWebview.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: htmlHeight!)
        cell.viewWebview.addSubview(cell.webView)
        cell.viewWebview.sendSubviewToBack(cell.webView)
       
        webViewDidFinishLoad(webView: cell.webView)
        
       // cell.heightConWV.constant = cell.webView.scrollView.contentSize.height
        cell.heightConWV.constant =  htmlHeight!*/
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  notices[indexPath.row].heghtCon != nil {
            return notices[indexPath.row].heghtCon
        }
        
        return 100
    }*/
    @objc func tapToAttached(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblData)
        let indexPathSelected = self.tblData.indexPathForRow(at:buttonPosition)
        if filterNotices.count > 0
        {
            _ = self.tblData.cellForRow(at: indexPathSelected!)!
            let StrAttachments = filterNotices[indexPathSelected!.row].notice_attachment ?? ""
            
               
            if StrAttachments.lowercased().contains("jpg") ||  StrAttachments.lowercased().contains("jpeg") ||  StrAttachments.lowercased().contains("png") {
                let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
                nextVC.imagePath = StrAttachments
                nextVC.isShowDownload = "yes"
                pushVC(vc: nextVC)
            } else {
                let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "NoticcWebvw") as! NoticcWebvw
                vc.strUrl = StrAttachments
                vc.strNoticetitle = filterNotices[indexPathSelected!.row].notice_title ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
           }
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*    if notices[indexPath.row].height != nil {
         print("fff", notices[indexPath.row].height)
         return CGFloat(notices[indexPath.row].height)
         }*/
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func tapNoticeDetails(_ sender : UIButton ){
        let vc = CircularDetailsVC()
        vc.modelNoticeBoard = filterNotices[sender.tag]
        pushVC(vc: vc)
    }
    
}

extension NoticeVC : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      //  hideProgress()
      //  print(error)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
     //  showProgress()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
      //  print("dd pos" , webView.tag )
      //  print("dd ==== h == " , webView.scrollView.contentSize.height)
        
      //   hideProgress()
     //   webView.frame.size.height = 1
     //   webView.frame.size = viewWebView.frame.size
        
        if ( notices[webView.tag].heghtCon == 0.0)
        {
        //    print("if  qwul" ,notices[webView.tag].heghtCon)
            // we already know height, no need to reload cell
            notices[webView.tag].heghtCon = webView.scrollView.contentSize.height
        //    tblData.reloadData()
           // return
        } else {
            
          //   print("if  not qwul" ,notices[webView.tag].heghtCon)
                   
            
        }
        
         
    }
    
    
    
}
