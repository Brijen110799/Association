//
//  SwitchMemberVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown
struct ResponseOtherMemberResponse : Codable {
    let status : String! //" : "200",
    let message : String! //" : "Get Family Members Successfully"
    let member :[ModelOtherMember]!
}
struct ModelOtherMember : Codable {
    let user_first_name : String! //" : "Deepak",
    let country_code : String! //" : "+91",
    let user_last_name : String! //" : "Panchal",
    let user_profile_pic : String! //" : "https:\/nt_profile\/user_1502636084.png",
    let user_id : String! //" : "293",
    let gender : String! //" : "Male",
    let user_mobile : String! //" : "9096693518",
    let user_status : String! //" : "1",
    let member_status : String! //" : "0"
    var selectedRelation : String!
    var selectedRelationEdit : String!
}

class SwitchMemberVC: BaseVC {
    
    @IBOutlet weak var cvData: UICollectionView!
    
   // @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblSelectMembeeToSwitvh: UILabel!
   // @IBOutlet weak var lblPleaseSelectNewRelation: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    let cellMember  = "FamilyMemberSelectionCell"
    let cellMemberRelarion  = "FamilyMemberRelationCell"
    
    var memberList = [MemberDetailModal]()
    var selectedIndex = -1
    var   otherMember  = [ModelOtherMember]()
    
