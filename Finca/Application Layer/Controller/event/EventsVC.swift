//
//  EventsVC.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit


// MARK: - Event
struct EventResponse: Codable {
    let event: [ModelEvent]!
    let eventCompleted: [ModelEvent]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case event = "event"
        case eventCompleted = "event_completed"
        case message = "message"
        case status = "status"
    }
}

// MARK: - EventElement
struct ModelEvent: Codable {
    let maximum_pass_guests: String!
    let maximum_pass_adult: String!
    let maximum_pass_children: String!
    let maximum_pass: String!
    let eventEndDate: String!
    let goingPerson: String!
    let notesPerson: String!
    let totalPopulation: String!
    let eventID: String!
    let adultCharge: String!
    let guestCharge : String!
    let eventType: String!
    let eventTitle: String!
    let bookedBy: String!
    let eventDescription: String!
    let balancesheetID: String!
    let childCharge: String!
    let eventUpcomingCompleted: String!
    let gallery: [GalleryModel]!
    let hideStatus: String!
    let eventStartDate: String!
    let eventImage: String!
    let numberofPerson: String!
    let eventViewDate: String!
    let eventLocation : String!
     let bookingOpen : String!
    let recivedamount: String!
    let goingchild: String!
    let goingguest: String!
    let goingadult: String!
    
    enum CodingKeys: String, CodingKey {
        case maximum_pass_guests = "maximum_pass_guests"
        case maximum_pass_adult = "maximum_pass_adult"
        case maximum_pass_children = "maximum_pass_children"
        case maximum_pass = "maximum_pass"
        case guestCharge = "guest_charge"
        case eventEndDate = "event_end_date"
        case goingPerson = "going_person"
        case notesPerson = "notes_person"
        case totalPopulation = "total_population"
        case eventID = "event_id"
        case adultCharge = "adult_charge"
        case eventType = "event_type"
        case eventTitle = "event_title"
        case bookedBy = "booked_by"
        case eventDescription = "event_description"
        case balancesheetID = "balancesheet_id"
        case childCharge = "child_charge"
        case eventUpcomingCompleted = "event_upcoming_completed"
        case gallery = "gallery"
        case hideStatus = "hide_status"
        case eventStartDate = "event_start_date"
        case eventImage = "event_image"
        case numberofPerson = "numberof_person"
        case eventViewDate = "event_start_date_view"
        case eventLocation = "event_location"
        case bookingOpen = "booking_open"
        case recivedamount = "recived_amount"
        case goingchild = "going_child"
        case goingguest = "going_guest"
        case goingadult = "going_adult"
    }
}

// MARK: - Gallery
struct EventGalleryModel: Codable {
    let galleryID: String!
    let societyID: String!
    let galleryTitle: String!
    let galleryPhoto: String!
    let eventID: String!
    let uploadDateTime: String!
    
    enum CodingKeys: String, CodingKey {
        case galleryID = "gallery_id"
        case societyID = "society_id"
        case galleryTitle = "gallery_title"
        case galleryPhoto = "gallery_photo"
        case eventID = "event_id"
        case uploadDateTime = "upload_date_time"
    }
}





class EventsVC: BaseVC {
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    @IBOutlet weak var viewUpcoming: UIView!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var viewNoDate: UIView!
    
    
    @IBOutlet weak var ivUpcoming: UIImageView!
    @IBOutlet weak var ivCompleted: UIImageView!
    
    
    
