//
//  ClassifiedDetailsVC.swift
//  Finca
//
//  Created by Jay Patel on 19/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ClassifiedDetailsVC: BaseVC {
    var userClassifiedList : ListedItem!
    var index = 0
    var flag : Int!
    
    @IBOutlet weak var lblspeificationdesc: UILabel!
    @IBOutlet weak var lblspecification: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgViewPager: iCarousel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPurchaseYear: UILabel!
    @IBOutlet var lblFeatures: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTotalImgNo: UILabel!
    @IBOutlet var lblCurrentImgNo: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserNumber: UILabel!
    @IBOutlet var pagerControlCount: UIPageControl!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var lbBrand: UILabel!
    @IBOutlet var lbFeatures: UILabel!
    @IBOutlet var lbPurchaseYear: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var lbForSale: UILabel!
    @IBOutlet var lbLocation: UILabel!
    @IBOutlet var lbLocationValue: UILabel!
    
    @IBOutlet var lbConditionTitle: UILabel!
    @IBOutlet var lbCondition: UILabel!
    @IBOutlet var ivProfile: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
     //   Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        imgViewPager.isPagingEnabled = true
        imgViewPager.bounces = false
        imgViewPager.delegate = self
        imgViewPager.dataSource = self
        imgViewPager.reloadData()
        if flag == 1{
            lblUserName.text = doGetLocalDataUser().userFullName
            //        print("name",userClassifiedList.userName)
            lblUserNumber.text = doGetLocalDataUser().userMobile
        }else{
            lblUserName.text = userClassifiedList.userName
            //        print("name",userClassifiedList.userName)
            lblUserNumber.text = userClassifiedList.userMobile
        }
        if userClassifiedList.images == nil{
           // lblTotalImgNo.isHidden = true
            pagerControlCount.isHidden = true
        }else{
            lblCurrentImgNo.text = "1"
        lblTotalImgNo.text = String(userClassifiedList.images.count)
        pagerControlCount.numberOfPages = userClassifiedList.images.count
        }
        
        lblFeatures.text = userClassifiedList.classifiedFeatures
        lbCondition.text = userClassifiedList.product_type ?? "" == "0" ? doGetValueLanguage(forKey: "old_items") : doGetValueLanguage(forKey: "new_items")
        
        lblTitle.text = userClassifiedList.classifiedAddTitle
        lblPurchaseYear.text = userClassifiedList.classifiedManufacturingYear
        lblPrice.text = "\(localCurrency()) "+userClassifiedList.classifiedExpectedPrice
        lblBrand.text = userClassifiedList.classifiedBrandName
        lblDescription.text = userClassifiedList.classifiedDescribeSelling
        lblspeificationdesc.text = userClassifiedList.classifiedspecification
        self.viewMain.layer.maskedCorners = [.layerMinXMinYCorner]
        lbLocationValue.text = userClassifiedList.location ?? ""
        lbBrand.text = doGetValueLanguage(forKey: "brands")
        lbFeatures.text = doGetValueLanguage(forKey: "feature")
        lbPurchaseYear.text = doGetValueLanguage(forKey: "purchase_year_")
        lbDescription.text = doGetValueLanguage(forKey: "description_contact_finca_fragment")
        lbForSale.text = doGetValueLanguage(forKey: "for_sale")
        lbLocation.text = doGetValueLanguage(forKey: "location")
        lbConditionTitle.text = doGetValueLanguage(forKey: "condition")
        lblspecification.text = doGetValueLanguage(forKey: "specification")
        
        Utils.setImageFromUrl(imageView: ivProfile, urlString: userClassifiedList.user_profile_pic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
    }
    @IBAction func onClickImage(_ sender: Any) {
        if userClassifiedList.images == nil{
            print("onClickImage")
        }else{
             print("idImageClassifiedVC")
            let vc = storyboard?.instantiateViewController(withIdentifier: "idImageClassifiedVC")as! ImageClassifiedVC
            vc.data = userClassifiedList.images
            vc.link = userClassifiedList.imageURL
            vc.userClassifiedList = userClassifiedList
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func fire(){
        if index == userClassifiedList.images.count {
                index = 0
            } else {
                imgViewPager.currentItemIndex = index
            }
  
    }
    @IBAction func btnOnClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOnClickChat(_ sender: Any) {
        
    }
    @IBAction func btnOnClickCall(_ sender: Any) {
        
        if userClassifiedList.public_mobile ?? "" == StringConstants.KEY_MOBILE_PRIVATE {
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
            
            
        }else {
            let phone = userClassifiedList.userMobile!.components(separatedBy: .whitespaces).joined()
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
  
    }
    
}
extension ClassifiedDetailsVC : iCarouselDelegate,iCarouselDataSource{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if userClassifiedList.images == nil{
            return 0
        }else{
        return userClassifiedList.images.count
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        viewCard.btnClickPager.tag = index
        viewCard.btnClickPager.addTarget(self, action: #selector(doViewImageInViewer(_:)), for: .touchUpInside)
        if userClassifiedList.images == nil{
        
        }else{
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: userClassifiedList.imageURL + userClassifiedList.images[index])
        }
        viewCard.frame = imgViewPager.frame
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
        if userClassifiedList.images == nil{
        }else{
        index = carousel.currentItemIndex
        pagerControlCount.currentPage = carousel.currentItemIndex
        lblCurrentImgNo.text = String(carousel.currentItemIndex + 1) 
        }
        ////   print("index:\(index)")
    }
    @objc func doViewImageInViewer(_ sender : UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "idImageClassifiedVC")as! ImageClassifiedVC
        vc.data = userClassifiedList.images
        vc.link = userClassifiedList.imageURL
        vc.userClassifiedList = userClassifiedList
        vc.index =  imgViewPager.currentItemIndex
        self.navigationController?.pushViewController(vc, animated: true)
       // vc.goTo(index:  imgViewPager.currentItemIndex)
    }
    
}
extension ClassifiedDetailsVC :  AppDialogDelegate {
    
   
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
