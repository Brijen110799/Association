//
//  DailogCustomGalleryVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 09/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Photos
import DropDown

class AlbumModel {
    let id:String
  let name:String
  let count:Int
  let collection:PHAssetCollection
  init(id:String, name:String, count:Int, collection:PHAssetCollection) {
    self.id = id
    self.name = name
    self.count = count
    self.collection = collection
  }
}
class DailogCustomGalleryVC: BaseVC{

    @IBOutlet weak var lbAlbums: UILabel!
    
    @IBOutlet weak var cvPhotoes: UICollectionView!
    var arrayColloection = ["Recents"]
    var itemcell =  "SelectedImagesCell"
  // var imageList = [UIImage]()
   // var imageList : PHFetchResult<PHAsset>? = nil
    var selectedCollection: PHAssetCollection?
    private var imageList: PHFetchResult<PHAsset>!
    
     private var albums: [PHAssetCollection] = []
    var albusStrings = [String]()
    let dropDown = DropDown()
    var  countSelect = 0
    var selectItem = [Bool]()
    var chatVC : ChatVC!
    var  totalCount = 5
    var isOneToChat = true
    var groupChatVC : GroupChatVC!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: itemcell, bundle: nil)
        cvPhotoes.register(nib, forCellWithReuseIdentifier: itemcell)
        cvPhotoes.delegate = self
        cvPhotoes.dataSource = self
        cvPhotoes.allowsMultipleSelection = true
       
      
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if checkMicroPhonePermssion() {
            fetchAlbums()
        }
    }
  
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    private func fetchAlbums() {
         self.albums.removeAll()
    let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    result.enumerateObjects({ (collection, _, _) in
        
        if collection.localizedTitle == "Recents" || collection.localizedTitle == "Favorites" ||
            collection.localizedTitle == "Selfies" {
            self.albums.append(collection)
            self.albusStrings.append(collection.localizedTitle!)
        }
        //  print("dddd" ,collection.localizedTitle)
        
    })
    
   
    
    self.lbAlbums.text = albusStrings[0]
     self.selectedCollection = albums[0]
      self.fetchImagesFromGallery(collection: self.selectedCollection)
  
    
    let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
       albums.enumerateObjects({ (collection, _, _) in
           
           self.albums.append(collection)
           self.albusStrings.append(collection.localizedTitle!)
       })
     }
    
    private func fetchImagesFromGallery(collection: PHAssetCollection?) {
        imageList = nil
        countSelect = 0
         DispatchQueue.main.async {
             let fetchOptions = PHFetchOptions()
             let sortOrder = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.sortDescriptors = sortOrder
             fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
             if let collection = collection {
                 self.imageList = PHAsset.fetchAssets(in: collection, options: fetchOptions)
             } else {
                 self.imageList = PHAsset.fetchAssets(with: fetchOptions)
             }
          
            self.selectItem.removeAll()
            if self.imageList != nil &&  self.imageList.count > 0 {
                for _ in 0...self.imageList.count {
                    self.selectItem.append(false)
                }
            }
            self.cvPhotoes.reloadData()
        }
       
     
        
     }
    
    @IBAction func onClickAlbum(_ sender: Any) {
        dropDown.anchorView = lbAlbums
        dropDown.dataSource = albusStrings
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbAlbums.text = self.dropDown.selectedItem
            self.selectedCollection = self.albums[index]
            //   self.collectionView.reloadData()
            self.fetchImagesFromGallery(collection: self.selectedCollection)
            
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
    }
    
    @IBAction func onClickOk(_ sender: Any) {
        var images = [UIImage]()
        for (index , item) in selectItem.enumerated() {
            
            if item {
                let asset = imageList?.object(at: index)
                images.append(getAssetThumbnailNew(asset: asset!))
            }
            
        }
      
        if images.count > 0 {
            self.sheetViewController?.dismiss(animated: false, completion: {
                if self.isOneToChat {
                    self.chatVC.goToMultimedia(images: images, fileImage: [])
                } else {
                     self.groupChatVC.goToMultimedia(images: images)
                }
               
            })
        }
       
       
        
    }
    
   
    @objc func btnImageRemove(_ sender:UIButton){
        //   self.selectedImages.remove(at: sender.tag)
          // cvSelectedImage.reloadData()
        let index = sender.tag
        if countSelect != totalCount {
            if selectItem[index]  {
                countSelect = countSelect - 1
                selectItem[index] = false
                cvPhotoes.reloadData()
            } else {
                countSelect = countSelect + 1
                selectItem[index] = true
                cvPhotoes.reloadData()
            }
        } else {
            if selectItem[index]  {
                countSelect = countSelect - 1
                selectItem[index] = false
                cvPhotoes.reloadData()
            }
        }
       }
    
    func checkMicroPhonePermssion() -> Bool {
               var isPermision = true
               
        let status = PHPhotoLibrary.authorizationStatus()
             switch status {
             case .authorized:
             //handle authorized status
                isPermision = true
             case .denied, .restricted :
             //handle denied status
                 isPermision = false
                openPermision()
             case .notDetermined:
                 isPermision = false
              //  openPermision()
                // ask for permissions
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        // as above
                        isPermision = true
                        print("authorized")
                        DispatchQueue.main.async {
                           self.fetchAlbums()
                        }
                       
                    case .denied, .restricted:
                        // as above
                        print("authorized")
                        self.openPermision()
                        isPermision = false
                    case .notDetermined:
                        // won't happen but still
                        print("notDetermined")
                    default:
                        break
                    }
                }
                 default:
                    break
             }
        
               return isPermision
               
           }
         func openPermision() {
             let ac = UIAlertController(title: "", message: "Please access photo permission", preferredStyle: .alert)
              ac.addAction(UIAlertAction(title: "OK", style: .default)
              {
                  (result : UIAlertAction) -> Void in
                  UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
              })
              ac.addAction(UIAlertAction(title: "Cancel", style: .default)
              {
                  (result : UIAlertAction) -> Void in
                  ac.dismiss(animated: true, completion: nil)
              })
              present(ac, animated: true)
          }
    
}

