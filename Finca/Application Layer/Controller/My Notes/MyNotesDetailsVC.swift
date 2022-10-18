//
//  MyNotesDetailsVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 21/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class MyNotesDetailsVC: BaseVC {
    var notesData : GetNotesModelList!
    
    var strTitle = ""
    var strDescription = ""
    var strNotesDate = ""
    var shareFlag : Bool!
    @IBOutlet weak var lbNoteDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbShareAdmin: UILabel!
    @IBOutlet weak var shareWithAdminView: UIView!
    var isAdminAdd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbTitle.text = strTitle
        self.lbDescription.text =  strDescription
        self.lbNoteDate.text = strNotesDate
        if shareFlag == true{
            shareWithAdminView.isHidden = false
            shareWithAdminView.backgroundColor = ColorConstant.colorPrimarylVeryite
        }else{
            shareWithAdminView.isHidden = true
        }
        
        if isAdminAdd {
            lbShareAdmin.text = doGetValueLanguage(forKey: "added_by_admin")
        }else {
            lbShareAdmin.text = doGetValueLanguage(forKey: "shared_with_admin")
        }
        
    }

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
