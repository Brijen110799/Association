//
//  TabMyBookingVC.swift
//  Finca
//
//  Created by Hardik on 3/27/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabMyBookingVC: BaseVC {
    
    
    @IBOutlet weak var ivNoData: UIImageView!
       var menuTitle : String!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var tbvdata: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    let itemcell = "MyEventCell"
    var mybooklist = [MyEvent](){
        didSet{
            tbvdata.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvdata.register(nib, forCellReuseIdentifier: itemcell)
        tbvdata.delegate = self
        tbvdata.dataSource = self
        //doEvent()
        tbvdata.estimatedRowHeight = 300
        tbvdata.rowHeight = UITableView.automaticDimension
        addRefreshControlTo(tableView: tbvdata)
        lbNoData.text = doGetValueLanguage(forKey: "no_booking_available")
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle),palceHolder: "")
    }
    
    override func pullToRefreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        self.mybooklist.removeAll()
        doEvent()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mybooklist.count > 0 {
            mybooklist.removeAll()
            tbvdata.reloadData()
        }
        doEvent()
    }
    
    func doEvent() {
        showProgress()
        
        let params = ["key":apiKey(),
                      "getMyBooking":"getMyBooking",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_type":doGetLocalDataUser().userType!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                print("event array ---->",json as Any)
                do {
                    let response = try JSONDecoder().decode(MyEventResponse.self, from:json!)
                    if response.status == "200" {
                        self.mybooklist = response.event
                        self.tbvdata.reloadData()
                    }else {
                        self.mybooklist.removeAll()
                        self.tbvdata.reloadData()
                    }
                } catch {
                    print("parse error")
                    print(error as Any)
                }
            }
        }
    }

    func docancelevent(id : String, attendId : String!){
        showProgress()
        let param = ["cancelAttend":"cancelAttend",
                     "event_id": id,
                     "event_attend_id":attendId!,
                     "society_id":doGetLocalDataUser().societyID!,
                     "user_id":doGetLocalDataUser().userID!,
                     "unit_id":doGetLocalDataUser().unitID!]
        print(param)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: param) { (Data, Error) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(MyEventResponse.self, from: Data!)
                    
                    if response.status == "200"{
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                         self.doEvent()
                    }else{
                       self.showAlertMessageWithClick(title: "Alert", msg: response.message)
                    }
                }catch{
                    
                }
            }else{
                
            }
        }
    }
}

extension TabMyBookingVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "my_booking"))  
    }
}

extension TabMyBookingVC : UITableViewDelegate,UITableViewDataSource,doActionMyEvent,AppDialogDelegate{

    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.mybooklist[tag]
                self.docancelevent(id: data.eventId!,attendId:data.eventAttendId)
            }
        }
    }

    func doViewPass(indexpath: IndexPath) {
        print("")
        let nextvc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idMyPassesVC")as! MyPassesVC
        nextvc.eventDetails = mybooklist[indexpath.row]
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    func doCancel(indexpath: IndexPath) {
        print("")

        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "cancel_passes"), style: .Delete,tag: indexpath.row,cancelText:doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))

        
    }
    
    func doReceipt(indexpath: IndexPath) {
//        let link =  UserDefaults.standard.string(forKey: StringConstants.KEY_BASE_URL)! + "apAdmin/paymentReceiptAndroid.php?user_id=" + doGetLocalDataUser().userID! + "&unit_id=" + doGetLocalDataUser().unitID + "&type=E&societyid=" + doGetLocalDataUser().societyID! + "&id=" + mybooklist[indexpath.row].eventId! + "&event_attend_id=\(mybooklist[indexpath.row].eventAttendId!)"
//        print("invoice link ======",link as Any)
        let link = mybooklist[indexpath.row].invoiceUrl ?? ""
        if link == "" {
            return
        }
        let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
        vc.strUrl = link
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mybooklist.count == 0 {
            self.viewNoData.isHidden = false
        } else {
            self.viewNoData.isHidden = true
        }
        return mybooklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvdata.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! MyEventCell
        
        let date = mybooklist[indexPath.row].eventDate.split{$0 == "-"}.map(String.init)
        cell.lblDate.text = date[2]
        let data = mybooklist[indexPath.row]
        cell.lblMonthYear.text = mybooklist[indexPath.row].eventMonthYearOnly
        cell.lblTime.text = mybooklist[indexPath.row].eventTime
        cell.lblTitle.text =  mybooklist[indexPath.row].eventTitle + " - " + mybooklist[indexPath.row].eventDayName
        cell.lbAdult.text = doGetValueLanguage(forKey: "adult")
        cell.lbChild.text = doGetValueLanguage(forKey: "children")
        cell.lbGuest.text = doGetValueLanguage(forKey: "guest")
        cell.bPass.setTitle(doGetValueLanguage(forKey: "view_pass").uppercased(), for: .normal)
        cell.bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        cell.bViewRecipt.setTitle(doGetValueLanguage(forKey: "view_receipt").uppercased(), for: .normal)
        if data.adultBooked == "0"{
            cell.viewAdultPass.isHidden = true
        }else{
            cell.viewAdultPass.isHidden = false
        }
        if data.childBooked == "0"{
            cell.viewChildPass.isHidden = true
        }else{
            cell.viewChildPass.isHidden = false
        }
        if data.guestBooked == "0"{
            cell.viewGuestPass.isHidden = true
        }else{
            cell.viewGuestPass.isHidden = false
        }

        cell.lblEventType.text = mybooklist[indexPath.row].eventType
        if mybooklist[indexPath.row].eventType == "0"{
            cell.lblTotalAmount.isHidden = true
            cell.lblEventType.text = doGetValueLanguage(forKey: "free") //"Free"
        }else{
            cell.lblTotalAmount.isHidden = false
            cell.lblEventType.text = doGetValueLanguage(forKey: "paid")
        }
        cell.lblNoAdult.text = mybooklist[indexPath.row].adultBooked
        cell.lblNoChild.text = mybooklist[indexPath.row].childBooked
        cell.lblBookedGuests.text = mybooklist[indexPath.row].guestBooked
        Utils.setImageFromUrl(imageView: cell.ivEvent, urlString: mybooklist[indexPath.row].eventImage, palceHolder: "banner_placeholder")
        if mybooklist[indexPath.row].eventType == EventType.paid_event.rawValue{
            cell.viewOfReceipt.isHidden = false
            cell.viewOfCancelPasses.isHidden = true
            cell.lblTotalAmount.text = "\(doGetValueLanguage(forKey: "total_amount")) : " + localCurrency() + " " + data.recivedAmount
        }else{
            if data.eventExpire {
                cell.viewOfCancelPasses.isHidden = true
            }else{
                cell.viewOfCancelPasses.isHidden = false
            }
            cell.viewOfReceipt.isHidden = true
           // cell.lblTotalAmount.text = "Free"
        }
        cell.data = self
        cell.selectionStyle = .none
        cell.indexpath = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idEventNewDetailVC") as! EventNewDetailVC
        //        print("hahahaha")
        //        print(mybooklist[indexPath.row])
        //        vc.eventModel = mybooklist[indexPath.row]
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
