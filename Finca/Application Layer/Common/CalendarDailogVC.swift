//
//  CalendarDailogVC.swift
//  Finca
//
//  Created by harsh panchal on 24/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FSCalendar
import DropDown
protocol CalendarDialogDelegate {
    func btnDoneClicked(with SelectedDateString : String!,with SelectedDate: Date!,tag : Int!)
}
class CalendarDailogVC: BaseVC {
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    var currentDate = NSDate()
    var delegate : CalendarDialogDelegate!
    @IBOutlet weak var calenderView: FSCalendar!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var tempMonthList = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var monthList:[String] = []
    var ArrStillMonth:[String] = []
    
    var Arrindex = [Int]()
    var yearArr:[String] = []
    var monthArr:[String] = []
    var selectedDate = ""
    var tag : Int!
    var dropDown = DropDown()
    
    var selectedMonth = "01"
//    var minimumDate = "2023-01-01"
//    var selectedYear = "2023"
    var minimumDate = "1900-01-01"
    var selectedYear = "1900"
    var maximumDate = ""
    var selectDate = ""
    var fromvc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendarSetup()
        let date = Date()
        let calender = Calendar.current
        var year = calender.component(.year,from: date)
        lblYear.text = String(year)
      
        for i in 0...9{
            if i == 0 {
                yearArr.append(String(year))
            }else{
                year = year-1
                yearArr.append(String(year))
            }
        
        }
       
