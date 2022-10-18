//
//  GreetingsDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 24/06/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
protocol greetingsDialogDelegate {
    func btnAgreeClicked(optionName:OptionName! , QuestionIndex : Int!,dialogContext : GreetingsDialogVC!)
}

class GreetingsDialogVC: BaseVC {
    @IBOutlet weak var lblPointsWon: UILabel!
    @IBOutlet weak var lblCongoYourAnsCorrect: UILabel!
    @IBOutlet weak var lblOK: UILabel!
    var context : GeneralKnowledgeGameVC!
    var player: AVAudioPlayer?
    var questionIndex : Int!
    var optionName : OptionName!
    var pointsWon = ""
    var delegate : greetingsDialogDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPointsWon.text = doGetValueLanguage(forKey: "you_won") + pointsWon
        //self.lblPointsWon.text = "You Won \(pointsWon)"
        self.playSound(forResource: "clapping")
        lblCongoYourAnsCorrect.text = doGetValueLanguage(forKey: "congratulations_nyour_answer_is_correct")
        lblOK.text = doGetValueLanguage(forKey: "ok")
    }
    @IBAction func btnYes(_ sender: UIButton) {
        self.delegate.btnAgreeClicked(optionName: self.optionName, QuestionIndex: self.questionIndex,dialogContext: self)
    }
    func playSound(forResource:String) {
        if player != nil {
            if player!.isPlaying {
                player?.stop()
            }
        }
      
        guard let url = Bundle.main.url(forResource: forResource, withExtension: "mp3") else {
            return
           print("rerunn 1")
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
          
            guard let player = player else {
                    print("rerunn 2")
                return
                
            }
            player.volume = 1
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
