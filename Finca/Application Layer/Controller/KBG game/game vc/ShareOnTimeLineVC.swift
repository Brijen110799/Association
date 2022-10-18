//
//  ShareOnTimeLineVC.swift
//  Finca
//
//  Created by Silverwing_macmini5 on 24/09/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ShareOnTimeLineVC: BaseVC {

    @IBOutlet weak var WinnerView: UIView!
    @IBOutlet weak var quizeNameView: UIView!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var lblQuizName: UILabel!
     
    @IBOutlet weak var ivWinnerUser: UIImageView!
    @IBOutlet weak var lblPoint: UILabel!
   
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var lblSponsor: UILabel!
    
    @IBOutlet weak var lblUnitNum: UILabel!
    @IBOutlet weak var lblSponserBytitle: UILabel!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    
    var setscreen = false
    var arrlist : Question!
    var pointswon : String!
    var currentDate = UIDatePicker()
    var item : WinnerUser!
    var ResultVC : ResultVC!
    var resultList = [WinnerUser]()
    
    @IBOutlet weak var ivUserProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
             lblUserName.text = doGetLocalDataUser().userFullName!
        lblUnitNum.text = doGetLocalDataUser().blockName + "(" + doGetLocalDataUser().unitName + ")"
        lblSponsor.text = item.kbgGameSponsorName!
        lblCategoryName.text = item.categoryName
        lblQuizName.text = item.kbgGameName
        Utils.setImageFromUrl(imageView: ivUser, urlString: item.sponsorImage, palceHolder: "kbgresult")
        lblSponserBytitle.text = doGetValueLanguage(forKey: "sponser_name")
        lblCategoryTitle.text = doGetValueLanguage(forKey: "category")
    }
    override func viewWillLayoutSubviews() {
//        if setscreen == true{
//            doset()
//        }else{
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.myOrientation = .landscape
//            let value = UIInterfaceOrientation.landscapeRight.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    

    @IBAction func onClickShare(_ sender: Any) {
       
                self.dismiss(animated: false) {

                                
                                self.btnStackView.isHidden = true
                                let nextVC = storyboardConstants.sub.instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
                                let data = self.convertToimg(with: self.shareView)!
                                print(data)
                                nextVC.cardImage = data
                                nextVC.comefromCard = "kbggame"
                                let appDel = UIApplication.shared.delegate as! AppDelegate
                                appDel.myOrientation = .portrait
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                UIView.setAnimationsEnabled(true)
                                self.pushVC(vc: nextVC)
                            }
            }
  
//    func doset(){
//    let appDel = UIApplication.shared.delegate as! AppDelegate
//    appDel.myOrientation = .portrait
//    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//    UIView.setAnimationsEnabled(true)
//    }
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
}

