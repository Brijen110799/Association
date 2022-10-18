//
//  BankAccountDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 31/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class BankAccountDetailsVC: BaseVC {
    
    
    @IBOutlet weak var heightUpiView: NSLayoutConstraint!
    @IBOutlet weak var viewUpi: UIView!
    @IBOutlet weak var imgupi: UIImageView!
    @IBOutlet weak var viewGst: UIView!
    @IBOutlet weak var lblGstValue: UILabel!
    @IBOutlet weak var lbGstTitle: UILabel!
    @IBOutlet weak var lbPersonName: UILabel!
    @IBOutlet weak var lbAccNo: UILabel!
    @IBOutlet weak var lbAccType: UILabel!
    @IBOutlet weak var lbBankName: UILabel!
    @IBOutlet weak var lbBranchName: UILabel!
    @IBOutlet weak var lbIFSCCode: UILabel!
    @IBOutlet weak var lbSwiftCode: UILabel!
    @IBOutlet weak var lbOtherRemark: UILabel!
    @IBOutlet weak var lbLabelPersonName: UILabel!
    @IBOutlet weak var lbLabelAccNo: UILabel!
    @IBOutlet weak var lbLabelAccType: UILabel!
    @IBOutlet weak var lbLabelBankName: UILabel!
    @IBOutlet weak var lbLabelBranchName: UILabel!
    @IBOutlet weak var lbLabelIFSCCode: UILabel!
    @IBOutlet weak var lbLabelSwiftCode: UILabel!
    @IBOutlet weak var lbLabelOtherRemark: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet  var views: [UIView]!
    var modelBankList : ModelBankList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }


    private func setupUI() {
        for item in  views {
            setThreeCorner(viewMain: item)
        }
        lbTitle.text = doGetValueLanguage(forKey: "bank_account_details") 
        lbLabelPersonName.text = doGetValueLanguage(forKey: "account_holder_name")
        lbLabelAccNo.text = doGetValueLanguage(forKey: "account_number")
        lbLabelAccType.text = doGetValueLanguage(forKey: "account_type")
        lbLabelBankName.text = doGetValueLanguage(forKey: "bank_name")
        lbLabelBranchName.text = doGetValueLanguage(forKey: "bank_branch")
        lbLabelIFSCCode.text = doGetValueLanguage(forKey: "ifsc_code")
        lbLabelSwiftCode.text = doGetValueLanguage(forKey: "swift_code")
        lbLabelOtherRemark.text = doGetValueLanguage(forKey: "other_remark")
        lbGstTitle.text = doGetValueLanguage(forKey: "tax_number")

        
        
        if let data = modelBankList {
            
            if data.account_holder ?? "" != "" {
                lbPersonName.text = data.account_holder ?? ""
            } else {
                lbPersonName.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            
           
            if data.account_number ?? "" != "" {
                lbAccNo.text = data.account_number ?? ""
            } else {
                lbAccNo.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
           
            if data.account_type ?? "" != "" {
                lbAccType.text = data.account_type ?? ""
            } else {
                lbAccType.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            if data.bank_name ?? "" != "" {
                lbBankName.text = data.bank_name ?? ""
            } else {
                lbBankName.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
           
            if data.bank_branch ?? "" != "" {
                lbBranchName.text = data.bank_branch ?? ""
            } else {
                lbBranchName.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            if data.ifsc_code ?? "" != "" {
                lbIFSCCode.text = data.ifsc_code ?? ""
            } else {
                lbIFSCCode.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            if data.swift_code ?? "" != "" {
                lbSwiftCode.text = data.swift_code ?? ""
            } else {
                lbSwiftCode.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            if data.other_remark ?? "" != "" {
                lbOtherRemark.text = data.other_remark ?? ""
            } else {
                lbOtherRemark.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            
            if data.gst_number ?? "" != "" {
                lblGstValue.text = data.gst_number ?? ""
            } else {
                lblGstValue.text = doGetValueLanguage(forKey: "no_data_avilable")
            }
            
            if data.upi_qr_code ?? "" != "" {
               
                Utils.setImageFromUrl(imageView:imgupi , urlString: data.upi_qr_code ?? "")
            } else {
                self.viewUpi.isHidden = true
            }
            
            
           
        }
        
        
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
}
