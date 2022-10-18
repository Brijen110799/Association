//
//  DocumentNameCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 06/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol OnClickDeleteImage {
    func onClickDeleteImage(index : Int , type : String)
}

class DocumentNameCell: UICollectionViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivDoc: UIImageView!
    var onClickDeleteImage: OnClickDeleteImage!
    @IBOutlet weak var bClose: UIButton!
    var index = 0
    var type = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickDelete(_ sender: Any) {
        
        onClickDeleteImage.onClickDeleteImage(index: index, type: type)
        
    }
}
