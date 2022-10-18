//
//  MultiUserAndSocietyDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 12/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import EzPopup

class MultiUserAndSocietyDialogVC: BaseVC {
    var multiSocietyList = [LoginResponse]()
    var multiUnitList = [LoginResponse]()
    var itemCell = "MultiUnitCell"
    @IBOutlet weak var lblTitle: UILabel!
    var context : HomeNavigationMenuController!
  //  var context2 : DialogAgreementExpire!
    @IBOutlet weak var tbvData: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        
        if multiUnitList.count != 0 {
            lblTitle.text = doGetValueLanguage(forKey: "select_unit").uppercased()
            tbvData.tag = 1
            tbvData.reloadData()
        }else{
            lblTitle.text = doGetValueLanguage(forKey: "select_society").uppercased()
            tbvData.tag = 2
            tbvData.reloadData()
        }
    }
    
}
extension MultiUserAndSocietyDialogVC : MultiUnitCellDelegate{
    func deleteButtonClicked(atIndexpath indexPath: IndexPath) {
        let data = multiUnitList[indexPath.row]
        self.showProgress()
        let params = ["deRegisterUnit":"deRegisterUnit",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":data.unitID!,
                      "user_id":data.userID!,
                      "userId":doGetLocalDataUser().userID ?? ""]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.dismiss(animated: false, completion: nil)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
}
extension MultiUserAndSocietyDialogVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView.tag == 1{
            count = multiUnitList.count
        }else{
            count = multiSocietyList.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        var main = UITableViewCell()
        if tableView.tag == 1{
            let data = multiUnitList[indexPath.row]
            let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! MultiUnitCell
            if data.userID == doGetLocalDataUser().userID!{
                cell.imgSelectedItem.isHidden = false
            }else{
                cell.imgSelectedItem.isHidden = true
            }
            cell.lblUnitName.text = data.floorName + " - " + data.blockName
            cell.delegate = self
            cell.indexPath = indexPath
            if data.unitStatus == "4"{
                cell.viewDelete.isHidden = false
                cell.lblUnitName.text = data.floorName + " - " + data.blockName + " (Approval Pending)"
                cell.lblUnitName.textColor = ColorConstant.yellow400
            }else{
                cell.viewDelete.isHidden = true
            }
            return cell
        }else{
            let data = multiSocietyList[indexPath.row]
            let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! MultiUnitCell
            if data.societyID == doGetLocalDataUser().societyID!{

                cell.imgSelectedItem.isHidden = false
            }else{
                cell.imgSelectedItem.isHidden = true
            }
            cell.viewDelete.isHidden = true
            cell.lblUnitName.text = data.society_name
            setupMarqee(label: cell.lblUnitName)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1{
            let data = multiUnitList[indexPath.row]
            
            if data.unitStatus == "4"{
                self.toast(message: "Wait for unit approval", type: .Faliure)
            }else{
                self.sheetViewController?.dismiss(animated: false, completion: {
                   // print("base url",data.baseURL!)
                  //  print("api key",data.apiKey!)
                    UserDefaults.standard.set(data.baseURL, forKey: StringConstants.KEY_BASE_URL)
                    UserDefaults.standard.set(data.apiKey, forKey: StringConstants.KEY_API_KEY)
                    if let encoded = try? JSONEncoder().encode(data) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                     
                        self.multiUnitList.removeAll()
                        self.tbvData.reloadData()
                       
                    }
//                    print(self.doGetLocalDataUser().unitName)
//                    print(self.doGetLocalDataUser().unitID)
//                    print(self.doGetLocalDataUser().unitStatus)
//                    print(self.doGetLocalDataUser().blockName)
                    
                    
                    UserDefaults.standard.set(nil, forKey: StringConstants.SLIDER_DATA)
                    UserDefaults.standard.set(data.userProfilePic,forKey: StringConstants.KEY_PROFILE_PIC)
                    UserDefaults.standard.setValue(data.accountDeactive, forKey: "ACCOUNTDEACTIVATE")
                    
//                    let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
//                    destiController.FlagShowAccountPopup = data.accountDeactive
//                    let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//                    newFrontViewController.isNavigationBarHidden = true
//                    self.context.revealViewController().pushFrontViewController(newFrontViewController, animated: true)
                    
                    Utils.setHome()
                })
               
            }
        }else{
            let data = multiSocietyList[indexPath.row]
            
            if data.unitStatus == "4"{
                self.toast(message: "Wait for unit approval", type: .Faliure)
            }else{
                self.sheetViewController?.dismiss(animated: false, completion: {
                    print("base url",data.baseURL!)
                    print("api key",data.apiKey!)
                    UserDefaults.standard.set(data.baseURL, forKey: StringConstants.KEY_BASE_URL)
                    UserDefaults.standard.set(data.apiKey, forKey: StringConstants.KEY_API_KEY)
                    if let encoded = try? JSONEncoder().encode(data) {
                        UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        self.multiUnitList.removeAll()
                        self.tbvData.reloadData()
                    }
                    UserDefaults.standard.set(nil, forKey: StringConstants.SLIDER_DATA)
                    UserDefaults.standard.set(data.userProfilePic,forKey: StringConstants.KEY_PROFILE_PIC)

//                    let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
//                    let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//                    newFrontViewController.isNavigationBarHidden = true
//                    self.context.revealViewController().pushFrontViewController(newFrontViewController, animated: true)
                    Utils.setHome()
                })
            }
        }
    }
    func showDeactiveDailog() {
        
        let screenwidth = UIScreen.main.bounds.width
                let screenheight = UIScreen.main.bounds.height
        
        let nextVC = DialogAccountDeactivated()
        
               // let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogAccountDeactivated") as! DialogAccountDeactivated
             //   nextVC.cabCompanyList = self.dailyCompanyList
              //  nextVC.contextDailyVisitor = self
                let popupVC = PopupViewController(contentController: nextVC, popupWidth: screenwidth - 10
                    , popupHeight: screenheight
                )
                popupVC.backgroundAlpha = 0.8
                popupVC.backgroundColor = .black
                popupVC.shadowEnabled = true
                popupVC.canTapOutsideToDismiss = false
                present(popupVC, animated: true)
        
    }
    
}
extension String {
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
}
