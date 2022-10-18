//
//  GeneralKnowledgeGameVC.swift
//  Finca
//
//  Created by Jay Patel on 07/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
import KCCircularTimer
import AVFoundation
import Contacts
import ContactsUI

struct GeneralKnowledgeGameResponse: Codable {
    let question: [Question]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case question = "question"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Question
struct Question: Codable {
    let kbgQuestionID: String!
    let kbgGameID: String!
    let societyID: String!
    let kbgQuestion: String!
    let kbgOption1: String!
    let kbgOption2: String!
    let kbgOption3: String!
    let kbgOption4: String!
    let currectAnswer: String!
    let winPoint: String!
    let winPointView : String!
    var isShowPoint: Bool!
    
    enum CodingKeys: String, CodingKey {
        case winPointView = "win_point_view"
        case kbgQuestionID = "kbg_question_id"
        case kbgGameID = "kbg_game_id"
        case societyID = "society_id"
        case kbgQuestion = "kbg_question"
        case kbgOption1 = "kbg_option_1"
        case kbgOption2 = "kbg_option_2"
        case kbgOption3 = "kbg_option_3"
        case kbgOption4 = "kbg_option_4"
        case currectAnswer = "currect_answer"
        case winPoint = "win_point"
        case isShowPoint = "isShowPoint"
    }
}
class GeneralKnowledgeGameVC: BaseVC, CNContactViewControllerDelegate {
    // var delegate : BaseVC!
    var countDown = 5
    var ArrList = [Question]()
    var timer = Timer()
    var countDownTimer = 60
    var timerIsPaused = true
    var isCheck = false
    var isRight = false
    var option : String!
    var lifeLineData = false
    var calldata = false
    var currentQueID: String!
    var priceList = [Question]()
    var player: AVAudioPlayer?
    var item : Game!
    var lifeLine : String!
    var flipIndex : Int!
    var flipflag = false
    var originalIndex = 0
    var index = 0{
        didSet{
            player?.stop()
            print("didset index---",self.index)
            playSound(forResource: "kbg_60_sec_countdown")

            self.lblOptionA.text = self.ArrList[self.index].kbgOption1
            self.optionSubViewA.backgroundColor = UIColor.white.withAlphaComponent(0.60)
            self.lblOptionB.text = self.ArrList[self.index].kbgOption2
            self.optionSubViewB.backgroundColor = UIColor.white.withAlphaComponent(0.60)
            self.lblOptionC.text = self.ArrList[self.index].kbgOption3
            self.optionSubViewC.backgroundColor = UIColor.white.withAlphaComponent(0.60)
            self.lblOptionD.text = self.ArrList[self.index].kbgOption4
            self.optionSubViewD.backgroundColor = UIColor.white.withAlphaComponent(0.60)
            self.lblQuestion.text = self.ArrList[self.index].kbgQuestion

            
            if lifeLineData == false{
                optionViewB.isHidden = false
                optionViewA.isHidden = false
                optionViewC.isHidden = false
                optionViewD.isHidden = false
            }
            
            if self.calldata == false{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.myOrientation = .landscape
                let value = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }


            self.lblCurrentQue.text = "\(self.index + 1) / \(ArrList.count - 1)"
            if flipflag {
                self.tbvPriceList.scrollToRow(at: IndexPath(row: ((self.priceList.count - 1) - self.flipIndex), section: 0), at: .bottom, animated: true)
                let cell = self.tbvPriceList.cellForRow(at: IndexPath(row: ((self.priceList.count - 1) - self.flipIndex) , section: 0)) as! GenerealKnowledgePriceListCell
                cell.viewbackground.isHidden = false
                

            }else{
                self.tbvPriceList.scrollToRow(at: IndexPath(row: ((self.priceList.count - 1) - self.index), section: 0), at: .bottom, animated: true)
                let cell = self.tbvPriceList.cellForRow(at: IndexPath(row: ((self.priceList.count - 1) - self.index) , section: 0)) as! GenerealKnowledgePriceListCell
                cell.viewbackground.isHidden = false
            }
            self.tbvPriceList.reloadData()
            self.progressAnimation(duration: 61)
        }
    }
    @IBOutlet weak var viewLifelineContainer: UIView!
    var fistTimeChange = true
    var callfirstTimeChange = true
    var newIndex = 0
    var pointsWon = 0
    let itemCell = "GenerealKnowledgePriceListCell"
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var circularView = ProgressViewTimer()
    var duration: TimeInterval!
    @IBOutlet var countDownView: UIView!
    let screenwidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    @IBOutlet var flipFlopView: UIView!
    @IBOutlet var callFriendView: UIView!
    @IBOutlet var AudienceView: UIView!
    @IBOutlet var lifeLine5050View: UIView!
    
    
    @IBOutlet var btnFlipLifeline: UIButton!
    @IBOutlet var btnCallLifeline: UIButton!
    @IBOutlet var btnAudienceLifeline: UIButton!
    @IBOutlet var btn5050Lifeline: UIButton!
    
