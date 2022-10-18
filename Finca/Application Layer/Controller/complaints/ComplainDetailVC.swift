//
//  ComplainDetailVC.swift
//  Finca
//
//  Created by Jay Patel on 07/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
class ComplainDetailVC: BaseVC {
    
    var isclick = true
    var context: ComplaintsVC!
    var complainDetailList : ComplainModel!
    var newComplainList = [Track]()
    let itemCell = "ComplainDetailCell"
    let itemCellLeft = "LeftComplainCell"
    let centerCell = "FinbookCommonCell"
    var indexSelect = -1
    @IBOutlet weak var conTrallingAddBuuton: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    //@IBOutlet weak var conTrallingAddBuuton: NSLayoutConstraint!
    var complainStatus = [complainStatusModel]()
    @IBOutlet var tbvComplainDetail: UITableView!
    let documentInteractionController = UIDocumentInteractionController()
    var lastContentOffset: CGFloat = 0
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    // var player : AVAudioPlayer?
    var audio_duration  = 0
    var playIndex = -1
    var blockStatus  = ""
    var blockMessage  = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvComplainDetail.register(nib, forCellReuseIdentifier: itemCell)
        
        let nibLeft = UINib(nibName: itemCellLeft, bundle: nil)
        tbvComplainDetail.register(nibLeft, forCellReuseIdentifier: itemCellLeft)

        let centerNib = UINib(nibName: centerCell, bundle: nil)
        tbvComplainDetail.register(centerNib, forCellReuseIdentifier: centerCell)


        tbvComplainDetail.delegate = self
        tbvComplainDetail.dataSource = self
        tbvComplainDetail.estimatedRowHeight = 50
        tbvComplainDetail.rowHeight = UITableView.automaticDimension
        
        documentInteractionController.delegate = self
        lbTitle.text = complainDetailList.complain_no
            //+ " - " + complainDetailList.compalainTitle
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        addRefreshControlTo(tableView: tbvComplainDetail)
        
        tbvComplainDetail.backgroundColor = UIColor.clear
        tbvComplainDetail.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func fetchNewDataOnRefresh() {
        self.refreshControl.beginRefreshing()
        self.complainStatus.removeAll()
        self.newComplainList.removeAll()
        self.tbvComplainDetail.reloadData()
        self.doCallGetComplainDetailApi()
        self.refreshControl.endRefreshing()

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }

    func doCallGetComplainDetailApi(){

        //        getComplainDetail_iOS
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getComplainDetail":"getComplainDetail_iOS",
                      "unit_id" : doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "complain_id":complainDetailList.complainID!,
                      "user_id":doGetLocalDataUser().userID!,]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()

