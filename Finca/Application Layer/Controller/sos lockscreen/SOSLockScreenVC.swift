//
//  SOSmPinVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 17/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SOSLockScreenVC: BaseVC {
    var passcode = [String]()
    var count = 0
    var youtubevideoId = ""
    @IBOutlet var viewArr: [UIView]!
    
    @IBOutlet var btn: [UIButton]!
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    @IBAction func onClickDelete(_ sender: Any) {
        if count > 0 {
            count = count - 1
            viewArr[count].backgroundColor = UIColor.lightGray
            passcode.removeLast()
            print(passcode)
        }
    }
    
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.goToDashBoard(storyboard: mainStoryboard)
    }
    @IBAction func btnClicked(_ sender: UIButton) {
        if count < 4 {
            viewArr[count].backgroundColor = ColorConstant.primaryColor
            passcode.insert(String(sender.tag), at: count)
            count += 1
            if count == 4{
                let enteredPassword = userInputCombineString(arrayOf: passcode)
                let savedpassword = UserDefaults.standard.string(forKey: StringConstants.SECURITY_MPIN_VALUE)
                print(savedpassword!)
                print(enteredPassword)
                if enteredPassword == savedpassword{
                    let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "idSOSVC") as! SOSVC
                    let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
                    newFrontViewController.isNavigationBarHidden = true
                    nextVC.youtubeVideoID = youtubevideoId
                    revealViewController().pushFrontViewController(newFrontViewController, animated: true)
                }else{
                    self.toast(message: "Mpin Invalid", type: .Faliure)
                    self.doClearAll()
                }
            }
            print(passcode)
        }
    }
    func doClearAll(){
        if count == 4 {
            for item in viewArr{
                item.backgroundColor = UIColor.lightGray
                count = count - 1
                passcode.removeLast()
            }
        }
    }
    func userInputCombineString(arrayOf stringArr:[String])->String{
        var string = ""
        for field in stringArr{
            string.append(field)
        }
        print("combine string",string)
        return string
    }
    
}
