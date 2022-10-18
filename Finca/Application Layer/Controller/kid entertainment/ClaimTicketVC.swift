//
//  ClaimTicketVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
struct ResponseReles : Codable {
    let status : String! //": "200",
    let message : String! //": "Rules Details"
    let rules:[ItemReles]!
}
struct ItemReles : Codable {
    let master_rule_id  :String! //": "1",
    let rule_name  :String! //": "Early Five",
    let rele_discription  :String! //": "Any Five Answer from Ticket",
    let total_player  :String! //": "5",
    let claim_player  :String! //": "2",
    let rule_points  :String! //": "10",
    let winner_list  :String! //": "Asif,Ankit,"
    let winnerList : [WinnerList]!
}
struct WinnerList : Codable {
    let user_name  :String! //": "1",
    let user_profile_pic  :String! //": "Early Five",
}

class ClaimTicketVC: BaseVC {

    let itemCell = "ClaimWinnerCell"
    var room_id = ""
     var rules = [ItemReles]()
    var clickCount = 0
    var fistTwoLine = 0
    var middleLine = 0
    var lastTwoLine = 0
    var isFourCorner = false
  //  var indexHide = -1
    var titleGame = ""
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var lblClaimYourTicket: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        doGetrule()
//        print("clickCount =  " , clickCount)
//        print("fistTwoLine =  " , fistTwoLine)
//        print("middleLine =  " , middleLine)
//        print("lastTwoLine =  " , lastTwoLine)
//
        if UserDefaults.standard.data(forKey:"claimList") != nil {
            if let data = UserDefaults.standard.data(forKey: "claimList"), let decoded = try? JSONDecoder().decode([ItemReles].self, from: data){
             rules = decoded
            cvData.reloadData()
         }
            
        }
        lblClaimYourTicket.text = doGetValueLanguage(forKey: "claim_for_your_ticket")
        
    }
    

    @IBAction func onClickClose(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    func doGetrule() {
       // showProgress()
         let params = ["getRules":"getRules",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "room_id" : room_id,
                      "user_name" : doGetLocalDataUser().userFullName!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
             // self.hideProgress()
             if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseReles.self, from:json!)
                    if response.status == "200" {
                        
                        if let encoded = try? JSONEncoder().encode(response.rules) {
                            UserDefaults.standard.set(encoded, forKey: "claimList")
                        }
                        
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
    

    func doCallClaimTicket(master_rule_id : String) {
        
        showProgress()
             let params = ["claimTicket":"claimTicket",
                          "society_id":doGetLocalDataUser().societyID!,
                          "user_id":doGetLocalDataUser().userID!,
                          "room_id" : room_id,
                          "user_name" : doGetLocalDataUser().userFullName!,
                          "master_rule_id" : master_rule_id]
            print("param" , params)
            let request = AlamofireSingleTon.sharedInstance
            request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
                  self.hideProgress()
                 if json != nil {
                    do {
                        let response = try JSONDecoder().decode(ResponseReles.self, from:json!)
                        if response.status == "200" {
                            self.toast(message: response.message, type: .Success)
                            self.doGetrule()
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
    
    func doCheckAndClain(master_rule_id : String) {
        
        switch master_rule_id {
        case "1":
            // Early Five
            
            if clickCount == 5 {
                doCallClaimTicket(master_rule_id: master_rule_id)
                
            } else {
                toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
            }
            
            break
        case "2":
            //Top Two Lines
            if fistTwoLine == 6 {
                doCallClaimTicket(master_rule_id: master_rule_id)
                
            } else {
                toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
            }
            break
             case "3":
               // Middle Line
                if middleLine == 3 {
                    doCallClaimTicket(master_rule_id: master_rule_id)
                    
                } else {
                    toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
                }
                
            break
           
        case "4":
            //Bottom Two Lines
            if lastTwoLine == 6 {
                doCallClaimTicket(master_rule_id: master_rule_id)
                
            } else {
                toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
            }
            
            break
            
           case "5":
            //Four Corner pending
            
            if isFourCorner {
                doCallClaimTicket(master_rule_id: master_rule_id)
            } else {
                toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
            }
            
            break
        case "6":
            
            if clickCount == 15 {
                doCallClaimTicket(master_rule_id: master_rule_id)
                
            } else {
                toast(message: doGetValueLanguage(forKey: "sorry_invalid_claim"), type: .Faliure)
            }
            
            break
            
        default:
            break
        }
        
    }
}
extension ClaimTicketVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , OnClickCliam{
  
    func onClickClaim(index: Int) {
       // indexHide = index
        doCheckAndClain(master_rule_id: rules[index].master_rule_id)
        
        
    }
    
    func onClickView(index: Int) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "idDialogWinnerVC")as! DialogWinnerVC
        vc.winnerList = rules[index].winnerList
        vc.titleGame = rules[index].rule_name
        //vc.context = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)  // add child for main view
        self.view.addSubview(vc.view)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! ClaimWinnerCell
       let item = rules[indexPath.row]
        cell.lbTitle.text = item.rule_name
        cell.lbTotalCoin.text =  item.rule_points
//        cell.lbClaimPrize.text = item.claim_player
        cell.lbTotalPrize.text = "\(doGetValueLanguage(forKey: "total_prizes")) : \(item.total_player ?? "")"
         cell.lbClaimPrize.text = "\(doGetValueLanguage(forKey: "claim_prize")) : \(item.claim_player ?? "")"
        cell.onClickCliam = self
        cell.index = indexPath.row
//        if indexHide == indexPath.row {
//            cell.bClaim.isHidden = true
//        }
        if item.winnerList != nil && item.winnerList.count > 0 {
             cell.bWinner.isHidden = false
        } else {
             cell.bWinner.isHidden = true
        }
        
        if item.total_player  == item.claim_player {
             cell.bClaim.isHidden = true
        } else {
            cell.bClaim.isHidden = false
        }
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
        return CGSize(width: yourwidth - 3 , height:200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddd didSelectItemAt ")
      
       
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//         let cell: WeekDaysCell = cvdata.cellForItem(at: indexPath) as! WeekDaysCell
          
    }
}
