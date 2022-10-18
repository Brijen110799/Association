//
//  OccupationCell.swift
//  Finca
//
//  Created by harsh panchal on 13/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol OcupationCellDelegate {
    func onClickContactNumber(indexPath:IndexPath)
}
class OccupationCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblBlockName: UILabel!
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblBusinessCategory: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var delegate : OcupationCellDelegate!
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnPhoneClicked(_ sender: UIButton) {
        self.delegate.onClickContactNumber(indexPath: self.indexPath)
    }
    
}
