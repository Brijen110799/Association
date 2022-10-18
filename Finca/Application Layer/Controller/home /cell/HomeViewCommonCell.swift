//
//  HomeViewCommonCell.swift
//  Finca
//
//  Created by CHPL Group on 29/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//


import UIKit

class HomeViewCommonCell: UITableViewCell {

    @IBOutlet weak var viewVendor: UIView!
    @IBOutlet weak var viewCircular: UIView!
    @IBOutlet weak var viewMember: UIView!
    @IBOutlet weak var viewHomeMenu: UIView!
    
    @IBOutlet weak var hieghtConCVMenu: NSLayoutConstraint!
    
    @IBOutlet var cvVender: UICollectionView!
    @IBOutlet weak var lbVendor: UILabel!
    @IBOutlet weak var lbViewAll: UILabel!
    
    @IBOutlet weak var lbViewAllMember: UILabel!
    @IBOutlet var cvMember: UICollectionView!
    @IBOutlet weak var lbMember: UILabel!
   
    @IBOutlet weak var pagerCircular: iCarousel!
    @IBOutlet weak var lbCircularCount: UILabel!
    @IBOutlet weak var lbCircular: UILabel!
    
    @IBOutlet var cvHomeMenu: UICollectionView!
    
    let baseVC = BaseVC()
    var itemCellVendor = "HomeVendorCell"
    var serviceProvider =  [LocalServiceProviderListModel]()
    
    var homeVC : HomeVC?
    
    var memberArray = [HomeMemberModel]()
    var itemCellMember = "HomeMemberCell"
    var noticeData =  [ModelNoticeBoard]()
   
    
    var itemCell = "HomeScreenCvCell"
    var appMenus = [MenuModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbViewAll.text = baseVC.doGetValueLanguage(forKey: "view_all").uppercased()
        lbVendor.text = baseVC.doGetValueLanguage(forKey: "vendors").uppercased()
        let nibVendor = UINib(nibName: itemCellVendor, bundle: nil)
        cvVender.register(nibVendor, forCellWithReuseIdentifier: itemCellVendor)
        cvVender.delegate = self
        cvVender.dataSource = self
        cvVender.alwaysBounceVertical = false
        cvVender.isScrollEnabled = false

        lbViewAllMember.text = baseVC.doGetValueLanguage(forKey: "view_all").uppercased()
        lbMember.text = baseVC.doGetValueLanguage(forKey: "members")
        viewMember.isHidden = true
        
        let nibMember = UINib(nibName: itemCellMember, bundle: nil)
        cvMember.register(nibMember, forCellWithReuseIdentifier: itemCellMember)
        cvMember.delegate = self
        cvMember.dataSource = self
        cvMember.alwaysBounceVertical = false
        
        lbCircular.text = baseVC.doGetValueLanguage(forKey: "circulars").uppercased()
        pagerCircular.type = .linear
        pagerCircular.isPagingEnabled = true
        pagerCircular.isScrollEnabled = true
        pagerCircular.stopAtItemBoundary = true
        pagerCircular.bounces = false
        pagerCircular.delegate = self
        pagerCircular.dataSource = self
        pagerCircular.clipsToBounds = true
        pagerCircular.reloadData()
        
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvHomeMenu.register(nib, forCellWithReuseIdentifier: itemCell)
        cvHomeMenu.delegate = self
        cvHomeMenu.dataSource = self
        cvHomeMenu.alwaysBounceVertical = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTapViewAllVendor(_ sender: Any) {
        homeVC?.tapViewAllVendor(sender)
    }
    @IBAction func tapViewAllMember(_ sender: Any) {
        homeVC?.doGoToMember(menu_title: lbMember.text ?? "")
    }
    func setDataVendor(serviceProvider :  [LocalServiceProviderListModel])  {
        self.serviceProvider = serviceProvider
        if self.serviceProvider.count > 0 {
            self.viewVendor.isHidden = false
            self.cvVender.reloadData()
        } else {
            self.viewVendor.isHidden = true
        }
    }
    
    func setDataCircularAndMember(noticeData : [ModelNoticeBoard] , memberArray : [HomeMemberModel]){
        self.noticeData = noticeData
        print("setDataCircularAndMember")
        if noticeData.count > 0 {
            self.viewMember.isHidden = true
            self.viewCircular.isHidden = false
            // self.cvCircular.reloadData()
            self.pagerCircular.reloadData()
            self.lbCircularCount.text = "1/\(noticeData.count)"
            self.viewSelectCirular()
            
            
        } else {
            self.viewCircular.isHidden = true
            viewMember.isHidden = false
            
            if memberArray.count > 0 {
                self.memberArray = memberArray
                self.cvMember.reloadData()
            }
        }
        
     
        
    }
    
    func setAppMenu(appMenus : [MenuModel] ) {
        
        
        self.appMenus  = appMenus
        
        print(appMenus)
        
       
        
        cvHomeMenu.reloadData()
    }
    
    
}
extension HomeViewCommonCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvVender {
            return serviceProvider.count
        }
        if collectionView == cvMember {
            return memberArray.count
        }
        if collectionView == cvHomeMenu {
            return appMenus.count
        }
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvVender {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellVendor, for: indexPath)as! HomeVendorCell
            let item = serviceProvider[indexPath.row]
            
            cell.lbName.text = item.serviceProviderName ?? ""
            Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.serviceProviderUserImage ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
            
