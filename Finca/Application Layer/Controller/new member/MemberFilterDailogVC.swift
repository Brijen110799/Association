//
//  MemberFilterDailogVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 22/06/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import DropDown

protocol OnApplyFilter {
    func onApplyFilter(cityId : String,areaId : String,radius : String ,my_team : String ,get_new_member : String , isApplyFilter : Bool,cityName : String,areaName : String,radiusName : String , showMe : String ,bloodgroup :String)
}
class MemberFilterDailogVC: BaseVC {
    
    @IBOutlet weak var lblbloodtitle: UILabel!
    @IBOutlet weak var lblbloodgroup: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbRadius: UILabel!
    @IBOutlet weak var lbMyTeam: UILabel!
    @IBOutlet weak var lbNewMember: UILabel!
    @IBOutlet weak var lbFilterLabel: UILabel!
    @IBOutlet weak var lbLocationLabel: UILabel!
    @IBOutlet weak var lbSelctCityLabel: UILabel!
    @IBOutlet weak var lbSelctAreaLabel: UILabel!
    @IBOutlet weak var lbSelectRadius: UILabel!
    @IBOutlet weak var lbShowMe: UILabel!
    @IBOutlet weak var bReset: UIButton!
    @IBOutlet weak var bApply: UIButton!
    @IBOutlet weak var viewMyTeam: UIView!
    @IBOutlet weak var viewNewMember: UIView!
    @IBOutlet weak var bTeam: UIButton!
    @IBOutlet weak var bNewMember: UIButton!
    var iscomefrom = ""
    var relationMember = [String]()
    
    
    var bloodGroup = ""
    let dropDown = DropDown()
    var areas = [String]()
    var filterCityId = ""
    var aredId = ""
    var radius = ""
    var my_team = "0"
    var get_new_member = "0"
    
    var showMe = ""
    var cities = [String]()
    var areaDataForFilterModel = [BlockModelMember]()
    var floorsForFilterModel = [FloorModelMember]()
    var areaDataForFilter = [BlockFastMember]()//[BlockModelMember]()//
    var floorsForFilter = [FloorFastMember]()//[FloorModelMember]()//
    var arrFloors = [FloorFastMember]()
    var arrFloorsModel = [FloorModelMember]()
    var onApplyFilter : OnApplyFilter?
    
    var isApplyFilter = false
    var isClickReset  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.relationMember =   ["Select","A","A+","B","B+","AB","AB+","O+","O-"]
        
        
        if doGetValueLanguageArrayString(forKey: "blood_type").count > 0{
            relationMember = doGetValueLanguageArrayString(forKey: "blood_type")
        }

        // Do any additional setup after loading the view.
        lblbloodtitle.text = doGetValueLanguage(forKey: "blood_group")
        lbFilterLabel.text = doGetValueLanguage(forKey: "filter")
        lbLocationLabel.text = doGetValueLanguage(forKey: "location").uppercased()
        lbSelctCityLabel.text = doGetValueLanguage(forKey: "select_city")
        lbSelctAreaLabel.text = doGetValueLanguage(forKey: "select_area")
        lbSelectRadius.text = doGetValueLanguage(forKey: "radius")
        lbShowMe.text = doGetValueLanguage(forKey: "show_me").uppercased()
        bReset.setTitle(doGetValueLanguage(forKey: "reset"), for: .normal)
        bApply.setTitle(doGetValueLanguage(forKey: "apply"), for: .normal)
        lbMyTeam.text = doGetValueLanguage(forKey: "my_team")
        lbNewMember.text = doGetValueLanguage(forKey: "new_members")
        lbCity.text = doGetValueLanguage(forKey: "all_city")
        lbArea.text = doGetValueLanguage(forKey: "all_area")
        lbRadius.text = doGetValueLanguage(forKey: "all")
        lblbloodgroup.text = doGetValueLanguage(forKey: "select")
        bTeam.isSelected = true
        bNewMember.isSelected = true
        
        print(areaDataForFilterModel)
        
