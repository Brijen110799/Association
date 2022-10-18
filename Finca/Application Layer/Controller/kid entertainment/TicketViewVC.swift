//
//  TicketViewVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import AVFoundation
import EzPopup
import MarqueeLabel
struct GameResponse : Codable {
    let status : String! //" : "203",
    let message : String! //" : "Game Over at 2020-04-20 14:10"
    let  timer_interval : String! //" : "15",
    let  game_start_time : String! //" : "2020-04-20 15:00:00",
    let  stage_ticket_ans : String! //" : "15",
    let  current_time : String! //" : "2020-04-20 14:59:28",
    let  game_end_time : String! //" : "2020-04-20 15:10",
    let totalGameInSecond  :String! //" : "600",
    let room_id  :String! //" : "3",
    let remaningTimeInSecond  :String! //" : "32"
    let questionAnswerFlag  :String!
    let questionCounter  :String!
    let ticketView : [TicketView]!
    let question : [QuestionModel]!
    //for joiynt user list
     let joinUsers : [JoitnsUserModel]!
}
struct QuestionModel : Codable {
    let answer : String! //" : "answer 1",
    let que_id : String! //" : "41",
    let question : String! //" : "Question 1 ?"
}
struct TicketView : Codable {
    let answer : String! //" : "Answer 11"
}
struct JoitnsUserModel : Codable {
    let user_id : String! //" : "answer 1",
    let user_name : String! //" : "41",
    let user_points : String! //" : "Question 1 ?"
    let gender : String! //" : "Question 1 ?"
    let user_profile : String! //" : "Question 1 ?"
}
    class TicketViewVC: BaseVC {
        var selectedItem : ItemGame!
    //for row one
    @IBOutlet weak var lbRowOneOne: UILabel!
    @IBOutlet weak var lbRowOneTwo: UILabel!
    @IBOutlet weak var lbRowOneThree: UILabel!
    @IBOutlet weak var lbRowOneFour: UILabel!
    @IBOutlet weak var IvRowOneOne: UIImageView!
    @IBOutlet weak var IvRowOneTwo: UIImageView!
    @IBOutlet weak var IvRowOneThree: UIImageView!
    @IBOutlet weak var IvRowOneFour: UIImageView!
    @IBOutlet weak var viewRowOneOne: UIView!
    @IBOutlet weak var viewRowOneTwo: UIView!
    @IBOutlet weak var viewRowOneThree: UIView!
    @IBOutlet weak var viewRowOneFour: UIView!
    
    //for row two
    @IBOutlet weak var lbRowTwoOne: UILabel!
    @IBOutlet weak var lbRowTwoTwo: UILabel!
    @IBOutlet weak var lbRowTwoThree: UILabel!
    @IBOutlet weak var lbRowTwoFour: UILabel!
    @IBOutlet weak var IvRowTwoOne: UIImageView!
    @IBOutlet weak var IvRowTwoTwo: UIImageView!
    @IBOutlet weak var IvRowTwoThree: UIImageView!
    @IBOutlet weak var IvRowTwoFour: UIImageView!
    @IBOutlet weak var viewRowTwoOne: UIView!
    @IBOutlet weak var viewRowTwoTwo: UIView!
    @IBOutlet weak var viewRowTwoThree: UIView!
    @IBOutlet weak var viewRowTwoFour: UIView!
    //for row three
    @IBOutlet weak var lbRowThreeOne: UILabel!
    @IBOutlet weak var lbRowThreeTwo: UILabel!
    @IBOutlet weak var lbRowThreeThree: UILabel!
    @IBOutlet weak var lbRowThreeFour: UILabel!
    
    @IBOutlet weak var IvRowThreeOne: UIImageView!
    @IBOutlet weak var IvRowThreeTwo: UIImageView!
    @IBOutlet weak var IvRowThreeThree: UIImageView!
    @IBOutlet weak var IvRowThreeFour: UIImageView!
    @IBOutlet weak var viewRowThreeOne: UIView!
    @IBOutlet weak var viewRowThreeTwo: UIView!
    @IBOutlet weak var viewRowThreeThree: UIView!
    @IBOutlet weak var viewRowThreeFour: UIView!
    
    //for row four
    @IBOutlet weak var lbRowFourOne: UILabel!
    @IBOutlet weak var lbRowFourTwo: UILabel!
    @IBOutlet weak var lbRowFourThree: UILabel!
    @IBOutlet weak var lbRowFourFour: UILabel!
    @IBOutlet weak var IvRowFourOne: UIImageView!
    @IBOutlet weak var IvRowFourTwo: UIImageView!
    @IBOutlet weak var IvRowFourThree: UIImageView!
    @IBOutlet weak var IvRowFourFour: UIImageView!
    @IBOutlet weak var viewRowFourOne: UIView!
    @IBOutlet weak var viewRowFourTwo: UIView!
    @IBOutlet weak var viewRowFourThree: UIView!
    @IBOutlet weak var viewRowFourFour: UIView!
    //for row five
    @IBOutlet weak var lbRowFiveOne: UILabel!
    @IBOutlet weak var lbRowFiveTwo: UILabel!
    @IBOutlet weak var lbRowFiveThree: UILabel!
    @IBOutlet weak var lbRowFiveFour: UILabel!
    @IBOutlet weak var IvRowFiveOne: UIImageView!
    @IBOutlet weak var IvRowFiveTwo: UIImageView!
    @IBOutlet weak var IvRowFiveThree: UIImageView!
    @IBOutlet weak var IvRowFiveFour: UIImageView!
    @IBOutlet weak var viewRowFiveOne: UIView!
    @IBOutlet weak var viewRowFiveTwo: UIView!
    @IBOutlet weak var viewRowFiveThree: UIView!
    @IBOutlet weak var viewRowFiveFour: UIView!
    @IBOutlet weak var lbTotalTimer: UILabel!
    @IBOutlet weak var lbQuestions: UILabel!
    @IBOutlet weak var lbNofQuation: UILabel!
    @IBOutlet weak var lbTimeConter: UILabel!
    @IBOutlet weak var circleProgress: CircularSlider!
    @IBOutlet weak var tbvUserList: UITableView!
    @IBOutlet weak var viewDisble: UIView!
    @IBOutlet weak var lbNoOfPlyaer: UILabel!
    @IBOutlet weak var leadingConUserList: NSLayoutConstraint!
    @IBOutlet weak var viewUserList: UIView!
        @IBOutlet weak var lblPlayersTitle: UILabel!
        @IBOutlet weak var lblTicketWillBeEnabled: UILabel!
        @IBOutlet weak var lblClaim: UILabel!
        let GAME_NOT_STARTED = "204"
    let GAME_OVER = "203"
    let GAME_WILL_START = "201"
    let GAME_IS_STARTED = "200"
    var rowOneArray = [String]()
    var rowTwoArray = [String]()
    var rowThreeArray = [String]()
    var rowFourArray = [String]()
    var rowFiveArray = [String]()
    var ticketView = [TicketView]()
    var question = [QuestionModel]()
    var counter = 0
    var isLoadTiecket = false
    var totalGameInSecond = ""
    var timerTotalGame : Timer!
    var quationCounter = 0
    var timerForQuetions:Timer!
    var quation = "Hello World !!!"
    var isLoadAns = true
    var anserCounter = 0
    var loadQution = true
    var timerAnserSever = 0
    var sheetController : SheetViewController!
    var isClickRowOneOne = true , isClickRowOneTwo = true , isClickRowOneThree = true ,isClickRowOneFour = true
    var isClickRowTwoOne = true , isClickRowTwoTwo = true , isClickRowTwoThree = true ,isClickRowTwoFour = true
    var isClickRowThreeOne = true , isClickRowThreeTwo = true , isClickRowThreeThree = true ,isClickRowThreeFour = true
    var isClickRowFourOne = true , isClickRowFourTwo = true , isClickRowFourThree = true ,isClickRowFourFour = true
    var isClickRowFiveOne = true , isClickRowFiveTwo = true , isClickRowFiveThree = true ,isClickRowFiveFour = true
    var clickCount = 0
    var fistTwoLine = 0
    var middleLine = 0
    var lastTwoLine = 0
    var timerAnwser : Timer!
    var anwserTimerCount = 0
    var player: AVAudioPlayer?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var fistTimeChange = true
    var cellItem = "GameUserListCell"
    var joinUsers = [JoitnsUserModel]()
    var ansFlag = ""
    var tempAnser = ""
    var isFinishGame = false
    var phoneActive = true
    var dialogTimerGameVC : DialogTimerGameVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doPlayGame()
        circleProgress.minimumValue = 0
        circleProgress.endPointValue = 0
        circleProgress.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(notif:)), name: NSNotification.Name(rawValue: StringConstants.KEY_NOTIFIATION), object: nil)
        let nib = UINib(nibName: cellItem, bundle: nil)
        tbvUserList.register(nib, forCellReuseIdentifier: cellItem)
        tbvUserList.dataSource = self
        tbvUserList.delegate = self
        tbvUserList.separatorStyle = .none
        doGelWinnerList()
        viewDisble.isHidden = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
       // lblPlayersTitle.text = doGetValueLanguage(forKey: "no_of_players")
        lblTicketWillBeEnabled.text = doGetValueLanguage(forKey: "after_answer_come_ticket_is_enable")
        lblClaim.text = doGetValueLanguage(forKey: "claim")
    }
    @objc func appCameToForeground() {
        print("app enters foreground")
        DispatchQueue.global(qos: .utility).async {
            self.stopTimmer()
            self.doPlayGame()
        }
    }
    @objc func doThisWhenNotify(notif: NSNotification) {
        
        guard
            let aps =  notif.userInfo?["aps"] as? NSDictionary,
            let click_action =  notif.userInfo?["click_action"] as? String,
            let menuClick =  notif.userInfo?["menuClick"] as? String,
            let alert = aps["alert"] as? NSDictionary,
            let title = alert["title"] as? String,
            let body = alert["body"] as? String
        else {
            return
        }
        if click_action == "gameOver" {
            goToWinnserList()
            stopTimmer()
            toast(message: body, type: .Information)
        }
        if click_action.lowercased() == "userclaim" {
            toast(message: body, type: .Information)
            self.playSound(forResource: "mario_up")
        }
        if menuClick.lowercased() == "HousieJoinGame".lowercased() {
            toast(message: "\(title) \(body)", type: .Information)
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
         showAppDialog(delegate: self, dialogTitle: doGetValueLanguage(forKey: "are_you_sure_you_want_to_exit"), dialogMessage: doGetValueLanguage(forKey: "thanks_for_playing_housie"), style: .Add,  cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
    }
    func backPop() {
        DispatchQueue.main.async {
            if self.timerForQuetions != nil {
                self.timerForQuetions.invalidate()
                
            }
            self.doSetScreen()
        }
        doPopBAck()
    }
    func backScreen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if fistTimeChange {
            fistTimeChange = false
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            HousiInfoVC.attemptRotationToDeviceOrientation()
            UIView.setAnimationsEnabled(true)
            appDel.myOrientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    override func viewWillLayoutSubviews() {
      
    }
   func doSetScreen() {
    appDel.myOrientation = .portrait
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    UIView.setAnimationsEnabled(true)
    }
        
    func doSetScreen2() {
    self.player?.stop()
     appDel.myOrientation = .portrait
     UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
     UIView.setAnimationsEnabled(true)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.doPopBAck()
        
        }
     }
    @IBAction func onClickClaim(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idClaimTicketVC")as! ClaimTicketVC
        vc.room_id =  selectedItem.room_id
        vc.clickCount = clickCount
        vc.fistTwoLine = fistTwoLine
        vc.middleLine = middleLine
        vc.lastTwoLine = lastTwoLine
        vc.isFourCorner = checkFourCorner()
        vc.view.backgroundColor = .clear
        self.addChild(vc)  // add child for main view
        self.view.addSubview(vc.view)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func onClickUserList(_ sender: Any) {
         viewUserList.isHidden = false
        self.leadingConUserList.constant = 0
        UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
        }
        doGelWinnerList()
    }
    @IBAction func onClickCloseUerList(_ sender: Any) {
        self.leadingConUserList.constant = -300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
          viewUserList.isHidden = true
    }
    func startTimerTotalGame() {
        lbTotalTimer.text =  stringFromTimeInterval(interval: TimeInterval(Int(totalGameInSecond)!))
        timerTotalGame  =    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TotalTimerUpdateCounter), userInfo: nil, repeats: true)
        
    }
    @objc func TotalTimerUpdateCounter() {
         //example functionality
        
         if Int(totalGameInSecond)! > 0 {
             let remian =   Int(totalGameInSecond)! - 1
             totalGameInSecond = String(remian)
             lbTotalTimer.text =  stringFromTimeInterval(interval: TimeInterval(remian))
         } else {
             timerTotalGame?.invalidate()
             timerTotalGame = nil
            timerForQuetions?.invalidate()
            timerForQuetions = nil
         
            goToWinnserList()
            
        }
     }
    func goToWinnserList() {
         doSetScreen()
        let vc = storyboard?.instantiateViewController(withIdentifier: "idWinnerListVC") as! WinnerListVC
        vc.room_id =  selectedItem.room_id
        vc.topic =  selectedItem.game_name
        vc.date =  selectedItem.game_date + " " +  selectedItem.game_time
        vc.isComeFromtitcker = true
        pushVC(vc: vc)
    }
    func startLoadQuantionAndAnser(){
         playSound(forResource: "juntos")
        lbNofQuation.text = String(quationCounter+1) + "/" + String(question.count)
        lbQuestions.text = question[quationCounter].question
       // lbQuestions.setTextWithTypeAnimation(typedText: question[quationCounter].question, characterDelay:  12)
        timerForQuetions = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerAnserSever), target: self, selector: #selector(upDateQationUpDate), userInfo: nil, repeats: true)
        startAnwserTimmer()
        doGelWinnerList()
        ansFlag = "0"
    }
    @objc func upDateQationUpDate() {
       viewDisble.isHidden = true
        if isLoadAns {
             ansFlag = "1"
            if anserCounter + 1 == question.count  {
                timerForQuetions?.invalidate()
                timerForQuetions = nil
            }
            if anserCounter  < question.count  {
                isLoadAns = false
                lbQuestions.text =  question[anserCounter].answer
                anserCounter = anserCounter + 1
                     
                UIView.animate(withDuration: 0.5) {
                    self.lbQuestions.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) //Scale label area
                }
                self.playSound(forResource: "answertoneforhousie")
                startAnwserTimmer()
                
            }
            
        } else {
             ansFlag = "0"
            if  quationCounter < question.count  {
                isLoadAns = true
                quationCounter = quationCounter + 1
                lbNofQuation.text = String(quationCounter+1) + "/" + String(question.count)
                self.lbQuestions.isHidden = true
                self.lbQuestions.text = question[quationCounter].question
                self.tempAnser = question[quationCounter].answer
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn],
                               animations: {
                                self.lbQuestions.center.y -= self.lbQuestions.bounds.height
                                self.lbQuestions.layoutIfNeeded()
                }, completion: nil)
                self.lbQuestions.isHidden = false
                self.lbQuestions.center.y += self.lbQuestions.bounds.height
                
                 self.playSound(forResource: "juntos")
                  startAnwserTimmer()
             }
        }
    }
    func doPlayGame() {
        
        DispatchQueue.main.async {
            self.showProgress()
        }
        let params = ["joinRoom":"joinRoom",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "room_id" : selectedItem.room_id!,
                      "user_name":doGetLocalDataUser().userFullName!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(GameResponse.self, from:json!)
                    if response.status == self.GAME_NOT_STARTED {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "idDialogMessageVC")as! DialogMessageVC
                        vc.msg = response.message
                        vc.context = self
                        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                        self.addChild(vc)  // add child for main view
                        self.view.addSubview(vc.view)
                        
                    }else  if response.status == self.GAME_WILL_START {
                        print("GAME_WILL_START")
                        if self.dialogTimerGameVC != nil {
                             if self.dialogTimerGameVC.view.isDescendant(of: self.view) {
                                self.dialogTimerGameVC.remaningTimeInSecond = ""
                                //myView is subview of self.view, remove it.
                                self.dialogTimerGameVC.view.removeFromSuperview()
                            } else {
                                //myView is not subview of self.view, add it.
                            }
                        }
                        self.question = response.question
                        self.ticketView = response.ticketView
                        self.totalGameInSecond = response.totalGameInSecond
                        self.timerAnserSever =  Int(response.timer_interval!)!
                      ///  self.doFillRowArrya()
                         let vc = self.storyboard!.instantiateViewController(withIdentifier: "idDialogTimerGameVC")as! DialogTimerGameVC
                        vc.remaningTimeInSecond = response.remaningTimeInSecond
                        vc.room_id = response.room_id
                        vc.context = self
                        self.dialogTimerGameVC = vc
                        vc.view.backgroundColor = .clear
                        self.addChild(vc)  // add child for main view
                        self.view.addSubview(vc.view)
                        
                    } else  if response.status == self.GAME_IS_STARTED {
                          print("GAME_IS_STARTED")
                        self.isLoadTiecket = true
                        
                        if self.dialogTimerGameVC != nil {
                            if self.dialogTimerGameVC.view.isDescendant(of: self.view) {
                                self.dialogTimerGameVC.remaningTimeInSecond = ""
                                //myView is subview of self.view, remove it.
                                self.dialogTimerGameVC.view.removeFromSuperview()
                            } else {
                                //myView is not subview of self.view, add it.
                            }
                        }
                        self.question = response.question
                        self.ticketView = response.ticketView
                        self.totalGameInSecond = response.totalGameInSecond
                        self.quationCounter = Int(response.questionCounter!)! - 1
                        self.anserCounter = Int(response.questionCounter!)! - 1
                        self.loadQution = false
                        self.lbNofQuation.text = response.questionCounter + "/" + String(self.question.count)
                        self.timerAnserSever =  Int(response.timer_interval!)!
                         if response.questionAnswerFlag == "0" {
                            // load quation
                            self.lbQuestions.text = self.question[self.quationCounter].question
                            self.isLoadAns = true
                            self.playSound(forResource: "juntos")
                            self.startAnwserTimmer()
                            self.tempAnser = self.question[self.quationCounter].answer
                                               
                        } else {
                            // load anser
                            self.isLoadAns = true
                            self.upDateQationUpDate()
                            self.playSound(forResource: "answertoneforhousie")
                            
                        }
                        print("phoneActive = " , self.phoneActive)
                        if self.phoneActive {
                            self.doFillRowArrya()
                        }
                        self.timerForQuetions = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerAnserSever), target: self, selector: #selector(self.upDateQationUpDate), userInfo: nil, repeats: true)
                        
                       //  self.doFillRowArrya()
                        
                    } else if response.status == self.GAME_OVER {
                        self.goToWinnserList()
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func doFillRowArrya() {
        
        if  self.ticketView.count > 0 {
            
            let diff = 20 - ticketView.count
            var count = 0
            if diff != 0 {
                
                for i in 0...3 {
                    
                    if i == 3 {
                        rowOneArray.append("")
                    } else {
                        rowOneArray.append(ticketView[count].answer)
                        count = count + 1
                       // print("# list one " , count )
                    }
                }
                for i in 0...3 {
                    
                    if i == 3 {
                        rowTwoArray.append("")
                    } else {
                        rowTwoArray.append(ticketView[count].answer)
                        count = count + 1
                     //   print("# list two " , count )
                    }
                    
                }
                for i in 0...3 {
                    
                    if i == 3 {
                        rowThreeArray.append("")
                    } else {
                        rowThreeArray.append(ticketView[count].answer)
                        count = count + 1
                      //  print("# list three " , count )
                    }
                    
                }
                
                for i in 0...3 {
                    
                    if i == 3 {
                        rowFourArray.append("")
                    } else {
                        rowFourArray.append(ticketView[count].answer)
                        count = count + 1
                     //   print("# list four " , count )
                    }
                    
                }
                
                
                for i in 0...3 {
                    
                    if i == 3 {
                        rowFiveArray.append("")
                    } else {
                        rowFiveArray.append(ticketView[count].answer)
                        count = count + 1
                     //   print("# list four " , count )
                    }
                    
                }
                
                rowOneArray.shuffle()
                rowTwoArray.shuffle()
                rowThreeArray.shuffle()
                rowFourArray.shuffle()
                rowFiveArray.shuffle()
                
                if isLoadTiecket {
                     showGameLayout()
                }
            }
        }
   // let diffarance = 0
    }
    func showGameLayout() {
        print("showGameLayout")
        phoneActive = false
        startTimerTotalGame()
        if loadQution {
            startLoadQuantionAndAnser()
                
        }
        //todo create row one data
        if rowOneArray[0] != "" {
            lbRowOneOne.text = rowOneArray[0]
        } else {
            IvRowOneOne.isHidden = false
        }
        
        if rowOneArray[1] != "" {
            lbRowOneTwo.text = rowOneArray[1]
        } else {
            IvRowOneTwo.isHidden = false
        }
        
        if rowOneArray[2] != "" {
            lbRowOneThree.text = rowOneArray[2]
        } else {
            IvRowOneThree.isHidden = false
        }
        
        if rowOneArray[3] != "" {
            lbRowOneFour.text = rowOneArray[3]
        } else {
            IvRowOneFour.isHidden = false
        }
        //todo create row second data
        if rowTwoArray[0] != "" {
            lbRowTwoOne.text = rowTwoArray[0]
        } else {
            IvRowTwoOne.isHidden = false
        }
        if rowTwoArray[1] != "" {
            lbRowTwoTwo.text = rowTwoArray[1]
        } else {
            IvRowTwoTwo.isHidden = false
        }
        if rowTwoArray[2] != "" {
            lbRowTwoThree.text = rowTwoArray[2]
        } else {
            IvRowTwoThree.isHidden = false
        }
        if rowTwoArray[3] != "" {
            lbRowTwoFour.text = rowTwoArray[3]
        } else {
            IvRowTwoFour.isHidden = false
        }
        //todo create row third
        if rowThreeArray[0] != "" {
            lbRowThreeOne.text = rowThreeArray[0]
        } else {
            IvRowThreeOne.isHidden = false
        }
        if rowThreeArray[1] != "" {
            lbRowThreeTwo.text = rowThreeArray[1]
        } else {
            IvRowThreeTwo.isHidden = false
        }
        if rowThreeArray[2] != "" {
            lbRowThreeThree.text = rowThreeArray[2]
        } else {
            IvRowThreeThree.isHidden = false
        }
        
        if rowThreeArray[3] != "" {
            lbRowThreeFour.text = rowThreeArray[3]
        } else {
            IvRowThreeFour.isHidden = false
        }
        //todo create row four
        if rowFourArray[0] != "" {
            lbRowFourOne.text = rowFourArray[0]
        } else {
            IvRowFourOne.isHidden = false
        }
        
        if rowFourArray[1] != "" {
            lbRowFourTwo.text = rowFourArray[1]
        } else {
            IvRowFourTwo.isHidden = false
        }
        
        if rowFourArray[2] != "" {
            lbRowFourThree.text = rowFourArray[2]
        } else {
            IvRowFourThree.isHidden = false
        }
        
        if rowFourArray[3] != "" {
            lbRowFourFour.text = rowFourArray[3]
        } else {
            IvRowFourFour.isHidden = false
        }
       
        //todo create row five
          if rowFiveArray[0] != "" {
              lbRowFiveOne.text = rowFiveArray[0]
          } else {
              IvRowFiveOne.isHidden = false
          }
          
          if rowFiveArray[1] != "" {
              lbRowFiveTwo.text = rowFiveArray[1]
          } else {
              IvRowFiveTwo.isHidden = false
          }
          
          if rowFiveArray[2] != "" {
              lbRowFiveThree.text = rowFiveArray[2]
          } else {
              IvRowFiveThree.isHidden = false
          }
          
          if rowFiveArray[3] != "" {
              lbRowFiveFour.text = rowFiveArray[3]
          } else {
              IvRowFiveFour.isHidden = false
          }
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {

         let ti = NSInteger(interval)
         let seconds = ti % 60
         let minutes = (ti / 60) % 60
       //  let hours = (ti / 3600)

         return String(format: "%0.2d:%0.2d",minutes,seconds)
       }
    func startAnwserTimmer() {
        if timerAnwser != nil {
             timerAnwser.invalidate()
        }
        circleProgress.maximumValue = CGFloat(timerAnserSever)
        circleProgress.endPointValue = CGFloat(timerAnserSever)
        anwserTimerCount = Int(self.timerAnserSever)
          lbTimeConter.text = String(anwserTimerCount) + "\n Second"
        timerAnwser = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(upDateAnswerCont), userInfo: nil, repeats: true)
           
    }
    @objc func upDateAnswerCont() {
        if anwserTimerCount > 0 {
            let remian =   anwserTimerCount - 1
            anwserTimerCount = remian
           
            circleProgress.endPointValue = CGFloat(remian)
            
            if anwserTimerCount < 10 {
                lbTimeConter.text = "0\(remian)\n Second"
            } else {
                 lbTimeConter.text = String(remian) + "\n Second"
            }
            
        } else {
            timerAnwser?.invalidate()
            if anserCounter + 1  == question.count {
                goToWinnserList()
                stopTimmer()
            }
        }
    }
    func checkFourCorner() -> Bool {
        var firstList = 0 , fiveList = 0
       var isFistLine = false , isFiveLine = false
       
        for (index , item) in rowOneArray.enumerated() {
            if item == "" {
                firstList = index
            }
        }
        for (index , item) in rowFiveArray.enumerated() {
            if item == "" {
                fiveList = index
            }
        }
        if firstList == 0 {
            if viewRowOneTwo.backgroundColor == ColorConstant.housi_yellow &&  viewRowOneFour.backgroundColor == ColorConstant.housi_yellow {
                isFistLine = true
            }
        }
        if firstList == 1 {
            if viewRowOneOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowOneFour.backgroundColor == ColorConstant.housi_yellow {
                isFistLine = true
            }
        }
        if firstList == 2 {
            if viewRowOneOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowOneFour.backgroundColor == ColorConstant.housi_yellow {
                isFistLine = true
            }
        }
        if firstList == 3 {
            if viewRowOneOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowOneThree.backgroundColor == ColorConstant.housi_yellow {
                isFistLine = true
            }
        }
      
        // for row last
        if fiveList == 0 {
            if viewRowFiveTwo.backgroundColor == ColorConstant.housi_yellow &&  viewRowFiveFour.backgroundColor == ColorConstant.housi_yellow {
                isFiveLine = true
            }
        }
        if fiveList == 1 {
            if viewRowFiveOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowFiveFour.backgroundColor == ColorConstant.housi_yellow {
                isFiveLine = true
            }
        }
        if fiveList == 2 {
            if viewRowFiveOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowFiveFour.backgroundColor == ColorConstant.housi_yellow {
                isFiveLine = true
            }
        }
        if fiveList == 3 {
            if viewRowFiveOne.backgroundColor == ColorConstant.housi_yellow &&  viewRowFiveThree.backgroundColor == ColorConstant.housi_yellow {
                isFiveLine = true
            }
        }
        
        if isFistLine && isFiveLine {
            return true
        }
        return false
    }
    
    func doSetDisble() {
    print("doSetDisble")
        if ansFlag == "0" {
            viewDisble.isHidden = false
        }
    }
    // Todo click firse row
    @IBAction func onClickRowOneOne(_ sender: Any) {
        if lbRowOneOne.text == "" {
            return
        }
        if lbRowOneOne.text == lbQuestions.text || lbRowOneOne.text == tempAnser {
            if isClickRowOneOne {
                isClickRowOneOne = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowOneOne,label: lbRowOneOne)
            }
        } else {
           doSetDisble()
        }
    }
    @IBAction func onClickRowOneTwo(_ sender: Any) {
      if lbRowOneTwo.text == "" {
            return
        }
        if lbRowOneTwo.text == lbQuestions.text || lbRowOneTwo.text == tempAnser {
            if isClickRowOneTwo {
                isClickRowOneTwo = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowOneTwo,label: lbRowOneTwo)
            }
        }else {
           doSetDisble()
        }
    }
    @IBAction func onClickRowOneThree(_ sender: Any) {
        if lbRowOneThree.text == "" {
            return
        }
        if lbRowOneThree.text == lbQuestions.text  || lbRowOneThree.text == tempAnser {
            if isClickRowOneThree {
                isClickRowOneThree = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowOneThree,label: lbRowOneThree)
            }
        }else {
            doSetDisble()
        }
    }
    @IBAction func onClickRowOneFour(_ sender: Any) {
      //  print("4" , lbRowOneFour.text)
        if lbRowOneFour.text == "" {
            return
        }
        if lbRowOneFour.text == lbQuestions.text || lbRowOneFour.text == tempAnser {
            if isClickRowOneFour {
                isClickRowOneFour = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowOneFour,label: lbRowOneFour)
            }
        }else {
            doSetDisble()
        }
    }
    // todo click second row
    @IBAction func onClickRowTwoOne(_ sender: Any) {
        if lbRowTwoOne.text == "" {
            return
        }
        if lbRowTwoOne.text == lbQuestions.text   || lbRowTwoOne.text == tempAnser {
            if isClickRowTwoOne {
                isClickRowTwoOne = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowTwoOne,label: lbRowTwoOne)
            }
        }else {
            doSetDisble()
        }
    }
    @IBAction func onClickRowTwoTwo(_ sender: Any) {
        if lbRowTwoTwo.text == "" {
            return
        }
        if lbRowTwoTwo.text == lbQuestions.text || lbRowTwoTwo.text == tempAnser {
            if isClickRowTwoTwo {
                isClickRowTwoTwo = false
                clickCount = clickCount + 1
                fistTwoLine = fistTwoLine + 1
                setSelectView(view: viewRowTwoTwo,label: lbRowTwoTwo)
            }
        }else {
            doSetDisble()
        }
        
    }
    @IBAction func onClickRowTwoThree(_ sender: Any) {
        if lbRowTwoThree.text == "" {
            return
        }
        if lbRowTwoThree.text == lbQuestions.text || lbRowTwoThree.text == tempAnser {
                   if isClickRowTwoThree {
                       isClickRowTwoThree = false
                       clickCount = clickCount + 1
                       fistTwoLine = fistTwoLine + 1
                       setSelectView(view: viewRowTwoThree,label: lbRowTwoThree)
                   }
               }else {
                  doSetDisble()
               }
        
    }
    @IBAction func onClickRowTwoFour(_ sender: Any) {
        if lbRowTwoFour.text == "" {
            return
        }
        if lbRowTwoFour.text == lbQuestions.text || lbRowTwoFour.text == tempAnser {
                 if isClickRowTwoFour {
                     isClickRowTwoFour = false
                     clickCount = clickCount + 1
                     fistTwoLine = fistTwoLine + 1
                     setSelectView(view: viewRowTwoFour,label: lbRowTwoFour)
                 }
             }else {
                doSetDisble()
             }
    }
    //todo click third
    @IBAction func onClickRowThreeOne(_ sender: Any) {
        if lbRowThreeOne.text == "" {
            return
        }
        if lbRowThreeOne.text == lbQuestions.text  || lbRowThreeOne.text == tempAnser {
            if isClickRowThreeOne {
                isClickRowThreeOne = false
                clickCount = clickCount + 1
                middleLine = middleLine + 1
                setSelectView(view: viewRowThreeOne,label: lbRowThreeOne)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowThreeTwo(_ sender: Any) {
        if lbRowThreeTwo.text == "" {
            return
        }
        if lbRowThreeTwo.text == lbQuestions.text  || lbRowThreeTwo.text == tempAnser {
            if isClickRowThreeTwo {
                isClickRowThreeTwo = false
                clickCount = clickCount + 1
                middleLine = middleLine + 1
                setSelectView(view: viewRowThreeTwo,label: lbRowThreeTwo)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowThreeThree(_ sender: Any) {
        if lbRowThreeThree.text == "" {
            return
        }
        if lbRowThreeThree.text == lbQuestions.text  || lbRowThreeThree.text == tempAnser {
            if isClickRowThreeThree {
                isClickRowThreeThree = false
                clickCount = clickCount + 1
                middleLine = middleLine + 1
                setSelectView(view: viewRowThreeThree,label: lbRowThreeThree)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowThreeFour(_ sender: Any) {
        if lbRowThreeFour.text == "" {
            return
        }
        if lbRowThreeFour.text == lbQuestions.text || lbRowThreeFour.text == tempAnser {
            if isClickRowThreeFour {
                isClickRowThreeFour = false
                clickCount = clickCount + 1
                middleLine = middleLine + 1
                setSelectView(view: viewRowThreeFour,label: lbRowThreeFour)
            }
        }else {
           doSetDisble()
        }
    }
    @IBAction func onClickRowFourOne(_ sender: Any) {
        if lbRowFourOne.text == "" {
            return
        }
          if lbRowFourOne.text == lbQuestions.text  || lbRowFourOne.text == tempAnser {
              if isClickRowFourOne {
                  isClickRowFourOne = false
                  clickCount = clickCount + 1
                  lastTwoLine = lastTwoLine + 1
                  setSelectView(view: viewRowFourOne,label: lbRowFourOne)
              }
          }else {
             doSetDisble()
          }
          
      }
      @IBAction func onClickRowFourTwo(_ sender: Any) {
        if lbRowFourTwo.text == "" {
            return
        }
        
          if lbRowFourTwo.text == lbQuestions.text  || lbRowFourTwo.text == tempAnser{
              if isClickRowFourTwo {
                  isClickRowFourTwo = false
                  clickCount = clickCount + 1
                  lastTwoLine = lastTwoLine + 1
                  setSelectView(view: viewRowFourTwo,label: lbRowFourTwo)
              }
          }else {
             doSetDisble()
          }
          
      }
      @IBAction func onClickRowFourThree(_ sender: Any) {
        if lbRowFourThree.text == "" {
            return
        }
          if lbRowFourThree.text == lbQuestions.text || lbRowFourThree.text == tempAnser {
              if isClickRowFourThree {
                  isClickRowFourThree = false
                  clickCount = clickCount + 1
                 lastTwoLine = lastTwoLine + 1
                  setSelectView(view: viewRowFourThree,label: lbRowFourThree)
              }
          }else {
             doSetDisble()
          }
      }
      @IBAction func onClickRowFourFour(_ sender: Any) {
          if lbRowFourFour.text == "" {
              return
          }
          if lbRowFourFour.text == lbQuestions.text || lbRowFourFour.text == tempAnser {
              if isClickRowFourFour {
                  isClickRowFourFour = false
                  clickCount = clickCount + 1
                 lastTwoLine = lastTwoLine + 1
                  setSelectView(view: viewRowFourFour,label: lbRowFourFour)
              }
          }else {
             doSetDisble()
          }
      }
    @IBAction func onClickRowFiveOne(_ sender: Any) {
        if lbRowFiveOne.text == "" {
            return
        }
        if lbRowFiveOne.text == lbQuestions.text || lbRowFiveOne.text == tempAnser{
            if isClickRowFiveOne {
                isClickRowFiveOne = false
                clickCount = clickCount + 1
                lastTwoLine = lastTwoLine + 1
                setSelectView(view: viewRowFiveOne,label: lbRowFiveOne)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowFiveTwo(_ sender: Any) {
        if lbRowFiveTwo.text == "" {
            return
        }
        if lbRowFiveTwo.text == lbQuestions.text || lbRowFiveTwo.text == tempAnser {
            if isClickRowFiveTwo {
                isClickRowFiveTwo = false
                clickCount = clickCount + 1
                lastTwoLine = lastTwoLine + 1
                setSelectView(view: viewRowFiveTwo,label: lbRowFiveTwo)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowFiveThree(_ sender: Any) {
        if lbRowFiveThree.text == "" {
            return
        }
        if lbRowFiveThree.text == lbQuestions.text || lbRowFiveThree.text == tempAnser {
            if isClickRowFiveThree {
                isClickRowFiveThree = false
                clickCount = clickCount + 1
                lastTwoLine = lastTwoLine + 1
                setSelectView(view: viewRowFiveThree,label: lbRowFiveThree)
            }
        }else {
           doSetDisble()
        }
        
    }
    @IBAction func onClickRowFiveFour(_ sender: Any) {
        if lbRowFiveFour.text == "" {
            return
        }
        if lbRowFiveFour.text == lbQuestions.text || lbRowFiveFour.text == tempAnser{
            if isClickRowFiveFour {
                isClickRowFiveFour = false
                clickCount = clickCount + 1
                lastTwoLine = lastTwoLine + 1
                setSelectView(view: viewRowFiveFour,label: lbRowFiveFour)
            }
        }else {
           doSetDisble()
        }
    }
    func setSelectView(view : UIView , label : UILabel) {
        view.backgroundColor = ColorConstant.housi_yellow
        label.textColor = .white
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
    override func viewDidDisappear(_ animated: Bool) {
        stopTimmer()
    }
    override func viewWillDisappear(_ animated: Bool) {
         stopTimmer()
         NotificationCenter.default.removeObserver(self)
    }
    func stopTimmer() {
        if player != nil {
            if player!.isPlaying {
                player?.stop()
            }
        }
        if timerTotalGame != nil {
            timerTotalGame?.invalidate()
            timerTotalGame = nil
        }
        if timerForQuetions != nil {
            timerForQuetions?.invalidate()
            timerForQuetions = nil
        }
        UserDefaults.standard.set(nil, forKey: "claimList")
        
    }
    func doGelWinnerList() {
           
           let params = ["getJoinUsers":"getJoinUsers",
                         "society_id":doGetLocalDataUser().societyID!,
                         "room_id":selectedItem.room_id!]
           print("param" , params)
           let request = AlamofireSingleTon.sharedInstance
           request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
           //    self.hideProgress()
               if json != nil {
                   do {
                       let response = try JSONDecoder().decode(GameResponse.self, from:json!)
                       if response.status == "200" {
                        if response.joinUsers.count > 9 {
                            self.lbNoOfPlyaer.text = self.doGetValueLanguage(forKey: "no_of_players") + String(response.joinUsers.count)
                                                  
                        } else {
                            self.lbNoOfPlyaer.text = self.doGetValueLanguage(forKey: "no_of_players_00") + String(response.joinUsers.count)
                        }
                           self.joinUsers = response.joinUsers
                           self.tbvUserList.reloadData()
                       }else {
                           self.toast(message: response.message, type: .Faliure)
                       }
                       print(json as Any)
                   } catch {
                       print("parse error")
                   }
               }
           }
              
       }
    override var shouldAutorotate: Bool {
          return true
    }
}
extension TicketViewVC: AppDialogDelegate{
    
    func btnAgreeClicked(dialogType: DialogStyle, tag:Int) {
        print("btnAgreeClicked")
        if dialogType == .Add{
            self.dismiss(animated: true)
            self.doSetScreen2()
        }
    }
}
extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }

        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
}
extension TicketViewVC : UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem, for: indexPath) as! GameUserListCell
        let item = joinUsers[indexPath.row]
        cell.lbPlayerName.text = item.user_name
        cell.lbPoint.text = item.user_points
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile, palceHolder:"user_default")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
