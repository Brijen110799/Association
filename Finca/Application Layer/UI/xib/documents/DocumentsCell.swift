//
//  DocumentsCell.swift
//  Finca
//
//  Created by anjali on 26/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DocumentsCell: UICollectionViewCell {
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var ivPlaceHolder: UIImageView!
    @IBOutlet weak var btnDeleteClicked: UIButton!
    @IBOutlet weak var viewDeleteButton: UIView!
    @IBOutlet weak var bubbleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.makeBubbleView()
        // Initialization code
    }

}
