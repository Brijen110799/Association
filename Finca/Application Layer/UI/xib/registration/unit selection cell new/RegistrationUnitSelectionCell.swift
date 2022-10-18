//
//  RegistrationUnitSelectionCell.swift
//  Finca
//
//  Created by harsh panchal on 26/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Foundation
protocol RegistrationUnitSelectionCellDelegate {
    func didClickUnitCell(indexPath : IndexPath! , SelectedUnit:UnitModel!)
    
}
class RegistrationUnitSelectionCell: UITableViewCell {
    
    var IsuserInserts:Bool!
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.type = .axial
        return gradient
    }()
    
    var unitList = [UnitModel]()
    var delegate : RegistrationUnitSelectionCellDelegate!
    var indexPath : IndexPath!
    @IBOutlet weak var lblFloorName: UILabel!
    @IBOutlet weak var constraintCvHeight: NSLayoutConstraint!
    @IBOutlet weak var cvData: UICollectionView!
    let itemCell = "UnitRegistrationCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        // Initialization code
    }
    
    func doInitCollectionView(unit:[UnitModel],isUserInsert:Bool){
        self.unitList = unit
        self.cvData.reloadData()
        IsuserInserts = isUserInsert
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.constraintCvHeight.constant = cvData.contentSize.height
    }
}
extension RegistrationUnitSelectionCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("unit count",unitList.count)
        return unitList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = unitList[indexPath.row]
        let cell = cvData.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! UnitRegistrationCell
        cell.lbTitle.text = data.unit_name
//        if data.unit_status == "0" {
//             cell.viewMain.layer.backgroundColor = ColorConstant.colorAvilable.cgColor
//        } else {
//              cell.viewMain.layer.backgroundColor = ColorConstant.red500.cgColor
//        }
        
        cell.setViewAvilabe(status: data.unit_status, isAddMoreUnit:IsuserInserts)
        
        
      /*  if data.unit_status == "0" {
            //avilable
            //            gradientLayer.colors = [#colorLiteral(red: 0.2, green: 0.6823529412, blue: 0.7725490196, alpha: 1),#colorLiteral(red: 0.1411764706, green: 0.8156862745, blue: 0.9411764706, alpha: 1)]
            //            cell.viewMain.layer.addSublayer(gradientLayer)
            cell.viewMain.layer.backgroundColor = ColorConstant.colorAvilable.cgColor
        } else if data.unit_status == "1" {
            // onwer
            cell.viewMain.layer.backgroundColor = ColorConstant.colorOwner.cgColor
        } else if data.unit_status == "2" {
          //  // defaulter
        //    cell.viewMain.layer.backgroundColor = ColorConstant.colorDefaulter.cgColor
           // print(  data.user_type)
             if data.user_type != nil {
                if data.user_type == "0" {
                    cell.viewMain.layer.backgroundColor = ColorConstant.colorOwner.cgColor
                } else  if data.user_type == "1" {
                    cell.viewMain.layer.backgroundColor = ColorConstant.colorRent.cgColor
                } else {
                    cell.viewMain.layer.backgroundColor = ColorConstant.colorDefaulter.cgColor
                }
            }
            
        }else if data.unit_status == "3" {
            // rent
            cell.viewMain.layer.backgroundColor = ColorConstant.colorRent.cgColor
        } else if data.unit_status == "4" {
            // pendeing
            cell.viewMain.layer.backgroundColor = ColorConstant.colorPending.cgColor
        }else if data.unit_status == "5" {
            // close
            cell.viewMain.layer.backgroundColor = ColorConstant.colorClose.cgColor
        }*/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        layoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.cvData.frame.width / 4
        return CGSize(width: width-5, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = unitList[indexPath.row]
        self.delegate.didClickUnitCell(indexPath: self.indexPath, SelectedUnit: data)
    }
}

