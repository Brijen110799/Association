//
//  TabPollVC.swift
//  Finca
//
//  Created by Hardik on 5/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabPollVC:  ButtonBarPagerTabStripViewController , SWRevealViewControllerDelegate {
    
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var lblScreenTitle: UILabel!
    var overlyView = UIView()
    var menu = BaseVC()
    var menuTitle : String!
    override func viewDidLoad() {
        self.loadDesing()
        super.viewDidLoad()
        lblScreenTitle.text = menuTitle
        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    @IBAction func onClickHome(_ sender: Any) {
        let destiController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    var youtubeVideoID = ""
    @IBAction func onClickVideo(_ sender: Any) {
        if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
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
    
    override func viewWillAppear(_ animated: Bool) {
        lblScreenTitle.text = menuTitle
        reloadPagerTabStripView()
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
        
        
        let child_1 = TabUpcomingElectionVC(nibName: "TabUpcomingElectionVC", bundle: nil)
//        child_1.menuTitle = menuTitle
//        let child_2 = UIStoryboard(name: "Election", bundle: nil).instantiateViewController(withIdentifier: "idCompletedPollsVC") as! CompletedPollsVC
//        child_2.menuTitle = menuTitle
        
        
     return [child_1 ]
       
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadPagerTabStripView()
    }
    
    
    
}
