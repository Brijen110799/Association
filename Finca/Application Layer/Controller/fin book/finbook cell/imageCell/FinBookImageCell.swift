//
//  FinBookImageCell.swift
//  Finca
//
//  Created by harsh panchal on 20/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol FinBookImageCellDelegate {
    func deleteButtonClicked(at indexpath : IndexPath!)
}

class FinBookImageCell: UICollectionViewCell {

    @IBOutlet weak var selectedImage: UIImageView!
    var indexPath : IndexPath!
    var delegate : FinBookImageCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func btnDelete(_ sender: UIButton) {
        self.delegate.deleteButtonClicked(at: self.indexPath)
    }
}
