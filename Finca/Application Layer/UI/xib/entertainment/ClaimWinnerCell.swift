//
//  ClaimWinnerCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol OnClickCliam {
    func onClickClaim(index : Int)
    func onClickView(index : Int)
    
}
class ClaimWinnerCell: UICollectionViewCell {

    @IBOutlet weak var bWinner: UIButton!
    @IBOutlet weak var bClaim: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTotalCoin: UILabel!
    @IBOutlet weak var lbTotalPrize: UILabel!
    @IBOutlet weak var lbClaimPrize: UILabel!
    var onClickCliam : OnClickCliam!
    var index : Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickClaim(_ sender: Any) {
        onClickCliam.onClickClaim(index: index)
    }
    
    @IBAction func onClickView(_ sender: Any) {
         onClickCliam.onClickView(index:  index)
    }
}
