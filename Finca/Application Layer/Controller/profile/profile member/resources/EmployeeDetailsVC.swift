//
//  EmployeeDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 03/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Cosmos
import Lightbox
class EmployeeDetailsVC: BaseVC {

    var ArrCount = [String]()
    var Status = Bool()
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ibProfile: UIImageView!
    @IBOutlet weak var cvUnitData: UICollectionView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lbNoOfRating: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var lbNumberUnit: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var bAddSchedule: UIButton!
    @IBOutlet weak var lbToolbarTitle: UILabel!
    @IBOutlet weak var bAddTime: UIButton!
    @IBOutlet weak var viewOfEmpID: UIView!
    @IBOutlet weak var VwID2 : UIView!
    @IBOutlet weak var heightofWorkingDayView: NSLayoutConstraint!
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    
    @IBOutlet weak var heightConTableData: NSLayoutConstraint!
    @IBOutlet weak var viewWorkingDays: UIView!
    
    @IBOutlet weak var viewNoDateSchedule: UIView!
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var lbNoDataForCurrentlyWorking: UILabel!
    @IBOutlet weak var lblWorkingScheduleTitle: UILabel!
    @IBOutlet weak var lblAvailble: UILabel!
    @IBOutlet weak var lblWorkingDays: UILabel!
    let cellUnitWorking = "EmployeeWorkingInUnitCell"
    var emp_id  = ""
    var data : ModelEmployeeList!
    var workingUnits =  [String]()
    var dayList = [Day]()
    let itemCell = "ViewResourceScheduleCell"
    
    var is_your_employee = false
    var isPopVC = false
    @IBOutlet weak var lblBooked: UILabel!
    @IBOutlet weak var lblYourBooking: UILabel!
    @IBOutlet weak var lblNodataFound: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bAddSchedule.isHidden = true
        bAddTime.setTitle(doGetValueLanguage(forKey: "add_schedule"), for: .normal)
        lblWorkingScheduleTitle.text = doGetValueLanguage(forKey: "working_schedule")
        lblAvailble.text = doGetValueLanguage(forKey: "available")
        lblBooked.text = doGetValueLanguage(forKey: "booked")
        lblYourBooking.text = doGetValueLanguage(forKey: "your_booking")
        lblNodataFound.text = doGetValueLanguage(forKey: "no_data_available")
        lblNoData.text = doGetValueLanguage(forKey: "this_resource_not_available_for_residents")
        lblWorkingDays.text = doGetValueLanguage(forKey: "working_day")
       
        
        self.viewWorkingDays.isHidden = true
        self.heightConTableData.constant = 0
        
        let nib = UINib(nibName: cellUnitWorking, bundle: nil)
        cvUnitData.register(nib, forCellWithReuseIdentifier: cellUnitWorking)
        
        cvUnitData.dataSource = self
        cvUnitData.delegate = self
        
        let nib1 = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib1, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        addRefreshControlTo(tableView: tbvData)
        tbvData.estimatedRowHeight = 50
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.isScrollEnabled = false
        tbvData.separatorStyle = .none
        //heightConTableData.constant = 600
        
       
        // Do any additional setup after loading the view.
        
        
        Utils.setImageFromUrl(imageView: ibProfile, urlString: data.empProfile, palceHolder: "user_default")
        lbToolbarTitle.text = data.empTypeName
        lbName.text = data.empName
        lbNumber.text = data.country_code + data.empMobile
        lbNoOfRating.text = data.averageRating
        ratingBar.rating = Double(data.averageRating!)!
       
