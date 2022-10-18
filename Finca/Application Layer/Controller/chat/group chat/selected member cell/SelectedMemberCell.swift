//
//  SelectedMemberCell.swift
//  Finca
//
//  Created by harsh panchal on 09/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol SelectedMemberCellDelegate {
    func removeMemberClicked(at indexPath : IndexPath!)
}
class SelectedMemberCell: UICollectionViewCell {
    var indexPath : IndexPath!
    var delegate : SelectedMemberCellDelegate!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMemberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnRemoveClicked(_ sender: UIButton) {
        self.delegate.removeMemberClicked(at: indexPath)
    }
    
    
}
