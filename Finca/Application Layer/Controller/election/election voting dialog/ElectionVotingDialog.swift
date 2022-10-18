//
//  ElectionVotingDialog.swift
//  Finca
//
//  Created by harsh panchal on 13/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ElectionVotingDialog: BaseVC {
    var electionData : ElectionDataModel!
    var upcomingElectionContext : TabUpcomingElectionVC!
    var completedElectionContext : TabCompletedElectionVC!
    var votingOptionList = [OptionModel]()
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblElectionName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var bVote: UIButton!
    
    let itemCell = "VotingOptionCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblDescription.text = electionData.electionDescription!
        self.lblElectionName.text = electionData.electionName!

        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.reloadData()
        tbvData.estimatedRowHeight = 50
        tbvData.rowHeight = UITableView.automaticDimension
        bVote.setTitle(doGetValueLanguage(forKey: "vote").uppercased(), for: .normal)
    }

    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func doCallRegisterVote(voteData : OptionModel!){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addElectionVote":"addElectionVote",
                      "election_id":electionData.electionId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "election_user_id":voteData.votingID!]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {

                        self.dismiss(animated: true) {
                            self.upcomingElectionContext == nil ? self.completedElectionContext.fetchNewDataOnRefresh() : self.upcomingElectionContext.fetchNewDataOnRefresh()
                            self.upcomingElectionContext == nil ? self.completedElectionContext.toast(message: response.message, type: .Success) : self.upcomingElectionContext.toast(message: response.message, type: .Success)
                        }
                    }else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }

    @IBAction func btnVoteClicked(_ sender: UIButton) {
        let selectedIndex = tbvData.indexPathForSelectedRow
        if selectedIndex != nil{
            let data = votingOptionList[selectedIndex!.row]
            self.doCallRegisterVote(voteData: data)
        }else{
            self.toast(message: doGetValueLanguage(forKey: "please_select_any_option"), type: .Warning)
        }
    }
}
extension ElectionVotingDialog : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votingOptionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = votingOptionList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! VotingOptionCell
        cell.lblOptionName.text = data.optionName

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
