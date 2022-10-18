//
//  TabMyVehicleVC.swift
//  Finca
//
//  Created by CHPL Group on 07/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftUI
import AVFoundation
import DeviceKit

class TabMyVehicleVC: BaseVC, AppDialogDelegate  {
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {

                    let data = self.filterRequestList[tag]
                    
                self.dovehicleDelete(vehicle_id: data.vehicle_id, index: tag, strQrcodeID: data.qrcode_id)

        }
    }
}
  
    
    func btnCancelClicked() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var btnclear: UIButton!
    let itemcell = "VehicleCell"
var AllVehicleList = [list]()
    var myVehicle = [list]()
    var filterRequestList = [list]()
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    var menuTitle : String!
  
    var logo : String!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tbvdata: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    var StrAttachments = ""
    var selectedDataTable : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfSearch.text = ""
        tbvdata.delegate = self
        tbvdata.dataSource = self
        viewNoData.isHidden = true
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvdata.register(nib, forCellReuseIdentifier: itemcell)
        addRefreshControlTo(tableView: tbvdata)
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        dovehicleList()
       
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_by_vehicle_number")
        lbTitle.text = doGetValueLanguage(forKey: "no_data")
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle),palceHolder: "")
               
        tbvdata.reloadData()
        btnclear.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    @objc func textFieldDidChange(sender : UITextField) {
        
        self.btnclear.isHidden = false
        
        filterRequestList = sender.text!.isEmpty ? AllVehicleList : AllVehicleList.filter({ item in
            return item.vehiclenumber.lowercased().range(of: sender.text?.lowercased() ?? "") != nil || item.user_fullname.lowercased().range(of: sender.text?.lowercased() ?? "") != nil ||
            item.companyname.lowercased().range(of: sender.text?.lowercased() ?? "") != nil
        })
       
        
        if filterRequestList.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
        tbvdata.reloadData()
      }
    
    
    func dovehicleDelete(vehicle_id:String!,index:Int!,strQrcodeID:String!) {
        showProgress()
     
        let params = ["key":apiKey(),
                      "deleteVehicle":"deleteVehicle",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "vehicle_id":vehicle_id!,
                      "qrcode_id":strQrcodeID!,
                      "language_id":doGetLanguageId()]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
                    if response.status == "200"{
                        self.filterRequestList.remove(at: index)
                     
                        if self.filterRequestList.count != 0{
                            self.viewNoData.isHidden = true
                        }else{
                            self.viewNoData.isHidden = false
                        }
                        
                        
                        self.tbvdata.reloadData()
                        
                    }else{
                     
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }

    }
    
    
    func dovehicleEdit() {
        showProgress()
     
        let params = ["key":apiKey(),
                      "updateVehicle":"updateVehicle",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "vehicle_id":"",
                      "vehicle_number":"",
                      "block_id":doGetLocalDataUser().blockID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "vehicle_type":"",
                      "old_vehicle_photo":"",
                      "old_rc_book":"",
                      "language_id":doGetLanguageId()]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
                    if response.status == "200"{
                       
                    }else{
                        
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }

    }
    
    @IBAction func btnclearAction(_ sender: Any) {
        self.btnclear.isHidden = true
        self.tfSearch.text = ""
        self.filterRequestList = self.AllVehicleList
        
        if self.filterRequestList.count != 0{
            self.viewNoData.isHidden = true
        }else{
            self.viewNoData.isHidden = false
        }
        
        self.tbvdata.reloadData()
        
    }
    
    func dovehicleList() {
     showProgress()
     
        let params = ["key":apiKey(),
                      "getMyVehicleList":"getMyVehicleList",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "language_id":doGetLanguageId()]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
                    if response.status == "200"{
                        self.AllVehicleList = response.list
                        self.filterRequestList = self.AllVehicleList
                        self.tbvdata.reloadData()
                        if self.AllVehicleList.count != 0{
                            self.viewNoData.isHidden = true
                        }else{
                            self.viewNoData.isHidden = false
                        }
                        self.tbvdata.reloadData()
                    }else{
                        self.viewNoData.isHidden = false
                   
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }

    }

    @IBAction func onClickAddVehicle(_ sender: UIButton) {
        
//        let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idAddVehicleVC") as! AddVehicleVC
//        vc.strQRcodeId = "5" ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)

        
        let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idScanQrVC")as! ScanQrVC
        vc.delegate = self
        vc.iscomefrom = "My"
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        
    }
 
    
}

extension TabMyVehicleVC:  QRCodeValidateDelegate {
      
    func passdata(qrcodeId: String?, apicall: String) {
        print(qrcodeId!)
//        self.showProgress()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.hideProgress()
            let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idAddVehicleVC") as! AddVehicleVC
            vc.strQRcodeId = qrcodeId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TabMyVehicleVC :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "my_vehicle"))
    }
}

