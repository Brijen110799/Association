//
//  EditProfessionalDescriptionVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 16/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit

class EditProfessionalDescriptionVC: BaseVC {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var bCancel: UIButton!
    
    @IBOutlet weak var bAdd: UIButton!
    @IBOutlet weak var bottomConstEditView: NSLayoutConstraint!
    
    var decription = ""
    var userProfessionalDetailsVC : UserProfessionalDetailsVC?
    let requrest = AlamofireSingleTon.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        tfDescription.placeholder = doGetValueLanguage(forKey: "enter_here")
        tfDescription.placeholderColor = .gray
        tfDescription.text = decription
       
        lbTitle.text = doGetValueLanguage(forKey: "more_about_profession")
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        bAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func tapBack(_ sender: Any) {
        removePopView()
    }
    

    @IBAction func tapAdd(_ sender: Any) {
        
        
        self.showProgress()
        let params = [
            "setTeamAbout":"setTeamAbout",
            "user_id":doGetLocalDataUser().userID!,
            "society_id":doGetLocalDataUser().societyID!,
            "unit_id":doGetLocalDataUser().unitID!,
            "employment_description" : tfDescription.text ?? ""]
          
        print("param" , params)
        
        requrest.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { (json, error) in
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200"{
                        self.userProfessionalDetailsVC?.updateDescriotion()
                        self.removePopView()
                        
                    }else{
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    @objc  func keyboardWillShow(sender: NSNotification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        if keyboardHeight > 304 {
            bottomConstEditView.constant = keyboardHeight - 22
        } else {
            bottomConstEditView.constant = keyboardHeight + 10
        }
      
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
       // scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        bottomConstEditView.constant = 16
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}