    @IBOutlet var lblCurrentQue: UILabel!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var topOfOptionC: NSLayoutConstraint!
    @IBOutlet var heightOfOptionA: NSLayoutConstraint!
    
    @IBOutlet var lblCountDownTimer: UILabel!
    @IBOutlet var optionViewA: UIView!
    @IBOutlet var optionViewB: UIView!
    @IBOutlet var optionViewC: UIView!
    @IBOutlet var optionViewD: UIView!
    
    @IBOutlet var lblOptionA: UILabel!
    @IBOutlet var lblOptionB: UILabel!
    @IBOutlet var lblOptionC: UILabel!
    @IBOutlet var lblOptionD: UILabel!
    
    @IBOutlet var optionSubViewA: UIView!
    @IBOutlet var optionSubViewB: UIView!
    @IBOutlet var optionSubViewC: UIView!
    @IBOutlet var optionSubViewD: UIView!
    
    @IBOutlet weak var viewQuestionContainer: UIView!
    @IBOutlet var tbvPriceList: UITableView!
    @IBOutlet var lblContdown: UILabel!
    @IBOutlet var questionNumberView: UIView!
    @IBOutlet var secondCountDownView: UIView!
    @IBOutlet var timerView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgPlayerPic: UIImageView!
    @IBOutlet weak var lblGameStartIn: UILabel!
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let circleLayer = CAShapeLayer()
        //        let progressLayer = CAShapeLayer()
        
        
        
        //        circularView.accessibilityFrame = CGRect(x: 0, y: 0, width: 80, height: 80)
        //        duration = 60    //Play with whatever value you want :]
        //        circularView.progressAnimation(duration: duration)
        //        timerView.addSubview(circularView)
        CountDown60Second()
//        secondCountDownView.isHidden = true
//        countDownView.isHidden = true
        
