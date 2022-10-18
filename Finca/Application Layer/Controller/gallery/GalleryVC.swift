//
//  GalleryVC.swift
//  Finca
//
//  Created by harsh panchal on 24/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
import EzPopup
class GalleryVC: BaseVC,UIGestureRecognizerDelegate {
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var tbvGallery: UITableView!
    var youtubeVideoID = ""
    @IBOutlet weak var Vwvideo:UIView!
    
    @IBOutlet weak var filtterView: UIView!
    var itemCell = "GalleryCell"
    var menuTitle = ""
    var gallery_List = [EventModel](){
        didSet{
            tbvGallery.reloadData()
            tbvGallery.setNeedsLayout()
            tbvGallery.layoutIfNeeded()
            
        }
    }
    var permList = [EventModel]()
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var viewClearFilter: UIView!
    @IBOutlet weak var conTrallingAddBuuton: NSLayoutConstraint!
    var lastContentOffset: CGFloat = 0
    @IBOutlet weak var lbTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvGallery.register(nib, forCellReuseIdentifier: itemCell)
        tbvGallery.delegate = self
        tbvGallery.dataSource = self
        doInintialRevelController(bMenu: bMenu)
        setupLongPressGesture()
        addRefreshControlTo(tableView: tbvGallery)
        self.viewClearFilter.isHidden = true
        self.filtterView.isHidden = true
        //        addRefreshControlTo(collectionView: cvGallery)
        doGetGalleryImages()
        tbvGallery.estimatedRowHeight = UITableView.automaticDimension
        lbTitle.text = menuTitle
        if youtubeVideoID != ""
        {
            Vwvideo.isHidden = false
        }else
        {
            Vwvideo.isHidden = true
        }
    }
    
    override func fetchNewDataOnRefresh() {
        self.viewClearFilter.isHidden = true
        self.filtterView.isHidden = true
        refreshControl.beginRefreshing()
        gallery_List.removeAll()
        doGetGalleryImages()
        refreshControl.endRefreshing()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        self.tbvGallery.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
    }
    
    @IBAction func btnOpenDateDailog(_ sender: UIButton!) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCalendarDailogVC") as! CalendarDailogVC
        vc.delegate = self
        vc.fromvc = "galary"
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    func doGetGalleryImages() {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getGallery":"getGallery",
                      "language_id":"1",
                      "block_id": doGetLocalDataUser().blockID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!
        
        ]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.galleryController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(GalleryResponse.self, from:json!)
                    if response.status == "200" {
                        self.filtterView.isHidden = false
                        self.gallery_List = response.event
                        
                        for (index,_) in  self.gallery_List.enumerated() {
                            if index == 0 {
                                self.gallery_List[index].isOpen = true
                               
                            } else {
                                //self.filtterView.isHidden = true
                                self.gallery_List[index].isOpen = false
                            }
                            
                        }
                        self.permList = self.gallery_List
                                              
                       // for
                        self.tbvGallery.reloadData()
                    }else {
                        self.filtterView.isHidden = true
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
        
    }
    
    @IBAction func btnClearFilter(_ sender: UIButton) {
        self.gallery_List = self.permList
        self.viewClearFilter.isHidden = true
    }
    @IBAction func onClickChat(_ sender: Any) {
        /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
    }
}   

extension GalleryVC : CalendarDialogDelegate{
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    func btnDoneClicked(with SelectedDateString: String!, with SelectedDate: Date!,tag : Int!) {
       // print("selected Date",SelectedDateString)
       let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM yyyy"
        let dateC = dateFormat.string(from: SelectedDate)
        
        var tempList = [EventModel]()
        for main_item in permList{
            if main_item.uploadDate.contains(dateC) {
                tempList.append(main_item)
            }
        }
        self.gallery_List = tempList
        self.viewClearFilter.isHidden = false
    }
}

extension GalleryVC : UITableViewDelegate, UITableViewDataSource , OnClickDown {
    
    func onClickDown(index: Int) {
        
        let data = gallery_List[index]
        let cell : GalleryCell = tbvGallery.cellForRow(at: IndexPath(row: index, section: 0)) as! GalleryCell
        
        if data.isOpen {
            gallery_List[index].isOpen = false
            cell.cvHeight.constant = 0
        } else {
            gallery_List[index].isOpen = true
            var count = Double(data.gallery.count) / 4.0
            let rowCount = modf(Float(count)).1
            count = modf(count).0
            if rowCount != 0.0{
                count = count+1
            }
            
            cell.cvHeight.constant = CGFloat((count * 80))
          //  cell.doSetCollectionView(imageList: data.gallery)
                
        }
        tbvGallery.reloadData()
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gallery_List.count == 0{
            viewNoData.isHidden = false
        }else{
            viewNoData.isHidden = true
        }
        
        return gallery_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = gallery_List[indexPath.row]
        let cell = tbvGallery.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! GalleryCell
        cell.doSetCollectionView(imageList: data.gallery)
        cell.lblImageCount.text = String(data.gallery.count)
        cell.lblTitle.text = data.eventTitle
         cell.lbDate.text = data.uploadDate
        cell.context = self
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.onClickDown = self
        if data.isOpen != nil {
            if data.isOpen {
                cell.ivDown.image = UIImage(named: "up-arrow")
            }else {
                cell.cvHeight.constant = 0
                cell.ivDown.image = UIImage(named: "down-arrow")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      /*  let data = gallery_List[indexPath.row]
        var height : Double = 45
        var count = Double(data.gallery.count) / 4.0
        let rowCount = modf(Float(count)).1
        count = modf(count).0
        if rowCount != 0.0{
            count = count+1
        }
        height = height + (count * 80)
        print(height)
        print("image count",data.gallery.count)
        print("count",count)
        print("rowcount",rowCount)
        return CGFloat(height)*/
        
        return UITableView.automaticDimension
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           self.lastContentOffset = scrollView.contentOffset.y
           //print("scrollViewWillBeginDragging" , scrollView.contentOffset.y)
       }
       func scrollViewDidScroll(_ scrollView: UIScrollView) {

           if self.lastContentOffset < scrollView.contentOffset.y {
               // did move up
               // print("move up")
               self.conTrallingAddBuuton.constant = -60
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           } else if self.lastContentOffset > scrollView.contentOffset.y {
               // did move down
               //    print("move down")
               self.conTrallingAddBuuton.constant = 16
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           } else {
               // didn't move
           }

       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let nextVC =  self.storyboard?.instantiateViewController(withIdentifier: "idGallerySliderVC")as! GallerySliderVC
//        nextVC.event_Image_Array.append(contentsOf: gallery_List[indexPath.row].gallery)
//          self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
//extension GalleryVC : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return gallery_List.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = cvGallery.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! GalleryCell
//
//
//        let count =  gallery_List[indexPath.row].gallery.count
//        cell.lblCount.text  = String(count)
//        cell.lblFolderName.text = gallery_List[indexPath.row].eventTitle
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let yourWidth = collectionView.bounds.width/3.0
//
//        return CGSize(width: yourWidth-6, height: yourWidth-20 )
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//
//
//}
