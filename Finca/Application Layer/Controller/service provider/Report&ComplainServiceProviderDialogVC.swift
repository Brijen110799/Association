//
//  Report&ComplainServiceProviderDialogVC.swift
//  Finca
//
//  Created by Jay Patel on 12/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class Report_ComplainServiceProviderDialogVC: BaseVC, UITextViewDelegate {
    var data:LocalServiceProviderListModel!
     let hint = "Description"
    
    @IBOutlet var tvRating: UITextView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tvRating)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tvRating.delegate = self
         tvRating.text = doGetValueLanguage(forKey: "description_add_note")
         tvRating.textColor = UIColor.lightGray
        btnSend.setTitle(doGetValueLanguage(forKey: "done").uppercased(), for: .normal)
        btnCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
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
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = doGetValueLanguage(forKey: "description_add_note")
            textView.textColor = UIColor.lightGray
        }
    }
//    @FormUrlEncoded
//    @POST("local_service_provider_controller.php")
//    Single<CommonResponce> addComplainServiceProvider(
//            @Field("addComplain") String addComplain,
//            @Field("society_id") String society_id,
//            @Field("local_service_provider_id") String local_service_provider_id,
//            @Field("user_id") String user_id,
//            @Field("user_name") String user_name,
//            @Field("user_mobile") String user_mobile,
//            @Field("comment") String comment
//    );

    func doAddRating(){
        showProgress()
        let params = ["addComplain":"addComplain",
                      "society_id":doGetLocalDataUser().societyID!,
                      "local_service_provider_id":data.serviceProviderUsersID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "comment":tvRating.text!]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        print("dismiss")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                            self.toast(message: response.message, type: .Information)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                self.removeFromParent()
//                                self.view.removeFromSuperview()
//                            }
//                        }
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                       
                        
                        //self.dismiss(animated: true,completion: nil)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    @IBAction func onClickDone(_ sender: Any) {
         print("Send")
          //closeView()
          
          if tvRating.text != "" && tvRating.text != doGetValueLanguage(forKey: "description_add_note") {
               if  !tvRating.text.trimmingCharacters(in: .whitespaces).isEmpty &&  tvRating.text != "\n"  &&
              tvRating.text != "\n "  && tvRating.text != doGetValueLanguage(forKey: "description_add_note") {
                   doAddRating()
              } else {
                  showAlertMessage(title: "", msg: "Enter the description")
              }
          } else {
             if tvRating.text == doGetValueLanguage(forKey: "description_add_note") {
                   showAlertMessage(title: "", msg: "Enter the description")
             }else if tvRating.text == ""{
                 showAlertMessage(title: "", msg: "Enter the description")
            }
              
             //  doAddRating()
          }
       }
      @IBAction func onClickCancel(_ sender: Any) {
          closeView()
      }
      func  closeView() {
          removeFromParent()
          view.removeFromSuperview()
      }
    override func onClickDone() {
        closeView()
    }
}
