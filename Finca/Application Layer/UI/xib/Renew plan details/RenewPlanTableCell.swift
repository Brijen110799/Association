//
//  RenewPlanTableCell.swift
//  Finca
//
//  Created by Fincasys Macmini on 27/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class RenewPlanTableCell: UITableViewCell {
    
    @IBOutlet weak var lblMembershipName: UILabel!
    @IBOutlet weak var lblMembershipDetail: UILabel!
    @IBOutlet weak var tblYearAmount: UITableView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var tblYearHeightConstraint: NSLayoutConstraint!
    
    var arrSlabList = [RenewSlabModel]()
    var itemCell = "RenewYearTableCell"
    
    var renewObject: RenewModel? {
        didSet {
            lblMembershipName.text = renewObject?.package_name
            lblMembershipDetail.text = renewObject?.package_desc?.htmlToString
            lblTotalAmount.text = "₹ \(renewObject?.package_amount ?? "0.0")"
            arrSlabList = renewObject?.slab ?? []
            if arrSlabList.count > 0{
                self.arrSlabList.insert(RenewSlabModel(year_price: "Amount", year: "", slab_year: "Year"), at: 0)
                viewTable.isHidden = false
            } else {
                viewTable.isHidden = true
            }
            tblYearAmount.reloadData()
            self.tblYearHeightConstraint.constant = (CGFloat(self.arrSlabList.count) * 37.0) //self.tblYearAmount.contentSize.height
            self.tblYearAmount.needsUpdateConstraints()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblYearAmount.delegate = self
        tblYearAmount.dataSource = self
        let nib = UINib(nibName: itemCell, bundle: nil)
        tblYearAmount.register(nib, forCellReuseIdentifier: itemCell)
        tblYearAmount.separatorStyle = .none
        tblYearAmount.reloadData()
        tblYearAmount.isScrollEnabled = false
    }
    
//    func setSlabList(arrRenew : [RenewModel]) {
//        self.arrRenewList = arrRenew
//        tblYearAmount.reloadData()
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RenewPlanTableCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSlabList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblYearAmount.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! RenewYearTableCell
        cell.selectionStyle = .none
        let objYearAmount = arrSlabList[indexPath.row]
        if indexPath.row == 0{
            cell.lblYear.text = objYearAmount.slab_year
            cell.lblAmount.text = objYearAmount.year_price
            cell.lblYear.textColor = ColorConstant.primaryColor
            cell.lblAmount.textColor = ColorConstant.primaryColor
        }else{
            cell.lblYear.text = objYearAmount.slab_year
            cell.lblAmount.text = "₹ \(objYearAmount.year_price ?? "0.0")"
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}


