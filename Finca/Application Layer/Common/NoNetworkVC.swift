//
//  NoNetworkVC.swift
//  O Shreeji dental clinic
//
//  Created by anjali on 09/05/19.
//  Copyright © 2019 Silverwing Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class NoNetworkVC: BaseVC {
    @IBOutlet weak var ivImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ivImage.setImageColor(color: UIColor.white)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnetion()
    }
    @IBAction func onClickRetry(_ sender: Any) {
   checkConnetion()
    }
    
    func checkConnetion() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            
            break
            
        case .wifi:
            
            onNetconnected()
        case .wwan:
            onNetconnected()
            
        }
        
    }
    override func onNetconnected(){
        dismiss(animated: true, completion: nil)
    }
}
