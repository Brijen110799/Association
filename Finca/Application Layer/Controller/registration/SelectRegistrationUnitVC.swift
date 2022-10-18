//
//  SelectRegistrationUnitVC.swift
//  Finca
//
//  Created by harsh panchal on 26/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class SelectRegistrationUnitVC: BaseVC {
    @IBOutlet weak var Stackvw2: UIStackView!
    @IBOutlet weak var StackVw1: UIStackView!
    var itemcell = "RegistrationUnitSelectionCell"
    @IBOutlet weak var lblBlockName: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    var userType = ""
    var floors = [FloorModel]()
    var blockName = ""
    var selectedBlock : BlockModel!
    var society_id = ""
    var parentControllerContext : OwnedDataSelectVC!
    var societyDetails : ModelSociety!
    var isUserInsert = true
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbAvailable: UILabel!
    @IBOutlet weak var lbTenant: UILabel!
    @IBOutlet weak var lbOnwer: UILabel!
    
    @IBOutlet weak var lbAvailableNew: UILabel!
    @IBOutlet weak var lbTenantNew: UILabel!
    var isAddMoreSociety = false // this flag is only used for language
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        tbvData.delegate = self
        tbvData.dataSource = self
        lblBlockName.text = blockName
        tbvData.setNeedsLayout()
        tbvData.layoutIfNeeded()
        tbvData.reloadData()
        if isUserInsert == true
        {
            StackVw1.isHidden = true
            Stackvw2.isHidden = false
            lbTenant.text = doGetValueLanguage(forKey: "tenant")
            lbOnwer.text = doGetValueLanguage(forKey: "owner")
            lbAvailable.text = doGetValueLanguage(forKey: "available")
            
            if isAddMoreSociety {
                lbTenant.text = doGetValueLanguageForAddMore(forKey: "tenant")
                lbOnwer.text = doGetValueLanguageForAddMore(forKey: "owner")
                lbAvailable.text = doGetValueLanguageForAddMore(forKey: "available")
            }
        }else
        {
            Stackvw2.isHidden = true
            StackVw1.isHidden = false
            lbTenantNew.text = doGetValueLanguage(forKey: "occupied")
            lbAvailableNew.text = doGetValueLanguage(forKey: "available")
            if isAddMoreSociety {
                lbTenantNew.text = doGetValueLanguageForAddMore(forKey: "occupied")
                lbAvailableNew.text = doGetValueLanguageForAddMore(forKey: "available")
            }
        }
        lbTitle.text = "\(doGetValueLanguage(forKey: "select")) \(doGetValueLanguage(forKey: "block"))"
        
        if isAddMoreSociety {
            lbTitle.text = "\(doGetValueLanguageForAddMore(forKey: "select")) \(doGetValueLanguageForAddMore(forKey: "block"))"
        }
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SelectRegistrationUnitVC : UITableViewDelegate,UITableViewDataSource,RegistrationUnitSelectionCellDelegate{
    
    func didClickUnitCell(indexPath: IndexPath!, SelectedUnit: UnitModel!) {
       
    if userType == "0" && isUserInsert == false {
        
        if SelectedUnit.unit_status == "0"{
            print("unit Name =",SelectedUnit.unit_name!)
            print("\n unit id =",SelectedUnit.unit_id!)
            
            let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
            vc.societyDetails = societyDetails
            vc.userType = userType
            vc.selectedBlock = selectedBlock
            vc.StrUnitname = SelectedUnit.unit_name!
            vc.society_id  = society_id
            vc.unitModel = SelectedUnit
            vc.society_id  = society_id
            vc.isUserinsert = self.isUserInsert
            vc.StrCheckAddMember = "1"
            vc.isAddMoreSociety =  isAddMoreSociety
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if SelectedUnit.unit_status == "1" {
            
        }else if SelectedUnit.unit_status == "4" {
            
            let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
            vc.societyDetails = societyDetails
            vc.userType = userType
            vc.selectedBlock = selectedBlock
            vc.StrUnitname = SelectedUnit.unit_name!
            vc.society_id  = society_id
            vc.unitModel = SelectedUnit
            vc.society_id  = society_id
            vc.isUserinsert = self.isUserInsert
            vc.StrCheckAddMember = "1"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }else if userType == "0" && isUserInsert == true {
        
            if SelectedUnit.unit_status == "0"{
                print("unit Name =",SelectedUnit.unit_name!)
                print("\n unit id =",SelectedUnit.unit_id!)
                
                let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
                vc.societyDetails = societyDetails
                vc.userType = userType
                vc.selectedBlock = selectedBlock
                vc.StrUnitname = SelectedUnit.unit_name!
                vc.society_id  = society_id
                vc.unitModel = SelectedUnit
                vc.society_id  = society_id
                vc.isUserinsert = self.isUserInsert
                vc.StrStatus = "0"
                vc.StrCheckAddMember = "1"
                vc.isAddMoreSociety =  isAddMoreSociety
            self.navigationController?.pushViewController(vc, animated: true)
                
            }else if SelectedUnit.unit_status == "1" {
                
              
                    let alert = UIAlertController(title: "", message: "Do you want to register as family account?",         preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { _ in
                           //Cancel Action
                       }))
                       alert.addAction(UIAlertAction(title: "YES",
                                                     style: UIAlertAction.Style.default,
                                                     handler: {(_: UIAlertAction!) in
                                                        
                                print("unit Name =",SelectedUnit.unit_name!)
                                print("\n unit id =",SelectedUnit.unit_id!)
                                                        
                                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
                                vc.societyDetails = self.societyDetails
                                vc.userType = self.userType
                                vc.selectedBlock = self.selectedBlock
                                vc.StrUnitname = SelectedUnit.unit_name!
                                vc.society_id  = self.society_id
                                vc.unitModel = SelectedUnit
                                vc.society_id  = self.society_id
                                vc.isUserinsert = self.isUserInsert
                                vc.StrStatus = "1"
                                vc.isAddMoreSociety =  self.isAddMoreSociety
                                self.navigationController?.pushViewController(vc, animated: true)
                                                       
                       }))
                       self.present(alert, animated: true, completion: nil)
                
                
                   }else if SelectedUnit.unit_status == "4"
                   {
                    
                    let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
                    vc.societyDetails = societyDetails
                    vc.userType = userType
                    vc.selectedBlock = selectedBlock
                    vc.StrUnitname = SelectedUnit.unit_name!
                    vc.society_id  = society_id
                    vc.unitModel = SelectedUnit
                    vc.society_id  = society_id
                    vc.isUserinsert = self.isUserInsert
                    vc.StrStatus = "0"
                    vc.StrCheckAddMember = "1"
                    vc.isAddMoreSociety =  isAddMoreSociety
                    self.navigationController?.pushViewController(vc, animated: true)
                   }
                   else if SelectedUnit.unit_status == "3"
                   {
                    
                    
                    
                          let alert = UIAlertController(title: "", message: "Do you want to register as owner family account?",         preferredStyle: UIAlertController.Style.alert)

                          alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { _ in
                                 //Cancel Action
                             }))
                             alert.addAction(UIAlertAction(title: "YES",
                                                           style: UIAlertAction.Style.default,
                                                           handler: {(_: UIAlertAction!) in
                                                              
                                      print("unit Name =",SelectedUnit.unit_name!)
                                      print("\n unit id =",SelectedUnit.unit_id!)
                                                              
                                      let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
                                    vc.societyDetails = self.societyDetails
                                  //  vc.userType = self.userType
                                    vc.selectedBlock = self.selectedBlock
                                    vc.StrUnitname = SelectedUnit.unit_name!
                                    vc.society_id  = self.society_id
                                    vc.unitModel = SelectedUnit
                                    vc.society_id  = self.society_id
                                    vc.isUserinsert = self.isUserInsert
                                    vc.StrStatus = "1"
                                    vc.StrCheckAddMember = "0"
                                    vc.userType = "0"
                                    vc.isAddMoreSociety =  self.isAddMoreSociety
                                    self.navigationController?.pushViewController(vc, animated: true)
                                                             
                             }))
                             self.present(alert, animated: true, completion: nil)
             
                   }
      
    }
    else if userType == "1" && isUserInsert == true {
        
        if SelectedUnit.unit_status == "4"
        {

            let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
            vc.societyDetails = societyDetails
            vc.userType = userType
            vc.selectedBlock = selectedBlock
            vc.StrUnitname = SelectedUnit.unit_name!
            vc.society_id  = society_id
            vc.unitModel = SelectedUnit
            vc.society_id  = society_id
            vc.isUserinsert = self.isUserInsert
            vc.StrStatus = "0"
            vc.StrCheckAddMember = "1"
            vc.isAddMoreSociety =  isAddMoreSociety
            self.navigationController?.pushViewController(vc, animated: true)
            //  ADD tenant
        }else if SelectedUnit.unit_status == "1" && userType == "1"
        {
            
            let alert = UIAlertController(title: "", message: "Do you want to register as tenant account?",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { _ in
                   //Cancel Action
               }))
               alert.addAction(UIAlertAction(title: "YES",
                                             style: UIAlertAction.Style.default,
                                             handler: {(_: UIAlertAction!) in
                                                
                        print("unit Name =",SelectedUnit.unit_name!)
                        print("\n unit id =",SelectedUnit.unit_id!)
                                                
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddTenantVC") as! AddTenantVC
                                                
                        vc.societyDetails = self.societyDetails
                        vc.userType = "1"
                        vc.selectedBlock = self.selectedBlock
                        vc.StrUnitname = SelectedUnit.unit_name!
                        vc.society_name = self.societyDetails.society_name
                        vc.UnitId = SelectedUnit.unit_id
                        vc.society_id  = self.societyDetails.society_id
                        vc.FloorId = SelectedUnit.floor_id
                        vc.BlockId = self.selectedBlock.block_id
                        self.navigationController?.pushViewController(vc, animated: true)
                                               
               }))
               self.present(alert, animated: true, completion: nil)
            
            
        }else if SelectedUnit.unit_status == "3"
        {
            
            let alert = UIAlertController(title: "", message: "Do you want to register as family account?",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { _ in
                   //Cancel Action
               }))
               alert.addAction(UIAlertAction(title: "YES",
                                             style: UIAlertAction.Style.default,
                                             handler: {(_: UIAlertAction!) in
                                                
                        print("unit Name =",SelectedUnit.unit_name!)
                        print("\n unit id =",SelectedUnit.unit_id!)
                                                
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
                        vc.societyDetails = self.societyDetails
                        vc.userType = "0"
                        vc.selectedBlock = self.selectedBlock
                        vc.StrUnitname = SelectedUnit.unit_name!
                        vc.society_id  = self.society_id
                        vc.unitModel = SelectedUnit
                        vc.society_id  = self.society_id
                        vc.isUserinsert = self.isUserInsert
                        vc.StrtenantAddfamily = "1"
                        vc.StrStatus = "1"
                        vc.isAddMoreSociety =  self.isAddMoreSociety
                        self.navigationController?.pushViewController(vc, animated: true)
                                               
               }))
               self.present(alert, animated: true, completion: nil)
            
        }else if SelectedUnit.unit_status == "0"
        {
            let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
            vc.societyDetails = societyDetails
            vc.userType = userType
            vc.selectedBlock = selectedBlock
            vc.StrUnitname = SelectedUnit.unit_name!
            vc.society_id  = society_id
            vc.unitModel = SelectedUnit
            vc.society_id  = society_id
            vc.isUserinsert = self.isUserInsert
            vc.StrStatus = "0"
            vc.StrCheckAddMember = "1"
            vc.isAddMoreSociety = self.isAddMoreSociety
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }else if userType == "1" && isUserInsert == false {
        
        if SelectedUnit.unit_status == "1"
        {
            print("SELECT")
            
        }else if SelectedUnit.unit_status == "3"
        {
            
            print("SELECT")
            
//            let alert = UIAlertController(title: "", message: "Do you want to register as family account?",         preferredStyle: UIAlertController.Style.alert)
//
//            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { _ in
//                   //Cancel Action
//               }))
//               alert.addAction(UIAlertAction(title: "OK",
//                                             style: UIAlertAction.Style.default,
//                                             handler: {(_: UIAlertAction!) in
//
//                        print("unit Name =",SelectedUnit.unit_name!)
//                        print("\n unit id =",SelectedUnit.unit_id!)
//
//                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
//                        vc.societyDetails = self.societyDetails
//                        vc.userType = self.userType
//                        vc.selectedBlock = self.selectedBlock
//                        vc.StrUnitname = SelectedUnit.unit_name!
//                        vc.society_id  = self.society_id
//                        vc.unitModel = SelectedUnit
//                        vc.society_id  = self.society_id
//                        vc.isUserinsert = self.isUserInsert
//
//                        self.navigationController?.pushViewController(vc, animated: true)
//
//               }))
//               self.present(alert, animated: true, completion: nil)
            
            
        }else if SelectedUnit.unit_status == "0"
        {
            let vc  = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
            vc.societyDetails = societyDetails
            vc.userType = userType
            vc.selectedBlock = selectedBlock
            vc.StrUnitname = SelectedUnit.unit_name!
            vc.society_id  = society_id
            vc.unitModel = SelectedUnit
            vc.society_id  = society_id
            vc.isUserinsert = self.isUserInsert
            vc.StrCheckAddMember = "1"
            vc.isAddMoreSociety =  isAddMoreSociety
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("floor Name",floors.count)
        return floors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = floors[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath) as! RegistrationUnitSelectionCell
        
        cell.lblFloorName.text = data.floor_name
        cell.doInitCollectionView(unit: data.units, isUserInsert: isUserInsert)
        cell.setNeedsDisplay()
        cell.delegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = floors[indexPath.row]
        let count = data.units.count
        var height = 0
        if count <= 4{
            height = 45
        }else{
            if count % 4 == 0{
                height =  (count / 4) * 45
            }else{
                //                    print("count = ",count)
                //                    print("heigt",height)
                //                    print("divide / 4 w/o discard",count  / 4)
                //                    print("divide / 4 discarded decimals = ",Int((count  / 4)))
                height = (Int((count  / 4)) * 45) + 45
            }
            print(height)
        }
        
        return CGFloat(height + 60)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewDidLayoutSubviews()
    }
}
