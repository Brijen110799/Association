//
//  SendAudioCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 19/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol AudioCellDelegate {
    func PlayAudio(at indexPath : IndexPath)
}
class SendAudioCell: UITableViewCell {

    @IBOutlet weak var imgPlayButton: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var imgTick: UIImageView!
    var delegate : AudioCellDelegate!
    var indexPath : IndexPath!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var playProgress: UISlider!
    @IBOutlet weak var viewDelete: UIView!
      
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playProgress.setThumbImage(UIImage(), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        self.delegate.PlayAudio(at: indexPath)
    }
}
