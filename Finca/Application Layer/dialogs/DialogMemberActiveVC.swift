//
//  DialogMemberActiveVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 15/04/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class DialogMemberActiveVC: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func OnClickOkBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
