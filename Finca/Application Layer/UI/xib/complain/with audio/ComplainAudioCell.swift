//
//  ComplainAudioCell.swift
//  Finca
//
//  Created by harsh panchal on 12/11/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import AVFoundation
class ComplainAudioCell: UITableViewCell {
    @IBOutlet weak var lblCmpDate: UILabel!
    @IBOutlet weak var lblCmpStatus: UILabel!
    @IBOutlet weak var lblCmpTitle: UILabel!
    @IBOutlet weak var lblCmpDesc: UILabel!
    @IBOutlet weak var lblCmpAdminMsg: UILabel!
    @IBOutlet weak var viewBtnEdit: UIView!
    @IBOutlet weak var viewBtnDelete: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var btnPlayAudio: UIButton!
    let baseVC = BaseVC()
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var conWidth: NSLayoutConstraint!
    var player : AVPlayer?
    var isAudioPlaying = false
    var audioFileURl = ""
    
    @IBOutlet weak var constraintViewHeighr: NSLayoutConstraint!
    @IBOutlet weak var btngiveFeedbackClicked: UIButton!
    @IBOutlet weak var viewGiveFeedback: UIView!
    @IBOutlet weak var imgPlayStop: UIImageView!
    @IBOutlet weak var audioPlaybackSlider: UISlider!
    @IBOutlet weak var viewDelete: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
