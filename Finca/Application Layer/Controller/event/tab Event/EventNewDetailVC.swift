//
//  EventNewDetailVC.swift
//  Finca
//
//  Created by Hardik on 3/28/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
class EventNewDetailVC: BaseVC {
    var delegate : ChildVCDelegate?
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var vireCorner: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UITextView!
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var bEdit: UIButton!
    @IBOutlet weak var bYes: UIButton!
    @IBOutlet weak var heightoftbvdata: NSLayoutConstraint!
    @IBOutlet weak var tbvdata: UITableView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var vweventDescription: UIView!
    let itemcell = "EventDetailsCell"
    var eventDetailsArray = [EventDetailList]()
    var eventDayArray = [EventDay]()
    var eventModel : Event!
    var itemData = ""
    var isComeFrom = "upcoming"
    override func viewDidLoad() {
        super.viewDidLoad()
       // vireCorner.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvdata.register(nib, forCellReuseIdentifier: itemcell)
        tbvdata.delegate = self
        tbvdata.dataSource = self
        tbvdata.estimatedRowHeight = 200
        tbvdata.rowHeight = UITableView.automaticDimension
        lbTitle.text = eventModel.eventTitle
        tbvdata.isScrollEnabled = false
        Utils.setImageFromUrl(imageView: ivImage, urlString: eventModel.eventImage)

    }

    override func viewWillAppear(_ animated: Bool) {
        //setThreeCorner(viewMain: vireCorner)
        vireCorner.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        doGetEventDetail()
    }

    @IBAction func onClickImage(_ sender: Any) {
        
        let nextvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idEventDetailImageVC")as! EventDetailImageVC
        nextvc.image = eventModel
     //   print("eventModel" , eventModel)
        self.navigationController?.pushViewController(nextvc, animated: true)
 
    }
    override func viewWillLayoutSubviews() {
        self.tbvdata.setNeedsDisplay()
        self.heightoftbvdata.constant = self.tbvdata.contentSize.height;
        self.tbvdata.layoutIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.tbvdata.isScrollEnabled = false
            if self.eventDayArray.count > 0 {
                self.heightoftbvdata.constant = self.tbvdata.contentSize.height + 40
            } else {
                self.heightoftbvdata.constant = 100
            }
        }
    }
    
    @IBAction func onClickBack(_sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickGalary(_ sender: UIButton) {
        for item in eventDetailsArray{
            if item.gallery.count == 0{
                toast(message: doGetValueLanguage(forKey: "no_images_for_this_event"), type: .Success)
            }else{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGallerySliderVC")as! GallerySliderVC
                //nextVC.event_Image_Array.append(self.eventImages)
                nextVC.event_Image_Array = item.gallery!
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    func doGetEventDetail() {
        self.showProgress()
        let param = ["key":apiKey(),
                     "getEventDetailsNew":"getEventDetailsNew",
                     "user_id":doGetLocalDataUser().userID!,
                     "society_id":doGetLocalDataUser().societyID!,
                     "unit_id":doGetLocalDataUser().unitID!,
                     "user_type":doGetLocalDataUser().userType!,
                     "event_id": eventModel.eventId!,
                     "language_id":doGetLanguageId(),
                     "country_id":instanceLocal().getCountryId()]
        print(param)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: param) { (Data, Error) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(EventDetailsResponse.self, from: Data!)
                    if response.status == "200"{
                        self.eventDetailsArray = response.event
                        for item in response.event {
                            self.eventDayArray = item.eventDays
                            self.tbvdata.reloadData()
                            self.lbDesc.text = item.eventDescription
                            if item.eventDescription == "" {
                                self.vweventDescription.isHidden = true
                            }else {
                                self.vweventDescription.isHidden = false
                            }
                           // self.lblLocation.text = item.eventLocation
                            self.lblEndDate.text = "\(self.doGetValueLanguage(forKey: "end_date")) - " + item.eventEndDate
                                //"\(self.doGetValueLanguage(forKey: "start_date")) - " +  item.eventEndDate
                            self.lblStartDate.text = "\(self.doGetValueLanguage(forKey: "start_date")) - " +  item.eventStartDateView
                        }
                    }else{
                        
                    }
                }catch{
                    print(error as Any)
                }
            }else{
                print("Parse Error")
            }
        }
    }
}

extension EventNewDetailVC : UITableViewDelegate,UITableViewDataSource,EventBookDelegate{

