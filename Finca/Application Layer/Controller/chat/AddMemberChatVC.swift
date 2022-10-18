//
//  AddMemberChatVC.swift
//  Finca
//
//  Created by anjali on 07/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct RepondeChatList : Codable {
    let status : String! //" : "200"
    let message : String! //" : "200"
    let member : [MemberModelChatList]!
    let group_chat_status: String!
    
}
struct MemberModelChatList : Codable {
    let flag: String!
    let chat_id : String!
    let user_type : String! //" : "0",
    let owner_name : String! //" : "",
    let member_date_of_birth : String! //" : "0002-12-31",
    let user_profile_pic : String! //" : https:\/\/www.fincasyscom\/img\/users\/recident_profile\/user_1908031026.png",
    let unit_status : String! //" : "1",
    let user_id : String! //" : "452",
    let user_status : String! //" : "1",
    let user_first_name : String! //" : "harsh",
    let user_mobile : String! //" : "9409286007",
    let floor_name : String! //" : "1 Floor",
    let owner_email : String! //" : "",
    let public_mobile : String! //" : "1",
    let alt_mobile : String! //" : "88588288828",
    let member_status : String! //" : "0",
    let unit_id : String! //" : "2118",
    let block_name : String! //" : "A",
    let owner_mobile : String! //" : "9409286007",
    let floor_id : String! //" : "518",
    let unit_name : String! //" : "101",
    let user_last_name : String! //" : "panchal",
    let user_full_name : String! //" : "harsh panchal"
    let chatCount : String! //" : "0"
   let gender : String! //" : "0"
    let token : String!
    let company_name : String!
    let user_designation : String!
}

class AddMemberChatVC: BaseVC {
    
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    let cellItem = "MemberListCaht"
    var memberList  = [MemberModelChatList]()
    var filteredArray = [MemberModelChatList]()
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbNoResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName:cellItem, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: cellItem)
        cvData.delegate = self
        cvData.dataSource = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tfSearch.delegate = self
        lbNoResult.isHidden = true
        doGetUserList()
        tfSearch.placeholder(doGetValueLanguage(forKey: "search"))
        lbNoResult.text = doGetValueLanguage(forKey: "no_data_available")
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filteredArray = textField.text!.isEmpty ? memberList : memberList.filter({ (item:MemberModelChatList) -> Bool in
          
            let unitName = item.block_name + "-" + item.unit_name
                 
            
            return item.user_full_name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || unitName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        if filteredArray.count == 0 {
            self.lbNoResult.isHidden = false
        } else {
            self.lbNoResult.isHidden = true
        }
        
          cvData.reloadData()
        
        
        
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
                      "isCheckAccess" : "0"]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(RepondeChatList.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.memberList.append(contentsOf: response.member)
                        self.filteredArray =  self.memberList
                        self.cvData.reloadData()
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
    
    @objc func onClickCall(sender : UIButton) {
        let index = sender.tag
        
        let phone = filteredArray[index].user_mobile!
        if let url = URL(string: "tel:\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}

extension AddMemberChatVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! MemberListChat
        cell.lbUserName.text = filteredArray[indexPath.row].user_full_name
        Utils.setImageFromUrl(imageView: cell.ivUserProfile, urlString: filteredArray[indexPath.row].user_profile_pic, palceHolder: "user_default")
        cell.lbUnitName.text = filteredArray[indexPath.row].user_designation ?? ""
        cell.lbCompanyName.text = filteredArray[indexPath.row].company_name ?? ""
        cell.viewCompanyName.isHidden = false
       
//        if filteredArray[indexPath.row].company_name ?? "" != "" {
//            cell.lbCompanyName.text = filteredArray[indexPath.row].company_name ?? ""
//            cell.viewCompanyName.isHidden = false
//        }else {
//            cell.viewCompanyName.isHidden = true
//         }
        
        cell.viewChatCount.isHidden = true
        cell.viewDeleteChatClicked.isHidden = true
        if  filteredArray[indexPath.row].public_mobile != "1" {
            cell.viewCall.isHidden = false
            cell.bCall.tag = indexPath.row
            cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
        } else {
            cell.viewCall.isHidden = true
        }
        if filteredArray[indexPath.row].gender != nil && filteredArray[indexPath.row].gender != ""  {
            cell.ivGender.isHidden = false
            if filteredArray[indexPath.row].gender == "Male" {
                cell.ivGender.image = UIImage(named: "gender_male")
            } else {
                cell.ivGender.image = UIImage(named: "gender_female")
            }
        } else {
            cell.ivGender.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        pushVC(vc: vc)
        //  vc.memberDetailModal =  memberArray[indexPath.row]
        vc.isGateKeeper = false
        vc.user_id = filteredArray[indexPath.row].user_id!
        vc.userFullName = filteredArray[indexPath.row].user_full_name!
        vc.user_image = filteredArray[indexPath.row].user_profile_pic!
        vc.public_mobile  =  filteredArray[indexPath.row].public_mobile!
         vc.mobileNumber =  filteredArray[indexPath.row].user_mobile!
        
//        let item = filteredArray[indexPath.row]
//
//        let vc = ChatRoomVC()
//
//        var userModel = MemberModelChat()
//        userModel.userChatId = "\(doGetLocalDataUser().societyID ?? "")\(item.user_id ?? "")"
//        userModel.userId = item.user_id ?? ""
//        userModel.publicMobile = item.public_mobile ?? ""
//        userModel.userMobile = item.user_mobile ?? ""
//        userModel.userProfile = item.user_profile_pic ?? ""
//        userModel.userType = StringConstants.RESIDENT
//        userModel.gender = item.gender ?? ""
//        userModel.userBlockName = "\(item.block_name ?? "")-\(item.unit_name ?? "")"
//        userModel.userName = item.user_full_name ?? ""
//        //userModel.lastSeen = cDate
//        userModel.userToken =  item.token ?? ""
//        vc.userModel = userModel
//        vc.sendTo = StringConstants.CHAT_WITH_RESIDENT
//        pushVC(vc: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}





