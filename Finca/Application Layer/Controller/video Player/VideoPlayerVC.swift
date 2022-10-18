//
//  VideoPlayerVC.swift
//  Finca
//
//  Created by harsh panchal on 29/11/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import YoutubePlayerView
class VideoPlayerVC: UIViewController {

    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    
    var videoId = ""
    override func viewDidLoad() {
        print("VideoId ==",videoId)
        super.viewDidLoad()
        videoPlayer.loadWithVideoId(videoId)
        videoPlayer.delegate = self
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension VideoPlayerVC : YoutubePlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        videoPlayer.play()
    }

    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }

    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }

    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }

    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
}
