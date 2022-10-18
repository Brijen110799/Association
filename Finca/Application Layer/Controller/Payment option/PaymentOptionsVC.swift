//
//  PaymentOptionsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 12/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Razorpay
import Alamofire
import SwiftyJSON
import SwiftUI


//import IQKeyboardManagerSwift

struct ResponsePayment : Codable {
    let remark : String! //" : "",
    let upi_id : String! //" : "",
    let upi_logo : String! //" : "",
    let status : String! //" : "200",
    let upi_name : String! //" : "",
    let message : String! //" : "Merchnat Details Get successfully..",
    let merchant_name : String! //" : "",
    let upi_enabled : Bool! //" : false,
    let is_wallet_applied : Bool! //" : false,
    let wallet_balance : String! //" : "",
    let wallet_balance_used : String!
    let transaction_amount_using_wallet  :String!
    let payments_gateways : [PaymentsGateways]!
}
struct PaymentsGateways : Codable {
    let transaction_charges : String! //" : "2.50",
    let transaction_amount : String! //" : "102.50",
    let merchant_id : String! //" : "5376121",
    let payment_getway_name : String! //" : "Payumoney",
    let remark : String! //" : "Transaction charges 2.50 % apply*",
    let merchant_key : String! //" : "nmCrcwHb",
    let salt_key : String! //" : "5LXbGbSyjA",
    let is_test_mode : Bool! //" : true,
    let payment_getway_logo : String! //" : "https:\/ey_Logo.jpg"
    let currency : String!
    let transaction_amount_using_wallet : String!
    let transaction_charges_using_wallet : String!
    
}
struct RazorpayResponse: Codable {
    let entity: String!
    let currency: String!
    let status: String!
    let offerID: String!
    let id: String!
    let receipt: String!
    let createdAt: Int!
    let notes: [String]!
    let attempts: Int!
    let amountDue: Int!
    let amount: Int!
    let amountPaid: Int!
    
    enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case currency = "currency"
        case status = "status"
        case offerID = "offer_id"
        case id = "id"
        case receipt = "receipt"
        case createdAt = "created_at"
        case notes = "notes"
        case attempts = "attempts"
        case amountDue = "amount_due"
        case amount = "amount"
        case amountPaid = "amount_paid"
    }
}

struct PayloadDataPayment  {
        var PaybleAmountComma = ""
        var paymentFor = ""
        var paymentForName = ""
        var paymentTypeFor = ""
        var paymentAmount = ""
        var paymentDesc = ""
        var paymentReceivedId = ""
        var paymentBalanceSheetId = ""
        var paymentLateFee = ""
        var paymentDiscountAmount = ""
        var paymentTransactionsId = ""
        var paymentBankReferenceNumber = ""
        var paymentBankCode = ""
        var paymentErrorMsg = ""
        var paymentNameOnCard = ""
        var paymentCardNumber = ""
        var paymentStatus = ""
        var paymentTransactionsAmount = ""
        var paymentReceivedBillId = ""
        var paymentBillId = ""
        var paymentReceivedMaintenanceId = ""
        var paymentMaintenanceId = ""
        var paymentDiscount = ""
        var userName = ""
        var userMobile = ""
        var userEmail = ""
        var userAddress = ""
        var eventId = ""
        var eventDayId = ""
        var totalAdult = ""
        var totalChild = ""
        var totalGuest = ""
        var facilityId = ""
        var facilityName = ""
        var facilityType = ""
        var facilityAmount = ""
        var person = ""
        var month = ""
        var bookedDate = ""
        var bookingStartTimeDays = ""
        var bookingEndTimeDays = ""
        var penaltyId = ""
        var maintenanceAmount = ""
        var customAmount = ""
        var walletAmount = ""
        var walletAmountUsed = ""
        var request_type = ""
        var bookingSelectedIds = [String]()
        var package_id = ""
        var society_id = ""
        var blockID = ""
        var floorID = ""
        var userFirstName = ""
        var userLastName = ""
        var userID = ""
        var fileAgreement = [URL]()
        var fileUrl: URL!
    
}

protocol PaymentSucessDelegate {
    func onSucusses()
}

class PaymentOptionsVC: BaseVC   {
    
    func onDismiss() {
        
    }
    //RavePayProtocol
//    func tranasctionSuccessful(flwRef: String?, responseData: [String : Any]?) {
//        print(responseData?.description ?? "Nothing here")
//        toast(message: "Payment Successfully", type: .Information)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.callPaymentSucucess(paymentTransactionsId: self.timeStr, userName: self.doGetLocalDataUser().userFullName ?? "", userMobile: self.doGetLocalDataUser().userMobile ?? "", userEmail: self.doGetLocalDataUser().userEmail ?? "", userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "Flutterwave", transaction_charges: self.transaction_charges)
//        }
//    }
//    func tranasctionFailed(flwRef: String?, responseData: [String : Any]?) {
//        print(responseData?.description ?? "Nothing here")
//
//        showAlertMessage(title: "error", msg: "Payment Failed")
//    }
    var options = [String:Any]()
    var StrType = ""
    var StrDate = ""
    var StrMaintenanceName = ""
    var StrIsComeFromEvent = ""
    var StrIsComeFromRenew = ""
    var INDEX = 0
    @IBOutlet weak var lbNoPayment: UILabel!
    
    @IBOutlet weak var bPayNow: UIButton!
    
    @IBOutlet weak var lbPaymentFor: UILabel!
    @IBOutlet weak var lbPaybleAmount: UILabel!
   // @IBOutlet weak var lbPaymentAmount: UILabel!
//    var balancesheetId = ""
//    var transaction_amount = ""
//    var paymentFor = ""
//    var paymentType = ""
    var payloadDataPayment : PayloadDataPayment!
    @IBOutlet weak var ivRadioPuMoeny: UIImageView!
    @IBOutlet weak var ivPayuMoeny: UIImageView!
    @IBOutlet weak var lbDescPayUMoney: UILabel!
    @IBOutlet weak var viewPayuMoeny: UIView!
    @IBOutlet weak var viewFlutterWave: UIView!
    @IBOutlet weak var ivRadioRazor: UIImageView!
    @IBOutlet weak var ivRazor: UIImageView!
    @IBOutlet weak var ivFlutter:UIImageView!
    @IBOutlet weak var ivRadioFlutter:UIImageView!
    @IBOutlet weak var lbDescRazor: UILabel!
    @IBOutlet weak var viewRazorPay: UIView!
    @IBOutlet weak var lbDescFlutter: UILabel!
    @IBOutlet weak var lbWallatBalance: UILabel!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var ivCheck: UIImageView!
    @IBOutlet weak var viewPaymentAmount: UIView!
    @IBOutlet weak var lbPaymentAmount: UILabel!
    @IBOutlet weak var viewWalletAmountApplied: UIView!
    @IBOutlet weak var lbWalletAmountApplied: UILabel!
    
