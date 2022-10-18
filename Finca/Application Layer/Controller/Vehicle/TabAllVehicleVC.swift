//
//  TabAllVehicleVC.swift
//  Finca
//
//  Created by CHPL Group on 07/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher
import Alamofire
import Lightbox

class TabAllVehicleVC: BaseVC {
    
    
    var strapicall = ""
    @IBOutlet weak var btnclear: UIButton!
    @IBOutlet weak var imgQr: UIImageView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    var menuTitle : String!
    var StrAttachments = ""
    @IBOutlet weak var viewNoData: UIView!
  //  @IBOutlet weak var cvdata: UICollectionView!
    @IBOutlet weak var tbvdata: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
   let itemcell = "VehicleCell"
    var filterRequestList = [list]()
    var AllVehicleList = [list]()
    var pushClouser : (()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvdata.delegate = self
       // doneButtonOnKeyboard(textField: tfSearch)
        tbvdata.dataSource = self
        viewNoData.isHidden = true
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvdata.register(nib, forCellReuseIdentifier: itemcell)
        addRefreshControlTo(tableView: tbvdata)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle),palceHolder: "")
        tfSearch.text = ""
        tfSearch.delegate = self
       // tfSearch.text = UserDefaults.standard.string(forKey: "Number")
        tbvdata.reloadData()
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        tbvdata.reloadData()
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_by_vehicle_number")
        lbTitle.text = doGetValueLanguage(forKey: "no_data")
        
        btnclear.isHidden = true
       
        
       
        self.dovehicleList()
             
       
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
 
        
        
        tbvdata.reloadData()
        if filterRequestList.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
        
        tbvdata.reloadData()
      }
    override func fetchNewDataOnRefresh() {
          tfSearch.text = ""
          view.endEditing(true)
         
          refreshControl.beginRefreshing()
         
          refreshControl.endRefreshing()
      }
    func dovehicleList() {
        showProgress()
        
        let params = ["key":apiKey(),
                      "getVehicleList":"getVehicleList",
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
   
      func doDeleteVehicle(vehicleUserId:String!,index:Int!){
          self.showProgress()
          let params = ["key":apiKey(),
                        "deleteVehicle":"deleteVehicle",
                        "users_vehicle_id":vehicleUserId!,
                        "user_id":doGetLocalDataUser().userID!,
                        "society_id":doGetLocalDataUser().societyID!,
                        "unit_id":doGetLocalDataUser().unitID!,
                        "language_id":doGetLanguageId(),
                        "block_id":doGetLocalDataUser().blockID!,
                        "user_name":doGetLocalDataUser().userFirstName!,
                        "blockUnitName":doGetLocalDataUser().blockName!]
          print("param" , params)
          let requrest = AlamofireSingleTon.sharedInstance
          requrest.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { [self] (json, error) in
              self.hideProgress()
              if json != nil {
                  do {
                      let response = try JSONDecoder().decode(vehicleResponse.self, from:json!)
                      if response.status == "200" {
                          self.AllVehicleList.remove(at: index)
                          tbvdata.reloadData()
                          
                      }else {
                          
                      }
                  } catch {
                      print("parse error")
                  }
              }
          }
      }
    
    @IBAction func btnclearAction(_ sender: Any) {
        self.btnclear.isHidden = true
        self.tfSearch.resignFirstResponder()
        self.tfSearch.text = ""
        self.filterRequestList = self.AllVehicleList
        
        if self.filterRequestList.count != 0{
            self.viewNoData.isHidden = true
        }else{
            self.viewNoData.isHidden = false
        }
               
        
        self.tbvdata.reloadData()
        
    }
    
    @IBAction func onClickScanQR(_ sender: UIButton) {
        let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idScanQrVC")as! ScanQrVC
        vc.delegate = self
        vc.iscomefrom = "All"
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        
        }
}

extension TabAllVehicleVC:  QRCodeValidateDelegate{
    
    func passdata(qrcodeId: String?, apicall: String) {
        print(qrcodeId!)
        
        self.strapicall = apicall
        // GJ01JK2525
       // DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            tfSearch.text = ""
            filterRequestList = AllVehicleList
            filterRequestList = qrcodeId!.isEmpty ? AllVehicleList : AllVehicleList.filter({ item in
                return item.generate_number.lowercased().range(of: (qrcodeId ?? "" ).lowercased()) != nil
            })
            tbvdata.reloadData()

            print(filterRequestList.count)
            if filterRequestList.count == 0 {
                viewNoData.isHidden = false
                self.btnclear.isHidden = false
            } else {
                self.btnclear.isHidden = false
                viewNoData.isHidden = true
            }
            
            tbvdata.reloadData()
       // }
        
    }
}
extension TabAllVehicleVC :  IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "all_vehicle"))
    }
}


extension TabAllVehicleVC : UITableViewDelegate,UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvdata.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! VehicleCell
        let data = filterRequestList[indexPath.row]
        cell.ViewEditDlt.isHidden = true
        
        cell.viewpending.isHidden = true
        cell.Topconstrainview.constant = 15
        
        
        cell.lbVehicleNameTitle.text = "\(doGetValueLanguage(forKey: "name")) :"
        cell.lbCompanyNameTitle.text = "\(doGetValueLanguage(forKey: "company_name")) :"
        cell.lbMobileNumberTitle.text = "\(doGetValueLanguage(forKey: "mobile_no")) :"
        
        var rect: CGRect =  cell.lbCompanyNameTitle.frame //get frame of label
        rect.size = (cell.lbCompanyNameTitle.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name:  cell.lbCompanyNameTitle.font.fontName , size:  cell.lbCompanyNameTitle.font.pointSize)!]))! //Calculate as per label font
        cell.widthcompanyname.constant = rect.width + 4
       
        cell.lblCompanyName.text = data.companyname
        cell.lblVehicleNumber.text = data.vehiclenumber
        cell.lblMobileNumber.text = data.usermobile
        cell.lblVehicleName.text = data.user_fullname
        StrAttachments = filterRequestList[indexPath.row].vehicleqrcode ?? ""
        
        if data.usermobile.contains("*") {
            cell.btncall.isUserInteractionEnabled = false
            cell.lblnumberbottom.isHidden = true
        }
        else {
            cell.btncall.isUserInteractionEnabled = true
            cell.lblnumberbottom.isHidden = false
        }
        
       
      
        cell.btnimgshow.addTarget(self, action: #selector(btnOpenImage(sender:)), for: .touchUpInside)
        cell.btnimgshow.tag = indexPath.row
        
        cell.btncall.addTarget(self, action: #selector(btncall(sender:)), for: .touchUpInside)
        cell.btncall.tag = indexPath.row
        
      
        if data.vehicletype == "0"{
          
          cell.ivVehicleType.setImageWithTint(ImageName: "ic_car", TintColor: ColorConstant.primaryColor)
            
        }else {
           
            cell.ivVehicleType.setImageWithTint(ImageName: "ic_bike", TintColor: ColorConstant.primaryColor)
        }
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: data.vehiclephoto, palceHolder: "banner_placeholder")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    } 
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
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
           
          //  parent?.present(controller, animated: true, completion: nil)
        }
    
        }
    
    @objc func btncall(sender : UIButton) {
       //dovehicleEdit()
       
        let data = filterRequestList[sender.tag]
        if data.usermobile != ""
        {
            
            doCall(on: data.usermobile!)
          
        }
    
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
extension TabAllVehicleVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {

                    let data = self.filterRequestList[tag]
                    self.doDeleteVehicle(vehicleUserId: data.vehicle_id, index: tag)


        }
    }
}
}
