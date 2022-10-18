//
//  DailogAttachmentVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
//import OpalImagePicker
import Photos
import MobileCoreServices
import ContactsUI
protocol OnTapMediaSelect {
    
    func onSuccessMediaSelect(image : [UIImage],fileImage : [URL])
    func onSucessUploadingFile(fileUrl : [String] , msg : String)
    
    func selectDocument(fileArray : [URL], type : String ,  file_duration:String)
    func onTapOthers(type : String)
    func onLocationSuccess(location : String , address: String)
}


class DailogAttachmentVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
    var itemCell = "HomeScreenCvCell"
    var chatVC : ChatVC!
    let nameArray = ["Camera","Images","Document","Location","Contact"]
    let imageArray = [UIImage(named: "camera_attach"),UIImage(named: "gallaery_attach"),UIImage(named: "document_attch"),UIImage(named: "location_attach"),UIImage(named: "contact_attach")]
    let imagePickerController = UIImagePickerController()
    var videoURL: URL!
    var onTapMediaSelect : OnTapMediaSelect!
    var contactStore = CNContactStore()
    let locationManager = CLLocationManager()
  //  "Video", UIImage(named: "video_attachment"),
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
         // Do any additional setup after loading the view.
    }
    override func onClickDone() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}

extension DailogAttachmentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! HomeScreenCvCell
        cell.lblHomeCell.text = nameArray[indexPath.row]
        cell.imgHomeCell.image = imageArray[indexPath.row]
        cell.viewNew.isHidden = true
        cell.viewBlink.isHidden = true
        cell.viewMain.backgroundColor = .clear
        cell.viewShadow.isHidden = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvWidth = collectionView.bounds.width
        return CGSize(width: cvWidth/3.0 , height: 80 )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let name = nameArray[index]
        if name == "Camera" {
            //Camera
            doOpenCamera()
        }else if name == "Images" {
            //Gallery
            doOpenPhoto()
            
        }else if  name == "Document" {
            //Document
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeText),String(kUTTypeRTF),String(kUTTypeSpreadsheet),String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypeJPEG),"com.microsoft.word.doc","public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            present(importMenu, animated: true)
        }else if  name == "Video"{
            //video picker
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.movie"]

            self.present(imagePickerController, animated: true, completion: nil)
        }else if name == "Location" {
            //Location
            doOpenLocatoin()
           
        } else if name == "Contact" {
            //Contact
            openContact()
        }
        
    }
    
    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
    }
    
  
    private func doOpenCamera() {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
          switch authStatus {
          case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                print("not")
            }
            break
          case .denied:
            showAlertMessageWithClick(title: "", msg: "Camera access required for capturing photos")
            break
          case .notDetermined:
            //alertToEncourageCameraAccessInitially()
          
            AVCaptureDevice.requestAccess(for: .video) { isSucess in
                
            }
            break
          default: break
            //alertToEncourageCameraAccessInitially()
          }
        
    }
    private func doOpenPhoto() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let imagePicker = OpalImagePickerController()
            imagePicker.maximumSelectionsAllowed = 5
            print("allowed selection",imagePicker.maximumSelectionsAllowed)
            imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
            imagePicker.selectionImageTintColor = UIColor.black
            imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
            imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
            imagePicker.imagePickerDelegate = self
            present(imagePicker, animated: true, completion: nil)
            break
        //handle authorized status
        case .denied, .restricted :
           showAlertMessageWithClick(title: "", msg: "Need to access photos permision for select images")
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    
                    break
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                // won't happen but still
                case .limited:
                    break
                @unknown default:
                    break
                }
            }
        case .limited:
            break
        @unknown default:
            break
        }
    }
    private func doOpenLocatoin() {
        
        
        DispatchQueue.main.async {
               if CLLocationManager.locationServicesEnabled() {
                   switch CLLocationManager.authorizationStatus() {
                   case .restricted, .denied :
                    self.showAlertMessageWithClick(title: StringConstants.KEY_TURN_ON, msg: StringConstants.KEY_STEP_NEXT)
   
                   case .notDetermined:
                       print("No access")
                       self.locationManager.requestAlwaysAuthorization()
                       // For use in foreground
                       self.locationManager.requestWhenInUseAuthorization()
                   case .authorizedAlways, .authorizedWhenInUse:
                       print("Access")
                   
                    self.sheetViewController?.dismiss(animated: false, completion: {
                        
                        if self.onTapMediaSelect != nil {
                            self.onTapMediaSelect.onTapOthers(type: "Location")
                        }else {
                            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationMapVC") as! SelectLocationMapVC
                            vc.chatVC = self.chatVC
                            self.chatVC.pushVC(vc: vc)
                        }
                       
                    })
   
                   @unknown default:
                       break
                   }
               } else {
                   print("Location services are not enabled")
               }
           }
        
     }
    private func openContact() {
        
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (granted){
                let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
                
                switch authorizationStatus {
                case .authorized:
                    self.sheetViewController?.dismiss(animated: false, completion: {
                        if self.onTapMediaSelect != nil {
                            self.onTapMediaSelect.onTapOthers(type: "Contact")
                        }else {
                            self.chatVC.showContactPicker()
                        }
                       
                    })
                    
                  case .denied:
                    self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                        if access {
                          
                        }
                        else {
                            if authorizationStatus == CNAuthorizationStatus.denied {
                                DispatchQueue.main.async {
                                    _ = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                                }
                              
                            }
                        }
                    })
                    
                default: break
                // completionHandler(accessGranted: false)
                }
            } else {
                self.showAlertMessageWithClick(title: "", msg: self.doGetValueLanguage(forKey: "fincasys_needs_contacts"))
            }
        })
    }
}
extension DailogAttachmentVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate , OpalImagePickerControllerDelegate , UIDocumentPickerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var image  = [UIImage]()
        var  imageT : UIImage!
        if info[.mediaType]as! CFString == kUTTypeMovie{
            //            video selected
            videoURL = info[.mediaURL] as? URL
            print(videoURL as Any) 
            picker.dismiss(animated: true){
                self.sheetViewController?.dismiss(animated: false, completion: {
                    self.chatVC.doSentVideoChat(FileUrl: self.videoURL)
                })
                
            }
        }else{
            //            image selected
            if let img = info[.editedImage] as? UIImage
            {
                //self.ivProfile.image = img
                imageT = img
                print("imagePickerController edit")
                image.append(img)

            }
            else if let img = info[.originalImage] as? UIImage
            {
                imageT = img
                image.append(img)
            }
            
            let imgName = UUID().uuidString + ".jpeg"
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = imageT.jpegData(compressionQuality: 0)! as NSData
            data.write(toFile: localPath, atomically: true)
            let imageURL = URL.init(fileURLWithPath: localPath)
           // self.fileUrl = imageURL
            
            picker.dismiss(animated: true, completion: {
                self.sheetViewController?.dismiss(animated: false, completion: { [self] in
                    
                    if onTapMediaSelect != nil {
                        onTapMediaSelect.onSuccessMediaSelect(image: image, fileImage: [imageURL])
                    } else {
                        self.chatVC.goToMultimedia(images: image, fileImage: [imageURL])
                    }
                })
            })
        }

    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        
