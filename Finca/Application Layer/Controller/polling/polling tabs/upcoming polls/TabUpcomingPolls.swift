//
//  TabUpcomingPolls.swift
//  Finca
//
//  Created by harsh panchal on 25/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//
import EzPopup
import UIKit
import XLPagerTabStrip
class TabUpcomingPolls: BaseVC {
    var menuTitle : String!
    var context : PollingPagerVC!

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var itemCell = "ElectionCell"
    var pollingList = [Voting](){
        didSet{
            self.filterList = self.pollingList
        }
    }
    var filterList = [Voting](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.estimatedRowHeight = 200
        tbvData.rowHeight = UITableView.automaticDimension
        doneButtonOnKeyboard(textField: [tfSearch])
        tfSearch.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_poll"))
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data_available")
        Utils.setImageFromUrl(imageView: imgNoData , urlString: getPlaceholderLocal(key: menuTitle))
        self.addRefreshControlTo(tableView: tbvData)
        self.doGetPollingQuestions()
        tfSearch.clearButtonMode = .whileEditing
    }

    @objc func searchChanged(_ sender : UITextField) {
        filterList = sender.text!.isEmpty ? pollingList : pollingList.filter({ (item:Voting) -> Bool in

            return item.votingQuestion.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
    }

    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        view.endEditing(true)
        hidePull()
        self.refreshControl.beginRefreshing()
        self.pollingList.removeAll()
        self.doGetPollingQuestions()
        self.refreshControl.endRefreshing()
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
                        self.pollingList = response.voting

                    }else {

                        self.pollingList.removeAll()

                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }


    func doGetPollingOptions(pollData : Voting!){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingOptionList":"getVotingOptionList",
                      "voting_id":pollData.votingId!,
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

                        let screenwidth = UIScreen.main.bounds.width
                        let screenheight = UIScreen.main.bounds.height
                        if response.votingSubmitted == "201"{
                            let nextVC = PollOptionDailogVC(nibName: "PollOptionDailogVC", bundle: nil)
                            nextVC.pollData = pollData
                            nextVC.pollingOptionData = response
                            nextVC.pollOptionList.append(contentsOf: response.option)
                            nextVC.upcomingPollContext = self
                            let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
                            popupVC.backgroundAlpha = 0.8
                            popupVC.backgroundColor = .black
                            popupVC.shadowEnabled = true
                            popupVC.canTapOutsideToDismiss = false
                            self.present(popupVC, animated: true)
                        }else{
                            let nextVC = PollResultDialogVC(nibName: "PollResultDialogVC", bundle: nil)
//                            nextVC.resultList.append(contentsOf: response.option)
                             nextVC.pollData = pollData
                            nextVC.pollingOptionData = response
                            nextVC.upcomingPollContext = self
                            let popupVC = PopupViewController(contentController:nextVC , popupWidth: screenwidth  , popupHeight: screenheight)
                            popupVC.backgroundAlpha = 0.8
                            popupVC.backgroundColor = .black
                            popupVC.shadowEnabled = true
                            popupVC.canTapOutsideToDismiss = false
                            self.present(popupVC, animated: true)
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
}

extension TabUpcomingPolls :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "current").uppercased())
    }
}
extension TabUpcomingPolls : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewNoData.isHidden = filterList.count == 0 ? false : true
        if !tfSearch.isEditing{
            self.viewSearch.isHidden = filterList.count == 0 ? true : false
        }
        return filterList.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filterList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ElectionCell
        cell.lblElectionTitle.text = data.votingQuestion
        cell.viewCreator.isHidden = true
        cell.viewEndDate.isHidden = false
        cell.lblEndDate.text = data.votingEndDate
        cell.lblElectionStartDate.text = data.votingStartDate
        cell.lblElectionStatus.text = data.votingStatusView
        cell.lblStartDate.text = doGetValueLanguage(forKey: "start_date")
        cell.lblElectionEndDate.text = doGetValueLanguage(forKey: "end_date")
        switch data.votingStatus {
        case "0":
            cell.viewStatus.backgroundColor = electionStatus.Nomination_Open.backgroundColor()
            cell.lblElectionStatus.textColor = electionStatus.Nomination_Open.textColor()
            break
        case "1":
            cell.viewStatus.backgroundColor = electionStatus.Voting_Closed.backgroundColor()
            cell.lblElectionStatus.textColor = electionStatus.Voting_Closed.textColor()
            break
        default:
            break
        }
        cell.reloadInputViews()
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let data = filterList[indexPath.row]

        doGetPollingOptions(pollData: data)

    }
}
