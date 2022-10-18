//
//  ProfileEmergencyNumberCell.swift
//  Finca
//
//  Created by harsh panchal on 12/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol UserProfileCellDelegate {
    func deleteButtonClicked(collectionView : UICollectionView , indexPath:IndexPath)
    func shareButtonClicked(collectionView : UICollectionView , indexPath:IndexPath)
    func editButtonClicked(collectionView : UICollectionView , indexPath:IndexPath)
    func callButtonClicked(collectionView : UICollectionView , indexPath:IndexPath)
    func messageButtonClicked(for collectionView : UICollectionView, at indexPath : IndexPath)
}
extension UserProfileCellDelegate{
    func deleteButtonClicked(collectionView : UICollectionView , indexPath:IndexPath){}
    func shareButtonClicked(collectionView : UICollectionView , indexPath:IndexPath){}
    func editButtonClicked(collectionView : UICollectionView , indexPath:IndexPath){}
    func callButtonClicked(collectionView : UICollectionView , indexPath:IndexPath){}
    func messageButtonClicked(for collectionView : UICollectionView, at indexPath : IndexPath){}
}
class ProfileEmergencyNumberCell: UICollectionViewCell {

    @IBOutlet weak var btnShareMember:UIButton!
    @IBOutlet weak var viewMessageButton: UIView!
    @IBOutlet weak var viewDeleteButton: UIView!
    @IBOutlet weak var viewEditButton: UIView!
    @IBOutlet weak var viewCallButton: UIView!
    @IBOutlet weak var viewShareButton: UIView!

    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var stackViewOptions: UIStackView!
    @IBOutlet weak var cornerView: UIView!

    @IBOutlet weak var lblNumber: UILabel!
    var indexPath : IndexPath!
    var collectionView : UICollectionView!
    var delegate : UserProfileCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        if BaseVC().doGetLocalDataUser().memberStatus == "1"{
            self.stackViewOptions.isHidden = true
        }else{
            self.stackViewOptions.isHidden = false
        }
        cornerView.makeBubbleView()
    }

    

    @IBAction func btnMessageClicked(_ sender: UIButton) {
        self.delegate.messageButtonClicked(for: self.collectionView, at: self.indexPath)
    }
    @IBAction func btnCallClicked(_ sender: UIButton) {
        self.delegate.callButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
    @IBAction func btnShareClicked(_ sender: UIButton) {
        self.delegate.shareButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
    @IBAction func btnDeleteCalled(_ sender: UIButton) {
        self.delegate.deleteButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
    @IBAction func btnEditCalled(_ sender: UIButton) {
        self.delegate.editButtonClicked(collectionView: self.collectionView, indexPath: self.indexPath)
    }
}