        if radius != "" {
            lbRadius.text  = "\(radius) km"
        }
        
        defuleStateLabel(label: lbNewMember, view: viewNewMember)
        defuleStateLabel(label: lbMyTeam, view: viewMyTeam)
       
        
        if   my_team != "0" {
            bTeam.isSelected = false
           
            selectedStateLabel(label: lbMyTeam, view: viewMyTeam)
        }
        
        if   get_new_member != "0" {
            bNewMember.isSelected = false
            selectedStateLabel(label: lbNewMember, view: viewNewMember)
        }
      
        
        
        // for GEO map
        
        if iscomefrom == "geomap"
        {
            for item in areaDataForFilterModel {
                if filterCityId != "" && filterCityId == item.block_id {
                    lbCity.text = item.block_name ?? ""
                    arrFloorsModel = item.floors
                }
            }
            
            for item in arrFloorsModel {
                if aredId != "" && aredId == item.floor_id {
                    lbArea.text = item.floor_name ?? ""
                }
            }
            
            
            
            for (index,_) in self.relationMember.enumerated(){
                if bloodGroup != "" && bloodGroup == relationMember[index] {
                    lblbloodgroup.text = relationMember[index]
                }
            }
            areaDataForFilterModel.insert(BlockModelMember(block_status: "", block_name: doGetValueLanguage(forKey: "all_city"), block_id: "", society_id: ""), at: 0)
            arrFloorsModel.insert(FloorModelMember(floor_name: doGetValueLanguage(forKey: "all_area"), floor_status: "", block_id: "", floor_id: ""), at: 0)
            
        }
        else{
            
            for item in areaDataForFilter {
                if filterCityId != "" && filterCityId == item.block_id {
                    lbCity.text = item.block_name ?? ""
                }
            }
            for itemSub in  floorsForFilter {
                if aredId != "" && aredId == itemSub.floor_id {
                    lbArea.text = itemSub.floor_name
                }
            }
            
            for (index,_) in self.relationMember.enumerated(){
                if bloodGroup != "" && bloodGroup == relationMember[index] {
                    lblbloodgroup.text = relationMember[index]
                }
            }
            
            
            arrFloors = floorsForFilter.filter({$0.block_id == filterCityId})
            
            areaDataForFilter.insert(BlockFastMember(block_id: "", society_id: "", block_name: doGetValueLanguage(forKey: "all_city"), total_population: "", block_status: ""), at: 0)
            arrFloors.insert(FloorFastMember(floor_id: "", block_id: "", floor_name: doGetValueLanguage(forKey: "all_area"), no_of_unit: "", unit_type: "", floor_status: ""), at: 0)
            
        }
        
       
//        for itemSub in  floorsForFilterModel {
//            if aredId != "" && aredId == itemSub.floor_id {
//                lbArea.text = itemSub.floor_name
//            }
//        }
//        arrFloorsModel = floorsForFilterModel.filter({$0.block_id == filterCityId})
        
        
       
        
     
        
//        if  areaDataForFilter.count > 0 {
//            self.cities.append(self.doGetValueLanguage(forKey: "all_city"))
//            for item in areaDataForFilter {
//                if filterCityId != "" && filterCityId == item.block_id {
//                    lbCity.text = item.block_name ?? ""
//
//
//                    if let data =  item.floors {
//                        areas.removeAll()
//                        areas.append(doGetValueLanguage(forKey: "all_area"))
//
//                        if data.count > 0 {
//                            floorsForFilter = item.floors
//                            for itemSub in  data {
//
//                                if aredId != "" && aredId == itemSub.floor_id {
//                                    lbArea.text = itemSub.floor_name
//                                }
//                                areas.append(itemSub.floor_name)
//                            }
//                        }
//                    }
//
//
//                }
//                self.cities.append(item.block_name ?? "")
//            }
//        }
        
     
        
          
    }


    @IBAction func tapCloseFilter(_ sender: Any) {
        removePopView()
       // closeFilter()
    }
  
   private func closeFilter() {
       onApplyFilter?.onApplyFilter(cityId: filterCityId, areaId: aredId, radius: radius,my_team: my_team,get_new_member: get_new_member, isApplyFilter: isApplyFilter , cityName: lbCity.text ?? "" , areaName: lbArea.text ?? "" , radiusName: lbRadius.text ?? "" , showMe: showMe ,bloodgroup:bloodGroup)
    removePopView()
   }

    @IBAction func tapCity(_ sender: Any) {
       
        if iscomefrom == "geomap"
        {
            isClickReset = ""
            dropDown.anchorView = lbCity
            dropDown.dataSource = areaDataForFilterModel.map({$0.block_name})//cities
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                lbCity.text = item
                
                aredId = ""
                lbArea.text = doGetValueLanguage(forKey: "all_area")
                
                arrFloorsModel.removeAll()
               
                if item == doGetValueLanguage(forKey: "all_city") {
                    filterCityId = ""
                } else {
                    filterCityId = areaDataForFilterModel[index].block_id ?? ""

                    arrFloorsModel = areaDataForFilterModel[index].floors
                    arrFloorsModel.insert(FloorModelMember(floor_name: doGetValueLanguage(forKey: "all_area"), floor_status: "", block_id: "", floor_id: ""), at: 0)
    //                floorsForFilter = areaDataForFilter[index-1].floors
    //                if let data =  areaDataForFilter[index-1].floors {
    //
    //                    if data.count > 0 {
    //                        for item in  data {
    //                            areas.append(item.floor_name)
    //                        }
    //                    }
    //                }
                }
               
                
                
            }
            //        dropDown.width = btnDropdownRelation.frame.width
            dropDown.show()
            
        }
        else{
              isClickReset = ""
            
              dropDown.anchorView = lbCity
              dropDown.dataSource = areaDataForFilter.map({$0.block_name})//cities
              dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                  lbCity.text = item
                 
                  
                  aredId = ""
                  lbArea.text = doGetValueLanguage(forKey: "all_area")
                  
                  arrFloors.removeAll()
                 
                  if item == doGetValueLanguage(forKey: "all_city") {
                      filterCityId = ""
                  } else {
                      filterCityId = areaDataForFilter[index].block_id ?? ""

                      arrFloors = floorsForFilter.filter({$0.block_id == filterCityId})
                      arrFloors.insert(FloorFastMember(floor_id: "", block_id: "", floor_name: doGetValueLanguage(forKey: "all_area"), no_of_unit: "", unit_type: "", floor_status: ""), at: 0)
      //                floorsForFilter = areaDataForFilter[index-1].floors
      //                if let data =  areaDataForFilter[index-1].floors {
      //
      //                    if data.count > 0 {
      //                        for item in  data {
      //                            areas.append(item.floor_name)
      //                        }
      //                    }
      //                }
                  }
                 
                  
                  
              }
              //        dropDown.width = btnDropdownRelation.frame.width
              dropDown.show()
            
        }
        
       
        
      
        
        
    }
    @IBAction func tapArea(_ sender: Any) {
        
        if iscomefrom == "geomap"
        {
            isClickReset = ""
    //        if areas.count == 0 {
    //            return
    //        }
            
            dropDown.anchorView = lbArea
            dropDown.dataSource = arrFloorsModel.map({$0.floor_name})//areas
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                lbArea.text = item
                
                
                if item == doGetValueLanguage(forKey: "all_area") {
                    aredId = ""
                } else {
                    aredId = arrFloorsModel[index].floor_id ?? ""
                }
            }
            //        dropDown.width = btnDropdownRelation.frame.width
            dropDown.show()
        }
        else{
            
                dropDown.anchorView = lbArea
                dropDown.dataSource = arrFloors.map({$0.floor_name})//areas
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    lbArea.text = item
                    
                    
                    if item == doGetValueLanguage(forKey: "all_area") {
                        aredId = ""
                    } else {
                        aredId = arrFloors[index].floor_id ?? ""
                    }
                }
                //        dropDown.width = btnDropdownRelation.frame.width
                dropDown.show()
            
        }
        
       
   
        
    }
    
    
    @IBAction func btnbloodAction(_ sender: Any) {
        
        dropDown.anchorView = lblbloodgroup
        dropDown.dataSource = relationMember
        dropDown.width = 100
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblbloodgroup.text = self.dropDown.selectedItem
            if index == 0 {
                bloodGroup = ""
            } else {
                bloodGroup = item
            }
            
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
    }
    @IBAction func tapRadius(_ sender: Any) {
        isClickReset = ""
        dropDown.anchorView = lbRadius
        dropDown.dataSource = [doGetValueLanguage(forKey: "all") ,"40 km","30 km","20 km","10 km"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbRadius.text = item
            
            if item == doGetValueLanguage(forKey: "all") {
                radius = ""
            } else {
                radius = String(item.split(separator: " ")[0])
            }
        }
       
        dropDown.show()
    }
    @IBAction func tapTeam(_ sender: Any) {
        isClickReset = ""
        defuleStateLabel(label: lbNewMember, view: viewNewMember)
       // selectedStateLabel(label: lbMyTeam, view: viewMyTeam)
       // my_team = "1"
        get_new_member = "0"
        bNewMember.isSelected = true
      
        if bTeam.isSelected {
            my_team = "1"
            selectedStateLabel(label: lbMyTeam, view: viewMyTeam)
            bTeam.isSelected = false
            showMe = lbMyTeam.text ?? ""
        } else {
            my_team = "0"
            bTeam.isSelected = true
            defuleStateLabel(label: lbMyTeam, view: viewMyTeam)
            showMe = ""
        }
        
        
    }
    @IBAction func tapNewMember(_ sender: Any) {
        isClickReset = ""
        defuleStateLabel(label: lbMyTeam, view: viewMyTeam)
      //  selectedStateLabel(label: lbNewMember, view: viewNewMember)
        my_team = "0"
       // get_new_member = "1"
        bTeam.isSelected = true
        
        
      
          
        if bNewMember.isSelected {
            bNewMember.isSelected = false
            get_new_member = "1"
            selectedStateLabel(label: lbNewMember, view: viewNewMember)
            showMe = lbNewMember.text ?? ""
        } else {
            bNewMember.isSelected = true
            get_new_member = "0"
            defuleStateLabel(label: lbNewMember, view: viewNewMember)
            showMe = ""
        }
        
        
    }
    @IBAction func tapReset(_ sender: Any) {
        isApplyFilter = false
        filterCityId = ""
        aredId = ""
        radius = ""
        bloodGroup = ""
        my_team = "0"
        get_new_member = "0"
       // doGetMembers(isFirstTime: false, isWithoutFilter: false)
       
        defuleStateLabel(label: lbMyTeam, view: viewMyTeam)
        defuleStateLabel(label: lbNewMember, view: viewNewMember)
        lbCity.text = doGetValueLanguage(forKey: "all_city")
        lbArea.text = doGetValueLanguage(forKey: "all_area")
        lbRadius.text = doGetValueLanguage(forKey: "all")
        lblbloodgroup.text = doGetValueLanguage(forKey: "select")
        isClickReset = "1"
      //  closeFilter()
        
    }
    @IBAction func tapApply(_ sender: Any) {
        isApplyFilter = true
        if isClickReset != "" {
            isApplyFilter = false
        }
        closeFilter()
    }
    
    
    private func defuleStateLabel(label : UILabel,view : UIView) {
        view.layer.cornerRadius =  label.frame.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        view.backgroundColor = .white
        //view.clipsToBounds = true
        label.textColor = ColorConstant.textPrimaryColor
    }
    private func selectedStateLabel(label : UILabel,view : UIView) {
        view.layer.cornerRadius =  view.frame.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = ColorConstant.colorP
       // view.clipsToBounds = true
        label.textColor = .white
    }

  
}
