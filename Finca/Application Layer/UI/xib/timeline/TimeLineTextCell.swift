//
//  TimeLineTextCell.swift
//  Finca
//
//  Created by harsh panchal on 19/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol TimelineCellDelegate {
    func openLikeList(indexPath : IndexPath)
    func tapReadMore(indexPath : IndexPath)
}
class TimeLineTextCell: UITableViewCell {
    @IBOutlet weak var lblLikeByDesc: UILabel!
    @IBOutlet weak var imgUser0: UIImageView!
    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var imguser2: UIImageView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var viewLikedByUsers: UIView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var bProfileClick: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var lblBlockName: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var BEdit: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblPostMessafe: UILabel!
   // @IBOutlet weak var textViewPostMessage: UITextField!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgComment: UIImageView!
    
    @IBOutlet weak var bReadMore: UIButton!
    @IBOutlet weak var heightConReadMore: NSLayoutConstraint!
    @IBOutlet weak var textViewPostMessage: UITextView!
    
   var delegate : TimelineCellDelegate!
    var indexPath : IndexPath!
    
    @IBOutlet weak var heightConTextView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgComment.setImageColor(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
        viewDelete.clipsToBounds = true
      //  textViewPostMessage.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnOpenLikeList(_ sender: UIButton) {
        self.delegate.openLikeList(indexPath: self.indexPath)
    }
//    @IBAction func onClickReadMore(_ sender: UIButton) {
//        self.delegate.onClickReadMore(indexPath: self.indexPath, type: "text")
//    }
}
