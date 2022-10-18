//
//  DialogCommonFilterVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 28/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit


struct CommonCheckModel : Codable {
    var title : String!
    var id  : String!
}

class DialogCommonFilterVC: BaseVC {

    var type:String!
    var state_id:String!
    var itemCell = "LocationCell"
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bDone: UIButton!
    var listData = [CommonCheckModel]()
    var filterListData = [CommonCheckModel]()
    
    var aboutSelfVC : AboutSelfVC!

    
    var selecteIndex = -1
    var tempSelect = -1
    var selectdTitle = ""
    var index = -1

    
    
    var id = ""
    var selectedtitle = ""
    var dataHandler : ((_ id : String , _ name : String ) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
        
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        
        if type == "AddResouece" {
            tfSearch.placeholder = doGetValueLanguage(forKey: "search_resource")
        }else if type == "EmpType" {
           tfSearch.placeholder = doGetValueLanguage(forKey: "search_employee_type")
        } else if type == "professionCategory"  {
             tfSearch.placeholder = doGetValueLanguage(forKey: "search_profession_type")
        } else {
            tfSearch.placeholder = doGetValueLanguage(forKey: "search_profession_type")
        }
        tfSearch.placeholder = doGetValueLanguage(forKey: "search")
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
              tfSearch.delegate = self
        // Do any additional setup after loading the view.
        
       
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
        bDone.setTitle(doGetValueLanguage(forKey: "done").uppercased(), for: .normal)
        self.filterListData = listData
            
        if filterListData.count == 0 {
              lbNoData.isHidden = false
        } else {
            lbNoData.isHidden = true
        }
        tbvData.reloadData()
    }
 
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return view.endEditing(true)
     }
   
    @objc func textFieldDidChange(textField: UITextField) {
     
           
         filterListData = textField.text!.isEmpty ? listData : listData.filter({ (item:CommonCheckModel) -> Bool in
             
             return item.title.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
         })
        
        if textField.text == "" {
            selecteIndex = tempSelect

        } else {
            selecteIndex = -1

        }
        if filterListData.count == 0 {
            lbNoData.isHidden = false
        } else {
            lbNoData.isHidden = true
        }
         
         tbvData.reloadData()
    
     }
     

     @IBAction func onClickDone(_ sender: Any) {
      //   selectLocationVC.reloadArrays()
        
        if type == "EmpType" {
            aboutSelfVC.empType = selectdTitle
            aboutSelfVC.isReloadData = true
        }  else if type == "professionCategory" {
            aboutSelfVC.lbBusinessType.text = selectdTitle
            aboutSelfVC.categotyID = id
            
            aboutSelfVC.indexForSub = index
            aboutSelfVC.isReloadData = true
        }else if aboutSelfVC != nil {
            aboutSelfVC.lbBusinessSubType.text = selectdTitle
        }
         dataHandler?(id, selectdTitle)
         self.removeFromParent()
         self.view.removeFromSuperview()
     }
    
    
    @IBAction func onClickCancel(_ sender: Any) {
       //  selectLocationVC.reloadArrays()
      
         self.removeFromParent()
         self.view.removeFromSuperview()

     }
}
extension DialogCommonFilterVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return filterListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCell, for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        
         cell.lbTitle.text = filterListData[indexPath.row].title
       
        
        if selectdTitle == filterListData[indexPath.row].title {
            cell.ivImage.image = UIImage(named: "radio-selected")
            cell.ivImage.setImageColor(color: ColorConstant.primaryColor)
        } else {
            cell.ivImage.image = UIImage(named: "radio-blank")
            cell.ivImage.setImageColor(color: ColorConstant.primaryColor)
        }
        
   
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
       
       /* if   self.filterListData[indexPath.row].isSelect {
            self.filterListData[indexPath.row].isSelect = false
        } else {
            self.filterListData[indexPath.row].isSelect = true
        }
        
        for (index , _) {
            
        }*/
        id = filterListData[indexPath.row].id
        
        selectdTitle = filterListData[indexPath.row].title
        tableView.reloadData()
       
        
        /* if type == "AddResouece" {
            self.addResourceVC.empTypeID = filterListData[indexPath.row].id
            self.addResourceVC.lbEmpType.text = filterListData[indexPath.row].title
                  
        }else if type == "EmpType" {
            aboutSelfVC.empType = filterListData[indexPath.row].title
            aboutSelfVC.isReloadData = true
        }  else if type == "professionCategory" {
            aboutSelfVC.lbBusinessType.text = filterListData[indexPath.row].title
            aboutSelfVC.categotyID = filterListData[indexPath.row].id
            
            aboutSelfVC.indexForSub = indexPath.row
            aboutSelfVC.isReloadData = true
        }else {
            aboutSelfVC.lbBusinessSubType.text = filterListData[indexPath.row].title
        }*/
        
      /*  if type == "state" {
            selectedIndex = filterStates[indexPath.row].name
            selectLocationVC.state_id = filterStates[indexPath.row].stateID
            selectLocationVC.state = filterStates[indexPath.row].name
             //selectItemState(index: indexPath.row, isFirstTime: false)
            
        } else if type == "country" {
             selectedIndex = filterCountries[indexPath.row].name
             selectLocationVC.country_id = filterCountries[indexPath.row].countryID
              selectLocationVC.country = filterCountries[indexPath.row].name
        }else if type == "city" {
            selectedIndex = filterCities[indexPath.row].name
             selectLocationVC.city_id = filterCities[indexPath.row].cityID
            selectLocationVC.city = filterCities[indexPath.row].name
        }*/
        self.view.endEditing(true)
        tableView.reloadData()
        
    }
    
  
}
