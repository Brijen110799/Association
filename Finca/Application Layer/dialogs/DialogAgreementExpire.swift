//
//  DialogAgreementExpire.swift
//  Finca
//
//  Created by Fincasys Macmini on 09/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FittedSheets
import DeviceKit
class DialogAgreementExpire: BaseVC {
    var context : HomeNavigationMenuController!
    var multiSocietyArray = [LoginResponse]()
    var multiSocietyList = [LoginResponse]()
    var multiUnitList = [LoginResponse]()
    
    // multiUnitList

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = UserDefaults.standard.data(forKey: StringConstants.MULTI_SOCIETY_DETAIL)
       
        if data != nil{
            let decoded = try? JSONDecoder().decode(SocietyArray.self, from: data!)
           // print(decoded?.SocietyDetails.count)
            multiSocietyArray.append(contentsOf: (decoded?.SocietyDetails)!)
        }
        doCallMultiUnitApi()
        
    }
    func doCallMultiUnitApi(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let device = Device.current
        let params = ["getMultiUnitsNew":"getMultiUnitsNew",
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_token": UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!,
                      "app_version_code" : appVersion!,
                      "phone_brand":"Apple",
                      "device":"ios",
                      "phone_model":device.description,
                      "country_code":doGetLocalDataUser().countryCode ?? ""]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (Data, Err) in
            if Data != nil{
                //                self.hideProgress()
                print(Data as Any)
                do {
                    let response = try JSONDecoder().decode(MultiUnitResponse.self, from: Data!)
                    if response.status == "200"{
                        //   self.btnUnitSelect.isEnabled = true
                        self.multiUnitList.append(contentsOf: response.units)
                       
                    }else{
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }else{
            }
        }
    }
    @IBAction func BtnOkClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        exit(0)
       
    }
    @IBAction func ChangeSocietyClick(_ sender: UIButton) {
        
        let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMultiUserAndSocietyDialogVC")as! MultiUserAndSocietyDialogVC
        pickerVC.multiSocietyList.removeAll()
        pickerVC.multiSocietyList = self.multiSocietyArray
     //   pickerVC.context = context
        let sheetController = SheetViewController(controller: pickerVC, sizes: [.fixed(200),.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 8)
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        
    }
    @IBAction func ChangeUnitClick(_ sender: UIButton) {
     
        let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMultiUserAndSocietyDialogVC")as! MultiUserAndSocietyDialogVC
        pickerVC.multiUnitList.removeAll()
        pickerVC.multiUnitList = self.multiUnitList
        
        let sheetController = SheetViewController(controller: pickerVC, sizes: [.fixed(200),.fixed(250)])
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.handleSize = CGSize(width: 100, height: 8)
        sheetController.handleColor = UIColor.white
        self.present(sheetController, animated: false) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        
    }
}
