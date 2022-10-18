//
//  ReminderDailogVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 28/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//
protocol ReminderDailogDelegate{
   
    func DoneButtonClicked(at indexPath : IndexPath)
}
import UIKit

class ReminderDailogVC: BaseVC {
    //var context : BaseVC!
    var reminderData : [AnyHashable : Any]!
    
    var reminder_date = ""
    var reminder_text = ""
    @IBOutlet weak var lblReminderTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnCompleteReminder: UIButton!
    @IBOutlet weak var btnReminderLater: UIButton!
    //var context : ReminderVC!
    var context : AddReminderVC!
    var reminderListModel : ReminderListModel!
    var reminder = [GetReminderListModel]()
    var currentCount = 0
    var delegate : ReminderDailogVC!
    var indexpath : IndexPath!
    var remindersize = 0
    var currentposition = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //doCallApi()
//        blDateTime.text = reminderListModel.reminder_date
//        lblReminderTitle.text = reminderListModel.reminder_textl
//        lblDateTime.text = reminder[currentCount].reminder_date
//        lblReminderTitle.text = reminder[currentCount].reminder_text
        setReminderData()
        btnReminderLater.setTitle(doGetValueLanguage(forKey: "remind_me_later").uppercased(), for: .normal)
        btnCompleteReminder.setTitle(doGetValueLanguage(forKey: "complete").uppercased(), for: .normal)
    }
    func setReminderData(){
        lblDateTime.text = reminder[currentCount].reminder_date_view
        lblReminderTitle.text = reminder[currentCount].reminder_text
    }
    @IBAction func onClickRemindMe(_ sender: Any) {
        closeView()
    }
    @IBAction func onClickCompleteReminder(_ sender: Any) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_complete"), style: .Add, tag: 0, cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
        //self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func onClickCloseReminder(_ sender: Any) {
        closeView()
        //        let vc = HomeVC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func closeView() {
        removeFromParent()
        view.removeFromSuperview()
        
    }
//    func doCallApi(){
//       // self.showProgress()
//
//        let params = ["getReminder":"getReminder",
//                      "society_id":doGetLocalDataUser().societyID!,
//                      "user_id":doGetLocalDataUser().userID!,
//                      "language_id":doGetLanguageId()]
//        print(params)
//        let request = AlamofireSingleTon.sharedInstance
//        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (json, Err) in
//
//            if json.self != nil{
//                print(json as Any)
//               // self.hideProgress()
//                do{
//                    let response = try JSONDecoder().decode(ReminderResponse.self, from: json!)
//                    if response.status == "200"{
//                        //self.reminderArr = response.reminder
//                        //self.tbvReminderData.reloadData()
//                        print("sucess")
//                    }else{
//                        self.showAlertMessage(title: "", msg: response.message)
//
//                    }
//                }catch{
//                    print("parse error",error as Any)
//                }
//            }
//        }
//    }

    func doCallCompleteApi() {
        print("current po ",self.currentCount)
        print("reminder po ",self.reminder.count)
        
        
        self.showProgress()

        let data = self.reminder[currentCount]
        let params = ["completeReminder":"completeReminder",
                      "society_id": data.society_id!,
                      "reminder_id":data.reminder_id!,
                      "user_id":self.doGetLocalDataUser().userID!,
                      "language_id":self.doGetLanguageId()]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(ReminderResponse.self, from: Data!)
                    if response.status == "200"{
                        self.currentCount += 1
                        if (self.currentCount <= self.reminder.count - 1){
                            self.setReminderData()
                        }else{
                            self.closeView()
                        }
                        self.toast(message: response.message, type: .Success)
                    }else{
                        print("faliure message",response.message as Any)
                        self.toast(message: response.message, type: .Faliure)
                    }
                }catch{
                    print("parse error",error as Any)
                   // self.toast(message: response.message, type: .Faliure)
                }
            }
        }
    }

}
extension ReminderDailogVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        self.dismiss(animated: true){
            
            self.doCallCompleteApi()
        }

        func btnCancelClicked() {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


