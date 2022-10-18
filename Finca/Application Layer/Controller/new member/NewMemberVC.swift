//
//  NewMemberVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 07/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
import SwiftUI

struct ResponseFastMember: Codable {
    let block : [BlockFastMember]!
    let floor : [FloorFastMember]!
    let units : [UnitFastMember]!
    let message : String!
    let status : String!
}

struct BlockFastMember: Codable {
    let block_id: String!//"30",
    let society_id: String!//"1",
    let block_name: String!//"Ahmedabad",
    let total_population: String!//"1171",
    let block_status: String!//"0"
}

struct FloorFastMember: Codable {
    let floor_id: String!//"150",
    let block_id: String!//"30",
    let floor_name: String!//"Amraiwadi & amd",
    let no_of_unit: String!//"5",
    let unit_type: String!//"101",
    let floor_status: String!//"0"
}

struct UnitFastMember: Codable {
    let unit_id: String!//"675",
    let society_id: String!//"1",
    let block_id: String!//"30",
    let block_name: String!//"Ahmedabad",
    let floor_name: String!//"Amraiwadi & amd",
    let floor_id: String!//"150",
    let unit_name: String!//"Unit675",
    let title: String!//"Ankit",
    let sub_title: String!//"Ankit  Rana",
    let sub_title_icon: String!//"https://dev.myassociation.app/img/user.png",
    let user_first_name: String!//"Ankit",
    let user_last_name: String!//"Rana",
    let user_mobile: String!//"12312312311",
    let user_email: String!//"ankit@silverwingteam.com",
    let public_mobile: String!//"0",
    let unit_status: String!//"1",
    let user_id: String!//"348",
    let user_profile_pic: String!//"https://dev.myassociation.app/img/users/recident_profile/Ankit_1650620733.jpeg",
    let user_full_name: String!//"Ankit  Rana",
    let user_type: String!//"0",
    let user_status: String!//"1",
    let company_name: String!//"ankit",
    let distance: String!//"8211.13 KM",
    let radius_distance: String!//"8211.13"
}

class NewMemberVC: BaseVC , CLLocationManagerDelegate {

    
    @IBOutlet weak var cvArea: UICollectionView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivFilter: UIImageView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    
    let cellItem = "NewMemberCell"
    let cellItemArea = "MemberAreaCell"
    let cellItemMember = "MemberUserCell"
    var  floors = [FloorModelMember]()
    var menuTitle = ""
    var selectIndex = 0
    var areaData = [BlockModelMember]()
    var filterareaData = [BlockModelMember]()
    let dropDown = DropDown()
    var filterCityId = ""
    var areas = [String]()
    var aredId = ""
    var bloodgroup = ""
    private var radius = ""
    private var my_team = "0"
    private var get_new_member = "0"
    var cities = [String]()
    var areaDataForFilter = [BlockModelMember]()
    var  floorsForFilter = [FloorModelMember]()
    let locationManager = CLLocationManager()
    var latPass = ""
    var langPass =  ""
    var isComeFromGeoTag =  ""
    var arrFastBlock = [BlockFastMember]()
    var arrFastFloor = [FloorFastMember]()
    var arrFastUnits = [UnitFastMember]()
    var arrBlockForFilter = [BlockFastMember]()
    var youtubeVideoID = ""
    
    private  var  floorData = [FloorModelMember]()
    private  var  allFloorData = [FloorModelMember]()
    private  var  allUnitData = [UnitModelMember]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocation()
        cvArea.showsHorizontalScrollIndicator = false
        cvArea.showsVerticalScrollIndicator = false
        let inb = UINib(nibName: cellItem, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: cellItem)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        
        let inbMember = UINib(nibName: cellItemMember, bundle: nil)
        tbvData.register(inbMember, forCellReuseIdentifier: cellItemMember)
//        tbvData.sectionHeaderHeight = UITableView.automaticDimension
//        tbvData.estimatedSectionHeaderHeight = 50
       
        
        let inbArea = UINib(nibName: cellItemArea, bundle: nil)
        cvArea.register(inbArea, forCellWithReuseIdentifier: cellItemArea)
        cvArea.delegate = self
        cvArea.dataSource = self
       
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        
       
