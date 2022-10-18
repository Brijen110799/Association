//
//  MultiUnitCell.swift
//  Finca
//
//  Created by harsh panchal on 12/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
protocol MultiUnitCellDelegate {
    func deleteButtonClicked(atIndexpath indexPath : IndexPath)
}
class MultiUnitCell: UITableViewCell {

    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var imgSelectedItem: UIView!
    @IBOutlet weak var lblUnitName: MarqueeLabel!
    var indexPath : IndexPath!
    var delegate : MultiUnitCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        self.delegate.deleteButtonClicked(atIndexpath: self.indexPath)
    }

}
