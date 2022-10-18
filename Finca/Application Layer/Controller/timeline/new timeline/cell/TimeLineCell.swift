//
//  TimeLineCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Lightbox
import VersaPlayer
import AVKit
import AVFoundation
import DropDown
import Kingfisher
var playerCurrentTime = CMTime.zero
class TimeLineCell: UITableViewCell {
    
    @IBOutlet weak var btnreport: UIButton!
    @IBOutlet weak var viewVD: UIView!
    @IBOutlet weak var lblvdcompanyname: UILabel!
    @IBOutlet weak var imgVDfeedicn: UIImageView!
    @IBOutlet weak var lblVDcommentdesc: UILabel!
    @IBOutlet weak var imgVdCardicn: UIImageView!
    @IBOutlet weak var viewcard: UIView!
    @IBOutlet weak var lblcallus: UILabel!
    @IBOutlet weak var btncallus: UIButton!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbBlockName: UILabel!
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var bEdit: UIButton!
    @IBOutlet weak var bProfile: UIButton!
    //@IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var viewDelete: UIView!
    
    @IBOutlet weak var tvMessage: UITextView!
    
    @IBOutlet weak var bReadMore: UIButton!
    @IBOutlet weak var bLike: UIButton!
    @IBOutlet weak var bComment: UIButton!
    @IBOutlet weak var bSave: UIButton!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var pagerController: UIPageControl!
    @IBOutlet weak var pager: iCarousel!
    @IBOutlet weak var conHeightPager: NSLayoutConstraint!
    
    @IBOutlet weak var playerView: VersaPlayerView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var controls: VersaPlayerControls!
    
    @IBOutlet weak var bMute: UIButton!
    
    @IBOutlet weak var ivComment: UIImageView!
    @IBOutlet weak var lbCommentCount: UILabel!
    @IBOutlet weak var lbSave: UILabel!
    @IBOutlet weak var viewLikedBy: UIView!
    
    @IBOutlet weak var lblLikeByDesc: UILabel!
    @IBOutlet weak var lblPostLIkeCount: UILabel!  
    @IBOutlet weak var imgUser0: UIImageView!
    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var imguser2: UIImageView!
   
    @IBOutlet weak var ivLike: UIImageView!
    @IBOutlet weak var ivSave: UIImageView!
    @IBOutlet weak var lblPostDateAndTime: UILabel!
    @IBOutlet weak var viewLikeComment: UIView!
    
    @IBOutlet weak var ConHeightMoreView: NSLayoutConstraint!
    @IBOutlet weak var actionView: UIView!
   
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var bCall: UIButton!
    
