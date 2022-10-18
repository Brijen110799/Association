//
//  SelectBlockAndRoomVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import CenteredCollectionView

struct BlockResponse : Codable {
    
    let message:String!// "message" : "Get Block success.",
    let status:String! //"status" : "200"
    let block : [BlockModel]!
    let package : [PackageModel]!
    
    let association_type: String? //" : "1",
    let payment_at_registration_time: String? //  "1",
    let membership_joining_proof_required: String? //  "1",
    
     let advocate_code_required: String? //  "1",
     let profile_photo_required: String? //  "1",
     let sanad_date_required: String? //  "1",
     let membership_joining_date_require: String? //  "1",
     let default_company_name: String? //  "GHAA",
     let middle_name_action: String?
     let membership_number_auto_generate: String?
}

struct BlockModel : Codable {
    let block_name:String! //"block_name" : "A",
    let block_id:String! //"block_id" : "65",
    let society_id:String!// "society_id" : "17",
    let block_status:String!// "block_status" : "0"
}


struct FloorResponse : Codable{
    let message:String!// "message" : "Get Block success.",
    let status:String! //"status" : "200"
    let floors:[FloorModel]!
}

struct FloorModel:Codable {
    let floor_name:String! //"floor_name" : "1 Floor",
    let floor_status:String! // "floor_status" : "0",
    let floor_id:String! //"floor_id" : "284",
    let block_id:String! //"block_id" : "65",
    let society_id:String! //"society_id" : "17"
    let units:[UnitModel]!
}
struct UnitModel : Codable {
    let unit_colour: String!
    let user_type : String! //" : "",
    let user_block_id : String! //" : "212",
    let unit_status : String! //" : "0",
    let user_floor_id : String! //" : "935",
    let user_unit_id : String! //" : "4805",
    let unit_name : String! //" : "5012",
    let user_full_name : String! //" : "",
    let user_status : String! //" : "",
    let tenant_view : String! //" : "",
    let public_mobile : String! //" : "",
    let user_id : String! //" : "",
    let is_defaulter : String! //" : "",
    let society_id : String! //" : "75",
    let floor_id : String! //" : "935",
    let unit_id : String! //" : "4805"
}

class SelectBlockAndRoomVC: BaseVC {
   var  userType = ""
    @IBOutlet weak var cvBlock: UICollectionView!
    var society_id:String!
    var societyDetails : ModelSociety!
    @IBOutlet weak var viewFloors: UIView!
    @IBOutlet weak var cvFloors: UICollectionView!
    var blocks = [BlockModel]()
    var floors = [FloorModel]()
    var unitModel : UnitModel!
    var isUserInsert = true // this mean first time come as new register
    
    @IBOutlet weak var lbTitle: UILabel!
    let itemCell = "UnitRegistrationCell"
    let itemCellFloor = "UnitBlockSelectCell"
    
