//
//  GameDialogVC.swift
//  Finca
//
//  Created by Hardik on 5/8/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class GameDialogVC: BaseVC {

    var currectAnswer = ""
    var contex: GeneralKnowledgeGameVC!
    var lifeLine = ""
    var ArrList : Question!
    var item : Game!

    @IBOutlet weak var ivDialog: UIImageView!
    @IBOutlet var MainVIew: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var lbl5050: UILabel!
    @IBOutlet weak var view5050: UIView!
    @IBOutlet weak var viewLifeline: UIView!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMessage.text = doGetValueLanguage(forKey: "are_you_sure_you_want_to_use_this_life_line")
        lblYes.text = doGetValueLanguage(forKey: "yes")
        lblNo.text = doGetValueLanguage(forKey: "no")
        if lifeLine == "5050"{
            viewLifeline.isHidden = true
            view5050.isHidden = false
        }else if lifeLine == "call"{
            viewLifeline.isHidden = false
            view5050.isHidden = true
            ivDialog.setImageWithTint(ImageName: "stopwatch", TintColor: ColorConstant.indigo_500)
        }
        if lifeLine == "Audience"{
            viewLifeline.isHidden = false
            view5050.isHidden = true
            ivDialog.setImageWithTint(ImageName: "Audience", TintColor: ColorConstant.indigo_500)
            ivDialog.contentMode = .scaleAspectFit
        }
        if lifeLine == "FlipFlop"{
            viewLifeline.isHidden = false
            view5050.isHidden = true
            ivDialog.setImageWithTint(ImageName: "flip", TintColor: ColorConstant.indigo_500)
            ivDialog.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func onClickNo(_ sender: Any) {
        contex.player?.play()

        if lifeLine == "FlipFlop"{
            self.dismiss(animated: true) {
                self.contex.player?.play()
                self.contex.startCounterTimer()
            }
            self.dismiss(animated: true, completion: nil)

        }
        if lifeLine == "Audience"{
            self.dismiss(animated: true) {
                self.contex.player?.play()
                self.contex.startCounterTimer()
            }
        }
        if lifeLine == "5050"{
            self.dismiss(animated: true) {
                self.contex.player?.play()
                self.contex.startCounterTimer()
            }
        }
        if lifeLine == "call"{
            self.dismiss(animated: true) {
                self.contex.player?.play()
                self.contex.startCounterTimer()
            }
        }

    }
    @IBAction func onClickYes(_ sender: Any) {
        MainVIew.isHidden = true
        if lifeLine == "Audience"{
            //            contex.player?.play()
            contex.AudienceView.backgroundColor = ColorConstant.red500
            contex.btnAudienceLifeline.isEnabled = false
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idAudienceLifeLineVC")as! AudienceLifeLineVC
            nextVC.currectAnswer2 = currectAnswer
            nextVC.ArrList =  ArrList
            nextVC.contex = self
            nextVC.item = item
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }
        if lifeLine == "FlipFlop"{
            self.contex.countDownTimer = 61
            self.dismiss(animated: true) {
                self.contex.flipFlopView.backgroundColor = ColorConstant.red500
                self.contex.btnFlipLifeline.isEnabled = false
                //            contex.index = 15
                self.contex.flipflag = true
                self.contex.index = 15
                self.contex.startCounterTimer()
                self.contex.player?.play()
            }
        }
        if lifeLine == "5050"{
            contex.lifeLine5050View.backgroundColor = ColorConstant.red500
            contex.fistTimeChange = false
            contex.lifeLineData = true
            self.contex.player?.play()
            self.contex.startCounterTimer()
            self.dismiss(animated: true, completion: nil)
        }else if lifeLine == "call"{
            contex.callFriendView.backgroundColor = ColorConstant.red500
            contex.callfirstTimeChange = false
            contex.calldata = true
            contex.addTimeLifeline()
//            contex.countDownTimer =
            self.contex.player?.play()
            self.contex.startCounterTimer()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
