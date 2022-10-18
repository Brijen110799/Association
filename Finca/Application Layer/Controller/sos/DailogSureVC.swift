//
//  DailogSureVC.swift
//  Finca
//
//  Created by anjali on 30/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DailogSureVC: UIViewController {
    
    var vc:SOSVC!
    var sosTitle:String!

    @IBOutlet weak var lbTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
lbTitle.text = sosTitle
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickNo(_ sender: Any) {
        vc.isSendSos = false
      removewView()
        
    }
    func removewView() {
        removeFromParent()
        view.removeFromSuperview()
    }
    
    @IBAction func onClickYes(_ sender: Any) {
          vc.isSendSos = true
        removewView()
    }
    
}