        tbvPriceList.isUserInteractionEnabled = false
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvPriceList.register(nib, forCellReuseIdentifier: itemCell)
        tbvPriceList.delegate = self
        tbvPriceList.dataSource = self
        questionNumberView.cornerRadius = 15
        lblContdown.text = "\(countDown)"
        print(countDown)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startingCountDownMethod), userInfo: nil, repeats: true)
        
        doCallGetQuestionsApi()
        self.viewQuestionContainer.viewRoundCorners(defaultDiameter: 10)
        self.viewLifelineContainer.viewRoundCorners()
        self.lblUserName.text = "\(doGetLocalDataUser().userFullName!) (\(doGetLocalDataUser().blockName!)-\(doGetLocalDataUser().unitName!))"
        Utils.setImageFromUrl(imageView: self.imgPlayerPic, urlString: doGetLocalDataUser().userProfilePic!, palceHolder: "user_default")
        lblGameStartIn.text = doGetValueLanguage(forKey: "game_start_in")
    }

    func startCounterTimer(){

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
    }

    func CountDown60Second(){
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: timerView.frame.size.width / 2.0 - 1, y: timerView.frame.size.height / 2.0), radius: timerView.frame.size.width / 2.0, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 3.0
//        circleLayer.strokeStart = 15
        circleLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = 5
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor(named: "ColorPrimary")?.cgColor
        timerView.layer.addSublayer(circleLayer)
        timerView.layer.addSublayer(progressLayer)
    }

    func progressAnimation(duration: TimeInterval) {
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .removed
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }

    override func viewWillAppear(_ animated: Bool) {
        if timerIsPaused == false{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
            timerIsPaused = true
        }
        print("flipIndex---",flipIndex as Any)
        if flipIndex == nil{
            lblCurrentQue.text = "\(String(index + 1)) / \(ArrList.count - 1)"
            print("index--",index)
        }else{
            lblCurrentQue.text = "\(String(flipIndex + 1)) / \(ArrList.count - 1)"
            index = flipIndex
            print("index---",index)
            flipIndex = nil
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

    }
    
    override func viewWillLayoutSubviews() {
        if lifeLineData == true{
            lifeLineData = false
            
            if ArrList[index].currectAnswer == "1"{
                optionViewB.isHidden = true
                optionViewC.isHidden = true
                optionViewA.isHidden = false
                optionViewD.isHidden = false
            }
            if ArrList[index].currectAnswer == "2"{
                optionViewD.isHidden = true
                optionViewC.isHidden = true
                optionViewA.isHidden = false
                optionViewB.isHidden = false
            }
            if ArrList[index].currectAnswer == "3"{
                optionViewB.isHidden = true
                optionViewA.isHidden = true
                optionViewC.isHidden = false
                optionViewD.isHidden = false
            }
            if ArrList[index].currectAnswer == "4"{
                optionViewB.isHidden = true
                optionViewC.isHidden = true
                optionViewA.isHidden = false
                optionViewD.isHidden = false
            }
        }
    }

    func checkOption(){
        print(isCheck)
        if isCheck == true{
            if isRight == true{
                //                setCheckResult()
                if option == "1"{
                    optionSubViewA.backgroundColor = ColorConstant.green500
                    optionSubViewA.alpha = 1
                }
                if option == "2"{
                    optionSubViewB.backgroundColor = ColorConstant.green500
                    optionSubViewB.alpha = 1
                }
                if option == "3"{
                    optionSubViewC.backgroundColor = ColorConstant.green500
                    optionSubViewC.alpha = 1
                }
                if option == "4"{
                    optionSubViewD.backgroundColor = ColorConstant.green500
                    optionSubViewD.alpha = 1
                }
                
            }else{
                if option == "1"{
                    optionSubViewA.backgroundColor = ColorConstant.red500
                    optionSubViewA.alpha = 1
                }
                if option == "2"{
                    optionSubViewB.backgroundColor = ColorConstant.red500
                    optionSubViewB.alpha = 1
                }
                if option == "3"{
                    optionSubViewC.backgroundColor = ColorConstant.red500
                    optionSubViewC.alpha = 1
                }
                if option == "4"{
                    optionSubViewD.backgroundColor = ColorConstant.red500
                    optionSubViewD.alpha = 1
                }
            }
        }else{
            
        }
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }

    @objc func startingCountDownMethod(){
        if countDown == 1{
            playSound(forResource: "kbg_60_sec_countdown")
            
            //60 second timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
            
            //60 second progressbar
            progressAnimation(duration: 60)
            
            secondCountDownView.isHidden = true
            self.tbvPriceList.isUserInteractionEnabled = true
            countDownView.isHidden = true

        }
        
        countDown -= 1
        lblContdown.text = "\(countDown)"
    }
    
    @objc func countDownMethod(){
        //        timerIsPaused = false
        if countDownTimer <= 1{
            timer.invalidate()
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSubmitAndExitPopUPVC")as! SubmitAndExitPopUPVC
            self.player?.pause()
            self.timer.invalidate()
            self.timerIsPaused = false
            nextVC.questionData = self.ArrList[index]
            nextVC.context = self
            nextVC.flag = doGetValueLanguage(forKey: "time_over")
            nextVC.pointswon = "\(self.pointsWon)"
            nextVC.context = self
            nextVC.questionData = ArrList[index]
            let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.4
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            self.present(popupVC, animated: true)

            
        }
        if countDownTimer == 50{
            
            //            circularProgressAnimation.speed = 0.0
        }
        countDownTimer -= 1
        lblCountDownTimer.text = "\(countDownTimer)"
    }

    func addTimeLifeline(){
        self.countDownTimer = self.countDownTimer + 180
        self.progressAnimation(duration: TimeInterval(self.countDownTimer))

    }
    
    @IBAction func btnBack(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let nextVC = storyboardConstants.kbg.instantiateViewController(withIdentifier: "idExitDialogVC")as! ExitDialogVC
        nextVC.delegate = self
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func btnFlipLifeline(_ sender: Any) {

        flipIndex = index
        player?.pause()
        timer.invalidate()
        timerIsPaused = false
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameDialogVC")as! GameDialogVC
        nextVC.currectAnswer = ArrList[index].currectAnswer
        nextVC.lifeLine = "FlipFlop"
        nextVC.contex = self
        nextVC.item = item
        nextVC.ArrList =  ArrList[index]
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func btnCallLifeline(_ sender: Any) {
        if callfirstTimeChange {
            player?.pause()
            timer.invalidate()
            timerIsPaused = false
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idGameDialogVC")as! GameDialogVC
            vc.lifeLine = "call"
            vc.contex = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.4
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }else{
            print("use")
        }
    }
    @IBAction func btnAudienceLifeline(_ sender: Any) {
//        player?.pause()
//        timer.invalidate()
//        timerIsPaused = false
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGameDialogVC")as! GameDialogVC
        nextVC.lifeLine = "Audience"
        nextVC.contex = self
        if self.flipflag == true{
            nextVC.currectAnswer = ArrList[newIndex].currectAnswer
        }else{
            nextVC.currectAnswer = ArrList[index].currectAnswer

        }
        nextVC.item = item
        nextVC.ArrList =  ArrList[index]
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
        
    }
    @IBAction func btn5050Lifeline(_ sender: Any) {
        if fistTimeChange {
            player?.pause()
            timer.invalidate()
            timerIsPaused = false
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idGameDialogVC")as! GameDialogVC
            vc.lifeLine = "5050"
            vc.contex = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.4
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }else{
            print("use")
        }
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
            //            player.numberOfLoops = 5
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func doSetScreen() {
        appDel.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
        
        
    }
    func doCallGetQuestionsApi(){
        //        self.showProgress()
        let unitName = doGetLocalDataUser().blockName! + "-" + doGetLocalDataUser().unitName!
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getKbgQuestion":"getKbgQuestion",
                      "society_id":doGetLocalDataUser().societyID!,
                      "kbg_game_id":item.kbgGameId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_name":unitName,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_mobile":doGetLocalDataUser().userMobile!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: "kbg_controller.php", parameters: params) { (json, error) in
            //            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(GeneralKnowledgeGameResponse.self, from:json!)
                    if response.status == "200" {
                        self.ArrList = response.question
                        self.priceList = response.question

                        print("cell height =====" , (self.tbvPriceList.frame.size.height / CGFloat(self.priceList.count)) + 5  )
                        //                        for (index,_) in self.priceList.enumerated(){
                        //                            self.priceList[index].isShowPoint = false
                        //                            //                            self.priceList[self.newIndex].isShowPoint = true
                        //                        }
                        
                        self.priceList.reverse()
                        self.priceList.remove(at: 0)
                        
                        self.lblOptionA.text = self.ArrList[self.index].kbgOption1
                        self.lblOptionB.text = self.ArrList[self.index].kbgOption2
                        self.lblOptionC.text = self.ArrList[self.index].kbgOption3
                        self.lblOptionD.text = self.ArrList[self.index].kbgOption4
                        self.lblQuestion.text = self.ArrList[self.index].kbgQuestion
                        self.tbvPriceList.reloadData()
                        self.lblCurrentQue.text = "\(String(self.index + 1)) / \(self.ArrList.count - 1)"

                        self.tbvPriceList.scrollToRow(at: IndexPath(row: self.priceList.count - 1, section: 0), at: .bottom, animated: true)
                    }else {
                        
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    override func onClickDone() {
      self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOptionA(_ sender: Any) {
        originalIndex = index
        print("current index Variable:",self.index)
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSelectedOptionDialogVC")as! SelectedOptionDialogVC
        nextVC.delegate = self
        nextVC.optionName = .A
        self.optionSubViewA.backgroundColor = UIColor(named: "orange_700")?.withAlphaComponent(0.75)
        self.optionSubViewB.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewC.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewD.backgroundColor = UIColor.white.withAlphaComponent(0.60)

        if self.flipflag == true{
            nextVC.questionIndex = 15
        }else{
            nextVC.questionIndex = self.index
        }

        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func btnOptionB(_ sender: Any) {
        originalIndex = index
        print("current index Variable:",self.index)
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSelectedOptionDialogVC")as! SelectedOptionDialogVC
        nextVC.delegate = self
        nextVC.optionName = .B
        self.optionSubViewA.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewB.backgroundColor = UIColor(named: "orange_700")?.withAlphaComponent(0.75)
        self.optionSubViewC.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewD.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        if self.flipflag == true{
            nextVC.questionIndex = 15
        }else{
            nextVC.questionIndex = self.index
        }
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func btnOptionC(_ sender: Any) {
        originalIndex = index
        print("current index Variable:",self.index)
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSelectedOptionDialogVC")as! SelectedOptionDialogVC
        nextVC.delegate = self
        nextVC.optionName = .C

        if self.flipflag == true{
            nextVC.questionIndex = 15
        }else{
            nextVC.questionIndex = self.index
        }
        self.optionSubViewA.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewB.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewC.backgroundColor = UIColor(named: "orange_700")?.withAlphaComponent(0.75)
        self.optionSubViewD.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func btnOptionD(_ sender: Any) {

        originalIndex = index
        print("current index Variable:",self.index)
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSelectedOptionDialogVC")as! SelectedOptionDialogVC
        nextVC.delegate = self
        nextVC.optionName = .D
        if self.flipflag == true{
            nextVC.questionIndex = 15
        }else{
            nextVC.questionIndex = self.index
        }
        self.optionSubViewA.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewB.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewC.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        self.optionSubViewD.backgroundColor = UIColor(named: "orange_700")?.withAlphaComponent(0.75)
        let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    func setNameAndNumber(number : String) {
        if let phoneCallURL = URL(string: number) {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
}


extension GeneralKnowledgeGameVC : SelectedOptionDialogDelegate , greetingsDialogDelegate, ExitDialogDelegate{

    func btnAgreeClickedOnExit() {
        self.dismiss(animated: true) {
            self.player?.stop()

            if self.pointsWon == 0{
                self.navigationController?.popViewController(animated: true)
            }else{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSubmitAndExitPopUPVC")as! SubmitAndExitPopUPVC
                nextVC.context = self
                nextVC.questionData = self.ArrList[self.index]
                nextVC.flag = self.doGetValueLanguage(forKey: "exit_the_game")
                nextVC.pointswon = String(self.pointsWon)
                nextVC.item = self.item!
                let popupVC = PopupViewController(contentController:nextVC , popupWidth: self.screenwidth  , popupHeight: self.screenheight)
                popupVC.backgroundAlpha = 0.4
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = true
                self.present(popupVC, animated: true)
            }
        }
    }

    func btnCancelClickedOnExit() {
        self.dismiss(animated: true, completion: nil)
    }

    func btnAgreeClicked(optionName: OptionName!, QuestionIndex: Int!, dialogContext: GreetingsDialogVC!) {
        dialogContext.dismiss(animated: true) {
            switch optionName {
            case .A:
                self.optionSubViewA.backgroundColor = UIColor(named: "orange_700")
            case .B:
                self.optionSubViewB.backgroundColor = UIColor(named: "orange_700")
            case .C:
                self.optionSubViewC.backgroundColor = UIColor(named: "orange_700")
            case .D:
                self.optionSubViewD.backgroundColor = UIColor(named: "orange_700")
            default:
                break
            }
            if self.flipflag {
                self.pointsWon = Int(self.ArrList[self.flipIndex].winPoint)!
            }else{
                self.pointsWon = Int(self.ArrList[self.index].winPoint)!
            }
            print("total point won ------------------ ", self.pointsWon)
            if String(self.pointsWon) == self.priceList[0].winPoint{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idSubmitAndExitPopUPVC")as! SubmitAndExitPopUPVC

                self.player?.pause()
                self.timer.invalidate()
                self.timerIsPaused = false
                nextVC.context = self
                nextVC.questionData = self.ArrList[self.index]
                nextVC.flag = self.doGetValueLanguage(forKey: "winner")
                nextVC.pointswon = String(self.pointsWon)
                nextVC.item = self.item!
                let popupVC = PopupViewController(contentController:nextVC , popupWidth: self.screenwidth  , popupHeight: self.screenheight)
                popupVC.backgroundAlpha = 0.4
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = true
                self.present(popupVC, animated: true)
            }else{
                if self.flipflag == true{
                    print("flip Index",self.flipIndex!)
                    self.countDownTimer = 60
                    self.index = self.flipIndex + 1

                    self.flipflag = false
                }else{
                    self.countDownTimer = 60
                    self.index = QuestionIndex + 1
                }
            }
        }
    }

    func yesButtonClicked(optionName: OptionName!, QuestionIndex: Int!, dialogContext: SelectedOptionDialogVC!) {
        dialogContext.dismiss(animated: true){
            self.player?.stop()
            print("question index",QuestionIndex!)
            if self.ArrList[QuestionIndex].currectAnswer == optionName.rawValue{
                var point = ""
                if self.flipflag{
                    point = self.ArrList[self.flipIndex].winPoint!
                }else{
                    point = self.ArrList[self.index].winPoint!
                }
                switch optionName {
                case .A:
                    self.optionSubViewA.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                case .B:
                    self.optionSubViewB.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                case .C:
                    self.optionSubViewC.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                case .D:
                    self.optionSubViewD.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                default:
                    break
                }
                let nextVC = storyboardConstants.kbg
                    .instantiateViewController(withIdentifier: "idGreetingsDialogVC")as! GreetingsDialogVC
                nextVC.delegate = self
                nextVC.optionName = optionName
                nextVC.questionIndex = QuestionIndex
                nextVC.pointsWon = point
                let popupVC = PopupViewController(contentController:nextVC , popupWidth: self.screenwidth  , popupHeight: self.screenheight)
                popupVC.backgroundAlpha = 0.4
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = true
                self.present(popupVC, animated: true)

            }else{

                switch optionName {
                case .A:
                    self.optionSubViewA.backgroundColor = UIColor(named: "red_a700")!.withAlphaComponent(0.7)
                case .B:
                    self.optionSubViewB.backgroundColor = UIColor(named: "red_a700")!.withAlphaComponent(0.7)
                case .C:
                    self.optionSubViewC.backgroundColor = UIColor(named: "red_a700")!.withAlphaComponent(0.7)
                case .D:
                    self.optionSubViewD.backgroundColor = UIColor(named: "red_a700")!.withAlphaComponent(0.7)
                default:
                    break
                }

                switch self.ArrList[QuestionIndex].currectAnswer.lowercased(){
                case "1":
                    self.optionSubViewA.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                    break;
                case "2":
                    self.optionSubViewB.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                    break;
                case "3":
                    self.optionSubViewC.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                    break;
                case "4":
                    self.optionSubViewD.backgroundColor = UIColor(named: "green 500")!.withAlphaComponent(0.7)
                    break;
                default:
                    break
                }

                let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitAndExitPopUPVC")as! SubmitAndExitPopUPVC
                vc.flag = self.doGetValueLanguage(forKey: "oops_your_answer_is_wrong")
                self.player?.pause()
                self.timer.invalidate()
                self.timerIsPaused = false
                vc.questionData = self.ArrList[self.index]
                vc.pointswon = String(self.pointsWon)
                vc.item = self.item!
                vc.context = self
                let popupVC = PopupViewController(contentController:vc , popupWidth: self.screenwidth  , popupHeight: self.screenheight)
                popupVC.backgroundAlpha = 0.4
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = true
                self.present(popupVC, animated: true)
            }
        }
    }
    
    func noButtonClicked(optionName: OptionName, QuestionIndex: Int, dialogContext: SelectedOptionDialogVC!) {
//        switch optionName {
//        case .A:
//            self.optionSubViewA.backgroundColor = UIColor.white.withAlphaComponent(0.60)
//        case .B:
//            self.optionSubViewB.backgroundColor = UIColor.white.withAlphaComponent(0.60)
//        case .C:
//            self.optionSubViewC.backgroundColor = UIColor.white.withAlphaComponent(0.60)
//        case .D:
//            self.optionSubViewD.backgroundColor = UIColor.white.withAlphaComponent(0.60)
//        }
        self.dismiss(animated: true, completion: nil)
    }
}


extension GeneralKnowledgeGameVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvPriceList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! GenerealKnowledgePriceListCell

        cell.lblPrice.text = priceList[indexPath.row].winPointView

        if indexPath.row == ((self.priceList.count - 1) - self.index) {
            cell.viewbackground.isHidden = false
        }else{
            cell.viewbackground.isHidden = true
        }
        //        print("hahaha",priceList[newIndex].isShowPoint)
        //        if priceList[indexPath.row].isShowPoint == true{
        //            cell.lblPrice.backgroundColor = ColorConstant.green500
        //        }else{
        //            cell.lblPrice.backgroundColor = ColorConstant.primaryColor
        //        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let height : CGFloat  = self.tbvPriceList.frame.size.height / CGFloat(priceList.count)
        return height + 10

    }
}


extension GeneralKnowledgeGameVC : CNContactPickerDelegate
{
    func onClickPickContact(){
        
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        doSetScreen()
        self.present(contactPicker, animated: true, completion: nil)
        
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user name
       // let userName:String = contact.givenName + " " + contact.middleName + " " + contact.familyName
        
        // user phone number
        
        var number = ""
        if contact.phoneNumbers.count >  0  {
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            // user phone number string
            number = firstPhoneNumber.stringValue
        }
        
        var conatct = ""
        
        if number.contains("+") {
            conatct = String(number.dropFirst(3))
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        } else if number.contains("-") {
            conatct = number.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            conatct = conatct.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }else {
            conatct = number.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
        doCall(on: conatct)
        self.calldata = false
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
        
    }
}

extension CALayer
{
    func pauseAnimation() {
        if isPaused() == false {
            let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }
    
    func resumeAnimation() {
        if isPaused() {
            let pausedTime = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            beginTime = timeSincePause
        }
    }
    
    func isPaused() -> Bool {
        return speed == 0
    }
}

extension UIView{
    func viewRoundCorners(defaultDiameter diameter : CGFloat! = nil) {
        if diameter == nil{
            self.layer.cornerRadius = self.frame.size.height / 2
        }else{
            self.layer.cornerRadius = diameter
        }
    }
}
