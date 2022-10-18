//
//  AddTimeLineVC.swift
//  Finca
//
//  Created by harsh panchal on 21/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Photos
//import OpalImagePicker
import YPImagePicker

protocol OnSuccessTimeline {
    func onSuccessTimeline()
}
class AddTimeLineVC: BaseVC {
    var selectedImages = [UIImage]()
    @IBOutlet weak var cvSelectedImage: UICollectionView!
    let itemCell = "SelectedImagesCell" 
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBlockName: MarqueeLabel!
    @IBOutlet weak var viewCameraButton: UIView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var viewEditTextButton: UIView!
    
    var comefromCard = ""
    var cardImage = UIImage()
    var edittimeline = ""
    var isEditTimelineCalled =  false
    var timelineContext : TimelineVC!
    var TimelineData : FeedModel!
    var videoUrl : URL? = nil
    var heightKey = 0.0
    let hint = "Write Something.."
    var emoji_category  =  [EmojiCategory]()
    var memberInfo = ""
    var onSuccessTimeline : OnSuccessTimeline?
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewEmoji.isHidden = false
     
      //  viewShowEmoji.isHidden = false
       
        cvSelectedImage.isHidden = false
        doneButtonOnKeyboard(textField: tvMessage)
        
      //  hideKeyBoardHideOutSideTouch()
        tvMessage.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tvMessage.placeholder = doGetValueLanguage(forKey: "write_something")
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        btnPost.setTitle(doGetValueLanguage(forKey: "Post_post_timeline_fragment").uppercased(), for: .normal)
        tvMessage.delegate = self
        btnPost.layer.shadowOffset = CGSize.zero
        btnPost.layer.shadowRadius = 3
        btnPost.layer.shadowOpacity = 0.3
        
        lblUserName.text = doGetLocalDataUser().userFullName!
        lblBlockName.text = doGetLocalDataUser().company_name ?? ""
        
