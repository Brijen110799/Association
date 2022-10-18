//
//  ComplainDetailCell.swift
//  Finca
//
//  Created by Jay Patel on 07/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class ComplainDetailCell: UITableViewCell {
    @IBOutlet var imgTypeCenter: UIImageView!
    @IBOutlet var viewPolygon: UIView!
       @IBOutlet var viewOfImage: UIView!
    
    @IBOutlet weak var imgplayvideo: UIImageView!
    @IBOutlet var leftView: UIView!
    @IBOutlet var lblDateLeft: UILabel!
    @IBOutlet var lblmsgLeft: UILabel!
    @IBOutlet var heightOfAudio_left: NSLayoutConstraint!
    @IBOutlet weak var ivComplainLeft: UIImageView!
       @IBOutlet  var heightOfImage_Left: NSLayoutConstraint!
     
    @IBOutlet weak var ivImagePlayer: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var heightOfLblStatus: NSLayoutConstraint!
    @IBOutlet var rightView: UIView!
    @IBOutlet var heightOfAudioRight: NSLayoutConstraint!
    @IBOutlet var lblDateRight: UILabel!
    @IBOutlet var lblmsgRight: UILabel!
    
    @IBOutlet weak var ivComplainRight: UIImageView!
    @IBOutlet var heightOfImageRight: NSLayoutConstraint!
      
    
    @IBOutlet weak var lbTotalDuration: UILabel!
    @IBOutlet weak var lbCurrentTime: UILabel!
    
    @IBOutlet weak var bImage: UIButton!
    
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var bAudio: UIButton!
    @IBOutlet weak var viewStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // createShape()
        // Initialization code
        playerSlider.setThumbImage(UIImage(), for: .normal)
        // playerSlider.tha
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func playSound(currentTime : String) {
        lbCurrentTime.text = currentTime
        
    }
    func createShape(){
        let shape = CAShapeLayer()
        viewPolygon.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 2
        shape.lineJoin = CAShapeLayerLineJoin.miter
        shape.fillColor = UIColor(named: "red_500")?.cgColor
        
        let path = UIBezierPath()
        //            print(viewPolygon.frame)
        
        _ = viewPolygon.frame.height/2
        let fullheight = viewPolygon.frame.height
        _ = viewPolygon.frame.width/2
        let fullwidth = viewPolygon.frame.width
        path.move(to: CGPoint(x: 0, y:0 ))
        path.addLine(to: CGPoint(x: 0, y:fullheight))
        //        path.addLine(to: CGPoint(x: halfWidth, y: fullheight))
        //            path.addLine(to: CGPoint(x: fullwidth, y: 0))
        path.addLine(to: CGPoint(x: fullwidth, y: 0))
        path.close()
        shape.path = path.cgPath
        
    }
    
    
}
