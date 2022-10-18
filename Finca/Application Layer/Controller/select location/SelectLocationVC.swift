//
//  SelectLocationVC.swift
//  Finca
//
//  Created by anjali on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
class SelectLocationVC: BaseVC {
    
    @IBOutlet weak var mainPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var bDemoTour: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var bNext: UIButton!
    var countries = [CountryModel]()
    var states = [StateModel]()
    var cities = [CityModel]()
    
    var selectView = ""
    var city_id = ""
    var state_id = ""
    var country_id = ""
    var country_code = ""
    var isclick = true
    
    var type = ""
    var city = ""
    var state = ""
    var country = ""
    
    var filterCity = [CityModel]()
    var filterstates = [StateModel]()
    
    var  user_mobile = ""
    var  demo_status = ""
    var  user_password = ""
      
    private var select_country = "Select Country"
    private var select_state = "Select State"
    private var select_city = "Select City"
    private let request = AlamofireSingleTon.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: ivBackground, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_BACKGROUND_IMAGE)!, palceHolder: "fincasys_notext")
        doGetLocation()
        bDemoTour.isHidden = true
        UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
        
        
        if doGetValueLanguage(forKey: "select_country") != "" {
            select_country = doGetValueLanguage(forKey: "select_country")
            select_state = doGetValueLanguage(forKey: "select_state")
            select_city = doGetValueLanguage(forKey: "select_city")
            bNext.setTitle(doGetValueLanguage(forKey: "next").uppercased(), for: .normal)
        } else {
            bNext.setTitle("NEXT", for: .normal)
        }
        
        lbCountry.text = select_country
        lbState.text = select_state
        lbCity.text = select_city
       
    }
    
    @IBAction func onClickCountry(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
//        type =  "country"
//        vc.type = type
//        vc.countries = countries
//        vc.selectLocationVC = self
//        //  vc.isEmergancy = false
//        // vc.ownedDataSelectVC = self
//        //   vc.isProfile = false//
//        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        self.addChild(vc)
//        self.view.addSubview(vc.view)
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
        type =  "country"
        vc.type = type
        vc.countries = countries
        vc.selectedIndex = country
        vc.selectLocationVC = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func onClickState(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
//        type =  "state"
//        vc.type = type
//
//        vc.selectLocationVC = self
//
//        if country_id == "" {
//            vc.states = states
//        } else {
//            vc.states = filterstates
//        }
//
//        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        self.addChild(vc)
//        self.view.addSubview(vc.view)
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
        type =  "state"
        vc.type = type
        vc.selectedIndex = state
        vc.selectLocationVC = self
        if country_id == "" {
            vc.states = states
        } else {
            vc.states = filterstates
        }
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
        
    }
    
    @IBAction func onClickCity(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
//        type =  "city"
//        vc.type = type
//
//        if state_id == "" {
//            vc.cities = cities
//        } else {
//            vc.cities = filterCity
//        }
//
//        vc.selectLocationVC = self
//        vc.state_id = state_id
//
//        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        self.addChild(vc)
//        self.view.addSubview(vc.view)
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
        type =  "city"
        vc.type = type
           vc.selectedIndex = city
        if state_id == "" {
            vc.cities = cities
        } else {
            vc.cities = filterCity
        }
        vc.selectLocationVC = self
        vc.state_id = state_id
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        isclick = true
        mainPickerView.isHidden = true
    }
    
    func doGetLocation() {
        showProgress()
        let params = ["key":apiKey(),
                      "getCountries":"getCountries"]
        
        print("param" , params)
        request.requestPostMain(serviceName: ServiceNameConstants.LOCATION_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseLocation.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.doSetArrayData(reposneLocation: response)
                        UserDefaults.standard.set(response.userPassword, forKey: StringConstants.KEY_PASSWORD)
                        UserDefaults.standard.set(response.userMobile, forKey: StringConstants.KEY_USER_NAME)
                        
                        UserDefaults.standard.set(response.societyName, forKey: StringConstants.KEY_SOCIATY_NAME)
                        UserDefaults.standard.set(response.societyLogo, forKey: StringConstants.KEY_SOCIATY_LOGO)
                        
                        self.user_mobile = response.userMobile
                        self.demo_status = response.demoStatus
                        self.user_password = response.userPassword
                        
                        UserDefaults.standard.set(response.subDomain, forKey: StringConstants.KEY_BASE_URL)
                        UserDefaults.standard.set(response.apiKey, forKey: StringConstants.KEY_API_KEY)
                        
                        if self.demo_status == "1" {
                            self.bDemoTour.isHidden = false
                        } else {
                            self.bDemoTour.isHidden = true
                        }
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func doSetArrayData(reposneLocation:ResponseLocation) {
        if reposneLocation.countries != nil {
            self.countries.append(contentsOf: reposneLocation.countries!)
            
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        if isValide() {
            var societyID = "0"
            if self.doCheckIsLocalDataIsThere() {
                societyID = self.doGetLocalDataUser().societyID ?? "0"
            }
            
            let dataKey = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
          
            if UserDefaults.standard.value(forKey: dataKey) == nil {
                let vc = SelectLanguageVC()
                vc.setContryData(city_id: city_id, state_id: state_id, country_id: country_id, country_code: country_code)
                self.pushVC(vc: vc)
            } else{
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
                var dictLo = NSDictionary()
                if  let data  = UserDefaults.standard.value(forKey: dataKey)  {
                    dictLo  = data  as! NSDictionary
                    UserDefaults.standard.set(dictLo, forKey: dataKey)
                }
                
                if doCheckIsLocalDataIsThere() && doGetLocalDataUser().countryId == countryId{
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
                    vc.isAddBuilding = false
                    vc.city_id = city_id
                    vc.state_id = state_id
                    vc.country_id = country_id
                    vc.languageDictionary = dictLo
                    vc.languageId = doGetLanguageId()
                    vc.country_code = country_code
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = SelectLanguageVC()
                    vc.setContryData(city_id: city_id, state_id: state_id, country_id: country_id, country_code: country_code)
                    self.pushVC(vc: vc)
                }
                
              
            }
            
          //  doGetData()
            
        }
    }
    
    func isValide() -> Bool {
        var isValid = true
      
        if country_id == "" {
            showAlertMessage(title: "", msg: select_country)
            isValid  = false
            
        }
        if state_id == "" {
            showAlertMessage(title: "", msg: select_state)
           
            isValid  = false
        }
        if city_id == "" {
            showAlertMessage(title: "", msg:  select_city)
            isValid  = false
        }
        return isValid
    }
    
     func reloadArrays() {
        
        print(country_id)
        print(city_id)
        print(state_id)
        if type == "country" {
            if country_id != "" {
                lbCountry.text = country
                doStateFilter(countryId: self.country_id)
//                lbState.text = doGetValueLanguage(forKey: "select_state")
//                lbCity.text = doGetValueLanguage(forKey: "select_city")
               
            } else {
               // lbCountry.text = doGetValueLanguage(forKey: "select_country")
                lbCountry.text = select_country
            }
            
            state = ""
            city = ""
           // lbState.text = doGetValueLanguage(forKey: "select_state")
           // lbCity.text = doGetValueLanguage(forKey: "select_city")
            lbState.text = select_state
            self.lbCity.text  = select_city
        } else if type == "city" {
            if  city != "" {
                self.lbCity.text = self.city
            } else {
                lbCity.text = select_city
            }
            
            
        } else if type == "state" {
            
            if state == ""  {
                lbState.text = select_state
            } else {
                lbState.text = state
                doFilterCity(stateId:self.state_id)
            }
            city = ""
            lbCity.text = select_city
        }
        
        
    }
    
    func doFilterCity(stateId:String!) {
        showProgress()
        print(stateId!)
        let params = ["key":apiKey(),
                      "getCity":"getCity",
                      "state_id":stateId!]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMain(serviceName: ServiceNameConstants.LOCATION_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(CityResponse.self, from:json!)
                    if response.status == "200" {
                        if self.filterCity.count > 0 {
                            self.filterCity.removeAll()
                        }
                        self.filterCity.append(contentsOf: response.cities)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        //
        //        // let sortedNames = filterCity.sorted(by: )
        //        // print(sortedNames)
        //
        //        // filterCity =   filterCity.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
    }
    
    func doStateFilter(countryId:String!) {
        showProgress()
        let params = ["key":apiKey(),
                      "getState":"getState",
                      "country_id":countryId!]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMain(serviceName: ServiceNameConstants.LOCATION_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                
                do {
                    
                    
                    let response = try JSONDecoder().decode(StateResponse.self, from:json!)
                    if response.status == "200" {
                        if self.filterstates.count > 0 {
                            self.filterstates.removeAll()
                        }
                        self.filterstates.append(contentsOf: response.states)
                        
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
    
    @IBAction func onClickDemoTour(_ sender: Any) {
        doLogin()
        
    }
    
    func doLogin() {
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        //"user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)
        let params = ["user_login":"user_login",
                      "user_mobile":user_mobile,
                      "user_password":user_password,
                      "user_token": "demo from ios",
                      "device":"ios",]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPostMain(serviceName: "demo_login_controller.php", parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        //   UserDefaults.standard.set(self.tfPassword.text!, forKey: StringConstants.KEY_PASSWORD)
                        // UserDefaults.standard.set(self.tfMobile.text!, forKey: StringConstants.KEY_USER_NAME)
                        
                        
                        
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        
                        UserDefaults.standard.set("101", forKey: StringConstants.COUNTRYID)
                        UserDefaults.standard.set("1558", forKey: StringConstants.STATEID)
                        UserDefaults.standard.set("15499", forKey: StringConstants.CITYID)
                        
                        
                        
                        UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER) as! SWRevealViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            } else {
                //print("error" , error)
            }
        }
    }
    
    
    func doGetData( ) {
        showProgress()
        let params  = ["getLanguageNew":"getLanguageNew",
                       "country_id":country_id]
        print("param" , params)
        request.requestPostCommon(serviceName: NetworkAPI.language_controller, parameters: params) { (json, error) in
            
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseLanguage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                         self.doGetLanguageData(languageId: response.language[0].language_id ?? "1")
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
                
                
            }
            
        }
    }
    
    func doGetLanguageData(languageId : String) {
        showProgress()
        let params = ["getLanguageValues":"getLanguageValues",
                         "language_id":languageId]
        print(params)
        request.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                
                var societyID = "0"
                if self.doCheckIsLocalDataIsThere() {
                    societyID = self.doGetLocalDataUser().societyID ?? "0"
                }
                let langKey = "\(StringConstants.LANGUAGE_ID)\(societyID)"
                UserDefaults.standard.setValue(languageId, forKey: langKey)
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
                UserDefaults.standard.set(dictionary, forKey: dataKey)
                
                //UserDefaults.standard.setValue(languageId, forKey: StringConstants.LANGUAGE_ID)
                
                let vc  = self.mainStoryboard.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
                vc.isAddBuilding = false
                vc.city_id = self.city_id
                vc.state_id = self.state_id
                vc.country_id = self.country_id
                vc.languageDictionary = dictionary
                vc.languageId = languageId
                self.pushVC(vc: vc)
                
            }
            
            
        }
        
        
      
    }
    
}


