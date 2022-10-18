//
//  ComplainFeedbackDialog.swift
//  Finca
//
//  Created by harsh panchal on 15/11/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
class ComplainFeedbackDialog: BaseVC {
    @IBOutlet weak var tvFeedback: UITextView!
    var complainDetails : ComplainModel!
    var context : ComplaintsVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tvFeedback)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
           if self.view.frame.origin.y != 0 {
               self.view.frame.origin.y = 0
           }
       }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if tvFeedback.text == ""{
            self.showAlertMessage(title: "", msg: "Please Write Something!!")
            return
        }
        self.showProgress()
        let params = ["getFeedback":"getFeedback",
                      "feedback_msg":tvFeedback.text!,
                      "complain_id":complainDetails.complainID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.dismiss(animated: true) {
                            self.context.fetchNewDataOnRefresh()
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
