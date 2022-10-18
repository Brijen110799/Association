//
//  TabUpomingEventVC.swift
//  Finca
//
//  Created by Hardik on 3/23/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabUpomingEventVC: BaseVC {
    var delegate : ChildVCDelegate?
    
    @IBOutlet weak var ivNoData: UIImageView!
    var menuTitle : String!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var cvdata: UICollectionView!
    @IBOutlet weak var tbvdata: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    
    let itemcell = "EventTVCell"
    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvdata.register(nib, forCellReuseIdentifier: itemcell)
        tbvdata.delegate = self
        tbvdata.dataSource = self
        addRefreshControlTo(tableView: tbvdata)
        lbTitle.text = doGetValueLanguage(forKey: "no_event_available")
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle),palceHolder: "")
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if eventList.count > 0 {
            eventList.removeAll()
            tbvdata.reloadData()
        }
        doEvent()
    }
    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        //        eventList.removeAll()
        //        eventComplitedList.removeAll()
        doEvent()
    }
    func doEvent() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getEventList":"getEventListNew",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(EventResponse.self, from: json!)
                    if response.status == "200"{
                        self.eventList = response.event
                        self.tbvdata.reloadData()
                        if self.eventList.count != 0{
                            self.viewNoData.isHidden = true
                        }else{
                            self.viewNoData.isHidden = false
                        }
                    }else{
                       /// self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }

    }
    
}
extension TabUpomingEventVC : UITableViewDelegate,UITableViewDataSource,EventBookDelegate{
    func doEventBook(indexpath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventList.count)
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvdata.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! EventTVCell
        let data = eventList[indexPath.row]
        cell.lbTitle.text = eventList[indexPath.row].eventTitle
        //cell.lbDay.text = data.noOfDays
       // cell.lblTime.text = data.eventTimeOnly
        cell.lblEndDate.text = "\(doGetValueLanguage(forKey: "end_date")) : " + data.eventEndVeiwOnly
       // cell.lbMonth.text = data.eventMonthYearOnly

        Utils.setImageFromUrl(imageView: cell.ivImageEvent, urlString: eventList[indexPath.row].eventImage, palceHolder: "banner_placeholder")
        let date = eventList[indexPath.row].eventStartDateView.split{$0 == " "}.map(String.init)
        //cell.lbDate.text = date[2]
        cell.lbDate.text = date[0] + " " + date[1] + " " + date[2] + " - " + data.noOfDays + " \(doGetValueLanguage(forKey: "day"))"
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idEventNewDetailVC") as! EventNewDetailVC
        vc.delegate = self
        vc.eventModel = eventList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    
    func convertDateFormater(_ date: String) -> String{
        print("date " , date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        return  dateFormatter.string(from: date!)
    }

}

extension TabUpomingEventVC :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "upcoming"))
    }
}
extension TabUpomingEventVC: ChildVCDelegate{
    func moveChildVC() {
        if let del = self.delegate {
            del.moveChildVC()
            self.doPopBAck()
        }
    }
}
