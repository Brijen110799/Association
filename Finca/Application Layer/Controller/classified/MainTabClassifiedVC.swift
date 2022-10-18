//
//  MainTabClassifiedVC.swift
//  Finca
//
//  Created by Jay Patel on 18/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVFoundation
import AVKit
class MainTabClassifiedVC: ButtonBarPagerTabStripViewController, SWRevealViewControllerDelegate {
    var overlyView = UIView()
    var youtubeVideoID = ""
    var menuTitle = ""
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet var btnOnCLickMenu: UIButton!
    @IBOutlet var lbTitle : UILabel!
    var child_1  = AllClassifiedVC()
    override func viewDidLoad() {
        loadDesing()
        super.viewDidLoad()
        doInintialRevelController(bMenu: btnOnCLickMenu)
        lbTitle.text = menuTitle
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    func loadDesing() {
              
              settings.style.buttonBarBackgroundColor = .clear
              settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
              settings.style.buttonBarItemBackgroundColor = .clear
              settings.style.selectedBarBackgroundColor = .clear
              settings.style.selectedBarHeight = 2.0
              settings.style.buttonBarMinimumLineSpacing = 0
              settings.style.buttonBarItemTitleColor = UIColor.blue
              settings.style.selectedBarHeight = 1
              settings.style.buttonBarItemsShouldFillAvailableWidth = true
              settings.style.buttonBarLeftContentInset = 0
              settings.style.buttonBarRightContentInset = 0
              settings.style.buttonBarHeight = 20
              
              
              changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                  guard changeCurrentIndex == true else { return }
                  oldCell?.label.textColor =  ColorConstant.colorP
                  newCell?.label.textColor = UIColor.white
                  newCell?.label.font = newCell?.label.font.withSize(12)
                  oldCell?.backgroundColor = .clear
                  oldCell?.cornerRadius = 20
                  newCell?.cornerRadius = 20
                  oldCell?.label.font =  oldCell?.label.font.withSize(12)
                  oldCell?.label.font =  oldCell?.label.font.withSize(12)
                  newCell?.backgroundColor =  ColorConstant.colorP
                  oldCell?.sizeToFit()
                  
                  
          }
          
          
      }
    func doInintialRevelController(bMenu:UIButton) {
        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.left     // if it not statisfy try this --> if
        {
            overlyView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height)
            //overlyView.backgroundColor = UIColor.red
            self.view.addSubview(overlyView)
            //self.view.isUserInteractionEnabled = false
        }
        else
        {
            overlyView.removeFromSuperview()
            //self.view.isUserInteractionEnabled = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.reloadPagerTabStripView()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
         child_1 = self.storyboard?.instantiateViewController(withIdentifier: "idAllClassifiedVC")as! AllClassifiedVC
        child_1.mainTabClassifiedVC = self
        child_1.menuTitle = menuTitle
      
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "idTabMyClassifiedVC")as! TabMyClassifiedVC
        child_2.MainTabClassifiedVC = self
        child_2.menuTitle = menuTitle
        //                child_2.loadView()
        return [child_1,child_2]
    }
    @IBAction func btnOnClickVideo(_ sender: Any) {
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
//                                self.toast(message: response.message, type: .Warning)
        }
    }
    func playVideo(url: URL) {
   let player = AVPlayer(url: url)

   let vc = AVPlayerViewController()
   vc.player = player

   self.present(vc, animated: true) { vc.player?.play() }
}
    @IBAction func btnOnClickHome(_ sender: Any) {
        let destiController = storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    func showFilterDailog(classifiedCategory :[ClassifiedCategory] , categoryId : String , subCategoryId : String ,product_type : String ) {
        let vc = BuySellFilterVC()
        vc.classifiedCategory = classifiedCategory
        vc.onApplyFilterServiceProvider = self
        vc.categoryId = categoryId
        vc.subCategoryId = subCategoryId
        vc.condition =  product_type
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        vc.view.frame = view.frame
        addChild(vc)
        view.addSubview(vc.view)
        //self.addPopView(vc: vc)
    }
    
}


extension MainTabClassifiedVC: OnApplyFilterServiceProvider{
    
    //for filter apply
    func onApplyFilterServiceProvider(categoryId: String, subCategoryId: String, radius: String, companyName: String, isApplyFilter: Bool) {
        print("call main")
     
        child_1.doAfterApplyFilter(categoryId: categoryId, subCategoryId: subCategoryId, isApplyFilter: isApplyFilter, product_type : radius)
    }
    
}
