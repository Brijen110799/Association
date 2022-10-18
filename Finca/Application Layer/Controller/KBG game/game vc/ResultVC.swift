//
//  ResultVC.swift
//  Finca
//
//  Created by Hardik on 5/8/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

// MARK: - KBGResultResponse
struct KBGResultResponse: Codable {
    let winnerUsers: [WinnerUser]!
    let status: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case winnerUsers = "winnerUsers"
        case status = "status"
        case message = "message"
    }
}

// MARK: - WinnerUser
struct WinnerUser: Codable {
    let userId: String!
    let userName: String!
    let gender: String!
    let winingPoint: String!
    let currectAnswer: String!
    let kbgGameName: String!
    let categoryName: String!
    let gameDate: String!
    let userProfilePic: String!
    let sponsorImage: String!
    let kbgGameSponsorName: String!
    let sponsorUrl: String!
    let unitName : String!
    enum CodingKeys: String, CodingKey {
        case unitName = "unit_name"
        case userId = "user_id"
        case userName = "user_name"
        case gender = "gender"
        case winingPoint = "wining_point"
        case currectAnswer = "currect_answer"
        case kbgGameName = "kbg_game_name"
        case categoryName = "category_name"
        case gameDate = "game_date"
        case userProfilePic = "user_profile_pic"
        case sponsorImage = "sponsor_image"
        case kbgGameSponsorName = "kbg_game_sponsor_name"
        case sponsorUrl = "sponsor_url"
    }
}


class ResultVC: BaseVC {
    
    @IBOutlet weak var ivGame: UIImageView!
    @IBOutlet weak var lblSponsor: UILabel!
    @IBOutlet weak var lblGamename: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    
    @IBOutlet weak var btnShareOnTimeLine: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var stackViewSponser: UIStackView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblSponserTitle: UILabel!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblShareOnTimeLine: UILabel!
    
    var item : Game!
    var resultList = [WinnerUser]()
    let itemcell = "ResultCell"
     var context : GeneralKnowledgeGameVC!
    var comefromCard = ""
    var cardImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        tbvData.delegate = self
        tbvData.dataSource = self
        
        if item.kbgGameSponsorName != nil && item.kbgGameSponsorName != "" {
            stackViewSponser.isHidden = false
            lblSponsor.text = item.kbgGameSponsorName
        }
       
        lblGamename.text = item.kbgGameName
        lblCategory.text = item.categoryName
        lblScreenTitle.text = doGetValueLanguage(forKey: "results")
        lblSponserTitle.text = doGetValueLanguage(forKey: "sponser_by")
        lblCategoryTitle.text = doGetValueLanguage(forKey: "category")
        lblShareOnTimeLine.text = doGetValueLanguage(forKey: "share_on_timeline")
        Utils.setImageFromUrl(imageView: ivGame, urlString: item.sponsorImage)
        tbvData.separatorStyle = .none
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    @IBAction func onClickShareTimeLine(_ sender: Any) {
       // var flag = false
        for winner in resultList{
            if winner.userId == doGetLocalDataUser().userID{
                //flag = true
                let itemuser = winner
                let nextVC = storyboardConstants.kbg.instantiateViewController(withIdentifier: "idShareOnTimeLineVC")as! ShareOnTimeLineVC
                 nextVC.item = itemuser
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.myOrientation = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIView.setAnimationsEnabled(true)
                pushVC(vc: nextVC)
                break
            }else{
                
                self.showAlertMessage(title: "", msg: "You haven't participaed this game!")
            }
      
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        dolandscape()
        doPopBAck()
    }
    func dolandscape() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func viewWillAppear(_ animated: Bool) {
        doSetScreen()
    }
    func doSetScreen() {
        print("doSetScreen")
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
        doResultAPI()
    }
    func doResultAPI(){
        DispatchQueue.main.async {
            self.showProgress()
        }
        
        let param = ["getResult":"getResult",
                     "society_id": doGetLocalDataUser().societyID!,
                     "user_id":doGetLocalDataUser().userID!,
                     "kbg_game_id":item.kbgGameId!]
        print(param)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName:  ServiceNameConstants.kbgController, parameters: param) { (Data, Error) in
            
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(KBGResultResponse.self, from: Data!)
                    if response.status == "200"{
                        self.resultList = response.winnerUsers
                        self.tbvData.reloadData()
                    }else{
                        self.shareView.isHidden = true
                        print("201")
                    }
                }catch{
                    print("error")
                }
            }else{
                print("Parse error")
            }
        }
    }
}
extension ResultVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! ResultCell
        let data = resultList[indexPath.row]
        if indexPath.row == 0{
            cell.imgCrown.isHidden = false
        }
        Utils.setImageFromUrl(imageView: cell.imgPlayerPic, urlString: data.userProfilePic, palceHolder: "user_default")
        cell.lblDate.text = "Points Won\n(\(data.gameDate!))"
        cell.lblPlayerName.text = data.userName
        cell.lblUnitNum.text = data.unitName
        cell.lblPointsWon.text = data.winingPoint
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
