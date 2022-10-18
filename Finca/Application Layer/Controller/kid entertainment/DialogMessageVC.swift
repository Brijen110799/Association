//
//  DialogMessageVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 27/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class DialogMessageVC: BaseVC {

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lbMessage: UILabel!
    var context: TicketViewVC!
    var msg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOK.setTitle(doGetValueLanguage(forKey: "ok"), for: .normal)
        // Do any additional setup after loading the view.
        
        //let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue-Regular", size: 14)!,
        //                  NSAttributedString.Key.foregroundColor: UIColor.black]
    
       // lbMessage.attributedText = NSAttributedString(string: msg, attributes: attributes)
     //   lbMessage.attributedText = msg.htmlToAttributedString
       
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//        lbMessage.attributedText = NSAttributedString(string:msg,
//                                                             attributes: [.paragraphStyle: paragraph])
//
//        lbMessage.attributedText = NSAttributedString()
//
//        
        lbMessage.attributedText =  msg.htmlToAttributedString
        
    }
    

    @IBAction func onClickOk(_ sender: Any) {
       // context.backPop()
        
        context.doSetScreen2()
            
    }
}