            if json != nil {

                do {

                    let response = try JSONDecoder().decode(ComplainDetailResponse.self, from:json!)
                    if response.status == "200" {
//                        print(response)

                        self.complainStatus.append(contentsOf: response.complainStatusArray)
                        self.newComplainList.append(contentsOf: response.track)
                        self.audio_duration = response.audioDuration!
                        for (index , _) in self.newComplainList.enumerated() {
                            self.newComplainList[index].isPlayAudio = false
                            self.newComplainList[index].duration = "0.0"
                        }
                        self.doSetDution()
                        self.scrollToBottom()
                        self.context.fetchNewDataOnRefresh()
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.player?.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEdit(_ sender: Any) {
        
        if isclick{
            self.isclick = false
            if  self.blockStatus != "" &&  self.blockStatus == "true" {
                self.showAppDialog(delegate: self, dialogTitle: "Admin message:", dialogMessage:  self.blockMessage, style: .Notice, tag: 0, cancelText: "", okText: "OKAY")
              
                
            } else {
                let nextVc = storyboardConstants.complain.instantiateViewController(withIdentifier: "idEditComplainVC")as! EditComplainVC
                nextVc.complainDetailList = complainDetailList
                nextVc.audio_duration = audio_duration
                //        nextVc.context = self
                nextVc.complainStatus  = self.complainStatus
                
                navigationController?.pushViewController(nextVc, animated: true)
            }
        }
       
    }
    
    func doSetDution() {
        var player:AVPlayer?
        for (index,item) in newComplainList.enumerated() {
            if item.complainsTrackVoice != "" && item.isDate == false{
                let url = URL(string: item.complainsTrackVoice)
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                player = AVPlayer(playerItem: playerItem)
                let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
                
                // player.isre
                newComplainList[index].duration = duratin.stringFromTimeInterval()
                newComplainList[index].currentTime = "00:00"
            }
        }
        self.tbvComplainDetail.reloadData()
    }

    @objc func onClickImage(_ sender:UIButton){
        let index = sender.tag
        let url = newComplainList[index].complainsTrackImg!
        if playIndex != -1{
            self.newComplainList[playIndex].isPlayAudio = false
            self.player?.pause()
        }

        self.tbvComplainDetail.reloadData()
        self.storeAndShare(withURLString: url)

    }

    @objc func playClicked(_ sender:UIButton){
       /* for (index,_) in newComplainList.enumerated() {
            if index != sender.tag {
                newComplainList[index].isPlayAudio = false
            }
            
        }
       
        
        
        let index = sender.tag
        playIndex = index
        if newComplainList[index].isPlayAudio {
            newComplainList[index].isPlayAudio = false
            player?.pause()
            
            if newComplainList[index].complainsTrackBy == "0"{
               
                guard let cell : ComplainDetailCell = tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? ComplainDetailCell else {
                    print("reuen no ceel")
                    return
                }
               // cell.im
                cell.ivImagePlayer.image = UIImage(named: "play-symbol")
//                if data.isPlayAudio {
//                    cell.ivImagePlayer.image = UIImage(named: "pause-button")
//                } else {
//                    cellComplain.ivImagePlayer.image = UIImage(named: "play-symbol")
//                }
            } else {
                guard let  cell : LeftComplainCell = (tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? LeftComplainCell) else {
                    print("reuen no ceel")
                    return
                }
                cell.ivImagePlayer.image = UIImage(named: "play-symbol")
                
            }
            
            
        } else {
            if newComplainList[index].complainsTrackBy == "0"{
               
                guard let cell : ComplainDetailCell = tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? ComplainDetailCell else {
                    print("reuen no ceel")
                    return
                }
               // cell.im
                cell.ivImagePlayer.image = UIImage(named: "pause-button")

            } else {
                guard let  cell : LeftComplainCell = (tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? LeftComplainCell) else {
                    print("reuen no ceel")
                    return
                }
                cell.ivImagePlayer.image = UIImage(named: "pause-button")
                
            }
            for (indexInner , _) in self.newComplainList.enumerated() {
                if indexInner != index {
                    self.newComplainList[indexInner].isPlayAudio = false
                }
            }
            newComplainList[index].isPlayAudio = true
            let urlS = newComplainList[index].complainsTrackVoice!
            let url = URL(string: urlS)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 1
            player?.play()
            //let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown) , userInfo: nil, repeats: true)
        }*/
       // tbvComplainDetail.reloadData()

        let url = newComplainList[sender.tag].complainsTrackVoice
        self.storeAndShare(withURLString: url!)
    }

    @objc  func countdown() {
        let index = playIndex
        let data = newComplainList[index]
        if player?.currentItem?.status == .readyToPlay {
            if data.complainsTrackBy == "0"{
                let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.currentTime())!)
                newComplainList[index].currentTime = duratin.stringFromTimeInterval()
                //let cell : ComplainDetailCell = tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as! ComplainDetailCell
                guard let cell : ComplainDetailCell = tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? ComplainDetailCell else {
                    print("reuen no ceel")
                    return
                    }
                cell.playerSlider.minimumValue = 0
                let duration : CMTime = (player?.currentItem!.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                cell.playerSlider.maximumValue = Float(seconds)
                let durationC : CMTime = (player?.currentItem?.currentTime())!
                let secondsC : Float64 = CMTimeGetSeconds(durationC)
                cell.playerSlider.minimumTrackTintColor = ColorConstant.colorP
                cell.playerSlider.setValue(Float(secondsC), animated: true)
               // tbvComplainDetail.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                //cell.playSound(currentTime: duratin.stringFromTimeInterval())
                cell.lbCurrentTime.text =  duratin.stringFromTimeInterval()
               // tbvComplainDetail.beginUpdates()
               // tbvComplainDetail.endUpdates()
                
            }else{
                let  duratin: TimeInterval  = CMTimeGetSeconds((player?.currentItem?.currentTime())!)
                newComplainList[index].currentTime = duratin.stringFromTimeInterval()
//                let cell : LeftComplainCell = tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as! LeftComplainCell
                guard let  cell : LeftComplainCell = (tbvComplainDetail.cellForRow(at: IndexPath(row: index, section: 0))  as? LeftComplainCell) else {
                    print("reuen no ceel")
                    return
                    }
                cell.playerSlider.minimumValue = 0
                let duration : CMTime = (player?.currentItem!.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                cell.playerSlider.maximumValue = Float(seconds)
                let durationC : CMTime = (player?.currentItem?.currentTime())!
                let secondsC : Float64 = CMTimeGetSeconds(durationC)
                cell.playerSlider.minimumTrackTintColor = ColorConstant.colorP
                cell.playerSlider.setValue(Float(secondsC), animated: true)
                cell.lbCurrentTime.text =  duratin.stringFromTimeInterval()
               // tbvComplainDetail.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
              //  tbvComplainDetail.beginUpdates()
                //tbvComplainDetail.endUpdates()
            }
        }
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
        if newComplainList.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.newComplainList.count-1, section: 0)
                self.tbvComplainDetail.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.isclick = true
        if  player != nil {
            player?.pause()
        }
    }

}
extension ComplainDetailVC: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newComplainList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = newComplainList[indexPath.row]

        if data.isDate {
            let cell = tbvComplainDetail.dequeueReusableCell(withIdentifier: centerCell, for: indexPath)as! FinbookCommonCell
            cell.lblDate.text = data.msgDateView
            cell.viewMain.layer.cornerRadius = 15
            cell.viewMain.backgroundColor = ColorConstant.primaryColor
            cell.lblDate.textColor = .white
            cell.selectionStyle = .none
            return cell
        }else{
            if data.complainsTrackBy == "0"{
                let cellComplain = tbvComplainDetail.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ComplainDetailCell
                cellComplain.layer.backgroundColor = UIColor.clear.cgColor
                cellComplain.imgplayvideo.isHidden = true
                cellComplain.lblmsgRight.text = data.complainsTrackMsg
                cellComplain.lblDateRight.text = data.complainsTrackDateTime
                if data.complainsTrackImg == ""{
                    cellComplain.heightOfImageRight.constant = 0
                } else {
                    cellComplain.heightOfImageRight.constant = 90
                    if  data.complainsTrackImg.contains(".pdf") {
                        cellComplain.ivComplainRight.backgroundColor = UIColor.white
                        cellComplain.ivComplainRight.image = UIImage(named: "pdf")
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                    } else if data.complainsTrackImg.contains(".doc") || data.complainsTrackImg.contains(".docx") {
                        cellComplain.ivComplainRight.backgroundColor = UIColor.white
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                        cellComplain.ivComplainRight.image = UIImage(named: "doc")
                    } else if data.complainsTrackImg.contains(".ppt") || data.complainsTrackImg.contains(".pptx") {
                        cellComplain.ivComplainRight.backgroundColor = UIColor.white
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                        cellComplain.ivComplainRight.image = UIImage(named: "doc")
                    } else if data.complainsTrackImg.contains(".jpg") || data.complainsTrackImg.contains(".jpeg") {
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFill
                        Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.complainsTrackImg, palceHolder: "")
                    } else if data.complainsTrackImg.contains(".png")  {
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFill
                        Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.complainsTrackImg, palceHolder: "")
                    } else if data.complainsTrackImg.contains(".zip")  {
                        cellComplain.ivComplainRight.backgroundColor = UIColor.white
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                        cellComplain.ivComplainRight.image = UIImage(named: "zip")
                    }else if data.complainsTrackImg.contains(".mp4") || data.complainsTrackImg.contains(".MPEG") {
                        
                        cellComplain.imgplayvideo.isHidden = false
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFill
                        let url = URL(string:  data.complainsTrackImg)

                        DispatchQueue.main.async {
                            if let thumbnailImage = self.getThumbnailImage(forUrl: url!) {
                                cellComplain.ivComplainRight.image = thumbnailImage
                                }
                        }
                       
                       
                      
                    }
                    
                    else {
                        cellComplain.ivComplainRight.backgroundColor = UIColor.white
                        cellComplain.ivComplainRight.contentMode = .scaleAspectFit
                        cellComplain.ivComplainRight.image = UIImage(named: "Audio")
                    }
                    Utils.setImageFromUrl(imageView: cellComplain.ivComplainRight, urlString: data.complainsTrackImg, palceHolder: "")
                }
                if data.complainsTrackVoice == ""{
                    cellComplain.heightOfAudioRight.constant = 0
                }else {

                    cellComplain.lbTotalDuration.text = data.duration
                    cellComplain.lbCurrentTime.text = data.currentTime
                    cellComplain.heightOfAudioRight.constant = 40
                    if data.isPlayAudio {
                        cellComplain.ivImagePlayer.image = UIImage(named: "pause-button")
                    } else {
                        cellComplain.ivImagePlayer.image = UIImage(named: "play-symbol")
                    }

                }
                cellComplain.selectionStyle = .none
                cellComplain.bAudio.tag = indexPath.row
                cellComplain.bAudio.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)

