//
//  PollingDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class PollingDetailsVC: BaseVC {
    
    
    @IBOutlet weak var tbvPollingOptionList: UITableView!
    @IBOutlet weak var btnVoteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPollQuestion: UILabel!
    @IBOutlet weak var lblPollDescription: UITextView!
    @IBOutlet weak var lbTotalVotecount: UILabel!
    @IBOutlet weak var lbTitleDesc: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var btnVote: UIButton!
    //@IBOutlet weak var viewThankYou: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var selectedCell : Int!
    var pollingDetails : Voting!
    var itemCell = "VotingCell"
    var progressBarCell = "PollingProgressbarCell"
    var resultCell = "ElectionWinnerCell"
    var pollingResultList = [PollingResultModel]()
    var pollingOptionList = [PollingOptionModel]()
    
    @IBOutlet weak var viewThankYou: DashedBorderView!
    @IBOutlet weak var viewThankYouHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib2 = UINib(nibName: self.progressBarCell, bundle: nil)
        self.tbvPollingOptionList.register(nib2, forCellReuseIdentifier: self.progressBarCell)
        self.tbvPollingOptionList.delegate = self
        self.tbvPollingOptionList.dataSource = self
        viewThankYou.isHidden = true
        viewThankYouHeightConstraint.constant = 0
        lblPollQuestion.text = pollingDetails.votingQuestion
        lblPollDescription.text = pollingDetails.votingDescription
        lbResult.text = ""
        viewThankYou.clipsToBounds = true
        
        tbvPollingOptionList.bounces = false
      //  btnVote.isEnabled = false
        if pollingDetails.votingStatus == "0"{
            doGetPollingOptions()
        }else{
            self.tbvHeightConstraint.constant = 0
            self.tbvPollingOptionList.isHidden = true
            self.btnVoteHeightConstraint.constant = 0
            self.btnVote.isHidden = true
            self.viewThankYou.isHidden = false
            self.viewThankYouHeightConstraint.constant = 45
            doCallResultsApi()
        }
        
        self.btnVote.isHidden = true
        self.viewThankYou.isHidden = true
        
     //      self.sheetViewController!.handleScrollView(svMain)
    }
    
    override func viewWillLayoutSubviews() {
        self.tbvPollingOptionList.setNeedsLayout()
        self.view.setNeedsLayout()
        
    
       //     tbvHeightConstraint.constant = tbvPollingOptionList.contentSize.height
    
    }
    
    override func viewDidLayoutSubviews() {
        print("dddd == " , tbvPollingOptionList.contentSize.height)
        tbvHeightConstraint.constant = tbvPollingOptionList.contentSize.height
        var size = 310 + tbvPollingOptionList.contentSize.height
        if viewThankYou.isHidden{
            size = 310 - 45 + tbvPollingOptionList.contentSize.height
        }else if viewThankYou.isHidden && btnVote.isHidden{
            size = 250
        }else {
            size = 330 + tbvPollingOptionList.contentSize.height
        }
        self.sheetViewController?.resize(to: .fixed(size) , animated: true)
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        
        self.sheetViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnAddPoll(_ sender: Any) {
        
        let selectedRows = tbvPollingOptionList.indexPathsForSelectedRows
        
     //   print(" btnAddPoll == " , selectedRows?.count)
        if selectedRows?.count == nil {
         //   print(" sekse sek")
            self.toast(message:"Please select any option.", type: .Faliure)
        }else{
            selectedCell = selectedRows![0].row
            doAddPoll(selectedIndex: selectedCell)
        }
        
    }
    
    func doAddPoll(selectedIndex:Int!){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addVote":"addVote",
                      "voting_id":pollingDetails.votingId!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "voting_option_id":pollingOptionList[selectedIndex].votingOptionID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse  .self, from:json!)
                    if response.status == "200" {
                        self.tbvHeightConstraint.constant = 0
                        self.tbvPollingOptionList.isHidden = false
                        self.btnVoteHeightConstraint.constant = 0
                        self.btnVote.isHidden = true
                        self.viewThankYou.isHidden = false
                        self.viewThankYouHeightConstraint.constant = 45
//                        self.tbvPollingOptionList.tag = 2
//                        self.tbvPollingOptionList.reloadData()
                        self.doGetPollingOptions()  
                        self.toast(message: response.message, type: .Success)
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
    
    func doGetPollingOptions(){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingOptionList":"getVotingOptionList",
                      "voting_id":pollingDetails.votingId!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingOptionResponse.self, from:json!)
                    if response.status == "200" {
                        self.pollingOptionList.removeAll()
                        self.tbvPollingOptionList.reloadData()
                        if response.votingSubmitted == "201"{
                            self.pollingOptionList.append(contentsOf: response.option)
                            let nib1 = UINib(nibName: self.itemCell, bundle: nil)
                            self.tbvPollingOptionList.register(nib1, forCellReuseIdentifier: self.itemCell)
                            self.tbvPollingOptionList.delegate = self
                            self.tbvPollingOptionList.dataSource = self
                            self.tbvPollingOptionList.tag = 1
                            self.tbvPollingOptionList.reloadData()
                            self.btnVote.isHidden = false
                            self.viewThankYou.isHidden = true
                            
                        }else{
                            self.pollingOptionList.append(contentsOf: response.option)
                            self.btnVoteHeightConstraint.constant = 0
                            self.btnVote.isHidden = true
                            self.viewThankYou.isHidden = false
                            self.viewThankYouHeightConstraint.constant = 45
                            self.lbTotalVotecount.text = "Total " + response.totalVoting + " Votes"
                            self.tbvPollingOptionList.tag = 2
                            self.tbvPollingOptionList.reloadData()
                            self.toast(message: "your vote is already submitted!!..", type:.Success)
                        }
                    }else {
                        self.toast(message: response.message, type: .Success)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallResultsApi(){
        print("get polling results")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingResult":"getVotingResult",
                      "voting_id":pollingDetails.votingId!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingResultResponse.self, from:json!)
                    if response.status == "200" {
                        self.pollingResultList.append(contentsOf: response.result)
                        let nib = UINib(nibName: self.resultCell, bundle: nil)
                        self.tbvPollingOptionList.register(nib, forCellReuseIdentifier: self.resultCell)
                        self.tbvPollingOptionList.delegate = self
                        self.tbvPollingOptionList.dataSource = self
                        self.tbvPollingOptionList.isHidden = false
                        self.tbvPollingOptionList.tag = 3
                        self.tbvPollingOptionList.reloadData()
                        self.viewThankYou.isHidden = true
                        self.viewThankYouHeightConstraint.constant = 0
                        self.lbResult.text =  ""
                        self.lblPollDescription.text = ""
                        self.lbTitleDesc.text = ""
                         self.lbTotalVotecount.text = "Total " + response.totalVoting + " Votes"
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

extension PollingDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (tableView.tag) {
        case 1:
            return pollingOptionList.count
            
        case 2:
            return pollingOptionList.count
        case 3:
            return pollingResultList.count
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (tableView.tag) {
            
        case 1:
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! VotingCell
            cell.lblNomineeName.text = pollingOptionList[indexPath.row].optionName
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: progressBarCell, for: indexPath)as! PollingProgressbarCell
            cell.lblOptionName.text = pollingOptionList[indexPath.row].optionName
            cell.ivCheck.isHidden = true
            cell.progressBar.setProgress(Float(pollingOptionList[indexPath.row].votingPer)!/100, animated: false)
            cell.progressBar.progressTintColor = UIColor(named: "ColorPrimary")
            cell.lblPercentageProgress.text = pollingOptionList[indexPath.row].votingPer + " %"
            cell.selectionStyle = .none
            cell.viewProgress.layer.borderColor = UIColor(named: "ColorPrimary")?.cgColor
            cell.viewProgress.layer.borderWidth = 1
            return cell
            
        case 3:
           /* let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)as! ElectionWinnerCell
            cell.lblVoteCount.text = pollingResultList[indexPath.row].givenVote
            cell.lblNomineeName.text = pollingResultList[indexPath.row].optionName
            if indexPath.row == 0{
                
                cell.lblVoteCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                //cell.imgWinnerBackground.image = UIImage(named: "winner")
                cell.viewWinner.isHidden = false
            }else{
                cell.lblVoteCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.viewWinner.isHidden = true
            }
            cell.selectionStyle = .none*/
            
            
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: progressBarCell, for: indexPath)as! PollingProgressbarCell
            cell.lblOptionName.text = pollingResultList[indexPath.row].optionName
           
             cell.progressBar.setProgress(Float(pollingResultList[indexPath.row].votingPer)!/100, animated: false)
            cell.lblPercentageProgress.text = pollingResultList[indexPath.row].votingPer + " %"
            
            if indexPath.row == 0{
                if pollingResultList[indexPath.row].givenVote != "0" {
                    cell.lblOptionName.textColor = UIColor(named: "green 500")
                    cell.lblPercentageProgress.textColor = UIColor(named: "green 500")
                    cell.ivCheck.isHidden = false
                    cell.viewProgress.layer.borderColor = UIColor(named: "green 500")?.cgColor
                    cell.viewProgress.layer.borderWidth = 1
                    cell.progressBar.progressTintColor = UIColor(named: "green 500")
                } else {
                    cell.ivCheck.isHidden = true
                    cell.viewProgress.layer.borderColor = UIColor(named: "ColorPrimary")?.cgColor
                    cell.viewProgress.layer.borderWidth = 1
                    cell.progressBar.progressTintColor = UIColor(named: "ColorPrimary")
                }

            } else {
                cell.ivCheck.isHidden = true
                cell.viewProgress.layer.borderColor = UIColor(named: "ColorPrimary")?.cgColor
                cell.viewProgress.layer.borderWidth = 1
                cell.progressBar.progressTintColor = UIColor(named: "ColorPrimary")
                
            }
            
                       
            cell.selectionStyle = .none
            
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (tableView.tag) {
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 35
        case 3:
            return 50
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        selectedCell = indexPath.row
        //        tbvPollingOptionList.reloadData()
        //        btnVote.isEnabled = true
        
        switch (tableView.tag) {
        case 1:
            //            selectedCell = indexPath.row
            //            tbvPollingOptionList.reloadData()
           // btnVote.isEnabled = true
            break;
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
