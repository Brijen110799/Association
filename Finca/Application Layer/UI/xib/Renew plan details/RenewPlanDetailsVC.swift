//
//  RenewPlanDetailsVC.swift
//  Finca
//
//  Created by CHPL Group on 11/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import SwiftUI

class RenewPlanDetailsVC: BaseVC {
    
    @IBOutlet weak var viewSanaddate: UIStackView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExpireDate: UILabel!
    @IBOutlet weak var lblJoiningDate: UILabel!
    @IBOutlet weak var lblSanadDate: UILabel!
    @IBOutlet weak var lbExpireDate: UILabel!
    @IBOutlet weak var lbJoiningDate: UILabel!
    @IBOutlet weak var lbSanadDate: UILabel!

    @IBOutlet weak var tbvPlan: UITableView!
    @IBOutlet weak var lblAnnualMembership: UILabel!
    @IBOutlet weak var lblLifetimeMembership: UILabel!
    @IBOutlet weak var lblLifetimeMembershipAmount: UILabel!
    
    @IBOutlet weak var bpay: UIButton!
    @IBOutlet weak var lblAnnualMembershipAmount: UILabel!
    
    @IBOutlet weak var tblPlans: UITableView!
    @IBOutlet weak var tblPlansHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewInvoice: UIView!
    @IBOutlet weak var lblPackageMessage: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblPackageAmount: UILabel!
    
    @IBOutlet weak var lblTransactionDateTitle: UILabel!
    @IBOutlet weak var lblPackageAmountTitle: UILabel!
    @IBOutlet weak var lblPackageNameTitle: UILabel!
    @IBOutlet weak var btnInvoiceTitle: UIButton!
    
