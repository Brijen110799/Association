//
//  ServeyVC.swift
//  Finca
//
//  Created by Silverwing-macmini1 on 24/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
struct SurveyReplyModel {
    var questionId : String!
    var answerOptionId : String!
}
class SurveyQuestionVC: BaseVC {
    
    @IBOutlet weak var viewPeviousbutton: UIView!
    @IBOutlet weak var lblSurveyTopic: UILabel!
    @IBOutlet weak var btnNextQuestion: UIButton!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var lblQueCount: UILabel!
    @IBOutlet weak var ProgressBarView: UIProgressView!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var lblQuestions: UILabel!
    //@IBOutlet weak var tbvOptions: UITableView!
    @IBOutlet weak var imgQuestion: UIImageView!
  //  @IBOutlet weak var hieghtConImage: NSLayoutConstraint!
    
    @IBOutlet weak var viewSurveyQuestions: UIView!
    @IBOutlet weak var viewSurveyResult: UIView!
    @IBOutlet weak var lblBtnNext: UILabel!
    @IBOutlet weak var lblBtnPrevious: UILabel!
    @IBOutlet weak var CollectHeight: NSLayoutConstraint!
    @IBOutlet weak var cvOption: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSurveyAnswer: UILabel!
    @IBOutlet weak var lbSurveyMsg: UILabel!
    
    var questionArray = [SurveyQuestion]()
    var questionResponseArray = [SurveyReplyModel]()
    var surveyVC :  SurveyVC!
    var optionsArray = [QuestionOption](){
        didSet{
            cvOption.reloadData()
        }
    }
    var count = 0
    var Questioncount = 0
    var selectedIndex = 0
    let itemCell = "SurveyOptionCell"
    // below variable is populated from the previous screen
    var surveyBasicDetails : SurveyModel!
    var questionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSurveyTopic.text = surveyBasicDetails.surveyTitle
        callApiGetSurveyQue()
        ProgressBarView.progress = 0.0
        viewPeviousbutton.isHidden = true
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvOption.register(nib, forCellWithReuseIdentifier: itemCell)
        cvOption.delegate = self
        cvOption.dataSource = self
        self.lblQueCount.isHidden = true
        
