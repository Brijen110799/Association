//
//  UnitBlockSelectCell.swift
//  Finca
//
//  Created by anjali on 31/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class UnitBlockSelectCell: UICollectionViewCell {
    
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    var units = [UnitModel]()
    var itemCell = "SelectBlockCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceHorizontal = false
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        // Initialization code
    }
    func doSetData(units:[UnitModel],isMember:Bool) {
        
        if units.count > 0 {
            self.units.removeAll()
            cvData.reloadData()
        }
        self.units.append(contentsOf: units)
        cvData.reloadData()
        
        
    }
    
}
extension UnitBlockSelectCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return units.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! SelectBlockCell
        cell.viewMain.layer.cornerRadius = 0.0
        
        if units[indexPath.row].unit_status == "0" {
            //avilable
            cell.viewMain.layer.backgroundColor = ColorConstant.colorAvilable.cgColor
        } else if units[indexPath.row].unit_status == "1" {
            // onwer
            cell.viewMain.layer.backgroundColor = ColorConstant.colorOwner.cgColor
        } else if units[indexPath.row].unit_status == "2" {
            // defaulter
            
            if units[indexPath.row].user_type == "0" {
                cell.viewMain.layer.backgroundColor = ColorConstant.colorOwner.cgColor
            } else  if units[indexPath.row].user_type == "1" {
                cell.viewMain.layer.backgroundColor = ColorConstant.colorRent.cgColor
            } else {
                cell.viewMain.layer.backgroundColor = ColorConstant.colorDefaulter.cgColor
            }
            
        }else if units[indexPath.row].unit_status == "3" {
            // rent
            cell.viewMain.layer.backgroundColor = ColorConstant.colorRent.cgColor
        } else if units[indexPath.row].unit_status == "4" {
            // pendeing
            cell.viewMain.layer.backgroundColor = ColorConstant.colorPending.cgColor
        }else if units[indexPath.row].unit_status == "5" {
            // close
            cell.viewMain.layer.backgroundColor = ColorConstant.colorClose.cgColor
        }
        cell.viewMain.cornerRadius = 6
        cell.lbTitle.text = units[indexPath.row].unit_name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = units[indexPath.row]
        print(data as UnitModel)
        if data.unit_status == "0"{
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "clickFloor"),
                object: nil,
                userInfo: ["data": units[indexPath.row]])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = 140 / 2
        return CGSize(width: yourWidth, height: 60)
    }
    
}