    @IBOutlet weak var ivSingleImage: UIImageView!
    @IBOutlet weak var bSingleImageClick: UIButton!
    var imgArray = [FeedImgModel]()
    var index = 0
    var isFitAspect = true
    var parentViewController: UIViewController? = nil
    var isExpanded: Bool = false
    var delegate : TimelineCellDelegate!
    var indexPath : IndexPath!
    //var action = ["Edit","Delete"]
    let dropDown = DropDown()
    var isShowView = true
    override func awakeFromNib() {
        super.awakeFromNib()
       
        pager.isPagingEnabled = true
        pager.bounces = false
        pager.delegate = self
        pager.dataSource = self
       // tvMessage.isScrollEnabled = false
        ConHeightMoreView.constant = 0
        //var isShowView = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setDataPager(imgArray : [FeedImgModel])  {
        /*if imgArray[0].feedHeight != nil && imgArray[0].feedHeight != "" && imgArray[0].feedHeight != "0"{
            
            let height = Int(imgArray[0].feedHeight)!
            
            if height >= 500 &&  height < 650  {
                conHeightPager.constant = 280
                isFitAspect = false
            }else
            {
                conHeightPager.constant = 400
                isFitAspect = true
            }
            
        } else {
            conHeightPager.constant = 280
            isFitAspect = true
        }*/
        pager.clipsToBounds = true
        self.imgArray = imgArray
        pager.reloadData()
        pagerController.numberOfPages = imgArray.count
        
    }
    func setuplabel(msg : String , isShow : Bool) {
        tvMessage.text = msg
       
      //  print(" isShow " , isShow)
        if isShow {
            tvMessage.textContainer.maximumNumberOfLines  = 0
        } else {
            tvMessage.textContainer.maximumNumberOfLines  = 6
        }
        tvMessage.invalidateIntrinsicContentSize()
    }
    @IBAction func onTapSelectAction(_ sender: Any) {
        if isShowView {
            isShowView = false
                 
                  ConHeightMoreView.constant = 60
                  UIView.animate(withDuration: 0.2, animations: { () -> Void in
                      self.layoutIfNeeded()
                  })
              } else {
                isShowView = true
                 
                ConHeightMoreView.constant = 0
                  UIView.animate(withDuration: 0.2, animations: { [self] () -> Void in
                      self.layoutIfNeeded()
                    
                  })
              }
        }
    @IBAction func onTapReadMore(_ sender: Any) {
        bReadMore.isHidden = true
        tvMessage.textContainer.maximumNumberOfLines  = 0
        tvMessage.invalidateIntrinsicContentSize()
       // tvMessage.textContainer.heightTracksTextView = true
       
       // self.setNeedsLayout()
       // self.layoutIfNeeded()
        delegate.tapReadMore(indexPath: indexPath)
        
        print("line tap more  " , tvMessage.numberOfLine())
    }
    @IBAction func btnShowLikeList(_ sender: UIButton) {
        self.delegate.openLikeList(indexPath: self.indexPath)
    }
    func configurePlayer(isPlayVideo: Bool, index: Int , videoPath : String) {
     
        self.playerView.isHidden = false
        
        playerCurrentTime = CMTime.zero
        
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        //let videoPath = APIConstants.imageAPI + "\(fileID)"
        
        let videoPathString = videoPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let videoURL = URL(string: videoPathString)!
        self.playerView.use(controls: self.controls)
       // self.bMute.isSelected = true
        self.playerView.playbackDelegate = self
        self.playerView.player.automaticallyWaitsToMinimizeStalling = false
        self.playerView.player.isMuted = false
       // playerView.controls?.behaviour.shouldHideControls = false
        playerView.layer.backgroundColor = UIColor.black.cgColor
          self.playerView.renderingView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       // print(isPlayVideo)
        self.bMute.setImage(UIImage(named: "mute-icon"), for: .normal)

        let item = VersaPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidStartPlaying(sender:)), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: item)
        
        
        DispatchQueue.global().async {
            self.playerView.autoplay = isPlayVideo
            self.playerView.set(item: item)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    @objc func playerDidFinishPlaying(sender: Notification) {
        print("Finish video player")
        self.playerView.player.seek(to: CMTime.zero)
    }
    @objc func playerDidStartPlaying(sender: Notification) {
       
        if self.playerView.isPlaying == true {
            DispatchQueue.main.async {
              //  self.bMute.setImage(UIImage(named: "unmute-icon"), for: .selected)
                
            }
        }
    }
    @IBAction func onTapMute(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        //  self.playerView.player.isMuted = sender.isSelected
        
        if !self.playerView.player.isMuted {
            self.playerView.player.isMuted = true
            self.bMute.setImage(UIImage(named: "mute-icon"), for: .normal)
           
           
        } else {
            self.playerView.player.isMuted = false
            self.bMute.setImage(UIImage(named: "unmute-icon"), for: .normal)
        }
//        if self.bMute.isSelected == true {
//            DispatchQueue.main.async {
//                self.bMute.setImage(UIImage(named: "mute-icon"), for: .selected)
//            }
//        }else {
//            DispatchQueue.main.async {
//                self.bMute.setImage(UIImage(named: "unmute-icon"), for: .selected)
//            }
//        }
    }
    
    func setUpLikeView(item : FeedModel , profilePic : String ,userID : String) {
        let baseVC = BaseVC()
       // doGetLocalDataUser().userProfilePic!
        if item.like != nil && item.like.count > 0 {
           // viewLikedBy.isHidden = false
            if item.like.count == 1 {
                imgUser0.isHidden = false
                imgUser1.isHidden = true
                imguser2.isHidden = true
                if item.likeStatus == "1" {
                    Utils.setImageFromUrl(imageView: imgUser0, urlString: profilePic, palceHolder: "user_default")
                }else {
                    Utils.setImageFromUrl(imageView: imgUser0, urlString: item.like[0].userProfilePic, palceHolder: "user_default")
                }
            }else if item.like.count == 2 {
                imgUser0.isHidden = false
                imgUser1.isHidden = false
                imguser2.isHidden = true
                Utils.setImageFromUrl(imageView: imgUser0, urlString: item.like[0].userProfilePic, palceHolder: "user_default")
                Utils.setImageFromUrl(imageView: imgUser1, urlString: item.like[1].userProfilePic, palceHolder: "user_default")
            }else {
                imgUser0.isHidden = false
                imgUser1.isHidden = false
                imguser2.isHidden = false
                
                
                if item.likeStatus == "1" {
                    
                
                if item.like[0].userId != userID && item.like[1].userId != userID && item.like[2].userId != userID{
                    Utils.setImageFromUrl(imageView: imgUser0, urlString: profilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imgUser1, urlString: item.like[1].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imguser2, urlString: item.like[2].userProfilePic, palceHolder: "user_default")
                    
                }else {
                    Utils.setImageFromUrl(imageView: imgUser0, urlString: item.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imgUser1, urlString: item.like[1].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imguser2, urlString: item.like[2].userProfilePic, palceHolder: "user_default")
                }
                }else {
                    Utils.setImageFromUrl(imageView: imgUser0, urlString: item.like[0].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imgUser1, urlString: item.like[1].userProfilePic, palceHolder: "user_default")
                    Utils.setImageFromUrl(imageView: imguser2, urlString: item.like[2].userProfilePic, palceHolder: "user_default")
                }
            }
            
            lblPostLIkeCount.text = "\(item.like.count) \(baseVC.doGetValueLanguage(forKey: "likes"))"
            
        } else {
        
           // viewLikedBy.isHidden = true
            lblPostLIkeCount.text = "\(baseVC.doGetValueLanguage(forKey: "likes_0"))"
            imgUser0.isHidden = true
            imgUser1.isHidden = true
            imguser2.isHidden = true
        }
        
 //       var tempStr = ""
//        if item.like != nil && item.like.count == 1 {
//
//
//            if item.likeStatus == "1"{
//                tempStr = "Liked by You"
//            }else{
//                let username = item.like[0].userName
//                tempStr = "Liked by \(username!)"
//            }
//
//        } else {
//            if item.like != nil && item.like.count > 0 {
//                if item.likeStatus == "1"{
//                    tempStr = "Liked by You and " + String(item.like.count - 1) + " Others"
//                }else{
//                    let username = item.like[0].userName ?? ""
//                    let count = String(item.like.count - 1)
//                    tempStr = "Liked by \(username) and \(count) Others"
//                }
//            }
//
//        }
       // lblLikeByDesc.text = tempStr
    }
    
    func doSetupLike(likeStatus : String) {
        if likeStatus == "0"{
            ivLike.setImageColor(color: ColorConstant.grey_40)
            ivLike.image = UIImage(named: "like_unselected")
        }else {
           
            ivLike.image = UIImage(named: "like_selected")
            ivLike.setImageColor(color: ColorConstant.primaryColor)
            
        }
    }
}
extension TimeLineCell : iCarouselDelegate,iCarouselDataSource , LightboxControllerDismissalDelegate , LightboxControllerPageDelegate , VersaPlayerPlaybackDelegate{
   
