//
//  GameMenuVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 17/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class EntertainmentVC: BaseVC {
    var youtubeVideoID = ""
    var menuTitle : String!
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbNoData: UILabel!
    var appmenu_sub = [SubMenuModel]()
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet var cvData: UICollectionView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    var itemCell = "EntertainmentGameCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScreenTitle.text = menuTitle
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceVertical = false
       // print("key ", menuTitle)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        doInintialRevelController(bMenu: bMenu)
        //doSetScreen()
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        if appmenu_sub.count == 0 {
            lbNoData.isHidden = false
            viewNoData.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        doSetScreen()
    }
    func doSetScreen() {
        print("doSetScreen")
        let appDel = UIApplication.shared.delegate as! AppDelegate
       appDel.myOrientation = .portrait
       UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       UIView.setAnimationsEnabled(true)
       
       
       }
    
    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
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
            toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }

    @IBAction func onClickChat(_ sender: Any) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        //  self.navigationController?.pushViewController(vc, animated: true)
        //  bVC.goToDashBoard(storyboard: mainStoryboard)
        let destiController = mainStoryboard.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }

}
extension EntertainmentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  print("numberOfItemsInSection" ,appMenus.count)
        if appmenu_sub.count == 0{
            viewNoData.isHidden = false
        }else{
            viewNoData.isHidden = true
        }
        return appmenu_sub.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! EntertainmentGameCell
        cell.lblHomeCell.text = appmenu_sub[indexPath.row].menu_title
        Utils.setImageFromUrl(imageView: cell.imgHomeCell, urlString: appmenu_sub[indexPath.row].menu_icon, palceHolder: "fincasys_notext")
        cell.imgHeight.constant = 34
        cell.imgwidth.constant = 34
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomeScreenCvCell {
                cell.viewMain.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomeScreenCvCell {
                cell.viewMain.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvWidth = collectionView.bounds.width
        

        return CGSize(width: cvWidth / 2 - 2 , height: 140)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doSelectItem(item: appmenu_sub[indexPath.row].ios_menu_click)
    }
    func  doSelectItem(item : String)  {
        switch item {
        case "HousieVC":
            let vc = storyboard?.instantiateViewController(withIdentifier: "idHousiInfoVC") as! HousiInfoVC
            pushVC(vc: vc)

            break
            
        case "KbgVC":
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idKBGVC")as! KBGVC
            pushVC(vc: vc)
            break
            

        default:
            break
        }
        
    }
    
    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
    }

}