    @IBOutlet weak var lbPaymentForLabel : UILabel!
    @IBOutlet weak var lbUseWallet : UILabel!
    @IBOutlet weak var lbPaymentSummery : UILabel!
    @IBOutlet weak var lbPaymentAmountLabel : UILabel!
    @IBOutlet weak var lbWalletApplied : UILabel!
    @IBOutlet weak var lbPaybleAmountLabel : UILabel!
    var documentdata = Data()
    
    var temp = "0"
    var tempModelFlutterwave : PaymentsGateways!
    var tempModelPau : PaymentsGateways!
    var tempModelRazor : PaymentsGateways!
    var paymentsGateways : PaymentsGateways!
    var facilityId = ""
    let requrest = AlamofireSingleTon.sharedInstance
    var razorpay: RazorpayCheckout!
    var respose : RazorpayResponse!
    var order_id = ""
    var paymentSucess : PaymentSucessDelegate!
    var walletBalance = 0.0
    var walletBalanceUsing = 0.0
    var isCheck = true
    var paybleAmount = 0.0
    var transactionAmountUsingWallet = 0.0
    var payments_gateways = [PaymentsGateways]()
    var  is_wallet_applied = false
    var isApplyWallet = false
    var transaction_charges = "0"
    var wallet_balance_used = 0.0
    var is_wallet_applieds = Bool()
    var timeStr = ""
    var paymentID = ""
    var isComeFromPlan = ""
    var registerParamter = [String : String]()
    var userTempMail = ""
    var fromHome = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Str = NSDate().timeIntervalSince1970
        timeStr = "txn_" + String(Str)
      
       // print(payloadDataPayment)
        lbPaybleAmount.text = payloadDataPayment.PaybleAmountComma
        print(payloadDataPayment.paymentAmount)
        print(payloadDataPayment.paymentForName)
        lbPaymentFor.text = payloadDataPayment.paymentForName
        paybleAmount = Double(payloadDataPayment.paymentAmount) ?? 0.0
        viewPaymentAmount.isHidden  = true
        viewWalletAmountApplied.isHidden  = true
        lbPaymentForLabel.text = doGetValueLanguage(forKey: "payment_for")
        lbUseWallet.text = doGetValueLanguage(forKey: "use_wallet_balance")
        lbPaymentSummery.text = doGetValueLanguage(forKey: "payment_Summary")
        lbPaymentAmountLabel.text = doGetValueLanguage(forKey: "payment_amount")
        lbWalletApplied.text = doGetValueLanguage(forKey: "wallet_amount_applied")
        lbPaybleAmountLabel.text = doGetValueLanguage(forKey: "payable_amount")
       
