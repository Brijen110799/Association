//
//  PollOptionDailogVC.swift
//  Finca
//
//  Created by harsh panchal on 26/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class PollOptionDailogVC: BaseVC {
    var pollData : Voting!
    var upcomingPollContext : TabUpcomingPolls!
    var pollOptionList = [PollingOptionModel]()
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPollName: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewbtnVote: UIView!
    @IBOutlet weak var imgattach: UIImageView!
    @IBOutlet weak var viewStatus: UIView!

    @IBOutlet weak var btnVote: UIButton!
    @IBOutlet weak var viewDescription: UIView!
    
    
    let itemCell = "VotingOptionCell"
    var pollingOptionData : PollingOptionResponse!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblDescription.text = pollData.votingDescription!
        self.lblPollName.text = pollData.votingQuestion!
        self.viewDescription.isHidden = pollData.votingDescription ?? "" == "" ? true : false
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.estimatedRowHeight = 50
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.reloadData()

        if pollingOptionData.votingStatus == "2"{
            self.viewStatus.isHidden = true
            self.viewbtnVote.isHidden = true
            self.toast(message: pollingOptionData.votingStatusView, type: .Faliure)
        }else if pollingOptionData.votingStatus == "1"{
            self.viewStatus.isHidden = true
            self.viewbtnVote.isHidden = true
            self.toast(message: pollingOptionData.votingStatusView, type: .Faliure)
        }else{
            self.viewStatus.isHidden = true
            self.viewbtnVote.isHidden = false
        }
        btnVote.setTitle(doGetValueLanguage(forKey: "vote").uppercased(), for: .normal)
    }

    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnAttchShow(_ sender: UIButton) {
       
    }
    func doAddPoll(data:PollingOptionModel!){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addVote":"addVote",
                      "voting_id":pollData.votingId!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "voting_option_id":data.votingOptionID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse  .self, from:json!)
                    if response.status == "200" {
                        self.dismiss(animated: true) {
                            self.upcomingPollContext.toast(message: response.message, type: .Success)
                            self.upcomingPollContext.doGetPollingOptions(pollData: self.pollData)

                        }
                    }else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error",error as Any)
                }
            }
        }
    }

    @IBAction func btnVoteClicked(_ sender: UIButton) {
        let selectedIndex = tbvData.indexPathForSelectedRow
        if selectedIndex != nil{
            let data = pollOptionList[selectedIndex!.row]
            self.doAddPoll(data: data)
        }else{
            self.toast(message: "Please select a option first!", type: .Warning)
        }
    }
}
extension PollOptionDailogVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pollOptionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = pollOptionList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! VotingOptionCell
        cell.lblOptionName.text = data.optionName

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
