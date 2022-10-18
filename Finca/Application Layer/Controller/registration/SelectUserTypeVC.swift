//
//  SelectUserTypeVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class SelectUserTypeVC: BaseVC {
    
    var isUserinsert = true
    @IBOutlet weak var bBack: UIButton!
    var society_id:String!
    var mobileNumber:String!
    var societyDetails : ModelSociety!
    @IBOutlet weak var ivRenter: UIImageView!
    @IBOutlet weak var ivCheckTent: UIImageView!
    @IBOutlet weak var lbTenant: UILabel!
    @IBOutlet weak var viewTenant: UIView!
    
    @IBOutlet weak var ivCheckOwner: UIImageView!
    @IBOutlet weak var iOwner: UIImageView!
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var viewOnwer: UIView!
    var  userType = "0"
    
    @IBOutlet weak var lbType: UILabel!
    
    @IBOutlet weak var bNext: UIButton!
    
    var isAddMoreSociety = false // this flag is only used for language
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(isUserinsert)
        changeButtonImageColor(btn: bBack, image: "back_white", color: ColorConstant.primaryColor)
      
        bNext.setTitle(doGetValueLanguage(forKey: "next"), for: .normal)
        lbTenant.text = doGetValueLanguage(forKey: "tenant")
        lbOwner.text = doGetValueLanguage(forKey: "owner")
        lbType.text = doGetValueLanguage(forKey: "select_type")
          
        selectOwnwer()
        
        
        if isAddMoreSociety {
            bNext.setTitle(doGetValueLanguageForAddMore(forKey: "next"), for: .normal)
            lbTenant.text = doGetValueLanguageForAddMore(forKey: "tenant")
            lbOwner.text = doGetValueLanguageForAddMore(forKey: "owner")
            lbType.text = doGetValueLanguageForAddMore(forKey: "select_type")
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func onClickOwned(_ sender: Any) {
        selectOwnwer()
    }
    @IBAction func onClickRented(_ sender: Any) {
      userType = "1"
        
        ivCheckTent.backgroundColor = .clear
        ivCheckTent.image = UIImage(named: "checked")
        ivCheckTent.setImageColor(color: ColorConstant.colorP)
        ivRenter.setImageColor(color: ColorConstant.colorP)
        lbTenant.textColor = ColorConstant.colorP
        viewTenant.layer.borderColor = ColorConstant.colorP.cgColor
        viewTenant.layer.borderWidth = 1
       
        ivCheckOwner.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        ivCheckOwner.image = nil
        ivCheckOwner.setImageColor(color: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        iOwner.setImageColor(color: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        lbOwner.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        viewOnwer.layer.borderColor = UIColor.clear.cgColor
        viewOnwer.layer.borderWidth = 1
        
    }
    func selectOwnwer() {
         userType = "0"
        ivCheckOwner.backgroundColor = .clear
        ivCheckOwner.image = UIImage(named: "checked")
        ivCheckOwner.setImageColor(color: ColorConstant.colorP)
        iOwner.setImageColor(color: ColorConstant.colorP)
        lbOwner.textColor = ColorConstant.colorP
        viewOnwer.layer.borderColor = ColorConstant.colorP.cgColor
        viewOnwer.layer.borderWidth = 1
        
        ivCheckTent.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        ivCheckTent.image = nil
        ivCheckTent.setImageColor(color: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        ivRenter.setImageColor(color: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        lbTenant.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        viewTenant.layer.borderColor = UIColor.clear.cgColor
        viewTenant.layer.borderWidth = 1
   
    }
   
    @IBAction func tapNext(_ sender: Any) {
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
        
        if !isUserinsert{
            vc.society_id = self.society_id
        }else{
            vc.society_id = societyDetails.society_id!
            vc.societyDetails = self.societyDetails
        }
        
    //    vc.unitModel = unitModel
        vc.userType = userType
        vc.isUserInsert = self.isUserinsert
        vc.isAddMoreSociety = isAddMoreSociety
        //   vc.ownedDataSelectVC = self
        self.view.endEditing(true)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
////        vc.isUserinsert = false
//        vc.userType = userType
//        vc.society_id = society_id
//        vc.mobileNumber = mobileNumber
//        vc.societyDetails = self.societyDetails
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
