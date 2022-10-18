//
//  DiscussionSubCommentCell.swift
//  Finca
//
//  Created by harsh panchal on 30/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol DiscssionSubCommentCellDelegate {
    func btnViewUserProfile(at indexPath : IndexPath)
}
extension DiscussionCommentCellDelegate{
    func btnViewUserProfile(at indexPath : IndexPath){
        
    }
}
class DiscussionSubCommentCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblCommentText: UILabel!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var lblSubCommentReply: UILabel!
    @IBOutlet weak var btnViewUserProfile: UIButton!
    var delegate : DiscussionDetailVC!
   //var delegate : DiscussionSubCommentCellDelegate!
    var indexPath : IndexPath!
    var context : DiscussionDetailVC!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        self.delegate.DeleteButtonClicked(at: self.indexPath)
    }
    
    
    @IBAction func btnViewUserProfile(_ sender: Any) {
        self.delegate.btnViewUserProfile(at: self.indexPath)
    }
}
