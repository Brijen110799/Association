//
//  SocietyVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
import FittedSheets
import Speech

struct ResponseSociety : Codable{
    let message:String! //"message" : "Get Society success.",
    let status:String! //"status" : "200"
    let society:[ModelSociety]!
}

struct ModelSociety:Codable {
    let api_key:String!//" : "bmsapikey",
    let societyUserId:String!//" : "",
    let builder_name:String!//" : "Akki",
    let society_name:String!//" : "Silverwing Society",
    let builder_mobile:String!//" : "9157146041",
    let sub_domain:String!//" : "https:\/\/www.fincasys.com\/",
    let secretary_mobile:String!//" : "9157146041",
    let society_id:String!//" : "48",
    let builder_address:String!//" : "Naroda",
    let secretary_email:String!//" : "ankitrana1056@gmail.com",
    let society_address:String!//" : "1st Floor, Parshwa Tower,\r\nAbove Kotak Mahindra Bank,\r\nS.G
    let socieaty_status:String!//" : null,
    let socieaty_logo:String!//" : "1562061152.png"
    let is_society : Bool!
    let is_firebase : Bool!
    let country_code : String!
    let choose_language : Bool!
    let language_id : String!
    let currency : String!
    
    let label_member_type: String? //  "Team Members",
    let secretary_name: String? //  null,
    let society_type: String? //  "1",
    let label_setting_resident: String? //  "Contact Number Privacy for Members",
    let label_setting_apartment: String? //  "Unit closed",
    let society_pincode: String? //  "380054",
    let city_name: String? //  ""
    
    let association_website: String? //  "www.chpl.com",
    let association_email: String? //  "ankit@silverwingteram.com",
    let association_phone_number: String? //  "9157146041",
    
}

class SocietyVC: BaseVC {
    
  //  @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var bLogin: UIButton!
    @IBOutlet weak var viewNoResult: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbNoData: UILabel!
    
    @IBOutlet weak var ivView: UIImageView!
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var bRegistration: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isHidden = true
        }
    }
    var societyArray = [ModelSociety]()
    var selectedSociety : ModelSociety!
    var filterSocietyArray = [ModelSociety](){
        didSet{
            tbvData.reloadData()
        }
    }
    let itemCell = "SocietyRegistrationTableCell"
    var city_id : String! // = ""
    var state_id : String! // = ""
    var country_id : String! // = ""
    var selectIndex : Int!
    var isAddBuilding = false
    
    @IBOutlet weak var viewClear: UIView!
    var languageDictionary:NSDictionary?
    var languageId = ""
    var country_code = ""
    var isShowLoading = true
    var chooselang : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        cvData.delegate = self