        if data.entryStatus == "1" {
            // avilabe
            lbStatus.text = doGetValueLanguage(forKey: "inside_adapter")
            viewStatus.backgroundColor = ColorConstant.green500
        }else if data.entryStatus == "2" {
            // not
            lbStatus.text = doGetValueLanguage(forKey: "outside_adapter")
            viewStatus.backgroundColor = ColorConstant.red500
        } else {
            lbStatus.text = doGetValueLanguage(forKey: "no_data")
            viewStatus.backgroundColor = ColorConstant.grey_10
            lbStatus.textColor = .black
        }
  
//        if  data.emp_type == "0"{
//            // not data show
//            bAddSchedule.isHidden = true
//            viewNoData.isHidden = false
//            //aUtils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal())
//        } else {
//            viewNoData.isHidden = true
//            doGetTimeSlot()
//        }
//
//        if data.emp_type == "1"
//        {
//            bAddTime.isHidden = false
//        }
        
        
        if data.empTypeID == "0" && data.emp_type == "0"{
            // not data show
            print("TEST DATA HERE::::")
          //  bAddSchedule.isHidden = true
            viewNoData.isHidden = false
            Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal())
        } else {
            viewNoData.isHidden = true
            doGetTimeSlot()
        }
        
        
        if data.emp_id_proof_view != nil && data.emp_id_proof_view != "" {
            
            viewOfEmpID.isHidden = false
        } else {
            viewOfEmpID.isHidden = true
        }
        
        if data.emp_id_proof_view1 != nil && data.emp_id_proof_view1 != "" {
            VwID2.isHidden = false
        } else {
            VwID2.isHidden = true
        }
    }
    @IBAction func onClickIDCard(_ sender: Any) {
        
        let url = data.emp_id_proof_view!
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    @IBAction func onClickIDCard2(_ sender: Any) {
        
        let url = data.emp_id_proof_view1!
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    @IBAction func onClickCall(_ sender: Any) {
        
        if is_your_employee {
            self.doCall(on: data.country_code + " " + data.empMobile!)
                
        } else {
            if data.entryStatus == "1" {
                // avilabe
                print("clcicl" , index)
                doCall(on: data.country_code + " " + data.empMobile!)
            }else {
                // not
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "not_available"))
                
            }
        }

    }
   
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
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
                        self.heightConTableData.constant = 600
                        self.workingUnits.append(contentsOf: response.workingUnits)
                        self.cvUnitData.reloadData()
                        self.is_your_employee = response.is_your_employee
                      
                        if response.workingUnits.count > 0 {
                         //   self.lbNumberUnit.text = ("\(self.doGetValueLanguage(forKey: "currently_working_in"))\(String(  response.workingUnits.count)  )\(self.doGetValueLanguage(forKey: "units"))")
                            self.lbNumberUnit.text = "\(self.doGetValueLanguage(forKey: "currently_working_in")) \(self.doGetValueLanguage(forKey: "unit")) (\(response.workingUnits.count))"
                        } else {
                             self.lbNoDataForCurrentlyWorking.isHidden = false
                        }
                       
                          self.dayList = response.days
                        self.doSetChekedData()
                        if self.is_your_employee == true{
                            self.viewWorkingDays.isHidden = false
                            self.heightConTableData.constant = 30
                        }else{
                           
                        }
                        
                       }else {
                        self.lbNoDataForCurrentlyWorking.isHidden = false
                        self.viewSchedule.isHidden = true
                        self.viewNoDateSchedule.isHidden = false
                         self.heightConTableData.constant = 140
                        self.bAddSchedule.isHidden = true
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
       }
    
    func doSetChekedData() {
        
        
        var addTimeSlote = true
        for (indexMain , _) in dayList.enumerated() {
            
            
            for (indexSub , itemSub)  in dayList[indexMain].timeslot.enumerated() {
                
                Status = dayList[indexMain].timeslot[indexSub].already_booked_slot
                if Status == true
                {
                    ArrCount.append("1")
                }
                
                if itemSub.availbleStatus {
                
                    dayList[indexMain].timeslot[indexSub].isCheck = true
                    addTimeSlote = false
                    
                    
                } else {
                    
                    addTimeSlote = true
                    
                    if doGetLocalDataUser().unitID == itemSub.unitID {
                        
                        bAddSchedule.setTitle(doGetValueLanguage(forKey: "edit_schedule").uppercased(), for: .normal)
                        dayList[indexMain].timeslot[indexSub].isCheck = false
                        
                    } else {
                      
                        dayList[indexMain].timeslot[indexSub].isCheck = true
                    }
                    
                }
                
            }
        }
         self.tbvData.reloadData()
        
        print(ArrCount.count)
        if ArrCount.count > 0
        {
            bAddTime.isHidden = false
        }
        else
        {
            bAddTime.isHidden = true
        }
       
//        if  addTimeSlote {
//            bAddTime.isHidden = true
//
//        } else {
//             bAddTime.isHidden = false
//        }
        
        DispatchQueue.main.async {
            self.heightConTableData.constant = self.tbvData.contentSize.height
        }
    }
    @IBAction func onClickWOrkingDays(_ sender: Any) {
        let nextVC = resourceStoryboard.instantiateViewController(withIdentifier: "idResourceAttendanceVC") as! ResourceAttendanceVC
        
        nextVC.empdetails = data
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    override func viewDidLayoutSubviews() {
      
    }
    override func viewWillLayoutSubviews() {
        if dayList.count > 0 {
            heightConTableData.constant = tbvData.contentSize.height + 20
          //  print("hhh viewWillLayoutSubviews" , tbvData.contentSize.height)
            //tbvData.reloadData()
        }
        if isPopVC {
            isPopVC = false
            doPopBAck()
        }
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        
        
        let text = "Check out Maid  profile on " + doGetLocalDataUser().society_name + "\nName : " + data.empName + "\nMobile : " + data.empMobile + "\nRating : " + data.averageRating
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
  
    }
    @IBAction func onClickAddRating(_ sender: Any) {
        
       // if is_your_employee {
        let vc = UIStoryboard(name: "Resource", bundle: nil).instantiateViewController(withIdentifier: "idAddRatinAndReviewVC") as! AddRatinAndReviewVC
            //let vc = mainStoryboard.instantiateViewController(withIdentifier: "idAddRatinAndReviewVC")as! AddRatinAndReviewVC
             vc.data = data
            vc.employeeDetailsVC = self
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            addChild(vc)  // add child for main view
            view.addSubview(vc.view)
            
//        }else {
//            showAlertMessage(title: "", msg: "This resource not available for you")
//
//        }
        
        
    }
    @IBAction func onClickAddSchedule(_ sender: Any) {
        var days_name = ""
            var time_slot_id = ""
              
               
               for (indexMain , item) in dayList.enumerated() {
                   
                   
                   for itemSub in dayList[indexMain].timeslot {
                        if !itemSub.isCheck {
                           
                           if days_name == "" {
                               days_name = item.day
                           }else {
                               days_name = days_name + "," + item.day
                           }
                          
                           
                           
                           if time_slot_id == "" {
                               time_slot_id = itemSub.timeSlotId
                           }else {
                               time_slot_id = time_slot_id + "," + itemSub.timeSlotId
                           }
                       
                       }
                   }
               }
               
               if days_name == "" {
                   showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_time_slot"))
               } else {
                   doAddSchedule(days_name: days_name,time_slot_id: time_slot_id)
                    
               }
        
    }
    
    func doAddSchedule(days_name:String , time_slot_id : String) {
           showProgress()
           //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
           let params = ["key":apiKey(),
                         "addSchedule":"addScheduleNew",
                         "emp_id":emp_id,
                         "society_id" : doGetLocalDataUser().societyID!,
                         "unit_id":doGetLocalDataUser().unitID!,
                         "days_name" : days_name,
                         "time_slot_id":time_slot_id,
                         "user_id":doGetLocalDataUser().userID!]
           print("param" , params)
           let requrest = AlamofireSingleTon.sharedInstance
           requrest.requestPost(serviceName: ServiceNameConstants.scheduleController, parameters: params) { (json, error) in
               if json != nil {
                   self.hideProgress()
                   print(json as Any)
                   do {
                       let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                       if response.status == "200" {
                           self.doPopBAck()
                           
                       }else {
                           
                       }
                   } catch {
                       print("parse error")
                   }
               }
           }
       }
    @IBAction func btnOpenImage(_ sender: UIButton) {
        if ibProfile.image != nil{
            let image = LightboxImage(image:ibProfile.image!)
            let controller = LightboxController(images: [image], startIndex: 0)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            parent?.present(controller, animated: true, completion: nil)
        }
    }
}
extension EmployeeDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingUnits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellUnitWorking, for: indexPath) as! EmployeeWorkingInUnitCell
            
        
        DispatchQueue.main.async {
                        self.setupMarqee(label:cell.lbTitle)
                        cell.lbTitle.triggerScrollStart()
                    }
        cell.lbTitle.text = workingUnits[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
              /*  let label = UILabel(frame: CGRect.zero)
               label.text = workingUnits[indexPath.row]
               label.sizeToFit()
               return CGSize(width: label.frame.width + 20, height: 30)*/
            
           return CGSize(width: 150, height: 30)
       }
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 1.0
      }
      
      func collectionView(_ collectionView: UICollectionView, layout
          collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 4.0
      }
}
extension EmployeeDetailsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ViewResourceScheduleCell
        cell.lbDay.text = "   \(data.day!)   "
        cell.selectionStyle = .none
        cell.setData(timeslot: data.timeslot)
        cell.isView = false
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.cvTimeSlot.reloadData()
        cell.heightConCV.constant =
        cell.cvTimeSlot.collectionViewLayout.collectionViewContentSize.height
        cell.cvTimeSlot.tag = indexPath.row
        cell.employeeDetailsVC = self
        cell.currentLoginUserUnitId = doGetLocalDataUser().unitID!
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       //  print("hhh willDisplay" , tableView.contentSize.height)
          viewWillLayoutSubviews()
     }
}
