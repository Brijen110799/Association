//
//  ElectionDialog.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ElectionDialog:  BaseVC {
    var electionData : ElectionDataModel!

    var upcomingElectionContext : TabUpcomingElectionVC!
    var completedElectionContext : TabCompletedElectionVC!

    var isVoteSubmited = false
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblElectionName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewThanks: UIView!
    @IBOutlet weak var viewStatusBG: UIView!
    @IBOutlet weak var viewStatusContainer: UIView!
    @IBOutlet weak var viewButtonContainer: UIView!
    
    @IBOutlet weak var bAppyNomination: UIButton!
    
    @IBOutlet weak var lbThankVote: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(electionData as Any)
        self.lblDescription.text = electionData.electionDescription!
        self.lblElectionName.text = electionData.electionName!
        
        bAppyNomination.setTitle(doGetValueLanguage(forKey: "apply_for_nomination").uppercased(), for: .normal)
        lbThankVote.text = doGetValueLanguage(forKey: "for_your_vote_nplease_wait_for_result")
    }

    override func viewWillAppear(_ animated: Bool) {
        if isVoteSubmited{
            self.viewStatusContainer.isHidden = true
            self.viewButtonContainer.isHidden = true
            self.viewThanks.isHidden = false
        }else{

            self.getStatus(electionId: electionData.electionId!, userID: self.doGetLocalDataUser().userID!)

        }
    }

    @IBAction func btnApplyForNominationClicked(_ sender: UIButton) {
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "ApplyForNomination":"ApplyForNomination",
                      "election_id":electionData.electionId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().userFullName!]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.dismiss(animated: true) {


                            self.upcomingElectionContext == nil ? self.completedElectionContext.toast(message: response.message, type: .Information): self.upcomingElectionContext.toast(message: response.message, type: .Information)
                            self.upcomingElectionContext == nil ? self.completedElectionContext.fetchNewDataOnRefresh() : self.upcomingElectionContext.fetchNewDataOnRefresh()
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
    func getStatus(electionId:String!,userID:String!){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "ApplyStatus":"ApplyStatus",
                      "election_id":electionId!,
                      "user_id":userID!,
                      "unit_id":doGetLocalDataUser().unitID!]

        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        switch self.electionData.electionStatus! {
                        case "1":
                            self.viewButtonContainer.isHidden = true
                            self.viewStatusContainer.isHidden = false
                            break;
                        case "2" ,"0":
                            self.lblStatus.text = response.message
                            self.viewStatusContainer.isHidden = false
                            break;
                        case "3":
                            self.viewStatusContainer.isHidden = false
                           // self.lblStatus.text = "Election is closed.\nResult will be publish soon."
                            self.lblStatus.text = self.doGetValueLanguage(forKey: "election_close")
                            self.viewButtonContainer.isHidden = true
                            break
                        default:
                            self.viewStatusContainer.isHidden = true
                            self.viewButtonContainer.isHidden = true
                        }

                    }else{
                        if self.electionData.electionStatus == electionStatus.Nomination_Open.rawValue{
                            self.viewButtonContainer.isHidden = false
                            self.viewStatusContainer.isHidden = true
                        }else{
                           self.viewStatusContainer.isHidden = false
                            self.lblStatus.text = self.doGetValueLanguage(forKey: "election_close")
                            self.viewButtonContainer.isHidden = true
                        }
                    }
                    print(json as Any)
                } catch {
                    print("parse error ", error as Any)
                }
            }
        }
    }

    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
