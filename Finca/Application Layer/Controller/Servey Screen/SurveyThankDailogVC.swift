//
//  SurveyThankDailogVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 25/06/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SurveyThankDailogVC: BaseVC {
    var surveyQuestionVC : SurveyQuestionVC!
    @IBOutlet weak var lbTitle : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.text = doGetValueLanguage(forKey: "thank_you_nthe_result_will_be_declared_soon")
    }
    @IBAction func tapOk(_ sender: Any) {
        self.dismiss(animated: true) {
            self.surveyQuestionVC.surveyVC.flagViewRefresh = true
            self.surveyQuestionVC.btnBackPressed(sender as! UIButton)
        }
    }
}
