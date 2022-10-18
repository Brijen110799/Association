//
//  MpinDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 18/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class MpinDialogVC: BaseVC {
    @IBOutlet var lblOptBox: [SkyFloatingLabelTextField]!
    @IBOutlet var lblConfirmOptBox: [SkyFloatingLabelTextField]!
    var context : SettingsVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOptBox[0].addTarget(self, action: #selector(self
            .textFieldDidChange(textField:)), for: .editingChanged)
        lblOptBox[1].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblOptBox[2].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblOptBox[3].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblOptBox[0].textAlignment = .center
        lblOptBox[1].textAlignment = .center
        lblOptBox[2].textAlignment = .center
        lblOptBox[3].textAlignment = .center
        doneButtonOnKeyboard(textField: lblOptBox[0])
        doneButtonOnKeyboard(textField: lblOptBox[1])
        doneButtonOnKeyboard(textField: lblOptBox[2])
        doneButtonOnKeyboard(textField: lblOptBox[3])

        lblConfirmOptBox[0].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblConfirmOptBox[1].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblConfirmOptBox[2].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblConfirmOptBox[3].addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        lblConfirmOptBox[0].textAlignment = .center
        lblConfirmOptBox[1].textAlignment = .center
        lblConfirmOptBox[2].textAlignment = .center
        lblConfirmOptBox[3].textAlignment = .center
        doneButtonOnKeyboard(textField: lblConfirmOptBox[0])
        doneButtonOnKeyboard(textField: lblConfirmOptBox[1])
        doneButtonOnKeyboard(textField: lblConfirmOptBox[2])
        doneButtonOnKeyboard(textField: lblConfirmOptBox[3])
    }

    @IBAction func btnCancelDialogClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.context.doInitSosMpinSettings()
//            self.context.toast(message: "SOS MPin Removed Successfully!!", type: .Success)
        }
    }
    @IBAction func btnSetMpinClicked(_ sender: UIButton) {
        let string1 = userInputCombineString(arrayOf: lblOptBox)
        let string2 = userInputCombineString(arrayOf: lblConfirmOptBox)
        if string1.count == 4{
            if string2.count == 4{
                if string1 == string2{
                    self.dismiss(animated: true) {
                        UserDefaults.standard.set(string2, forKey: StringConstants.SECURITY_MPIN_VALUE)
                        UserDefaults.standard.set(true, forKey: StringConstants.SECURITY_MPIN_FLAG)
                        self.context.doInitSosMpinSettings()
                        self.context.toast(message: "MPIN SET SUCCESSFULLY!!", type: .Success)

                    }
                }else{
                    self.toast(message: "Confirm pin is not match", type: .Faliure)
                }
            }else{
                self.toast(message: "Confirm pin is not match", type: .Faliure)
            }
        }else{
            self.toast(message: "Please enter 4-digits pin", type: .Faliure)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    func userInputCombineString(arrayOf tf:[UITextField])->String{
        var string = ""
        for field in tf{
            string.append(field.text!)

        }
        return string
    }
    @objc func textFieldDidChange(textField : UITextField)  {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case lblOptBox[0]:
                lblOptBox[1].becomeFirstResponder()

            case lblOptBox[1]:
                lblOptBox[2].becomeFirstResponder()

            case lblOptBox[2]:
                lblOptBox[3].becomeFirstResponder()

            case lblOptBox[3]:
                lblOptBox[3].resignFirstResponder()

            case lblConfirmOptBox[0]:
                lblConfirmOptBox[1].becomeFirstResponder()

            case lblConfirmOptBox[1]:
                lblConfirmOptBox[2].becomeFirstResponder()

            case lblConfirmOptBox[2]:
                lblConfirmOptBox[3].becomeFirstResponder()

            case lblConfirmOptBox[3]:
                lblConfirmOptBox[3].resignFirstResponder()

            default:
                break
            }
        } else {
            switch textField {
            case lblOptBox[3]:
                lblOptBox[2].becomeFirstResponder()

            case lblOptBox[2]:
                lblOptBox[1].becomeFirstResponder()

            case lblOptBox[1]:
                lblOptBox[0].becomeFirstResponder()

            case lblOptBox[0]:
                lblOptBox[0].resignFirstResponder()

            case lblConfirmOptBox[3]:
                lblConfirmOptBox[2].becomeFirstResponder()

            case lblConfirmOptBox[2]:
                lblConfirmOptBox[1].becomeFirstResponder()

            case lblConfirmOptBox[1]:
                lblConfirmOptBox[0].becomeFirstResponder()

            case lblConfirmOptBox[0]:
                lblConfirmOptBox[0].resignFirstResponder()
            default:
                break
            }
        }
    }
}
//if count == 4{
//    let enteredPassword = userInputCombineString(arrayOf: passcode)
//    let savedpassword = UserDefaults.standard.string(forKey: StringConstants.SECURITY_MPIN_VALUE)
//    if enteredPassword == savedpassword{
//        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "idSOSVC") as! SOSVC
//        let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
//        newFrontViewController.isNavigationBarHidden = true
//        nextVC.youtubeVideoID = youtubevideoId
//        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
//    }else{
//        self.doClearAll()
//    }
//}else{
//    count = count + 1
//}

//func userInputCombineString(arrayOf string:[String])->String{
//    var string = ""
//    for field in string{
//        string.append(field)
//
//    }
//    return string
//}