        lbTitle.text = doGetValueLanguage(forKey: "survey_details")
        lblBtnNext.text = doGetValueLanguage(forKey: "next")
        lblBtnPrevious.text = doGetValueLanguage(forKey: "previous")
        lbSurveyAnswer.text = doGetValueLanguage(forKey: "survey_answered")
        lbSurveyMsg.text = doGetValueLanguage(forKey: "survey_msg")
        
    }
    func callApiGetSurveyQue(){
        self.showProgress()
        let params = ["getSurveyQuestion":"getSurveyQuestion",
                      "society_id":doGetLocalDataUser().societyID!,
                      "survey_id":surveyBasicDetails.surveyID!]

        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.surveyController, parameters: params) { (json, error) in
             self.hideProgress()
            print(json as Any)
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SurveyQuestionReponse.self, from:json!)
                    if response.status == "200" {
                        self.questionArray.append(contentsOf: response.survey)
                        self.lblQueCount.text = "0 of \(self.questionArray.count)  \(self.doGetValueLanguage(forKey: "answered"))"
                        self.doSetDataAtIndex(index: 0)
                        self.viewSurveyQuestions.isHidden = false
                        self.viewSurveyResult.isHidden = true
                    }else {
                        print("error",error as Any)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func doSetDataAtIndex(index questionIndex : Int)  {
        let data = questionArray[questionIndex]
        self.lblQueCount.text = "\(questionIndex) \(doGetValueLanguage(forKey: "of")) \(self.questionArray.count) \(doGetValueLanguage(forKey: "answered"))"
        self.questionNumber.text = "\(doGetValueLanguage(forKey: "question")) : \(questionIndex + 1)"
        
        if data.questionImage != nil  && data.questionImage != "" {
            Utils.setImageFromUrl(imageView: self.imgQuestion, urlString: data.questionImage, palceHolder: "no_image")
            imgQuestion.isHidden = false
        } else {
            imgQuestion.isHidden = true
        }
        //self.Questioncount = questionIndex
        self.count = questionIndex
        self.questionId = data.surveyQuestionId
        self.lblQuestions.text = data.surveyQuestion
        self.optionsArray = data.questionOption
    }
    func doSetQuestionAtIndex(index queIndex : Int)  {
        let data = questionArray[queIndex]
        self.selectedIndex = queIndex
        self.questionNumber.text = "\(doGetValueLanguage(forKey: "question")) : \(queIndex + 1)"

        if data.questionImage != nil  && data.questionImage != "" {
            Utils.setImageFromUrl(imageView: self.imgQuestion, urlString: data.questionImage, palceHolder: "no_image")
            imgQuestion.isHidden = false
        } else {
            imgQuestion.isHidden = true
        }

        self.Questioncount = queIndex
        self.questionId = data.surveyQuestionId
        self.lblQuestions.text = data.surveyQuestion
        self.optionsArray = data.questionOption
    }
    @IBAction func btnPreviousClicked(_ sender: Any) {
//        if self.count != 1{
//            self.lblBtnNext.text = "Next"
//            //self.Questioncount -= 1
//            //self.count -= 1
//
//            self.doSetDataAtIndex(index: count)
////
////            let progresscount:Float = Float(count) / Float(questionArray.count)
////            self.lblPer.text = String(format: "%.2f", (progresscount * 100))
////          //  print("PROGRESS COUNT",progresscount)
////            self.ProgressBarView.setProgress(Float(progresscount), animated: true)
//        }
        if self.count != 0 {
                self.count -= 1
                self.selectedIndex -= 1
                self.questionId = ""
                self.doSetQuestionAtIndex(index: count)
            if count == 0 {
                self.viewPeviousbutton.isHidden = true
            }
            }
        
        else{
            self.viewPeviousbutton.isHidden = true
           
        }
    }
    @IBAction func onClickNextQuestion(_ sender: UIButton) {
        //puts(" ");
        var selectedIndex = 0
        var isChack = false
       
        for (index, item)  in optionsArray.enumerated(){
            if item.isChack != nil && item.isChack{
                isChack = true
                selectedIndex = index
                break
            }
        }
        
       
        if isChack{
           // print("selected indexpath row",selectedIndex!.count)
          //  print("CURRENT COUNT ",count)
           // print("ARRAY COUNT ",questionArray.count)
            print("index Of ", selectedIndex)
            if count < questionArray.count - 1{
                //self.flag = true
                self.lblQueCount.isHidden = false
                let data = optionsArray[selectedIndex]
                let insertFlag = true
                viewPeviousbutton.isHidden = false
                for (index,item) in questionResponseArray.enumerated(){
                    if item.questionId == self.questionId{
                        self.questionResponseArray.remove(at: index)
                       
                    }
                }
                //in case of flag to be false the already registered data will be altered using the above control structure
                if insertFlag{
                    print("questionId   ",self.questionId)
                    print("questionId   ",self.questionId)
                    self.questionResponseArray.append(SurveyReplyModel(questionId: self.questionId, answerOptionId: data.surveyOptionId))
                }
                self.cvOption.deselectItem(at: IndexPath(), animated: true)
                self.count += 1
                self.selectedIndex += 1
                self.questionId = ""
                self.doSetDataAtIndex(index: count)
                self.Questioncount += 1
              
                self.doSetQuestionAtIndex(index: Questioncount)
                let progresscount:Float = Float(count) / Float(questionArray.count)
                self.lblPer.text = String(format: "%.2f", (progresscount * 100))
              //  print("PROGRESS COUNT",progresscount)
                self.ProgressBarView.setProgress(Float(progresscount), animated: true)
            }else if count == questionArray.count - 1{
               
                if questionResponseArray.count < questionArray.count{
                    let data = optionsArray[selectedIndex]
                    self.questionResponseArray.append(SurveyReplyModel(questionId: self.questionId, answerOptionId: data.surveyOptionId))
                }
                self.lblPer.text = "100"
                self.lblQueCount.text = "\(questionArray.count) \(doGetValueLanguage(forKey: "of")) \(self.questionArray.count) \(doGetValueLanguage(forKey: "answered"))"
                self.ProgressBarView.setProgress(1, animated: true)
                self.viewSurveyResult.isHidden = false
                self.viewSurveyQuestions.isHidden = true
                self.viewPeviousbutton.isHidden = false
                self.lblBtnNext.text = doGetValueLanguage(forKey: "submit")
                doSubmitData()
                
            }
            if count == questionArray.count - 1{
                self.lblBtnNext.text = doGetValueLanguage(forKey: "submit")
            }
            
            
        }
        
        else{
            self.toast(message: doGetValueLanguage(forKey: "please_select_option_first"), type: .Warning)
        }
        printReponseArray()
    }
    
    func doSubmitData() {
        
        var survey_option_id = ""
        var survey_question_id = ""
        
        for item in  questionResponseArray {
            if survey_option_id == "" {
                survey_option_id = item.answerOptionId
            } else {
                survey_option_id = survey_option_id +  "," + item.answerOptionId
            }
            
            if survey_question_id == "" {
                survey_question_id = item.questionId
            } else {
                survey_question_id = survey_question_id +  "," + item.questionId
            }
            
        }
        print("Option Id", survey_option_id)
        print("question Id", survey_question_id)
     
        
        self.showProgress()
        let params = ["addSurveyAnswer":"addSurveyAnswer",
                      "society_id":doGetLocalDataUser().societyID!,
                      "survey_option_id" : survey_option_id,
                      "survey_question_id" : survey_question_id,
                      "survey_id":surveyBasicDetails.surveyID!,
                      "user_id" : doGetLocalDataUser().userID!,
                      "unit_id" :  doGetLocalDataUser().unitID!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.surveyController, parameters: params) { (json, error) in
            self.hideProgress()
            print(json as Any)
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SurveyQuestionReponse.self, from:json!)
                    if response.status == "200" {
                        let screenwidth = UIScreen.main.bounds.width
                        let screenheight = UIScreen.main.bounds.height
                      //  let vc = self.storyboard!.instantiateViewController(withIdentifier: "idSurveyThankDailogVC")as! SurveyThankDailogVC
                        let vc = SurveyThankDailogVC()
                        vc.surveyQuestionVC = self
                        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
                        popupVC.backgroundAlpha = 0.8
                        popupVC.backgroundColor = .black
                        popupVC.shadowEnabled = true
                        popupVC.canTapOutsideToDismiss = false
                        self.present(popupVC, animated: true)

                    }else {
                        print("error",error as Any)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }

    }
    func printReponseArray(){
        for item in questionResponseArray{
            print("\(item.questionId!) - \(item.answerOptionId!)\n")
        }
    }

    func checkAnswerExistance(question_id : String!)->String!{
        var returnString = ""
        for item in questionResponseArray{
            print("solution array question",item.questionId!)
            print("sent question id",question_id!)
            if item.questionId == question_id{
                returnString = item.answerOptionId
            }else{
                returnString = ""
            }
        }
        return returnString
    }
}

