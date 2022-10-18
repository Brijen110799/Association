//
//  EventPaymentDetailsVC.swift
//  Finca
//
//  Created by Hardik on 3/30/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
enum EventType : String{
    case paid_event = "1"
    case free_event = "0"
}
protocol ChildVCDelegate {
    func moveChildVC()
}
class EventPaymentDetailsVC: BaseVC {
    var delegate: ChildVCDelegate?
    
    @IBOutlet weak var GstStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblSingleAdultCharge: UILabel!
    @IBOutlet weak var lblIndividualChildCharge: UILabel!
    @IBOutlet weak var lblIndividualGuestCharge: UILabel!
    @IBOutlet weak var lblAdultCount: UILabel!
    @IBOutlet weak var lblChildCount: UILabel!
    @IBOutlet weak var lblGuestCount: UILabel!
    @IBOutlet weak var lblTotalAdultCharges: UILabel!
    @IBOutlet weak var lblTotalChildCharges: UILabel!
    @IBOutlet weak var lblTotalGuestCharges: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!
    @IBOutlet weak var viewAdultCharge: UIView!
    @IBOutlet weak var viewChildCharge: UIView!
    @IBOutlet weak var viewguestCharge: UIView!
    @IBOutlet weak var tfNotes: UITextView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet var viewAmountBreakdown: UIView!
    
    @IBOutlet weak var lblAdultCurrency: UILabel!
    @IBOutlet weak var lblChildCurrency: UILabel!
    @IBOutlet weak var lblGuestCurrency: UILabel!
    @IBOutlet weak var lbTotalAmoutTitle: UILabel!
    
    @IBOutlet var btnPay: UIButton!

    @IBOutlet weak var NonGstSepratorView: UIView!
    //gst outlets
    @IBOutlet weak var viewofIGST: UIView!
    @IBOutlet weak var viewofCGST: UIView!
    @IBOutlet weak var viewOfSGST: UIView!
    @IBOutlet weak var lblIGST: UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet weak var lblIGSTAmount: UILabel!
    @IBOutlet weak var lblCGSTAmount: UILabel!
    @IBOutlet weak var lblSGSTAmount: UILabel!
    @IBOutlet weak var svAdultTotal: UIStackView!
    @IBOutlet weak var svChildTotal: UIStackView!
    @IBOutlet weak var svGuestTotal: UIStackView!
    
    @IBOutlet weak var viewMainCalulation: UIView!
    
