//
//  HousiInfoVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation

struct ResponseGame : Codable {
    let message : String! //": "Get Game Successfully!",
    let status : String! //": "200"
    let game : [ItemGame]!
    
}
struct ItemGame : Codable {
    let game_over : Bool! //" : true,
    let game_time : String! //" : "11:30 AM",
    let no_of_question : Int! //" : 20,
    let sponser_url : String! //" : "https:\/\/www.apple.com",
    let game_end_time : String! //" : "2020-04-25 11:40 AM",
    let game_name : String! //" : "iOS Testing 24-04",
    let game_date : String! //" : "25 Apr 2020",
    let sponser_name : String! //" : "iOS Dev",
    let society_id : String! //" : "75",
    let sponser_photo : String! //" : "https:\/\/developesponser_id_1587793378.jpg",
    let room_id : String! //" : "51"
    
}
class HousiInfoVC: BaseVC {

    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var tblGame : UITableView!
    @IBOutlet weak var progressBar: NVActivityIndicatorView!
    var IsComeFromAppdelegate = ""
    var selectedItem = [ItemGame]()
    var fistTimeChange = true
    var FcmGameJoin : FcmHouseiGameJoin!
    var SocietyId = ""
    //@IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var lblLoading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblGame.isHidden = true
        tblGame.estimatedRowHeight = 80
        tblGame.rowHeight = UITableView.automaticDimension
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        btnHistory.setTitle(doGetValueLanguage(forKey: "history"), for: .normal)
        lblLoading.text = doGetValueLanguage(forKey: "loading")
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        doGetGameInfo()
        
    }
    override func viewDidAppear(_ animated: Bool) {
       if UIApplication.shared.statusBarOrientation.isLandscape {
            // activate landscape changes
         print("lande scape")
        doSetScreen()
       } else {
        print("prort")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    @IBAction func onClickBack(_ sender: Any) {
        
        if IsComeFromAppdelegate == "1"
        {
            Utils.setHome()
            
        }else{
            doPopBAck()
        }
    }
    @objc func onClickUrl(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblGame)
        let indexPathSelected = self.tblGame.indexPathForRow(at:buttonPosition)
        if selectedItem.count > 0
        {
            _ = self.tblGame.cellForRow(at: indexPathSelected!)!
            let url1 = selectedItem[indexPathSelected!.row].sponser_url ?? ""
            
            if url1 != "" {
                guard let url = URL(string: url1) else { return }
                UIApplication.shared.open(url)
            }
      
        }
        
    }
    @objc func onClickCheckHistory(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblGame)
        let indexPathSelected = self.tblGame.indexPathForRow(at:buttonPosition)
        if selectedItem.count > 0
        {
            _ = self.tblGame.cellForRow(at: indexPathSelected!)!
            let vc = storyboard?.instantiateViewController(withIdentifier: "idWinnerListVC") as! WinnerListVC
            vc.room_id =  selectedItem[indexPathSelected!.row].room_id
            pushVC(vc: vc)
        
        }
    }
    @IBAction func onClickHistory(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idGameHistoryVC") as! GameHistoryVC
      
        pushVC(vc: vc)
        
    }
    func doGetGameInfo() {
         progressBar.startAnimating()
        viewProgress.isHidden = false
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getGameNew":"getGameNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.housie_controller, parameters: params) {(json, error) in
            //  self.hideProgress()
            self.progressBar.stopAnimating()
            self.viewProgress.isHidden = true
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseGame.self, from:json!)
                    if response.status == "200" {
                        self.tblGame.isHidden = false
                    
                        self.selectedItem = response.game
                        if  self.selectedItem.count > 0
                        {
                            self.tblGame.reloadData()
                        }
                        self.viewNoData.isHidden = true
                    }else {
                        self.viewNoData.isHidden = false
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }

    }
    @IBAction func onClickEnglish(_ sender: Any) {
//        ivRadioHindi.image = UIImage(named: "radio-blank")
//        ivRadioEnglish.image = UIImage(named: "radio-selected")
//        ivRadioGujrati.image = UIImage(named: "radio-blank")
//        ivRadioHindi.setImageColor(color: .white)
//        ivRadioEnglish.setImageColor(color: .white)
//        ivRadioGujrati.setImageColor(color: .white)
    }
    @IBAction func onClickGujrati(_ sender: Any) {
//        ivRadioHindi.image = UIImage(named: "radio-blank")
//        ivRadioGujrati.image = UIImage(named: "radio-selected")
//        ivRadioEnglish.image = UIImage(named: "radio-blank")
//        ivRadioHindi.setImageColor(color: .white)
//        ivRadioEnglish.setImageColor(color: .white)
//        ivRadioGujrati.setImageColor(color: .white)
        
        
    }
    @IBAction func onClickHindi(_ sender: Any) {
//        ivRadioGujrati.image = UIImage(named: "radio-blank")
//        ivRadioHindi.image = UIImage(named: "radio-selected")
//        ivRadioEnglish.image = UIImage(named: "radio-blank")
//        ivRadioHindi.setImageColor(color: .white)
//        ivRadioEnglish.setImageColor(color: .white)
//        ivRadioGujrati.setImageColor(color: .white)
    }
    func doSetScreen() {
        DispatchQueue.main.async {
          let value = UIInterfaceOrientation.portrait.rawValue
          UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    override var shouldAutorotate: Bool {
          return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
extension HousiInfoVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellHousie
        let data = selectedItem[indexPath.row]
        cell.lbDate.text =  "\(doGetValueLanguage(forKey: "date")) : " + data.game_date
        cell.lbTime.text =  "\(doGetValueLanguage(forKey: "times")) : " + data.game_time
        cell.lbTopic.text =  "\(doGetValueLanguage(forKey: "topic")) : " + data.game_name
        cell.lbSponserName.text = data.sponser_name
        cell.lblLetsPlay.text = doGetValueLanguage(forKey: "let_s_play")
        if data.sponser_photo != nil && data.sponser_photo == ""
        {
            cell.HeightImagevw.constant = 0
            cell.btnSponserurl.isHidden = true
            
        }else
        {
            cell.HeightImagevw.constant = 110
            cell.btnSponserurl.isHidden = false
        }
        Utils.setImageFromUrl(imageView: cell.ivSponsers, urlString: data.sponser_photo)
        cell.BtncheckHistory.addTarget(self, action: #selector(onClickCheckHistory(_:)), for: .touchUpInside)
     
        cell.btnSponserurl.addTarget(self, action: #selector(onClickUrl(_:)), for: .touchUpInside)
        if data.game_over  {
            cell.VwPlay.isHidden = true
            cell.checkHistoryView.isHidden = false
            cell.lblcheckHistory.text = doGetValueLanguage(forKey: "check_out_history")
            //cell.BtncheckHistory.isHidden = false
//            cell.lblcheckHistory.isHidden = false
        }else
        {
            cell.checkHistoryView.isHidden = true
            //cell.lblcheckHistory.isHidden = true
            //cell.BtncheckHistory.isHidden = true
            cell.VwPlay.isHidden = false
            cell.VwPlay.transform = CGAffineTransform(rotationAngle: CGFloat(-45))
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = selectedItem[indexPath.row]
        if data.game_over {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "idWinnerListVC") as! WinnerListVC
                    vc.room_id =  selectedItem[indexPath.row].room_id
                    pushVC(vc: vc)
             } else {
                 let vc = storyboard?.instantiateViewController(withIdentifier: "idTicketViewVC") as! TicketViewVC
                 vc.selectedItem = data
                 pushVC(vc: vc)
             }
    }
}
class cellHousie : UITableViewCell
{
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTopic: UILabel!
    @IBOutlet weak var viewMainData: UIView!
    @IBOutlet weak var ivSponsers: UIImageView!
    @IBOutlet weak var lbSponserName: UILabel!
    @IBOutlet weak var VwPlay : UIView!
    @IBOutlet weak var btnSponserurl : UIButton!
    @IBOutlet weak var HeightImagevw: NSLayoutConstraint!
    @IBOutlet weak var lblcheckHistory:UILabel!
    @IBOutlet weak var BtncheckHistory:UIButton!
    @IBOutlet weak var checkHistoryView: UIView!
    @IBOutlet weak var lblLetsPlay: UILabel!
}
