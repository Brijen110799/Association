//
//  CustomerAccountDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 16/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class    CustomerAccountDetailsVC: BaseVC {
    enum ViewType {
        case Due
        case Advance
    }
    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblDueAmount: UILabel!
    @IBOutlet weak var lblAdvanceAmount: UILabel!
    @IBOutlet weak var viewAdvance: UIStackView!
    @IBOutlet weak var viewDue: UIStackView!
    @IBOutlet weak var btnRequestPayment: UIButton!
    @IBOutlet weak var btnSetDueDate: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewShareDue: UIView!
    @IBOutlet weak var btnShare: UIButton!

    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblTotalDue: UILabel!
    @IBOutlet weak var lblAdvanceBalanceTitle: UILabel!
    @IBOutlet weak var lblCreditTitle: UILabel!
    @IBOutlet weak var lblDebitTitle: UILabel!
    @IBOutlet weak var ivNoData: UIImageView!
    var imageNoData = UIImage()
    var context : FinBookVC!
    var transactionList = [CustomerTansactionModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    var customerData : CustomerListModel!
    var accountStatus : ViewType!{
        didSet{
            if accountStatus == .Due{
                self.viewAdvance.isHidden = true
                self.viewDue.isHidden = false
                //                self.viewShareDue.isHidden = false
                //                btnShare.isEnabled = false
            }else if accountStatus == .Advance{
                self.viewAdvance.isHidden = false
                self.viewAdvance.backgroundColor = ColorConstant.light_green
               
                self.viewDue.isHidden = true
                //                self.viewShareDue.isHidden = true
                //                btnShare.isUserInteractionEnabled = true
                //                btnShare.isEnabled = false
            }
        }
    }
    var itemCell1 = "FinBookDebitCell"
    var itemCell2 = "FinbookCreditCell"
    var centerCell = "FinbookCommonCell"
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.btnSetDueDate.layer.cornerRadius = self.btnSetDueDate.bounds.height / 2
        self.btnRequestPayment.layer.cornerRadius = self.btnRequestPayment.bounds.height / 2
        self.lblCustomerName.text = customerData.customerName

        tbvData.estimatedRowHeight = 100
        tbvData.rowHeight = UITableView.automaticDimension

        let nib1 = UINib(nibName: itemCell1, bundle: nil)
        tbvData.register(nib1, forCellReuseIdentifier: itemCell1)
        let nib2 = UINib(nibName: itemCell2, bundle: nil)
        tbvData.register(nib2, forCellReuseIdentifier: itemCell2)
        let nib3 = UINib(nibName: centerCell, bundle: nil)
        tbvData.register(nib3, forCellReuseIdentifier: centerCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        viewAdvance.backgroundColor = ColorConstant.light_green
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
        lblTotalDue.text = "\(doGetValueLanguage(forKey: "total_due")) : "
        lblAdvanceBalanceTitle.text = "Advance Balance"
        lblCreditTitle.text = doGetValueLanguage(forKey: "credit")
        lblDebitTitle.text = doGetValueLanguage(forKey: "debit")
        btnDueDate.setTitle(doGetValueLanguage(forKey: "set_due_date"), for: .normal)
        
        btnRequestPayment.setTitle(doGetValueLanguage(forKey: "payment_request"), for: .normal)
        ivNoData.image = imageNoData
    }
    @IBAction func btnEditClicked(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboard!.instantiateViewController(withIdentifier: "idFinAddCustomerDialogVC")as! FinAddCustomerDialogVC
        vc.dialogType = .Update
        vc.customerData = self.customerData
        vc.editContext = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        showAppDialog(delegate: self, dialogTitle: doGetValueLanguage(forKey: "delete_customer"), dialogMessage: doGetValueLanguage(forKey: "all_transaction_of_this_customer_will_also_be_deleted"), style: .Delete, cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "ok"))
       // self.showAppDialog(delegate: self, dialogTitle: "Delete Customer", dialogMessage: "All transaction of this customer will also be deleted along with this customer", style: .Delete)
        
    }
    override func fetchNewDataOnRefresh() {
        self.transactionList.removeAll()
        self.doCallApi()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
    }

    @IBAction func btnSetDueDateClicked(_ sender: UIButton) {
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        let dateS2 = dateF.string(from: Date())
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCalendarDailogVC") as! CalendarDailogVC
        vc.delegate = self
        vc.maximumDate = "date"
        vc.minimumDate =  dateS2
        vc.fromvc = "hisab"
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth-10  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    func doCallApi(){
        self.showProgress()
        let params = ["getTransaction":"getTransaction",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "finbook_customer_id":customerData.finbookCustomerId!]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err)in
            self.hideProgress()
            if Data != nil{
                
                do{
                    let response = try JSONDecoder().decode(CustomerTransactionResponse.self, from: Data!)
                    if response.status == "200"{

                        if response.isDue{
                            self.accountStatus = .Due
                            self.lblDueAmount.text = self.localCurrency() + " " + response.dueBlanace
                            self.lblDueAmount.textColor = UIColor(named: "red_a700")
                           
                            self.customerData.dueAmount = response.dueBlanace
                        }else{
                            self.accountStatus = .Advance
                            self.lblAdvanceAmount.text = self.localCurrency() + " " + response.dueBlanace
                            self.lblAdvanceAmount.textColor = UIColor(named: "green 500")
                            self.customerData.dueAmount = response.dueBlanace
                        }
                        
                        
                        if response.due_date ?? "" != "" {
                            self.btnDueDate.setTitle("\(self.doGetValueLanguage(forKey: "set_due_date")) \(self.customerData.dueDate!)", for: .normal)
                            self.btnDueDate.isEnabled = true
                        } else {
                            self.btnDueDate.setTitle(self.doGetValueLanguage(forKey: "set_due_date"), for: .normal)
                        }
                        
//                        if self.customerData.dueDate != ""{
//                            self.btnDueDate.setTitle("\(self.doGetValueLanguage(forKey: "due_date")) \(self.customerData.dueDate!)", for: .normal)
//                            self.btnDueDate.isEnabled = true
//
//                        } else {
//                            self.btnDueDate.setTitle(self.doGetValueLanguage(forKey: "set_due_date"), for: .normal)
//                        }
                        self.transactionList.append(contentsOf: response.tansaction)
                        self.tbvData.scrollToRow(at: IndexPath(row: self.transactionList.count - 1, section: 0), at: .bottom, animated: true)
                    }else{
                       // self.btnDueDate.setTitle(self.doGetValueLanguage(forKey: "set_due_date"), for: .normal)
                    }
                }catch{
                    print("parse Error",error)
                }
            }
        }
    }

    @IBAction func btnGiveCredit(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idAddTranscationDialogVC")as! AddTranscationDialogVC
        vc.context = self
        vc.transactionType = .Credit
        vc.customerData = self.customerData
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    @IBAction func btnAcceptPayment(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idAddTranscationDialogVC")as! AddTranscationDialogVC
        vc.context = self
        vc.transactionType = .Debit
        vc.customerData = self.customerData
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnCallCustomerClicked(_ sender: UIButton) {
        self.doCall(on: customerData.customerMobile!)
    }

    @IBAction func btnRequestPaymentClicked(_ sender: UIButton) {
        let nextvc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idPaymentReminderVC")as! PaymentReminderVC
        nextvc.customerData = self.customerData
        nextvc.reminderType = .PaymentReminder
        self.navigationController?.pushViewController(nextvc, animated: true)
    }

    @IBAction func btnWhatsappRemainder(_ sender: UIButton) {
        if accountStatus == .Due{
            if customerData.dueAmount == "0.00"{
                self.toast(message: self.doGetValueLanguage(forKey: "no_due_amount"), type: .Faliure)

            }else{
                print("PaymentReminderVC")
                let nextvc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idPaymentReminderVC")as! PaymentReminderVC
                nextvc.customerData = self.customerData
                nextvc.reminderType = .PaymentReminder
                self.navigationController?.pushViewController(nextvc, animated: true)
            }
        }else{
            self.toast(message: self.doGetValueLanguage(forKey: "no_due_amount"), type: .Faliure)
        }
    }

    func doDeleteCustomer(){
        self.showProgress()
        let params = ["deleteCustomer":"deleteCustomer",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "finbook_customer_id":customerData.finbookCustomerId!,
                      "user_type":doGetLocalDataUser().userType!]
        print("params",params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
            
        }
    }
}

extension CustomerAccountDetailsVC : CalendarDialogDelegate,AppDialogDelegate{

    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        self.dismiss(animated: true) {
            self.doDeleteCustomer()
        }
    }

    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }

    func btnDoneClicked(with SelectedDateString: String!, with SelectedDate: Date!,tag : Int!) {
        let param = ["setDueDate":"setDueDate",
                     "due_date":SelectedDateString!,
                     "user_id":doGetLocalDataUser().userID!,
                     "finbook_customer_id":customerData.finbookCustomerId!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: param) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        print("faliure message",response.message!)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
        print("selected Date",SelectedDate as Any)
    }

}
extension CustomerAccountDetailsVC : UITableViewDelegate ,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactionList.count == 0{
            self.viewNoData.isHidden = false
        }else{
            self.viewNoData.isHidden = true
        }
        return transactionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = transactionList[indexPath.row]
        let tbvCell = UITableViewCell()
        if data.isDate{
            let cell = tbvData.dequeueReusableCell(withIdentifier:centerCell, for: indexPath) as! FinbookCommonCell
            cell.lblDate.text = data.msgDateView
            cell.viewMain.layer.cornerRadius = 15
            cell.lblDate.textColor = ColorConstant.colorP
            cell.viewMain.backgroundColor = UIColor(named: "colorPrimarylVeryite")
            cell.selectionStyle = .none
            return cell
        }else if !data.isDate && data.debitAmount == "0.00"{
            let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell1, for: indexPath) as! FinBookDebitCell
            if data.activeStatus == "1"{
                cell.viewEntryData.isHidden = true
                cell.viewDeletedEntry.isHidden = false
                cell.lblFinalAmount.text = ""
                cell.lblCreditDeleteTitle.text = "Payment Deleted"
            }else{
                cell.viewEntryData.isHidden = false
                cell.viewDeletedEntry.isHidden = true
                cell.lblAmount.text = self.localCurrency() + " " +  data.credit_amount_view
                cell.lblRemark.text = data.remark
                cell.lblRemark.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lblFinalAmount.text = self.localCurrency() + " " + data.remaningAmount
                if cell.lblRemark.text == "" &&  ((cell.lblRemark.text?.isEmptyOrWhitespace()) != nil){
                    cell.lblRemark.isHidden = true
                }else{
                    cell.lblRemark.isHidden = false
                }
            }
            cell.lblTime.text = data.createdDate
            cell.selectionStyle = .none
            return cell
        }else if !data.isDate && data.creditAmount == "0.00"{
            let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell2, for: indexPath) as! FinbookCreditCell
            if data.activeStatus == "1"{
                cell.viewEntryData.isHidden = true
                cell.viewDeletedEntry.isHidden = false
                cell.lblFinalAmount.text = ""
                cell.lbDeletePayment.text = "Payment Deleted"
            }else{
                cell.viewEntryData.isHidden = false
                cell.viewDeletedEntry.isHidden = true
                cell.lblAmount.text = self.localCurrency() + " " + data.debit_amount_view
                cell.lblRemark.text = data.remark
                cell.lblRemark.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lblFinalAmount.text = self.localCurrency() + " " + data.remaningAmount
                cell.lblTime.text = data.createdDate
                if cell.lblRemark.text == "" &&  ((cell.lblRemark.text?.isEmptyOrWhitespace()) != nil){
                    cell.lblRemark.isHidden = true
                }else{
                    cell.lblRemark.isHidden = false
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            return tbvCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = transactionList[indexPath.row]
        if !data.isDate{
            let nextVC = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idTransactionDetailsVC")as! TransactionDetailsVC
            nextVC.transactionData = data
            nextVC.customerData = self.customerData
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
