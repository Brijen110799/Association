//
//  SelectLanguageVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectLanguageVC: BaseVC {

    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var bContinue: UIButton!
    @IBOutlet weak var lbMSg: UILabel!
    @IBOutlet weak var viewBack: UIView!
    
    private let itemCell = "LanguageCell"
    var language =  [ModelLanguage]()
    var languageId = ""
    private var isComeFromSetting = false
    private var city_id = "" // = ""
    private var state_id = "" // = ""
    private var country_id = "" // = ""
    private var country_code = "" // = ""
    
    private let request = AlamofireSingleTon.sharedInstance
    var selectedSociety : ModelSociety!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bContinue.isEnabled = true
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
       
        bContinue.layer.backgroundColor = ColorConstant.green500.cgColor
        lbMSg.text = "Now you can use My Association in multiple language"
        doGetData()
        viewBack.isHidden = false
        
//        if isComeFromSetting {
//            viewBack.isHidden = false
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       
    }
    func doGetData( ) {
       
         showProgress()
        var params = [String:String]()
        if self.isComeFromSetting
        {
             params = ["getLanguageNew":"getLanguageNew", "country_id": instanceLocal().getCountryId()]
        } else {
             params = ["getLanguageNew": "getLanguageNew", "country_id": country_id]
        }
        
        print("param" , params)
       
        request.requestPostCommon(serviceName: NetworkAPI.language_controller, parameters: params) { (json, error) in
            
            self.hideProgress()
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(ResponseLanguage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.language = response.language
                        
                        if self.isComeFromSetting {
                            
                            self.bContinue.isEnabled = true
                            
                            for (index,item) in  self.language.enumerated() {
                                
                                if item.language_id == self.doGetLanguageId() {
                                    self.language[index].isCheck = true
                                    self.languageId = item.language_id ?? "1"
                                } else {
                                    self.language[index].isCheck = false
                                }
                                
                                
                            }
                        }else{
                            self.languageId =  self.language[0].language_id ?? "1"
                            self.bContinue.layer.backgroundColor = ColorConstant.green500.cgColor
                            self.language[0].isCheck = true
                            self.bContinue.isEnabled = true
                        }
                        
                        self.bContinue.isEnabled = true
                        
                        for (index,item) in  self.language.enumerated() {
                            
                            if item.language_id == self.doGetLanguageId() {
                                self.language[index].isCheck = true
                                self.languageId = item.language_id ?? "1"
                            } else {
                                self.language[index].isCheck = false
                            }
                            
                        }
                        
                        self.tbvData.reloadData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
                
                
            }
            
        }
        
       /* Alamofire.request(requrest.commonURL + NetworkAPI.language_controller, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            self.hideProgress()
            switch(response.result) {
                
            case .success(_):
                do {
                    let response = try JSONDecoder().decode(ResponseLanguage.self, from:response.data!)
                    if response.status == "200" {
                        
                        
                        self.language = response.language
                       
                        
                        if self.isComeFromSetting {
                            
                            self.bContinue.isEnabled = true
                         
                            for (index,item) in  self.language.enumerated() {
                                if let id = UserDefaults.standard.string(forKey: StringConstants.LANGUAGE_ID) {
                                    
                                    if item.language_id == id {
                                        self.language[index].isCheck = true
                                        self.languageId = item.language_id ?? "1"
                                    } else {
                                        self.language[index].isCheck = false
                                    }
                                    
                                }
                            }
                         }else
                        {
                            self.languageId =  self.language[0].language_id ?? "1"
                            self.bContinue.layer.backgroundColor = ColorConstant.green500.cgColor
                            self.language[0].isCheck = true
                            self.bContinue.isEnabled = true
                        }
                      
                        self.tbvData.reloadData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
                
                break
                
            case .failure(_):
                print(response)
                break
                
            }
        }*/
   
    }
    
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func tapContinue(_ sender: Any) {
        doGetLanguageData()
    }
    
    func doGetLanguageData() {
        showProgress()
        
        var params = [String : String]()
        var societyID = "0"
        if self.doCheckIsLocalDataIsThere() {
            societyID = self.doGetLocalDataUser().societyID ?? "0"
        }
        
        if self.isComeFromSetting {
            params = ["getLanguageValues":"getLanguageValues",
                      "language_id": languageId,
                      "society_id": societyID,
                      "country_id": instanceLocal().getCountryId()]
        } else {
            params = ["getLanguageValues":"getLanguageValues",
                      "language_id": languageId,
                      "society_id": societyID,
                      "country_id": country_id]
        }
        
        self.request.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                let langKey = "\(StringConstants.LANGUAGE_ID)\(societyID)"
                UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
                UserDefaults.standard.set(dictionary, forKey: dataKey)
                
                if self.isComeFromSetting {
                    Utils.setHome()
                } else {
                    //                    let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationVC")as! SelectLocationVC
                    //                    self.pushVC(vc: vc)
                    var chooseLang = false
                    if self.selectedSociety != nil {
                        chooseLang =  self.selectedSociety.choose_language
                    }
                    
                    if chooseLang == true {
                        
                        let langKey = "\(StringConstants.LANGUAGE_ID)\(self.selectedSociety.society_id ?? "0")"
                        UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                        let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.selectedSociety.society_id ?? "0")"
                        UserDefaults.standard.set(dictionary, forKey: dataKey)
                        
                        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
                        vc.city_id = self.city_id
                        vc.state_id = self.state_id
                        vc.country_id = self.country_id
                        vc.society_id = self.selectedSociety.society_id
                        vc.society_name = self.selectedSociety.society_name
                        vc.societyDetails = self.selectedSociety
                        vc.country_code = self.selectedSociety.country_code ?? ""
                        
                        UserDefaults.standard.set(self.selectedSociety.society_name!, forKey: StringConstants.KEY_SOCIATY_NAME)
                        UserDefaults.standard.set(self.selectedSociety.socieaty_logo, forKey: StringConstants.KEY_SOCIATY_LOGO)
                        UserDefaults.standard.set(self.selectedSociety.sub_domain, forKey: StringConstants.KEY_BASE_URL)
                        UserDefaults.standard.set(self.selectedSociety.api_key, forKey: StringConstants.KEY_API_KEY)
                        UserDefaults.standard.set(self.selectedSociety.api_key, forKey: StringConstants.KEY_IS_FIREBASE)
                        //                                           self.navigationController?.pushViewController(vc, animated: true)
                        self.pushVC(vc: vc)
                    } else {
                        let vc  = self.mainStoryboard.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
                        vc.isAddBuilding = false
                        vc.city_id = self.city_id
                        vc.state_id = self.state_id
                        vc.country_id = self.country_id
                        vc.languageDictionary = dictionary
                        vc.languageId = self.languageId
                        vc.country_code = self.country_code
                        self.pushVC(vc: vc)
                    }
                }
            }
        }
    }
    
    
    func setIsComeFromSetting(isComeFromSetting : Bool) {
        self.isComeFromSetting = isComeFromSetting
    }
    
    func setContryData(city_id: String,state_id: String,country_id: String,country_code: String ) {
        self.city_id = city_id
        self.state_id = state_id
        self.country_id = country_id
        self.country_code =  country_code
    }
    
    
}
extension SelectLanguageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! LanguageCell
        let item = language[indexPath.row]
        cell.mainView.layer.borderWidth = 2
        cell.lbPrimaryLanguage.text = item.language_name ?? ""
        cell.lbSecondryLanguage.text = item.language_name_1 ?? ""
        
        Utils.setImageFromUrl(imageView: cell.ivLanguage, urlString: item.language_icon ?? "",palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
        if item.isCheck ?? false {
            cell.mainView.layer.borderColor = ColorConstant.green500.cgColor
            cell.ivCheck.isHidden = false
        } else {
            cell.ivCheck.isHidden = true
            cell.mainView.layer.borderColor = ColorConstant.grey_10.cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (index,item) in language.enumerated() {
            
            if index == indexPath.row {
                
                if item.isCheck ?? false {
                    language[index].isCheck = false
                    bContinue.layer.backgroundColor = ColorConstant.grey_10.cgColor
                   // bContinue.isEnabled = false
                    bContinue.isUserInteractionEnabled = false
                 } else {
                    languageId =  language[index].language_id ?? "1"
                    bContinue.layer.backgroundColor = ColorConstant.green500.cgColor
                    language[index].isCheck = true
                    bContinue.isEnabled = true
                     bContinue.isUserInteractionEnabled = true
                }
                
            } else {
                language[index].isCheck = false
            }
        }
        
        
        tbvData.reloadData()
    }
    
}

struct ResponseLanguage : Codable {
    let message : String! //" : "Get Language Successfully!",
    let status : String! //" : "200"
    let language : [ModelLanguage]!
}
struct ModelLanguage : Codable {
    var language_name_1 : String? = "" //" : "English",
    var language_name : String? = "" //" : "English",
    var continue_btn_name : String? = "" //" : "CONTINUE",
    var language_file : String? = "" //" : "english.png",
    var language_icon : String? = "" //" : "https:\/\/mastlanguage\/english.png",
    var language_id : String? = "" //" : "1"
    var isCheck : Bool? = false
}