            self.doGetPaymentDetails()
        
        
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func tapPayNoew(_ sender: Any) {
        var email = ""
        if self.payloadDataPayment.userEmail != "" {
            if userTempMail != ""{
                email =  self.payloadDataPayment.userEmail
            }else{
                email =  self.doGetLocalDataUser().userEmail
            }
            
        }else {
            if doGetLocalDataUser().userEmail != nil{
                email = doGetLocalDataUser().userEmail
            }else{
                self.openEmailDialog(delegate: self)
            }
        }
     
        if paybleAmount > 0 {
            payloadDataPayment.walletAmountUsed = "\(self.walletBalanceUsing)"
            var paybleAmount = paymentsGateways.transaction_amount ?? "0"
            transaction_charges = paymentsGateways.transaction_charges ?? "0"
            if isApplyWallet {
                paybleAmount = paymentsGateways.transaction_amount_using_wallet ?? "0"
                transaction_charges = paymentsGateways.transaction_charges_using_wallet ?? "0"
            }
            self.paybleAmount = Double(paybleAmount)!
            if paymentsGateways.payment_getway_name == "Payumoney" {
              
                self.setupPayu(phone: payloadDataPayment.userMobile, email: email, amount: paybleAmount , firstname: payloadDataPayment.userFirstName, key: paymentsGateways.merchant_key, merchantid: paymentsGateways.merchant_id, txnID: String(Date().millisecondsSince1970), udf1: "", udf2: "", udf3: "", udf4: "", udf5: "", udf6: "", udf7: "", udf8: "", udf9: "", udf10: "", salt:paymentsGateways.salt_key,isTestMode: paymentsGateways.is_test_mode, transaction_charges: transaction_charges)
                
            } else if paymentsGateways.payment_getway_name == "Razorpay" {
                if userTempMail != ""{
                    doOpenRazorPay(keyId: paymentsGateways.merchant_id, amount: paybleAmount, currency: paymentsGateways.currency, keySecret: paymentsGateways.merchant_key, contact: self.payloadDataPayment.userMobile , email: self.payloadDataPayment.userEmail ,desc: payloadDataPayment.paymentForName)
                }else{
                    doOpenRazorPay(keyId: paymentsGateways.merchant_id, amount: paybleAmount, currency: paymentsGateways.currency, keySecret: paymentsGateways.merchant_key, contact: self.doGetLocalDataUser().userMobile , email: self.doGetLocalDataUser().userEmail ,desc: payloadDataPayment.paymentForName)
                }
                
                
            } else if paymentsGateways.payment_getway_name == "Flutterwave" {
//                let config = RaveConfig.sharedConfig()
//              //  config.isPreAuth = false
//                config.country = "NG"
//                config.currencyCode = "NGN"
//                config.email = self.doGetLocalDataUser().userEmail ?? ""
//                config.isStaging = paymentsGateways.is_test_mode
//                config.phoneNumber = self.doGetLocalDataUser().userMobile ?? ""
//                config.transcationRef = timeStr
//                config.firstName = self.doGetLocalDataUser().userFirstName!
//                config.lastName = self.doGetLocalDataUser().userLastName!
//                config.meta = [["metaname":"sdk", "metavalue":"ios"]]
//                config.publicKey = paymentsGateways.merchant_id!
//                config.encryptionKey = paymentsGateways.salt_key!
//                let controller = NewRavePayViewController()
//                let nav = UINavigationController(rootViewController: controller)
//                controller.amount = paymentsGateways.transaction_amount ?? ""
//                controller.delegate = self
//                self.present(nav, animated: true)
            }
        } else {
            let timestamp = NSDate().timeIntervalSince1970
            if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN {
                self.doCallPlanRenew(paymentTransactionsId: "\(timestamp)", userName: self.payloadDataPayment.userName , userMobile: self.payloadDataPayment.userMobile , userEmail: self.payloadDataPayment.userEmail , userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "Wallet", transaction_charges: self.transaction_charges, paymentDiscount: "")
            } else   if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER {
                self.doCallRegisterWithPlan(paymentTransactionsId: "\(timestamp)", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "Wallet", transaction_charges: self.transaction_charges)
            }else {
                self.callPaymentSucucess(paymentTransactionsId: "\(timestamp)", userName: payloadDataPayment.userName , userMobile: payloadDataPayment.userMobile , userEmail: payloadDataPayment.userEmail , userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "Wallet", transaction_charges:  "0", paymentDiscount: "")
            }
        }
    }
    private func doGetPaymentDetails() {
        showProgress()
       
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var params = [String : String]()
        
        if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER {
            
            
            params =  ["getMerchantDetailsNew":"getMerchantDetailsNew",
                       "balancesheet_id":payloadDataPayment.paymentBalanceSheetId,
                       "transaction_amount" : payloadDataPayment.paymentAmount,
                       "society_id": payloadDataPayment.society_id,
                       "user_mobile": payloadDataPayment.userMobile,
                       "language_id" : doGetLanguageId()]
            
        } else {
            params = ["getMerchantDetailsNew":"getMerchantDetailsNew",
                      "balancesheet_id":payloadDataPayment.paymentBalanceSheetId,
                      "transaction_amount" : payloadDataPayment.paymentAmount,
                      "society_id":doGetLocalDataUser().societyID,
                      "user_mobile":doGetLocalDataUser().userMobile,
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "language_id" : doGetLanguageId()]
            
        }
               
        print("param" , params)
        requrest.requestPost(serviceName: ServiceNameConstants.payment_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponsePayment.self, from:json!)
                    if response.status == "200" {
                      
                        self.is_wallet_applieds  = response.is_wallet_applied
                        print(self.is_wallet_applied)
                        if response.payments_gateways != nil && response.payments_gateways.count > 0 {
                            
                        self.payments_gateways = response.payments_gateways
                        if response.payments_gateways != nil &&   response.payments_gateways.count > 0 {
                            
                            for (index , item) in response.payments_gateways.enumerated() {
                                
                                if item.payment_getway_name == "Payumoney" {
                                    self.setupPayUMoeny(paymentsGateways: item)
                                }else  if item.payment_getway_name == "Razorpay" {
                                    self.setupRazorPay(paymentsGateways: item)
                                }else  if item.payment_getway_name == "Flutterwave" {
                                   // self.setupFlutterwave(paymentsGateways: item)
                                }
                                print(index)
                                print(self.INDEX = index)
                            }
                            if response.is_wallet_applied != nil && response.is_wallet_applied {
                                self.is_wallet_applied = response.is_wallet_applied
                                self.walletBalance = Double(response.wallet_balance ?? "0") ?? 0.0
                                self.walletBalanceUsing = Double(response.wallet_balance_used ?? "0") ?? 0.0
                                self.transactionAmountUsingWallet = Double(response.transaction_amount_using_wallet ?? "0") ?? 0.0
                                self.payloadDataPayment.walletAmount = response.wallet_balance
                                self.viewWallet.isHidden = false
                                self.lbWallatBalance.text = "\(self.localCurrency())\(response.wallet_balance ?? "0.0")"
                              
                            } else {
                                self.viewWallet.isHidden = true
                                self.paybleAmount = Double(self.payloadDataPayment.paymentAmount) ?? 0.0
                            }
                        }else
                        {
                            //self.lbNoPayment.text = "No payment method available please contact admin"
                            self.showAlertMessageWithClick(title: "Alert", msg: "No payment method available please contact admin")
                        }
                        }else {
                           // self.lbNoPayment.text = "No payment method available please contact admin"
                            self.showAlertMessageWithClick(title: "Alert", msg: "No payment method available please contact admin")
                        }
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func tapPayuMoney(_ sender: Any) {
        ivRadioRazor.image = UIImage(named: "radio-blank")
        paymentsGateways = tempModelPau
        
        if temp == "1" {
            temp = "0"
            bPayNow.isHidden = true
            ivRadioPuMoeny.image = UIImage(named: "radio-blank")
        } else {
            temp = "1"
            bPayNow.isHidden = false
            ivRadioPuMoeny.image = UIImage(named: "radio-selected")
            ivRadioFlutter.image = UIImage(named: "radio-blank")
            ivRadioRazor.image = UIImage(named: "radio-blank")
            
            bPayNow.setTitle("Pay With \(tempModelPau.payment_getway_name ?? "")".uppercased(), for: .normal)
        }
        StrType = "PayUMoeny"
        ivRadioPuMoeny.setImageColor(color: ColorConstant.primaryColor)
        ivRadioRazor.setImageColor(color: ColorConstant.primaryColor)
        ivRadioFlutter.setImageColor(color: ColorConstant.primaryColor)
        
    }
    @IBAction func tapFlutterwave(_ sender: UIButton) {
        paymentsGateways = tempModelFlutterwave
        ivRadioFlutter.image = UIImage(named: "radio-blank")
       
        if temp == "3" {
            temp = "0"
            bPayNow.isHidden = true
            ivRadioFlutter.image = UIImage(named: "radio-blank")
        } else {
            temp = "3"
            bPayNow.isHidden = false
            ivRadioFlutter.image = UIImage(named: "radio-selected")
            ivRadioPuMoeny.image = UIImage(named: "radio-blank")
            ivRadioRazor.image = UIImage(named: "radio-blank")
            bPayNow.setTitle("Pay With \(tempModelFlutterwave.payment_getway_name ?? "")".uppercased(), for: .normal)
        }
        StrType = "Flutterwave"
        ivRadioPuMoeny.setImageColor(color: ColorConstant.primaryColor)
        ivRadioRazor.setImageColor(color: ColorConstant.primaryColor)
        ivRadioFlutter.setImageColor(color: ColorConstant.primaryColor)
    }
    @IBAction func tapRaroz(_ sender: Any) {
        paymentsGateways = tempModelRazor
        ivRadioPuMoeny.image = UIImage(named: "radio-blank")
       
        if temp == "2" {
            temp = "0"
            bPayNow.isHidden = true
            ivRadioRazor.image = UIImage(named: "radio-blank")
        } else {
            temp = "2"
            bPayNow.isHidden = false
            ivRadioRazor.image = UIImage(named: "radio-selected")
            ivRadioFlutter.image = UIImage(named: "radio-blank")
            ivRadioPuMoeny.image = UIImage(named: "radio-blank")
            bPayNow.setTitle("Pay With \(tempModelRazor.payment_getway_name ?? "")".uppercased(), for: .normal)
        }
        StrType = "RazorPay"
        ivRadioPuMoeny.setImageColor(color: ColorConstant.primaryColor)
        ivRadioRazor.setImageColor(color: ColorConstant.primaryColor)
        ivRadioFlutter.setImageColor(color: ColorConstant.primaryColor)
    }
    override func onClickDone() {
        doPopBAck()
    }
    @IBAction func tapCheckWallet(_ sender: Any) {
        temp = "0"
        self.bPayNow.setTitle("PAY NOW", for: .normal)
        ivRadioRazor.image = UIImage(named: "radio-blank")
        ivRadioPuMoeny.image = UIImage(named: "radio-blank")
        ivFlutter.image = UIImage(named: "radio-blank")
        if isCheck {
            isCheck = false
            isApplyWallet = true
            self.viewPaymentAmount.isHidden  = false
            self.viewWalletAmountApplied.isHidden  = false
            self.ivCheck.image = UIImage(named: "check_box")
            self.ivCheck.setImageColor(color: ColorConstant.colorP)
            if walletBalance > 0 {
                self.paybleAmount = self.transactionAmountUsingWallet
                self.lbPaymentAmount.text = "\(localCurrency())\(payloadDataPayment.paymentAmount)"
                
                self.lbWalletAmountApplied.text = "\(localCurrency()) -" + String(format: "%.2f", walletBalanceUsing)
                wallet_balance_used = walletBalanceUsing
                self.lbPaybleAmount.text = "\(localCurrency())" +  String(format: "%.2f", transactionAmountUsingWallet)
                //self.lbWalletAmountApplied.text = "\(localCurrency())\(transactionAmountUsingWallet)"
                let amountRemaingBal = walletBalance - walletBalanceUsing
                self.lbWallatBalance.text = "\(localCurrency())" + String(format: "%.2f", amountRemaingBal)
                if paybleAmount > 0 {
                    self.bPayNow.isHidden = true
                    if    payments_gateways.count > 0 {
                        
                        for item in payments_gateways {
                            
                            if item.payment_getway_name == "Payumoney" {
                                self.setupPayUMoeny(paymentsGateways: item)
                            }else  if item.payment_getway_name == "Razorpay" {
                                self.setupRazorPay(paymentsGateways: item)
                            }else if item.payment_getway_name == "Flutterwave" {
                                //self.setupFlutterwave(paymentsGateways: item)
                            }
                            
                        }
                    }
                    
                }else {
                    payloadDataPayment.walletAmountUsed = "\(self.transactionAmountUsingWallet)"
                    self.bPayNow.isHidden = false
                    self.viewRazorPay.isHidden = true
                    self.viewPayuMoeny.isHidden = true
                    self.viewFlutterWave.isHidden = true
                    
                }
            }
            
        } else {
            isCheck = true
            isApplyWallet = false
            self.ivCheck.image = UIImage(named: "check_box_uncheck")
            self.ivCheck.setImageColor(color: ColorConstant.colorP)
            self.paybleAmount = self.transactionAmountUsingWallet
            self.bPayNow.isHidden = true
            self.paybleAmount = self.transactionAmountUsingWallet
            self.lbPaybleAmount.text = "\(localCurrency())\(transactionAmountUsingWallet)"
            self.lbWallatBalance.text = "\(localCurrency())" + String(format: "%.2f", walletBalance)
            lbPaybleAmount.text = "\(localCurrency())\(payloadDataPayment.paymentAmount)"
            paybleAmount = Double(payloadDataPayment.paymentAmount) ?? 0.0
            wallet_balance_used = 0
            self.viewPaymentAmount.isHidden  = true
            self.viewWalletAmountApplied.isHidden = true
           
            if    payments_gateways.count > 0 {
                
                for item in payments_gateways {
                    
                    if item.payment_getway_name == "Payumoney" {
                        //
                        self.setupPayUMoeny(paymentsGateways: item)
                    }else  if item.payment_getway_name == "Razorpay" {
                        self.setupRazorPay(paymentsGateways: item)
                    }else if item.payment_getway_name == "Flutterwave" {
                        //self.setupFlutterwave(paymentsGateways: item)
                    }
                }
            }
        }
    }
    func doUpiSetepu() {
        
        //  let str =  "gpay://upi/pay?pa=\("9726686576@ybl")&pn=\("Asif Hingora")&tr=\("qtgxbds")&mc=\("mcValue")&tn=\("tnValue")&am=\("1")&cu=\("INR")"
        
        //  let str =  "gpay://upi/pay?pa=\("9726686576@ybl")&pn=\("Asif Hingora")&am=\("1")&cu=\("INR")&tn=\("")"
      /*    let str =  "phonepe://upi/pay?pa=\("9726686576@ybl")&pn=\("Asif Hingora")&am=\("1")&cu=\("INR")&tn=\("")"
        
               guard let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               else {
                   return
               }

               guard let url = URL(string: urlString) else {
                   return
               }
              
         // UIApplication.shared.open(url)
          
          UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
              
              print(success)
              
          })
        
           return*/
        
    }
    func setupFlutterwave(paymentsGateways:PaymentsGateways) {
        tempModelFlutterwave = paymentsGateways
        viewFlutterWave.isHidden = false
        Utils.setImageFromUrl(imageView: ivFlutter, urlString: paymentsGateways.payment_getway_logo!)
        lbDescFlutter.text = paymentsGateways.remark
    }
    func setupPayUMoeny(paymentsGateways:PaymentsGateways) {
        tempModelPau = paymentsGateways
        viewPayuMoeny.isHidden = false
        Utils.setImageFromUrl(imageView: ivPayuMoeny, urlString: paymentsGateways.payment_getway_logo!)
        lbDescPayUMoney.text = paymentsGateways.remark
    }
    func setupRazorPay(paymentsGateways:PaymentsGateways) {
        tempModelRazor = paymentsGateways
        viewRazorPay.isHidden = false
        Utils.setImageFromUrl(imageView: ivRazor, urlString: paymentsGateways.payment_getway_logo!)
        lbDescRazor.text = paymentsGateways.remark
       // StrType = "RazorPay"
    }
    func setupPayu(phone:String!,email:String!,amount:String!,firstname:String!,key:String!,merchantid:String!,txnID:String!,udf1:String!,udf2:String!,udf3:String!,udf4:String!,udf5:String!,udf6:String!,udf7:String!,udf8:String!,udf9:String!,udf10:String!,salt:String,paymentType:String="",paymentFor:String="",paymentForID:String!="",balancesheetId:String!="",facilityId:String!="",isTestMode : Bool,transaction_charges : String)
    {
        if email == "" {
            self.openEmailDialog(delegate: self)
        }else{
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
            txnParam.productInfo = doGetValueLanguage(forKey: "app_name")
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
            
                if let error = error {
                    
                    print("pay uy error \(error)")
                    self.showAlertMessage(title: "", msg: error.localizedDescription)
                    return
                }
                if response?["result"] != nil && (response?["result"] is [AnyHashable : Any]){

                    let responseResult = (response?["result"] as! NSDictionary)

                    func valueForKeyInResposne(key : String!) -> Any!{
                        return (responseResult.value(forKey: key) as Any)
                    }
//                    let userMobile = "\(valueForKeyInResposne(key: "phone") ?? "")"
//                    let payment_mode = valueForKeyInResposne(key: "mode") ?? ""
//                    let transaction_amount = valueForKeyInResposne(key: "amount") ?? ""
//                    let transaction_date = valueForKeyInResposne(key: "addedon") ?? ""
                    let payment_status = valueForKeyInResposne(key: "status")  as! String
                   
                 //   let payment_txnid = valueForKeyInResposne(key: "txnid") ?? ""
                    let payment_firstname = valueForKeyInResposne(key: "firstname") as? String
                 //   let payment_lastname = valueForKeyInResposne(key: "lastname")as! String
                   // let payment_address = "\(valueForKeyInResposne(key: "address1")!) \n \(valueForKeyInResposne(key: "address 2")!)"
                    let payment_phone = valueForKeyInResposne(key: "phone")  as? String
                    let payment_email = valueForKeyInResposne(key: "email") as? String
                    let bank_ref_num =  valueForKeyInResposne(key: "bank_ref_num") as? String
                    let bankcode = valueForKeyInResposne(key: "bankcode") as? String
                    let error_Message =  valueForKeyInResposne(key: "error_Message") as? String
                    let name_on_card = valueForKeyInResposne(key: "name_on_card") as? String
                    let cardnum = valueForKeyInResposne(key: "cardnum") as? String
               //     let payment_discount  = valueForKeyInResposne(key: "discount") as! String
                  //  let walletBalance = valueForKeyInResposne(key:"udf1") as? String
                   // let mPlan = valueForKeyInResposne(key: "udf3") as? String

                    var payuMoneyId : NSNumber = 0
                    if  let paymentId = valueForKeyInResposne(key: "paymentId") {
                        payuMoneyId =  paymentId as? NSNumber ?? 0
                    } else {
                        if  let encryptedPaymentId = valueForKeyInResposne(key: "encryptedPaymentId") {
                            payuMoneyId = encryptedPaymentId as? NSNumber ?? 0
                        }
                    }
                  
                    
                    //print("\(mPlan) , \(walletBalance) , \(cardnum) , \(name_on_card) , \(error_Message) , \(bankcode) , \(bank_ref_num) , \(payment_email) , \(payment_phone) , \(payment_firstname) , \(payment_txnid) , \(payuMoneyId) , \(payment_status) , \(transaction_date) , \(transaction_amount) , \(payment_mode) , \(userMobile)")

                    let success = payment_status.range(of: "success", options: .caseInsensitive)

                    if (success != nil){
                        if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN {
                            self.doCallPlanRenew(paymentTransactionsId: "\(payuMoneyId)", userName: self.payloadDataPayment.userName , userMobile: self.payloadDataPayment.userMobile, userEmail: self.payloadDataPayment.userEmail, userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "PayUMoney", transaction_charges: self.transaction_charges, paymentDiscount: "")
                        } else   if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER {
                            self.doCallRegisterWithPlan(paymentTransactionsId: "\(payuMoneyId)",  paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "PayUMoney", transaction_charges: self.transaction_charges)
                        } else {
                            
                            self.callPaymentSucucess(paymentTransactionsId: "\(payuMoneyId)", userName: payment_firstname ?? "" , userMobile: payment_phone ?? "", userEmail: payment_email ?? "", userAddress: "", paymentBankReferenceNumber: bank_ref_num ?? "", paymentBankCode: bankcode ?? "", paymentErrorMsg: error_Message ?? "", paymentNameOnCard: name_on_card ?? "", paymentStatus: payment_status, paymentCardNumber: cardnum ?? "", payment_mode: "PayUMoney", transaction_charges: transaction_charges, paymentDiscount: "")
                        }
//                        self.doCallTransactionAPIcardNum(paymentType: paymentType, paymentName: paymentFor, payUId: "\(payuMoneyId)", txnID: payment_txnid, firstName: payment_firstname, lastName: payment_lastname, phone: payment_phone, email: payment_email, address: payment_address, bankRefNum:bank_ref_num, bankCode: bankcode, errorMessage: error_Message, nameOnCard: name_on_card, paymentStatus: payment_status, cardNum: cardnum, discount: payment_discount, UserMobile: self.doGetLocalDataUser().userMobile!, transctionAmt:amount, receiveBillId:paymentForID , balanceSheetId: balancesheetId, Month: "", facilityType: "", noOfPerson: "", facilityId: facilityId)
                        //
                        //                    UIUtility.toastMessage(onScreen: "Payment Successfull")
                    }else{
                        UIUtility.toastMessage(onScreen: "Payment failed", from: self)
                    }
                }else{
                    //UIUtility.toastMessage(onScreen: "Payment canceled", from: self)
                    
                    let vc = PaymentDetailVC()
                    if self.StrType == "PayUMoeny"
                    {
                        vc.SelectedPaymentsGateways =  self.tempModelPau
                    }else if self.StrType == "RazorPay"
                    {
                        vc.SelectedPaymentsGateways = self.tempModelRazor
                    }else
                    {
                        vc.SelectedPaymentsGateways = self.tempModelFlutterwave
                    }
                    vc.payments_gateways = self.payments_gateways
                    vc.StrPayment = self.StrType
                    vc.StrDate = self.StrDate
                    vc.paymentTransactionsId = "N/A"
                    vc.StrMaintenanceName = self.StrMaintenanceName
                    vc.StrSuccess = "Failed"
                    vc.StrIsComeFromEvent = self.StrIsComeFromEvent
                    vc.StrIsComeFromRenew = self.StrIsComeFromRenew
                    self.navigationController?.pushViewController(vc, animated: true)
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
                        self.toast(message: "Email update sucessfully", type: .Success)
                    }else{
                    }
                }catch{
                    print("Parse error",Err as Any)
                }
            }
        }
    }
    func callPaymentSucucess(paymentTransactionsId : String,userName:String,userMobile:String,userEmail:String,userAddress:String,paymentBankReferenceNumber:String,paymentBankCode:String,paymentErrorMsg:String,paymentNameOnCard:String,paymentStatus:String,paymentCardNumber:String,payment_mode:String,transaction_charges:String,paymentDiscount:String) {
       
        let params = ["pay":"pay",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "paymentFor"  : payloadDataPayment.paymentFor,
                      "paymentForName"  : payloadDataPayment.paymentForName,
                      "paymentTypeFor"  : payloadDataPayment.paymentTypeFor,
                      "paymentDescription"  : payloadDataPayment.paymentDesc ,
                      "paymentTransactionsId" : paymentTransactionsId ,
                      "userName" : userName,
                      "userMobile" : userMobile,
                      "userEmail" : userEmail,
                      "userAddress" : userAddress,
                      "paymentBankReferenceNumber" : paymentBankReferenceNumber,
                      "paymentBankCode" : paymentBankCode,
                      "paymentErrorMsg" : paymentErrorMsg,
                      "paymentNameOnCard" : paymentNameOnCard,
                      "paymentStatus" : paymentStatus,
                      "paymentCardNumber" : paymentCardNumber,
                      "paymentDiscount"  : paymentDiscount,
                      "paymentTransactionsAmount"  : "\(paybleAmount)",
                      "paymentReceivedBillId"  : payloadDataPayment.paymentReceivedBillId,
                      "paymentReceivedMaintenanceId"  : payloadDataPayment.paymentReceivedMaintenanceId,
                      "paymentBalanceSheetId"  : payloadDataPayment.paymentBalanceSheetId,
                      "no_of_month"  : payloadDataPayment.month,
                      "facility_book_date"  : payloadDataPayment.bookedDate,
                      "facilityType"  : payloadDataPayment.facilityType,
                      "no_of_person"  : payloadDataPayment.person,
                      "facilityId"  : payloadDataPayment.facilityId,
                      "unit_name"  : unitName(),
                      "penaltyId"  : payloadDataPayment.penaltyId,
                      "bill_id"  : payloadDataPayment.paymentBillId,
                      "maintenance_id"  : payloadDataPayment.paymentMaintenanceId,
                      "paymentLateFee"  : payloadDataPayment.paymentLateFee,
                      "eventDayId"  : payloadDataPayment.eventDayId,
                      "eventId"  : payloadDataPayment.eventId,
                      "bookingStartTimeDays"  : payloadDataPayment.bookingStartTimeDays,
                      "bookingEndTimeDays"  : payloadDataPayment.bookingEndTimeDays,
                      "maintenanceAmount"  : payloadDataPayment.maintenanceAmount,
                      "customAmount"  : payloadDataPayment.customAmount,
                      "payment_mode"  : payment_mode,
                      "transaction_charges"  : transaction_charges,
                      "paymentDiscountAmount"  : payloadDataPayment.paymentDiscountAmount,
                      "is_wallet_applied":"\(is_wallet_applied)",
                      "wallet_balance":"\(walletBalance)",
                      "wallet_balance_used":"\(wallet_balance_used)",
                      "language_id" : doGetLanguageId(),
                      ]
   
        print("params " , params)
        print(payloadDataPayment.bookingSelectedIds)
       
        showProgress()
      //  requrest.requestPostMultipartArray(serviceName: ServiceNameConstants.payment_controller, parameters: params) { (json, error) in
        requrest.requestPostMultipartArray(serviceName: ServiceNameConstants.payment_controller, parameters: params, family_user_id: payloadDataPayment.bookingSelectedIds, member_relation: [String](), paramArray: "bookingSelectedIds[]") { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponsePayment.self, from:json!)
                    if response.status == "200" {
                        self.paymentSucess.onSucusses()
                        let PaymentAmountss =  self.payloadDataPayment.paymentAmount.doubleValue
                      
                        if self.isApplyWallet == true && PaymentAmountss ?? 0.00 < self.walletBalance
                        {
                            self.navigationController!.popViewController(animated: true)
                            
                        }else
                        {
                        
                            let vc = PaymentDetailVC()
                         
                            if self.StrType == "PayUMoeny"
                            {
                                vc.SelectedPaymentsGateways =  self.tempModelPau
                            }else if self.StrType == "RazorPay"
                            {
                                vc.SelectedPaymentsGateways = self.tempModelRazor
                            }else
                            {
                                vc.SelectedPaymentsGateways = self.tempModelFlutterwave
                            }
                            vc.payments_gateways = self.payments_gateways
                            vc.StrPayment = self.StrType
                            vc.StrDate = self.StrDate
                            vc.paymentTransactionsId = paymentTransactionsId
                            vc.StrMaintenanceName = self.StrMaintenanceName
                            vc.StrSuccess = "Success"
                            vc.StrIsComeFromEvent = self.StrIsComeFromEvent
                            vc.StrIsComeFromRenew = self.StrIsComeFromRenew
                           // vc.is_wallet_applied = self.is_wallet_applieds
                            vc.StrWalletAmount = String(self.wallet_balance_used)
                            vc.is_wallet_applied = self.isApplyWallet
                            vc.payloadDataPayment = self.payloadDataPayment
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                 
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        /*request.requestPostMultipartArray(serviceName: ServiceNameConstants.payment_controller, parameters: params,family_user_id: payloadDataPayment.bookingSelectedIds, member_relation: [String](), paramArray: "bookingSelectedIds[]" ) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponsePayment.self, from:json!)
                    if response.status == "200" {
                        self.paymentSucess.onSucusses()
                        let PaymentAmountss =  self.payloadDataPayment.paymentAmount.doubleValue
                        
                        
                     
                        if self.isApplyWallet == true && PaymentAmountss ?? 0.00 < self.walletBalance
                        {
                            for controller in self.navigationController!.viewControllers as Array {

                                        if controller.isKind(of: BillsAndFundsVC.self) {

                                            self.navigationController!.popToViewController(controller, animated: true)

                                            break

                                        }

                                    }
                            
                            
                        }else
                        {
                            
                            
                            let vc = PaymentDetailVC()
                          //  vc.paymentSucess = self
                            vc.payments_gateways = self.payments_gateways
                            vc.StrPayment = self.StrType
                            vc.StrDate = self.StrDate
                            vc.paymentTransactionsId = paymentTransactionsId
                            vc.StrMaintenanceName = self.StrMaintenanceName
                            vc.StrSuccess = "Success"
                            vc.StrIsComeFromEvent = self.StrIsComeFromEvent
                           // vc.is_wallet_applied = self.is_wallet_applieds
                            vc.StrWalletAmount = String(self.wallet_balance_used)
                            vc.is_wallet_applied = self.isApplyWallet
                            vc.payloadDataPayment = self.payloadDataPayment
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                       // self.doPopBAck()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }*/
        
    }
    func doOpenRazorPay(keyId:String,amount:String,currency:String,keySecret:String,contact:String,email:String,
                        desc:String) {
           
           print("goToPayment")
           razorpay = RazorpayCheckout.initWithKey(keyId, andDelegate: self)
           print("amount",amount)
     //   let amountT = Int(amount)! * 100
           let amount_temp = Double(amount)! * 100
           let amountT = Int(amount_temp)
           print("amountDoule",amountT)
           showProgress()
        let header : HTTPHeaders = ["Content-Type":" application/json"]
           
           let parameters: [String: String] = ["amount":String(amountT),"currency":currency,"receipt":"1","payment_capture":"1"]
//           Alamofire.request("https://api.razorpay.com/v1/orders",
//                             method: .post,
//                             parameters: parameters,
//                             encoding: JSONEncoding.default,
//                             headers: header).authenticate(user: keyId, password: keySecret).responseJSON { (response:DataResponse<Any>) in
//
//                               print(parameters,"parameters")
//                               self.hideProgress()
//                               switch(response.result) {
//
//                               case .success(_):
//                                   if response.result.value != nil{
//                                       let json = JSON(response.data!)
//                                       print("json data" , json)
//                                       do{
//
//                                           let response = try JSONDecoder().decode(RazorpayResponse.self, from: response.data!)
//                                           self.respose = response
//
//                                        print("amount_response", Int(response.amount!))
//                                        self.order_id = response.id!
//                                        self.options = [
//
//
//                                            "amount": Int(response.amount!), //This is in currency subunits. 100 = 100 paise= INR 1.
//                                            "currency": "INR",//We support more that 92 international currencies.
//                                            "description": desc,
//                                            "order_id": response.id!,
//                                            "image": "https://www.fincasys.com/images/logo.png",
//                                            "name": self.doGetLocalDataUser().userFullName ?? "Fincasys",
//                                            "prefill": [
//                                                "contact": contact,
//                                                "email": email
//                                            ],
//                                            "theme": [
//                                                "color": "#682E7D"
//                                            ]
//                                        ]
//                                        print(self.options,"options")
//                                        self.razorpay.open(self.options)
//                                       }catch
//                                       {
//                                        print("json data" , json)
//                                        self.showAlertMessage(title: "", msg:"\(self.options)")
//                                       }
//                                   }
//                                   break
//                               case .failure(_):
//                                   print( " error " ,response.result.error as Any)
//
//                                    self.showAlertMessage(title: "", msg: response.result.error as Any as! String)
//
//                                   break
//                               }
//           }
        
        AF.request("https://api.razorpay.com/v1/orders", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).authenticate(username: keyId, password: keySecret).responseJSON { response in
            self.hideProgress()
            switch(response.result) {
            
            case .success(_):
                if response.value != nil{
                    let json = JSON(response.data!)
                    print("json data" , json)
                    do{
                        
                        let response = try JSONDecoder().decode(RazorpayResponse.self, from: response.data!)
                        self.respose = response
                        
                        print("amount_response", Int(response.amount!))
                        self.order_id = response.id!
                        self.options = [
                            
                            
                            "amount": Int(response.amount!), //This is in currency subunits. 100 = 100 paise= INR 1.
                            "currency": "INR",//We support more that 92 international currencies.
                            "description": "",
                            "order_id": response.id!,
                            "image": "https://myassociation.app/images/logo.png",
                            "name":  "",
                            "prefill": [
                                "contact": contact,
                                "email": email
                            ],
                            "theme": [
                                "color": "#96C43D"
                            ]
                        ]
                        print(self.options,"options")
                        self.razorpay.open(self.options)
                    }catch
                    {
                        print("json data" , json)
                        self.showAlertMessage(title: "", msg:"\(self.options)")
                    }
                }
                break
            case .failure(let error):
                print( " error " ,error as Any)
                
                self.showAlertMessage(title: "", msg: error as Any as! String)
                
                break
            }
          
            }
        }
    
    
    func doCallPlanRenew(paymentTransactionsId : String,userName:String,userMobile:String,userEmail:String,userAddress:String,paymentBankReferenceNumber:String,paymentBankCode:String,paymentErrorMsg:String,paymentNameOnCard:String,paymentStatus:String,paymentCardNumber:String,payment_mode:String,transaction_charges:String,paymentDiscount:String) {
       
        let dateWithoutFormate = UserDefaults.standard.string(forKey: StringConstants.KEY_DATE_WITHOUT_FORMAT)
        let params = ["payPacakge":"payPacakge",
                      "membership_joining_date":dateWithoutFormate ?? "" ,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "paymentTypeFor"  : payloadDataPayment.paymentTypeFor,
                      "paymentForName"  : payloadDataPayment.paymentForName,
                      "paymentFor"  : payloadDataPayment.paymentFor,
                      "paymentTransactionsId" : paymentTransactionsId ,
                      "userName" : userName,
                      "userMobile" : userMobile,
                      "userEmail" : userEmail,
                      "unit_name"  : unitName(),
                      "paymentBankReferenceNumber" : paymentBankReferenceNumber,
                      "paymentBankCode" : paymentBankCode,
                      "paymentErrorMsg" : paymentErrorMsg,
                      "paymentNameOnCard" : paymentNameOnCard,
                      "paymentStatus" : paymentStatus,
                      "paymentCardNumber" : paymentCardNumber,
                      "paymentDiscount"  : paymentDiscount,
                      "paymentTransactionsAmount"  : "\(paybleAmount)",
                      "paymentDescription"  : payloadDataPayment.paymentDesc ,
                      "userAddress" : userAddress,
                      "package_id"  : payloadDataPayment.package_id ,
                      "paymentBalanceSheetId"  : payloadDataPayment.paymentBalanceSheetId,
                      "payment_mode"  : payment_mode,
                      "package_amount" : payloadDataPayment.paymentAmount]
 
       // print("params " , params)
      //  print(payloadDataPayment.bookingSelectedIds)
       
        showProgress()
      //  requrest.requestPostMultipartArray(serviceName: ServiceNameConstants.payment_controller, parameters: params) { (json, error) in
        requrest.requestPost(serviceName: ServiceNameConstants.payment_controller, parameters: params) { json, error in
            self.hideProgress()
            if json != nil {
              
                do {
                    let response = try JSONDecoder().decode(ResponsePayment.self, from:json!)
                    if response.status == "200" {
                        //self.paymentSucess.onSucusses()
                        let PaymentAmountss =  self.payloadDataPayment.paymentAmount.doubleValue
                      
                        if self.isApplyWallet == true && PaymentAmountss ?? 0.00 < self.walletBalance
                        {
                            self.navigationController!.popViewController(animated: true)
                            
                        }else
                        {
                        
                            let vc = PaymentDetailVC()
                         
                            if self.StrType == "PayUMoeny"
                            {
                                vc.SelectedPaymentsGateways =  self.tempModelPau
                            }else if self.StrType == "RazorPay"
                            {
                                vc.SelectedPaymentsGateways = self.tempModelRazor
                            }else
                            {
                                vc.SelectedPaymentsGateways = self.tempModelFlutterwave
                            }
                            vc.payments_gateways = self.payments_gateways
                            vc.StrPayment = self.StrType
                            vc.StrDate = self.StrDate
                            vc.paymentTransactionsId = paymentTransactionsId
                            vc.StrMaintenanceName = self.StrMaintenanceName
                            vc.StrSuccess = "Success"
                            vc.StrIsComeFromEvent = self.StrIsComeFromEvent
                           // vc.is_wallet_applied = self.is_wallet_applieds
                            vc.StrWalletAmount = String(self.wallet_balance_used)
                            vc.is_wallet_applied = self.isApplyWallet
                            vc.payloadDataPayment = self.payloadDataPayment
                            if self.fromHome {
                            vc.isComeFromPlan = "1"
                            }else {
                                vc.isComeFromPlan = ""
                            }
                            vc.StrIsComeFromRenew = "1"
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                 
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
            
        }
        
    }
   
    func doCallRegisterWithPlan(paymentTransactionsId : String,paymentBankReferenceNumber:String,paymentBankCode:String,paymentErrorMsg:String,paymentNameOnCard:String,paymentStatus:String,paymentCardNumber:String,payment_mode:String,transaction_charges:String) {
       
        self.registerParamter.updateValue( payloadDataPayment.paymentTypeFor, forKey: "paymentTypeFor")
        self.registerParamter.updateValue(payloadDataPayment.paymentForName , forKey: "paymentForName")
        //self.registerParamter.updateValue("paymentTypeFor", forKey: payloadDataPayment.paymentTypeFor)
       // self.registerParamter.updateValue("paymentForName", forKey: payloadDataPayment.paymentForName)
        self.registerParamter.updateValue(payloadDataPayment.paymentFor, forKey: "paymentFor")
        self.registerParamter.updateValue(paymentTransactionsId, forKey: "paymentTransactionsId")
        self.registerParamter.updateValue(paymentBankReferenceNumber, forKey: "paymentBankReferenceNumber")
        self.registerParamter.updateValue(paymentBankCode, forKey: "paymentBankCode")
        self.registerParamter.updateValue(paymentErrorMsg, forKey: "paymentErrorMsg")
        self.registerParamter.updateValue(paymentNameOnCard, forKey: "paymentNameOnCard")
        self.registerParamter.updateValue(paymentStatus, forKey: "paymentStatus")
        self.registerParamter.updateValue(paymentCardNumber, forKey: "paymentCardNumber")
        //self.registerParamter.updateValue(paymentDiscount, forKey: "paymentDiscount")
        self.registerParamter.updateValue("\(paybleAmount)", forKey:  "paymentTransactionsAmount")
        self.registerParamter.updateValue(payloadDataPayment.paymentDesc, forKey: "paymentDescription")
       
        self.registerParamter.updateValue(payloadDataPayment.package_id, forKey: "package_id")
        self.registerParamter.updateValue(payloadDataPayment.paymentBalanceSheetId, forKey: "paymentBalanceSheetId")
        self.registerParamter.updateValue(payment_mode, forKey: "payment_mode")
        
        
       print("params " , registerParamter)
      //  print(payloadDataPayment.bookingSelectedIds)
       
        showProgress()
      //  requrest.requestPostMultipartArray(serviceName: ServiceNameConstants.payment_controller, parameters: params) { (json, error) in
        requrest.requestPostMultipartWithFileArryaReg(serviceName: ServiceNameConstants.payment_controller, parameters: registerParamter, joining_doc: payloadDataPayment.fileAgreement, paramName: "", compression: 0.3, completionHandler: { json, error in
            self.hideProgress()
            if json != nil {
              
                do {
                    let response = try JSONDecoder().decode(ResponsePayment.self, from:json!)
                    if response.status == "200" {
                        //self.paymentSucess.onSucusses()
                        let PaymentAmountss =  self.payloadDataPayment.paymentAmount.doubleValue
                      
                        if self.isApplyWallet == true && PaymentAmountss ?? 0.00 < self.walletBalance
                        {
                            self.navigationController!.popViewController(animated: true)
                            
                        }else
                        {
                            
                            self.toast(message: response.message, type: .Success)
                            
                           //MARK: after registration pop on loginvc by sagar
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.navigationController?.popToViewController(ofClass: LoginVC.self)
                            }
                         
                            //MARK: unneccary code hide 
                           
//                            let vc = PaymentDetailVC()
//
//                            if self.StrType == "PayUMoeny"
//                            {
//                                vc.SelectedPaymentsGateways =  self.tempModelPau
//                            }else if self.StrType == "RazorPay"
//                            {
//                                vc.SelectedPaymentsGateways = self.tempModelRazor
//                            }else
//                            {
//                                vc.SelectedPaymentsGateways = self.tempModelFlutterwave
//                            }
//                            vc.payments_gateways = self.payments_gateways
//                            vc.StrPayment = self.StrType
//                            vc.StrDate = self.StrDate
//                            vc.paymentTransactionsId = paymentTransactionsId
//                            vc.StrMaintenanceName = self.StrMaintenanceName
//                            vc.StrSuccess = "Success"
//                            vc.StrIsComeFromRenew = self.StrIsComeFromRenew
//                            vc.StrWalletAmount = String(self.wallet_balance_used)
//                            vc.is_wallet_applied = self.isApplyWallet
//                            vc.payloadDataPayment = self.payloadDataPayment
//                            self.navigationController?.pushViewController(vc, animated: true)
                          
                            
                        }
                 
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
            
        })
        
        
    }
    
    
}
extension PaymentOptionsVC : EmailDialogDelegate{
    func UpdateButtonClicked(Update Email: String!, tag: Int!) {
        self.dismiss(animated: true){
            self.doCallEmailUpdate(updated: Email)
        }
    }
}
extension PaymentOptionsVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
       // showAlertMessage(title: "error", msg: str)
        // self.presentAlert(withTitle: "Alert", message: str)
        
        let vc = PaymentDetailVC()
        vc.SelectedPaymentsGateways = self.tempModelRazor
        vc.payments_gateways = self.payments_gateways
        vc.StrPayment = self.StrType
        vc.StrDate = self.StrDate
        vc.paymentTransactionsId = "N/A"
        vc.StrMaintenanceName = self.StrMaintenanceName
        vc.StrSuccess = "Failed"
        vc.StrIsComeFromEvent = self.StrIsComeFromEvent
        vc.StrIsComeFromRenew = self.StrIsComeFromRenew
        vc.isComeFromPlan = isComeFromPlan
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        
//        let generated_signature = hmac_sha256(order_id + "|" + payment_id , "307HhGHf9vmohpsBS4u60eex")
//
//        if (generated_signature == razorpay_signature) {
//          //payment is successful
//        }
        toast(message: "Payment Successfully", type: .Information)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN {
                //MARK: Renew from homevc and renew plan vc
                self.doCallPlanRenew(paymentTransactionsId: payment_id, userName: self.payloadDataPayment.userName, userMobile: self.payloadDataPayment.userMobile, userEmail: self.payloadDataPayment.userEmail, userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "RazorPay", transaction_charges: self.transaction_charges, paymentDiscount: "")
            }else  if self.payloadDataPayment.paymentTypeFor == StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER {
                //MARK: registerscreen after call API
                
               self.doCallRegisterWithPlan(paymentTransactionsId: payment_id, paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "RazorPay", transaction_charges: self.transaction_charges)
            } else {
                //MARK: event booking other extra activity
                self.callPaymentSucucess(paymentTransactionsId: payment_id, userName: self.payloadDataPayment.userName, userMobile: self.payloadDataPayment.userMobile, userEmail: self.payloadDataPayment.userEmail, userAddress: "", paymentBankReferenceNumber: "", paymentBankCode: "", paymentErrorMsg: "", paymentNameOnCard: "", paymentStatus: "success", paymentCardNumber: "", payment_mode: "RazorPay", transaction_charges: self.transaction_charges, paymentDiscount: "")
            }
            
        }
    }
}