    func numberOfItems(in carousel: iCarousel) -> Int {
        print(imgArray.count)
        return imgArray.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        viewCard.btnClickPager.tag = index
        viewCard.btnClickPager.addTarget(self, action: #selector(doViewImageInViewer(_:)), for: .touchUpInside)
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: imgArray[index].feedImg, palceHolder: "banner_placeholder")
        viewCard.frame = pager.frame
        viewCard.ivImage.contentMode = .scaleAspectFill
//        if isFitAspect {
//            viewCard.ivImage.contentMode = .scaleAspectFill
//        } else {
//            viewCard.ivImage.contentMode = .scaleAspectFit
//        }
//        viewCard.viewMain.layer.cornerRadius = 10
//        viewCard.viewMain.backgroundColor = UIColor.gray
     //   viewCard.ivImage.contentMode = .scaleAspectFill
        viewCard.ivImage.clipsToBounds = true
//        viewCard.layer.masksToBounds = false
//        viewCard.layer.shadowColor = UIColor.black.cgColor
//        viewCard.layer.shadowOpacity = 0.5
//        viewCard.layer.shadowOffset = CGSize(width: -1, height: 1)
//        viewCard.layer.shadowRadius = 1
        return viewCard
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//
//        if (option == .spacing) {
//            return value * 1.1
//        }
        return value
    }
    //scrolling started
    func carouselDidScroll(_ carousel: iCarousel) {
        index = carousel.currentItemIndex
        pagerController.currentPage = carousel.currentItemIndex
        
        ////   print("index:\(index)")
    }
//    @IBAction func onClickReadMore(_ sender: UIButton) {
//        self.delegate.onClickReadMore(indexPath: self.indexPath, type: "image")
//    }
    
    @objc func doViewImageInViewer(_ sender:UIButton){
        var images = [LightboxImage]()
        
        for image in imgArray{
            images.append(LightboxImage(imageURL:URL(string:image.feedImg)!))
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
        parentViewController?.present(controller, animated: true, completion: nil)
        controller.goTo(sender.tag )
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
}