extension SurveyQuestionVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = optionsArray[indexPath.row]
        let cell = cvOption.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! SurveyOptionCell
        cell.lblOption.text = data.surveyOptionName
               
        if optionsArray[indexPath.row].isChack != nil && optionsArray[indexPath.row].isChack {

            cell.viewOption.backgroundColor = UIColor(named: "green 500")
            cell.lblOption.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                       

        }else{
            cell.viewOption.backgroundColor = UIColor(named: "grey_5")
           cell.lblOption.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        }
      return cell
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = cvOption.bounds.width/2
        return CGSize(width: width - 2, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if optionsArray[indexPath.row].isChack != nil && optionsArray[indexPath.row].isChack {
           optionsArray[indexPath.row].isChack = false
        }else{
            optionsArray[indexPath.row].isChack = true
        }
        for (index, _)  in optionsArray.enumerated(){
            if index != indexPath.row{
                optionsArray[index].isChack = false
            }
        }
        if questionArray[count].questionOption[indexPath.row].isChack != nil && questionArray[count].questionOption[indexPath.row].isChack{
            questionArray[count].questionOption[indexPath.row].isChack = false
        }else{
            questionArray[count].questionOption[indexPath.row].isChack = true
        }
        for (index, _) in  questionArray[count].questionOption.enumerated(){
            if index != indexPath.row{
                questionArray[count].questionOption[index].isChack = false
            }
        }
        collectionView.reloadData()
    }
    
}
extension SurveyQuestion : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Success{

        }
    }
}
