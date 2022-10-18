//
//  SearchMemberVC.swift
//  Finca
//
//  Created by harsh panchal on 06/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SwiftUI

class SearchMemberVC: BaseVC {
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewFAB: UIView!
    @IBOutlet weak var tbvMemberList: UITableView!
    @IBOutlet weak var cvSelectedMembers: UICollectionView!
    var memberListCell = "SearchMemberCell"
    var selectedMemberCell = "SelectedMemberCell"
    var memberList = [MemberListModel]()
    var filteredArray = [MemberListModel]()
    var selectedMemberList = [MemberListModel]()
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var lbNoResult: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblAppbarText: UILabel!
   // @IBOutlet weak var lbNoData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfSearch.addTarget(self, action: #selector(filterMember(_:)), for: .editingChanged)
        tfSearch.delegate = self
        let tbvnib = UINib(nibName: memberListCell, bundle: nil)
        tbvMemberList.register(tbvnib, forCellReuseIdentifier: memberListCell)
        tbvMemberList.delegate = self
        tbvMemberList.dataSource = self
        tbvMemberList.allowsMultipleSelection = true
        tbvMemberList.separatorStyle = .none
      //  lblAppbarText.text = "\(doGetValueLanguage(forKey: "members_of")) " + doGetLocalDataUser().society_name!
        lblAppbarText.isHidden = true
        doGetUserList()
        viewNoData.isHidden = true
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_member")
        lbNoResult.text = doGetValueLanguage(forKey: "no_member_data")
    }
    
    @objc func filterMember(_ textField : UITextField!){
        filteredArray = textField.text!.isEmpty ? memberList : memberList.filter({ (item:MemberListModel) -> Bool in
            //let unitName = item.blockName + "-" + item.unitName
            return item.userFullName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.company_name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.user_designation.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil ||
                item.search_keyword.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        
        if filteredArray.count == 0 {
            viewNoData.isHidden = false
               
        } else {
            viewNoData.isHidden = true
               
        }
       tbvMemberList.reloadData()
    }
    
    
    @IBAction func keyboardDoneClicked(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    @IBAction func btnbackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doGetUserList() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMemberList":"getMemberList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_type":doGetLocalDataUser().userType!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "isCheckAccess" : "1"]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            print(json as Any)
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                    if response.status == "200" {
                           self.viewNoData.isHidden = true
                        self.memberList.append(contentsOf: response.member)
                        self.filteredArray =  self.memberList
                        self.tbvMemberList.reloadData()
                    }else {
                        self.viewNoData.isHidden = false
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func didSelectUser(with UserID : String!){
        for (index,item) in memberList.enumerated(){
            if item.userID == UserID{
                self.selectedMemberList.append(item)
                self.memberList.remove(at: index)
                self.view.endEditing(true)
                self.tfSearch.text = ""
            }
        }
        self.cvSelectedMembers.reloadData()
        self.filteredArray.removeAll(keepingCapacity: true)
        self.filteredArray = self.memberList
        self.tbvMemberList.reloadData()
    }
    
    func didRemoveSelectedMember(with UserID:String!){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    
}
extension SearchMemberVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredArray[indexPath.row]
       
        let cell = tbvMemberList.dequeueReusableCell(withIdentifier: memberListCell, for: indexPath)as! SearchMemberCell
        cell.selectionStyle = .none
        cell.lblMemberName.text = data.title//data.userFullName ?? ""
        
        if data.user_designation ?? "" != "" {
            cell.lbDesg.isHidden = false
            cell.lbDesg.text = data.user_designation ?? ""
        } else {
            cell.lbDesg.isHidden = true
        }
        
        Utils.setImageFromUrl(imageView: cell.imgSmallIcon, urlString: data.sub_title_icon, palceHolder: "buildingMember")
        cell.lblMemberUnitNo.text = data.sub_title//data.company_name ?? ""
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    @objc func onClickCall(sender : UIButton) {
        let index = sender.tag
        
        let phone = filteredArray[index].userMobile!
        if let url = URL(string: "tel:\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//        vc.user_id = data.userID
//       self.navigationController?.pushViewController(vc, animated: true)
//        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = data.userID!
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MemberDetailsVC()
        vc.user_id = data.userID ?? ""
        vc.userName =  ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