        lbTitle.text = menuTitle
        
        
        ivFilter.setImageColor(color: ColorConstant.grey_60)
        
//        if let data = UserDefaults.standard.data(forKey: StringConstants.KEY_MEMBER_DATA), let decoded = try? JSONDecoder().decode(ResponseMember.self, from: data){
//            //userLocalData = decoded
//            doSetLocalData(data: decoded, isWithoutFilter: true)
//            doGetMembers(isFirstTime: false, isWithoutFilter: true)
//        } else {
//            doGetMembers(isFirstTime: true, isWithoutFilter: true)
//        }
        
        doGetMembers(isFirstTime: true, isBlockLoad: true,  blockId:doGetLocalDataUser().blockID, floorId:"0", isFilter:"false")
    }

    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    
    
    @IBAction func tapSerach(_ sender: Any) {
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSearchMemberVC")as! SearchMemberVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
  
    }
    
    @IBAction func tapLocation(_ sender: Any) {
        
        if isComeFromGeoTag == "geotag" {
            doPopBAck()
        } else {
            let nextVC =  GeoTagVC()
            nextVC.titleToolbar = doGetValueLanguage(forKey: "location")
            pushVC(vc: nextVC)
        }
       
    }
    
   
    func doGetMembers(isFirstTime : Bool,isBlockLoad : Bool, blockId:String, floorId:String, isFilter:String) {
        showProgress()
//        if isFirstTime {
//            showProgress()
//        }
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        /*let params = ["key":apiKey(),
                      "getMembersNew":"getMembersNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "my_id":doGetLocalDataUser().userID!,
                      "my_team" : my_team,
                      "get_new_member" : get_new_member,
                      "user_latitude" : latPass,
                      "user_longitude" : langPass,
                      "block_id" : filterCityId,
                      "floor_id":aredId]*/
        let params = ["getAllDetailsNew":"getAllDetailsNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "my_id":doGetLocalDataUser().userID!,
                      "language_id":"1",
                      "user_latitude":latPass,
                      "user_longitude":langPass,
                      "block_id":blockId,//doGetLocalDataUser().blockID!,
                      "floor_id":floorId,//doGetLocalDataUser().floorID!,
                      "is_filter":isFilter,
                      "my_team":my_team,
                      "get_new_member":get_new_member,
                      "blood_group":self.bloodgroup,
                      "my_block_id":doGetLocalDataUser().blockID!]
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName:  NetworkAPI.fast_member_list_controller, parameters: params) { (json, error) in
            self.hideProgress()
//            if isFirstTime {
//                self.hideProgress()
//            }
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseFastMember.self, from:json!)
                    
                    if response.status == "200" {
                        print(response)
                        if let blockList = response.block {
                            if isBlockLoad {
                                self.arrBlockForFilter = blockList
                            }
                            if isFirstTime {
                                self.arrFastBlock = blockList
                                self.cvArea.reloadData()
                            }
                        }
                        if let floorList = response.floor {
                            self.arrFastFloor = floorList
                        }
                        if let unitList = response.units {
//                            self.arrFastUnits = unitList
                            self.arrFastUnits.removeAll()
                            if unitList.count > 0 {
                                unitList.forEach{object in
                                    if self.radius != "" {
                                        if (Double(object.radius_distance ?? "0") ?? 0) <=  Double(self.radius) ?? 0 {
                                            self.arrFastUnits.append(object)
                                         }
                                    } else {
                                        self.arrFastUnits = unitList
                                    }
                                }
                                self.tbvData.reloadData()
                                self.viewNoData.isHidden = true
                            }else {
                                self.tbvData.reloadData()
                                self.viewNoData.isHidden = false
                            }
                            
                        }
                        
//                        if isWithoutFilter {
//                            if let encoded = try? JSONEncoder().encode(response) {
//                                UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_MEMBER_DATA)
//                            }
//                        }
//
//
//                        self.doSetLocalData(data: response, isWithoutFilter: isWithoutFilter)
                            
                       
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    /*func doSetLocalData(data : ResponseMember , isWithoutFilter : Bool) {
        var areaDataTemp = [BlockModelMember]()
        
        if let data = data.block {
            if areaDataForFilter.count == 0 {
                areaDataForFilter = data
            }
           
           // self.areaData = data
       
            for (_,item) in data.enumerated() {
                var  floorsTemp = [FloorModelMember]()
                var memberCount = 0
                for (_,subItem) in item.floors.enumerated() {
                    var  units = [UnitModelMember]()
                    
                    
                    
                    for subMember in subItem.units {
                        if radius != "" {
                            if Double(subMember.radius_distance ?? "0") ?? 0 <=  Double(self.radius) ?? 0 {
                                units.append(subMember)
                                memberCount += 1
                            }
                            
                        } else {
                            units.append(subMember)
                            memberCount += 1
                        }
                    }
                    
                    if units.count > 0 {
                        floorsTemp.append(FloorModelMember(floor_name: subItem.floor_name, society_id: subItem.society_id, floor_status: subItem.floor_status, block_id: subItem.block_id, floor_id: subItem.floor_id, units: units, cellH: 0))
                    }
                    
                    
                }
                
                if memberCount > 0 {
                    
                    areaDataTemp.append(BlockModelMember(block_status: item.block_status, block_name: item.block_name, block_id: item.block_id, society_id: item.society_id, isSelect: false, floors: floorsTemp, units: [UnitModelMember](), total_members: "\(memberCount)"))
                }
                
                
            }
            
            
            if areaDataTemp.count > 0 {
                viewNoData.isHidden = true
                if isWithoutFilter {
                    self.areaData = data
                } else {
                    self.areaData = areaDataTemp
                }
                
                self.setDataMember(index: 0)
                self.cvArea.reloadData()
            }else {
                viewNoData.isHidden = false
            }
    }
        
    }
    
    private func setDataMember(index : Int) {
        self.floors = areaData[index].floors ?? []
        DispatchQueue.main.async {
            self.tbvData.reloadData()
        }
        
        if self.floors.count > 0 && floors[0].units.count > 0 {
            viewNoData.isHidden = true
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tbvData.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else{
            viewNoData.isHidden = false
        }
    }*/
    
    @IBAction func tapFilter(_ sender: Any) {
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMessageWithClick(title:  "Turn on your location setting", msg: StringConstants.KEY_STEP_NEXT)
                    
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                   //  For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    self.loadLocation()
                    let nextVC = MemberFilterDailogVC()
                    nextVC.areaDataForFilter = self.arrBlockForFilter //self.arrFastBlock//self.areaDataForFilter
                    nextVC.floorsForFilter = self.arrFastFloor//self.floorsForFilter
                    nextVC.onApplyFilter = self
                    nextVC.filterCityId = self.filterCityId
                    nextVC.aredId = self.aredId
                    nextVC.radius = self.radius
                    nextVC.my_team = self.my_team
                    nextVC.get_new_member = self.get_new_member
                    nextVC.bloodGroup = self.bloodgroup
                    nextVC.view.frame = self.view.frame
                    self.addPopView(vc: nextVC)
                    
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }
       
    }
    
    @IBAction func tapMembers(_ sender: Any) {
        //goToDashBoard(storyboard: mainStoryboard)
    }
    private func defuleStateLabel(label : UILabel) {
        label.layer.cornerRadius =  label.frame.height / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = ColorConstant.grey_40.cgColor
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.textColor = ColorConstant.grey_40
    }
    private func selectedStateLabel(label : UILabel) {
        label.layer.cornerRadius =  label.frame.height / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.backgroundColor = ColorConstant.colorP
        label.clipsToBounds = true
        label.textColor = .white
    }
    func  loadLocation() {
           // Ask for Authorisation from the User.
           self.locationManager.requestAlwaysAuthorization()
           // For use in foreground
           self.locationManager.requestWhenInUseAuthorization()
           
           if CLLocationManager.locationServicesEnabled() {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               locationManager.startUpdatingLocation()
           }
           
       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if (locations.last != nil) {
            
            DispatchQueue.main.async {
               
                self.locationManager.stopUpdatingLocation()
            }
            
            latPass = String(locValue.latitude)
            langPass = String(locValue.longitude)
           
        }
        
        
    }
    override func onClickDone() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    private func doGetBlocks() {
           showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["getAllDetails":"getAllDetails",
                      "society_id":doGetLocalDataUser().societyID ?? ""]
        print("param" , params)
        //  let requrest = AlamofireSingleTon.sharedInstance
        AlamofireSingleTon.sharedInstance.requestPost(serviceName:  ServiceNameConstants.fast_data_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseCommonBlocks.self, from:json!)
                    
                    if response.status == "200" {
                       
                        
                        if let floors = response.floor {
                            self.floors = floors
                        }
                        
                        if let blocks  = response.block {
                            self.areaData = blocks
                            self.areaDataForFilter = blocks
                            for (index,item) in blocks.enumerated() {
                                if item.block_id == self.doGetLocalDataUser().blockID ?? "" {
                                    self.selectIndex = index
                                    self.getMembers(block_id: item.block_id ?? "")
                                    break
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.cvArea.reloadData()
                            }
                        }
                        
                     
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message ?? "")
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    private func getMembers(block_id : String) {
        showProgress()
        let params = ["getUnitMembers":"getUnitMembers",
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "block_id" : block_id]
        print("param" , params)
        AlamofireSingleTon.sharedInstance.requestPost(serviceName:  ServiceNameConstants.fast_data_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseCommonBlocks.self, from:json!)
                    
                    if response.status == "200" {
                        self.floorData.removeAll()
                        
                        if let members = response.units {
                            
                            if members.count > 0 {
                                let  filterFloor = block_id.isEmpty ? self.floors : self.floors.filter({ (item: FloorModelMember) -> Bool in
                                    return item.block_id == block_id
                                })
                                
                                for item in  filterFloor {
                                    var  floorDataMode = item
                                    
                                    let  filterFUnit = item.floor_id.isEmpty ? members : members.filter({ (itemSub: UnitModelMember) -> Bool in
                                        return  itemSub.floor_id == item.floor_id
                                    })
                                    floorDataMode.units = filterFUnit
                                    self.floorData.append(floorDataMode)
                                }
                                
                                DispatchQueue.main.async {
                                    self.tbvData.reloadData()
                                    
                                    if self.floorData.count > 0 {
                                        self.tbvData.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                                    }
                                    
                                }
                                if self.floorData.count > 0 {
                                    self.viewNoData.isHidden = true
                                }else {
                                    self.viewNoData.isHidden = false
                                }
                            }  else {
                                self.viewNoData.isHidden = false
                                self.tbvData.reloadData()
                            }
                        
                        
                        }
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message ?? "")
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    private func doFilterData(block_id : String) {
        self.floorData.removeAll()
        if allFloorData.count > 0 {
            let  filterFloor = block_id.isEmpty ? self.allFloorData : self.allFloorData.filter({ (item: FloorModelMember) -> Bool in
                return item.block_id == block_id
            })
            
            for item in  filterFloor {
                var  floorDataMode = item
                
                let  filterFUnit = item.floor_id.isEmpty ? allUnitData : allUnitData.filter({ (itemSub: UnitModelMember) -> Bool in
                    return  itemSub.floor_id == item.floor_id
                })
                if filterFUnit.count > 0 {
                    floorDataMode.units = filterFUnit
                    self.floorData.append(floorDataMode)
                }
            }
            DispatchQueue.main.async {
                self.tbvData.reloadData()
                
                if self.floorData.count > 0 {
                    self.tbvData.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
            }
            if self.floorData.count > 0 {
                self.viewNoData.isHidden = true
            }else {
                self.viewNoData.isHidden = false
            }
        }
         
    }
}

extension NewMemberVC : UITableViewDataSource , UITableViewDelegate, TapMemberClick {
//    func numberOfSections(in tableView: UITableView) -> Int {
//      return  0//floors.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFastUnits.count//floors[section].units.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMemberCell") as! NewMemberCell
//        let item = floors[section]
//        if floors.count == 1 {
//            cell.viewMain.isHidden = true
//        } else {
//            cell.viewMain.isHidden = false
//        }
//        cell.lbTitle.text = item.floor_name ?? ""
//
//
//
//        return cell
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItemMember, for: indexPath) as! MemberUserCell
//<<<<<<< HEAD
//        cell.viewNoData.isHidden = true
        cell.viewMain.isHidden = false
        let item = arrFastUnits[indexPath.row]//floors[indexPath.section].units[indexPath.row]
//=======
    //    cell.viewNoData.isHidden = true
//        let item = floors[indexPath.section].units[indexPath.row]
//>>>>>>> sub_branch_brijen
        cell.lbName.text = item.title ?? ""
        cell.lbCompany.text = "\(item.sub_title ?? "")"
        cell.ConLeft.constant = 8
        cell.ConRight.constant = 8
        cell.tapMemberClick = self
        cell.unitModelMember = item
        if item.floor_name == "" {
            cell.viewHeader.isHidden = true
        }else{
            cell.viewHeader.isHidden = false
            cell.lblHeaderTitle.text = item.floor_name
        }
//        if item.unit_name == "" {
//            cell.viewLine.isHidden = true
//            cell.viewMain.isHidden = true
//            cell.viewNoData.isHidden = false
//        }
        Utils.setImageFromUrl(imageView: cell.ivCompanticon, urlString: item.sub_title_icon ?? "")
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic ?? "" ,palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        cell.selectionStyle = .none
        
  
        cell.bInfo.isHidden = true
        
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemberDetailsVC()
        vc.user_id = arrFastUnits[indexPath.row].user_id//floors[indexPath.section].units[indexPath.row].user_id ?? ""
        vc.userName = arrFastUnits[indexPath.row].user_full_name ?? ""//floors[indexPath.section].units[indexPath.row].user_full_name ?? ""
        pushVC(vc: vc)
    }
    func tapClickCell(item: UnitFastMember/*UnitModelMember*/, type: TapClickType) {
        if type == .call {
            if let public_mobile = item.public_mobile {
                
                if public_mobile == "1" {
                    self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info,cancelText: "", okText: "OKAY")
                } else {
                    DispatchQueue.main.async {
                        
                        if let user_mobile = item.user_mobile {
                            //doCall(on: user_mobile)
                            let number = user_mobile.replacingOccurrences(of: " ", with: "")
                            if let phoneCallURL = URL(string: "telprompt://\(number)") {
                                
                                let application:UIApplication = UIApplication.shared
                                if (application.canOpenURL(phoneCallURL)) {
                                    if #available(iOS 10.0, *) {
                                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                                    } else {
                                        // Fallback on earlier versio
                                        application.openURL(phoneCallURL as URL)
                                        
                                    }
                                }else{
                                    print("dialer N/A")
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if type == .msg {
            if doGetLocalDataUser().userID ?? "" != item.user_id ?? "" && doGetLocalDataUser().userMobile ?? "" != item.user_mobile ?? ""{
                let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                //  vc.memberDetailModal =  memberArray[indexPath.row]
                vc.user_id = item.user_id ?? ""
                vc.userFullName = item.user_full_name ?? ""
                vc.user_image = item.user_profile_pic  ?? ""
                vc.public_mobile  =  item.public_mobile ?? ""
                vc.mobileNumber =  item.user_mobile ?? ""
                vc.isGateKeeper = false
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
              //  self.toast(message: "Self chat disabled", type: .Information)
            }
            
        }
        
        if type == .location {
            let vc = GeoTagVC()
            vc.other_user_id = item.user_id ?? ""
            vc.other_user_name = item.user_full_name ?? ""
            vc.titleToolbar = item.title//user_full_name ?? ""
            pushVC(vc: vc)
        }
        
        if type == .mail {
            let email = item.user_email ?? ""
            if email != "" {
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } else {
                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "not_available"), style: .Info,cancelText: "", okText: "OKAY")
            }
        }
        
        
        if type == .itemClick {
            let vc = MemberDetailsVC()
            vc.user_id = item.user_id ?? ""
            vc.userName = item.user_full_name ?? ""
            pushVC(vc: vc)
        }
        
    }
 
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if floors.count == 1 {
//            return 24
//        }
//        return UITableView.automaticDimension
//    }
   
    
}

extension NewMemberVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFastBlock.count//areaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItemArea, for: indexPath) as! MemberAreaCell
      //  cell.lbTitle.text = "\(areaData[indexPath.row].block_name.uppercased()) (\(areaData[indexPath.row].floors.count))"
        let objBlock = arrFastBlock[indexPath.row]
        cell.lbTitle.text = "\(objBlock.block_name.uppercased())"//" (\(arrFastBlock[indexPath.row].total_population ?? ""))"
        if objBlock.total_population != "" {
            cell.lbTitle.text?.append(contentsOf: "(\(objBlock.total_population ?? ""))")
        }
        if selectIndex == indexPath.row {
            cell.viewSelector.isHidden = false
            cell.viewSelector.backgroundColor = ColorConstant.colorP
            cell.lbTitle.textColor =  ColorConstant.colorP
        }else {
            cell.viewSelector.isHidden = true
            cell.lbTitle.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = arrFastBlock[indexPath.row].block_name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 40, height: 40)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        doGetMembers(isFirstTime: false, isBlockLoad: false,  blockId:arrFastBlock[indexPath.row].block_id, floorId:"0", isFilter: "false")
//        setDataMember(index: indexPath.row)
        collectionView.reloadData()
    }
    
}
extension NewMemberVC: AppDialogDelegate , OnApplyFilter{
    
    //for filter apply
    func onApplyFilter(cityId: String, areaId: String, radius: String, my_team: String, get_new_member: String , isApplyFilter : Bool,cityName : String,areaName : String,radiusName : String , showMe : String ,bloodgroup :String) {
        self.filterCityId = cityId
        self.aredId = areaId
        self.radius = radius
        self.my_team = my_team
        self.get_new_member = get_new_member
        self.bloodgroup = bloodgroup
        areaData.removeAll()
        floors.removeAll()
        cvArea.reloadData()
        tbvData.reloadData()
        if isApplyFilter {
            ivFilter.setImageColor(color: ColorConstant.colorP)
            viewLocation.isHidden = true
        } else {
            ivFilter.setImageColor(color: ColorConstant.grey_60)
            viewLocation.isHidden = false
        }
        doGetMembers(isFirstTime: true, isBlockLoad: false,  blockId:cityId, floorId:areaId, isFilter: "true")
//        doGetMembers(isFirstTime: false, isWithoutFilter: false)
    }
    
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

struct ResponseCommonBlocks : Codable {
    let message : String? //": "",
    let status : String? //": "200"
    let block : [BlockModelMember]?
    let floor : [FloorModelMember]?
    var units : [UnitModelMember]?
}
