//
//  TabResidantVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 09/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabResidantVC: BaseVC {
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbNoResult: UILabel!
    var memberListCell = "MemberListCell"
  
    var memberList = [MemberListModel]()
    var filteredArray = [MemberListModel]()
    let requrest = AlamofireSingleTon.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfSearch.addTarget(self, action: #selector(filterMember(_:)), for: .editingChanged)
        tfSearch.delegate = self
        let tbvnib = UINib(nibName: memberListCell, bundle: nil)
        tbvData.register(tbvnib, forCellReuseIdentifier: memberListCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle  = .none
        
        // Do any additional setup after loading the view.
        self.lbNoResult.isHidden = true
        doGetUserList()
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
        tbvData.reloadData()
    }
    func doGetUserList() {
        showProgress()
        let params = ["getMemberList":"getMemberList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_type":doGetLocalDataUser().userType!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "isCheckAccess" : "0"]
        print("param" , params)
       
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
              
                do {
                    let response = try JSONDecoder().decode(MemberListResponse.self, from:json!)
                    if response.status == "200" {
                           self.lbNoResult.isHidden = true
                        self.memberList = response.member
                        self.filteredArray =  self.memberList
                        self.tbvData.reloadData()
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

    @IBAction func tapBack(_ sender: Any) {
      doPopBAck()
    }
   
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}
extension TabResidantVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "RESIDENT"
    }
}
extension TabResidantVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: memberListCell, for: indexPath)as! MemberListCell
        //        cell.delegate = self
        
       /* if data.blockStatus{
            cell.lblMemberName.textColor = UIColor(named: "gray_20")
            cell.lblMemberUnitNo.textColor = UIColor(named: "gray_20")
            cell.lblMemberName.text = data.userFullName + " - Blocked"
            cell.lblMemberUnitNo.text = data.blockName + " - " + data.unitName
        }else{
            cell.lblMemberName.text = data.userFullName
            cell.lblMemberName.textColor = UIColor.black
            cell.lblMemberUnitNo.textColor = ColorConstant.colorP
            cell.lblMemberUnitNo.text = data.blockName + " - " + data.unitName
        }*/
        cell.indexPath = indexPath
        cell.lblMemberUnitNo.text = data.blockName + "-" + data.unitName
        cell.lblMemberName.text = data.userFullName
        cell.lblMemberUnitNo.textColor = ColorConstant.colorP
        
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
         
        if  data.publicMobile != "1" {
            cell.viewCall.isHidden = false
            cell.bCall.tag = indexPath.row
            cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
        } else {
            cell.viewCall.isHidden = true
        }
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
        return 70
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
        
       
        var userModel = MemberModelChat()
        userModel.userChatId = "\(doGetLocalDataUser().societyID ?? "")\(data.userMobile ?? "")"
        userModel.userId = data.userID
        userModel.publicMobile = data.publicMobile
        userModel.userMobile = data.userMobile
        userModel.userProfile = data.userProfilePic
        userModel.userType = StringConstants.RESIDENT
        userModel.gender = data.gender
        userModel.userBlockName = "\(data.blockName ?? "")-\(data.unitName ?? "")"
        userModel.userName = data.userFullName
        userModel.userToken = data.token ?? ""
        let vc = ChatRoomVC()
        vc.userModel = userModel
        vc.sendTo = StringConstants.CHAT_WITH_RESIDENT
        pushVC(vc: vc)
    }
    
}