extension TabMyVehicleVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvdata.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! VehicleCell
        let data = filterRequestList[indexPath.row]
      //  cell.ViewEditDlt.isHidden = true
        cell.lblCompanyName.text = data.companyname
        cell.lblVehicleNumber.text = data.vehiclenumber
       //cell.lblMobileNumber.text = data.usermobile
        cell.lblVehicleName.text = data.user_fullname
        
        
        if let vehiclestatus = data.vehicle_status
        {
            if vehiclestatus == "1"
            {
                cell.lblvehiclestatus.text = doGetValueLanguage(forKey: "approve")
            }
            else{
                cell.lblvehiclestatus.text = doGetValueLanguage(forKey: "pending")
            }
            
        }
        
        
        
        cell.lbVehicleNameTitle.text = "\(doGetValueLanguage(forKey: "name")) :"
        cell.lbCompanyNameTitle.text = "\(doGetValueLanguage(forKey: "company_name")) :"
        cell.lbMobileNumberTitle.text = "\(doGetValueLanguage(forKey: "mobile_no")) :"
        
        var rect: CGRect =  cell.lbCompanyNameTitle.frame //get frame of label
        rect.size = (cell.lbCompanyNameTitle.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name:  cell.lbCompanyNameTitle.font.fontName , size:  cell.lbCompanyNameTitle.font.pointSize)!]))! //Calculate as per label font
        cell.widthcompanyname.constant = rect.width + 4
       
        
        cell.lbMobileNumberTitle.isHidden = true
        cell.lblMobileNumber.isHidden = true
        cell.lblnumberbottom.isHidden = true
        cell.Heightlbmobile.constant = 0
        cell.heigthlblmobileval.constant = 0
        
        cell.btnimgshow.addTarget(self, action: #selector(btnOpenImage(sender:)), for: .touchUpInside)
        cell.btnimgshow.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnQrCode.addTarget(self, action: #selector(btnscanqr(sender:)), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(btnedit(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(btndlt(sender:)), for: .touchUpInside)
        
        cell.btncall.addTarget(self, action: #selector(btncall(sender:)), for: .touchUpInside)
        cell.btncall.tag = indexPath.row
        StrAttachments = filterRequestList[indexPath.row].vehicleqrcode ?? ""
        if data.vehicletype == "0"{
            cell.ivVehicleType.setImageWithTint(ImageName: "ic_car", TintColor: ColorConstant.primaryColor)
        }else {
            cell.ivVehicleType.setImageWithTint(ImageName: "ic_bike", TintColor: ColorConstant.primaryColor)
        }
        
        
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: data.vehiclephoto, palceHolder: "banner_placeholder")
        cell.selectionStyle = .none
        return cell
    }
    func gotoScanner() {
       
        
        let nextVC = ScanQrVC(nibName: "ScanQrVC", bundle: nil)
     //  nextVC.delegate = self
        pushVC(vc: nextVC)
    }
    @objc func btncall(sender : UIButton) {
       //dovehicleEdit()
       
        let data = filterRequestList[sender.tag]
        if data.usermobile != ""
        {
            
            doCall(on: data.usermobile!)
          
        }
    
        }
    @objc func btnedit(sender : UIButton) {
       //dovehicleEdit()
       
    
            selectedDataTable = sender.tag
            let vc = self.storyboard?.mainStory().instantiateViewController(withIdentifier: "idAddVehicleVC")as! AddVehicleVC
            let data = AllVehicleList[sender.tag]
            vc.vechilesModelEditFromParking = data
            vc.isComeFromParking = "1"
            vc.initForUpdate = true
            pushVC(vc: vc)
           
        }
    @objc func btndlt(sender : UIButton) {
      
        print(sender.tag)
        selectedDataTable = sender.tag
       
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel").uppercased(),okText : doGetValueLanguage(forKey: "delete").uppercased())
        
    }
    @objc func btnscanqr(sender : UIButton) {
           
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
              nextVC.imagePath = StrAttachments
            pushVC(vc: nextVC)
        
    }
    
    @objc func btnOpenImage(sender : UIButton) {
       //dovehicleEdit()
       
        let data = filterRequestList[sender.tag]
        if data.vehiclephoto != ""
        {
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
                  nextVC.imagePath = data.vehiclephoto
            nextVC.iscomefrom = "vehicle"
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true)
        
        }
    
        }
           
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
func tapDelete(sender :UIButton) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete, tag: sender.tag , cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }

    func convertDateFormater(_ date: String) -> String
        {
            print("date " , date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MMMM-dd"
            return  dateFormatter.string(from: date!)
        }
    
}