            return cell
        }
        
        if collectionView == cvMember {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellMember, for: indexPath)as! HomeMemberCell
            let item = memberArray[indexPath.row]
            
            cell.lbName.text = item.user_full_name ?? ""
            Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
            
            return cell
        }
        
        if collectionView == cvHomeMenu {
        let cell = cvHomeMenu.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! HomeScreenCvCell
        cell.lblHomeCell.text = appMenus[indexPath.row].menu_title
        Utils.setImageFromUrl(imageView: cell.imgHomeCell, urlString: appMenus[indexPath.row].menu_icon, palceHolder: "fincasys_notext")
        //   setCardView(view: cell.viewMain)
        if appMenus[indexPath.row].is_new != nil && appMenus[indexPath.row].is_new  {
            cell.viewNew.isHidden = false
        }else{
            cell.viewNew.isHidden = true
        }
        if appMenus[indexPath.row].isBlink != nil && appMenus[indexPath.row].isBlink  {
            //  viewBlink
            cell.viewBlink.isHidden = false
            cell.viewBlink.alpha = 1.0
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
                if  cell.viewBlink.alpha == 0.0 {
                    cell.viewBlink.alpha = 1.0
                } else {
                    cell.viewBlink.alpha = 0.0
                }
            }, completion: nil)
        } else {
            cell.viewBlink.isHidden = true
        }
        cell.viewMain.backgroundColor = .white
        return cell
        
        }
        return UICollectionViewCell()
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvWidth = collectionView.frame.width
        
        if collectionView == cvVender || collectionView == cvMember{
            return CGSize(width: cvVender.frame.size.width / 4 - 1 , height: 111-1 )
        }

        
        return CGSize(width: cvWidth / 3-1 , height: 111-1 )
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        
        if collectionView == cvVender {
            homeVC?.goToVendorDetails(serviceProviderUsersID: self.serviceProvider[indexPath.row].serviceProviderUsersID ?? "")
       }
        
        if collectionView == cvMember {
            let vc = MemberDetailsVC()
            vc.user_id = memberArray[indexPath.row].user_id ?? ""
            vc.userName = memberArray[indexPath.row].user_first_name ?? ""
            baseVC.pushVC(vc: vc)
        }
        
        if collectionView == cvHomeMenu {
            homeVC?.doActionOnSelectedItem(SelectedItemId: appMenus[indexPath.row].ios_menu_click, menu_icon: appMenus[indexPath.row].menu_icon, menu_title: appMenus[indexPath.row].menu_title,tutorialVideo:appMenus[indexPath.row].tutorial_video,Subcategory:appMenus[indexPath.row].appmenu_sub ?? [])
        }
        
    }
    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if collectionView == cvHomeMenu {
            UIView.animate(withDuration: 0.1) {
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeScreenCvCell {
                    cell.viewMain.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if collectionView == cvHomeMenu {
            UIView.animate(withDuration: 0.1) {
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeScreenCvCell {
                    cell.viewMain.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
        
    }
}

extension HomeViewCommonCell : iCarouselDelegate,iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
            return noticeData.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
       
            let cell = (Bundle.main.loadNibNamed("CircularHomeCell", owner: self, options: nil)![0] as? UIView)! as! CircularHomeCell
            cell.frame = CGRect(x: 0, y: 0, width: pagerCircular.frame.size.width / 1.5, height: 148)
            cell.layer.masksToBounds = true
            let item = noticeData[index]
            cell.layer.isDoubleSided = false
            cell.lbTitle.text = item.notice_title ?? ""
            cell.backgroundColor = .white
          
            cell.lbDesc.text = item.notice_description_text ?? ""
           
           
            cell.lbDate.text = item.date_view ?? ""
            cell.bDetails.tag = index
            cell.bDetails.addTarget(self, action: #selector(tapDetails(sender:)), for: .touchUpInside)
            if index == pagerCircular.currentItemIndex {
                cell.viewMain.backgroundColor = .white
                cell.viewMain.layer.borderWidth = 1
                cell.viewMain.layer.borderColor = ColorConstant.colorP.cgColor
                cell.lbTitle.textColor = ColorConstant.colorP
            } else {
                cell.viewMain.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                cell.viewMain.layer.borderWidth = 1
                cell.viewMain.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                cell.lbTitle.textColor = .black
            }
            
         
        
   
        return cell
        
        
    }
   
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
      
        return value
        
    }
   
    func carouselDidScroll(_ carousel: iCarousel) {
        
       
            lbCircularCount.text = "\(pagerCircular.currentItemIndex + 1 )/\(noticeData.count)"
            
            viewSelectCirular()
        
        
    }
    
    private func viewSelectCirular() {
        print("viewSelectCirular")
        if noticeData.count > 0 {
            
            for (index,_) in noticeData.enumerated() {
                
                
                if  let cell = pagerCircular.itemView(at: index) as? CircularHomeCell {
                    if index == pagerCircular.currentItemIndex {
                        cell.viewMain.backgroundColor = .white
                        cell.viewMain.layer.borderWidth = 1
                        cell.viewMain.layer.borderColor = ColorConstant.colorP.cgColor
                        cell.lbTitle.textColor = ColorConstant.colorP
                    } else {
                        cell.viewMain.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                        cell.viewMain.layer.borderWidth = 1
                        cell.viewMain.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                        cell.lbTitle.textColor = .black
                    }
                }
                
                
                //(Bundle.main.loadNibNamed("CircularHomeCell", owner: self, options: nil)![0] as? UIView)! as! CircularHomeCell
            }
           
       }
    }
    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
        return 0
    }
    
    @objc func tapDetails(sender : UIButton) {
        homeVC?.goToCircularDetails(data: noticeData[sender.tag])
    }
    
}
