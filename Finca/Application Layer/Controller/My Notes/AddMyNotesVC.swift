//
//  AddMyNotesVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 21/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class AddMyNotesVC: BaseVC {
    enum DialogType{
        case Update
        case Add
    }
    var strTitle = ""
    var strDescription = ""
    @IBOutlet weak var lbHeaderTitleBar: UILabel!
    @IBOutlet weak var tfTitle: UITextField!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var switchAdmin: UISwitch!
    
  
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblShareWithAdmin: UILabel!
    var dialogType : DialogType = .Add
    var notesData : GetNotesModelList!
    var editContext : MyNotesVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tfTitle)
        doneButtonOnKeyboard(textField: tvDescription)
       
        lbHeaderTitleBar.text = doGetValueLanguage(forKey: "create_note")
        btnSave.setTitle(doGetValueLanguage(forKey: "save_note").uppercased(), for: .normal)
        tvDescription.placeholder = doGetValueLanguage(forKey: "description")
        tfTitle.placeholder(doGetValueLanguage(forKey: "title"))
        lblShareWithAdmin.text = doGetValueLanguage(forKey: "share_with_admin")
        if self.dialogType == .Update{
            self.lbHeaderTitleBar.text = doGetValueLanguage(forKey: "edit_note")
            self.tfTitle.text = strTitle
            self.tvDescription.text = strDescription
            if notesData.share_with_admin{
                switchAdmin.isOn = true
            }else{
                switchAdmin.isOn = false
            }
            
        }
        
    }
    @objc func switchStateChanged(_ sender:UISwitch){
        if sender.isOn{
//            let defaults = UserDefaults.standard
//            defaults.set("1", forKey: "SwitchOnOff")
            //switch on
            
        }else{
//            let defaults = UserDefaults.standard
//            defaults.set("0", forKey: "SwitchOnOff")
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        doPopBAck()
    }
    
   
    @IBAction func onClickSaveNotes(_ sender: Any) {
        if doValidata(){
            if dialogType == .Add{
                
                doCallAddApi()
            }else if dialogType == .Update{
                
                doCallEditApi()
            }
        }
            
    }
    
    func doValidata()->Bool{
        
        if (tfTitle.text!.isEmptyOrWhitespace()){
            toast(message: doGetValueLanguage(forKey: "please_add_title"), type: .Faliure)
           return false

       }
        if (tvDescription.text!.isEmptyOrWhitespace()){
            toast(message: doGetValueLanguage(forKey: "please_add_description"), type: .Faliure)
        return false
        }
      return true
    }
    func doCallAddApi(){
        
        self.showProgress()

        let params = ["addNote":"addNote",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "note_title":tfTitle.text!,
                      "note_description":tvDescription.text!,
                      "share_with_admin": switchAdmin.isOn ? "1":"0",
                      "language_id":doGetLanguageId()]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.user_notes_controller, parameters: params) { [self] (Data, error) in
            
        
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        print("Add Success")
                        
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
    
    override func onClickDone() {
        doPopBAck()
    }
    
    func doCallEditApi() {
        self.lbHeaderTitleBar.text = doGetValueLanguage(forKey: "edit_note")
        self.dialogType = .Update
        self.showProgress()
        let params = ["editNote":"editNote",
                      "society_id":self.doGetLocalDataUser().societyID!,
                      "user_id":self.doGetLocalDataUser().userID!,
                      "note_id":notesData.note_id!,
                      "note_title":tfTitle.text!,
                      "note_description":tvDescription.text!,                  "share_with_admin":switchAdmin.isOn ? "1":"0",
                      "language_id": self.doGetLanguageId()]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.user_notes_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(GetNotesResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }else{
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
}