    @IBOutlet weak var lbBlockName: UILabel!
//    var unitModel:UnitModel!
    var blockModel:BlockModel!
    var ownedDataSelectVC:OwnedDataSelectVC!
    var isAddMoreSociety = false // this flag is only used for language
    var country_code = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(isUserInsert)
        cvBlock.delegate = self
        cvBlock.dataSource = self
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvBlock.register(inb, forCellWithReuseIdentifier: itemCell)
        
        
        //        let inbFloor = UINib(nibName: itemCellFloor, bundle: nil)
        //        cvFloors.register(inbFloor, forCellWithReuseIdentifier: itemCellFloor)
        //        viewFloors.isHidden = true
        doGetBlock()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clickFloor(_:)),
                                               name: NSNotification.Name(rawValue: "clickFloor"),object: nil)
        
        lbTitle.text = "\(doGetValueLanguage(forKey: "select")) \(doGetValueLanguage(forKey: "block"))"
        
        if isAddMoreSociety {
            lbTitle.text = "\(doGetValueLanguageForAddMore(forKey: "select")) \(doGetValueLanguageForAddMore(forKey: "block"))"
        }
    }
    
    @objc func clickFloor(_ notification: NSNotification) {
        
        let data =  notification.userInfo?["data"] as? UnitModel
       // print(data?.unit_status)
       // print("hhhhhhhhhhhhhhhhhhhh")
        if data?.unit_status == "0" {
            ownedDataSelectVC.unitModel = data!
            
            ownedDataSelectVC.blockModel = blockModel!
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    func doGetBlock() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getBlocks":"getBlocks",
                      "society_id":society_id!]
        
        let requrest = AlamofireSingleTon.sharedInstance
        if !isUserInsert {
            requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params) { (json, error) in
                self.hideProgress()
                if json != nil {
                    do {
                        
                        let response = try JSONDecoder().decode(BlockResponse.self, from:json!)
                        if response.status == "200" {
                            
                            if response.block.count == 1 {
                                let vc  = NewRegistrationVC()
                                vc.society_id = self.society_id
                                vc.block_id = response.block[0].block_id ?? "0"
                                vc.block_name = response.block[0].block_name ?? "0"
                                vc.country_code = self.country_code
                                vc.isUserInsert = self.isUserInsert
                                vc.societyDetails = self.societyDetails
                                self.navigationController?.pushViewController(vc, animated: true)
                                return
                            }
                            
                            self.blocks = response.block ?? []
                            self.cvBlock.reloadData()
                            
                            
                           
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("block error",error as Any)
                    }
                }
            }
        }else{
            requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params,baseUer: societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
                self.hideProgress()
                if json != nil {
                    do {
                        let response = try JSONDecoder().decode(BlockResponse.self, from:json!)
                        if response.status == "200" {
                            if response.block.count == 1 {
                                let vc  = NewRegistrationVC()
                                vc.society_id = self.society_id
                                vc.block_id = response.block[0].block_id ?? "0"
                                vc.block_name = response.block[0].block_name ?? "0"
                                vc.country_code = self.country_code
                                vc.isUserInsert = self.isUserInsert
                                vc.societyDetails = self.societyDetails
                                self.navigationController?.pushViewController(vc, animated: true)
                                return
                            }
                            self.blocks.append(contentsOf: response.block)
                            self.cvBlock.reloadData()
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("block error",error as Any)
                    }
                }
            }
        }
        
        
    }
    
    func doGetFlorUnit(block_id:String,block_name:String,selectedBlock : BlockModel!) {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //        lbBlockName.text = bloack_name
        let params = ["key":apiKey(),
                      "getFloorandUnit":"getFloorandUnit",
                      "society_id":society_id!,
                      "block_id":block_id]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        if !isUserInsert{
            requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params) { (json, error) in
                self.hideProgress()
                if json != nil {
                   
                    do {
                        let response = try JSONDecoder().decode(FloorResponse.self, from:json!)
                        
                        if response.status == "200" {
                            // lbTitle.text = "Select Unit"
                            //                        self.viewFloors.isHidden = false
                            //                        self.cvBlock.isHidden = true
                            //                        self.floors.append(contentsOf: response.floors)
                            //                        self.cvFloors.reloadData()
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSelectRegistrationUnitVC")as! SelectRegistrationUnitVC
                            
                             vc.isUserInsert = self.isUserInsert
                            vc.society_id = self.society_id
                            vc.floors.append(contentsOf: response.floors)
                            vc.parentControllerContext = self.ownedDataSelectVC
                            vc.blockName = block_name
                            vc.userType = self.userType
                            vc.selectedBlock = selectedBlock
                            self.view.endEditing(true)
                            vc.societyDetails = self.societyDetails
                            vc.isAddMoreSociety = self.isAddMoreSociety
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                        
                    } catch {
                        print("floor error",error as Any)
                    }
                }
            }
        }else{
            requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params,baseUer: societyDetails.sub_domain! + StringConstants.APINEW) { (json, error) in
                
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(FloorResponse.self, from:json!)
                        
                        if response.status == "200" {
                            // lbTitle.text = "Select Unit"
                            //                        self.viewFloors.isHidden = false
                            //                        self.cvBlock.isHidden = true
                            //                        self.floors.append(contentsOf: response.floors)
                            //                        self.cvFloors.reloadData()
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSelectRegistrationUnitVC")as! SelectRegistrationUnitVC
                            
                            vc.isUserInsert = self.isUserInsert
                            vc.society_id = self.society_id
                            vc.floors.append(contentsOf: response.floors)
                            vc.parentControllerContext = self.ownedDataSelectVC
                            vc.blockName = block_name
                            vc.selectedBlock = selectedBlock
                            vc.userType = self.userType
                            vc.societyDetails = self.societyDetails
                            vc.isAddMoreSociety =  self.isAddMoreSociety
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                        
                    } catch {
                        print("floor error",error as Any)
                    }
                }
            }
        }
        
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
}
extension SelectBlockAndRoomVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvFloors {
            return floors.count
        }
        return blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvFloors {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellFloor, for: indexPath) as! UnitBlockSelectCell
            
            cell.lbTitle.text = floors[indexPath.row].floor_name
            cell.doSetData(units: floors[indexPath.row].units, isMember: false)
            // cell.layer.cornerRadius = cell.bounds.height/2
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! UnitRegistrationCell
        cell.lbTitle.text = blocks[indexPath.row].block_name
        cell.lbTitle.textColor = UIColor.white
        setupMarqee(label: cell.lbTitle)
        //cell.addGradient(viewMain: cell.contentView, color: [#colorLiteral(red: 0.7268739343, green: 0.433236897, blue: 0.8259053826, alpha: 1),#colorLiteral(red: 0.4078431373, green: 0.1803921569, blue: 0.4901960784, alpha: 1)])
        //   cell.layer.cornerRadius = cell.bounds.height/2
        // cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvFloors {
            let yourWidth = collectionView.bounds.width
            return CGSize(width: yourWidth-2, height: 180)
        }
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-2, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if collectionView == cvBlock {
//            doGetFlorUnit(block_id: blocks[indexPath.row].block_id,block_name: blocks[indexPath.row].block_name,selectedBlock: blocks[indexPath.row])
//
//            blockModel = blocks[indexPath.row]
//        }
        
        let vc  = NewRegistrationVC()
        vc.society_id = self.society_id
        vc.block_id = blocks[indexPath.row].block_id ?? "0"
        vc.block_name = blocks[indexPath.row].block_name ?? "0"
        vc.country_code = country_code
        vc.isUserInsert = isUserInsert
        vc.societyDetails = societyDetails
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
