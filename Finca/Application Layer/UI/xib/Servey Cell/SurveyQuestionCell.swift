//
//  SurveyQuestionCell.swift
//  Finca
//
//  Created by Silverwing-macmini1 on 27/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SurveyQuestionCell: UIView {

    @IBOutlet weak var tbvOption: UITableView!
    @IBOutlet weak var ivQuestion: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblQuestionNo: UILabel!
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    
    let itemCell = "SurveyOptionCell"
    func viewDidLoad() {
        // super.viewDidLoad()
    }
}

