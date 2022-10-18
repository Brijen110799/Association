//
//  ReviewServiceProviderDialogVC.swift
//  Finca
//
//  Created by Jay Patel on 12/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Cosmos
class ReviewServiceProviderDialogVC: BaseVC, UITextViewDelegate{
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var tvRating: UITextView!
    @IBOutlet weak var lbRatingStatus: UILabel!
    @IBOutlet weak var lblWriteYourReview: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    var vc: ClickedServiceProviderDetailVC!
    var data:LocalServiceProviderListModel!
        
       var rating = 0
       
       let hint = "Write here"
    override func viewDidLoad() {
        super.viewDidLoad()
        lbRatingStatus.text = ""
        lblWriteYourReview.text = doGetValueLanguage(forKey: "write_your_review")
        doneButtonOnKeyboard(textField: tvRating)
        ratingBar.settings.fillMode = .full 
        btnDone.setTitle(doGetValueLanguage(forKey: "done").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        ratingBar.didFinishTouchingCosmos = { rating in
            self.rating = Int(rating)
            
            print("dd" , rating)
            
            if rating == 1 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "very_bad")
            }else if rating == 2 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "need_some_improvement")
            }else if rating == 3 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "good")
            }else if rating == 4 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "great")
            }else if rating == 5 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "awesome")
            }else if rating == 0 {
                self.lbRatingStatus.text = ""
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tvRating.delegate = self
        tvRating.placeholder = doGetValueLanguage(forKey: "type_here")
        tvRating.placeholderColor = UIColor.lightGray
        
        if data.userPreviousComment ?? "" != "" {
            tvRating.text = data.userPreviousComment ?? ""
            // tvRating.textColor = UIColor.black
        }
        ratingBar.rating = 0
        ratingBar.settings.minTouchRating = 0
        if data.userPreviousRating != ""  && data.userPreviousRating != nil{
            ratingBar.rating = Double(data.userPreviousRating ?? "0") ?? 0
            
            let rating = Double(data.userPreviousRating ?? "0") ?? 0
            self.rating = Int(rating)
            if rating == 1 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "very_bad")
            }else if rating == 2 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "need_some_improvement")
            }else if rating == 3 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "good")
            }else if rating == 4 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "great")
            }else if rating == 5 {
                self.lbRatingStatus.text = self.doGetValueLanguage(forKey: "awesome")
            }else if rating == 0 {
                self.lbRatingStatus.text = ""
            }
            
        }
      
    }
    func doGiveRatingAPI(){
        showProgress()
        let params = ["addReview":"addReview",
                      "society_id":doGetLocalDataUser().societyID!,
                      "local_service_provider_id":data.serviceProviderUsersID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "rating_point":"\(rating)",
                      "country_code":doGetLocalDataUser().countryCode!,
                      "rating_comment":tvRating.text!]
        let request = AlamofireSingleTon.sharedInstance
        print("params==",params)
        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: json!)
                    if response.status == "200"{
                        self.vc.userRating = Double(self.rating)
                        self.vc.isUpdate = true
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }else{

                    }
                }catch{
                    print("parse error")
                }
            }else{
                    print(error as Any)
            }
        }
    }
    override func onClickDone() {
        closeView()
    }
   
    
    @IBAction func onClickDone(_ sender: Any) {
        
        //closeView()
        if tvRating.text == doGetValueLanguage(forKey: "type_here") {
            //                      tvRating.text = ""
        } else {
            
            if tvRating.text != "" {
                
                if  !tvRating.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tvRating.text != "\n"  && tvRating.text != "\n "  && tvRating.text != doGetValueLanguage(forKey: "type_here")  {
                    
                } else {
                    showAlertMessage(title: "", msg: "Enter feedback")
                    return
                }
            }
            
        }
        
        if rating == 0 {
            showAlertMessage(title: "", msg: "Select rating")
            return
        }
        doGiveRatingAPI()
    }
       @IBAction func onClickCancel(_ sender: Any) {
           closeView()
       }
       func  closeView() {
           removeFromParent()
           view.removeFromSuperview()
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

}

