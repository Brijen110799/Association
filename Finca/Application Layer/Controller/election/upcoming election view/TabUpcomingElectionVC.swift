//
//  TabUpcomingElectionVC.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
import XLPagerTabStrip
enum electionStatus : String{
    case Nomination_Open  = "0"
    case Voting_Open = "1"
    case Result_Published = "2"
    case Voting_Closed = "3"

    func backgroundColor() -> UIColor {
        switch self {
        case .Result_Published , .Voting_Open , .Nomination_Open:
            return #colorLiteral(red: 0.1647058824, green: 0.7215686275, blue: 0.1490196078, alpha: 0.25)
        case .Voting_Closed:
            return #colorLiteral(red: 1, green: 0.2392156863, blue: 0.2431372549, alpha: 0.26)
        }

    }

    func textColor() -> UIColor{
        switch self {
        case .Result_Published , .Voting_Open , .Nomination_Open:
            return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
        case .Voting_Closed:
            return #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 1)
        }
    }
}
class TabUpcomingElectionVC: BaseVC {

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lbNoData: UILabel!
    var menuTitle : String!
    var context : ElectionPagerVC!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    var itemCell = "ElectionCell"
    @IBOutlet weak var tbvData: UITableView!

    var electionList = [ElectionDataModel](){
        didSet{
            self.filterList = self.electionList
        }
    }

    var filterList = [ElectionDataModel](){
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
        self.addRefreshControlTo(tableView: tbvData)
        doneButtonOnKeyboard(textField: [tfSearch])
        tfSearch.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        Utils.setImageFromUrl(imageView: imgNoData , urlString: getPlaceholderLocal(key: menuTitle))
          self.getElectionDetails()
        
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_election")
        tfSearch.clearButtonMode = .whileEditing
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
    }

    @objc func searchChanged(_ sender : UITextField) {
        filterList = sender.text!.isEmpty ? electionList : electionList.filter({ (item:ElectionDataModel) -> Bool in

            return item.electionName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.electionStatusView.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
    }

    override func fetchNewDataOnRefresh() {
        self.refreshControl.beginRefreshing()
        self.electionList.removeAll()
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
        
        self.getElectionDetails()
        self.refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.electionList.removeAll()
        //fetchNewDataOnRefresh()
    }

    func getElectionDetails(){
        self.showProgress()
        let params = ["getElectionListNew":"getElectionListNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "userType":doGetLocalDataUser().userType!,
                      "user_id":doGetLocalDataUser().userID!,
                      "member_status":doGetLocalDataUser().memberStatus!,
                      "unit_id":doGetLocalDataUser().unitID!]
        
        let request = AlamofireSingleTon.sharedInstance
        print(params)

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (Data, error) in
            self.hideProgress()
            if Data != nil{
              
                do{
                    let response = try JSONDecoder().decode(ElectionListReponse.self, from: Data!)
                    if response.status == "200"{
                        self.electionList =  response.election
                        
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    func doGetOptions(electionData :ElectionDataModel! ,completionHandler :  @escaping(VotingOptionResponse)->()){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getElectionOptionList":"getElectionOptionList",
                      "election_id":electionData.electionId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(VotingOptionResponse.self, from:json!)
                    if response.status == "200" {
                        completionHandler(response)
                    }else {
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}
extension TabUpcomingElectionVC : UITableViewDelegate , UITableViewDataSource{

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
        cell.lblElectionTitle.text = data.electionName
        cell.lblElectionAddedBy.text = data.electionCreatedBy
        cell.lblElectionStartDate.text = data.electionDate
        cell.lblElectionStatus.text = data.electionStatusView
        cell.lbBy.text = doGetValueLanguage(forKey: "by")
        cell.lbStartDate.text = doGetValueLanguage(forKey: "start_date")
        switch data.electionStatus {
        case electionStatus.Nomination_Open.rawValue:
            cell.viewStatus.backgroundColor = electionStatus.Nomination_Open.backgroundColor()
            cell.lblElectionStatus.textColor = electionStatus.Nomination_Open.textColor()
            break
        case electionStatus.Voting_Open.rawValue:
            cell.viewStatus.backgroundColor = electionStatus.Voting_Open.backgroundColor()
            cell.lblElectionStatus.textColor = electionStatus.Voting_Open.textColor()
            break
        case electionStatus.Result_Published.rawValue:
            cell.viewStatus.backgroundColor = electionStatus.Result_Published.backgroundColor()
            cell.lblElectionStatus.textColor = electionStatus.Result_Published.textColor()
            break
        case electionStatus.Voting_Closed.rawValue:
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

        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        switch data.electionStatus {
        case electionStatus.Nomination_Open.rawValue:
            let vc = ElectionDialog(nibName: "ElectionDialog", bundle: nil)
            vc.electionData = data
            vc.upcomingElectionContext = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
            break;
        case electionStatus.Voting_Open.rawValue:

            self.doGetOptions(electionData: data) { (response) in
                print(response)
                if response.votingSubmitted == "201"{

                    let vc = ElectionVotingDialog(nibName: "ElectionVotingDialog", bundle: nil)
                    vc.votingOptionList.append(contentsOf: response.option)
                    vc.electionData = data
                    vc.upcomingElectionContext = self
                    let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
                    popupVC.backgroundAlpha = 0.8
                    popupVC.backgroundColor = .black
                    popupVC.shadowEnabled = true
                    popupVC.canTapOutsideToDismiss = true
                    self.present(popupVC, animated: true)

                }else{
                    let vc = ElectionDialog(nibName: "ElectionDialog", bundle: nil)
                    vc.electionData = data
                    vc.upcomingElectionContext = self
                    vc.isVoteSubmited = true
                    let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
                    popupVC.backgroundAlpha = 0.8
                    popupVC.backgroundColor = .black
                    popupVC.shadowEnabled = true
                    popupVC.canTapOutsideToDismiss = true
                    self.present(popupVC, animated: true)
                }
            }
            break;
        case electionStatus.Result_Published.rawValue:
            let vc = ElectionDialog(nibName: "ElectionDialog", bundle: nil)
            vc.electionData = data
            vc.upcomingElectionContext = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            self.present(popupVC, animated: true)
            break;
        case electionStatus.Voting_Closed.rawValue:
            let vc = ElectionDialog(nibName: "ElectionDialog", bundle: nil)
            vc.electionData = data
            vc.upcomingElectionContext = self
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
            break;
        default:
            break
        }

    }
}
extension TabUpcomingElectionVC :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "upcoming").uppercased())
    }
}
