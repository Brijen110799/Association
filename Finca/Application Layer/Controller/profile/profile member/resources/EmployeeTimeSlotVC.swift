//
//  EmployeeTimeSlotVC.swift
//  Finca
//
//  Created by harsh panchal on 18/11/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EmployeeTimeSlotVC: BaseVC {
    
    @IBOutlet weak var viewFab: UIView!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tbvTimeSlotList: UITableView!
    var emp_id = ""
    var emp_name = ""
    var emp_details : ModelEmployeeList!
    var dayList = [Day]()
   // let itemCell = "EmployeeTimeSlotCell"
      let itemCell = "ViewResourceScheduleCell"
    var isReleoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewFab.isHidden = true
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvTimeSlotList.register(nib, forCellReuseIdentifier: itemCell)
        tbvTimeSlotList.delegate = self
        tbvTimeSlotList.dataSource = self
        addRefreshControlTo(tableView: tbvTimeSlotList)
        tbvTimeSlotList.estimatedRowHeight = 50
        tbvTimeSlotList.rowHeight = UITableView.automaticDimension
        lblPageTitle.text = emp_name + "'s Schedule"
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        dayList.removeAll()
        tbvTimeSlotList.reloadData()
        doGetTimeSlot()
        refreshControl.endRefreshing()
    }
    
    @IBOutlet weak var viewFAB: UIView!
    func doGetTimeSlot() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getSchedule":"getScheduleNew",
                      "emp_id":emp_id,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.scheduleController, parameters: params) { (json, error) in
            if json != nil {
                self.hideProgress()
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(EmployeeTimeSlotResponse.self, from:json!)
                    if response.status == "200" {
                        if response.is_your_employee{
                            self.viewFab.isHidden = false
                        }else{
                            self.viewFab.isHidden = true
                        }
                        self.dayList = response.days
                        self.tbvTimeSlotList.reloadData()
                     
                    }else {
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @IBAction func btnAddTimeSlot(_ sender: UIButton) {
       /* let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddEmployeeTimeSlotVC")as! AddEmployeeTimeSlotVC
        nextVC.empId = self.emp_id
        nextVC.emp_details = self.emp_details
        self.navigationController?.pushViewController(nextVC, animated: true)*/
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddScheduleTimeSlotVC")as! AddScheduleTimeSlotVC
         nextVC.emp_id = self.emp_id
        nextVC.isAdd = true
        nextVC.emp_details = self.emp_details
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension EmployeeTimeSlotVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dayList[indexPath.row]
        let cell = tbvTimeSlotList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ViewResourceScheduleCell
        cell.lbDay.text = "   \(data.day!)   "
        cell.selectionStyle = .none
        cell.setData(timeslot: data.timeslot)
        cell.isView = true
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.cvTimeSlot.reloadData()
        cell.heightConCV.constant = cell.cvTimeSlot.collectionViewLayout.collectionViewContentSize.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          
     }
    
    
    

}

