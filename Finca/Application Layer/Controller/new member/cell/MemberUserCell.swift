//
//  MemberUserCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 07/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
enum TapClickType {
    case call
    case msg
    case location
    case mail
    case itemClick
}
protocol TapMemberClick {
    func tapClickCell(item : UnitFastMember/*UnitModelMember*/ , type : TapClickType)
}
class MemberUserCell: UITableViewCell {

    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var ivCompanticon: UIImageView!
    @IBOutlet weak var lbName: MarqueeLabel!
    
    @IBOutlet weak var lbCompany: UILabel!
    
    @IBOutlet weak var bInfo: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ConLeft: NSLayoutConstraint!
    @IBOutlet weak var ConRight: NSLayoutConstraint!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var bCall: UIButton!
    @IBOutlet weak var bMessage: UIButton!
    @IBOutlet weak var bLocation: UIButton!
    @IBOutlet weak var bFollow: UIButton!
    @IBOutlet weak var bMail: UIButton!
  
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewLine: UIView!
    var isAddGesture  = true
    var tapMemberClick : TapMemberClick?
    var unitModelMember  : UnitFastMember?//UnitModelMember?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.labelSwipedLeft(sender:)))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.labelSwipedLeft(sender:)))
        swipeRight.direction = .right
        
        viewMain.addGestureRecognizer(swipeLeft)
        viewMain.addGestureRecognizer(swipeRight)
        //ConLeft.constant = 8
       //ConRight.constant = 8
        
        setupMarqee(label: lbName)
        //setupMarqee(label: lbCompany)
    }
    func setupMarqee(label : MarqueeLabel) {
        label.type = .continuous
        label.animationCurve = .easeIn
        label.fadeLength = 10.0
        label.leadingBuffer = 0
        label.trailingBuffer = 0
    }
    @objc func labelSwipedLeft(sender: UISwipeGestureRecognizer) {
        if !isAddGesture {
            return
        }
        print("labelSwipedLeft called")
        if sender.direction == .left {
            print("left swipe made")
            ConLeft.constant = 8
            ConRight.constant = 8
            
        }
        if sender.direction == .right {
            print("right swipe made")
            if  ConLeft.constant < 10 {
                ConLeft.constant = viewMain.frame.width - viewMain.frame.width / 4 + 18
                ConRight.constant = -viewMain.frame.width - viewMain.frame.width / 4
            }
          }
       
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onTapCall(_ sender: UIButton) {
        tapMemberClick?.tapClickCell(item: unitModelMember!, type: .call)
    }
    
    @IBAction func onTapMail(sender:UIButton) {
        tapMemberClick?.tapClickCell(item: unitModelMember!, type: .mail)
    }
    @IBAction func onTapLocation(sender:UIButton) {
        tapMemberClick?.tapClickCell(item: unitModelMember!, type: .location)
    }
    
    @IBAction func onTapMessage(sender:UIButton) {
        tapMemberClick?.tapClickCell(item: unitModelMember!, type: .msg)
    }
    
    
}
