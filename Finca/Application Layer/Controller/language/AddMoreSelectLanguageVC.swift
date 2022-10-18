//
//  AddMoreSelectLanguageVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/04/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit

class AddMoreSelectLanguageVC: BaseVC {
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var bContinue: UIButton!
    
    @IBOutlet weak var viewBack: UIView!
    private let itemCell = "LanguageCell"
    @IBOutlet weak var lbMSg: UILabel!
    
    var language =  [ModelLanguage]()
    var languageId = ""
    private var isComeFromSetting = false
    private var city_id = "" // = ""
    private var state_id = "" // = ""
    private var country_id = "" // = ""
    private let request = AlamofireSingleTon.sharedInstance

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
        //viewBack.isHidden = false
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
             params = ["getLanguageNew":"getLanguageNew",
                       "country_id":instanceLocal().getCountryId()]
        }else
        {
             params = ["getLanguageNew":"getLanguageNew",
                       "country_id":country_id]
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
                
                
            }
            
        }
        
       
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
        if self.isComeFromSetting
        {
            params = ["getLanguageValues":"getLanguageValues",
                      "language_id":languageId,
                      "society_id":doGetLocalDataUser().societyID ?? "0",
                      "country_id":instanceLocal().getCountryId()]
        }else
        {
            params = ["getLanguageValues":"getLanguageValues",
                      "language_id":languageId,
                      "society_id":doGetLocalDataUser().societyID ?? "0",
                      "country_id":country_id]
        }
        print(params)
        request.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                let langKey = "\(StringConstants.LANGUAGE_ID_ADD_MORE)"
                UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA_ADD_MORE)"
                
                UserDefaults.standard.set(dictionary, forKey: dataKey)
//                if self.isComeFromSetting {
//                    Utils.setHome()
//                } else {
                   // let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationVC")as! SelectLocationVC
                   // self.pushVC(vc: vc)
                    
                    let vc  = self.mainStoryboard.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
                    vc.isAddBuilding = true
                    vc.city_id = self.city_id
                    vc.state_id = self.state_id
                    vc.country_id = self.country_id
                    vc.languageDictionary = dictionary
                    vc.languageId = self.languageId
                    self.pushVC(vc: vc)
                //}
            }
//            if isSucess ?? false {
//
//            }
            
            
        }
       
    }
    func setIsComeFromSetting(isComeFromSetting : Bool) {
        self.isComeFromSetting = isComeFromSetting
    }
    
    func setContryData(city_id: String,state_id: String,country_id: String ) {
        self.city_id = city_id
        self.state_id = state_id
        self.country_id = country_id
    }
    override func onClickDone() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) || controller.isKind(of: AddBuildingLoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
//        if isUserinsert{
//            //            Utils.setHomeRootLogin()
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: LoginVC.self) || controller.isKind(of: AddBuildingLoginVC.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }else{
//
//            Utils.setHome()
//
//        }
    }
}
extension AddMoreSelectLanguageVC : UITableViewDelegate , UITableViewDataSource {
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
                    
                 } else {
                    languageId =  language[index].language_id ?? "1"
                    bContinue.layer.backgroundColor = ColorConstant.green500.cgColor
                    language[index].isCheck = true
                    bContinue.isEnabled = true
                }
                
            } else {
                language[index].isCheck = false
            }
        }
        
        
        tbvData.reloadData()
    }
    
}
