//
//  RequestDetailVC.swift
//  Finca
//
//  Created by Jay Patel on 17/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation

struct RequestDetailResponse: Codable {
    let status: String!
    let track: [RequestTrack]!
    let message: String!
    let audioDuration: Int!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case track = "track"
        case message = "message"
        case audioDuration = "audio_duration"
    }
}
struct RequestTrack: Codable {
    let adminID: String!
    let requestTrackMsg: String!
    let requestTrackImgOld: String!
    let adminName: String!
    let requestTrackVoice: String!
    let requestID: String!
    let requestTrackBy: String!
    let requestTrackDateTime: String!
    let requestTrackImg: String!
    let requestTrackID: String!
    let requestStatusView: String!
    let requestTrackVoiceOld: String!
    var isDate: Bool!
    var msgDate: String!
    var msgDateView: String!

    enum CodingKeys: String, CodingKey {
        case isDate = "isDate"
        case msgDate = "msg_date"
        case msgDateView = "msg_date_view"
        case adminID = "admin_id"
        case requestTrackMsg = "request_track_msg"
        case requestTrackImgOld = "request_track_img_old"
        case adminName = "admin_name"
        case requestTrackVoice = "request_track_voice"
        case requestID = "request_id"
        case requestTrackBy = "request_track_by "
        case requestTrackDateTime = "request_track_date_time"
        case requestTrackImg = "request_track_img"
        case requestTrackID = "request_track_id"
        case requestStatusView = "request_status_view"
        case requestTrackVoiceOld = "request_track_voice_old"
    }
}
class RequestDetailVC: BaseVC {
    
    var lastContentOffset: CGFloat = 0
    var context: RequestVC!
    var requestDetailList : RequestModel!
    var newRequestList = [RequestTrack]()
    let itemCell = "ComplainDetailCell"
    let itemCellLeft = "LeftComplainCell"
    let centerCell = "FinbookCommonCell"
    var audio_duration = 0
    var requestStatus = [RequestResponse]()
   // var lastContentOffset: CGFloat = 0
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var LeadingConst: NSLayoutConstraint!
    @IBOutlet var tbvRequestDetail: UITableView!
    
    @IBOutlet weak var conTrailingEditBtn: NSLayoutConstraint!
    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvRequestDetail.register(nib, forCellReuseIdentifier: itemCell)

        let replyCell = UINib(nibName: itemCellLeft, bundle: nil)
        tbvRequestDetail.register(replyCell, forCellReuseIdentifier: itemCellLeft)

