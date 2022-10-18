//
//  EmailUpdateDialog.swift
//  Finca
//
//  Created by harsh panchal on 04/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol EmailDialogDelegate{
    func UpdateButtonClicked(Update Email:String!,tag:Int!)

    func CancelButtonClicked(tag:Int!)
}
class EmailUpdateDialog: UIViewController,UITextFieldDelegate {
    var tag : Int!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    var delegate : EmailDialogDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if tfEmail.text! == ""{
            self.tfEmail.errorMessage = "Enter Email Address First!!"
        }else{
            self.delegate.UpdateButtonClicked(Update:self.tfEmail.text! , tag: self.tag)
        }
    }

    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.delegate.CancelButtonClicked(tag: self.tag)
        }
    }
}

extension EmailDialogDelegate{
    func CancelButtonClicked(tag : Int!) {

    }
}