//        picker.dismiss(animated: true) {
//            //            picker.
//            picker.viewDidDisappear(true)
//            self.sheetViewController?.dismiss(animated: false, completion: {
//                self.chatVC.goToMultimedia(images: images)
//            })
//        }
    }
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
           var images = [UIImage]()
         let fileImage = [URL]()
        if assets.count > 0 {
            for asset in assets {
//                asset.getURL { (url) in
//
//                    fileImage.append(url!)
//
//                }
                images.append(self.getAssetThumbnailNew(asset: asset))
            }
        }
        picker.dismiss(animated: true) {
            //            picker.
            picker.viewDidDisappear(true)
            self.sheetViewController?.dismiss(animated: false, completion: {
                if images.count  > 0 {
                  
                    if self.onTapMediaSelect != nil {
                        self.onTapMediaSelect.onSuccessMediaSelect(image: images, fileImage: fileImage)
                    } else {
                        self.chatVC.goToMultimedia(images: images, fileImage: fileImage)
                    }
                }
            })
        }
     }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
         guard let myURL = urls.first else {
             return
          }
        
        var array = [URL]()
        array.append(myURL)
        print("url " , myURL)
       //  let fileType = myURL.pathExtension.lowercased()
        self.sheetViewController?.dismiss(animated: false, completion: { [self] in
            if onTapMediaSelect != nil {
                onTapMediaSelect.selectDocument(fileArray: array, type: StringConstants.MSG_TYPE_FILE, file_duration: "")
            } else {
                self.chatVC.doUploadDocument(fileArray: array,type: StringConstants.MSG_TYPE_FILE, file_duration: "")
            }
          
        })
        
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
          controller.dismiss(animated: true, completion: nil)
      }
    
}
extension PHAsset {

    func getPathURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
              
               // print("test url \(contentEditingInput?.fullSizeImageURL)")
               // print("test url string  \(contentEditingInput?.fullSizeImageURL?.absoluteURL)")
                completionHandler(contentEditingInput?.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
