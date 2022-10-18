//
//  ElectionResultDialog.swift
//  Finca
//
//  Created by harsh panchal on 14/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ElectionResultDialog: BaseVC {
    let itemcell = "ElectionResultCell"
    var electionData : ElectionDataModel!
    var upcomingElectionContext : TabUpcomingElectionVC!
    var completedElectionContext : TabCompletedElectionVC!

    var resultList = [ResultModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblElectionName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbTotalVote: UILabel!
    var electionResultResponse : ElectionResultResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDescription.text = electionData.electionDescription!
        self.lblElectionName.text = electionData.electionName!
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        tbvData.delegate = self
        tbvData.dataSource = self
        
        self.lbResult.text = doGetValueLanguage(forKey: "result")
        self.lbTotalVote.text = doGetValueLanguage(forKey: "total_votes")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.doGetResultData()
    }

    func doGetResultData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getElectionResult":"getElectionResult",
                      "election_id":electionData.electionId!,]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ElectionResultResponse.self, from:json!)
                    if response.status == "200" {
                        self.resultList.append(contentsOf: response.result)
                        self.lblVoteCount.text = response.totalVoting
                        self.electionResultResponse = response
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

    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ElectionResultDialog : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! ElectionResultCell
        let data = resultList[indexPath.row]
        if electionResultResponse.electionTie == nil {
            print("No data Available")
        }else{
        if self.electionResultResponse.electionTie{
            cell.progressBar.progressTintColor = ColorConstant.colorPrimarylVeryite
            cell.progressBar.trackTintColor = ColorConstant.colorPrimarylite.withAlphaComponent(0.25)
        }else{
            if indexPath.row == 0 && data.votingPer != "0"{
                cell.progressBar.progressTintColor = electionStatus.Nomination_Open.textColor()
                cell.progressBar.trackTintColor = electionStatus.Nomination_Open.backgroundColor()
            }else{
                cell.progressBar.progressTintColor = electionStatus.Voting_Closed.textColor()
                cell.progressBar.trackTintColor = electionStatus.Voting_Closed.backgroundColor()

            }
        }
        }
        cell.lblNomineeName.text =  data.optionName
        cell.lblVotePercent.text = data.votingPer + " %"
        cell.progressBar.setProgress(Float(data.votingPer)!/100, animated: false)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
