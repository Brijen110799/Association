//
//  GameHistoryCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 24/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol GameClickDelegate {
    func onClickDetail(index: Int)
     func onClickLink(index: Int)
}

class GameHistoryCell: UITableViewCell {

    @IBOutlet weak var ivSponser: UIImageView!
    @IBOutlet weak var lbLink: UILabel!
    @IBOutlet weak var viewSponser: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSpanseNeme: UILabel!
    var gameClickDelegate : GameClickDelegate!
    @IBOutlet weak var conHeightSponser: NSLayoutConstraint!
    @IBOutlet weak var lblSponserByTitle: UILabel!
    @IBOutlet weak var btnViewResult: UIButton!
    var  index : Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickDetails(_ sender: Any) {
        gameClickDelegate.onClickDetail(index: index)
        
    }
    @IBAction func onClickLink(_ sender: Any) {
         gameClickDelegate.onClickLink(index: index)
      }
}
