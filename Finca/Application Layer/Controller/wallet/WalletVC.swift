//
//  WalletVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

struct ResposnseWallet : Codable {
    let availableBalance  :String! // : "1000.00",
    let till_msg  :String! // : "22 Nov 2020 04:54 PM",
    let message  :String! // : "Customer Transaction Successfully !",
    let status  :String! // : "200"
    let tansaction : [ModelTranction]!
}
struct ModelTranction : Codable {
    let user_mobile : String! //" : "9096693518",
    let wallet_id : String! //" : "54",
    let created_date : String! //" : "22 Nov 2020 11:08 AM",
    let active_status : String! //" : "0",
    let debit_amount : String! //" : "0.00",
    let credit_amount : String! //" : "1000.00",
    let society_id : String! //" : "75",
    let remark : String! //" : "22-11-2020",
    let avl_balance : String! //" : "1000.00"
    
    let credit_amount_view: String!
    let debit_amount_view: String!
    let avl_balance_view: String!
}

class WalletVC: BaseVC {
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbAvlBal: UILabel!
    let itemCell = "WalletTranctionCell"
    var tansaction = [ModelTranction]()
    
    @IBOutlet weak var tbvData: UITableView!
  
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var conHeightTable: NSLayoutConstraint!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblClearBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetWalletDetails()
        self.lbUserName.text = doGetLocalDataUser().userFullName ?? ""
        Utils.setImageFromUrl(imageView: ivProfile, urlString: doGetLocalDataUser().userProfilePic ?? "", palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.dataSource = self
        tbvData.delegate = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 40
        tbvData.rowHeight = UITableView.automaticDimension
        viewNoData.isHidden = true
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_wallet")
        lblNoData.text = doGetValueLanguage(forKey: "no_data")
        lblClearBalance.text = doGetValueLanguage(forKey: "clear_balance")
    }
    @IBAction func tapRefresh(_ sender: Any) {
        doGetWalletDetails()
    }
    func doGetWalletDetails() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getTransaction":"getTransaction",
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "user_mobile":doGetLocalDataUser().userMobile ?? "",
                      "unit_id":doGetLocalDataUser().unitID ?? "",
                      "country_code":doGetLocalDataUser().countryCode ?? ""]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.wallet_controller, parameters: params) { [self] (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResposnseWallet.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.lbAvlBal.text = "\(self.localCurrency())\(response.availableBalance ?? "")"
                        self.lbNote.text = response.till_msg
                        if response.tansaction != nil &&  response.tansaction.count > 0 {
                            self.tansaction = response.tansaction
                            self.tbvData.reloadData()
                            viewNoData.isHidden = true
                        }else {
                            viewNoData.isHidden = false
                        }
                        
                    }else {
                        self.lbAvlBal.text = "\(self.localCurrency())\(response.availableBalance ?? "")"
                      //  self.showAlertMessage(title: "Alert", msg: response.message)
                        viewNoData.isHidden = false
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    override func viewWillLayoutSubviews() {
        if tansaction.count > 0 {
            DispatchQueue.main.async {
                self.conHeightTable.constant = self.tbvData.contentSize.height
            }
        }
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    
}

extension WalletVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tansaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! WalletTranctionCell
        let item = tansaction[indexPath.row]
        
        cell.selectionStyle = .none
        cell.lbAmountBal.text = "\(localCurrency())\(item.avl_balance_view ?? "")"
        cell.lbDate.text = item.created_date
        
        if item.credit_amount != nil && item.credit_amount.count > 0 && Double(item.credit_amount ?? "0.0")! > 0 {
            cell.lbAmountCreadit.text = "+ \(localCurrency())\(item.credit_amount_view ?? "")"
            cell.lbAmountCreadit.textColor = ColorConstant.green500
            cell.lbTitle.text = item.remark
            cell.ivArrow.image = UIImage(named: "arrow_downward")
            cell.ivArrow.setImageColor(color: ColorConstant.grey_40)
        } else {
            cell.lbAmountCreadit.text = "- \(localCurrency())\(item.debit_amount_view ?? "")"
            cell.lbAmountCreadit.textColor = ColorConstant.red500
            cell.lbTitle.text = item.remark
            cell.ivArrow.image = UIImage(named: "arrow_upward")
            cell.ivArrow.setImageColor(color: ColorConstant.grey_40)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*    if notices[indexPath.row].height != nil {
         print("fff", notices[indexPath.row].height)
         return CGFloat(notices[indexPath.row].height)
         }*/
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
   
    
}
