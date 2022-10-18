//
//  AudienceLifeLineVC.swift
//  Finca
//
//  Created by Jay Patel on 13/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class AudienceLifeLineVC: BaseVC {
    var timer = Timer()
    var countDown = 5
    var currectAnswer2 = ""
    var ArrList : Question!
    var item : Game!
    var contex: GameDialogVC!
    @IBOutlet var heightOfOptionA: NSLayoutConstraint!
    @IBOutlet var heightOfOptionB: NSLayoutConstraint!
    @IBOutlet var heightOfOptionC: NSLayoutConstraint!
    @IBOutlet var heightOfOptionD: NSLayoutConstraint!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet var lblPercentageOptionA: UILabel!
    @IBOutlet var lblPercentageOptionB: UILabel!
    @IBOutlet var lblPercentageOptionC: UILabel!
    @IBOutlet var lblPercentageOptionD: UILabel!
    
    @IBOutlet var optionViewA: UIView!
    @IBOutlet var optionViewB: UIView!
    @IBOutlet var optionViewC: UIView!
    @IBOutlet var optionViewD: UIView!
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet var imgGIF: UIImageView!
    @IBOutlet var subView: UIView!
    @IBOutlet var GIFView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFView.isHidden = true
        btnOK.isHidden = true
//        imgGIF.image("audience_poll")
        imgGIF.loadGif(name: "audience_poll")
        subView.backgroundColor = .black
        subView.alpha = 0.75
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
        doCheckOptionPoll()
        print("currectAnswer2---",currectAnswer2)
        btnOk.setTitle(doGetValueLanguage(forKey: "ok"), for: .normal)
       
    }
    func doCheckOptionPoll(){
        if currectAnswer2 == "1"{
            lblPercentageOptionA.text = "52 %"
            heightOfOptionA.constant = 110
            
            lblPercentageOptionB.text = "7 %"
            heightOfOptionB.constant = 30
            
            lblPercentageOptionC.text = "17 %"
            heightOfOptionC.constant = 55
            
            lblPercentageOptionD.text = "24 %"
            heightOfOptionD.constant = 70
        }
        if currectAnswer2 == "2"{
            lblPercentageOptionA.text = "0 %"
            heightOfOptionA.constant = 0
            
            lblPercentageOptionB.text = "89 %"
            heightOfOptionB.constant = 125
            
            lblPercentageOptionC.text = "3 %"
            heightOfOptionC.constant = 15
            
            lblPercentageOptionD.text = "8 %"
            heightOfOptionD.constant = 33
        }
        if currectAnswer2 == "3"{
            lblPercentageOptionA.text = "14 %"
            heightOfOptionA.constant = 45
            
            lblPercentageOptionB.text = "1 %"
            heightOfOptionB.constant = 5
            
            lblPercentageOptionC.text = "74 %"
            heightOfOptionC.constant = 115
            
            lblPercentageOptionD.text = "11 %"
            heightOfOptionD.constant = 20
        }
        if currectAnswer2 == "4"{
            lblPercentageOptionA.text = "26 %"
            heightOfOptionA.constant = 92
            
            lblPercentageOptionB.text = "18 %"
            heightOfOptionB.constant = 65
            
            lblPercentageOptionC.text = "21 %"
            heightOfOptionC.constant = 80
            
            lblPercentageOptionD.text = "35 %"
            heightOfOptionD.constant = 120
        }
    }
    
    @IBAction func btnOK(_ sender: Any) {
        self.dismiss(animated: true) {
            self.contex.contex.player?.play()
            self.contex.dismiss(animated: true, completion: nil)
        }
    }
    @objc func countDownMethod(){
        if countDown == 1{
            GIFView.isHidden = false
            GIFView.backgroundColor = UIColor(named: "colorNoti")?.withAlphaComponent(0.75)
            imgGIF.isHidden = true
            btnOK.isHidden = false
        }
        countDown -= 1
    }
    
}