    var menuTitle = ""
    var associationType = ""
    var paymentDesc = ""
    var paymentAmount = ""
    var paymentBalanceSheetId = ""
    var AnnualPackageName = ""
    var LifeTimePackageName = ""
    var LifeTimepaymentDesc = ""
    var LifeTimepaymentAmount = ""
    var StrIsComeFromRenewPlan = ""
    var LifeTimepaymentBalanceSheetId = ""
    var penaltyContext : RenewPlanDetailsVC!
    var index : IndexPath!
    let itemcell = "RenewPlanCell"
    let iCell = "RenewPlanTableCell"
    var arrRenew = [RenewModel]()
    var slab = [RenewSlabModel]()
    var btnPaynowStatus = false
    var invoiceLink = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        doInintialRevelController(bMenu: bMenu)
        tblPlans.delegate = self
        tblPlans.dataSource = self
        let nib = UINib(nibName: iCell, bundle: nil)
        tblPlans.register(nib, forCellReuseIdentifier: iCell)
        tblPlans.separatorStyle = .none
//        doGetRenewPackage()
        tblPlans.isScrollEnabled = true
        lblTransactionDateTitle.text = doGetValueLanguage(forKey: "trasaction_date")
        lblPackageNameTitle.text = doGetValueLanguage(forKey: "package_name")
        lblPackageAmountTitle.text = doGetValueLanguage(forKey: "package_amount")
        btnInvoiceTitle.setTitle(doGetValueLanguage(forKey: "invoice").uppercased(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.doGetRenewPackage()
        StringConstants.CheckRenew = false
    }
    
    func doGetRenewPackage(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getRenewPlanDetails":"getRenewPlanDetails",
                      "society_id":doGetLocalDataUser().societyID!,//"1"
                      "user_id":doGetLocalDataUser().userID!,//"1063"
                      "unit_id":doGetLocalDataUser().unitID!,
                      "language_id":"1"]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.renewplancontroller, parameters: params) { (json, error) in
            self.hideProgress()
            print(json as Any)
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(RenewPlanResponse.self, from:json!)
                   
                    if response.status == "200" {
                        self.viewInvoice.isHidden = true
                        self.tblPlans.isHidden = false
                        self.arrRenew = response.package
                    
                        self.tblPlans.reloadData()
                        
                        if response.sanad_date == ""
                        {
                            self.lblSanadDate.isHidden = true
                            self.viewSanaddate.isHidden = true
                        }
                        else{
                            self.viewSanaddate.isHidden = false
                            self.lblSanadDate.isHidden = false
                            self.lblSanadDate.text = response.sanad_date
                        }
                       
                        self.lblExpireDate.text = response.membership_expire_date
                        self.lblJoiningDate.text = response.membership_joining_date
                        
                        if response.sanad_date == "" {
                            self.lblSanadDate.text = "Not Available"
                        }
                        if response.membership_joining_date == "" {
                            self.lblJoiningDate.text = "Not Available"
                        }
                        if response.membership_expire_date == "" {
                            self.lblExpireDate.text = "Not Available"
                           }
                        self.btnPaynowStatus = response.is_package_expire
                    }else if response.status == "201"{
                        self.viewInvoice.isHidden = false
                        self.tblPlans.isHidden = true
                        self.arrRenew.removeAll()
                        self.tblPlans.reloadData()
                        self.lblSanadDate.text = response.sanad_date
                        self.lblExpireDate.text = response.membership_expire_date
                        self.lblJoiningDate.text = response.membership_joining_date
                        self.lblPackageMessage.text = response.message
                        self.lblTransactionDate.text = "\(response.transaction_date ?? "")"
                        self.lblPackageName.text = "\(response.pacakage_name ?? "")"
                        self.lblPackageAmount.text = "\(response.package_amount ?? "")"
                        if response.sanad_date == "" {
                            self.lblSanadDate.text = "Not Available"
                        }
                        if response.membership_joining_date == "" {
                            self.lblJoiningDate.text = "Not Available"
                        }
                        if response.membership_expire_date == "" {
                            self.lblExpireDate.text = "Not Available"
                           }
                        self.btnPaynowStatus = response.is_package_expire
                        self.invoiceLink = response.invoice_link
                    }else {
                        self.viewInvoice.isHidden = true
                        self.tblPlans.isHidden = true
                        self.arrRenew.removeAll()
                        self.tblPlans.reloadData()
                    }
//                    if response.is_package_expire == true {
//                        self.bpay.isHidden = false
//                    }else{
//                        self.bpay.isHidden = true
//                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
//        DispatchQueue.main.async {
////            self.tblPlansHeightConstraint.constant = self.tblPlans.contentSize.height
//            if self.tblPlansHeightConstraint.constant < 100 {
//                self.tblPlansHeightConstraint.constant = 110.0
//            }
//        }
    }
    
//    override func viewDidLayoutSubviews(){
//        DispatchQueue.main.async {
//            self.tblPlansHeightConstraint.constant = self.tblPlans.contentSize.height
//            if self.tblPlansHeightConstraint.constant < 100 {
//                self.tblPlansHeightConstraint.constant = 110.0
//            }
//            self.tblPlans.setNeedsLayout()
//        }
//    }
    
