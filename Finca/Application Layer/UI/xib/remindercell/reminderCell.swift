//
//  reminderCell.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 27/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol reminderCellDelegate{
    func DeleteButtonClicked(at indexPath : IndexPath)
    func DoneButtonClicked(at indexPath : IndexPath)
}
class reminderCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var lblReminderTime: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    var delegate : reminderCellDelegate!
    var indexpath : IndexPath!
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var bDone: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setThreeCorner(viewMain: mainView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    
    @IBAction func onClickDeleteReminder(_ sender: UIButton) {
        self.delegate.DeleteButtonClicked(at: self.indexpath)
       
    }
    
    @IBAction func onClickDoneReminder(_ sender: Any) {
        self.delegate.DoneButtonClicked(at: self.indexpath)
        
    }
}
