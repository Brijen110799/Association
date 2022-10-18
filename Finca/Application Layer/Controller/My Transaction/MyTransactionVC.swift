//
//  MyTransactionVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 10/02/21.
//  Copyright © 2021 anjali. All rights reserved.
//
import UIKit
struct TransactionModel : Codable{
    let transection_id: String! // "36",
    let payment_mode: String! // "RazorPay",
    let user_mobile: String! // "7984910005",
    let society_id: String! // "203",
    let transection_date: String! // "16 Dec 2020 01:09 PM",
    let payment_for_name: String! // "16\/12  Maintenance 1 - Maintenance",
    let transection_amount: String! // "6751.8"
    let transection_invoice : String!
}
struct TransactionResponse: Codable {
    var message: String!
    var status: String!
    var tansaction: [TransactionModel]!

}
class MyTransactionVC: BaseVC {

    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var tbvTransaction: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    let itemCell = "transactionCell"
    var transactionArr = [TransactionModel]()
    var invoicelink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewNodata.isHidden = true
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvTransaction.register(nib, forCellReuseIdentifier: itemCell)
        tbvTransaction.delegate = self
        tbvTransaction.dataSource = self
        
        tbvTransaction.estimatedRowHeight = UITableView.automaticDimension
        tbvTransaction.rowHeight = UITableView.automaticDimension
        self.doGetApi()
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_transaction")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
        
    }

    override func fetchNewDataOnRefresh() {
        self.doGetApi()
        self.transactionArr.removeAll()
    }
    
    @IBAction func tapToBack(_ sender: Any) {
        doPopBAck()
    }
    func doGetApi(){
        let params = ["getOnlineTransaction":"getOnlineTransaction",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.wallet_controller, parameters: params) { (json, Err) in
      
            if json.self != nil{
                print(json as Any)
               // self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(TransactionResponse.self, from: json!)
                    if response.status == "200"{
                        self.viewNodata.isHidden = true
                        self.transactionArr = response.tansaction
                        if self.transactionArr.count == 0 {
                            self.viewNodata.isHidden = false
                        }
                        self.tbvTransaction.reloadData()
                        print("sucess")
                        
                    }else{
                        self.viewNodata.isHidden = false
                        self.transactionArr.removeAll()
                        self.tbvTransaction.reloadData()
                        self.showAlertMessage(title: "", msg: response.message)
                
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
}
extension MyTransactionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = transactionArr[indexPath.row]
        let cell = tbvTransaction.dequeueReusableCell(withIdentifier: "transactionCell")as! transactionCell
        cell.selectionStyle = .none
        cell.lbPaymentName.text = data.payment_for_name
        cell.lbTransactionDate.text = data.transection_date
        cell.lbTransactionAmount.text = localCurrency()+""+data.transection_amount
        cell.lbTransactionMode.text = data.payment_mode
        cell.btninvo.tag = indexPath.row
        cell.btninvo.addTarget(self, action: #selector(btninvoice(sender:)), for: .touchUpInside)
        if self.transactionArr[indexPath.row].transection_invoice == "" {
            cell.btninvo.isHidden = true
            cell.constinvoiceheight.constant = 0
        }else {
            cell.btninvo.isHidden = false
            cell.constinvoiceheight.constant = 30
        }
        
        return cell
    }
    @objc func btninvoice(sender : UIButton) {
         
            
        let link = transactionArr[sender.tag].transection_invoice
                if link == "" {
                    return
                }
                let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
                vc.strUrl = link
                self.navigationController?.pushViewController(vc, animated: true)
           
        }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }

}
