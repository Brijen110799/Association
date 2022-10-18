//
//  RecievedAudioCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 19/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class RecievedAudioCell: UITableViewCell {
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var imgPlayButton: UIImageView!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var playProgress: UISlider!
    var delegate : AudioCellDelegate!
    var indexPath : IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//      _ = playProgress.currentThumbImage?.scaleToSize(newSize: CGSize(width: 12, height: 12))
//
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
extension UIImage {

    func scaleToSize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}
