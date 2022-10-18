//
//  CategoryCell.swift
//  Zoobiz
//
//  Created by Silverwing Technologies on 05/01/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setThreeCorner(viewMain: viewMain)
    }
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

}