    let itemCell = "EventCell"
    var eventList = [ModelEvent]()
    var eventComplitedList = [ModelEvent]()
    var isUpcoming = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoDate.clipsToBounds = true
        viewNoDate.isHidden = true
        // Do any additional setup after loading the view.
        doInintialRevelController(bMenu: bMenu)
        
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
//        ivUpcoming.setImageColor(color: .white)
//        ivCompleted.setImageColor(color: .white)
   //       doEvent()
        setSelectorEvent(selection: 1)
        addRefreshControlTo(collectionView: cvData)
    }
    
    func setSelectorEvent(selection:Int) {
        
        switch selection {
        case 1:
            //upcoming
            if eventList.count == 0 {
                viewNoDate.isHidden = false
            } else {
                viewNoDate.isHidden = true
            }
            viewUpcoming.backgroundColor = ColorConstant.colorP
            viewCompleted.backgroundColor = ColorConstant.grey_60
            isUpcoming = true
            cvData.reloadData()
            cvData.setContentOffset(.zero, animated: true)
        case 2:
            if eventComplitedList.count == 0 {
                viewNoDate.isHidden = false
            } else {
                viewNoDate.isHidden = true
            }
            
            // compltetes
            viewUpcoming.backgroundColor = ColorConstant.grey_60
            viewCompleted.backgroundColor = ColorConstant.colorP
            isUpcoming = false
            cvData.reloadData()
            cvData.setContentOffset(.zero, animated: true)
        default:
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        if eventList.count > 0 {
            eventList.removeAll()
            eventComplitedList.removeAll()
            cvData.reloadData()
        }
        if eventComplitedList.count > 0 {
            eventComplitedList.removeAll()
            cvData.reloadData()

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
                      "getEventList":"getEventList",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                print("event array ---->",json as Any)
                do {
                    let response = try JSONDecoder().decode(EventResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        if self.isUpcoming {
                            if response.event.count == 0 {
                                self.viewNoDate.isHidden = false
                            } else {
                                self.viewNoDate.isHidden = true
                            }
                        } else {
                            if response.eventCompleted.count == 0 {
                                self.viewNoDate.isHidden = false
                            } else {
                                self.viewNoDate.isHidden = true
                            }
                        }
                        
                        self.eventList = response.event
                        self.eventComplitedList = response.eventCompleted
//                        self.eventList.append(contentsOf: response.event)
//                        self.eventComplitedList.append(contentsOf: response.eventCompleted)
                        self.cvData.reloadData()
                        
                    }else {
                    }
                } catch {
                    print("parse error")
                    print(error as Any)
                }
            }
        }
        
    }
    var youtubeVideoID = ""
    @IBAction func onClickNotification(_ sender: Any) {
        
        if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.toast(message: "No Tutorial Availabel!!", type: .Warning)
        }
        
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        //  self.navigationController?.pushViewController(vc, animated: true)
        goToDashBoard(storyboard: mainStoryboard)
        
    }
    
    
    @IBAction func onClickCompleted(_ sender: Any) {
        setSelectorEvent(selection: 2)
        
    }
    
    @IBAction func onClickUpcoming(_ sender: Any) {
        setSelectorEvent(selection: 1)
        
    }
    
}


