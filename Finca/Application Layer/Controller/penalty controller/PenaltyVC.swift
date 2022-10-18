//
//  PenaltyVC.swift
//  Finca
//
//  Created by harsh panchal on 27/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import CryptoSwift
import Lightbox
import EzPopup

class PenaltyVC: BaseVC {
   
    var youtubeVideoID = ""
    var menuTitle : String!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var tbvData: UITableView!
    let itemcell = "PenaltyCell"
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var VwVideo:UIView!
    var penaltyList = [PenaltyModel]()
    var index : IndexPath!
    var paymentSucess : PaymentSucessDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        tbvData.delegate = self
        tbvData.dataSource = self
        addRefreshControlTo(tableView: tbvData)
        doInintialRevelController(bMenu: bMenu)
       // paymentSucess = self
        lblScreenTitle.text = doGetValueLanguage(forKey: "_penalty")
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        penaltyList.removeAll()
        tbvData.reloadData()
        doCallApi()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func onClickNotification(_ sender: Any) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        // let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        // self.navigationController?.pushViewController(vc, animated: true)
        goToDashBoard(storyboard: mainStoryboard)
        
    }
    
    func doCallApi()  {
        let params = ["getList":"getList",
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_id":instanceLocal().getCountryId()]
        let request = AlamofireSingleTon.sharedInstance
        self.showProgress()
        request.requestPost(serviceName: ServiceNameConstants.PENALTY_CONTROLLER, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(PenaltyListResponse.self, from: Data!)
                    if response.status == "200"{
                        self.penaltyList = response.penalty
                        self.tbvData.reloadData()
                    }else{
                        self.penaltyList.removeAll()
                        self.tbvData.reloadData()
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }

    func setupPayu(phone:String!,email:String!,amount:String!,firstname:String!,key:String!,merchantid:String!,txnID:String!,udf1:String!,udf2:String!,udf3:String!,udf4:String!,udf5:String!,udf6:String!,udf7:String!,udf8:String!,udf9:String!,udf10:String!,salt:String,paymentType:String="",paymentFor:String="",paymentForID:String!="",balancesheetId:String!="",facilityId:String!="",isTestMode : Bool)
    {
        if email == ""{
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

                        self.doCallTransactionAPIcardNum(paymentType: paymentType, paymentName: paymentFor, payUId: "\(payuMoneyId)", txnID: payment_txnid, firstName: payment_firstname, lastName: payment_lastname, phone: payment_phone, email: payment_email, address: payment_address, bankRefNum:bank_ref_num, bankCode: bankcode, errorMessage: error_Message, nameOnCard: name_on_card, paymentStatus: payment_status, cardNum: cardnum, discount: payment_discount, UserMobile: self.doGetLocalDataUser().userMobile!, transctionAmt:amount, receiveBillId:paymentForID , balanceSheetId: balancesheetId, Month: "", facilityType: "", noOfPerson: "", facilityId: facilityId)
                        //
                        //                    UIUtility.toastMessage(onScreen: "Payment Successfull")
                    }else{
                        UIUtility.toastMessage(onScreen: "Payment failed", from: self)
                    }
                }else{
                    UIUtility.toastMessage(onScreen: "Payment canceled", from: self)
                }
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
    func doCallTransactionAPIcardNum(paymentType:String!,paymentName:String!,payUId:String!,txnID:String!,firstName:String!,lastName:String!,phone:String!,email:String!,address:String!,bankRefNum:String!,bankCode:String!,errorMessage:String!,nameOnCard : String!,paymentStatus:String!,cardNum:String!,discount:String!,UserMobile:String!,transctionAmt:String!,receiveBillId:String!,balanceSheetId:String!,Month:String!,facilityType:String!,noOfPerson:String!,facilityId:String!){
        
        self.showProgress()
        
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
                      "payment_address":address!,
                      "bank_ref_num":bankRefNum!,
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
                      "no_of_month":Month!,
                      "facility_book_date":Month!,
                      "facility_type":facilityType!,
                      "no_of_person":noOfPerson!,
                      "facility_id":facilityId!,
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
                        self.fetchNewDataOnRefresh()
                        self.toast(message: "Penalty Payment Successful", type: .Information)
                    }
                }catch{
                    
                }
            }
        }
    }
    private func doCallPyUCredsAPI(transactionAmount:String!,balancesheetId:String!,paymentType:String!="",paymentFor:String!="",facilityId:String!="") {
        showProgress()
        var email = ""
        
        if self.doGetLocalDataUser().userEmail != nil && self.doGetLocalDataUser().userEmail != "" {
            email =  self.doGetLocalDataUser().userEmail
        }
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMerchantDetails":"getMerchantDetails",
                      "society_id":doGetLocalDataUser().societyID!,
                      "block_id":doGetLocalDataUser().blockID!,
                      "balancesheet_id":balancesheetId!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.payuController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MerchantDetailResponse.self, from:json!)
                    if response.status == "200" {
                        print("merchantid \(String(describing: response.merchantID)) , merchant_key \(String(describing: response.merchantKey)) , merchant_salt \(String(describing: response.saltKey))")
                        
                        self.setupPayu(phone: self.doGetLocalDataUser().userMobile, email: email, amount: transactionAmount, firstname: self.doGetLocalDataUser().userFirstName, key: response.merchantKey, merchantid: response.merchantID, txnID: String(Date().millisecondsSince1970), udf1: "", udf2: "", udf3: "", udf4: "", udf5: "", udf6: "", udf7: "", udf8: "", udf9: "", udf10: "", salt:response.saltKey,paymentType: paymentType,paymentFor: paymentFor,facilityId:facilityId,isTestMode: response.isTestMode)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

extension PenaltyVC : UITableViewDelegate,UITableViewDataSource{
    
    
  //  func showPaymentDetail(indexPath: IndexPath!) {
        
        
//        let vc = UIStoryboard(name: "sub", bundle: nil ).instantiateViewController(withIdentifier: "PenaltyImageShowVC") as! PenaltyImageShowVC
//        let data = penaltyList[indexPath.row] as? NSDictionary
//            vc.sliders = penaltyList[indexPath.row].penalty_img
//            vc.penaltyListNext = penaltyList
//
//            self.navigationController?.pushViewController(vc, animated: true)

//        PenaltyDetailVC
        //PenaltyDetailVC
//        let data = penaltyList[indexPath.row]
//
//
//        if data.paidStatus == "0"{
//            let screenwidth = UIScreen.main.bounds.width
//            let screenheight = UIScreen.main.bounds.height
//
//            let destiController = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idPenaltyDetailVC") as! PenaltyDetailVC
//            index = indexPath
//            destiController.penaltyContext = self
//            let popupVC = PopupViewController(contentController: destiController, popupWidth: screenwidth
//                , popupHeight: screenheight
//            )
//            popupVC.backgroundAlpha = 0.5
//            popupVC.backgroundColor = .black
//            popupVC.shadowEnabled = true
//            popupVC.canTapOutsideToDismiss = false
//            present(popupVC, animated: true)
//
//        } else {
//            //goto invoice
////            let link = "\(UserDefaults.standard.string(forKey: StringConstants.KEY_BASE_URL)!)apAdmin/paymentReceiptAndroid.php?user_id=\(doGetLocalDataUser().userID!)&unit_id=\(doGetLocalDataUser().unitID!)&type=P&societyid=\(doGetLocalDataUser().societyID!)&id=\(data.penaltyID!)"
////
//            let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
//            vc.strUrl = data.invoiceUrl ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//
      
   // }
    
    func showcaseImage(indexPath: IndexPath!) {
        
        
       let data = penaltyList[indexPath.row]
//
//        let vc = UIStoryboard(name: "sub", bundle: nil ).instantiateViewController(withIdentifier: "PenaltyImageShowVC") as! PenaltyImageShowVC
//        print(penaltyList[indexPath.row].penalty_img)
//            vc.sliders = penaltyList[indexPath.row].penalty_img
//        vc.penaltyListNext = penaltyList
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        let image = LightboxImage(imageURL:URL(string:data.penaltyPhoto)!)
        let controller = LightboxController(images: [image], startIndex: 0)
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self


        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen

        parent?.present(controller, animated: true, completion: nil)
        
        
    }

    func doCallPay(indexPath: IndexPath!) {
        let data = penaltyList[indexPath.row]
        doCallPyUCredsAPI(transactionAmount: data.penaltyAmount,balancesheetId:data.balancesheetID,paymentType: "4",paymentFor:"penalty " + doGetLocalDataUser().userID!, facilityId: data.penaltyID)
        
//        let data = penaltyList[indexPath.row]
//        doCallPyUCredsAPI(transactionAmount: data.penaltyAmount,balancesheetId:data.balancesheetId,paymentType: "4",paymentFor:"penalty " + doGetLocalDataUser().userID!, facilityId: data.penaltyId)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if penaltyList.count != 0{
            viewNoData.isHidden = true
        }else{
            viewNoData.isHidden = false
        }
        return penaltyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = penaltyList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! PenaltyCell
        cell.lblPenaltyDescription.text = data.penaltyName
        Utils.setImageFromUrl(imageView: cell.imgPenaltyImage, urlString: data.penaltyPhoto, palceHolder: "fincasys_notext")
        print(data.cgst_lbl_view ?? "")
        if data.paidStatus == "0"{
            cell.lblPaymentStatus.text = doGetValueLanguage(forKey: "unpaid_colon") + doGetLocalDataUser().currency! + data.penalty_amount_view + " "
           // cell.viewButtonPay.isHidden = false
            cell.bPay.setTitle(doGetValueLanguage(forKey: "pay"), for: .normal)
            cell.bPay.addTarget(self, action: #selector(onClickPayClick(_:)), for: .touchUpInside)
            cell.bImage.addTarget(self, action: #selector(onClickImageClick(_:)), for: .touchUpInside)
            cell.lblPaymentStatus.backgroundColor = ColorConstant.red500
            cell.bPay.backgroundColor = ColorConstant.colorP
        }else{
            cell.lblPaymentStatus.text = doGetValueLanguage(forKey: "paid_colon") + doGetLocalDataUser().currency! + data.penalty_amount_view + " "
           // cell.viewButtonPay.isHidden = true
            cell.bPay.addTarget(self, action: #selector(onClickPayClick(_:)), for: .touchUpInside)
            cell.bPay.setTitle(doGetValueLanguage(forKey: "invoice").uppercased(), for: .normal)
            cell.bPay.backgroundColor = ColorConstant.green500
            cell.lblPaymentStatus.backgroundColor = ColorConstant.green500
        }
        
//        DispatchQueue.main.async {
//            cell.viewMain.clipsToBounds = true
//            cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//        }
        
        cell.lblDate.text = doGetValueLanguage(forKey: "date") + data.penaltyDate
     //   cell.delegate = self
//        cell.indexPath = indexPath
       
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "sub", bundle: nil ).instantiateViewController(withIdentifier: "PenaltyImageShowVC") as! PenaltyImageShowVC
        
        let data = penaltyList[indexPath.row]
        vc.sliders = penaltyList[indexPath.row].penalty_img
        vc.penaltyListNext = penaltyList
        vc.Strtitle = data.penaltyName
        vc.StrtotalAmountView = data.penalty_amount_view
        vc.StrtotalAmount = data.penaltyAmount
        vc.StrWithoutGst = data.amountWithoutGst
        vc.Strpayment_request_id = data.payment_request_id
        vc.Strbalancesheet_id = data.balancesheetID
        vc.Strpenalty_id = data.penaltyID
        vc.StrDate = data.penaltyDate
        vc.PaidStatus = data.paidStatus
        vc.InvoiceUrl = data.invoiceUrl
        vc.already_requests = data.already_request
        vc.StrPayment_RequestID = data.payment_request_id
        vc.CGst_Amount = data.cgstAmount
        vc.Igst_amount = data.igstAmount
        vc.Gst_type = data.gstType
        vc.Penalty_amount = data.penaltyAmount
        vc.Sgst_amount = data.sgstAmount
        vc.Gst_slab = data.tax_slab ?? ""
        vc.gst = data.gst
        vc.bill_type = data.billType
        vc.is_taxble = data.is_taxble
        vc.taxble_type = data.taxble_type
        print(data.cgst_lbl_view ?? "")
        vc.cgst_lbl_view = data.cgst_lbl_view ?? ""
        vc.igst_lbl_view = data.igst_lbl_view ?? ""
        vc.sgst_lbl_view = data.sgst_lbl_view ?? ""
       // vc.igst_amount_view = data.igst_amount_view
       // vc.cgst_amount_view = data.cgst_amount_view
       // vc.sgst_amount_view = data.sgst_amount_view
        vc.tax_slab  = data.tax_slab
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func onClickImageClick(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbvData)
        let indexPathSelected = self.tbvData.indexPathForRow(at:buttonPosition)
        if penaltyList.count > 0
        {
            
            _ = self.tbvData.cellForRow(at: indexPathSelected!)!
            
            let data = penaltyList[indexPathSelected!.row]
   
             let image = LightboxImage(imageURL:URL(string:data.penaltyPhoto)!)
             let controller = LightboxController(images: [image], startIndex: 0)
             // Set delegates.
             controller.pageDelegate = self
             controller.dismissalDelegate = self


             controller.dynamicBackground = true
             controller.modalPresentationStyle = .fullScreen

             parent?.present(controller, animated: true, completion: nil)
            
        }
    }
    @objc func onClickPayClick(_ sender : UIButton ){
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbvData)
        let indexPathSelected = self.tbvData.indexPathForRow(at:buttonPosition)
     
        if penaltyList.count > 0
        {
            if penaltyList[indexPathSelected!.row].paidStatus == "0"{
                
                _ = self.tbvData.cellForRow(at: indexPathSelected!)!
            
                let vc = UIStoryboard(name: "sub", bundle: nil ).instantiateViewController(withIdentifier: "PenaltyImageShowVC") as! PenaltyImageShowVC
                
                let data = penaltyList[indexPathSelected!.row]
                vc.sliders = penaltyList[indexPathSelected!.row].penalty_img
                vc.penaltyListNext = penaltyList
                vc.Strtitle = data.penaltyName
                vc.StrtotalAmountView = data.penalty_amount_view
                vc.StrtotalAmount = data.penaltyAmount
                vc.StrWithoutGst = data.amountWithoutGst
                vc.Strpayment_request_id = data.payment_request_id
                vc.Strbalancesheet_id = data.balancesheetID
                vc.Strpenalty_id = data.penaltyID
                vc.StrDate = data.penaltyDate
                vc.PaidStatus = data.paidStatus
                vc.InvoiceUrl = data.invoiceUrl
                vc.already_requests = data.already_request
                vc.StrPayment_RequestID = data.payment_request_id
                vc.CGst_Amount = data.cgstAmount
                vc.Igst_amount = data.igstAmount
                vc.Gst_type = data.gstType
                vc.Penalty_amount = data.penaltyAmount
                vc.Sgst_amount = data.sgstAmount
                vc.Gst_slab = data.tax_slab ?? ""
                vc.gst = data.gst
                vc.bill_type = data.billType
                vc.is_taxble = data.is_taxble
                vc.taxble_type = data.taxble_type
                vc.cgst_lbl_view = data.cgst_lbl_view
                vc.igst_lbl_view = data.igst_lbl_view
                vc.sgst_lbl_view = data.sgst_lbl_view
               // vc.igst_amount_view = data.igst_amount_view
               // vc.cgst_amount_view = data.cgst_amount_view
               // vc.sgst_amount_view = data.sgst_amount_view
                vc.tax_slab  = data.tax_slab
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else
            {
                let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
                vc.strUrl = penaltyList[indexPathSelected!.row].invoiceUrl ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func setCardView(view : UIView){
           view.layer.masksToBounds = false
           view.layer.shadowColor = UIColor.black.cgColor
           view.layer.shadowOpacity = 0.4
           view.layer.shadowOffset = CGSize.zero
           view.layer.shadowRadius = 4
       }
}
extension PenaltyVC : EmailDialogDelegate ,  PaymentSucessDelegate{
    func onSucusses() {
        
        print("payment succes back")
      //  self.doCallApi()
        
    }
    
    func UpdateButtonClicked(Update Email: String!, tag: Int!) {
        self.dismiss(animated: true){
            
        }
    }
}

