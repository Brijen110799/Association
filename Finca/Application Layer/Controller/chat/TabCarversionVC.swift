//
//  TabCarversionVC.swift
//  Finca
//
//  Created by anjali on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabCarversionVC: BaseButtonBarPagerTabStripViewController<CustomTabCell>  {
    
    @IBOutlet weak var viewMoreTab: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewGroupNew: UIView!
    @IBOutlet weak var bGroupNew: UIButton!
    
    var cellCustGrard =  CustomTabCell()
    var cellMember =  CustomTabCell()
    var cellGroup =  CustomTabCell()
    var memberCount = "0"
    var gradCount = "0"
    let baseVc = BaseVC()
    var youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.CHAT_VIDEO_ID) ?? ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "CustomTabCell", bundle: Bundle(for: CustomTabCell.self), width: { _ in
            return 70.0
        })
    }

    override func viewDidLoad() {
        settings.style.selectedBarHeight=1
        settings.style.buttonBarBackgroundColor = UIColor(named: "ColorPrimary")
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.blue
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 20
        
        changeCurrentIndexProgressive = {(oldCell: CustomTabCell?, newCell: CustomTabCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.lbTitle.textColor =  UIColor.white
            newCell?.lbTitle.textColor = UIColor.white
            print("changeCurrentIndexProgressive ")
           
        }
        super.viewDidLoad()
          
        if   UserDefaults.standard.string(forKey: StringConstants.CREATE_GROUP) ?? "" == "0" {
            self.viewMoreTab.isHidden = true
        } else {
            self.viewMoreTab.isHidden = false
        }
        self.lblScreenTitle.text = self.baseVc.doGetValueLanguage(forKey: "chat")
        
        if youtubeVideoID == "" && youtubeVideoID.count < 3{
            viewVideo.isHidden = true
        }
        bGroupNew.setTitle(baseVc.doGetValueLanguage(forKey: "new_group"), for: .normal)
        
//       changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
//           guard changeCurrentIndex == true else { return }
//           oldCell?.label.textColor =  ColorConstant.grey_40
//           newCell?.label.textColor = UIColor.white
//       }
      
       // self.reloadPagerTabStripView()
        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
//        dismissKeyboard(sender)
//        viewEmoji.isHidden = true
//        conHeightEmoji.constant = CGFloat(0)
        if sender.state == .ended {
           
            viewGroupNew.isHidden = true
        }
        sender.cancelsTouchesInView = false
    }
    
    override func configure(cell: CustomTabCell, for indicatorInfo: IndicatorInfo) {
       // cell.iconImage.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
        if indicatorInfo.title == self.baseVc.doGetValueLanguage(forKey: "members") {
            cellMember = cell
        }
        if indicatorInfo.title == self.baseVc.doGetValueLanguage(forKey: "chat_security") {
            cellCustGrard = cell
        }
        if indicatorInfo.title == self.baseVc.doGetValueLanguage(forKey: "chat_group") {
            cellGroup = cell
        }
        
        cell.lbTitle.text = indicatorInfo.title?.uppercased()
        cell.lbCount.text = indicatorInfo.userInfo as? String
        
        if indicatorInfo.userInfo as? String != nil && indicatorInfo.userInfo as? String != "0" {
            cell.viewBadge.isHidden = false
        } else {
            cell.viewBadge.isHidden = true
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMoreMenuClicked(_ sender: UIButton) {
      
        if viewGroupNew.isHidden {
            viewGroupNew.isHidden = false
        } else {
            viewGroupNew.isHidden = true
        }
        
    }
    func loadDesing () {
       
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: UIButton) {
        
       /* if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            UIUtility.toastMessage(onScreen: "No Video Available!!", from: self)
        }*/
        
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!
                
                baseVc.playVideo(url: url)
               
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            BaseVC().toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabMemberConversionVC")as! TabMemberConversionVC
        //let child_1 =   TabMemberConversionVC()
        child_1.setupInit(itemInfo: IndicatorInfo(title: self.baseVc.doGetValueLanguage(forKey: "members"), image: UIImage(named: ""),userInfo: memberCount))
        child_1.context = self
      
        let child_2 = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabGroupVC")as! TabGroupVC
       
        child_2.context = self
        child_2.setupInit(itemInfo: IndicatorInfo(title: self.baseVc.doGetValueLanguage(forKey: "chat_group"), image: UIImage(named: ""),userInfo: "0"))
        
        let child_3 = storyboardConstants.chat.instantiateViewController(withIdentifier: "idTabGateKeeperVC")as! TabGateKeeperVC
        child_3.context = self
        child_3.setupInit(itemInfo:  IndicatorInfo(title: self.baseVc.doGetValueLanguage(forKey: "chat_security"), image: UIImage(named: ""),userInfo: gradCount))
        
        print("is society ??",BaseVC().doGetLocalDataUser().isSociety!)
        if BaseVC().doGetLocalDataUser().isSociety{
            return [child_1, child_2,child_3]

        }else{
            return [child_1, child_2]
        }
    }
    let bvc = BaseVC()
    func showLoading(){
        bvc.showProgress()
    }
    
    func hideLoading(){
        bvc.hideProgress()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    override func viewWillAppear(_ animated: Bool) {
        //   self.reloadPagerTabStripView()
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadPagerTabStripView()
    }
    
    func setCountMember(count : String) {
//        memberCount = count
//        buttonBarView.reloadData()
        configure(cell: cellMember, for: IndicatorInfo(title:  self.baseVc.doGetValueLanguage(forKey: "members"), image: UIImage(named: ""),userInfo: "\(count)"))
//        let cell = buttonBarView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CustomTabCell
//        cell?.lbCount.text = count
    }
    
    func setCountGrad(count : String) {
          configure(cell: cellCustGrard, for: IndicatorInfo(title: self.baseVc.doGetValueLanguage(forKey: "chat_security"), image: UIImage(named: ""),userInfo: "\(count)"))
    }
    func setCountGroup(count : String) {
          configure(cell: cellGroup, for: IndicatorInfo(title: self.baseVc.doGetValueLanguage(forKey: "chat_group"), image: UIImage(named: ""),userInfo: "\(count)"))
    }
    
    
    @IBAction func tapNewGroup(_ sender: UIButton) {
        viewGroupNew.isHidden = true
        let nextVC = storyboardConstants.chat.instantiateViewController(withIdentifier: "idAddGroupChatVC")as! AddGroupChatVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
