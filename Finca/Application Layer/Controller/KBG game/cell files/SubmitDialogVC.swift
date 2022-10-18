//
//  SubmitDialogVC.swift
//  Finca
//
//  Created by Hardik on 5/8/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SubmitDialogVC: BaseVC {

    var context : GeneralKnowledgeGameVC!
    var exitContext : SubmitAndExitPopUPVC!
    var arrlist : Question!
    var pointswon : String!
    var currentDate = UIDatePicker()
    var item : Game!
    var flag = ""
    var setscreen = false
    @IBOutlet weak var ivuser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblPlayeNameTitle: UILabel!
    @IBOutlet weak var lblShareOnTimeLine: UILabel!
    @IBOutlet weak var lblExit: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCategoryTitle.text = doGetValueLanguage(forKey: "category")
        lblPlayeNameTitle.text = doGetValueLanguage(forKey: "player_name")
        lblShareOnTimeLine.text = doGetValueLanguage(forKey: "share_on_timeline")
        lblExit.text = doGetValueLanguage(forKey: "exit")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let currentDate = format.string(from: date)

        lblDate.text = "\(doGetValueLanguage(forKey: "points_won")) \(currentDate)"

        lblUserName.text = doGetLocalDataUser().userFullName! + " \n(" + doGetLocalDataUser().blockName!  + " - " + doGetLocalDataUser().unitName + ")"
        lblGameName.text = item.kbgGameName!
        lblCategory.text = item.categoryName

        lblPoint.text = pointswon

    }
    override func viewWillLayoutSubviews() {
        if setscreen == true{
            doset()
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myOrientation = .landscape
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    func convertToimg(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            return image
        }
        return nil
    }
    func doset(){
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)

    }
    
    @IBAction func onClickNo(_ sender: Any) {
            self.dismiss(animated: true) {
                self.exitContext.dismiss(animated: true) {
                    self.context.navigationController?.popViewController(animated: true)
                }
            }
    }
    @IBAction func onclickShareToTimeLine(_ sender: Any) {


            self.dismiss(animated: false) {

                self.exitContext.dismiss(animated: false) {
                    self.btnStackView.isHidden = true
                    let nextVC = storyboardConstants.sub.instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
                    let data = self.convertToimg(with: self.viewimage)!
                    print(data)
                    nextVC.cardImage = data
                    nextVC.comefromCard = "kbggame"
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.myOrientation = .portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UIView.setAnimationsEnabled(true)
                self.context.navigationController?.pushViewController(nextVC, animated: true)
                }
            }


    }
}
