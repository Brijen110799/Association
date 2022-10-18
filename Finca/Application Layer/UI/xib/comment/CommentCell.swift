//
//  CommentCell.swift
//  Finca
//
//  Created by harsh panchal on 21/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

protocol onTapDeleteCommnet {
    func onTapDeletComnent(indexPath : IndexPath)
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblCommentatorName: UILabel!
    @IBOutlet weak var lblCommentText: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewRemoveComment: UIView!
    @IBOutlet weak var btnRemoveComment: UIButton!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var bReply: UIButton!
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var viewReply: UIView!
    
    
    @IBOutlet weak var bMemberDetails: UIButton!
    @IBOutlet weak var bDeleteSub: UIButton!
    @IBOutlet weak var conWidthMainView: NSLayoutConstraint!
    var onTapDeleteCommnet : onTapDeleteCommnet!
    var indexPath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    @IBAction func onClickDelete(_ sender: UIButton) {
        onTapDeleteCommnet.onTapDeletComnent(indexPath: indexPath)
    }
    //    @objc func doRemoveComment(_ sender:UIButton) {
//           let indexsub = sender.tag
//        commentsVC.doDeleteComment(comments_id: commentList[indexsub].commentsId, index: index, isSub: true, subIndex: indexsub, user_id: commentList[indexsub].userId)
//    }
//
    
   
}


