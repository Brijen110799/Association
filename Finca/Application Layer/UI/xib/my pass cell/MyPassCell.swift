//
//  MyPassCell.swift
//  bnievents
//
//  Created by harsh panchal on 03/09/19.
//  Copyright © 2019 Guest User. All rights reserved.
//

import UIKit
protocol EntryPassDelegate {
    func btnSharePassClicked(at indexPath : IndexPath)
}
class MyPassCell: UITableViewCell {
    
    @IBOutlet weak var lbltitleDate:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lbltitleTicketnumber:UILabel!
    @IBOutlet weak var lblTicketnumber:UILabel!
    @IBOutlet weak var lblMemberpass:UILabel!

    @IBOutlet weak var viewTopView: UIView!
    @IBOutlet weak var viewMain: UIView!
   // @IBOutlet weak var lblEventTime: UILabel!
    @IBOutlet weak var lblpassType: UILabel!
   // @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
//    @IBOutlet weak var viewTop: UIView!
//    @IBOutlet weak var viewBottom: UIView!
//    @IBOutlet weak var lblpassDate: UILabel!
//    @IBOutlet weak var lblTicketNumber: UILabel!
    @IBOutlet weak var imgVerifiedQR: UIImageView!
    @IBOutlet weak var imgQRImage: UIImageView!
//    @IBOutlet weak var webView: UIView!
    
     var gradient : CAGradientLayer!
    var delegate : EntryPassDelegate!
    var indexPath : IndexPath!
    @IBOutlet weak var btnShareClicked: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.masksToBounds = true
        viewMain.layer.cornerRadius = 14
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addGradient(viewMain:UIView!,color:[CGColor]){
        gradient = CAGradientLayer()
        gradient.frame = viewMain.frame
        gradient.colors = color
        //        gradient.startPoint = CGPoint(x: 0, y: 1)
        //        gradient.startPoint = CGPoint(x: 1, y: 0)
        viewMain.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction func btnSharePassClicked(_ sender: UIButton) {
        self.delegate.btnSharePassClicked(at: self.indexPath)
    }
}
