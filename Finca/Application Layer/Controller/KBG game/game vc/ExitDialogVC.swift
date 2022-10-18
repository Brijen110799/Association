//
//  ExitDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 24/06/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol ExitDialogDelegate {
    func btnAgreeClickedOnExit()

    func btnCancelClickedOnExit()
}

class ExitDialogVC: BaseVC {
    @IBOutlet weak var lblQuitGame: UILabel!
    @IBOutlet weak var lblExitGame: UILabel!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    var delegate : ExitDialogDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblQuitGame.text = doGetValueLanguage(forKey: "quit_game")
        lblExitGame.text = doGetValueLanguage(forKey: "exit_the_game")
        lblYes.text = doGetValueLanguage(forKey: "yes")
        lblNo.text = doGetValueLanguage(forKey: "no")
    }

    @IBAction func btnYesClicked(_ sender: UIButton) {
        self.delegate.btnAgreeClickedOnExit()
    }

    @IBAction func btnNoClicked(_ sender: UIButton) {
        self.delegate.btnCancelClickedOnExit()
    }
}
