//
//  BalanceSheetVc.swift
//  Finca
//
//  Created by harsh panchal on 08/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BalanceSheetVc: BaseVC {
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    
    @IBOutlet weak var viewNoData: UIView!
    // @IBOutlet weak var lblBalanceSheetTotal: UILabel!
    
    @IBOutlet weak var tbvbalanceSheet: UITableView!
    
    var balanceList = [BalancesheetModel]()
    
    let itemCell = "BalanceSheetCell"
    var menuTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        doGetBalanceSheetData()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvbalanceSheet.register(nib, forCellReuseIdentifier: itemCell)
        tbvbalanceSheet.delegate = self
        tbvbalanceSheet.dataSource = self
        addRefreshControlTo(tableView: tbvbalanceSheet)
        doInintialRevelController(bMenu: bMenu)
        viewNoData.clipsToBounds = true
        self.viewNoData.isHidden = true
        lbTitle.text = doGetValueLanguage(forKey: "balancesheets")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
       // balanceList.removeAll()
        doGetBalanceSheetData()
        refreshControl.endRefreshing()
    }
    
    func doGetBalanceSheetData(){
        print("get emergency contact")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "balancesheet_pdf":"balancesheet_pdf",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_type":doGetLocalDataUser().userType!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.balanceSheetController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BalanceSheetResponse.self, from:json!)
                    if response.status == "200" {
                        self.balanceList =  response.balancesheet
                        //  self.lblBalanceSheetTotal.text = doGetLocalDataUser().currency! + " " + response.cashOnHand
                        self.tbvbalanceSheet.reloadData()
                        self.viewNoData.isHidden = true
                    }else {
                        self.viewNoData.isHidden = false
                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
      
    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
        
    }
    
    
    @objc func onClickView(sender:UIButton) {
        
        let index = sender.tag
        //  let urlM = balanceList[index].balancesheet_pdf!
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetDetailsVC") as! BalanceSheetDetailsVC
        vc.balanceData = balanceList[index]
        vc.stringUrl = balanceList[index].balancesheet_pdf!
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*  let url = urlM.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
         
         let imageURL = URL(string: url!)
         print("url", imageURL)
         //Utils
         if UIPrintInteractionController.canPrint(imageURL!) {
         print(imageURL as Any)
         let printInfo = UIPrintInfo(dictionary: nil)
         printInfo.jobName = imageURL!.lastPathComponent
         printInfo.outputType = .photo
         
         let printController = UIPrintInteractionController.shared
         printController.printInfo = printInfo
         printController.showsNumberOfCopies = false
         
         printController.printingItem = imageURL
         
         printController.present(animated: true, completionHandler: nil)
         }*/
        
    }
}
extension BalanceSheetVc : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balanceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvbalanceSheet.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! BalanceSheetCell
        // cell.lblBalanceAmount.text =  doGetLocalDataUser().currency! + " " +  balanceList[indexPath.row].currentBalance
        // cell.lblSheetName.text = balanceList[indexPath.row].balancesheetName
        cell.lbCreateBy.text = "\(doGetValueLanguage(forKey: "created_by")) :"
        cell.lbTitle.text = balanceList[indexPath.row].balancesheet_name
        //  cell.lbUpdateDate.text = "Uploaded Date : " +  balanceList[indexPath.row].created_date
        cell.lblCreated.text = balanceList[indexPath.row].created_by
       // cell.lblFile.text = balanceList[indexPath.row].balancesheet_pdf
        //   let date = convertDateFormater(time[0]).split{$0 == "-"}.map(String.init)
        let time = balanceList[indexPath.row].created_date!.split{$0 == " "}.map(String.init)
        cell.lbDay.text = time[0]
        cell.lbMonth.text = time[1]
        cell.lbYear.text = time[2]
        
        DispatchQueue.main.async {
        cell.viewMain.clipsToBounds = true
        cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
        }
        
//        cell.bView.tag = indexPath.row
//        cell.bView.addTarget(self, action: #selector(onClickView(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
         let vc = storyboard?.instantiateViewController(withIdentifier: "idBalanceSheetDetailsVC") as! BalanceSheetDetailsVC
               vc.balanceData = balanceList[index]
               vc.stringUrl = balanceList[index].balancesheet_pdf!
               self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
}