                cellComplain.bImage.tag = indexPath.row
                cellComplain.bImage.addTarget(self, action: #selector(onClickImage(_:)), for: .touchUpInside)
                
               // cellComplain.lblStatus.text = "\(data.complaintStatusView ?? "")"
                //cellComplain.lblStatus.textColor = ColorConstant.complaint_open_text
                if  data.complaintStatusView != nil &&  data.complaintStatusView.count > 0 {
                    cellComplain.lblStatus.text = "\(data.complaintStatusView ?? "")"
                    cellComplain.viewStatus.isHidden = false
                    if data.complaintStatusView.lowercased() == "open" {
                        // 0 = open
                        cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                        cellComplain.lblStatus.textColor = ColorConstant.complaint_open_text
                    } else if data.complaintStatusView.lowercased() == "in progress" {
                        // 3 = in progress
                        cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_inprocess
                        cellComplain.lblStatus.textColor = ColorConstant.complaint_inprocess_text

                    }else if data.complaintStatusView.lowercased() == "reopen" {
                        // 2 = re open
                        cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                        cellComplain.lblStatus.textColor = ColorConstant.complaint_open_text

                    }else if data.complaintStatusView.lowercased() == "closed" {
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

            let cellComplain = tbvComplainDetail.dequeueReusableCell(withIdentifier: itemCellLeft, for: indexPath)as! LeftComplainCell
            cellComplain.layer.backgroundColor = UIColor.clear.cgColor
            cellComplain.lblmsgLeft.text = data.complainsTrackMsg
            cellComplain.imgplayvideo.isHidden = true
            cellComplain.lblDateLeft.text = data.complainsTrackDateTime
            if data.complainsTrackImg == ""{
                cellComplain.heightOfImage_Left.constant = 0
            } else {
                cellComplain.heightOfImage_Left.constant = 90
                if  data.complainsTrackImg.contains(".pdf") {
                    cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                    cellComplain.ivComplainLeft.image = UIImage(named: "pdf")
                } else if data.complainsTrackImg.contains(".doc") || data.complainsTrackImg.contains(".docx") {
                    cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                    cellComplain.ivComplainLeft.image = UIImage(named: "doc")
                } else if data.complainsTrackImg.contains(".ppt") || data.complainsTrackImg.contains(".pptx") {
                    cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                    cellComplain.ivComplainLeft.image = UIImage(named: "doc")
                } else if data.complainsTrackImg.contains(".jpg") || data.complainsTrackImg.contains(".jpeg") {
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFill
                    Utils.setImageFromUrl(imageView: cellComplain.ivComplainLeft, urlString: data.complainsTrackImg, palceHolder: "")
                } else if data.complainsTrackImg.contains(".png")  {
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFill
                    Utils.setImageFromUrl(imageView: cellComplain.ivComplainLeft, urlString: data.complainsTrackImg, palceHolder: "")
                } else if data.complainsTrackImg.contains(".zip")  {
                    cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                    cellComplain.ivComplainLeft.image = UIImage(named: "zip")
                }else if data.complainsTrackImg.contains(".mp4") || data.complainsTrackImg.contains(".MPEG") {
                    cellComplain.imgplayvideo.isHidden = false
                    let url = URL(string:  data.complainsTrackImg)
                    if let thumbnailImage = getThumbnailImage(forUrl: url!) {
                        cellComplain.ivComplainLeft.image = thumbnailImage
                        }
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFill
                  
                }
                else {
                    cellComplain.ivComplainLeft.backgroundColor = UIColor.white
                    cellComplain.ivComplainLeft.contentMode = .scaleAspectFit
                    cellComplain.ivComplainLeft.image = UIImage(named: "Audio")
                }
            }
            if data.complainsTrackVoice == ""{
                cellComplain.heightOfAudio_left.constant = 0
            }else {
                cellComplain.lbTotalDuration.text = data.duration
                cellComplain.lbCurrentTime.text = data.currentTime
                cellComplain.heightOfAudio_left.constant = 40
                if data.isPlayAudio {
                    cellComplain.ivImagePlayer.image = UIImage(named: "pause-button")
                } else {
                    cellComplain.ivImagePlayer.image = UIImage(named: "play-symbol")
                }
            }

            cellComplain.bAudio.tag = indexPath.row
            cellComplain.bAudio.addTarget(self, action: #selector(playClicked(_:)), for: .touchUpInside)
            cellComplain.bImage.tag = indexPath.row
            cellComplain.bImage.addTarget(self, action: #selector(onClickImage(_:)), for: .touchUpInside)
            cellComplain.selectionStyle = .none
            
            if  data.complaintStatusView != nil &&  data.complaintStatusView.count > 0 {
                
                cellComplain.lblLeftStatus.text = "\(data.complaintStatusView ?? "") by \(data.adminName ?? "")"
                cellComplain.viewStatus.isHidden = false
                if data.complaintStatusView.lowercased() == "open" {
                    // 0 = open
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                    cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_open_text
                } else if data.complaintStatusView.lowercased() == "in progress" {
                    // 3 = in progress
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_inprocess
                    cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_inprocess_text

                }else if data.complaintStatusView.lowercased() == "reopen" {
                    // 2 = re open
                    cellComplain.viewStatus.backgroundColor = ColorConstant.complaint_open
                    cellComplain.lblLeftStatus.textColor = ColorConstant.complaint_open_text

                }else if data.complaintStatusView.lowercased() == "closed" {
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           self.lastContentOffset = scrollView.contentOffset.y
           //print("scrollViewWillBeginDragging" , scrollView.contentOffset.y)
       }
       func scrollViewDidScroll(_ scrollView: UIScrollView) {

           if self.lastContentOffset < scrollView.contentOffset.y {
               // did move up
               // print("move up")
               self.conTrallingAddBuuton.constant = -60
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           } else if self.lastContentOffset > scrollView.contentOffset.y {
               // did move down
               //    print("move down")
               self.conTrallingAddBuuton.constant = 16
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           } else {
            // didn't move
           }
        
       }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
}



extension ComplainDetailVC: UIDocumentInteractionControllerDelegate ,URLSessionDownloadDelegate{
    
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

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        // let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        //let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d",minutes,seconds)

    }
}
extension ComplainDetailVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Notice{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
