//
//  AddReminderVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 26/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
import EzPopup
import SkyFloatingLabelTextField
import UserNotifications
import AVFoundation

//struct GetReminderResponse: Codable {
//    var message: String!
//    var status: String!
//    var reminder: [GetReminderListModel]!
//
////    enum CodingKeys: String, CodingKey {
////        case message = "message"
////        case status = "status"
////
////    }
//}
//struct GetReminderListModel: Codable {
//    var reminder_date_view: String! //" : "01 Jan 1970 05:30 AM",
//    var reminder_text: String! //" : "add",
//    var society_id: String! //" : "75",
//    var reminder_date: String! //" : "1970-01-01 05:30:00",
//    var reminder_me: Bool! //" : true,
//    var reminder_id: String! //" : "17",
//    var user_id: String! //" : "90"
//    
////    enum CodingKeys : String, CodingKey{
////        case society_id = "society_id"
////        case user_id = "user_id"
////        case language_id = "language_id"
////    }
//}
class AddReminderVC: BaseVC, UNUserNotificationCenterDelegate , UITextViewDelegate , OnSelectDate {
  
   

    @IBOutlet weak var viewSetDate: UIView!
    
    @IBOutlet weak var viewSetTime: UIView!

    @IBOutlet weak var lblAddTitle: UILabel!
    @IBOutlet weak var lblReminderDate: UILabel!
    @IBOutlet weak var lblReminderTime: UILabel!
    @IBOutlet weak var btnSaveReminder: UIButton!
    
    @IBOutlet weak var tfSetDate: CustomUITextField!
    
    @IBOutlet weak var tfSetTime: CustomUITextField!
    
    @IBOutlet weak var tvAddTitle: UITextView!
    @IBOutlet weak var tbvSuggestionKeyWord: UITableView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
 
    var dateFormatter = DateFormatter()
    let timePicker = UIDatePicker()
    var timeFormatter = DateFormatter()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    let notificationCenter = UNUserNotificationCenter.current()
    var getReminderArr = [GetReminderListModel]()
    var time = ""
    var date = ""
    let itemCell = "SuggestionKeyWordCell"
    var suggestion = [String]()
    var filterSuggestion = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        suggestion = self.doGetValueLanguageArrayString(forKey: "quick_reminder")
       
        doneButtonOnKeyboard(textField: tvAddTitle)
        doneButtonOnKeyboard(textField: tfSetDate)
        doneButtonOnKeyboard(textField: tfSetTime)
        //doCallGetReminder()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvSuggestionKeyWord.register(nib, forCellReuseIdentifier: itemCell)
        tbvSuggestionKeyWord.delegate = self
        tbvSuggestionKeyWord.dataSource = self
        tbvSuggestionKeyWord.separatorStyle = .none
        tbvSuggestionKeyWord.estimatedRowHeight = UITableView.automaticDimension
        tbvSuggestionKeyWord.rowHeight = UITableView.automaticDimension
        lblAddTitle.text = doGetValueLanguage(forKey: "reminder")
        lblReminderDate.text = doGetValueLanguage(forKey: "reminder_date")
        lblReminderTime.text = doGetValueLanguage(forKey: "reminder_time")
        btnSaveReminder.setTitle(doGetValueLanguage(forKey: "save_reminder").uppercased(), for: .normal)
        tvAddTitle.placeholder = doGetValueLanguage(forKey: "reminder_title")
        tvAddTitle.placeholderColor = .black
        setThreeCorner(viewMain: viewSetDate)
        setThreeCorner(viewMain: viewSetTime)
        
