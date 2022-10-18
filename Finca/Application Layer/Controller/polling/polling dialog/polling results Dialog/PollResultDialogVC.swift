//
//  PollResultDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 25/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class PollResultDialogVC: BaseVC {
    let itemcell = "ElectionResultCell"
    var pollData : Voting!
    var pollingResultResponse : PollingResultResponse!
    var pollingOptionData : PollingOptionResponse!
    var upcomingPollContext : TabUpcomingPolls!
    var completedPollContext : TabCompletedPolls!
    @IBOutlet weak var lblthankyou:UILabel!
    
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var viewThanks: UIView!
    
    @IBOutlet weak var ivStatus: UIImageView!
    var resultList = [PollingResultModel]()
   
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblElectionName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var lblTotlaVote: UILabel!
    //var electionResultResponse : ElectionResultResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTotlaVote.text = doGetValueLanguage(forKey: "total_votes")
        lblStatus.text = doGetValueLanguage(forKey: "result")
        self.lblDescription.text = pollData.votingDescription!
        self.lblElectionName.text = pollData.votingQuestion!
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        lblthankyou.text = doGetValueLanguage(forKey: "thanks_for_your_vote")
        tbvData.delegate = self
        tbvData.dataSource = self
        self.lblVoteCount.text = pollingOptionData.totalVoting
        if upcomingPollContext != nil{
            self.viewThanks.isHidden = false
            
        }else{
            self.viewThanks.isHidden = true
        }
        
        if pollData.votingStatus != nil && pollData.votingStatus == "0" {
          //  voting
            ivStatus.image = UIImage(named: "voting")
             self.lbResult.isHidden = true
        } else {
            //trophy
            ivStatus.image = UIImage(named: "trophy")
            self.lbResult.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.doGetPollResultData()
    }
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func doGetPollResultData(){
        showProgress()
        let params = [
                      "getVotingResult":"getVotingResult",
                      "voting_id":pollData.votingId!,
                      "language_id": doGetLanguageId()]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.voting_list_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingResultResponse.self, from:json!)
                    if response.status == "200" {
                        self.resultList = response.result
                        self.lblVoteCount.text = response.totalVoting
                        self.pollingResultResponse = response
                        self.tbvData.reloadData()
                    }else {
                        self.toast(message: response.message, type: .Information)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}
extension PollResultDialogVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! ElectionResultCell
        let data = resultList[indexPath.row]

          if pollData.votingStatus != nil && pollData.votingStatus == "0" {
            cell.progressBar.progressTintColor = ColorConstant.primaryColor
            cell.progressBar.trackTintColor =  ColorConstant.primaryColorAlpha
        
        } else {
            if indexPath.row == 0 && data.votingPer != "0"  && data.votingPer != resultList[indexPath.row < resultList.count - 1 ? (indexPath.row + 1) : indexPath.row ].votingPer {
                cell.progressBar.progressTintColor = electionStatus.Nomination_Open.textColor()
                cell.progressBar.trackTintColor = electionStatus.Nomination_Open.backgroundColor()
            }else{
                cell.progressBar.progressTintColor = electionStatus.Voting_Closed.textColor()
                cell.progressBar.trackTintColor = electionStatus.Voting_Closed.backgroundColor()
           }
        }
        cell.lblNomineeName.text =  data.optionName
        cell.lblVotePercent.text = data.votingPer + " %"
        cell.progressBar.setProgress(Float(data.votingPer)!/100, animated: false)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