//        cvData.dataSource = self
//        let inb = UINib(nibName: itemCell, bundle: nil)
//        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.backgroundColor = .clear
        bLogin.isHidden = true
        //doGetSocietes()
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        viewNoResult.isHidden = false
          viewClear.isHidden = true
      
        bLogin.setTitle(doGetValueLanguage(forKey: "Continue").uppercased(), for: .normal)
        lbNoData.text = doGetValueLanguage(forKey: "search_society")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_society")
        bRegistration.setTitle(doGetValueLanguage(forKey: "request_your_society"), for: .normal)
        bRegistration.isHidden = true
        bBack.isHidden = true
        if isAddBuilding {
            bRegistration.isHidden = true
            bLogin.setTitle(doGetValueLanguageForAddMore(forKey: "Continue").uppercased(), for: .normal)
            lbNoData.text = doGetValueLanguageForAddMore(forKey: "search_society")
            tfSearch.placeholder = doGetValueLanguageForAddMore(forKey: "search_society")
            bBack.isHidden = false
            backView.isHidden = false
        }
        
        doGetLanguageData(language_id: languageId, isLoginGo: false)
    }
    
    private func setupUI() {
        bLogin.setTitle(doGetValueLanguage(forKey: "Continue").uppercased(), for: .normal)
        lbNoData.text = doGetValueLanguage(forKey: "search_society")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_society")
        bRegistration.setTitle(doGetValueLanguage(forKey: "request_your_society"), for: .normal)
        bRegistration.isHidden = true
    }
    func gotoSuggestionMenu(textVoice : [ModelSociety]){
        if textVoice.count > 0 {
            dismiss(animated: true) {
                self.filterSocietyArray = []
                self.filterSocietyArray = textVoice
                self.viewNoResult.isHidden = true
                self.tbvData.reloadData()
                
            }
        }
    }
    @IBAction func onClickConversion(_ sender: Any) {
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = DialogVoiceSearchSociety()
        
        vc.context = self
        vc.societyArray = societyArray
        // vc.societyArray = societyArray
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        //  popupVC.canTapOutsideToDismiss = true
        self.present(popupVC, animated: true)
   
    }
    @IBAction func onClickClear(_ sender: Any) {
        bLogin.isHidden = true
        bRegistration.isHidden = true
        selectIndex = -1
        filterSocietyArray.removeAll()
        tbvData.reloadData()
        tfSearch.text = ""
        if tfSearch.text == ""
        {
          //  lbNoData.text = "Search Your Society"
            lbNoData.text = doGetValueLanguage(forKey: "search_your_society")
            self.viewNoResult.isHidden = false
        }else
        {
            self.viewNoResult.isHidden = true
        }
        view.endEditing(true)
        viewClear.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    @objc func textFieldDidChange(textField: UITextField) {
        selectIndex = nil
        self.viewClear.isHidden = false
        
        if tfSearch.text == "" {
            bLogin.isHidden = true
            bRegistration.isHidden = true
            filterSocietyArray.removeAll()
            tbvData.reloadData()
            lbNoData.text = doGetValueLanguage(forKey: "search_your_society")
            self.viewNoResult.isHidden = false
            view.endEditing(true)
            viewClear.isHidden = true
            
        }
        
        if textField.text?.count ?? 0 >= 3 {
            doGetSocietes(society_name: textField.text ?? "")
        }else {
            lbNoData.text = doGetValueLanguage(forKey: "search_society")
            self.filterSocietyArray.removeAll()
            self.societyArray.removeAll()
            tbvData.reloadData()
            self.viewNoResult.isHidden = false
            bLogin.isHidden = true
        }
        
    }
    
    func doFilterdArray(at text : String) {
        if text == "" {
              viewClear.isHidden = true
        } else {
              viewClear.isHidden = false
        }
        if text.count >= 3 {
            filterSocietyArray = text.isEmpty ? societyArray : societyArray.filter({ (item:ModelSociety) -> Bool in
                
                return item.society_name.range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
          
            if text == "" {
                filterSocietyArray.removeAll()
                viewNoResult.isHidden = false
                tbvData.reloadData()
                selectIndex = -1
                bLogin.isHidden = true
                //lbNoData.text = "Search Your Society"
                lbNoData.text = doGetValueLanguage(forKey: "search_society")
            } else {
                lbNoData.text = doGetValueLanguage(forKey: "no_society_found")
               // lbNoData.text = "No Society Found"
                bLogin.isHidden = true
                
            }
            self.bRegistration.isHidden = true
            if filterSocietyArray.count == 0 {
                viewNoResult.isHidden = false
                
                if !isAddBuilding {
                    self.bRegistration.isHidden = true
                }
            }else {
                viewNoResult.isHidden = true
            }
            tbvData.reloadData()
        }else{
            viewNoResult.isHidden = false
            lbNoData.text = doGetValueLanguage(forKey: "search_society")
            self.bRegistration.isHidden = true
            bLogin.isHidden = true
            selectIndex = 2
            filterSocietyArray.removeAll()
            tbvData.reloadData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    func doGetSocietes(society_name :String) {
//        if isShowLoading {
//            self.isShowLoading = false
//            showProgress()
//        }
       
        let params = ["key":apiKey(),
                      "getSocietyNew":"getSocietyNew",
                      "country_id":"101",
                      "state_id":"0",
                      "city_id":"0",
                      "society_name":society_name]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMain(serviceName: ServiceNameConstants.societyList, parameters: params) { (json, error) in
//            if self.isShowLoading {
//                self.isShowLoading = true
//                self.hideProgress()
//            }
           
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseSociety.self, from:json!)
                    if response.status == "200" {
                        self.societyArray = response.society
                        self.filterSocietyArray = response.society
                        self.tbvData.reloadData()
                       // self.filterSocietyArray = response.society
                        self.viewNoResult.isHidden = true
                        self.bRegistration.isHidden = true
                    }else {
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_society_found")
                        self.viewNoResult.isHidden = false
                        self.bLogin.isHidden = true
                        self.filterSocietyArray.removeAll()
                        self.tbvData.reloadData()
                        if !self.isAddBuilding {
                            self.bRegistration.isHidden = false
                        }else{
                        self.bRegistration.isHidden = true
                        }
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func onClickContinew(_ sender: Any) {
        print("onclick")
        var multiSocietyArray = [LoginResponse]()
        if isAddBuilding{
            let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
            if data != nil{
                let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
                multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
            }
            var flag = true
            for item in multiSocietyArray{
                if item.societyID == selectedSociety.society_id{
                    flag = false
                }
            }

            if flag{
                let langKey = "\(StringConstants.LANGUAGE_ID)\(self.selectedSociety.society_id ?? "0")"
                UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.selectedSociety.society_id ?? "0")"
                UserDefaults.standard.set(languageDictionary, forKey: dataKey)
               
                let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idAddBuildingLoginVC") as! AddBuildingLoginVC
                vc.city_id = self.city_id
                vc.state_id = self.state_id
                vc.country_id = self.country_id
                vc.society_id = selectedSociety.society_id
                vc.society_name = selectedSociety.society_name
                vc.societyDetails = selectedSociety
                vc.countryCode = selectedSociety.country_code ?? ""
                UserDefaults.standard.set(selectedSociety.society_name, forKey: StringConstants.KEY_SOCIATY_NAME)
                UserDefaults.standard.set(selectedSociety.socieaty_logo, forKey: StringConstants.KEY_SOCIATY_LOGO)
                UserDefaults.standard.set(self.selectedSociety.api_key, forKey: StringConstants.KEY_IS_FIREBASE)
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            }else{
              
                showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "this_building_is_already_added"), style: .Add, tag: 0, cancelText: "", okText: "OKAY")
           }
        }else{
            
            
            if selectedSociety.choose_language ?? false  {
                
                let vc = SelectLanguageVC()
                vc.setContryData(city_id: "0", state_id: "0", country_id: "101", country_code: self.selectedSociety.country_code ?? "0")
                vc.selectedSociety  = selectedSociety
                self.pushVC(vc: vc)
                
            } else {
                
                //if doGetLanguageId() == selectedSociety.language_id {
                    doGetLanguageData(language_id: selectedSociety.language_id ?? "1", isLoginGo: true)
//                    let langKey = "\(StringConstants.LANGUAGE_ID)\(self.selectedSociety.society_id ?? "0")"
//                    UserDefaults.standard.setValue(self.languageId, forKey: langKey)
//
//                    let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.selectedSociety.society_id ?? "0")"
//                    UserDefaults.standard.set(languageDictionary, forKey: dataKey)
//
//                    let vc = storyboard?.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
//                    vc.city_id = self.city_id
//                    vc.state_id = self.state_id
//                    vc.country_id = self.country_id
//                    vc.society_id = selectedSociety.society_id
//                    vc.society_name = selectedSociety.society_name
//                    vc.societyDetails = selectedSociety
//                    vc.country_code = selectedSociety.country_code ?? ""
//                    UserDefaults.standard.set(selectedSociety.society_name!, forKey: StringConstants.KEY_SOCIATY_NAME)
//                    UserDefaults.standard.set(selectedSociety.socieaty_logo, forKey: StringConstants.KEY_SOCIATY_LOGO)
//                    UserDefaults.standard.set(self.selectedSociety.sub_domain, forKey: StringConstants.KEY_BASE_URL)
//                    UserDefaults.standard.set(self.selectedSociety.api_key, forKey: StringConstants.KEY_API_KEY)
//                    UserDefaults.standard.set(self.selectedSociety.api_key, forKey: StringConstants.KEY_IS_FIREBASE)
//                    self.navigationController?.pushViewController(vc, animated: true)
                //}
//                else {
//                    doGetLanguageData(language_id: selectedSociety.language_id ?? "1", isLoginGo: true)
//                }
                
              
            }
            
          
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    func doReturnVoiceText(text : String) {
//        doFilterdArray(at: text)
        self.tfSearch.text = text
        doGetSocietes(society_name: text)
        
    }
    
    @IBAction func tapRegistration(_ sender: Any) {
        let vc = storyboard?.login().instantiateViewController(withIdentifier: "idRequestSocietyVC") as! RequestSocietyVC
        vc.country_code = country_code
        pushVC(vc: vc)
    }
    
    
    func doGetLanguageData(language_id : String , isLoginGo : Bool) {
        showProgress()
        
        
        var societyID = "0"
        if self.doCheckIsLocalDataIsThere() {
            societyID = self.doGetLocalDataUser().societyID ?? "0"
        }
        
        let params = ["getLanguageValues":"getLanguageValues",
                  "language_id":language_id,
                  "society_id":societyID,
                  "country_id":country_id ?? ""]
        
        print(params)
        AlamofireSingleTon.sharedInstance.doGetLanguageData(serviceName: NetworkAPI.language_controller, parameters: params) { (dictionary, error) in
            self.hideProgress()
            if dictionary != nil {
                let langKey = "\(StringConstants.LANGUAGE_ID)\(societyID)"
                UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                
                let dataKey = "\(StringConstants.LANGUAGE_DATA)\(societyID)"
                UserDefaults.standard.set(dictionary, forKey: dataKey)
                
                //self.languageDictionary = dictionary
                DispatchQueue.main.async {
                    self.setupUI()
                
                    if isLoginGo {
                        
                        let langKey = "\(StringConstants.LANGUAGE_ID)\(self.selectedSociety.society_id ?? "0")"
                        UserDefaults.standard.setValue(self.languageId, forKey: langKey)
                        
                        let dataKey = "\(StringConstants.LANGUAGE_DATA)\(self.selectedSociety.society_id ?? "0")"
                        UserDefaults.standard.set(dictionary, forKey: dataKey)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
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
                        self.navigationController?.pushViewController(vc, animated: true) // KEY_IS_FIREBASE
                        
                    }
                }
                
                
                
            }
//            if isSucess ?? false {
//
//            }
            
            
        }
       
    }
}
extension  SocietyVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! SocietyRegistrationCell
        
        cell.lbTitle.text = filterSocietyArray[indexPath.row].society_name
        cell.lbDesc.text = filterSocietyArray[indexPath.row].society_address
        cell.viewMain.layer.shadowRadius = 3
        cell.viewMain.layer.shadowOffset = CGSize.zero
        cell.viewMain.shadowOpacity = 0.4
        if selectIndex == indexPath.row{
            cell.viewMain.backgroundColor = ColorConstant.primaryColor
            cell.lbTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lbDesc.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lbTitle.font = .boldSystemFont(ofSize: 15)
            bLogin.isHidden = false
        } else {
            cell.lbTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbDesc.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbTitle.font = .boldSystemFont(ofSize: 15)
            cell.viewMain.backgroundColor = UIColor.white
            
        }
        
        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterSocietyArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-3, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        selectIndex = indexPath.row
        collectionView.reloadData()
        print(filterSocietyArray[indexPath.row])
        bLogin.isHidden = false
        bLogin.isEnabled = true
        selectedSociety = filterSocietyArray[indexPath.row]
        self.view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
    }
}
extension SocietyVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Add{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension SocietyVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSocietyArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! SocietyRegistrationTableCell
        cell.selectionStyle = .none
        cell.lbTitle.text = filterSocietyArray[indexPath.row].society_name
        cell.lbDesc.text = filterSocietyArray[indexPath.row].society_address
        cell.viewMain.layer.shadowRadius = 3
        cell.viewMain.layer.shadowOffset = CGSize.zero
        cell.viewMain.shadowOpacity = 0.4
        if selectIndex == indexPath.row{
            cell.viewMain.backgroundColor = ColorConstant.primaryColor
            cell.lbTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lbDesc.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lbTitle.font = .boldSystemFont(ofSize: 15)
            bLogin.isHidden = false
        } else {
            cell.lbTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbDesc.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbTitle.font = .boldSystemFont(ofSize: 15)
            cell.viewMain.backgroundColor = UIColor.white
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
        print(filterSocietyArray[indexPath.row])
        bLogin.isHidden = false
        bLogin.isEnabled = true
        selectedSociety = filterSocietyArray[indexPath.row]
        self.view.endEditing(true)
    }
}