        if maximumDate != "" {
            let date = Calendar.current.date(byAdding: .year, value: 50, to: Date())
            maximumDate = dateFormatter.string(from: date!)
        } else {
            maximumDate = dateFormatter.string(from: Date())
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        lblMonth.text = nameOfMonth
                dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MM"
         let numberM = dateFormatter.string(from: date)
         
         for i in 0...Int(numberM)! - 1 {
         monthList.append(tempMonthList[i])
         }
        
        if selectDate != "" {
            calenderView.select(dateFormatter.date(from: selectDate))
        }
        
        if fromvc == "galary" {
            //this only for galery
            calenderView.isHidden = true
        }
        if fromvc == "hisab" {
            monthList.removeAll()
            
            for i in 0...tempMonthList.count - 1 {
                if i >= Int(numberM)! - 1 {
                    print("index \(i)  = count \(Int(numberM) ?? 0)")
                    monthList.append(tempMonthList[i])
                }
            }
            
            let  year = calender.component(.year,from: date)
            yearArr.removeAll()
            yearArr.append("\(year)")
            yearArr.append("\(year+1)")
            yearArr.append("\(year+2)")
        }
    }
    @IBAction func btnMonthDropdown(_ sender: UIButton) {
        
        
        if self.fromvc == "FacilitiesBookVC"{
            monthList = tempMonthList
        }
        dropDown.anchorView = lblMonth
        dropDown.dataSource = monthList
        dropDown.selectionAction = {[unowned self] ( index: Int, item: String) in
            self.lblMonth.text = item
            var index = index
            index = index + 1
  //          var month = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            let dateM = dateFormatter.date(from: item)

            dateFormatter.dateFormat = "MM"
            let  month = dateFormatter.string(from: dateM ?? Date())
//            if index < 10{
             //   month = String(format: "%02d", index)
            self.selectedMonth = month
            let date = Date()
            let calender = Calendar.current
//            let year = calender.component(.year,from: date)
            //let day = calender.component(.day, from: date)
            var day = calender.component(.day, from: calenderView.selectedDate ?? Date())
            if day > 28 && month == "02" {
                day = 1
            }
            
            
            print("day" , day)
            let monthString = "\(self.lblYear.text!)-\(month)-\(day)"
            print("made date",monthString)
            
           // let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calDate = dateFormatter.date(from: monthString)
            print("made date cal",date)
            if calDate! > dateFormatter.date(from: self.minimumDate)! {
                // add this
            if self.fromvc == "FacilitiesBookVC"{
                if (dateFormatter.date(from: monthString)! < Date()){
                    self.showAlertMessage(title: "", msg: "Please select current or future date")
                }else{
                    self.calenderView.select(calDate, scrollToDate: true)
                    self.selectedDate = monthString
                }
                
            }else{
                self.calenderView.select(calDate, scrollToDate: true)
                self.selectedDate = monthString
            }
            }  // add this
        }
        dropDown.show()
    }
    @IBAction func btnYearDropdown(_ sender: UIButton) {
        
//        if self.fromvc == "FacilitiesBookVC"{
//            yearArr = ["2021","2022","2023"]
//        }
        
        dropDown.anchorView = lblYear
        dropDown.dataSource = yearArr
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            self.lblYear.text = item
           // let date = Date()
            let calender = Calendar.current
//            let month = calender.component(.month,from: date)
           // let day = calender.component(.day, from: date)
            let day = calender.component(.day, from: calenderView.selectedDate ?? Date())
//            let monthString = "\(item)-\(self.selectedMonth)-\(day)"
//            print("made date",monthString)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
           // let calDate = dateFormatter.date(from: monthString)
          //  print("made date cal",date)
            
            
            dateFormatter.dateFormat = "yyyy"
            if dateFormatter.string(from: Date()) != item {
                monthList = tempMonthList
            }
            else {
                
                dateFormatter.dateFormat = "MM"
                let numberM = dateFormatter.string(from: Date())
                self.selectedMonth = numberM
                monthList.removeAll()
                for i in 0...Int(numberM)! - 1 {
                    monthList.append(tempMonthList[i])
                }
           // monthList = []
                if fromvc == "hisab" {
                    
                    monthList.removeAll()
                    for i in 0...tempMonthList.count - 1 {
                        if i >= Int(numberM)! - 1 {
                            monthList.append(tempMonthList[i])
                        }
                    }
                }
            }

            
          /*  if dateFormatter.string(from: Date()) != item {
                monthList = tempMonthList
              }else{
                dateFormatter.dateFormat = "MM"
                let numberM = dateFormatter.string(from: date)
                for i in 0...Int(numberM)! - 1 {
                    monthList.append(tempMonthList[i])
                }

                
               // let last = monthList.count - 1
                self.selectedMonth = "\(monthList.count - 1)"
                monthString = "\(item)-\(self.selectedMonth)-\(day)"
                self.lblMonth.text = monthList[monthList.count - 1]
            }*/
            let monthString = "\(item)-\(self.selectedMonth)-\(day)"
            print("made date",monthString)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calDate = dateFormatter.date(from: monthString)
          
            if self.fromvc == "FacilitiesBookVC"{
//                dateFormatter.dateFormat = "yyyy"
//                let sD = dateFormatter.string(from: Date())
//
//                if sD != item {
//                    toast(message: "Please select future year", type: .Faliure)
//                    return
//
//                }
//                dateFormatter.dateFormat = "yyyy-MM-dd"
                print(monthString)
                let  sCDate = dateFormatter.string(from: Date())
                if ( dateFormatter.date(from: monthString)! <  dateFormatter.date(from: sCDate)! )  {
                    self.showAlertMessage(title: "", msg: "Please select current or future date")
                }else{
                    self.calenderView.select(calDate, scrollToDate: true)
                    self.selectedDate = monthString
                }
            }else{
                 
            self.calenderView.select(calDate, scrollToDate: true)
            self.selectedDate = monthString
            }
        }
        dropDown.show()
        
    }
    func setDateLabel(selectedDate : Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.selectedDate = formatter.string(from: selectedDate)
    }
    func initCalendarSetup(){
        calenderView.collectionView.backgroundColor = UIColor(named: "colorPrimary")
        calenderView.appearance.titleDefaultColor = UIColor.black
        calenderView.appearance.titlePlaceholderColor = UIColor(named: "gray_20")
        calenderView.appearance.subtitlePlaceholderColor = UIColor(named: "gray_20")
        calenderView.appearance.titleTodayColor = UIColor.white
        calenderView.headerHeight = 0
        calenderView.scrollEnabled = false
        calenderView.appearance.eventSelectionColor = UIColor(named: "gray_20")
        calenderView.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calenderView.delegate = self
        calenderView.dataSource = self
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calDate = dateFormatter.date(from: self.selectedDate)
            self.delegate.btnDoneClicked(with: self.selectedDate, with: calDate,tag: self.tag)
        }
    }
    
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func getPreviousMonth() -> Date? {
           return Calendar.current.date(byAdding: .month, value: -1, to: self)
       }
    func endOfNextMonth()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(byAdding: .month, value: 1, to: self.endOfMonth())
        return formatter.string(from: date!)
    }

    func startOfPreviousMonth()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(byAdding: .month, value: -1, to: self.startOfMonth())
        return formatter.string(from: date!)
    }
    
    func startOfMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
        return formatter.string(from: date)
    }
    
    func endOfMonthString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        return formatter.string(from: date)
    }
    
}
extension CalendarDailogVC : FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.setDateLabel(selectedDate: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter.date(from: minimumDate)!
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter.date(from: maximumDate)!
    }
    
    
}

