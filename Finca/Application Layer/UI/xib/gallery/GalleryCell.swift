//
//  GalleryCell.swift
//  Finca
//
//  Created by harsh panchal on 24/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol OnClickDown {
    func onClickDown(index : Int)
}

class GalleryCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    @IBOutlet weak var cvImages: UICollectionView!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    let itemcell = "SelectedImagesCell"
    var imageList = [GalleryModel]()
    var context : GalleryVC!
    var index  = -1
    var onClickDown : OnClickDown!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var ivDown: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        let nib = UINib(nibName: itemcell, bundle: nil)
        cvImages.register(nib, forCellWithReuseIdentifier: itemcell)
        cvImages.delegate = self
        cvImages.dataSource = self
        // Initialization code
    }
    
    func doSetCollectionView(imageList:[GalleryModel]){
        self.imageList = imageList
        cvImages.reloadData()
        var count = Double(imageList.count) / 4.0
        let rowCount = modf(Float(count)).1
        count = modf(count).0
        if rowCount != 0.0{
            count = count+1
        }
        self.cvHeight.constant = (count * 80)//self.cvImages.contentSize.height
        self.cvImages.needsUpdateConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func onClickDown(_ sender: Any) {
        onClickDown.onClickDown(index: index)
        
    }
    
    override func layoutSubviews() {
        cvImages.layoutIfNeeded()
        cvImages.setNeedsLayout()
        self.cvHeight.constant = self.cvImages.contentSize.height
//        var count = Double(imageList.count) / 4.0
//        let rowCount = modf(Float(count)).1
//        count = modf(count).0
//        if rowCount != 0.0{
//            count = count+1
//        }
//        self.cvHeight.constant = (count * 80)
    }
    
    
    //    override func layoutIfNeeded() {
    //        cvImages.setNeedsLayout()
//        self.cvHeight.constant = self.cvImages.contentSize.height
////               cvImages.layoutSubviews()
//    }
}
extension GalleryCell :  UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = imageList[indexPath.row]
        let cell = cvImages.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath) as! SelectedImagesCell
        cell.imgSelectedImage.contentMode = .scaleAspectFill
        Utils.setImageFromUrl(imageView: cell.imgSelectedImage, urlString:data.galleryPhoto,palceHolder:"fincasys_notext")
        cell.btnDeletePressed.isHidden = true
        cell.imgRemove.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = cvImages.frame.width/4
        
        return CGSize(width: width - 2, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.layoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idGallerySliderVC")as! GallerySliderVC
        nextVC.event_Image_Array.append(contentsOf: imageList)
        nextVC.index = indexPath.row
            
        context.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
