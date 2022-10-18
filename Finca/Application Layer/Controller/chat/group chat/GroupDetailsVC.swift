//
//  GroupDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 10/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown
import EzPopup
class GroupDetailsVC: BaseVC {
    let dropdown = DropDown()
    let cellItem = "MemberListCaht"
    var memberList  = [MemberListModel]()
    var filteredArray = [MemberListModel]()
    var groupDetail : MemberListModel!
    var optionsArray = [String]()
    
    @IBOutlet weak var imgGroupIcon: UIImageView!
    @IBOutlet weak var viewFAB: UIView!
    @IBOutlet weak var lblGroupname: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var lblMemberCount: UILabel!
    @IBOutlet weak var btnAddMoreMember: UIButton!
    @IBOutlet weak var btnMoreOption: UIButton!
    @IBOutlet weak var viewEditGroupDetails: UIView!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lbNoResult: UILabel!
    var userModelForRemoveGroup : MemberListModel?
    var deleteGroup = ""
    var memberCount = "0"
    var groupChatVC : GroupChatVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: cellItem, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: cellItem)
        cvData.dataSource = self
        cvData.delegate = self
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.placeholder(doGetValueLanguage(forKey: "search"))
        lbNoResult.text = doGetValueLanguage(forKey: "no_data")
        doGetUserList()
        
        lblGroupname.text = groupDetail.userFullName ?? ""
        lblMemberCount.text = "\(doGetValueLanguage(forKey: "you")) & " + "\(Int(groupDetail.memberSize!)! - 1) \(doGetValueLanguage(forKey: "members"))"
        Utils.setImageFromUrl(imageView: imgGroupIcon, urlString: groupDetail.userProfilePic!, palceHolder: "groupPlaceholder")
        deleteGroup = "\(doGetValueLanguage(forKey: "delete")) \(doGetValueLanguage(forKey: "chat_group"))"
        if groupDetail.userID == doGetLocalDataUser().userID{
            viewFAB.isHidden = false
            optionsArray = [deleteGroup,doGetValueLanguage(forKey: "add_new_member")]
        }else{
            viewFAB.isHidden = true 
            optionsArray = [doGetValueLanguage(forKey: "leave")]
        }
        
        
        if groupDetail.userID! == doGetLocalDataUser().userID!{
            constraintWidth.constant = 80
            viewEditGroupDetails.isHidden = false
        }else{
            constraintWidth.constant = 40
            viewEditGroupDetails.isHidden = true
        }
        lbNoResult.isHidden = true
    }
    
    @IBAction func btnMoreOptionsClicked(_ sender: UIButton) {
        dropdown.anchorView = btnMoreOption
        dropdown.dataSource = optionsArray
        dropdown.width = 190
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch item {
            case doGetValueLanguage(forKey: "leave"):
                //self.doCallLeaveGroup()
                showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "leave_group"))?", style: .Delete,tag : 1 , cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "leave"))
                break;
            case deleteGroup:
                self.confirmDeleteGroup()
                break;
            case doGetValueLanguage(forKey: "add_new_member"):
                self.doClickAddMember()
                break;
            default:
                break;
            }
            self.dropdown.hide()
        }
        dropdown.show()
    }
    
    func confirmDeleteGroup() {
//        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
//
//            alert.dismiss(animated: true, completion: nil)
//            self.doCallDeleteApi()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//
//        self.present(alert, animated: true)
        
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "sure_to_delete"))?", style: .Delete,tag : 2 , cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }
    
    override func onClickDone() {
        
    }
    func doCallLeaveGroup(){
        self.showProgress()
        let params = ["leaveGroup":"leaveGroup",
                      "society_id":doGetLocalDataUser().societyID!,
                      "group_id":groupDetail.chatID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_name":doGetLocalDataUser().userFirstName!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
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
                    print("Parse error",Err as Any)
                }
            }
        }
    }
    
    func doCallDeleteApi(){
        self.showProgress()
        let params = ["deleteGroup":"deleteGroup",
                      "society_id":doGetLocalDataUser().userID!,
                      "group_id":groupDetail.chatID!,
                      "user_id":doGetLocalDataUser().userID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
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
                    print("Parse error",Err as Any)
                }
            }
        }
    }
    
    func doClickAddMember(){
        btnAddMoreMembersClicked(btnMoreOption)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        groupChatVC?.memberCount = memberCount
        doPopBAck()
    }
    
    @IBAction func btnAddMoreMembersClicked(_ sender: UIButton) {
        let nextVC = storyboardConstants.chat.instantiateViewController(withIdentifier: "idAddMoreMembersVC")as! AddMoreMembersVC
        nextVC.groupDetail = self.groupDetail
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        filteredArray = textField.text!.isEmpty ? memberList : memberList.filter({ (item:MemberListModel) -> Bool in
            
            return item.userFullName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.blockName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.blockName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
       if filteredArray.count == 0 {
             lbNoResult.isHidden = false
       }else {
        lbNoResult.isHidden = true
        }
      
        cvData.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    func doGetUserList() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMemberList":"getMemberListGroup",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_type":doGetLocalDataUser().userType!,
                      "group_id":groupDetail.chatID!,
                      "isCheckAccess" : "0"]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                    if response.status == "200" {
                        self.memberList.append(contentsOf: response.member)
                        self.lblMemberCount.text = "\(self.doGetValueLanguage(forKey: "you")) & " + "\(response.member.count) \(self.doGetValueLanguage(forKey: "members"))"
                        self.memberCount = "\(response.member.count + 1)"
                        self.setupArray()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
    
    func setupArray(){
       
        let tempArr = memberList
        self.memberList.removeAll()
        for (_,item) in tempArr.enumerated(){
            if item.joinStatus{
                self.memberList.append(item)
            }
        }
        
        for (index,item) in memberList.enumerated() {
            if groupDetail.userID == item.userID {
                memberList.swapAt(0, index)
            }
        }
        
        self.filteredArray = self.memberList
        self.cvData.reloadData()
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
    
    func doCallDeleteMemberApi(memberData : MemberListModel!){
        self.showProgress()
        let params = ["leaveGroup":"leaveGroup",
                      "society_id":doGetLocalDataUser().societyID!,
                      "group_id":groupDetail.chatID!,
                      "user_id":memberData.userID!,
                      "user_name":memberData.userFirstName!,
                      "admin_name":doGetLocalDataUser().userFirstName!]
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.CreateGroupController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.memberList.removeAll()
                        self.filteredArray.removeAll()
                        self.cvData.reloadData()
                        self.doGetUserList()
                    }else{
                        
                    }
                }catch{
                    print("parse error",Err as Any)
                }
            }
        }
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idGroupInfoDialogVC")as! GroupInfoDialogVC
        //        vc.context = self
        //        vc.selectedMemberList = self.selectedMemberList
        vc.editFlag = true
        vc.editContext = self
        vc.groupDetails = self.groupDetail
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
}
extension GroupDetailsVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,MemberListCellDelgate {
    
