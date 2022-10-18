//
//  ReminderVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 19/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import UserNotifications
struct ReminderResponse: Codable {
    var message: String!
    var status: String!
    var reminder: [ReminderListModel]!

//    enum CodingKeys: String, CodingKey {
//        case message = "message"
//        case status = "status"
//
//    }
}
struct ReminderListModel: Codable {
    var reminder_date_view: String! //" : "01 Jan 1970 05:30 AM",
    var reminder_text: String! //" : "add",
    var society_id: String! //" : "75",
    var reminder_date: String! //" : "1970-01-01 05:30:00",
    var reminder_me: Bool! //" : true,
    var reminder_id: String! //" : "17",
    var user_id: String! //" : "90"
    
    
//    enum CodingKeys : String, CodingKey{
//        case society_id = "society_id"
//        case user_id = "user_id"
//        case language_id = "language_id"
//    }
}
class ReminderVC: BaseVC {

    @IBOutlet weak var tbvReminderData: UITableView!
    
    @IBOutlet weak var lblNoReminder: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    
    @IBOutlet weak var viewAddReminder: UIView!
    
    @IBOutlet weak var conTrallingAddBuuton: NSLayoutConstraint!
    @IBOutlet weak var lblScreenTitle: UILabel!
    let itemCell = "reminderCell"
    var reminderArr = [ReminderListModel](){
        didSet{
            tbvReminderData.reloadData()
        }
    }
    var selectedIndex = -1
    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doCallApi()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvReminderData.register(nib, forCellReuseIdentifier: itemCell)
        tbvReminderData.delegate = self
        tbvReminderData.dataSource = self
        
        tbvReminderData.estimatedRowHeight = UITableView.automaticDimension
        tbvReminderData.rowHeight = UITableView.automaticDimension
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_reminders")
        lblNoReminder.text = doGetValueLanguage(forKey: "no_data")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ReminderRefresh), name: .ReminderRefresh, object: nil)
    }
    
    @objc func ReminderRefresh(){
        fetchNewDataOnRefresh()
    }
    
    override func fetchNewDataOnRefresh() {
        self.doCallApi()
        self.reminderArr.removeAll()
    }

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickAddReminder(_ sender: Any) {
        let vc = AddReminderVC()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    func doCallApi(){
       // self.showProgress()
        
        let params = ["getReminder":"getReminder",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "language_id":doGetLanguageId()]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (json, Err) in
      
            if json.self != nil{
                print(json as Any)
               // self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(ReminderResponse.self, from: json!)
                    if response.status == "200"{
                        self.reminderArr = response.reminder
                        //print("ReminderArr", self.reminderArr)
                        self.tbvReminderData.reloadData()
                        self.viewNoData.isHidden = true
                        print("sucess")
                    }else{
                        self.viewNoData.isHidden = false
                        self.reminderArr.removeAll()
                        self.tbvReminderData.reloadData()
                        //self.showAlertMessage(title: "", msg: response.message)
                
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    func doCallDeleteApi(params : [String : String]) {
        self.showProgress()
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(ReminderResponse.self, from: Data!)
                    if response.status == "200"{
                        self.doCallApi()
                        self.tbvReminderData.reloadData()
                        self.toast(message: response.message, type: .Success)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    func doCallCompleteApi(params : [String : String]) {
        self.showProgress()
        print(params as Any)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(ReminderResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                        self.toast(message: response.message, type: .Success)
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
extension ReminderVC : UITableViewDelegate,UITableViewDataSource,reminderCellDelegate{
    
    func DoneButtonClicked(at indexPath: IndexPath) {
//        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Are You Sure To Complete The Reminder??",  style: .Add, tag: indexPath.row)
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_complete"), style: .Add, tag: indexPath.row, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
    }
    
    func DeleteButtonClicked(at indexPath: IndexPath) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: indexPath.row, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
       // self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: indexPath.row)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = reminderArr[indexPath.row]
        let cell = tbvReminderData.dequeueReusableCell(withIdentifier: "reminderCell")as! reminderCell
        cell.lblReminderTime.text = "On \(data.reminder_date_view ?? "")"
        cell.lblTitle.text = data.reminder_text
        cell.selectionStyle = .none
        cell.indexpath = indexPath
        cell.delegate = self
        cell.bDone.setTitle(doGetValueLanguage(forKey: "mark_as_complete"), for: .normal)
        
        
        if data.reminder_me ?? false {
            cell.lbStatus.isHidden = true
            cell.bDone.isHidden = false
        }else {
            cell.lbStatus.isHidden = false
            cell.bDone.isHidden = true
            cell.lbStatus.text = doGetValueLanguage(forKey: "completed")
        }
        
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            // print("move up")
            self.conTrallingAddBuuton.constant = -60
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            //    print("move down")
            self.conTrallingAddBuuton.constant = 16
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            // didn't move
        }

    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
        //print("scrollViewWillBeginDragging" , scrollView.contentOffset.y)
    }
}
    
extension ReminderVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.reminderArr[tag]
                let params = ["deleteReminder":"deleteReminder",
                              "reminder_id":data.reminder_id!,
                              "user_id":self.doGetLocalDataUser().userID!,
                              "language_id":self.doGetLanguageId()]
                self.doCallDeleteApi(params: params)
                
            }
        }else{
            self.dismiss(animated: true){
                let data = self.reminderArr[tag]
                let params = ["completeReminder":"completeReminder",
                              "society_id": data.society_id!,
                              "reminder_id":data.reminder_id!,
                              "user_id":self.doGetLocalDataUser().userID!,
                              "language_id":self.doGetLanguageId()]
                self.doCallCompleteApi(params: params)
            }
        }
    }

    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
