//
//  NotesCell.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 21/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol NotesListCellDelegate {
    func DeleteButtonClicked(at indexPath : IndexPath)
    func EditButtonClicked(at indexPath: IndexPath)
    func shareButtonClicked(at indexPath: IndexPath)
}
class NotesCell: UITableViewCell {

    @IBOutlet weak var lbNoteDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var mainVIew: UIView!
    
    var delegate : NotesListCellDelegate!
    var indexpath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setThreeCorner(viewMain: mainVIew)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setThreeCorner(viewMain : UIView) {
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    
    @IBAction func onClickShareNote(_ sender: UIButton) {
        self.delegate.shareButtonClicked(at: self.indexpath)
    }
    @IBAction func onClickEditNote(_ sender: UIButton) {
        self.delegate.EditButtonClicked(at: self.indexpath)
        
    }
    
    @IBAction func onClickDeleteNote(_ sender: UIButton) {
        self.delegate.DeleteButtonClicked(at: self.indexpath)
    }
    
}