        settimePicker()
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge],completionHandler: {didAllow,error in})
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       // tvAddTitle.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tvAddTitle.delegate = self
        tbvHeight.constant = 0
        tfSetDate.delegate = self
        tfSetTime.delegate = self
        tfSetDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfSetDate.text = dateFormatter.string(from: Date())
        
       // tvAddTitle.addTarget(self, action: #selector(doFilterArray(_: )), for: .editingChanged )
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.view.endEditing(true)
        let vc = DailogDatePickerVC(onSelectDate: self, minimumDate: Date(), maximumDate: nil, currentDate: nil)
        vc.view.frame = view.frame
        addPopView(vc: vc)
    }
     override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
           return false
    }
   
    
    func textViewDidChange(_ textView: UITextView) {
        doFilterArray(text: textView.text ?? "")
        
    }
    func doFilterArray(text : String){
      
        filterSuggestion = text.isEmpty ? suggestion : suggestion.filter({ (item: String) -> Bool in
            return item.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
     
        tbvHeight.constant = 40
        if text == "" {
            filterSuggestion.removeAll()
            viewDidLayoutSubviews()
        }
        if filterSuggestion.count == 0  {
            tbvHeight.constant = 0
        }
      
        tbvSuggestionKeyWord.reloadData()
      
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     /*   let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        var currentText = ""
        if (isBackSpace == -92) {
            currentText = String(textField.text!.dropLast())
        }
        else {
            currentText = textField.text! + string
        }
        
        if currentText == "" {
            self.tbvSuggestionKeyWord.reloadData()
            tbvHeight.constant = 0
            filterSuggestion.removeAll()
        }
        else{
            filterSuggestion = tvAddTitle.text!.isEmpty ? suggestion : suggestion.filter({ (item: String) -> Bool in
                return item.lowercased().range(of: currentText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            if filterSuggestion.count > 0{
                tbvHeight.constant = 200
            } else {
                tbvHeight.constant = 0
            }
            tbvSuggestionKeyWord.reloadData()
        }*/
     
        return true
        
    }
    
//    @objc func textFieldDidChange(textField: UITextField) {
//        //your code
//
//        filterSuggestion = tvAddTitle.text!.isEmpty ? suggestion : suggestion.filter({ (item: String) -> Bool in
//            return item.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
//                     })
//
//
//
//        tbvSuggestionKeyWord.reloadData()
//        print(filterSuggestion)
//
//        if textField.text == "" {
//            tbvHeight.constant = 0
//        } else {
//            tbvHeight.constant = 300
//        }
//
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func myNotification(){
//        let nough = UNMutableNotificationContent()
//        nough.title = "hey today is 23rd deC"
//               nough.subtitle = "this is 2018"
//               nough.body = "i'm ios learner now😁"
//               nough.badge = 1
//               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//               let reQ = UNNotificationRequest(identifier: "reQi", content: nough, trigger: trigger)
//               UNUserNotificationCenter.current().add(reQ, withCompletionHandler: nil)
//
//               // 2 important things.....>> hey listen when you click notification button than go to home after showing notification on iphone remember...
//
//               // second is....>> when 1 time you click on allow notification than no more time its annoying you than remember this too.....pilowtalk now listing at pm communication iskon 4 29 pm 27 dec 2018😁
//
//    }
    func noti2(){
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = tvAddTitle.text ?? ""
        content.sound = UNNotificationSound.default

      //  let calender = Calendar(identifier: .indian)
        //let now = Date()
        
        // Change the year date everything you want 😃
//        components.year = 2020
//        components.month = 12
//        components.day = 01
//
//        components.hour = 04
//        components.minute = 02
//        components.second = 5
//        let finalDate = "\(tfSetDate.text ?? "" ) \(time ?? "")"
//        print(finalDate)
//       // return
//        let formatter4 = DateFormatter()
//        formatter4.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        print(formatter4.date(from: finalDate) ?? "Unknown date")
//        print(dateFormatter.locale = Locale.init(identifier: finalDate))
//        return
        //print(string)
       
        let dateString = "\(tfSetDate.text ?? "" ) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: dateString)

        let dateObj = dateFormatter.date(from: dateString)

   

        //let calender = Calendar.current
        //let components = calender.dateComponents([.year, .month, .day, .hour], from: dateObj!)

        
       // let components = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateObj!)
       // let date = calender.date(from: components)!
        //let finalDate = calender.date(from: components)
        let triggerDaily = Calendar.current.dateComponents([.day, .month, .month,.hour,.minute,.second,], from: dateObj!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)


        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
       print("INSIDE NOTIFICATION")

        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
           if let error = error {
               print("SOMETHING WENT WRONG\(error.localizedDescription))")
          }
      })
        doPopBAck()
    }
//    func noti(){
//        let dateComp:NSDateComponents = NSDateComponents()
//        dateComp.hour = 20
//        dateComp.minute = 43
//        dateComp.timeZone = NSTimeZone.system
//        let calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.indian)!
//        let date:NSDate = calender.date(from: dateComp as DateComponents)! as NSDate
//
//        let localNotificationSilent = UILocalNotification()
//        localNotificationSilent.fireDate = date as Date
//        localNotificationSilent.repeatInterval =  NSCalendar.Unit.day
//        localNotificationSilent.alertBody = "Started!"
//        localNotificationSilent.alertAction = "swipe to hear!"
//        localNotificationSilent.timeZone = NSCalendar.current.timeZone
//        localNotificationSilent.category = "PLAY_CATEGORY"
//        UIApplication.shared.scheduleLocalNotification(localNotificationSilent)
//    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doThisWhenNotify(reminder:)), name: .ReminderRefresh, object: nil)
       // doCallGetReminderNoti()
       
    }
    @objc func doThisWhenNotify(reminder: NSNotification) {
       // doCallGetReminderNoti()
        
        
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {

    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
 
    }
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        content.title = notificationType
        content.body = "Reminder Added "
        content.sound = .none
                content.badge = 1
        let date = Date()
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        _ = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
       
        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "test"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trig)
        

           UNUserNotificationCenter.current().delegate = self
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        //        notificationCenter.
    }
    func doValidate()->Bool{
         var isValid = true
        if tvAddTitle.text == "" {
           showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "reminder_title"))
            isValid = false
           
        }
        
        return isValid
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
//        let vc = ReminderVC()
//        self.navigationController?.popViewController(animated: true)

    }

       
    @IBAction func onClickSetTime(_ sender: Any) {
        
    }
    

  
    
    @IBAction func onClickSaveReminder(_ sender: Any) {
        
        if doValidate(){
           // doCallGetReminderNoti()
           
         doCallAddApi()
      
        }
        
    }
  
    func settimePicker(){
        
       
        
      
       
        timeFormatter.dateFormat = "hh:mm"
      //  let time = timeFormatter.string(from: timePicker.date)
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }

        
        
        timePicker.minimumDate = Date()
        

    
        let formatter = timeFormatter
        //formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        tfSetTime.text = timeFormatter.string(from: timePicker.date)
   
        tfSetTime.inputView = timePicker
        //self.time = tfSetTime.text ?? "date"
        let toolBar = UIToolbar()
       tfSetTime.delegate = self
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true)

        tfSetTime.inputAccessoryView = toolBar
            timeFormatter.dateFormat = "HH:mm:ss"
          self.time = timeFormatter.string(from: timePicker.date)
        
    }
    
    
    @objc func doneButtonTapped() {
        timeFormatter.dateFormat = "HH:mm"
        tfSetTime.text = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "HH:mm:ss"
        self.time = timeFormatter.string(from: timePicker.date)
        print("time \(time)")
        self.view.endEditing(true)
    }
  
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func doCallAddApi(){
        self.showProgress()
        
        let params = ["addReminder":"addReminder",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "reminder_text":tvAddTitle.text!,
                      "reminder_date":tfSetDate.text!,
                      "reminder_time":tfSetTime.text!,
                      "language_id":doGetLanguageId()]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { [self] (Data, error) in
            self.hideProgress()
        
            if Data != nil{
               
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        print("Add Success")
//                        self.scheduleNotification(notificationType: "Reminder Added Successfully")
                        UserDefaults.standard.set(true, forKey: "")
                        self.noti2()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    func doCallGetReminderNoti(){
        self.showProgress()

        let params = ["getReminderNotification":"getReminderNotification",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "reminder_text":tvAddTitle.text!,
                      "language_id":doGetLanguageId()]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.reminder_controller, parameters: params) { (Data, error) in


            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(GetReminderResponse.self, from: Data!)
                    if response.status == "200"{
                    print("Add Success")
                        self.scheduleNotification(notificationType: "Reminder Added ")
                        
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)

                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        
     
       // self.tbvHeight.constant = 0
        DispatchQueue.main.async {

            if self.filterSuggestion.count > 0 {
                if self.filterSuggestion.count > 10 {
                    self.tbvHeight.constant =  260
                } else {
                    self.tbvHeight.constant =  self.tbvSuggestionKeyWord.contentSize.height
                }

            }else {
                self.tbvHeight.constant = 0
            }
        }
     
    }
    
    func onSelectDate(dateString: String, date: Date) {
        // this is delegate of calender obj
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfSetDate.text = dateFormatter.string(from: date)
    }
    
}
extension AddReminderVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(filterSuggestion.count)
        return self.filterSuggestion.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//let data = suggestion[indexPath.row]
        let cell = tbvSuggestionKeyWord.dequeueReusableCell(withIdentifier: "SuggestionKeyWordCell")as! SuggestionKeyWordCell
        
        cell.lblSuggestedWord.text =  filterSuggestion[indexPath.row]
        setThreeCorner(viewMain: cell.viewMain)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tvAddTitle.text = filterSuggestion[indexPath.row]
        
        
        filterSuggestion.removeAll()
        tbvSuggestionKeyWord.reloadData()
        viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        viewDidLayoutSubviews()
        
    }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
