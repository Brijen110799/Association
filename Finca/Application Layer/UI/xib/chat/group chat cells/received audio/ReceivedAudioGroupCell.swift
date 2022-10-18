//
//  ReceivedAudioGroupCell.swift
//  Finca
//
//  Created by harsh panchal on 25/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ReceivedAudioGroupCell: UITableViewCell {
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblSenderName: UILabel!

    @IBOutlet weak var imgPlayButton: UIImageView!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var playProgress: UISlider!
    var delegate : AudioCellDelegate!
    var indexPath : IndexPath!
    var cellDelegate : ChatClickDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playProgress.setThumbImage(UIImage(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPlayAudioClicked(_ sender: UIButton) {
           self.delegate.PlayAudio(at: self.indexPath)
       }
    
}
