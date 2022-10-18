//
//  ReceivedVideoChatCell.swift
//  Finca
//
//  Created by harsh panchal on 23/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
protocol VideoCellDelegate{
    func playVideo(at indexPath :IndexPath)
}
class ReceivedVideoChatCell: UITableViewCell {
    var delegate : VideoCellDelegate!
    var indexPath : IndexPath!
    var videoUrl : URL!{
        didSet{
            self.getThumbnailImageFromVideoUrl(url: self.videoUrl) { (image) in
                self.imageVIdeoThumb.image = image
            }
        }
    }
    @IBOutlet weak var imageVIdeoThumb: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func btnPlayVideoClicked(_ sender: UIButton) {
        self.delegate.playVideo(at: self.indexPath)
    }
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
}
