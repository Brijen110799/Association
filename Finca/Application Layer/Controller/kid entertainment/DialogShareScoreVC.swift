//
//  DialogShareScoreVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 25/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class DialogShareScoreVC: BaseVC {
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbBlockName: UILabel!
    @IBOutlet weak var lbTopicName: UILabel!
    @IBOutlet weak var lbRules: UILabel!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbPoints: UILabel!
    @IBOutlet weak var lblTopicNameTitle: UILabel!
    @IBOutlet weak var lblRulesClaimTitle: UILabel!
    
    @IBOutlet weak var lblPointsWon: UILabel!
    @IBOutlet weak var btnShareOnTimeLine: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var lbShareOnTimeline: UILabel!
    var ruleName = ""
    var point = ""
    var date = ""
    var topic = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        lbUserName.text =   "\(doGetLocalDataUser().userFullName ?? "")"
         
        lbBlockName.text = "\(doGetLocalDataUser().blockName ?? "")-\(doGetLocalDataUser().floorName ?? "")"
        
        lbRules.text = ruleName
        lbTopicName.text = topic
        lbPoints.text = point
        lbDate.text = date
        lblTopicNameTitle.text = doGetValueLanguage(forKey: "topic_name")
        lblRulesClaimTitle.text = doGetValueLanguage(forKey: "rules_claim")
        lblPointsWon.text = doGetValueLanguage(forKey: "points_won")
        lbShareOnTimeline.text = doGetValueLanguage(forKey: "share_on_timeline")
        //btnNo.setTitle(doGetValueLanguage(forKey: "no"), for: .normal)
    }
    

    @IBAction func onClickShare(_ sender: Any) {
       
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddTimeLineVC")as! AddTimeLineVC
        let data = convertToimg(with: viewMain)!
        nextVC.cardImage = data
        nextVC.comefromCard = "visitingCard"
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func convertToimg(with view: UIView) -> UIImage? {
        view.backgroundColor = UIColor(named: "grey_3")
          UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
          defer { UIGraphicsEndImageContext() }
          if let context = UIGraphicsGetCurrentContext() {
              view.layer.render(in: context)
              let image = UIGraphicsGetImageFromCurrentImageContext()
              
              return image
          }
          return nil
      }
    
    @IBAction func onClickNo(_ sender: Any) {
        view.removeFromSuperview()
        removeFromParent()
    }
}
