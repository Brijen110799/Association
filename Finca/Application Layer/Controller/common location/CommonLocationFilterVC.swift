//
//  CommonLocationFilterVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 30/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol OnSelectLocation {
    func onSelectLocation(type:String , id:String,name:String)
    
}
class CommonLocationFilterVC: BaseVC {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tbvData: UITableView!
    var selectedIndex : String!
    var countries = [CountryModel]()
    var filterCountries = [CountryModel]()
    var states = [StateModel]()
    var filterStates = [StateModel]()
    var cities = [CityModel]()
    var filterCities = [CityModel]()
    var selectedRow : Int!
    var selectData = ""
    var type:String!
    var state_id:String!
    var itemCell = "LocationCell"
    var onSelectLocation : OnSelectLocation!
    private var select_country = "Select Country"
    private var select_state = "Select State"
    private var select_city = "Select City"
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
        
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        if type == "state" {
            filterStates = states
        } else if type == "country"  {
            filterCountries = countries
        } else if type == "city" {
            filterCities = cities
            //doFilerCity()
        }
        // hideKeyBoardHideOutSideTouch()
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        
        if doGetValueLanguage(forKey: "select_country") != "" {
            select_country = doGetValueLanguage(forKey: "select_country")
            select_state = doGetValueLanguage(forKey: "select_state")
            select_city = doGetValueLanguage(forKey: "select_city")
        }
        
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        if type == "state" {
            
            filterStates = textField.text!.isEmpty ? states : states.filter({ (item:StateModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            tbvData.reloadData()
        } else if type == "country" {
            filterCountries = textField.text!.isEmpty ? countries : countries.filter({ (item:CountryModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            tbvData.reloadData()
        }else if type == "city" {
            filterCities = textField.text!.isEmpty ? cities : cities.filter({ (item:CityModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            tbvData.reloadData()
        }
        
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        
        if isValidate() {
            if selectedRow != nil{
                
                if type == "state" {
                    
                    onSelectLocation.onSelectLocation(type: type, id: filterStates[selectedRow].stateID, name: filterStates[selectedRow].name)
                    
                    //
                } else if type == "country" {
                    
                    onSelectLocation.onSelectLocation(type: type, id: filterCountries[selectedRow].countryID, name: filterCountries[selectedRow].name)
                    
                }else if type == "city" {
                    //                    selectedIndex = filterCities[selectedRow].name
                    onSelectLocation.onSelectLocation(type: type, id: filterCities[selectedRow].cityID, name: filterCities[selectedRow].name)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private func isValidate() -> Bool {
       var isValide = true
        
        if type == "state" {
            
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_state)
                
            }
        } else if type == "country" {
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_country)
            }
        }else if type == "city" {
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_city)
            }
        }
        
        return isValide
    }

}

extension CommonLocationFilterVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == "state" {
            return  self.filterStates.count
        } else if type == "country"  {
            return self.filterCountries.count
        } else if type == "city" {
            return self.filterCities.count
        }
        
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCell, for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        
        
        if type == "state" {
            if selectedIndex == filterStates[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterStates[indexPath.row].name
            
        } else  if type == "country" {
            if selectedIndex == filterCountries[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCountries[indexPath.row].name
            
        }else  if type == "city" {
            if selectedIndex == filterCities[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCities[indexPath.row].name
            
        }
        cell.ivImage.tintColor = UIColor(named: "ColorPrimary")
        cell.ivImage.image = cell.ivImage.image?.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        if type == "state" {
            selectedIndex = filterStates[indexPath.row].name
            
            //            selectLocationVC.state_id = filterStates[indexPath.row].stateID
            //            selectLocationVC.state = filterStates[indexPath.row].name
            //             //selectItemState(index: indexPath.row, isFirstTime: false)
            //
        } else if type == "country" {
            selectedIndex = filterCountries[indexPath.row].name
            //             selectLocationVC.country_id = filterCountries[indexPath.row].countryID
            //              selectLocationVC.country = filterCountries[indexPath.row].name
        }else if type == "city" {
            selectedIndex = filterCities[indexPath.row].name
            //             selectLocationVC.city_id = filterCities[indexPath.row].cityID
            //            selectLocationVC.city = filterCities[indexPath.row].name
        }
        self.view.endEditing(true)
        tableView.reloadData()
        
    }
    
    
}

