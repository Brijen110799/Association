//
//  SurveyResultVC.swift
//  Finca
//
//  Created by harsh panchal on 28/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

struct ResponseSurverResult  : Codable{
    let message : String! //" : "Question get successfully",
    let total_participant : Int! //" : 0,
    let status : String! //" : "200"
    let survey : [ModelSurverResult]!
    
}

struct ModelSurverResult  : Codable {
    let question_image  :String! //" : "",
    let survey_question_id  :String! //" : "1",
    let survey_id  :String! //" : "1",
    let survey_question  :String! //" : "Are yave been exposed to someone who tested positive or
    let question_option : [ModelQuestionOption]!
}

struct ModelQuestionOption  : Codable {
    let votingPer  :String!//" : "0",
    let survey_option_id  :String!//" : "1",
    let survey_option_name  :String!//" : "Yes"
}

class SurveyResultVC: BaseVC {

    @IBOutlet weak var tbvResult: UITableView!
    let itemCell = "SurveyResultCell"
       var surveyModel : SurveyModel!
     var survey = [ModelSurverResult]()
    
    @IBOutlet weak var lbParticipant: UILabel!
    @IBOutlet weak var viewTotalPArticipant: UIView!
    @IBOutlet weak var lbTitle: UILabel!
     var gradient : CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvResult.register(nib, forCellReuseIdentifier: itemCell)
        tbvResult.delegate = self
        tbvResult.dataSource = self
        tbvResult.separatorStyle = .none
        // Do any additional setup after loading the view.
         doGetResult()
      //  addGradient(color:  [ColorConstant.start_balnce_sheet.cgColor,ColorConstant.end_balnce_sheet.cgColor])
        viewTotalPArticipant.backgroundColor = ColorConstant.colorP
        lbTitle.text = doGetValueLanguage(forKey: "survey_results")
    }
   
    func addGradient(color:[CGColor]){
    let gradient: CAGradientLayer = CAGradientLayer()

    gradient.colors = color
    gradient.locations = [0.0 , 1.0]
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    self.viewTotalPArticipant.layer.insertSublayer(gradient, at: 0)
    }

 
    func doGetResult(){
          showProgress()
          let params = ["getSurveyResult":"getSurveyResult",
                        "society_id":doGetLocalDataUser().societyID!,
                        "survey_id":surveyModel.surveyID!]
          print("param" , params)
          let request = AlamofireSingleTon.sharedInstance

          request.requestPost(serviceName: ServiceNameConstants.surveyController, parameters: params) { (json, error) in
              self.hideProgress()
              if json != nil {
                  do {
                      let response = try JSONDecoder().decode(ResponseSurverResult.self, from:json!)
                      if response.status == "200" {
                        self.viewTotalPArticipant.isHidden = false
                        self.lbParticipant.text = "\(self.doGetValueLanguage(forKey: "total")) " + String(response.total_participant) + " \(self.doGetValueLanguage(forKey: "participant_survey"))"
                        self.survey = response.survey
                        self.tbvResult.reloadData()
                      }else {
                         self.viewTotalPArticipant.isHidden = true
                        self.tbvResult.reloadData()
                    }
                    print(json as Any)
                  } catch {
                      print("parse error")
                  }
              }
          }
      }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
}
extension SurveyResultVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return survey.count
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvResult.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! SurveyResultCell
        cell.selectionStyle = .none
        cell.heightTableData.constant = CGFloat(60 * survey[indexPath.row].question_option.count)
        cell.setList(question_option: survey[indexPath.row].question_option)
        cell.lbTitle.text = "Q : " + survey[indexPath.row].survey_question
        
        if indexPath.row ==  survey.count - 1 {
            cell.viewExtraForBottom.isHidden = false
        }else {
            cell.viewExtraForBottom.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPatxh: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
