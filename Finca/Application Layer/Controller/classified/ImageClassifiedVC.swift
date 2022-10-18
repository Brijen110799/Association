//
//  ImageClassifiedVC.swift
//  Finca
//
//  Created by Hardik on 6/25/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ImageClassifiedVC: UIViewController {

    @IBOutlet weak var imgViewPager: iCarousel!
    @IBOutlet weak var clvData: UICollectionView!
    var data = [String]()
    var link : String!
    
    var currentIndexPath = IndexPath()
    var userClassifiedList : ListedItem!
    let itemcell = "ImageClassifiedCell"
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(data,"imageData")

        imgViewPager.isPagingEnabled = true
        imgViewPager.bounces = false
        imgViewPager.delegate = self
        imgViewPager.dataSource = self
        imgViewPager.reloadData()
        imgViewPager.clipsToBounds = true
        self.imgViewPager.currentItemIndex = index
       
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
   
    @IBAction func onClickBack(_ sender: Any) {
        DispatchQueue.main.async {
            self.imgViewPager.isHidden = true
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func goTo(index : Int) {
        print("select index  \(index)"  )
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.imgViewPager.scrollToItem(at: index, animated: false)
//        }
     //   self.imgViewPager.currentItemIndex = index
        
        
    }
    override func viewDidLayoutSubviews() {
     //   self.imgViewPager.currentItemIndex = index
    }
    
}

extension ImageClassifiedVC : iCarouselDelegate,iCarouselDataSource{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return userClassifiedList.images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: userClassifiedList.imageURL + userClassifiedList.images[index])
        viewCard.frame = imgViewPager.frame
        viewCard.ivImage.contentMode = .scaleAspectFit
        viewCard.ivImage.clipsToBounds = true
        return viewCard
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {

        return value
        
    }
    
    //scrolling started
    func carouselDidScroll(_ carousel: iCarousel) {
//        index = carousel.currentItemIndex
//        pagerControlCount.currentPage = carousel.currentItemIndex
//        lblCurrentImgNo.text = String(carousel.currentItemIndex + 1)
        
        ////   print("index:\(index)")
    }
}

