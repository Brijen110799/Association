//
//  ClassifiedLocationFilterVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 12/04/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import EzPopup
protocol OnSelectedLocation {
    func locationFilter(state_id : String ,city_id : String ,state : String ,city : String )
}
class ClassifiedLocationFilterVC: BaseVC {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblFilterLocation: UILabel!
    @IBOutlet weak var selectStateView: UIView!
    @IBOutlet weak var selectCityView: UIView!
    @IBOutlet weak var lblSelectState: UILabel!
    @IBOutlet weak var lblSelectCity: UILabel!
    @IBOutlet weak var lblClearFilter: UILabel!
    @IBOutlet weak var lblApply: UILabel!
    
    var states = [StateModel]()
    var cities = [CityModel]()
    var filterstates = [StateModel]()
    
    var type = ""
    var city = ""
    var state = ""
    var country_id = ""
    var state_id = "0"
    private var select_country = "Select Country"
    private var select_state = "Select State"
    private var select_city = "Select City"
    var city_id = "0"
    var onSelectedLocation : OnSelectedLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cities)
        print(states)
       
        setThreeCorner(viewMain: selectStateView)
        setThreeCorner(viewMain: selectCityView)
       // lblSelectState.text = select_state
        
        doStateFilter(countryId: countryId)
        
        if state != "" {
            lblSelectState.text = state
        } else {
            lblSelectState.text = doGetValueLanguage(forKey: "select_state")
        }
        if city != "" {
            lblSelectCity.text = city
        } else {
            lblSelectCity.text = doGetValueLanguage(forKey: "select_city")
        }
        
        lblFilterLocation.text = doGetValueLanguage(forKey: "filter_location")
        lblClearFilter.text = doGetValueLanguage(forKey: "clear_filter")
        lblApply.text = doGetValueLanguage(forKey: "apply")
        
    }


    @IBAction func onClickBack(_ sender: Any) {
        closeView()
    }
    
    @IBAction func onTapSelectState(_ sender: Any) {

       
       
       
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
       
        let vc = CommonLocationFilterVC()
        vc.type = StringConstants.STATE
        vc.onSelectLocation = self
        vc.selectedIndex = state
        vc.states = states
      
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
        
    }
    
    @IBAction func onTapSelectCity(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
       
        let vc = CommonLocationFilterVC()
        vc.type = StringConstants.CITY
        vc.onSelectLocation = self
        vc.selectedIndex = city
        vc.cities = cities
      
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    func doStateFilter(countryId:String!) {
        showProgress()
        let params = ["key":apiKey(),
                      "getState":"getState",
                      "country_id":countryId!,
                      "language_id": doGetLanguageId()]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {

                do {


                    let response = try JSONDecoder().decode(StateResponse.self, from:json!)
                    if response.status == "200" {
                        self.states = response.states
                        
                        if self.state_id != "0" {
                            self.doGetCity(state_id: self.state_id)
                        }
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }


                } catch {
                    print("parse error")
                }
            }
        }
        //        if filterstates.count > 0 {
        //            filterstates.removeAll()
        //        }
        //
        //
        //        for j in (0..<states.count) {
        //
        //            if states[j].country_id == country_id {
        //                filterstates.append(states[j])
        //            }
        //        }
    }
    func closeView() {
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func doGetCity(state_id:String) {
        showProgress()
        let params = ["getCity":"getCity",
                      "state_id": state_id]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                 do {
                     
                    let response = try JSONDecoder().decode(CityResponse.self, from:json!)
                    if response.status == "200" {
                        self.cities = response.cities
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                          
                } catch {
                    print("parse error")
                }
            }
        }
     
    }
    
    @IBAction func tapClear(_ sender: Any) {
        state_id = "0"
        city_id = "0"
        city = ""
        state = ""
        onSelectedLocation.locationFilter(state_id: state_id, city_id: city_id,state: state,city: city)
        closeView()
    }
    
    @IBAction func tapApply(_ sender: Any) {
        onSelectedLocation.locationFilter(state_id: state_id, city_id: city_id,state: state,city: city)
        closeView()
    }
}
extension ClassifiedLocationFilterVC : OnSelectLocation {
    func onSelectLocation(type: String, id: String, name: String) {
        if type == StringConstants.STATE {
            state = name
            lblSelectState.text = name
            state_id = id
            doGetCity(state_id: state_id)
            
        } else {
            city = name
            lblSelectCity.text = name
            city_id = id
        }
        print(" type = \(type)  id = \(id) name = \(name)")
        
    }
    
    
    
}
