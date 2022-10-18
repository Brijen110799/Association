//
//  LogoutDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 26/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol LogoutDialogDelegate {
    func btnAllSocietyLogoutClicked()
    
    func btnCurrentSocietyLogoutClicked()
}
class LogoutDialogVC: BaseVC {
    @IBOutlet weak var btnAllSociety: UIButton!
    @IBOutlet weak var btnCurrentSociety: UIButton!
    var delegate : LogoutDialogDelegate!
    var isAllButtonHidden : Bool = false
    @IBOutlet weak var lbMsg: UILabel!
    @IBOutlet weak var bCancel: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnAllSociety.setTitle("\(doGetValueLanguage(forKey: "all_society").uppercased())", for: .normal)
        bCancel.setTitle("\(doGetValueLanguage(forKey: "cancel").uppercased())", for: .normal)
        self.btnCurrentSociety.setTitle("\(doGetValueLanguage(forKey: "current_society").uppercased())", for: .normal)
        lbMsg.text = doGetValueLanguage(forKey: "are_you_sure_you_want_to_logout")
        if isAllButtonHidden{
            self.btnAllSociety.isHidden = true
            self.btnCurrentSociety.setTitle("\(doGetValueLanguage(forKey: "logout").uppercased())", for: .normal)
        }
    }
    
    @IBAction func btnAllSociety(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate.btnAllSocietyLogoutClicked()
        }
    }
    @IBAction func btnCurrentSociety(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate.btnCurrentSocietyLogoutClicked()
        }
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