    var relationMember = [String]()
    let dropDown = DropDown()
    var new_primary_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // tbvData.estimatedRowHeight = 90
      //  tbvData.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: cellMember, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: cellMember)
        cvData.delegate = self
        cvData.dataSource = self
    
       
       // memberList = tempMemberList
        cvData.reloadData()
        
//        let nibM = UINib(nibName: cellMemberRelarion, bundle: nil)
//        tbvData.register(nibM, forCellReuseIdentifier: cellMemberRelarion)
//        tbvData.delegate = self
//        tbvData.dataSource = self
//        tbvData.separatorStyle = .none
        self.relationMember =  doGetLocalDataUser().isSociety ?  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Uncle","Aunt","Friend","Tenant","Other"] : ["Owner","Employee","Other"]
        relationMember = doGetValueLanguageArrayString(forKey: "relation_society")
        print("arr : \(memberList)")
        if memberList.count > 0{
        new_primary_id = memberList[0].userID
        doGetOtherMember(new_primary_id: memberList[0].userID)
        }else{
            toast(message: "add member", type: .Information)
        }
       // new_primary_id = memberList[0].userID
        //doGetOtherMember(new_primary_id: memberList[0].userID)
        lblScreenTitle.text = doGetValueLanguage(forKey: "family_members_primary_switch")
        lblSelectMembeeToSwitvh.text = doGetValueLanguage(forKey: "select_member_to_switch_primary_account")
       // lblPleaseSelectNewRelation.text = doGetValueLanguage(forKey: "please_select_new_relation_with_selected_member")
        btnOK.setTitle(doGetValueLanguage(forKey: "ok"), for: .normal)
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func tapOk(_ sender: Any) {
        if selectedIndex == -1 {
           showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_member_to_switch_primary_account"))
        }else {
            doCallApi()
        }
        
    }
    override func onClickDone() {
        Utils.setHome()
    }
    func doGetOtherMember(new_primary_id : String) {

        let params = ["getOtherFamilyMmeber":"getOtherFamilyMmeber",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "new_primary_id":new_primary_id,
                      "user_type":doGetLocalDataUser().userType ?? ""]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.family_controller, parameters: params) { (json, error) in
           print(json!)
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseOtherMemberResponse.self, from:json!)
                    if response.status == "200" {
                        self.otherMember = response.member
                       // self.tbvData.reloadData()
                        
                    }else {

                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallApi(){
        showProgress()
         
         let params = ["setNewPrimaryMember":"setNewPrimaryMember",
                       "society_id":doGetLocalDataUser().societyID!,
                       "user_id":doGetLocalDataUser().userID!,
                       "unit_id":doGetLocalDataUser().unitID!,
                       "new_primary_id":new_primary_id,
                       "user_type":doGetLocalDataUser().userType ?? "",
                       "user_name" : doGetLocalDataUser().userFullName ?? "",
                       "language_id" :doGetLanguageId()]
         print("param" , params)
        
         let request = AlamofireSingleTon.sharedInstance
         request.requestPost(serviceName: ServiceNameConstants.family_controller, parameters: params) { (Data, error) in
             self.hideProgress()
             if Data != nil{
                 do{
                     let response = try JSONDecoder().decode(DailyVisitorResponse.self, from: Data!)
                     if response.status == "200"{
                         self.showAlertMessageWithClick(title: "", msg: response.message)
                     }else{
                         self.toast(message: response.message, type: .Faliure)
                     }
                 }catch{
                     print("error")
                 }
             }else{
                 print("Parse Error")
             }
         }
    }
}

extension SwitchMemberVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMember, for: indexPath) as! FamilyMemberSelectionCell
        
        
        let item = memberList[indexPath.row]
        cell.lbName.text = "\(item.userFirstName ?? "") \(item.userLastName ?? "")"
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.userProfilePic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        setThreeCorner(viewMain: cell.viewMain)
        cell.viewMain.layer.borderWidth = 1
        cell.viewMain.layer.borderColor = UIColor.white.cgColor
        if selectedIndex == indexPath.row {
            cell.ivProfile.layer.borderWidth = 1
            cell.ivProfile.layer.borderColor = ColorConstant.colorP.cgColor
            cell.viewMain.backgroundColor =  ColorConstant.colorP
           
        } else {
            cell.ivProfile.layer.borderWidth = 1
            cell.ivProfile.layer.borderColor = ColorConstant.grey_60.cgColor
            cell.viewMain.backgroundColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 3  - 1 , height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        new_primary_id = memberList[selectedIndex].userID
        doGetOtherMember(new_primary_id: memberList[selectedIndex].userID)
    }
    
    
    
}
extension SwitchMemberVC  : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellMemberRelarion, for: indexPath) as! FamilyMemberRelationCell
        setThreeCorner(viewMain: cell.viewMain)
        let item = otherMember[indexPath.row]
        
        cell.lbName.text = "\(item.user_first_name ?? "") \(item.user_last_name ?? "")"
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        cell.selectionStyle = .none
        if indexPath.row == otherMember.count - 1{
            cell.viewHidden.isHidden = false
        } else {
            cell.viewHidden.isHidden = true
        }
        if item.selectedRelation ?? "" == "" {
            cell.lbRelation.text = doGetValueLanguage(forKey: "select_member_relation")
            cell.tfOtherRelation.isHidden = true
        } else {
            
            cell.lbRelation.text = item.selectedRelation
            if  item.selectedRelation == doGetValueLanguage(forKey: "other_relation") {
                cell.tfOtherRelation.isHidden = false
                cell.tfOtherRelation.text = item.selectedRelationEdit ?? ""
            } else {
                cell.tfOtherRelation.isHidden = true
                cell.tfOtherRelation.text = ""
               
            }
        }
        cell.bRelation.tag = indexPath.row
        cell.bRelation.addTarget(self, action: #selector(onTapRelation(sender:)), for: .touchUpInside)
        cell.tfOtherRelation.placeholder(doGetValueLanguage(forKey: "enter_relation_here"))
        cell.tfOtherRelation.tag = indexPath.row
        cell.tfOtherRelation.addTarget(self, action: #selector(onTextChange(_: )), for: .editingChanged )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    @objc func onTextChange(_ sender : UITextField){
        
        otherMember[sender.tag].selectedRelationEdit = sender.text
       
    }
    @objc func onTapRelation(sender :UIButton) {
        let indexM = sender.tag
        
         dropDown.anchorView = sender
        dropDown.dataSource = relationMember
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
         //   self.lblRelation.text = self.dropDown.selectedItem
           
            otherMember[indexM].selectedRelation = item
          //  tbvData.reloadRows(at: [IndexPath(row: indexM, section: 0)], with: .none)
            
        }
        dropDown.width = sender.frame.width
        
        dropDown.show()
    }
    
}
