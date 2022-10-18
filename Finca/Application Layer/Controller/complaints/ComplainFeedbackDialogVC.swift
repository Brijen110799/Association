//
//  ComplainFeedbackDialogVC.swift
//  Finca
//
//  Created by Jay Patel on 15/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Cosmos
class ComplainFeedbackDialogVC: BaseVC, UITextViewDelegate {
    
    var data: ComplainModel!
    var rating = 0.0
    var context : ComplaintsVC!
    var hint = "Type here"
    @IBOutlet var lblComplainID: UILabel!
    @IBOutlet var tvFeedback: UITextView!
    @IBOutlet var RatingStarView: CosmosView!
    @IBOutlet weak var lblSuggestionHeader: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblRateFeedBack: UILabel!
    @IBOutlet weak var lbRaingText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblComplainID.text = "\(doGetValueLanguage(forKey: "complain_id")) : \(data.complain_no ?? "")".uppercased()
        //lblComplainID.text = "COMPLAINT ID : "+data.complain_no
        doneButtonOnKeyboard(textField: tvFeedback)
        RatingStarView.settings.fillMode = .full
        RatingStarView.didFinishTouchingCosmos = { rating in
            self.rating = Double(rating)
            
            switch rating {
            case 1:
                self.lbRaingText.text = self.doGetValueLanguage(forKey: "very_bad")
            case 2:
                self.lbRaingText.text = self.doGetValueLanguage(forKey: "need_some_improvement")
            case 3:
                self.lbRaingText.text = self.doGetValueLanguage(forKey: "good")
            case 4:
                self.lbRaingText.text = self.doGetValueLanguage(forKey: "great")
            case 5:
                self.lbRaingText.text = self.doGetValueLanguage(forKey: "awesome")
            default:
                break
            }
        }
        tvFeedback.delegate = self
//        tvFeedback.pla = hint
//        tvFeedback.textColor = UIColor.lightGray
        
        if data.feedbackMsg != ""{
            tvFeedback.text = data.feedbackMsg
           // tvFeedback.textColor = UIColor.black
        }
        
        if data.ratingStar != ""  && data.ratingStar != nil{
            RatingStarView.rating = Double(data.ratingStar!)!
            rating = Double(data.ratingStar!)!
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        lblRateFeedBack.text = doGetValueLanguage(forKey: "rate_feedback_complain")
        lblSuggestionHeader.text = doGetValueLanguage(forKey: "complain_leave_comment")
        btnSubmit.setTitle(doGetValueLanguage(forKey: "submit").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        //hint = doGetValueLanguage(forKey: "type_here")
        tvFeedback.placeholderColor = UIColor.lightGray
        tvFeedback.placeholder = doGetValueLanguage(forKey: "type_here")
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        //             if textView.textColor == UIColor.lightGray {
        //                 textView.text = nil
        //                 textView.textColor = UIColor.black
        //             }
        
//        if textView.text == hint {
//            print("equoal")
//            textView.text = nil
//            textView.textColor = UIColor.black
//        } else {
//            print("not eq")
//        }
        
    }

    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = hint
//            textView.textColor = UIColor.lightGray
//        }
    }
    @IBAction func btnCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        closeView()
    }
    func  closeView() {
        removeFromParent()
        view.removeFromSuperview()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
       
            
//        if tvFeedback.text != "" {
//
//            if  !tvFeedback.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tvFeedback.text != "\n"  && tvFeedback.text != "\n "  && tvFeedback.text != hint  {
//
//            } else {
//                showAlertMessage(title: "", msg: "Enter feedback")
//                return
//            }
//        }
        
        if rating == 0 {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_rate_complaint_with_star"))
            return
        }
        
        doRating()

    }
    
    
    
    func doRating(){
        self.showProgress()
        let params = ["getFeedback":"getFeedback",
                      "feedback_msg":tvFeedback.text!,
                      "complain_id":data.complainID!,
                      "rating_star":String(rating)]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        
                     
                        
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true) {
                                self.context.fetchNewDataOnRefresh()
                            
                            }
                        }
                        

                    }else{
                        self.toast(message: "Please Try Again..!", type: .Faliure)
                    }
                }catch{
                }
            }
        }
    }
}
