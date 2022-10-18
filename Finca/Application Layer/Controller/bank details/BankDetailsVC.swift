//
//  BankDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class BankDetailsVC: BaseVC {

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivBsnk: UIImageView!
    let requrest = AlamofireSingleTon.sharedInstance
    let cellItem = "BankDetailsItem"
    var bankList = [ModelBankList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let inb = UINib(nibName: cellItem, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: cellItem)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        
        addRefreshControlTo(tableView: tbvData)
        lbTitle.text = doGetValueLanguage(forKey: "my_bank_account")
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
    }

    override func pullToRefreshData(_ sender: Any) {
        hidePull()
        doGetBankDetails()
        
    }

    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    override func viewWillAppear(_ animated: Bool) {
        doGetBankDetails()
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        let  vc = AddBankDetailsVC()
        pushVC(vc: vc)
    }
    
    private func doGetBankDetails() {
        
        
        showProgress()
        let params = ["getBankList":"getBankList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        
        print("param" , params)
        
     
        
        requrest.requestPost(serviceName:  NetworkAPI.bank_controller, parameters: params) { (json, error) in
         
                self.hideProgress()
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseBankList.self, from:json!)
                    
                    if response.status == "200" {
                        
                        //self.MemberTypes = response.member_types
                        
                        if let list = response.list {
                            self.bankList = list
                            self.tbvData.reloadData()
                        }
                        if self.bankList.count > 0{
                            self.viewNoData.isHidden = true
                        }else {
                            self.viewNoData.isHidden = false
                        }
                        
                      
                    }else {
                        self.viewNoData.isHidden = false
                        self.bankList.removeAll()
                        self.tbvData.reloadData()
                        
                        //self.showAlertMessage(title: "Alert", msg: response.message ?? "")
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    private func doDeleteBank(bank_id:String) {
        
        
        showProgress()
        let params = ["deleteBank":"deleteBank",
                      "user_id":doGetLocalDataUser().userID!,
                      "bank_id":bank_id]
        
        
        print("param" , params)
        
     
        
        requrest.requestPost(serviceName:  NetworkAPI.bank_controller, parameters: params) { (json, error) in
         
                self.hideProgress()
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseBankList.self, from:json!)
                    
                    if response.status == "200" {
                        
                        //self.MemberTypes = response.member_types
                        
                        self.doGetBankDetails()
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message ?? "")
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
}


extension BankDetailsVC : UITableViewDataSource , UITableViewDelegate {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem, for: indexPath) as! BankDetailsItem
        let item = bankList[indexPath.row]
        cell.lbBankName.text = "\(item.bank_name ?? "") \(item.bank_branch ?? "")"
        
        cell.lbAccountName.text = item.account_holder ?? ""
        cell.lbAccountNumber.text = item.account_number ?? ""
        cell.selectionStyle = .none
        setThreeCorner(viewMain: cell.viewMain)
        
        cell.bEdit.tag = indexPath.row
        cell.bEdit.addTarget(self, action: #selector(tapEdit(sender:)), for: .touchUpInside)
       
        cell.bShare.tag = indexPath.row
        cell.bShare.addTarget(self, action: #selector(tapShare(sender:)), for: .touchUpInside)
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(tapDelete(sender:)), for: .touchUpInside)
       
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let  vc = BankAccountDetailsVC()
        vc.modelBankList = bankList[indexPath.row]
        pushVC(vc: vc)
    }
    @objc func tapEdit(sender :UIButton) {
        let  vc = AddBankDetailsVC()
        vc.modelBankList = bankList[sender.tag]
        vc.isEdit = true
        pushVC(vc: vc)
    }
    @objc func tapShare(sender :UIButton) {
        let item = bankList[sender.tag]
//        let shareString = "BANK NAME\n\(item.bank_name ?? "") \(item.bank_branch ?? "")\nHOLDER NAME\n\(item.account_holder ?? "")\nACCOUNT NUMBER\n\(item.account_number ?? "")\nACCOUNT TYPE\n\(item.account_type ?? "")\nIFSC CODE\n\(item.ifsc_code ?? "")\nSWIFT CODE\n\(item.swift_code ?? "")"
        var shareString = ""
        if   item.bank_name ?? "" != ""  {
            shareString = "Bank Name:\(item.bank_name ?? "")\n"
            
        }
        
        if   item.account_holder ?? "" != ""  {
            shareString = "\(shareString)Holder Name:\(item.account_holder ?? "")\n"
            
        }
        if   item.account_number ?? "" != ""  {
            shareString = "\(shareString)Account Number:\(item.account_number ?? "")\n"
            
        }
        if   item.bank_branch ?? "" != "" {
            shareString = "\(shareString)Bank Branch:\(item.bank_branch ?? "")\n"
            
        }
        if   item.ifsc_code ?? "" != "" {
            shareString = "\(shareString)IFSC Code:\(item.ifsc_code ?? "")\n"
            
        }
        if   item.swift_code ?? "" != "" {
            shareString = "\(shareString)Swift Code:\(item.swift_code ?? "")\n"
            
        }
        if   item.account_type ?? "" != "" {
            shareString = "\(shareString)Account Type:\(item.account_type ?? "")\n"
            
        }
        if   item.gst_number ?? "" != "" {
            shareString = "\(shareString)GST Code:\(item.gst_number ?? "")\n\n"
            
        }
//        if   item.upi_qr_code ?? "" != "" {
//            shareString = "\(shareString)Here My UPI details\n"
//            
//        }
        
        
        var image = UIImage()
        if  item.upi_qr_code ?? "" != "" {
            
            let url = URL(string: item.upi_qr_code!)
            let data = try? Data(contentsOf: url!)

            if let imageData = data {
                image = UIImage(data: imageData)!
            }
           
        }
        
        
//        let data = instanceLocal().getShareappcontent()
//
//
//        let image = UIImage(named: "advert_share")
//        let shareAll = [ image as Any, data ] as [Any]
//
//        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//
//        self.present(activityViewController, animated: true, completion: nil)
        
       
        
        let textToShare = [image as Any, shareString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func tapDelete(sender :UIButton) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete, tag: sender.tag , cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }
}

extension BankDetailsVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                self.doDeleteBank(bank_id: self.bankList[tag].bank_id ?? "")
            }
        }
    }
    
}
struct ResponseBankList  : Codable {
    let status : String? //" : "200",
    let message : String? //" : "list get success."
    let list : [ModelBankList]?
}
struct ModelBankList  : Codable {
    let upi_qr_code :String?
    let gst_number : String?
    let old_upi_qr_code :String?
    let bank_branch : String? //" : "sbi",
    let account_number : String? //" : "324532889",
    let bank_id : String? //" : "30",
    let account_type : String? //" : "Savings account",
    let account_holder : String? //" : "deepak",
    let ifsc_code : String? //" : "sbin0010438",
    let swift_code : String? //" : "",
    let bank_name : String? //" : "sbi",
    let other_remark : String? //" : ""
}