        let centerNib = UINib(nibName: centerCell, bundle: nil)
              tbvRequestDetail.register(centerNib, forCellReuseIdentifier: centerCell)
        tbvRequestDetail.delegate = self
        tbvRequestDetail.dataSource = self
        tbvRequestDetail.estimatedRowHeight = 50
        tbvRequestDetail.rowHeight = UITableView.automaticDimension
        tbvRequestDetail.delegate = self
        tbvRequestDetail.dataSource = self
        documentInteractionController.delegate = self
        lbTitle.text = requestDetailList.request_no + " - " + requestDetailList.request_title
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        doCallGetRequestDetailApi()

    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y{
            self.conTrailingEditBtn.constant = -60
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }else if self.lastContentOffset > scrollView.contentOffset.y{
            self.conTrailingEditBtn.constant = 16
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }else{
           print("Don't Move") 
        }
    }

    func doCallGetRequestDetailApi(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getRequestDetail":"getRequestDetail_iOS",
                      "society_id":doGetLocalDataUser().societyID!,
                      "request_id":requestDetailList.request_id!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.requestController, parameters: params) { (json, error) in
            self.hideProgress()

            if json != nil {

                do {

                    let response = try JSONDecoder().decode(RequestDetailResponse.self, from:json!)
                    if response.status == "200" {
                        self.audio_duration = response.audioDuration!
                        print(response)
                        self.newRequestList = response.track
                        self.tbvRequestDetail.reloadData()
                        self.scrollToBottom()
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//           self.lastContentOffset = scrollView.contentOffset.y
//           //print("scrollViewWillBeginDragging" , scrollView.contentOffset.y)
//       }
//       func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//           if self.lastContentOffset < scrollView.contentOffset.y {
//               // did move up
//               // print("move up")
//               self.LeadingConst.constant = -60
//               UIView.animate(withDuration: 0.3) {
//                   self.view.layoutIfNeeded()
//               }
//           } else if self.lastContentOffset > scrollView.contentOffset.y {
//               // did move down
//               //    print("move down")
//               self.LeadingConst.constant = 16
//               UIView.animate(withDuration: 0.3) {
//                   self.view.layoutIfNeeded()
//               }
//           } else {
//            // didn't move
//           }
//
//       }

    @IBAction func onClickEdit(_ sender: Any) {
        let nextVc = storyboardConstants.complain.instantiateViewController(withIdentifier: "idEditRequestVC")as! EditRequestVC
        nextVc.requestDetailList = requestDetailList
        nextVc.audio_duration = audio_duration
        //       nextVc.context = self
        nextVc.requestStatus = self.requestStatus
        navigationController?.pushViewController(nextVc, animated: true)

    }
}
extension RequestDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newRequestList.count
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = newRequestList[indexPath.row]

    if data.isDate {
        let cell = tbvRequestDetail.dequeueReusableCell(withIdentifier: centerCell, for: indexPath)as! FinbookCommonCell
        cell.lblDate.text = data.msgDateView
        cell.viewMain.layer.cornerRadius = 15
        cell.viewMain.backgroundColor = #colorLiteral(red: 0.4920899272, green: 0.2535480559, blue: 0.541061461, alpha: 0.3990702025)
        cell.lblDate.textColor = ColorConstant.colorP
        cell.selectionStyle = .none
        return cell
    }else{
        if data.requestTrackBy == "0"{
            let cellComplain = tbvRequestDetail.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ComplainDetailCell
            cellComplain.layer.backgroundColor = UIColor.clear.cgColor
            
            cellComplain.lblmsgRight.text = data.requestTrackMsg
            cellComplain.lblDateRight.text = data.requestTrackDateTime
            if data.requestTrackImg == ""{
                cellComplain.heightOfImageRight.constant = 0
            } else {
                cellComplain.heightOfImageRight.constant = 90
                if  data.requestTrackImg.contains(".pdf") {
                    cellComplain.ivComplainRight.backgroundColor = UIColor.white
                    cellComplain.ivComplainRight.image = UIImage(named: "pdf")
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                } else if data.requestTrackImg.contains(".doc") || data.requestTrackImg.contains(".docx") {
                    cellComplain.ivComplainRight.backgroundColor = UIColor.white
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                    cellComplain.ivComplainRight.image = UIImage(named: "doc")
                } else if data.requestTrackImg.contains(".ppt") || data.requestTrackImg.contains(".pptx") {
                    cellComplain.ivComplainRight.backgroundColor = UIColor.white
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                    cellComplain.ivComplainRight.image = UIImage(named: "doc")
                } else if data.requestTrackImg.contains(".jpg") || data.requestTrackImg.contains(".jpeg") {
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFill
                    Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.requestTrackImg, palceHolder: "")
                }
                
                else if data.requestTrackImg.contains(".png")  {
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFill
                    Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.requestTrackImg, palceHolder: "")
                } else if data.requestTrackImg.contains(".zip")  {
                    cellComplain.ivComplainRight.backgroundColor = UIColor.white
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                    cellComplain.ivComplainRight.image = UIImage(named: "zip")
                } else {
                    cellComplain.ivComplainRight.backgroundColor = UIColor.white
                    cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                    cellComplain.ivComplainRight.image = UIImage(named: "Audio")
                }
                Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.requestTrackImg, palceHolder: "")
            }
            if data.requestTrackVoice == ""{
                cellComplain.heightOfAudioRight.constant = 0
            }else {
                cellComplain.heightOfAudioRight.constant = 40
//                if data.isPlayAudio {
//                    cellComplain.ivImagePlayer.image = UIImage(named: "pause-button")
//                } else {
//                    cellComplain.ivImagePlayer.image = UIImage(named: "play-symbol")
//                }

            }
            cellComplain.selectionStyle = .none
            cellComplain.bAudio.tag = indexPath.row
            cellComplain.bAudio.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)

            cellComplain.bImage.tag = indexPath.row
            cellComplain.bImage.addTarget(self, action: #selector(onClickImage(_:)), for: .touchUpInside)
            
           // cellComplain.lblStatus.text = "\(data.complaintStatusView ?? "")"
            //cellComplain.lblStatus.textColor = ColorConstant.complaint_open_text
            if  data.requestStatusView != nil &&  data.requestStatusView.count > 0 {
                cellComplain.lblStatus.text = "\(data.requestStatusView ?? "")"
                cellComplain.viewStatus.isHidden = false
                if data.requestStatusView.lowercased().contains("open".lowercased()) {
                    // 0 = open
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                    cellComplain.lblStatus.textColor = ColorConstant.complaint_open_text
                }
                else if data.requestStatusView.lowercased().contains("in progress".lowercased()) {
                    // 2 = in progress
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_inprocess
                    cellComplain.lblStatus.textColor = ColorConstant.complaint_inprocess_text

                }
                else if data.requestStatusView.lowercased().contains("Reply".lowercased()) {
                    // 3 = reply
                    cellComplain.viewStatus.backgroundColor = ColorConstant.green500
                    cellComplain.lblStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

                }
                else if data.requestStatusView.lowercased().contains("closed".lowercased()) {
                    // 1 = close
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_reopen
                    cellComplain.lblStatus.textColor = ColorConstant.complaint_reopen_text

                } else {
                    cellComplain.viewStatus.backgroundColor = ColorConstant.green500
                    cellComplain.lblStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

                }


            } else {
                cellComplain.viewStatus.isHidden = true
            }
            
            
            
            return cellComplain
        }

        let cellComplain = tbvRequestDetail.dequeueReusableCell(withIdentifier: itemCellLeft, for: indexPath)as! LeftComplainCell
        cellComplain.layer.backgroundColor = UIColor.clear.cgColor
        cellComplain.lblmsgLeft.text = data.requestTrackMsg
       
        cellComplain.lblDateLeft.text = data.requestTrackDateTime
        if data.requestTrackImg == ""{
            cellComplain.heightOfImage_Left.constant = 0
        } else {
            cellComplain.heightOfImage_Left.constant = 90
            if  data.requestTrackImg.contains(".pdf") {
                cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                cellComplain.ivComplainLeft.image = UIImage(named: "pdf")
            } else if data.requestTrackImg.contains(".doc") || data.requestTrackImg.contains(".docx") {
                cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                cellComplain.ivComplainLeft.image = UIImage(named: "doc")
            } else if data.requestTrackImg.contains(".ppt") || data.requestTrackImg.contains(".pptx") {
                cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                cellComplain.ivComplainLeft.image = UIImage(named: "doc")
            } else if data.requestTrackImg.contains(".jpg") || data.requestTrackImg.contains(".jpeg") {
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFill
                Utils.setImageFromUrl(imageView: cellComplain.ivComplainLeft, urlString: data.requestTrackImg, palceHolder: "")
            } else if data.requestTrackImg.contains(".png")  {
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFill
                Utils.setImageFromUrl(imageView: cellComplain.ivComplainLeft, urlString: data.requestTrackImg, palceHolder: "")
            } else if data.requestTrackImg.contains(".zip")  {
                cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                cellComplain.ivComplainLeft.image = UIImage(named: "zip")
            } else {
                cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                cellComplain.ivComplainLeft.image = UIImage(named: "Audio")
            }
        }
        if data.requestTrackVoice == ""{
            cellComplain.heightOfAudio_left.constant = 0
        }else {
            
            cellComplain.heightOfAudio_left.constant = 40
//            if data.isPlayAudio {
//                cellComplain.ivImagePlayer.image = UIImage(named: "pause-button")
//            } else {
//                cellComplain.ivImagePlayer.image = UIImage(named: "play-symbol")
//            }
        }

        cellComplain.bAudio.tag = indexPath.row
        cellComplain.bAudio.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)
        cellComplain.bImage.tag = indexPath.row
        cellComplain.bImage.addTarget(self, action: #selector(onClickImage(_:)), for: .touchUpInside)
        cellComplain.selectionStyle = .none
        
        if  data.requestStatusView != nil &&  data.requestStatusView.count > 0 {
            
            cellComplain.lblLeftStatus.text = "\(data.requestStatusView ?? "") by \(data.adminName ?? "")"
            cellComplain.viewStatus.isHidden = false
            if data.requestStatusView.lowercased().contains("open".lowercased()) {
                // 0 = open
                cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_open_text
            }
            else if data.requestStatusView.lowercased().contains("in progress".lowercased()) {
                // 2 = in progress
                cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_inprocess
                cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_inprocess_text

            }
            else if data.requestStatusView.lowercased().contains( "Reply".lowercased()) {
                // 3 = reply
                cellComplain.viewStatus.backgroundColor = ColorConstant.green500
                cellComplain.lblLeftStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            }
            else if data.requestStatusView.lowercased().contains("closed".lowercased()) {
                // 1 = close
                cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_reopen
                cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_reopen_text
            }
        }
            
        return cellComplain

    }
      
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func onClickImage(_ sender:UIButton){
        let index = sender.tag
        let url = newRequestList[index].requestTrackImg!
        self.storeAndShare(withURLString: url)
        
    }
    
    @objc func playClicked(_ sender:UIButton){
        let index = sender.tag
        let url = newRequestList[index].requestTrackVoice
        self.storeAndShare(withURLString: url!)
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

    func scrollToBottom(){
        if newRequestList.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.newRequestList.count-1, section: 0)
                self.tbvRequestDetail.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}
extension RequestDetailVC: UIDocumentInteractionControllerDelegate ,URLSessionDownloadDelegate{
    
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
