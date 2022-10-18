//
//  AddMoreMembersVC.swift
//  Finca
//
//  Created by harsh panchal on 11/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class AddMoreMembersVC: BaseVC {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewFAB: UIView!
    @IBOutlet weak var tbvMemberList: UITableView!
    @IBOutlet weak var cvSelectedMembers: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var memberListCell = "MemberListCell"
    var selectedMemberCell = "SelectedMemberCell"
    var memberList = [MemberListModel]()
    var filteredArray = [MemberListModel]()
    var selectedMemberList = [MemberListModel]()
    var groupDetail : MemberListModel!
    
    @IBOutlet weak var lbNoResult: UILabel!
    @IBOutlet weak var lblSelectGrpMember: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tfSearch.addTarget(self, action: #selector(filtering(_:)), for: .editingChanged)
        let tbvnib = UINib(nibName: memberListCell, bundle: nil)
        tbvMemberList.register(tbvnib, forCellReuseIdentifier: memberListCell)
        tbvMemberList.delegate = self
        tbvMemberList.dataSource = self
        tbvMemberList.allowsMultipleSelection = true
        tbvMemberList.backgroundColor = UIColor(named: "app_background")
        
        let cvnib = UINib(nibName: selectedMemberCell, bundle: nil)
        cvSelectedMembers.register(cvnib, forCellWithReuseIdentifier: selectedMemberCell)
        cvSelectedMembers.delegate = self
        cvSelectedMembers.dataSource = self
        doGetUserList()
        lbNoResult.isHidden = true
        lblSelectGrpMember.text = doGetValueLanguage(forKey: "select_group_members")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search"))
        lbNoResult.text = doGetValueLanguage(forKey: "no_data")
    }
    
    @objc func filtering(_ textField : UITextField!){
        
          filteredArray = textField.text!.isEmpty ? memberList : memberList.filter({ (item:MemberListModel) -> Bool in
                  
                  return item.userFullName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.blockName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.unitName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
              })
        
        if filteredArray.count == 0 {
            lbNoResult.isHidden = false
        } else {
             lbNoResult.isHidden = true
        }
        tbvMemberList.reloadData()
    }
    
    @IBAction func keyboardDoneClicked(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnbackPressed(_ sender: UIButton){
    self.navigationController?.popViewController(animated: true)
}
    
    @IBAction func btnCreateGroup(_ sender: UIButton) {
           doCallApi()
    }
    
    func doCallApi(){
        var memberIdArray = [String]()
        var memberNames = [String]()
        for item in selectedMemberList{
            memberIdArray.append(item.userID)
            memberNames.append(item.userFirstName)
        }
        let memberIdString = memberIdArray.joined(separator: "~")
        let memName = memberNames.joined(separator: ",")
        print(memberIdString)
        print(memName)
        let params = ["addMoreMember":"addMoreMember",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "group_id":groupDetail.chatID!,
                      "member_id":memberIdString,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "member_name":memName]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: TabCarversionVC.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break;
                            }
                        }
                    }else{
                        
                    }
                }catch{
                    print(Err as Any)
                }
            }
        }
    }
    
    func doGetUserList() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMemberList":"getMemberListGroupAddMember",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_type":doGetLocalDataUser().userType!,
                      "group_id":groupDetail.chatID!,
                      "isCheckAccess" : "0"]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            print(json as Any)
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.memberList.append(contentsOf: response.member)
                        self.filteredArray =  self.memberList
                        self.tbvMemberList.reloadData()
                        
                    }else {
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
}
extension AddMoreMembersVC : UITableViewDelegate,UITableViewDataSource,MemberListCellDelegate{
    
    func didSelectMember(at indexPath: IndexPath!, selectedStatus: Bool!) {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredArray[indexPath.row]
        let cell = tbvMemberList.dequeueReusableCell(withIdentifier: memberListCell, for: indexPath)as! MemberListCell
        cell.delegate = self
        cell.indexPath = indexPath
         Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        //cell.backgroundColor = UIColor(named: "app_background")
        
        cell.lbCompanyName.text = filteredArray[indexPath.row].company_name ?? ""
        cell.viewCompanyName.isHidden = false
       
        
        if data.joinStatus{
            cell.lblMemberName.text = data.userFullName + " Already added in group"
//            cell.lblMemberUnitNo.textColor = UIColor(named: "gray_40")
//            cell.lblMemberName.textColor = UIColor(named: "gray_40")
//            cell.mainView.backgroundColor = UIColor(named: "gray_20")
        }else{
            if data.blockStatus{
//                cell.lblMemberName.textColor = UIColor(named: "gray_20")
//                cell.lblMemberUnitNo.textColor = UIColor(named: "gray_20")
//                cell.lblMemberName.text = data.userFullName + " - Blocked"
                cell.lblMemberUnitNo.text = data.user_designation ?? ""
            }else{
                cell.lblMemberName.text = data.userFullName
//                cell.lblMemberName.textColor = UIColor.black
//                cell.lblMemberUnitNo.textColor = UIColor.black
                cell.lblMemberUnitNo.text = data.user_designation ?? ""
            }
           
        }

        cell.selectionStyle  = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
        if !data.blockStatus{
            didSelectUser(with: data.userID)
        }
        didSelectUser(with: data.userID)
    }
}
extension AddMoreMembersVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectedMemberCellDelegate{
    
    func removeMemberClicked(at indexPath: IndexPath!) {
       let data = selectedMemberList[indexPath.row]
        self.memberList.append(data)
        self.selectedMemberList.remove(at: indexPath.row)
        self.filteredArray.removeAll(keepingCapacity: true)
        self.filteredArray = self.memberList
        self.cvSelectedMembers.reloadData()
        self.tbvMemberList.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedMemberList.count == 0{
            cvSelectedMembers.isHidden = true
            viewFAB.isHidden = true
        }else{
            lblCount.text = "\(selectedMemberList.count)"
            viewFAB.isHidden = false
            cvSelectedMembers.isHidden = false
        }
        return selectedMemberList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = selectedMemberList[indexPath.row]
        let cell = cvSelectedMembers.dequeueReusableCell(withReuseIdentifier: selectedMemberCell, for: indexPath) as! SelectedMemberCell
        cell.lblMemberName.text = data.userFullName
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
