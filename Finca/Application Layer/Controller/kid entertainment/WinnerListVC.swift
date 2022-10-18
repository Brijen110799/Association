//
//  WinnerListVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
struct ResponseWinnerList : Codable {
    let message : String! //" : "Users List",
    let status : String! //" : "200",
    let winnerUsers : [ItemWinnerList]!
    
}
struct ItemWinnerList : Codable {
    let user_profile_pic : String! //" : "https:\/\/developer.ident_profile\/user_1358682192.png",
    let user_id : String! //" : "1015",
    let gender : String! //" : "Male",
    let rele_discription : String! //" : "Any Five Answer from Ticket",
    let winning_point : String! //" : "10",
    let user_name : String! //" : "Deepak (p-205)",
    let rule_name : String! //" : "Early Five"
}
class WinnerListVC: BaseVC {
     @IBOutlet weak var cvData: UICollectionView!
    let itemCell = "WinnerCell"
      var winnweList = [ItemWinnerList]()
     var room_id = ""
    var date = ""
      var topic = ""
      var player: AVAudioPlayer?
     @IBOutlet weak var viewConfettiview: UIView!
    
    @IBOutlet weak var confirView: ConfettiView!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var lblWinnerTitle: UILabel!
    var ruleName = ""
    var point = 0
    var isComeFromtitcker = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        doGelWinnerList()
        lblWinnerTitle.text = doGetValueLanguage(forKey: "winner")
        lbNoData.text = doGetValueLanguage(forKey: "no_winner_found")
    }
    
    func setConfettiView(){

        confirView.emit(with: [
            .image(UIImage(named: "confetti")!, .yellow),
            .image(UIImage(named: "diamond")!, .green),
            .image(UIImage(named: "star1")!, .magenta),
            .image(UIImage(named: "triangle")!, .white),
            .image(UIImage(named: "diamond")!, .red),
            .image(UIImage(named: "confetti")!, .cyan),
            .image(UIImage(named: "triangle")!, .systemPink)])
        
        playSound(forResource: "gameover")
        
    }
    
    func doGelWinnerList() {
         
         showProgress()
              let params = ["getWinner":"getWinner",
                           "society_id":doGetLocalDataUser().societyID!,
                           "user_id":doGetLocalDataUser().userID!,
                           "room_id" : room_id]
             print("param" , params)
             let request = AlamofireSingleTon.sharedInstance
             request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
                   self.hideProgress()
                  if json != nil {
                     do {
                         let response = try JSONDecoder().decode(ResponseWinnerList.self, from:json!)
                         if response.status == "200" {
                            self.winnweList = response.winnerUsers
                            self.cvData.reloadData()
                            self.lbNoData.isHidden = true
                            
                            self.doShoeShareButton()
                          }else {
                             self.lbNoData.isHidden = false
                            //self.toast(message: response.message, type: .Faliure)
                         }
                         print(json as Any)
                     } catch {
                         print("parse error")
                     }
                 }
             }
         
     }

   func doShoeShareButton() {
    if isComeFromtitcker {
        setConfettiView()
    }
    
     for item in winnweList {
        
       if item.user_id == doGetLocalDataUser().userID! {
           self.viewShare.isHidden = false
          
        if ruleName == "" {
            ruleName = item.rule_name
            point = Int(item.winning_point)!
        } else {
            ruleName = ruleName + "," + item.rule_name
            point = point + Int(item.winning_point)!
        }
            
            
        }
        
    }
    }
    @IBAction func onClickBack(_ sender: Any) {
       
        if isComeFromtitcker {
            
            for controller in self.navigationController!.viewControllers as Array {
                       if controller.isKind(of: HousiInfoVC.self) {
                            
                           self.navigationController!.popToViewController(controller, animated: true)
                           break
                       }
                   }
        } else {
            doPopBAck()
        }
    }
    @IBAction func onClickShare(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "idDialogShareScoreVC")as! DialogShareScoreVC
        vc.topic =   topic
        vc.date =  date
        vc.point = String(point)
        vc.ruleName = ruleName
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addChild(vc)  // add child for main view
        view.addSubview(vc.view)
        
      }
    func playSound(forResource:String) {
          
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
        DispatchQueue.main.async {
            self.stopPlayer()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.stopPlayer()
        }
    }
    func stopPlayer() {
        if player != nil {
            if player!.isPlaying {
                player?.stop()
            }
        }
    }
}
extension WinnerListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return winnweList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! WinnerCell
        let item = winnweList[indexPath.row]
        cell.lbTitle.text = item.rule_name
        cell.lbUserName.text = item.user_name
        cell.lbPoint.text = item.winning_point
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic, palceHolder: "user_default")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourwidth = collectionView.frame.width
        return CGSize(width: yourwidth - 3 , height:110)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddd didSelectItemAt ")
      
       
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//         let cell: WeekDaysCell = cvdata.cellForItem(at: indexPath) as! WeekDaysCell
          
    }
}