    func doEventBook(indexpath: IndexPath) {
        if  eventDayArray[indexpath.row].eventType == EventType.paid_event.rawValue && !eventDayArray[indexpath.row].isPay {
           self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "online_payment_off"), style: .Info, tag: 0, cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "ok"))
            return
        }
        
        let nextvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idEventPaymentDetailsVC")as! EventPaymentDetailsVC
        nextvc.delegate = self
        nextvc.eventModel = eventDayArray[indexpath.row]
        nextvc.StrEventName = eventDetailsArray[0].eventTitle
        self.navigationController?.pushViewController(nextvc, animated: true)
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDayArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvdata.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! EventDetailsCell
        let data = eventDayArray[indexPath.row]
        cell.lblEventName.text =  eventDayArray[indexPath.row].eventDayName.uppercased()
        cell.lblEventDate.text = eventDayArray[indexPath.row].eventDate + " - " + eventDayArray[indexPath.row].eventTime
        cell.lbllocation.text = eventDayArray[indexPath.row].eventlocation
        cell.lbAdult.text = doGetValueLanguage(forKey: "adult") + ":"
        cell.lbChild.text =  doGetValueLanguage(forKey: "child") + ":"
        cell.lbGuest.text =  doGetValueLanguage(forKey: "guest") + ":"
    
        cell.lblAttendents.text = "\(doGetValueLanguage(forKey: "total_attendee")) : " + eventDayArray[indexPath.row].totalBooked
        if data.eventType == EventType.free_event.rawValue{
            cell.lblAdultFees.text = doGetValueLanguage(forKey: "free")
            cell.lblChildFees.text =  doGetValueLanguage(forKey: "free")
            cell.lblGuestFees.text =  doGetValueLanguage(forKey: "free")
        }else{
            cell.lblAdultFees.text = "\(doGetLocalDataUser().currency!) \(eventDayArray[indexPath.row].adultCharge ?? "")"
            cell.lblChildFees.text = "\(doGetLocalDataUser().currency!) \(eventDayArray[indexPath.row].childCharge ?? "")"
            cell.lblGuestFees.text = "\(doGetLocalDataUser().currency!) \(eventDayArray[indexPath.row].guestCharge ?? "")"
        }
       
        if isComeFrom == "upcoming" {
            
            if  !data.soldOut {
                //cell.viewBookEvent.isHidden = false
                cell.viewBookEvent.backgroundColor = ColorConstant.primaryColor
                cell.bBookEvent.isHidden = false
                cell.lbBookevent.text = doGetValueLanguage(forKey: "book_event").uppercased()
            }else {
                cell.viewBookEvent.backgroundColor = ColorConstant.grey_40
                cell.bBookEvent.isHidden = true
                cell.lbBookevent.text = doGetValueLanguage(forKey: "sold_out").uppercased()
                // cell.viewBookEvent.isHidden = true
            }
            
            
            if data.dayBookingOpen ?? false {
                cell.viewBookEvent.isHidden = false
            } else  {
                cell.viewBookEvent.isHidden = true
            }
            
            
        } else {
            cell.viewBookEvent.isHidden = true
        }
       
        cell.btnEventAddress.tag = indexPath.row
        cell.btnEventAddress.addTarget(self, action: #selector(taponaddress(_:)), for: .touchUpInside)
      
        cell.data = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        //if data.maximumPassAdult
        if data.maximumPassAdult == "0"{
            cell.viewAdult.isHidden = true
        }else{
            cell.viewAdult.isHidden = false
        }
        if data.maximumPassChildren == "0"{
            cell.viewChild.isHidden = true
        }else{
            cell.viewChild.isHidden = false
        }
        if data.maximumPassGuests == "0"{
            cell.viewGuest.isHidden = true
        }else{
            cell.viewGuest.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    @objc func taponaddress(_ sender : UIButton ){
      
        
if let str = eventDayArray[sender.tag].eventlocation
        {
    let strurl = "comgooglemaps://?saddr=&daddr=\(str)&directionsmode=driving"
    let encodedURL = strurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    if let url = URL(string: encodedURL!) {
            UIApplication.shared.open(url, options: [:])
        }
    
}
        
           
    
    }
}
extension EventNewDetailVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension EventNewDetailVC: ChildVCDelegate{
    func moveChildVC() {
        if let del = self.delegate {
            del.moveChildVC()
            self.doPopBAck()
        }
    }
}


