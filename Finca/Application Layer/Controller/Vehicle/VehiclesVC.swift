//
//  VehiclesVC.swift
//  Finca
//
//  Created by CHPL Group on 07/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVKit
import AVFoundation

class VehiclesVC: ButtonBarPagerTabStripViewController , SWRevealViewControllerDelegate {
        var youtubeVideoID = ""
        var overlyView = UIView()
        var isMovingToNext = false
        @IBOutlet weak var bVideo:UIButton!
        @IBOutlet weak var btnMenu: UIButton!
        @IBOutlet weak var lbTitle: UILabel!
        @IBOutlet weak var viewVideo:UIView!
        var menuTitle = ""
        private let baseVC = BaseVC()
        override func viewDidLoad() {
            self.loadDesing()
            super.viewDidLoad()
            lbTitle.text = menuTitle
//            lbTitle.text = baseVC.doGetValueLanguage(forKey: "events")
            revealViewController().delegate = self
            if self.revealViewController() != nil {
                btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
//            if youtubeVideoID != "" && youtubeVideoID.count > 3{
//                viewVideo.isHidden = false
//            }else{
//                viewVideo.isHidden = true
//            }
        }
        override func viewWillLayoutSubviews() {
                if isMovingToNext {
                    self.isMovingToNext = false
                    DispatchQueue.main.async {
                        self.moveToViewController(at: 1, animated: true)
                    }
                }
            }
        @IBAction func onClickHome(_ sender: Any) {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        }
        
       
//        @IBAction func onClickVideo(_ sender: Any) {
//            if youtubeVideoID != ""{
//                    if youtubeVideoID.contains("https"){
//                        let url = URL(string: youtubeVideoID)!
//
//                        playVideo(url: url)
//                    }else{
//                        let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
//                        vc.videoId = youtubeVideoID
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }else{
//                BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
//            }
//        }
//
//
//        func playVideo(url: URL) {
//       let player = AVPlayer(url: url)
//
//       let vc = AVPlayerViewController()
//       vc.player = player
//
//       self.present(vc, animated: true) { vc.player?.play() }
//    }
//        
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
        
        override func viewWillAppear(_ animated: Bool) {
//             reloadPagerTabStripView()
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
        override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            
            
            let child_1 = storyboardConstants.main.instantiateViewController(withIdentifier: "idTabAllVehicleVC") as! TabAllVehicleVC
          //  child_1.delegate = self
          //  child_1.menuTitle = menuTitle
            let child_2 = storyboardConstants.main.instantiateViewController(withIdentifier: "idTabMyVehicleVC") as! TabMyVehicleVC
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabMyVehicleVC") as! TabMyVehicleVC
          //  child_2.menuTitle = menuTitle
           
            
            return [child_1 ,child_2]
            
        }
        override func viewDidAppear(_ animated: Bool) {
             reloadPagerTabStripView()
        }
    }
        extension VehiclesVC: ChildVCDelegate {
            func moveChildVC() {
                
                isMovingToNext = true
        //        viewWillLayoutSubviews()
        //        DispatchQueue.main.async {
        //            self.moveToViewController(at: 1, animated: true)
        //        }
            }
        }





