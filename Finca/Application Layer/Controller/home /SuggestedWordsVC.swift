//
//  SuggestedWordsVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 14/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

 protocol PassDataVoicesearchDelegate{
    func Passdata(SelectedItemId:String,menu_icon:String,menu_title:String,tutorialVideo:String,Subcategory:[SubMenuModel])
}
class SuggestedWordsVC: BaseVC {
    
    var delegate:PassDataVoicesearchDelegate?
    var appMenusNew = [MenuModel]()
    var ArrTitle = [String]()
    var context:VoiceSearchVC!
    @IBOutlet weak var collectionSuggestedWord:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionSuggestedWord.delegate = self
        collectionSuggestedWord.dataSource = self

    }
    @IBAction func onClickCancel(_ sender: Any) {
        view.removeFromSuperview()
    }
}
extension SuggestedWordsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection" ,ArrTitle.count)
        return appMenusNew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionSuggestedWord.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! SuggestedCell
        
        cell.lblTitle.text = appMenusNew[indexPath.row].menu_title
        Utils.setImageFromUrl(imageView: cell.imgvw, urlString: appMenusNew[indexPath.row].menu_icon, palceHolder: "fincasys_notext")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvWidth = collectionSuggestedWord.frame.size.width

        return CGSize(width: ((cvWidth / 4.0) + 20) , height: 120)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      //  dismiss(animated: true)
       // {
            
            let SelectedItemId = self.appMenusNew[indexPath.row].ios_menu_click
            let menu_icon = self.appMenusNew[indexPath.row].menu_icon
            let menu_title = self.appMenusNew[indexPath.row].menu_title
            let tutorialVideo = self.appMenusNew[indexPath.row].tutorial_video
            let Subcategory = self.appMenusNew[indexPath.row].appmenu_sub
            
            self.delegate?.Passdata(SelectedItemId: SelectedItemId ?? "", menu_icon: menu_icon ?? "", menu_title: menu_title ?? "", tutorialVideo: tutorialVideo ?? "", Subcategory: Subcategory ?? [])
            
       // }
        
      //  doActionOnSelectedItem(SelectedItemId: Arrdata[indexPath.row].ios_menu_click, menu_icon: appMenus[indexPath.row].menu_icon, menu_title: appMenus[indexPath.row].menu_title,tutorialVideo:appMenus[indexPath.row].tutorial_video,Subcategory:appMenus[indexPath.row].appmenu_sub ?? [])
        
    }
    func doActionOnSelectedItem(SelectedItemId : String,menu_icon:String,menu_title:String,tutorialVideo:String,Subcategory:[SubMenuModel]) {
        switch (SelectedItemId) {
        
        case "DiscussionVC":
            let nextVC = storyboardConstants.discussion.instantiateViewController(withIdentifier: "idDiscussionListVC")as! DiscussionListVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;

     

        case "SurveyVC":
            let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSurveyVC")as! SurveyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;

      
        case "MemberVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMemberVC")as! MemberVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            
            break;
        
    
        
        case "EventsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEventTabVC")as! EventTabVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key: menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "NoticeVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idNoticeVC")as! NoticeVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
       
        case "vehicleVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idVehiclesVC")as! VehiclesVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
       
        case "ComplaintsVC":
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idComplaintsVC")as! ComplaintsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "PollingVc":
            let nextVC = PollingPagerVC(nibName: "PollingPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ElectionVC":
            let nextVC = ElectionPagerVC(nibName: "ElectionPagerVC", bundle: nil)
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "BuildingDetailsVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idBuildingDetailsVC")as! BuildingDetailsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "EmergencyContactsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idEmergencyContactsVC")as! EmergencyContactsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ProfileVC":
            let nextVC = self.storyboard?.login().instantiateViewController(withIdentifier: "idUserProfileVC")as! UserProfileVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "SOSVC":
            if UserDefaults.standard.bool(forKey: StringConstants.SECURITY_MPIN_FLAG){
                let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idSOSLockScreenVC") as! SOSLockScreenVC
                let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
                nextVC.youtubevideoId = tutorialVideo
                newFrontViewController.isNavigationBarHidden = true
                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            }else{
                let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "idSOSVC") as! SOSVC
                let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
                newFrontViewController.isNavigationBarHidden = true
                nextVC.youtubeVideoID = tutorialVideo
                revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            }
            break;
        case "GalleryVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGalleryVC")as! GalleryVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "DocumentsVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDocumentsVC")as! DocumentsVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ServiceProviderVC":
            let nextVC = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderVC")as! ServiceProviderVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "BalanceSheetVc":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetVc")as! BalanceSheetVc
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value: menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "ContactUsVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idContactFincaTeamVC") as! ContactFincaTeamVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "MainTabClassifiedVC":
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMainTabClassifiedVC") as! MainTabClassifiedVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
       
        case "RequestVC" :
            let nextVC = storyboardConstants.complain.instantiateViewController(withIdentifier: "idRequestVC") as! RequestVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
            
        case "SearchOccupationVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idOccupationVC")as! OccupationVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        case "PenaltyVC":
            let nextVC = subStoryboard.instantiateViewController(withIdentifier: "idPenaltyVC")as! PenaltyVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
       
            
        case "EntertainmentVC":
            let nextVC = entertainmentStoryboard.instantiateViewController(withIdentifier: "idEntertainmentVC")as! EntertainmentVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.youtubeVideoID = tutorialVideo
            nextVC.appmenu_sub =  Subcategory
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;

        case "KhataBookVC":
            let nextVC = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idFinBookVC")as! FinBookVC
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            nextVC.menuTitle = menu_title
            setPlaceholderLocal(key:  menu_title, value:  menu_icon)
            //            nextVC.youtubeVideoID = appMenus[index].tutorial_video
            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
            break;
        default:
            break;
        }
    }
}
class SuggestedCell:UICollectionViewCell
{
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgvw:UIImageView!
    @IBOutlet weak var viewBorder:UIView!
}
