//
//  BalanceSheetCell.swift
//  Finca
//
//  Created by harsh panchal on 08/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BalanceSheetCell: UITableViewCell {

    @IBOutlet weak var bView: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbMonth: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var viewNew: UIView!
    @IBOutlet weak var viewView: UIView!
    @IBOutlet weak var lbCreateBy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: [ColorConstant.start_balnce_sheet.cgColor, ColorConstant.end_balnce_sheet.cgColor], type: .axial)
//        gradient.cornerRadius = 8
//        gradient.frame = viewView.bounds
//        viewView.layer.addSublayer(gradient)
//
//
//
//        let gradient2 = CAGradientLayer(start: .topLeft, end: .topRight, colors: [ColorConstant.start_balnce_sheet.cgColor, ColorConstant.end_balnce_sheet.cgColor], type: .axial)
//
//        gradient2.cornerRadius = 8
//        gradient2.frame = viewNew.frame
//
//        viewNew.layer.addSublayer(gradient2)
        viewMain.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
        
    }
    
}
extension CAGradientLayer {
    
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}