extension DailogCustomGalleryVC :  UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  return imageList!.count
        if let imageList = imageList {
            return imageList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath) as! SelectedImagesCell
        cell.imgSelectedImage.contentMode = .scaleAspectFill
        let asset = imageList?.object(at: indexPath.row)
      ///  cell.imgSelectedImage.fetchImage(asset: asset!, contentMode: .aspectFit, targetSize: cell.imgSelectedImage.frame.size)
        cell.imgSelectedImage.image = getAssetThumbnail(asset: asset!)
        cell.imgRemove.backgroundColor = ColorConstant.grey_10
        Utils.setRoundImage(imageView:  cell.imgRemove)
        
        
       
        if    selectItem[indexPath.row] {
            cell.imgRemove.image = UIImage(named: "check_circle")
            cell.imgRemove.setImageColor(color: ColorConstant.blue_400)
            
        } else {
            cell.imgRemove.image = UIImage(named: "radio-blank")
            cell.imgRemove.setImageColor(color: .white)
            
        }
        cell.btnDeletePressed.tag = indexPath.row
        cell.btnDeletePressed.addTarget(self, action: #selector(btnImageRemove(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3
        
        return CGSize(width: width - 2, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     //   self.layoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        
        if countSelect > 0 {
            if countSelect != totalCount {
                if selectItem[indexPath.row]  {
                    countSelect = countSelect - 1
                    selectItem[indexPath.row] = false
                    collectionView.reloadData()
                } else {
                    countSelect = countSelect + 1
                    selectItem[indexPath.row] = true
                    collectionView.reloadData()
                }
            } else {
                if selectItem[indexPath.row]  {
                    countSelect = countSelect - 1
                    selectItem[indexPath.row] = false
                    collectionView.reloadData()
                }
            }
        } else {
            var images = [UIImage]()
            let asset = imageList?.object(at: indexPath.row)
            images.append(getAssetThumbnailNew(asset: asset!))
            self.sheetViewController?.dismiss(animated: false, completion: {
                if self.isOneToChat {
                    self.chatVC.goToMultimedia(images: images, fileImage: [])
                } else {
                    self.groupChatVC.goToMultimedia(images: images)
                }
                
            })
        }
        
        
     
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
          print("didDeselectItemAt")
    }
    
}



