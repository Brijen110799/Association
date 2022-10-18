//
//  TabCompletedElectionVC.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EzPopup
class TabCompletedElectionVC: BaseVC {
    var menuTitle : String!
    var context : ElectionPagerVC!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    var itemCell = "ElectionCell"
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lbNoData: UILabel!
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
        Utils.setImageFromUrl(imageView: imgNoData , urlString: getPlaceholderLocal(key: menuTitle))
        doneButtonOnKeyboard(textField: [tfSearch])
        tfSearch.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        self.getElectionDetails()
        addRefreshControlTo(tableView: tbvData)
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_election")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
    }
    @objc func searchChanged(_ sender : UITextField) {
        filterList = sender.text!.isEmpty ? electionList : electionList.filter({ (item:ElectionDataModel) -> Bool in

            return item.electionName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.electionStatusView.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil        })
    }


    override func fetchNewDataOnRefresh() {
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
        
        self.getElectionDetails()
        
        hidePull()
    }

    override func viewWillAppear(_ animated: Bool) {
        // self.electionList.removeAll()
        //  fetchNewDataOnRefresh()
    }

    func getElectionDetails(){
        self.showProgress()
        let params = ["getElectionListNew":"getElectionListNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "userType":doGetLocalDataUser().userType!,
                      "user_id":doGetLocalDataUser().userID!,
                      "member_status":doGetLocalDataUser().memberStatus!,
                      "language_id" :doGetLanguageId()]
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (Data, error) in
            self.hideProgress()
            if Data != nil{
                
                do{
                    let response = try JSONDecoder().decode(ElectionListReponse.self, from: Data!)
                    if response.status == "200"{
                        self.electionList = response.electionCompleted
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

}

extension TabCompletedElectionVC : UITableViewDelegate , UITableViewDataSource{
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
        case electionStatus.Result_Published.rawValue:
            let vc = ElectionResultDialog(nibName: "ElectionResultDialog", bundle: nil)
            vc.electionData = data
            vc.completedElectionContext = self
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
            vc.completedElectionContext = self
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

extension TabCompletedElectionVC :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
          return IndicatorInfo(title: doGetValueLanguage(forKey: "completed"))
    }
}