        Utils.setImageFromUrl(imageView: imgUserProfile, urlString: doGetLocalDataUser().userProfilePic!, palceHolder: "user_default")
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvSelectedImage.register(nib, forCellWithReuseIdentifier: itemCell)
        cvSelectedImage.delegate = self
        cvSelectedImage.dataSource = self
        cvSelectedImage.backgroundColor = .clear
        cvSelectedImage.isHidden = true
        if comefromCard == "visitingCard"{
            tvMessage.text = memberInfo
            selectedImages.append(cardImage)
            self.cvSelectedImage.isHidden = false
            viewCameraButton.isHidden = true
            viewEditTextButton.isHidden = true
           
        }else if comefromCard == "kbggame"{
            selectedImages.append(cardImage)
            self.cvSelectedImage.isHidden = false
            viewCameraButton.isHidden = true
            viewEditTextButton.isHidden = true
           
        }
        lbltitle.text = doGetValueLanguage(forKey: "add_post")
        if isEditTimelineCalled {
            viewCameraButton.isHidden = true
            viewEditTextButton.isHidden = true
            tvMessage.text = TimelineData.feedMsg!
            
         
            if tvMessage.text == ""{
               // tvMessage.text = hint
            }
            if TimelineData.feedMsg == ""
            {
                tvMessage.placeholder = hint
                tvMessage.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
            }
            
            btnPost.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
            lbltitle.text = doGetValueLanguage(forKey: "edit_post")
            
//            if edittimeline == "edittimeline"{
//                btnPost.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
//                lbltitle.text = doGetValueLanguage(forKey: "edit_post")
//                //tvMessage.textColor = UIColor.black
//
//            }else{
//                lbltitle.text = doGetValueLanguage(forKey: "add_post")
//            }
            
            if TimelineData.feedType == "1" {
                if TimelineData.feedImg.count > 0  {
                    for item in TimelineData.feedImg{
                        //                    print(TimelineData.feedImg ,"Image Array")
                        //                    print(item.feedImg , "feedImg")
                        downloadImage(from: URL(string: item.feedImg)!)
                        
                    }
                }
            }
        }
    }
    func downloadImage(from url: URL )   {
        print("Download Started")
        //  var imageD = UIImage(named: "")
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                //imageD = UIImage(data: data)
                self!.cvSelectedImage.isHidden = false
                self!.selectedImages.append(UIImage(data: data)!)
                self!.cvSelectedImage.reloadData()
                
            }
        }
      
        // return imageD!
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
   
    override func viewWillLayoutSubviews() {
        if comefromCard == "kbggame"{
            
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.myOrientation = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Utils.setImageFromUrl(imageView: imgUserProfile, urlString: doGetLocalDataUser().userProfilePic!,palceHolder: "user_default")
        self.imgUserProfile.contentMode = .scaleAspectFill
    }
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPost(_ sender: UIButton) {
        
        if selectedImages.count == 0{
            if  !tvMessage.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tvMessage.text != "\n"  &&
                tvMessage.text != "\n "  && tvMessage.text != hint   {
                if isEditTimelineCalled {
                    
                    doCallEditPostFeed()
                } else {
                    doCallAddPostFeed()
                }
                
            } else {
                showAlertMessageWithClick(title: "", msg: "Please write something..")
                            
//                if tvMessage.text == "" {
//                    showAlertMessageWithClick(title: "", msg: "Please write something..")
//                } else {
//
//                }
                
            }
        }else{
            if isEditTimelineCalled {
                self.doCallEditPostFeed()
            } else {
                self.doCallAddPostFeed()
            }
        }
        
    }
    func doCallAddPostFeed(){
        showProgress()
        var feedIsImageType = 0
        var msgText = tvMessage.text!
        if selectedImages.count > 0{
            feedIsImageType = 1
        }
        if videoUrl != nil {
            feedIsImageType = 2
        }
        if msgText == "Write Something.."{
            msgText = ""
        }
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addFeedMultipart":"addFeedMultipart",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "feed_type":String(feedIsImageType),
                      "feed_msg":msgText,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? ""]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipart(serviceName: ServiceNameConstants.newsFeedController, parameters: params, imagesArray: selectedImages,compression: 0.5,fileURL: videoUrl,fileParam: "feed_video[]", completionHandler: { (json, error) in
            self.hideProgress()
            
            if json != nil {
                print(json as Any)
                do {
                    print(json as Any)
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        if self.onSuccessTimeline != nil {
                            self.onSuccessTimeline?.onSuccessTimeline()
                        }
                        
                        if self.comefromCard == "visitingCard"{
                            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
                            vc.isMyTimeLine = false
                            vc.isMemberTimeLine = false
                            self.revealViewController()?.pushFrontViewController(vc, animated: true)
                        }else if self.comefromCard == "kbggame"{
                            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
                            vc.isMyTimeLine = false
                            vc.isMemberTimeLine = false
                            self.revealViewController()?.pushFrontViewController(vc, animated: true)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                       
                    }else {
                        
                    }
                } catch {
                    print("parse error",error.localizedDescription)
                }
            }else{
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func doCallEditPostFeed(){
        showProgress()
//        var feedIsImageType = 0
        var msgText = tvMessage.text!
//        if selectedImages.count > 0{
//            feedIsImageType = 1
//        }
        if msgText == "Write Something.."{
            msgText = ""
        }
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addFeedMultipart":"editFeed",
                      "feed_id":TimelineData.feedId!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "feed_msg":msgText,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "block_name":doGetLocalDataUser().company_name ?? ""]
        
        print("paramedit " , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipart(serviceName: ServiceNameConstants.newsFeedControllerEdit, parameters: params, imagesArray: selectedImages,compression: 0.5, completionHandler: { (json, error) in
            self.hideProgress()
            
            if json != nil {
                print(json as Any)
                do {
                    print(json as Any)
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        if self.onSuccessTimeline != nil {
                            self.onSuccessTimeline?.onSuccessTimeline()
                        }
                        if self.comefromCard == "visitingCard"{
                            //                            let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idTimelineVC")as! TimelineVC
                            //                            self.navigationController?.pushViewController(nextVC, animated: true)
                            Utils.setHome()
                        }else if self.comefromCard == "kbggame"{
                            Utils.setHome()
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                      
                    }else {
                        
                    }
                } catch {
                    print("parse error",error.localizedDescription)
                }
            }else{
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    @IBAction func btnOpenPicker(_ sender: UIButton) {
        
        //        self.selectedImages.removeAll()
        if selectedImages.count < 5{
            let remainingImage = 5 - selectedImages.count
            self.cvSelectedImage.reloadData()
            
            var config = YPImagePickerConfiguration()
            // [Edit configuration here ...]
            // Build a picker with your configuration
            config.showsPhotoFilters = false
            config.library.mediaType = .photoAndVideo
            config.library.maxNumberOfItems = remainingImage
            config.library.minNumberOfItems = 1
            config.library.numberOfItemsInRow = 4
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.screens = [.photo,.library,.video]
            config.startOnScreen = .library
            config.showsCrop = .none
            config.targetImageSize = .cappedTo(size:720)
            // for vide
            config.video.compression = AVAssetExportPresetHighestQuality
            config.video.fileType = .mov
            config.video.recordingTimeLimit = 30.0
            config.video.libraryTimeLimit = 50.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 30.0
            config.video.trimmerMinDuration = 3.0
            
            let picker = YPImagePicker(configuration: config)
            picker.imagePickerDelegate = self
            picker.didFinishPicking { [self, unowned picker] items, cancelled in
                _ = items.map { print("🧀 \($0)") }
                //print("item count",items.count)
                
                for item in items {
                    switch item {
                    case .photo(let photo):
                        self.videoUrl = nil
                        //                    print(self.selectedImages.count)
                        self.viewCameraButton.isHidden = true
                        self.viewEditTextButton.isHidden = true
                        self.selectedImages.append(photo.image)
                        self.cvSelectedImage.isHidden = false
                        self.cvSelectedImage.reloadData()
                        picker.dismiss(animated: true, completion: nil)
                        break;
                    case .video(let video):
                        self.viewCameraButton.isHidden = true
                        self.viewEditTextButton.isHidden = true
                        print("video" , video)
                        self.videoUrl = video.url
                        self.selectedImages.append(video.thumbnail)
                        self.cvSelectedImage.isHidden = false
                        self.cvSelectedImage.reloadData()
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }else{
            self.toast(message: "Maximum images already selected", type: .Information)
        }
    }
    
    @IBAction func tapTimelineWith(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idEditTextImageVC") as! EditTextImageVC
        vc.Delegate = self
        pushVC(vc: vc)
        
    }
    
}
extension AddTimeLineVC: UITextViewDelegate , PassImage{
    func passImage(image: UIImage, strType: String) {
        comefromCard = strType
        cardImage = image
        if comefromCard == "EditTextImage"{
            viewCameraButton.isHidden = true
            viewEditTextButton.isHidden = true
            cvSelectedImage.isHidden = false
            selectedImages.append(cardImage)
            cvSelectedImage.reloadData()
        }
    }
    
    
    @objc func btnImageRemove(_ sender:UIButton){
        if edittimeline == "edittimeline"{
            return
        }
        self.selectedImages.remove(at: sender.tag)
        cvSelectedImage.reloadData()
        if self.selectedImages.count == 0 {
            viewCameraButton.isHidden = false
            viewEditTextButton.isHidden = false
            self.cvSelectedImage.isHidden = true
        }
      
    }
}
extension AddTimeLineVC : OpalImagePickerControllerDelegate{
    private func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        self.dismiss(animated: true, completion: nil)
        self.selectedImages.append(contentsOf: images)
        self.cvSelectedImage.reloadData()
    }
}

extension AddTimeLineVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return selectedImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = cvSelectedImage.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as!SelectedImagesCell
        
        cell.imgSelectedImage.image = selectedImages[indexPath.row]
            cell.imgSelectedImage.contentMode = .scaleToFill
            if edittimeline == "edittimeline"{
                cell.imgRemove.isHidden = true
            }
            cell.btnDeletePressed.tag = indexPath.row
            cell.btnDeletePressed.addTarget(self, action: #selector(btnImageRemove(_:)), for: .touchUpInside)
            return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cvSelectedImage{
            return 0
        }else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cvSelectedImage{
            return 0
        }else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvSelectedImage{
            let width = cvSelectedImage.bounds.width/2
            return CGSize(width: width-4, height: width - 20)
        }else{
            return CGSize(width: 40 , height:30)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
    }
}
extension AddTimeLineVC: YPImagePickerDelegate {
    func noPhotos() {}

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true// indexPath.row != 2
    }
}
