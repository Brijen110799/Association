//
//  FloorMemberCell.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class FloorMemberCell: UICollectionViewCell {
   
    @IBOutlet weak var lbTitle: UILabel!
     @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var lbCountNoti: UILabel!
    
    @IBOutlet weak var viewMain: RadialGradientSqureView!
  
    @IBOutlet weak var viewAvilabe: RadialGradientSqureView!
    @IBOutlet weak var viewOnwer: UIView!
    @IBOutlet weak var viewDefulter: RadialGradientSqureView!
    @IBOutlet weak var viewRent: RadialGradientSqureView!
    @IBOutlet weak var viewClose: RadialGradientSqureView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewNotification.isHidden = true
       
        viewOnwer.isHidden = true
        viewAvilabe.isHidden = true
        viewDefulter.isHidden = true
        viewRent.isHidden = true
        viewClose.isHidden  = true
        
     }
    
    
    func setBackUnit(unit_status : String , is_defaulter : String , user_type : String ) {
       
        if is_defaulter != ""  &&  is_defaulter == "1" {

            lbTitle.backgroundColor = ColorConstant.colorDefaulter
            lbTitle.textColor = .white
            lbName.textColor = ColorConstant.colorDefaulter
            lbName.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9568627451, blue: 0.9803921569, alpha: 1)
            
        } else {
            if unit_status == "0" {
                //avilable
//                viewOnwer.isHidden = true
//                viewAvilabe.isHidden = false
//                viewDefulter.isHidden = true
//                viewRent.isHidden = true
//                viewClose.isHidden  = true
//                lbTitle.textColor = .black
                lbTitle.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
                lbTitle.textColor = .white
                lbName.textColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
                lbName.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 0.1038366866)
                
            } else if unit_status == "1" {
                // onwer
//                viewOnwer.isHidden = false
//                viewAvilabe.isHidden = true
//                viewDefulter.isHidden = true
//                viewRent.isHidden = true
//                viewClose.isHidden  = true
//                lbTitle.textColor = .black
                lbTitle.backgroundColor = ColorConstant.colorP
                lbTitle.textColor = .white
                lbName.textColor = ColorConstant.colorP
                lbName.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.2235294118, blue: 0.4549019608, alpha: 0.1)
                
            } else if unit_status == "2" {
                // defuler  instead of check owner or tenant
                if user_type == "0" {
//                    viewOnwer.isHidden = false
//                    viewAvilabe.isHidden = true
//                    viewDefulter.isHidden = true
//                    viewRent.isHidden = true
//                    viewClose.isHidden  = true
//                    lbTitle.textColor = .black
                    lbTitle.backgroundColor = ColorConstant.colorP
                    lbTitle.textColor = .white
                    lbName.textColor = ColorConstant.colorP
                    lbName.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.2235294118, blue: 0.4549019608, alpha: 0.1)
                    
                } else if user_type == "1" {
//                    viewOnwer.isHidden = true
//                    viewAvilabe.isHidden = true
//                    viewDefulter.isHidden = true
//                    viewRent.isHidden = false
//                    viewClose.isHidden  = true
//                    lbTitle.textColor = .black
                    
                    lbTitle.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 1)
                    lbTitle.textColor = .white
                    lbName.textColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 1)
                    lbName.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 0.1)
                    
                } else {
//                    viewOnwer.isHidden = true
//                    viewAvilabe.isHidden = true
//                    viewDefulter.isHidden = false
//                    viewRent.isHidden = true
//                    viewClose.isHidden  = true
//                    lbTitle.textColor = .white
                   
                    lbTitle.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    lbTitle.textColor = .white
                    lbName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    lbName.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
                    
                }
                
            }else if unit_status == "3" {
                // rent
//                viewOnwer.isHidden = true
//                viewAvilabe.isHidden = true
//                viewDefulter.isHidden = true
//                viewRent.isHidden = false
//                viewClose.isHidden  = true
//                lbTitle.textColor = .black
                lbTitle.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 1)
                lbTitle.textColor = .white
                lbName.textColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 1)
                lbName.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2862745098, blue: 0.1254901961, alpha: 0.1)
                
            } else if unit_status == "5" {
                // close
//                viewOnwer.isHidden = true
//                viewAvilabe.isHidden = true
//                viewDefulter.isHidden = true
//                viewRent.isHidden = true
//                viewClose.isHidden  = false
//                lbTitle.textColor = .white
                lbTitle.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.5019607843, blue: 0.2431372549, alpha: 1)
                lbTitle.textColor = .white
                lbName.textColor = #colorLiteral(red: 0.7725490196, green: 0.5019607843, blue: 0.2431372549, alpha: 1)
                lbName.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.5019607843, blue: 0.2431372549, alpha: 0.1)
                
                
            } else {
//                viewOnwer.isHidden = true
//                viewAvilabe.isHidden = false
//                viewDefulter.isHidden = true
//                viewRent.isHidden = true
//                viewClose.isHidden  = true
//                lbTitle.textColor = .black
                
                lbTitle.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
                lbTitle.textColor = .white
                lbName.textColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
                lbName.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 0.1038366866)
            }
            
            
            
        }
        
        
        
        
    }
    

}
/*else if unit_status == "4" {
    // pendeing
    viewOnwer.isHidden = true
    viewAvilabe.isHidden = false
    viewDefulter.isHidden = true
    viewRent.isHidden = true
     viewClose.isHidden  = true
    //cell.viewMain.layer.backgroundColor = ColorConstant.colorEmpty.cgColor
//    cell.viewMain.InsideColor = ColorConstant.startPending
  //  cell.viewMain.OutsideColor = ColorConstant.endPending
     lbTitle.textColor = .black
}*/
