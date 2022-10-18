//
//  SectionSliderCell.swift
//  Finca
//
//  Created by CHPL Group on 29/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit

class SectionSliderCell: UITableViewCell {

    @IBOutlet weak var pager: iCarousel!
    @IBOutlet weak var pagerController: ISPageControl!
    var slider = [Slider]()
    var homeVC : HomeVC?
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pager.type = .rotary
        pager.isPagingEnabled = true
        pager.isScrollEnabled = true
        pager.stopAtItemBoundary = true
        pager.bounces = false
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    func addSelderData(slider : [Slider])  {
        
        self.slider = slider
        self.pagerController.numberOfPages = slider.count
        self.pagerController.currentPage = 0
        pager.reloadData()
        self.carouselDidScroll(self.pager)
        if self.slider.count > 1
        {
            self.pager.isUserInteractionEnabled = true
        }
        else{
            self.pager.isUserInteractionEnabled = false
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func fire(){
        if slider.count > 0{

            if index == slider.count {
                index = 0
                pagerController.currentPage = pager.currentItemIndex
                
            } else {
                pager.scrollToItem(at: index, animated: true)
                pagerController.currentPage = pager.currentItemIndex
            }
            pager.reloadData()
        }
    }
    
}
extension SectionSliderCell : iCarouselDelegate,iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return slider.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
      
        
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: slider[index].sliderImageName, palceHolder: "banner_placeholder")
        viewCard.lbDescription.isHidden = false
        viewCard.lbDescription.text = "  \(slider[index].date_view ?? "")"
        //setupMarqee(label: viewCard.lbDescription)
        //viewCard.lbDescription.speed = .rate(0.7)
        
        DispatchQueue.main.async {
            /// viewCard.lbDescription.en
            viewCard.lbDescription.restartLabel()
            viewCard.lbDescription.labelReturnedToHome(true)
          // viewCard.lbDescription.triggerScrollStart()
        }
        
        viewCard.frame = pager.frame
        viewCard.layer.masksToBounds = false
        viewCard.viewMain.layer.cornerRadius = 4
        viewCard.ivImage.layer.cornerRadius = 4
        viewCard.btnClickPager.tag = index
        viewCard.btnClickPager.addTarget(self, action: #selector(pagerClickedBy(_:)), for: .touchUpInside)
        return viewCard
        
        
    }
   
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if carousel == pager {
            if (option == .spacing) {
                return 1
            }
        }
       
      
        return value
        
    }
   
    func carouselDidScroll(_ carousel: iCarousel) {
        
        if carousel == pager {
            index = pager.currentItemIndex + 1
            self.pagerController.currentPage = pager.currentItemIndex
        }
      
        
    }
    
  
    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
        return 0
    }
    
    @objc func pagerClickedBy(_ sender : UIButton){
        let data = slider[sender.tag]
       homeVC?.goToSliderDetails(data: data)
    }
}
