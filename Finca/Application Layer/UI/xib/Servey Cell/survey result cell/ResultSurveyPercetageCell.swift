//
//  ResultSurveyPercetageCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 06/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ResultSurveyPercetageCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbProgress: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       


        // Configure the view for the selected state
    }
    
}
