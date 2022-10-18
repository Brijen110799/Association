//
//  DialogTimerGameVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 20/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation

class DialogTimerGameVC: BaseVC {
    //for row one
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lblGameWillBeStartIn: UILabel!
    @IBOutlet weak var lblClaimPrize: UILabel!
    var remaningTimeInSecond = ""
    var context: TicketViewVC!
    var timer : Timer!
    let appDel = UIApplication.shared.delegate as! AppDelegate
     var rules = [ItemReles]()
    let itemCell = "HouseRuleCell"
    var room_id = ""
    @IBOutlet weak var cvData: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if remaningTimeInSecond != "" {
            timer  =    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            lbTimer.text =  stringFromTimeInterval(interval: TimeInterval(Int(remaningTimeInSecond)!))
        }
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        doGetrule()
        lblGameWillBeStartIn.text = doGetValueLanguage(forKey: "game_will_start_in")
        lblClaimPrize.text = doGetValueLanguage(forKey: "claim_prize")
    }
    @objc func updateCounter() {
        //example functionality
       var remian = -1
        if  remaningTimeInSecond == "" {
           // closeDialog()
            return
        }
        if Int(remaningTimeInSecond)! > 0 {
             remian =   Int(remaningTimeInSecond)! - 1
            remaningTimeInSecond = String(remian)
            lbTimer.text =  stringFromTimeInterval(interval: TimeInterval(remian))
        } else {
            timer?.invalidate()
            timer = nil
            context.isLoadTiecket = true
            context.doFillRowArrya()
            removeFromParent()
            view.removeFromSuperview()
        }
    }
    func closeDialog() {
        removeFromParent()
        view.removeFromSuperview()
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {
      let ti = NSInteger(interval)
      let seconds = ti % 60
      let minutes = (ti / 60) % 60
      return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    @IBAction func onClickCancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.appDel.myOrientation = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(true)
            self.context.doPopBAck()
            self.removeFromParent()
            self.view.removeFromSuperview()
            
        }
    }
    func doGetrule() {
         let params = ["getRules":"getRules",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "room_id" : room_id,
                      "user_name" : doGetLocalDataUser().userFullName!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
             
             if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseReles.self, from:json!)
                    if response.status == "200" {
                        
                        
                        self.rules = response.rules
                        
                        self.cvData.reloadData()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }

    }
}
extension DialogTimerGameVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rules.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! HouseRuleCell
       let item = rules[indexPath.row]
        cell.lbTitle.text = item.rule_name
        cell.lbTotalCoin.text = item.rule_points
        cell.lbWinner.text = item.total_player
         return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourwidth = collectionView.frame.width/3
        return CGSize(width: yourwidth - 3 , height:110)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddd didSelectItemAt ")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//         let cell: WeekDaysCell = cvdata.cellForItem(at: indexPath) as! WeekDaysCell
    }
}
