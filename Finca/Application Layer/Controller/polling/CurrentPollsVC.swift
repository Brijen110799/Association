//
//  CurrentPollsVC.swift
//  Finca
//
//  Created by Hardik on 5/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FittedSheets

// MARK: - PollingNewResponse
struct PollingNewResponse: Codable {
    let voting: [Voting]!
    let votingCompleted: [Voting]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case voting = "voting"
        case votingCompleted = "voting_completed"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Voting
struct Voting: Codable {
    let votingId: String!
    let societyId: String!
    let votingQuestion: String!
    let votingDescription: String!
    let votingStartDate: String!
    let votingEndDate: String!
    let votingStatus: String!
    let votingStatusView: String!

    enum CodingKeys: String, CodingKey {
        case votingId = "voting_id"
        case societyId = "society_id"
        case votingQuestion = "voting_question"
        case votingDescription = "voting_description"
        case votingStartDate = "voting_start_date"
        case votingEndDate = "voting_end_date"
        case votingStatus = "voting_status"
        case votingStatusView = "voting_status_view"
    }
}

class CurrentPollsVC: BaseVC {
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var tbvPoll: UITableView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewClear: UIView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    var itemCell = "PollingCell"
    var pollingQuesList = [Voting]()
    var filterPollingQuesList = [Voting]()
    var flagViewRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        doGetPollingQuestions()
        addRefreshControlTo(tableView: tbvPoll)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvPoll.register(nib, forCellReuseIdentifier: itemCell)
        tbvPoll.delegate = self
        tbvPoll.dataSource = self
        tbvPoll.estimatedRowHeight = 50
        tbvPoll.rowHeight = UITableView.automaticDimension
        
        viewClear.isHidden  = true
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_poll"))
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data_available")
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filterPollingQuesList = textField.text!.isEmpty ? pollingQuesList : pollingQuesList.filter({ (item:Voting) -> Bool in
            
            return item.votingQuestion.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.votingDescription!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        if textField.text == "" {
            self.viewClear.isHidden  = true
        } else {
            self.viewClear.isHidden  = false
        }
        
        if textField.text == "" {
            self.tfSearch.isHidden = true
        }else {
            self.tfSearch.isHidden = false
        }
        if filterPollingQuesList.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
        tbvPoll.reloadData()
    }
    
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        view.endEditing(true)
        hidePull()
        viewClear.isHidden  = true
        refreshControl.beginRefreshing()
        // pollingQuesList.removeAll()
        tbvPoll.reloadData()
        doGetPollingQuestions()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if flagViewRefresh {
            //pollingQuesList.removeAll()
            doGetPollingQuestions()
        } else {
            
           // viewNoData.isHidden = false
            
        }
        
    }
    
    func doGetPollingQuestions(){
        print("delete success")
        self.showProgress()
        let params = [
                      "getVotingListNew":"getVotingListNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingNewResponse.self, from:json!)
                    if response.status == "200" {
                        self.pollingQuesList = response.voting
                        self.filterPollingQuesList =  self.pollingQuesList
                        self.tbvPoll.reloadData()
                    }else {
                        if self.filterPollingQuesList.count == 0 {
                            self.viewNoData.isHidden = false
                    
                            self.viewSearchBar.isHidden = false
                        }else{
                            self.viewNoData.isHidden = true
                            self.viewSearchBar.isHidden = false
                        }
                        self.pollingQuesList.removeAll()
                        self.filterPollingQuesList.removeAll()
                        self.tbvPoll.reloadData()
                        //                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func onClickClear(_ sender: Any) {
        
        filterPollingQuesList = pollingQuesList
        viewNoData.isHidden = true
        viewClear.isHidden  = true
        tbvPoll.reloadData()
        tfSearch.text = ""
        view.endEditing(true)
        
    }
    
    
    
}

extension CurrentPollsVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "current").uppercased())
    }
}

extension CurrentPollsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterPollingQuesList.count == 0 {
            viewNoData.isHidden = false
            self.viewSearchBar.isHidden = false
        }else{
            viewNoData.isHidden = true
            self.viewSearchBar.isHidden = false
        }
        return filterPollingQuesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvPoll.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! PollingCell
        cell.lblPollingQues.text = filterPollingQuesList[indexPath.row].votingQuestion
        cell.lbDate.text =  filterPollingQuesList[indexPath.row].votingStartDate
        cell.lbEndDate.text =  filterPollingQuesList[indexPath.row].votingEndDate
        cell.lblStartDateTitle.text = doGetValueLanguage(forKey: "start_date")
        cell.lblEndDateTitle.text = doGetValueLanguage(forKey: "end_date")
        switch (pollingQuesList[indexPath.row].votingStatus) {
        case "0":
            cell.lblPollingStatus.text = "Open"
            cell.viewStatus.backgroundColor = ColorConstant.green500
            // cell.lblPollingStatus.textColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
            break;
        case "1":
            cell.lblPollingStatus.text = "Closed"
            cell.viewStatus.backgroundColor = ColorConstant.red500
            // cell.lblPollingStatus.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            break
        default:
            break;
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idPollingDetailsVC")as! PollingDetailsVC
         nextVC.pollingDetails = pollingQuesList[indexPath.row]
         flagViewRefresh = true
         self.navigationController?.pushViewController(nextVC, animated: true)*/
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idPollingDetailsVC") as! PollingDetailsVC
        //         vc.pollingDetails = pollingQuesList[indexPath.row]
        //        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //        self.addChild(vc)
        //        self.view.addSubview(vc.view)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idPollingDetailsVC") as! PollingDetailsVC
        
        vc.pollingDetails = filterPollingQuesList[indexPath.row]
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(310)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = false
        sheetController.dismissOnPan = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 5)
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false ,completion:nil)
    }
}