    func doRemoveMemberfromGroup(indexPath: IndexPath) {
        userModelForRemoveGroup = filteredArray[indexPath.row]
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "remove_user_group"))?", style: .Delete,tag : 3 , cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "remove"))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = filteredArray[indexPath.row]
        let nilCell = UICollectionViewCell()
        if data.joinStatus{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! MemberListChat
            cell.lbUserName.text = data.userFullName
            Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: data.userProfilePic, palceHolder: "user_default")
            cell.viewChatCount.isHidden = true
            if groupDetail.userID! == doGetLocalDataUser().userID!{
                cell.viewChatLbl.isHidden = true
                cell.viewDeleteChatClicked.isHidden = false
                cell.indexPath = indexPath
                cell.delegate = self
            }else{
                cell.viewDeleteChatClicked.isHidden = true
            }
            
            cell.lbUnitName.text = data.user_designation
            if groupDetail.userID! == data.userID{
                cell.lbCompanyName.text = "\(filteredArray[indexPath.row].company_name ?? "") (Group Admin)"
            }else{
                cell.lbCompanyName.text = "\(filteredArray[indexPath.row].company_name ?? "") - \(filteredArray[indexPath.row].floorName ?? "")"
            }
            setupMarqee(label: cell.lbCompanyName)
            //cell.lbCompanyName.addSubview(marL)
            
            
            cell.viewCompanyName.isHidden = false
        
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
            
            cell.viewCall.isHidden = true
            return cell
        }
        return nilCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if groupDetail.userID == doGetLocalDataUser().userID{
            if indexPath.row == filteredArray.count - 1 {
                
                if filteredArray.count > 8 {
                    return CGSize(width: collectionView.bounds.width, height: 140)
                    
                } else {
                    return CGSize(width: collectionView.bounds.width, height: 110)
                }
                
                
            } else {
                return CGSize(width: collectionView.bounds.width, height: 110)
                
            }
        } else {
            return CGSize(width: collectionView.bounds.width, height: 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        //  vc.memberDetailModal =  memberArray[indexPath.row]
        vc.isGateKeeper = false
        vc.user_id = filteredArray[indexPath.row].userID!
        vc.userFullName = filteredArray[indexPath.row].userFullName!
        vc.user_image = filteredArray[indexPath.row].userProfilePic!
        vc.public_mobile  = filteredArray[indexPath.row].publicMobile!
        vc.mobileNumber =  filteredArray[indexPath.row].userMobile!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GroupDetailsVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                if tag == 1 {
                    //for leave group
                    self.doCallLeaveGroup()
                } else if tag == 2 {
                    //for delete group
                    self.doCallDeleteApi()
                } else if tag == 3 {
                    //for single user from group
                    self.doCallDeleteMemberApi(memberData: self.userModelForRemoveGroup)
                }
                
            }
        }
    }
    
}
