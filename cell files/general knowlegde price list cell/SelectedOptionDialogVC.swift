//
//  SelectedOptionDialogVC.swift
//  Finca
//
//  Created by Jay Patel on 08/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol SelectedOptionDialogDelegate {
    func yesButtonClicked(optionName:OptionName! , QuestionIndex : Int!, dialogContext : SelectedOptionDialogVC!)
    
    func noButtonClicked(optionName:OptionName , QuestionIndex : Int, dialogContext : SelectedOptionDialogVC!)
}
enum OptionName : String{
    case A = "1"
    case B = "2"
    case C = "3"
    case D = "4"
}
class SelectedOptionDialogVC: BaseVC {
    
    var context : GeneralKnowledgeGameVC!
//    var arrList = [Question]()
//    var option : String!
//    var isRight: Bool!
//    var isCheck: Bool!
//    var index: Int!
    var delegate : SelectedOptionDialogDelegate!
    var questionIndex : Int!
    var optionName : OptionName!
    
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var lblAreYouSure: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("option is===",option as Any)
        lblAreYouSure.text = doGetValueLanguage(forKey: "are_you_sure")
        lblYes.text = doGetValueLanguage(forKey: "yes")
        lblNo.text = doGetValueLanguage(forKey: "no")
    }
    
    @IBAction func btnYes(_ sender: Any) {
//        if option == arrList[index].currectAnswer{
//            print("right")
//            let storyBoard : UIStoryboard = UIStoryboard(name: "KBG", bundle: nil)
//            let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idGeneralKnowledgeGameVC") as! GeneralKnowledgeGameVC
//            gotoDashboardVC.isCheck = true
//            gotoDashboardVC.isRight = true
//            gotoDashboardVC.index = index + 1
////            gotoDashboardVC.player?.stop()
//            gotoDashboardVC.option = option
////            gotoDashboardVC.newData = "Yes"
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            let nav : UINavigationController = UINavigationController()
//            nav.viewControllers  = [gotoDashboardVC]
//            nav.isNavigationBarHidden = true
//            appdelegate.viewC = gotoDashboardVC
//            appdelegate.window!.rootViewController = nav
//            //                context.isRight = true
//            //                context.isCheck = true
//
//        }else{
//            print("wrong")
//            let storyBoard : UIStoryboard = UIStoryboard(name: "KBG", bundle: nil)
//            let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idGeneralKnowledgeGameVC") as! GeneralKnowledgeGameVC
//            gotoDashboardVC.isCheck = true
//            gotoDashboardVC.isRight = false
//            gotoDashboardVC.player?.stop()
//            gotoDashboardVC.option = option
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            let nav : UINavigationController = UINavigationController()
//            nav.viewControllers  = [gotoDashboardVC]
//            nav.isNavigationBarHidden = true
//            appdelegate.viewC = gotoDashboardVC
//            appdelegate.window!.rootViewController = nav
//        }
//        for item in arrList{
//            if option == item.currectAnswer{
//
//            }else{
//
//            }
//        }
        
        self.delegate.yesButtonClicked(optionName: self.optionName, QuestionIndex: self.questionIndex,dialogContext: self)
    }
    
    @IBAction func btnNo(_ sender: Any) {
        self.delegate.noButtonClicked(optionName: self.optionName, QuestionIndex: self.questionIndex,dialogContext: self)
//        view.removeFromSuperview()
//        removeFromParent()
    }
    
}
