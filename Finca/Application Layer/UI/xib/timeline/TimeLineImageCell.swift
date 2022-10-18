//
//  TimeLineImageCell.swift
//  Finca
//
//  Created by harsh panchal on 19/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Lightbox

class TimeLineImageCell: UITableViewCell {

    @IBOutlet weak var ThumbnailVideoImfvw:UIImageView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var bEdit: UIButton!
    @IBOutlet weak var lblLikeByDesc: UILabel!
    @IBOutlet weak var imgUser0: UIImageView!
    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var imguser2: UIImageView!
    @IBOutlet weak var viewLikedBy: UIView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var bProfileClick: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblflatName: UILabel!
    @IBOutlet weak var lblPostDescription: UILabel!
    @IBOutlet weak var tvPostDescription: UITextView!
    @IBOutlet weak var ImgPager: iCarousel!
    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var lblPostLIkeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblPostDateAndTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var btnComment: UIButton!
    
    
    @IBOutlet weak var conHeightTextviewDesc: NSLayoutConstraint!
    var delegate : TimelineCellDelegate!
    var indexPath : IndexPath!
    var imgArray = [FeedImgModel]()
    var index = 0
    var parentViewController: UIViewController? = nil
    @IBOutlet weak var bReadMore: UIButton!
     @IBOutlet weak var heightConTextView: NSLayoutConstraint!
     @IBOutlet weak var heightConReadMore: NSLayoutConstraint!
    
    @IBOutlet weak var heightConTextVieww: NSLayoutConstraint!
    @IBOutlet weak var conHeightPager: NSLayoutConstraint!
    var isFitAspect = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ImgPager.isPagingEnabled = true
        ImgPager.bounces = false
        ImgPager.delegate = self
        ImgPager.dataSource = self
        ImgPager.reloadData()
        pagerControl.numberOfPages = imgArray.count
        viewDelete.clipsToBounds = true
    }
    @IBAction func btnShowLikeList(_ sender: UIButton) {
        self.delegate.openLikeList(indexPath: self.indexPath)
    }
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension TimeLineImageCell : iCarouselDelegate,iCarouselDataSource{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        print(imgArray.count)
        return imgArray.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        viewCard.btnClickPager.tag = index
        viewCard.btnClickPager.addTarget(self, action: #selector(doViewImageInViewer(_:)), for: .touchUpInside)
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: imgArray[index].feedImg, palceHolder: "banner_placeholder")
        viewCard.frame = ImgPager.frame
        if isFitAspect {
            viewCard.ivImage.contentMode = .scaleAspectFill
        } else {
            viewCard.ivImage.contentMode = .scaleAspectFit
        }
//        viewCard.viewMain.layer.cornerRadius = 10
//        viewCard.viewMain.backgroundColor = UIColor.gray
        viewCard.ivImage.contentMode = .scaleAspectFill
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
        pagerControl.currentPage = carousel.currentItemIndex
        
        ////   print("index:\(index)")
    }
//    @IBAction func onClickReadMore(_ sender: UIButton) {
//        self.delegate.onClickReadMore(indexPath: self.indexPath, type: "image")
//    }
}

extension TimeLineImageCell:LightboxControllerPageDelegate,LightboxControllerDismissalDelegate{
    
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    
}
