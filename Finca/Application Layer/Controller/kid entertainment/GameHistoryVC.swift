//
//  GameHistoryVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 24/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

struct ResponseGameHistory : Codable {
    let status  :String! //" : "200"
    let message  :String! //" : "Game List",
    let gameList:[ModelGameList]!
    
}
struct ModelGameList : Codable {
    let sponser_photo : String! //" : "hper.fincasys\/sponser_id_1587710519.png",
    let room_id : String! //" : "47",
    let sponser_name : String! //" : "ios Dev",
    let game_name : String! //" : "iOS Testing 24-04",
    let game_date : String! //" : "24 Apr 2020,03:05 PM",
    let sponser_url : String! //" : "Asif Hingora"
    let winnerUsers : [ItemWinnerList]!
}


class GameHistoryVC: BaseVC  {
    var gameList =  [ModelGameList]()
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblGameHistory: UILabel!
    let cellItem = "GameHistoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellItem, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: cellItem)
        tbvData.dataSource = self
        tbvData.delegate = self
        tbvData.separatorStyle = .none
        doGelWinnerList()
        lblGameHistory.text = doGetValueLanguage(forKey: "game_history")
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    func doGelWinnerList() {
        
        showProgress()
        let params = ["getResult":"getResult",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseGameHistory.self, from:json!)
                    if response.status == "200" {
                        self.gameList = response.gameList
                        self.tbvData.reloadData()
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
}

extension GameHistoryVC : UITableViewDelegate,UITableViewDataSource , GameClickDelegate{
    func onClickDetail(index: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idWinnerListVC") as! WinnerListVC
        vc.room_id =  gameList[index].room_id
        vc.topic =   gameList[index].game_name
        vc.date =   gameList[index].game_date
        
        pushVC(vc: vc)
    }
    
    func onClickLink(index: Int) {
        let url1 = gameList[index].sponser_url
        
        if url1 != "" {
            guard let url = URL(string: url1!) else { return }
            UIApplication.shared.open(url)
        }
       
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem, for: indexPath) as! GameHistoryCell
        let item = gameList[indexPath.row]
        cell.lbTitle.text = item.game_name
        cell.lbDate.text = item.game_date
        cell.index = indexPath.row
        cell.gameClickDelegate = self
        cell.lblSponserByTitle.text = doGetValueLanguage(forKey: "sponser_by")
        cell.btnViewResult.setTitle(doGetValueLanguage(forKey: "view_result"), for: .normal)
        if item.sponser_name == "" {
            cell.viewSponser.isHidden = true
             cell.conHeightSponser.constant = 0
        } else {
            cell.viewSponser.isHidden = false
            cell.conHeightSponser.constant = 120
            Utils.setImageFromUrl(imageView: cell.ivSponser, urlString: item.sponser_photo,palceHolder: "finca_logo")
              cell.lbSpanseNeme.text = item.sponser_name
              cell.lbLink.text = item.sponser_url
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
