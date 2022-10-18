//
//  ElectionPagerVC.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import AVFoundation
import AVKit
class ElectionPagerVC: ButtonBarPagerTabStripViewController , SWRevealViewControllerDelegate {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var bMenu: UIButton!
    var menu = BaseVC()
    var menuTitle = ""
    var overlyView = UIView()
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!

    override func viewDidLoad() {
        self.loadDesing()
        super.viewDidLoad()

        if self.revealViewController() != nil {
            revealViewController().delegate = self
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        lbTitle.text = menuTitle
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        lbTitle.text = menu.doGetValueLanguage(forKey: "election")
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

    func doHideShowLoader(hidden:Bool!){
        hidden ? menu.hideProgress() : menu.showProgress()
    }

    func loadDesing () {

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


        let child_1 = TabUpcomingElectionVC(nibName: "TabUpcomingElectionVC", bundle: nil)
        child_1.menuTitle = menuTitle
        child_1.context = self
        let child_2 = TabCompletedElectionVC(nibName: "TabCompletedElectionVC", bundle: nil)
        child_2.menuTitle = menuTitle
        child_2.context = self
        return [child_1 , child_2]

    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.reloadPagerTabStripView()
    }


    
    @IBAction func btnPlayVideoClicked(_ sender: UIButton) {
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
    
    func playVideo(url: URL) {
   let player = AVPlayer(url: url)

   let vc = AVPlayerViewController()
   vc.player = player

   self.present(vc, animated: true) { vc.player?.play() }
}
    @IBAction func btnHomeClicked(_ sender: UIButton) {
        let destiController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }

}