extension  EventsVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! EventCell
        
        
        if isUpcoming {
            //print("event title ======= " + eventList[indexPath.row].eventTitle)
            cell.lbTitle.text = eventList[indexPath.row].eventTitle
            cell.lbDesc.text = eventList[indexPath.row].eventDescription
            // cell.lbDate.text = eventList[indexPath.row].event_start_date
            if eventList[indexPath.row].eventType == "1"{
                cell.lblEventType.text = "Paid Event"
            }else{
                cell.lblEventType.text = "Free Event"
            }
            if eventList[indexPath.row].goingPerson == "0" {
                cell.lbAttending.text = "Yes"
                cell.lbAttending.textColor = UIColor(named: "green_a700")
            } else {
                cell.lbAttending.text = "NO"
                cell.lbAttending.textColor = UIColor(named: "red_a700")
                
            }
            //let date = eventList[indexPath.row].event_start_date
            
            /*  if eventList[indexPath.row].eventStartDate != nil {
             let time = eventList[indexPath.row].eventStartDate!.split{$0 == " "}.map(String.init)
             
             cell.lbDate.text = time[1] + time[2]
             
             }*/
            
          //  let date = convertDateFormater(eventList[indexPath.row].eventStartDate).split{$0 == "-"}.map(String.init)
            
            
            if eventList[indexPath.row].eventStartDate != nil && eventList[indexPath.row].eventStartDate != "" {
                
                let date = eventList[indexPath.row].eventStartDate.split{$0 == "-"}.map(String.init)
                let time = eventList[indexPath.row].eventStartDate.split{$0 == " "}.map(String.init)
                cell.lbDay.text = String(date[2].prefix(2))
                // cell.lbMonth.text = date[1] + ","
                cell.lbMonth.text = getMount(index: Int(date[1])! - 1)  + ","
                cell.lbYear.text = date[0] + " " + time[1] + " " + time[2]
                
               
//                print("rgdf0",time[0])
//                print("rgdf1",time[1])
//                print("rgdf1",time[2])
            }
           
            
            Utils.setImageFromUrl(imageView: cell.ivImageEvent, urlString: eventList[indexPath.row].eventImage, palceHolder: "banner_placeholder")
        } else {
          //  print("event title ======= " + eventComplitedList[indexPath.row].eventTitle)
            cell.lbTitle.text = eventComplitedList[indexPath.row].eventTitle
            
            /*  let time = eventComplitedList[indexPath.row].eventStartDate!.split{$0 == " "}.map(String.init)
             
             let date = convertDateFormater(time[0]).split{$0 == "-"}.map(String.init)
             
             cell.lbDay.text = date[2]
             cell.lbMonth.text = date[1] + ","
             cell.lbYear.text = date[0]*/
            
            
            if eventComplitedList[indexPath.row].eventStartDate != nil && eventComplitedList[indexPath.row].eventStartDate != "" {
             
            //    let date = convertDateFormater(eventComplitedList[indexPath.row].eventStartDate).split{$0 == "-"}.map(String.init)
                let date = eventComplitedList[indexPath.row].eventStartDate.split{$0 == "-"}.map(String.init)
                    
                //let day = date[2].prefix(2)
                cell.lbDay.text = String(date[2].prefix(2))
                cell.lbMonth.text = getMount(index: Int(date[1])! - 1)  + ","
                cell.lbYear.text = date[0]
                
                      
            }
             Utils.setImageFromUrl(imageView: cell.ivImageEvent, urlString: eventComplitedList[indexPath.row].eventImage, palceHolder: "banner_placeholder")
        }
        return  cell
    }  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isUpcoming {
            return eventList.count
        }else {
            return eventComplitedList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idEventDetailsVC") as! EventDetailsVC
        if isUpcoming {
            print(eventList[indexPath.row])
            
            vc.eventModel = eventList[indexPath.row]
            
        } else {
            print(eventComplitedList[indexPath.row])
            vc.eventModel = eventComplitedList[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func convertDateFormater(_ date: String) -> String
    {
        print("date " , date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        return  dateFormatter.string(from: date!)
    }
    
    
    func setupPayu(phone:String!,email:String!,amount:String!,firstname:String!,key:String!,merchantid:String!,txnID:String!,udf1:String!,udf2:String!,udf3:String!,udf4:String!,udf5:String!,udf6:String!,udf7:String!,udf8:String!,udf9:String!,udf10:String!,salt:String)
    {
        
        let txnParam = PUMTxnParam()
        //Set the parameters
        txnParam.phone = phone!
        txnParam.email = email!
        txnParam.amount = amount!
        txnParam.environment = PUMEnvironment.production
        txnParam.firstname = firstname!
        txnParam.key = key!
        txnParam.merchantid = merchantid!
        txnParam.txnID = txnID!
        txnParam.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        txnParam.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        txnParam.productInfo = "Fincasys"
        txnParam.udf1 = ""
        txnParam.udf2 = ""
        txnParam.udf3 = ""
        txnParam.udf4 = ""
        txnParam.udf5 = ""
        txnParam.udf6 = ""
        txnParam.udf7 = ""
        txnParam.udf8 = ""
        txnParam.udf9 = ""
        txnParam.udf10 = ""
        
        let hashString = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo!)|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)||||||\(salt)"
        print(hashString)
        let data = hashString.data(using: .utf8)
        txnParam.hashValue = data?.sha512().toHexString()
        
        PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self) { (response, error, extraParam) in
            print(response as Any)
            if response?["result"] != nil && (response?["result"] is [AnyHashable : Any]){
                
                let responseResult = (response?["result"] as! NSDictionary)
                
                func valueForKeyInResposne(key : String!) -> Any!{
                    return (responseResult.value(forKey: key) as Any)
                }
                let userMobile = "\(valueForKeyInResposne(key: "phone")!)"
                let payment_mode = valueForKeyInResposne(key: "mode") as! String
                let transaction_amount = valueForKeyInResposne(key: "amount") as! String
                let transaction_date = valueForKeyInResposne(key: "addedon") as! String
                let payment_status = valueForKeyInResposne(key: "status") as! String
                let payuMoneyId = valueForKeyInResposne(key: "paymentId") as! Int
                let payment_txnid = valueForKeyInResposne(key: "txnid") as! String
                let payment_firstname = valueForKeyInResposne(key: "firstname") as! String
                let payment_lastname = valueForKeyInResposne(key: "lastname")as! String
                let payment_address = "\(valueForKeyInResposne(key: "address1")!) \n \(valueForKeyInResposne(key: "address 2")!)"
                let payment_phone = valueForKeyInResposne(key: "phone") as! String
                let payment_email = valueForKeyInResposne(key: "email")as! String
                let bank_ref_num = "\(valueForKeyInResposne(key: "bank_ref_num")!)"
                let bankcode = valueForKeyInResposne(key: "bankcode") as! String
                let error_Message =  valueForKeyInResposne(key: "error_Message")as!  String
                let name_on_card = valueForKeyInResposne(key: "name_on_card") as! String
                let cardnum = valueForKeyInResposne(key: "cardnum") as! String
                let payment_discount  = valueForKeyInResposne(key: "discount") as! String
                let walletBalance = valueForKeyInResposne(key:"udf1") as! String
                let mPlan = valueForKeyInResposne(key: "udf3") as! String
                
                print("\(mPlan) , \(walletBalance) , \(cardnum) , \(name_on_card) , \(error_Message) , \(bankcode) , \(bank_ref_num) , \(payment_email) , \(payment_phone) , \(payment_firstname) , \(payment_txnid) , \(payuMoneyId) , \(payment_status) , \(transaction_date) , \(transaction_amount) , \(payment_mode) , \(userMobile)")
                
                let success = payment_status.range(of: "success", options: .caseInsensitive)
                
                if (success != nil){
                    var paymentType : String!
                    var paymentFor : String!
                    var paymentForID : String!
                    var balancesheetId : String!
                    //                    if self.isBillList{
                    //                        paymentType = "1"
                    //                        paymentFor = self.lblMaintenanceFor.text!
                    //                        paymentForID = self.billList.receiveBillID!
                    //                        balancesheetId = self.billList.balancesheetID!
                    //                    }else{
                    //                        paymentType = "0"
                    //                        paymentFor = self.lblMaintenanceFor.text!
                    //                        paymentForID = self.maintainanceList.receiveMaintenanceID!
                    //                        balancesheetId = self.maintainanceList.balancesheetID!
                    //                    }
                    
                    //                    self.doCallTransactionAPIcardNum(paymentType: paymentType!, paymentName: paymentFor, payUId: "\(payuMoneyId)", txnID: payment_txnid, firstName: payment_firstname, lastName: payment_lastname, phone: payment_phone, email: payment_email, address: payment_address, bankRefNum:bank_ref_num, bankCode: bankcode, errorMessage: error_Message, nameOnCard: name_on_card, paymentStatus: payment_status, cardNum: cardnum, discount: payment_discount, UserMobile: self.doGetLocalDataUser().userMobile!, transctionAmt:amount, receiveBillId:paymentForID , balanceSheetId: balancesheetId, Month: "", facilityType: "", noOfPerson: "", facilityId: "")
                    
                    
                    self.toast(message: "Payment Successfull", type: .Success)
                }else{
                    
                    self.toast(message: "Payment Failed", type: .Faliure)
                }
            }else{
                
                self.toast(message: "Payment canceled", type: .Warning)
            }
        }
    }
    
    
    
    func getMount(index : Int) -> String {
        
        let array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        
        return array[index]
    }
}





