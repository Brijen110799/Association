//
//  DiscussionListCell.swift
//  Finca
//
//  Created by harsh panchal on 28/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol DiscussionListCellDelegate {
    func MuteButtonClicked(at indexPath : IndexPath)

    func UnMuteButtonClicked(at indexPath : IndexPath)

    func DeleteButtonClicked(at indexPath : IndexPath)
}
class DiscussionListCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var viewMute: UIView!
    @IBOutlet weak var viewUnMute: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var btnUnmuteClicked: UILabel!
    @IBOutlet weak var widthOfPdf: NSLayoutConstraint!
    
    @IBOutlet weak var ivPdf: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    var delegate : DiscussionListCellDelegate!
    var indexpath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        self.delegate.DeleteButtonClicked(at: self.indexpath)
    }
    @IBAction func btnMuteClicked(_ sender: UIButton) {
        self.delegate.MuteButtonClicked(at: self.indexpath)
    }

    @IBAction func btnUnMuteClicked(_ sender: UIButton) {
        self.delegate.UnMuteButtonClicked(at: self.indexpath)
    }
}
