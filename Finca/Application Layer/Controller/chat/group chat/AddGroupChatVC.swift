//
//  AddGroupChatVC.swift
//  Finca
//
//  Created by harsh panchal on 09/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class AddGroupChatVC: BaseVC {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewFAB: UIView!
    @IBOutlet weak var tbvMemberList: UITableView!
    @IBOutlet weak var cvSelectedMembers: UICollectionView!
    var memberListCell = "MemberListCell"
    var selectedMemberCell = "SelectedMemberCell"
    var memberList = [MemberListModel]()
    var filteredArray = [MemberListModel]()
    var selectedMemberList = [MemberListModel]()
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbNoResult: UILabel!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var btnUnSelectAll: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfSearch.addTarget(self, action: #selector(filterMember(_:)), for: .editingChanged)
        tfSearch.delegate = self
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
         lbNoResult.isHidden = true
        doGetUserList()
        lblScreenTitle.text = doGetValueLanguage(forKey: "select_group_members")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_member"))
        lbNoResult.text = doGetValueLanguage(forKey: "no_data")
        btnUnSelectAll.setTitle(doGetValueLanguage(forKey: "unselect_all"), for: .normal)
        btnSelectAll.setTitle(doGetValueLanguage(forKey: "select_all"), for: .normal)
        
    }
    
    @objc func filterMember(_ textField : UITextField!){
        filteredArray = textField.text!.isEmpty ? memberList : memberList.filter({ (item:MemberListModel) -> Bool in
            let unitName = item.blockName + "-" + item.unitName
            return item.userFullName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || unitName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
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
    @IBAction func btnbackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCreateGroup(_ sender: UIButton) {
        if selectedMemberList.count > 1{
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idGroupInfoDialogVC")as! GroupInfoDialogVC
            vc.context = self
            vc.selectedMemberList = self.selectedMemberList
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }else{
            self.toast(message: "Please select 2 or more members", type: .Information)
        }
        
    }
    func doGetUserList() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMemberList":"getMemberList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_type":doGetLocalDataUser().userType!,
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
                         self.lbNoResult.isHidden = true
                    }else {
                        self.lbNoResult.isHidden = false
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func    didSelectUser(with UserID : String!){
        for item in filteredArray{
            if item.userID == UserID{
                self.selectedMemberList.append(item)
                //self.memberList.remove(at: index)
                self.view.endEditing(true)
                self.tfSearch.text = ""
            }
        }
        
        for (index,item) in memberList.enumerated(){
            if item.userID == UserID{
                memberList[index].selectMember = true
            }
        }
        self.cvSelectedMembers.reloadData()
       // self.filteredArray.removeAll(keepingCapacity: true)
        self.filteredArray = self.memberList
        self.tbvMemberList.reloadData()
    }
    
    func didRemoveSelectedMember(with UserID:String!){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func tapUnselect(_ sender: Any) {
        for member in  memberList {
            removeSelectedItem(userId: member.userID)
        }
        selectedMemberList.removeAll()
        self.view.endEditing(true)
        self.tfSearch.text = ""
        self.cvSelectedMembers.reloadData()
        self.filteredArray = memberList
        self.tbvMemberList.reloadData()
        lbNoResult.isHidden = true
    }
    @IBAction func tapSelectAll(_ sender: Any) {
       
        if memberList.count > 0 {
            for (index,item) in memberList.enumerated() {
                memberList[index].selectMember = true
                if  memberList[index].selectMember {
                    let model = item
                    
                    if selectedMemberList.count > 0 {
                        if !selectedMemberList.contains(where: { $0.userID == model.userID }) {
                            selectedMemberList.append(model)
                        }
                    } else {
                        selectedMemberList.append(model)
                    }
                    
                } else {
                          
                }
                // self.selectedMemberList.append(item)
                
            }
            self.view.endEditing(true)
            self.tfSearch.text = ""
            self.filteredArray = memberList
            self.cvSelectedMembers.reloadData()
            self.tbvMemberList.reloadData()
        }
             
    }
    
    func removeSelectedItem(userId : String) {
        if memberList.count > 0 {
            for (index,item) in memberList.enumerated() {
                if item.userID == userId{
                    memberList[index].selectMember = false
                }
                //
            }
        }
        
        filteredArray = memberList
    }
    
    func removeItem(userId : String) {
        
        for (index,item) in selectedMemberList.enumerated() {
            if item.userID == userId{
                selectedMemberList.remove(at: index)
            }
    
        }
        self.cvSelectedMembers.reloadData()
        
    }

    
}
extension AddGroupChatVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredArray[indexPath.row]
        let cell = tbvMemberList.dequeueReusableCell(withIdentifier: memberListCell, for: indexPath)as! MemberListCell
        //        cell.delegate = self
        cell.backgroundColor = .clear
        if data.blockStatus{
          //  cell.lblMemberName.textColor = UIColor(named: "gray_20")
            //cell.lblMemberUnitNo.textColor = UIColor(named: "gray_20")
            cell.lblMemberName.text = data.userFullName + " - Blocked"
            cell.lblMemberUnitNo.text = data.user_designation ?? ""
        }else{
            cell.lblMemberName.text = data.userFullName
            //cell.lblMemberName.textColor = UIColor.black
            //cell.lblMemberUnitNo.textColor = UIColor.black
            cell.lblMemberUnitNo.text = data.user_designation ?? ""
        }
        cell.indexPath = indexPath
       cell.lblMemberUnitNo.text = data.user_designation ?? ""
        cell.lblMemberName.text = data.userFullName
        cell.lbCompanyName.text = filteredArray[indexPath.row].company_name ?? ""
        cell.viewCompanyName.isHidden = false
       
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        //print("selected count",selectedMemberList.count)
       // cell.viewCall.isHidden = true
        if data.gender != nil && data.gender != ""  {
            cell.ivGender.isHidden = false
            if data.gender == "Male" {
                cell.ivGender.image = UIImage(named: "gender_male")
            } else {
                cell.ivGender.image = UIImage(named: "gender_female")
            }
        } else {
            cell.ivGender.isHidden = true
        }
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
        
        if data.userID != doGetLocalDataUser().userID
        {
            
    
        if data.selectMember == nil {
            filteredArray[indexPath.row].selectMember = false
        }
       
        if !data.blockStatus{
            
            if filteredArray[indexPath.row].selectMember {
                filteredArray[indexPath.row].selectMember = false
                removeItem(userId: data.userID)
            }else {
                filteredArray[indexPath.row].selectMember = true
                didSelectUser(with: data.userID)
            }
            
        }
       // print("ddddd " ,  data.selectMember )
          
        tableView.reloadData()
            
        }
        
    }
    
}

extension AddGroupChatVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectedMemberCellDelegate{
    
    func removeMemberClicked(at indexPath: IndexPath!) {
        print("removeMemberClicked " , indexPath.row)
        let data = selectedMemberList[indexPath.row]
      //  self.memberList.append(data)
        removeSelectedItem(userId: data.userID)
        self.selectedMemberList.remove(at: indexPath.row)
       self.cvSelectedMembers.reloadData()
        //self.filteredArray.removeAll(keepingCapacity: true)
      //  self.filteredArray = self.memberList
       // self.cvSelectedMembers.reloadData()
       // self.tbvMemberList.reloadData()
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
//// add group
////same in edit
//user_name groupcreater fsname
//member_name seperated by ,
//

