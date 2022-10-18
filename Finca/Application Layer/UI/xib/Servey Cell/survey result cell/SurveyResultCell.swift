//
//  SurveyResultCell.swift
//  Finca
//
//  Created by harsh panchal on 28/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SurveyResultCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var heightTableData: NSLayoutConstraint!
    @IBOutlet weak var tblData: UITableView!
     var question_option = [ModelQuestionOption]()
    let itemCell = "ResultSurveyPercetageCell"
    
    @IBOutlet weak var viewExtraForBottom: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let nib = UINib(nibName: itemCell, bundle: nil)
        tblData.register(nib, forCellReuseIdentifier: itemCell)
        tblData.delegate = self
        tblData.dataSource = self
        tblData.separatorStyle = .none
        
        
    }
    func setList(question_option : [ModelQuestionOption]) {
        self.question_option = question_option
        tblData.reloadData()
    }

  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SurveyResultCell : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question_option.count
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ResultSurveyPercetageCell
    cell.lbProgress.text = question_option[indexPath.row].votingPer + "%"
      
        cell.lbTitle.text = question_option[indexPath.row].survey_option_name
        cell.progressBar.setProgress(Float(question_option[indexPath.row].votingPer)!/100, animated: false)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPatxh: IndexPath) -> CGFloat {
        return 60
    }
}