    @IBOutlet weak var nonGstView: UIView!
    @IBOutlet weak var lbNote : UILabel!
    @IBOutlet weak var lbTotalChargeLabel : UILabel!
    
    
    var attendPerson:String!
    var note:String!
    var event_id:String!
    var noOfAttent:String!
    var isShowDelet : Bool!
    var eventModel: EventDay!
    var grandTotalNew = String( format: "%05.2f",0.00)
    var StrEventName : String!
    var grandTotal = String( format: "%05.2f",0.00)
    var taxedTotal = String(format: "%05.2f", 00.00)
    override func viewDidLoad() {
        super.viewDidLoad()
        tfNotes.placeholder = doGetValueLanguage(forKey: "write_your_notes_here")
        tfNotes.placeholderColor = .gray
        doneButtonOnKeyboard(textField: tfNotes)
        self.initPrimaryUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      //  tfNotes.contentInset = UIEdgeInsets(top: -7.0,left: 0.0,bottom: 0,right: 0.0)
        //self.NonGstSepratorView.isHidden = false
    }
    @objc  func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })

    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
  
    func initPrimaryUI(){
        self.lblTopHeading.text = eventModel.eventDayName
        self.scrollView.keyboardDismissMode = .interactive

        lblSingleAdultCharge.text =  "\(doGetValueLanguage(forKey: "adult")) (\(localCurrency()) \(eventModel.adultCharge ?? ""))"
        //: \(doGetLocalDataUser().currency!)\(eventModel.adultCharge!)"
        lblIndividualChildCharge.text = "\(doGetValueLanguage(forKey: "children")) (\(localCurrency()) \(eventModel.childCharge ?? ""))"
        //: \(doGetLocalDataUser().currency!)\(eventModel.childCharge!)"
        lblIndividualGuestCharge.text = "\(doGetValueLanguage(forKey: "guest")) (\(localCurrency()) \(eventModel.guestCharge ?? ""))"
        //: \(doGetLocalDataUser().currency!)\(eventModel.guestCharge!)"
        
        lblAdultCurrency.text = "\(doGetValueLanguage(forKey: "total_adult_charges")) (\(doGetLocalDataUser().currency!))"
        lblChildCurrency.text = "\(doGetValueLanguage(forKey: "total_child_charges")) (\(doGetLocalDataUser().currency!))"
        lblGuestCurrency.text = "\(doGetValueLanguage(forKey: "total_guest_charges")) (\(doGetLocalDataUser().currency!))"
        lbTotalAmoutTitle.text = "\(doGetValueLanguage(forKey: "total_amount")) (\(doGetLocalDataUser().currency!))"
        lbNote.text = "\(doGetValueLanguage(forKey: "notes_optional"))"
        if eventModel.maximumPassAdult == "0"{
            self.viewAdultCharge.isHidden = true
            self.svAdultTotal.isHidden = true
        }else{
            self.viewAdultCharge.isHidden = false
            self.svAdultTotal.isHidden = false
        }
        if eventModel.maximumPassChildren == "0"{
            self.viewChildCharge.isHidden = true
            self.svChildTotal.isHidden = true
            
        }else{
            self.viewChildCharge.isHidden = false
            self.svChildTotal.isHidden = false
        }
        if eventModel.maximumPassGuests == "0"{
            self.viewguestCharge.isHidden = true
            self.svGuestTotal.isHidden = true
        }else{
            self.viewguestCharge.isHidden = false
            self.svGuestTotal.isHidden = false
        }
       
        switch eventModel.eventType {

        case EventType.paid_event.rawValue:
            viewMainCalulation.isHidden = false
            lbTotalChargeLabel.isHidden = false
            
            if eventModel.is_taxble == "1" {
                //eventModel.billType == "GST"{
              //  NonGstSepratorView.isHidden = false
                nonGstView.isHidden = false
                if eventModel.taxble_type == "1" {
                  
                 //   viewofIGST.isHidden = false
                 //   viewofCGST.isHidden = true
                  //  viewOfSGST.isHidden = true
                }else {
                   
                 //   viewofIGST.isHidden = true
                  //  viewofCGST.isHidden = false
                    //viewOfSGST.isHidden = false
                }
            }else{
               // NonGstSepratorView.isHidden = true
                nonGstView.isHidden = true
              //  viewofIGST.isHidden = true
               // viewofCGST.isHidden = true
               // viewOfSGST.isHidden = true
            }
            btnPay.isHidden = true
            btnPay.setTitle(doGetValueLanguage(forKey: "pay").uppercased(), for: .normal)
            viewAmountBreakdown.isHidden = false
            let gstBreakdown =  Double(self.eventModel.tax_slab)!/2
            lblIGST.text = "IGST(" + eventModel.tax_slab! + "%):"
            lblCGST.text = "CGST(" + String(gstBreakdown) + "%):"
            lblSGST.text = "SGST(" + String(gstBreakdown) + "%):"
            lblTotalAdultCharges.text = "\t\t0.00"
            lblTotalChildCharges.text = "\t\t0.00"
            lblTotalGuestCharges.text = "\t\t0.00"
            lblTotalPayment.text = "\t\t0.00"
            lblIGSTAmount.text = "\t\t0.00"
            lblCGSTAmount.text = "\t\t0.00"
            lblSGSTAmount.text = "\t\t0.00"
          
            break;
        case EventType.free_event.rawValue:
            viewMainCalulation.isHidden = true
            lbTotalChargeLabel.isHidden = true
            btnPay.isHidden = true
          //  viewofIGST.isHidden = true
           // viewofCGST.isHidden = true
           // viewOfSGST.isHidden = true
            btnPay.setTitle(doGetValueLanguage(forKey: "yes_interested").uppercased(), for: .normal)
            viewAmountBreakdown.isHidden = true
            lblSingleAdultCharge.text =  doGetValueLanguage(forKey: "no_of_adults")
            //: \(doGetLocalDataUser().currency!)\(eventModel.adultCharge!)"
            lblIndividualChildCharge.text = doGetValueLanguage(forKey: "no_of_children")
            //: \(doGetLocalDataUser().currency!)\(eventModel.childCharge!)"
            lblIndividualGuestCharge.text = doGetValueLanguage(forKey: "no_of_Guests")
             
               
            break;
        default:
            break;
        }
    }
    func payForEvent(){
        
//            var email = ""
//
//            if self.doGetLocalDataUser().userEmail != nil && self.doGetLocalDataUser().userEmail != "" {
//                email =  self.doGetLocalDataUser().userEmail
//            }
            
         //   doCallPyUCredsAPI(email: email)
            
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_EVENT
            model.paymentForName = eventModel.eventDayName ?? ""
            model.paymentDesc = tfNotes.text ?? ""
            model.paymentAmount = self.taxedTotal
            model.PaybleAmountComma = grandTotalNew
            model.paymentFor  = "Event"
            model.eventId = eventModel.eventId ?? ""
            model.eventDayId = eventModel.eventsDayId ?? ""
            model.paymentBalanceSheetId = eventModel.balancesheetId ?? ""
            model.totalAdult = lblAdultCount.text ?? ""
            model.totalChild = lblChildCount.text ?? ""
            model.totalGuest = lblGuestCount.text ?? ""
            model.person = "\(lblAdultCount.text ?? "")~\(lblChildCount.text ?? "")~\(lblGuestCount.text ?? "")"
        model.userName = "\(doGetLocalDataUser().userFullName!)"
        model.userEmail = "\(doGetLocalDataUser().userEmail!)"
        model.userMobile = "\(doGetLocalDataUser().userMobile!)"
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.paymentSucess = self
            vc.StrDate = eventModel.eventDate
            vc.StrMaintenanceName =  "Event" + " " + eventModel.eventDayName
            vc.StrIsComeFromEvent = "1"
            navigationController?.pushViewController(vc, animated: true)
     
    }
    func doCallPyUCredsAPI(email:String) {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMerchantDetails":"getMerchantDetails",
                      "events_day_id":eventModel.eventsDayId! ,
                      "society_id":doGetLocalDataUser().societyID!,
                      "balancesheet_id":eventModel.balancesheetId!]
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.payuController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MerchantDetailResponse.self, from:json!)
                    if response.status == "200" {
                        print(self.grandTotal)
                        print("merchant id",response.merchantID!)
                        print("merchant key",response.merchantKey!)
                        print("salt key",response.saltKey!)

                        self.setupPayu(phone: self.doGetLocalDataUser().userMobile, email: email, amount: self.taxedTotal, firstname: self.doGetLocalDataUser().userFirstName, key: response.merchantKey, merchantid: response.merchantID, txnID: String(Date().millisecondsSince1970), udf1: "", udf2: "", udf3: "", udf4: "", udf5: "", udf6: "", udf7: "", udf8: "", udf9: "", udf10: "", salt:response.saltKey,isTestMode: response.isTestMode)
                        
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    func checkPayButton(){
        let adultCount = lblAdultCount.text ?? "0"
        let childCount = lblChildCount.text ?? "0"
        let guestCount = lblGuestCount.text ?? "0"

//        if adultCount == "0" || childCount == "0" || guestCount == "0"{
//            self.btnPay.isHidden = true
//        }else{
//            self.btnPay.isHidden = false
//        }
        if eventModel.eventType == EventType.free_event.rawValue{
            let count = Int(adultCount)! +  Int(childCount)! +  Int(guestCount)!
            
            if count > 0  {
                self.btnPay.isHidden = false
            } else {
                self.btnPay.isHidden = true
            }
            
        }
    }
    
    @IBAction func btnAdultCountControl(_ sender: UIButton) {
        var adultCount = Int(lblAdultCount.text!)!
        if sender.tag != 0{
            if adultCount < Int(eventModel.remainingPassAdult)!{
                adultCount += 1
            }else{
                
                if eventModel.eventType ?? "" ==  EventType.paid_event.rawValue {
                    
                    if Int(eventModel.remainingPassAdult ?? "0") ?? 0  == 0  {
                        toast(message: "\(doGetValueLanguage(forKey: "all_adult_pass_sold"))", type: .Defult)
                    } else {
                        //self.showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.maximumPassAdult ?? "0") \(doGetValueLanguage(forKey:"adult_attend"))")
                        toast(message: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.remainingPassAdult ?? "0") \(doGetValueLanguage(forKey:"adult_attend"))", type: .Defult)
                    }
                } else {
                    if Int(eventModel.remainingPassAdult ?? "0") ?? 0  == 0  {
                        toast(message: "\(doGetValueLanguage(forKey: "all_member_pass_sold"))", type: .Defult)
                    } else {
                        //self.showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.maximumPassAdult ?? "0") \(doGetValueLanguage(forKey:"adult_attend"))")
                        toast(message: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.remainingPassAdult ?? "0") \(doGetValueLanguage(forKey:"member_can_attend_event"))", type: .Defult)
                    }
                }
                  
            }
        }else{
            if adultCount != 0{
                adultCount -= 1
            }
        }
        lblAdultCount.text = String(adultCount)
        checkPayButton()
        calculateAdultCharge(adultCount: lblAdultCount.text!)
    }
    
    @IBAction func btnChildCountControl(_ sender: UIButton) {
        var childCount = Int(lblChildCount.text!)!
        
        if sender.tag != 0{
            if childCount < Int(eventModel.remainingPassChildren)!{
                childCount += 1
            }else{
                if Int(eventModel.remainingPassChildren ?? "0") ?? 0  == 0  {
                    toast(message: "\(doGetValueLanguage(forKey: "all_children_passed_out"))", type: .Defult)
                } else {
                     toast(message: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.remainingPassChildren ?? "0") \(doGetValueLanguage(forKey:"child_attend"))", type: .Defult)
                }
                
            }
        }else{
            if childCount != 0{
                childCount -= 1
            }
            
        }
        
        lblChildCount.text = String(childCount)
        checkPayButton()
        calculateChildCharge(childCount: lblChildCount.text!)
    }
    
    @IBAction func btnGuestCountControl(_ sender: UIButton) {
        var guestCount = Int(lblGuestCount.text!)!
        if sender.tag != 0{
            if guestCount < Int(eventModel.remainingPassGuests)!{
                guestCount += 1
            }else{
                if Int(eventModel.remainingPassGuests ?? "0") ?? 0  == 0  {
                    toast(message: "\(doGetValueLanguage(forKey: "all_guest_passed_out"))", type: .Defult)
                } else {
                     toast(message: "\(doGetValueLanguage(forKey: "maximum")) \(eventModel.remainingPassGuests ?? "0") \(doGetValueLanguage(forKey:"guest_attend"))", type: .Defult)
                }
            }
        }else{
            if guestCount != 0{
                guestCount -= 1
            }
            
        }

        lblGuestCount.text = String(guestCount)
        checkPayButton()
        calculateGuestCharge(guestCount: lblChildCount.text!)
    }
    
    override func onClickDone() {
        delegate?.moveChildVC()
                if let del = self.delegate {
                    del.moveChildVC()
                }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPayForEvent(_ sender: UIButton) {
        if eventModel.eventType == "1"{
            payForEvent()
        }else{
            doSubmit()
        }
        
    }
    
    func doSubmit() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "bookEventUnpaid":"bookEventUnpaid",
                      "events_day_id": eventModel.eventsDayId!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "event_id" : eventModel.eventId!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "going_person":lblAdultCount.text!,
                      "adult_person":lblAdultCount.text!,
                      "child_person":lblChildCount.text!,
                      "guest_person":lblGuestCount.text!,
                      "notes":tfNotes.text!,
                      "user_name":doGetLocalDataUser().userFullName!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }else {
                        self.showAlertMessageWithClick(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error.")
                }
            }
        }
    }

    func calculateAdultCharge(adultCount:String!){
        let adultCharge = Float(self.eventModel.adultCharge)
        let childCharge = Float(self.eventModel.childCharge)
        let guestCharge = Float(self.eventModel.guestCharge)
        //        if adultCount != "0"{
        let adult_total = Float(adultCount!)! * adultCharge!

        var child_total = Float("0.00")!
        var guest_total = Float("0.00")!
        if lblChildCount.text! == "0"{
            child_total = Float("0.00")! * childCharge!
        }else{
            child_total = Float(lblChildCount.text!)! * childCharge!
        }
        if lblGuestCount.text! == "0"{
            guest_total = Float("0.00")! * guestCharge!
        }else{
            guest_total = Float(lblGuestCount.text!)! * guestCharge!
        }
        
        lblTotalAdultCharges.text = "\(localCurrency()) \(String(format: "%05.2f", adult_total))"
      
            //"\t\t" + String( format: "%05.2f",number)
        let grandTotal = adult_total + child_total + guest_total
        //self.grandTotal = String( format: "%05.2f",grandTotal)
        grandTotalNew = String( format: "%05.2f",grandTotal)
        self.doCalculateGrandtotal()
    }

    func calculateChildCharge(childCount: String!){
        let adultCharge = Float(self.eventModel.adultCharge)
        let childCharge = Float(self.eventModel.childCharge)
        let guestCharge = Float(self.eventModel.guestCharge)
        //        if childCount != "0"{
        var adult_total = Float("0.00")!
        var  guest_total = Float("0.00")!
        if lblAdultCount.text! == "0"{
            adult_total = Float("0.00")! * adultCharge!
        }else{
            adult_total = Float(lblAdultCount.text ?? "0.00")! * adultCharge!
        }
        if lblGuestCount.text! == "0"{
            guest_total = Float("0.00")! * guestCharge!
        }else{
            guest_total = Float(lblGuestCount.text!)! * guestCharge!
        }
        
        
        let child_total = Float(lblChildCount.text!)! * childCharge!
        
        lblTotalChildCharges.text = "\(localCurrency()) \(String(format: "%05.2f", child_total))"
        
             //"\t\t" + String( format: "%05.2f",number)
        let grandTotal = adult_total + child_total + guest_total
        self.grandTotalNew = String( format: "%05.2f",grandTotal)
        self.doCalculateGrandtotal()
    }

    func calculateGuestCharge(guestCount : String!){
        let adultCharge = Float(self.eventModel.adultCharge)
        let childCharge = Float(self.eventModel.childCharge)
        let guestCharge = Float(self.eventModel.guestCharge)

        //        if guestCount != "0"{
        var adult_total = Float("0.00")!
        var child_total = Float("0.00")!
        if lblAdultCount.text! == "0"{
            adult_total = Float("0.00")! * adultCharge!
        }else{
            adult_total = Float(lblAdultCount.text ?? "0.00")! * adultCharge!
        }
        if lblChildCount.text! == "0"{
            child_total = Float("0.00")! * childCharge!
        }else{
            child_total = Float(lblChildCount.text!)! * childCharge!
        }

        let guest_total = Float(lblGuestCount.text!)! * guestCharge!
        
        lblTotalGuestCharges.text = "\(localCurrency()) \(String(format: "%05.2f", guest_total))"
      
            //"\t\t" + String( format: "%05.2f",number)

        let grandTotal = adult_total + child_total + guest_total
        self.grandTotalNew = String( format: "%05.2f",grandTotal)

        self.doCalculateGrandtotal()
    }

    func doCalculateGrandtotal(){
        if eventModel.billType == "GST"{
            var igst : Float = 0.00
            var cgst : Float = 0.00
            var sgst : Float = 0.00
            print("gst slab percentage ---- ",self.eventModel.gstSlab!)
            print("gst slab type ---- ", self.eventModel.gstType!)

            igst = Float(self.eventModel.gstSlab)!
            cgst =  Float(self.eventModel.gstSlab)!/2
            sgst =  Float(self.eventModel.gstSlab)!/2
            var grandTotalValue : Float = 0.00
            grandTotalValue = Float(self.grandTotal)!
            if eventModel.gstType == "IGST"{
                print("type igst")
                print("grand Total ---- ",self.grandTotal)
                let taxValue : Float = grandTotalValue * igst / 100
                print("igst tax ---- ",taxValue)
                print("total including tax ---- ",grandTotalValue + taxValue)
                self.lblIGSTAmount.text = String(format: "%05.2f", taxValue)
                self.lblTotalPayment.text = String(format: "%05.2f", grandTotalValue + taxValue)
                self.taxedTotal = String(format: "%05.2f", grandTotalValue + taxValue)
            }else{
                print("type sgst and cgst")
                print("grand Total ---- ",self.grandTotal)
                let sgstValue : Float = grandTotalValue * sgst / 100
                let cgstValue : Float = grandTotalValue * cgst / 100
                print("sgst tax ---- ",sgstValue)
                print("cgst tax ---- ",cgstValue)
                print("total including tax ---- ",grandTotalValue + sgstValue + cgstValue)
                self.lblSGSTAmount.text = String(format: "%05.2f", sgstValue)
                self.lblCGSTAmount.text = String(format: "%05.2f", cgstValue)
                self.lblTotalPayment.text = String(format: "%05.2f", grandTotalValue + sgstValue + cgstValue)
                self.taxedTotal = String(format: "%05.2f", grandTotalValue + sgstValue + cgstValue)
            }
        }else{
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            //numberFormatter.currencyDecimalSeparator = "##"
            let Numbers = numberFormatter.string(from: NSNumber(value:Float(grandTotalNew)!))!
            print("NUmber Adult:::",Numbers)
            
            print("grandtotalamount",grandTotalNew)
            lblTotalPayment.text = "\(localCurrency()) \(grandTotalNew)"
            self.taxedTotal = self.grandTotalNew

        }
        if eventModel.eventType == EventType.paid_event.rawValue{
           
            if  Double(grandTotalNew)! > 0 {
                self.btnPay.isHidden = false
            }else{
                self.btnPay.isHidden = true
            }
        }
        
    }

    func setupPayu(phone:String!,email:String!,amount:String!,firstname:String!,key:String!,merchantid:String!,txnID:String!,udf1:String!,udf2:String!,udf3:String!,udf4:String!,udf5:String!,udf6:String!,udf7:String!,udf8:String!,udf9:String!,udf10:String!,salt:String , isTestMode : Bool)
    {
        if email == ""{
            self.openEmailDialog(delegate: self)
        }else{
           // print("++merchantid++",merchantid)
            //print("++salt++",salt)
            //print("++key++",key)
            let txnParam = PUMTxnParam()
            //Set the parameters
            txnParam.phone = phone!
            txnParam.email = email!
            txnParam.amount = amount!
            if isTestMode {
                txnParam.environment = GatewayTransactionMode.TEST_MODE
            } else {
                txnParam.environment = GatewayTransactionMode.GATEWAY_MODE
            }
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
                    
                    let payment_address = "\(valueForKeyInResposne(key: "address1") as? String ?? "") \n \(valueForKeyInResposne(key: "address 2") as? String ?? "")"
                    
                
                    let payment_phone = valueForKeyInResposne(key: "phone") as! String
                    
                    let payment_email = valueForKeyInResposne(key: "email")as! String
                    let bank_ref_num = valueForKeyInResposne(key: "bank_ref_num")as! String
                    
                    //                    let bank_ref_num = "\(valueForKeyInResposne(key: "bank_ref_num") ?? "")"
                    
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
                        //                    var paymentType : String!
                        var paymentFor : String!
                        var paymentForID : String!
                        var balancesheetId : String!
                        //

                        paymentFor = "event booking"
                        paymentForID = self.eventModel.eventId!
                        balancesheetId = self.eventModel.balancesheetId!
                        //
                        let person = "\(self.lblAdultCount.text!)~\(self.lblChildCount.text!)~\(self.lblGuestCount.text!)"
                        self.doCallTransactionAPI(paymentType:"3", paymentName: paymentFor, payUId: "\(payuMoneyId)", txnID: payment_txnid, firstName: payment_firstname, lastName: payment_lastname, phone: payment_phone, email: payment_email, address: payment_address, bankRefNum:bank_ref_num, bankCode: bankcode, errorMessage: error_Message, nameOnCard: name_on_card, paymentStatus: payment_status, cardNum: cardnum, discount: payment_discount, UserMobile: self.doGetLocalDataUser().userMobile!, transctionAmt:amount, receiveBillId:self.tfNotes.text! , balanceSheetId: balancesheetId, Month: "", facilityType: "", noOfPerson: person, facilityId: paymentForID)


                        self.toast(message: "Payment Successfull", type: .Success)
                    }else{
                        self.toast(message: "Payment Failed", type: .Faliure)
                    }
                }else{
                    self.toast(message: "Payment canceled", type: .Warning)
                }
            }
        }
    }
    
    
    func doCallTransactionAPI(paymentType:String!,paymentName:String!,payUId:String!,txnID:String!,firstName:String!,lastName:String!,phone:String!,email:String!,address:String!,bankRefNum:String!,bankCode:String!,errorMessage:String!,nameOnCard : String!,paymentStatus:String!,cardNum:String!,discount:String!,UserMobile:String!,transctionAmt:String!,receiveBillId:String!,balanceSheetId:String!,Month:String!,facilityType:String!,noOfPerson:String!,facilityId:String!){
        
        self.showProgress()
        //
        let no_of_month = ""
        let date_booked = ""
        //        if responseFacilityDetails.facility_type  == "0"{
        //            date_booked = Month
        //            no_of_month = ""
        //        }else{
        //            no_of_month = Month
        //            date_booked = ""
        //        }
        
        let params = ["key":apiKey(),
                      "payUmoney":"payUmoney",
                      "society_id": doGetLocalDataUser().societyID!,
                      "user_id": doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "payment_for_type":paymentType!,
                      "payment_for_name":paymentName!,
                      "payuMoneyId":payUId!,
                      "payment_txnid":txnID!,
                      "payment_firstname":firstName!,
                      "payment_lastname":lastName!,
                      "payment_phone":phone!,
                      "payment_email":email!,
                      "payment_address":address ?? "",
                      "bank_ref_num":bankRefNum ?? "",
                      "bankcode":bankCode!,
                      "error_Message":errorMessage!,
                      "name_on_card":nameOnCard!,
                      "payment_status":paymentStatus!,
                      "cardnum":cardNum!,
                      "discount":discount!,
                      "user_mobile":UserMobile!,
                      "transection_amount":transctionAmt!,
                      "receive_bill_id":receiveBillId!,
                      "balancesheet_id":balanceSheetId!,
                      "no_of_month":no_of_month,
                      "facility_book_date":date_booked,
                      "facility_type":facilityType!,
                      "no_of_person":noOfPerson!,
                      "facility_id":facilityId!,
                      "events_day_id": eventModel.eventsDayId!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "unit_name":doGetLocalDataUser().unitName!]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.payuController, parameters:params) { (Data, NSError) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        //                        self.removeFromParent()
                        //                        self.view.removeFromSuperview()
                        //                        self.allFacilityController.navigationController?.popViewController(animated: true)
                        //self.toast(message: "Payment Sucessfull Done", type: 0)
                        self.showAlertMessageWithClick(title: "", msg: "Payment Sucessfull Done")
                    }else if response.status == "201" {
                        
                        self.showAlertMessageWithClick(title: "", msg: "During the transaction booking full, please contact to society admin for refund your payment.!")
                    }
                }catch{
                    
                }
            }
        }
    }
    
    func doCallEmailUpdate(updated emailID: String!){
        let params = ["setEmail":"setEmail",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_email":emailID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        Utils.updateLocalUserData()
                        self.payForEvent()
                    }else{
                    }
                }catch{
                    print("Parse error",Err as Any)
                }
            }
        }
    }
}
extension EventPaymentDetailsVC : EmailDialogDelegate , PaymentSucessDelegate {
    func onSucusses() {
        doPopBAck()
    }
    
    func UpdateButtonClicked(Update Email: String!, tag: Int!) {
        self.dismiss(animated: true){
            self.doCallEmailUpdate(updated: Email)
        }
    }
}
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