    func PackageRegistration(){
        
            let params : [String : String] = ["payPacakgeregistration" : "payPacakgeregistration",
                                              "society_id":doGetLocalDataUser().societyID!,
                                              "block_id":doGetLocalDataUser().blockID!,
                                              "floor_id" :doGetLocalDataUser().floorID!,
                                              "unit_id" :doGetLocalDataUser().unitID!,
                                              "membership_joining_date": lblJoiningDate.text ?? "",
                                              "company_name" : doGetLocalDataUser().company_name ?? "",
                                              "user_first_name" : doGetLocalDataUser().userFirstName ?? "",
                                              "user_last_name" : doGetLocalDataUser().userLastName ?? "",
                                              "user_full_name" : doGetLocalDataUser().userFullName ,
                                              "user_mobile" : doGetLocalDataUser().userMobile ?? "",
                                              "user_email" : doGetLocalDataUser().userEmail ?? "",
                                              "user_type" : "0",
                                              "user_token" : UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? "",
                                              "device":"ios",
                                              "gender" : doGetLocalDataUser().gender,
                                              "country_code" : doGetLocalDataUser().countryCode,
                                              "unit_name" : doGetLocalDataUser().unitName ?? "",
                                              "advocate_code": doGetLocalDataUser().advocate_code ?? "",
                                              "sanad_date": doGetLocalDataUser().sanad_date ?? "",
                                              "package_amount": paymentAmount,
                                              "user_profile_pic":doGetLocalDataUser().userProfilePic]
            
            
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER
            model.paymentForName = doGetLocalDataUser().userFullName
            model.paymentDesc = paymentDesc
            model.paymentAmount = paymentAmount
            model.paymentFor  = AnnualPackageName
            model.package_id  = paymentBalanceSheetId
            model.paymentBalanceSheetId  = paymentBalanceSheetId
            model.PaybleAmountComma = paymentAmount
            model.society_id = doGetLocalDataUser().societyID!
            model.blockID = doGetLocalDataUser().blockID!
            model.floorID = doGetLocalDataUser().floorID!
            model.userName = doGetLocalDataUser().userFullName
            model.userFirstName = doGetLocalDataUser().userFirstName
            model.userLastName = doGetLocalDataUser().userLastName
            model.userEmail = doGetLocalDataUser().userEmail
            model.userMobile = doGetLocalDataUser().userMobile
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.StrIsComeFromRenew = "1"
            vc.registerParamter = params
            vc.paymentSucess = self.penaltyContext as? PaymentSucessDelegate
            self.pushVC(vc: vc)
        }
    
    
    func PackageRegistrationLifetime(){
        
            let params : [String : String] = ["payPacakgeregistration" : "payPacakgeregistration",
                                              "society_id":doGetLocalDataUser().societyID!,
                                              "block_id":doGetLocalDataUser().blockID!,
                                              "floor_id" :doGetLocalDataUser().floorID!,
                                              "unit_id" :doGetLocalDataUser().unitID!,
                                              "membership_joining_date": lblJoiningDate.text ?? "",
                                              "company_name" : doGetLocalDataUser().company_name ?? "",
                                              "user_first_name" : doGetLocalDataUser().userFirstName ?? "",
                                              "user_last_name" : doGetLocalDataUser().userLastName ?? "",
                                              "user_full_name" : doGetLocalDataUser().userFullName ,
                                              "user_mobile" : doGetLocalDataUser().userMobile ?? "",
                                              "user_email" : doGetLocalDataUser().userEmail ?? "",
                                              "user_type" : "0",
                                              "user_token" : UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN) ?? "",
                                              "device":"ios",
                                              "gender" : doGetLocalDataUser().gender,
                                              "country_code" : doGetLocalDataUser().countryCode,
                                              "unit_name" : doGetLocalDataUser().unitName ?? "",
                                              "advocate_code": doGetLocalDataUser().advocate_code ?? "",
                                              "sanad_date": doGetLocalDataUser().sanad_date ?? "",
                                              "package_amount": LifeTimepaymentAmount,
                                              "user_profile_pic":doGetLocalDataUser().userProfilePic]
            
            
            var model = PayloadDataPayment()
            model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER
            model.paymentForName = doGetLocalDataUser().userFullName
            model.paymentDesc = LifeTimepaymentDesc
            model.paymentAmount = LifeTimepaymentAmount
            model.paymentFor  = LifeTimePackageName
            model.package_id  = LifeTimepaymentBalanceSheetId
            model.paymentBalanceSheetId  = LifeTimepaymentBalanceSheetId
            model.PaybleAmountComma = LifeTimepaymentAmount
            model.society_id = doGetLocalDataUser().societyID!
            model.blockID = doGetLocalDataUser().blockID!
            model.floorID = doGetLocalDataUser().floorID!
            model.userName = doGetLocalDataUser().userFullName
            model.userFirstName = doGetLocalDataUser().userFirstName
            model.userLastName = doGetLocalDataUser().userLastName
            model.userEmail = doGetLocalDataUser().userEmail
            model.userMobile = doGetLocalDataUser().userMobile
            let vc = PaymentOptionsVC()
            vc.payloadDataPayment = model
            vc.StrIsComeFromRenew = "1"
            vc.registerParamter = params
            vc.paymentSucess = self.penaltyContext as? PaymentSucessDelegate
            self.pushVC(vc: vc)
        }
    
    @IBAction func onClickPayAnnualPackage(_ sender: UIButton) {
        PackageRegistration()
//        var model = PayloadDataPayment()
//        model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PENALTY
//        model.paymentForName = self.doGetLocalDataUser().userFullName
//        model.paymentDesc = paymentDesc
//        model.paymentAmount = paymentAmount
//        model.paymentFor  = AnnualPackageName
//        model.paymentReceivedId  = paymentBalanceSheetId
//        model.penaltyId  = paymentBalanceSheetId
//        model.paymentBalanceSheetId  = paymentBalanceSheetId
//
//        let vc = PaymentOptionsVC()
//        vc.payloadDataPayment = model
//        vc.paymentSucess = self.penaltyContext as? PaymentSucessDelegate
//        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func onClickPayLifetimePackage(_ sender: UIButton) {
        PackageRegistrationLifetime()
//        var model = PayloadDataPayment()
//        model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER
//        model.paymentForName = self.doGetLocalDataUser().userFullName
//        model.paymentDesc = LifeTimepaymentDesc
//        model.paymentReceivedId  = LifeTimepaymentBalanceSheetId
//        model.penaltyId  = LifeTimepaymentBalanceSheetId
//        model.paymentAmount = LifeTimepaymentAmount
//        model.paymentFor  = LifeTimePackageName
//        model.paymentBalanceSheetId  = LifeTimepaymentBalanceSheetId
//
//        let vc = PaymentOptionsVC()
//        vc.payloadDataPayment = model
//        vc.paymentSucess = self.penaltyContext as? PaymentSucessDelegate
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func btnInvoiceAction(_ sender: Any) {
        let link = invoiceLink
        if link == "" {
            return
        }
        let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
        vc.strUrl = link
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickHome(_ sender: UIButton) {
        goToDashBoard(storyboard: mainStoryboard)
    }
  
}

extension RenewPlanDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRenew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPlans.dequeueReusableCell(withIdentifier: iCell, for: indexPath)as! RenewPlanTableCell
        cell.selectionStyle = .none
        if self.btnPaynowStatus {
            cell.viewBtn.isHidden = false
        } else {
            cell.viewBtn.isHidden = true
        }
        
        let objRenew = arrRenew[indexPath.row]
        cell.renewObject = objRenew
        cell.btnPay.tag = indexPath.row
        cell.btnPay.addTarget(self, action: #selector(btnPayNowClicked(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func btnPayNowClicked(_ sender : UIButton){
        let tag = sender.tag
        let package = self.arrRenew[tag]
        var model = PayloadDataPayment()
        model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PACAKGE_PLAN
        model.paymentForName = package.package_name ?? ""
        model.paymentDesc = package.package_desc ?? ""
        model.paymentAmount = package.package_amount  ?? ""
        model.paymentFor  = "Package"
        model.package_id  = package.package_id ?? ""
        model.paymentBalanceSheetId  = package.balancesheet_id ?? ""
        model.PaybleAmountComma = package.package_amount  ?? ""
        let vc = PaymentOptionsVC()
        vc.payloadDataPayment = model
//        vc.isComeFromPlan = ""
        StringConstants.CheckRenew = true
       // vc.paymentSucess = self
        self.pushVC(vc: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.viewDidLayoutSubviews()
//    }
}

