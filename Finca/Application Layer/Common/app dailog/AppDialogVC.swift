//
//  AppDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 02/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol AppDialogDelegate{
    /// app dialog agree button action
    func btnAgreeClicked(dialogType : DialogStyle,tag : Int)
    /// app dialog cancel button action
    func btnCancelClicked()
}

extension AppDialogDelegate{
    func btnCancelClicked(){
        
    }
}

class AppDialogVC: BaseVC {
    var delegate : AppDialogDelegate!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDialogMessage: UILabel!
    @IBOutlet weak var lblDialogTitle: UILabel!
    @IBOutlet weak var imgDialog: UIImageView!
    @IBOutlet weak var btnAgree: UIButton!
   @IBOutlet weak var btnCancel: UIButton!
    var dialogTitle = ""
    var dialogMessage = ""
    var dialogImage : UIImage!
    var bgColor : UIColor!
    var buttonTitle = ""
    var dialogType : DialogStyle!
    var tag = 0
    var buttonTitleCancel = "CANCEL"
    var isTintColor = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        lblDialogTitle.text = dialogTitle
        lblDialogMessage.text = dialogMessage
        imgDialog.image = dialogImage
        viewBackground.backgroundColor = bgColor
        if isTintColor == "" {
            imgDialog.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            imgDialog.image = imgDialog.image?.withRenderingMode(.alwaysTemplate)
        }
        btnAgree.setTitle(buttonTitle, for: .normal)
        btnCancel.setTitle(buttonTitleCancel, for: .normal)
        if buttonTitle == "OKAY"{
            btnCancel.isHidden = true
            btnAgree.setTitle(doGetValueLanguage(forKey: "ok").uppercased(), for: .normal)
        }else{
            btnCancel.isHidden = false
        }
        //btnAgree.setTitle(doGetValueLanguage(forKey: "delete"), for: .normal)
        //btnCancel.setTitle(doGetValueLanguage(forKey: "cancel"), for: .normal)
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate.btnCancelClicked()
        }
    }
    
    @IBAction func btnAgreeClicked(_ sender: UIButton) {
        self.delegate.btnAgreeClicked(dialogType: self.dialogType!,tag :self.tag)
    }
    
    func setButtonCancelTitle(title : String) {
        print("dddddd")
//        btnCancel.setTitle(title, for: .normal)
    }
}
