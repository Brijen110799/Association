//
//  DailogDatePickerVC.swift
//  Finca
//
//  Created by CHPL Group on 10/11/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit

protocol OnSelectDate {
    func onSelectDate(dateString : String,date : Date)
}

class DailogDatePickerVC: BaseVC {
    

    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var bSelect: UIButton!
    @IBOutlet weak var bCanacel: UIButton!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    private var onSelectDate  : OnSelectDate?
    private var minimumDate : Date?
    private var maximumDate : Date?
    private var currentDate : Date?

    
    convenience init() {
        self.init()
    }
    
    init(onSelectDate: OnSelectDate? , minimumDate : Date? , maximumDate : Date?, currentDate : Date? ) {
        self.onSelectDate = onSelectDate
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mexDate = maximumDate {
            datepicker.maximumDate = mexDate
        }
        
        if let minDate = minimumDate {
            datepicker.minimumDate = minDate
        }
        if let currentData = currentDate {
            datepicker.date = currentData
        }
        
        bSelect.setTitle(doGetValueLanguage(forKey: "select").uppercased(), for: .normal)
        bCanacel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
    }
  

    @IBAction func tapCancel(_ sender: UIButton) {
        removePopView()
    }
    
    @IBAction func tapSelect(_ sender: UIButton) {
        onSelectDate?.onSelectDate(dateString: dateFormatter.string(from: datepicker.date), date: datepicker.date)
        removePopView()
    }
    
    
}
