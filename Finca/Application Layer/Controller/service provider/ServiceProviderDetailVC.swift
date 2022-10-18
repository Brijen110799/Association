//
//  ServiceProviderDetailVC.swift
//  Finca
//
//  Created by harsh panchal on 26/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation


class ServiceProviderDetailVC: BaseVC {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tbvServiceProviderOptions: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblNoDataDescription: UILabel!
    @IBOutlet weak var ivFilter: UIImageView!
 
    var selectedID = [String]()
    var serviceProvider = [LocalServiceProviderListModel]()
    var filteredArray = [LocalServiceProviderListModel]()
    //var serviceProviderDetail : LocalServiceProviderModel!
   // var subProviderDetail : LocalServiceSubProviderModel!
    var headingText : String!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let itemCell = "ServiceProviderDetailCell"
    var selectedIndex = -1
    var category = [LocalServiceProviderModel]()
    
     var categoryId = "0"
     var subCategoryId = "0"
     var radius = ""
     var companyName = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMessage(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "idGlobalSearchServiceProviderVC") as! GlobalSearchServiceProviderVC
//                    vc.menuTitle = self.menuTitle
//                    self.pushVC(vc: vc)
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }

        lblHeading.text = headingText
        doCallServiceProviderDetail(local_service_provider_id: "0", local_service_provider_sub_id: "0", search_keyword: "", radius: "")
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvServiceProviderOptions.register(nib, forCellReuseIdentifier: itemCell)
        tbvServiceProviderOptions.delegate = self
        tbvServiceProviderOptions.dataSource = self
        tbvServiceProviderOptions.estimatedRowHeight = 150
        tbvServiceProviderOptions.rowHeight = UITableView.automaticDimension
        addRefreshControlTo(tableView: tbvServiceProviderOptions)
        tbvServiceProviderOptions.allowsMultipleSelection = true
     //   lblRequestForCallBack.text = doGetValueLanguage(forKey: "request_for_callback")
        lblNoDataDescription.text = doGetValueLanguage(forKey: "no_data")
     
       
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: headingText))
        doCallServiceProviderApi()
        tfSearch.placeholder = doGetValueLanguage(forKey: "search")
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filteredArray = textField.text!.isEmpty ? serviceProvider : serviceProvider.filter({ (item:LocalServiceProviderListModel) -> Bool in
            
            return item.serviceProviderName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.service_provider_phone_view.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.service_provider_category_name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
       
        
        if filteredArray.count == 0 {
            self.viewNoData.isHidden = false
        } else {
            self.viewNoData.isHidden = true
        }
        
        tbvServiceProviderOptions.reloadData()
    }
    
    @IBAction func onClickLocation(_ sender: UIButton) {
        if  permission(){
        let vc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idNearByMeServiceProviderVC")as! NearByMeServiceProviderVC
    //    vc.selecteddata = serviceProviderDetail
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnRequestForCallback(_ sender: UIButton) {
        // let selectedRows = tbvServiceProviderOptions.indexPathsForSelectedRows
        var selectedID = ""
        for item in filteredArray{
            if item.isCheck == true {
                if selectedID == ""{
                    selectedID = item.serviceProviderUsersID
                }else{
                    selectedID = selectedID + "," + item.serviceProviderUsersID
                }
            }
        }
        
        if selectedID == ""{
            self.toast(message:"Please Select Atleast One Service Provider!!", type: .Faliure)
        }else{
            //            selectedID = (selectedRows?.map { filteredArray[$0.row].serviceProviderUsersId })
            //            print(selectedID.joined(separator: ","))
            showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "callback_to_service_provider"))", style: .Info, tag: 1, cancelText: "\(doGetValueLanguage(forKey: "no"))", okText: "\(doGetValueLanguage(forKey: "yes"))")
            selectedIndex = sender.tag
//            let alertVC = UIAlertController(title: "Confirmation", message: "Do You really want callback from your selected Service Providers?", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
//                self.dismiss(animated: true, completion: nil)
//            }))
//            alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
//                self.doCallApiForCallback(callBackIDs: selectedID)
//            }))
//            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func doCallApiForCallback(callBackIDs:String!){
        
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addCallRequest":"addCallRequest",
                      "local_service_provider_users_id":callBackIDs!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: ServiceNameConstants.LSPController, parameters: params) { (json, error) in

            self.hideProgress()
            if json != nil {
                self.hideProgress()
                print(json as Any)
                do {

                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.showAlertMessage(title: "", msg:response.message)
                    }else{
                        self.toast(message: response.message, type: .Faliure)
                    }
                } catch {
                    print("parse error")
                }
            }
        }

        
    }
    
    override func fetchNewDataOnRefresh() {
        categoryId = "0"
        subCategoryId = "0"
        radius = ""
        companyName  =  ""
        ivFilter.setImageColor(color: ColorConstant.grey_60)
        tfSearch.text = ""
        serviceProvider.removeAll()
        filteredArray.removeAll()
        tbvServiceProviderOptions.reloadData()
        refreshControl.beginRefreshing()
        doCallServiceProviderDetail(local_service_provider_id: "0", local_service_provider_sub_id: "0", search_keyword: "", radius: "")
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doCallServiceProviderDetail(local_service_provider_id : String , local_service_provider_sub_id : String , search_keyword : String , radius : String ){
        self.showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getServiceProviderUserNew":"getServiceProviderUserNew",
                      "user_latitude":doGetLocalDataUser().societyLatitude!,
                      "user_longitude":doGetLocalDataUser().societyLongitude!,
                      "user_id":doGetLocalDataUser().userID!,
                      "local_service_provider_id":local_service_provider_id,
                      "local_service_provider_sub_id": local_service_provider_sub_id,
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "search_keyword" : search_keyword]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                print(json as Any)
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(LocalServiceProviderListResponse.self, from:json!)
                    if response.status == "200" {
                        self.viewNoData.isHidden = true
                        self.serviceProvider = response.localServiceProvider
                         
                        
                        if radius != "" {
                            var tempList = [LocalServiceProviderListModel]()
                            
                            
                            for item in response.localServiceProvider {
                                
                                if let dist = item.distance_in_km {
                                    var disttance = "0"
                                    
                                    if dist.lowercased().contains("km") {
                                        disttance =  String(dist.split(separator: " ")[0])
                                    }
                                    
                                    
                                    if Double(disttance) ?? 0 <=  Double(radius) ?? 0 {
                                        
                                        tempList.append(item)
                                        
                                    }
                                      
                                }
                                
                                
                            }
                            self.serviceProvider = tempList
                            
//                            if tempList.count > 0 {
//                                self.serviceProvider = tempList
//                            }
                        }
                        
                        self.filteredArray = self.serviceProvider
                        
                        if self.filteredArray.count == 0 {
                            self.viewNoData.isHidden = false
                        } else {
                            self.viewNoData.isHidden = true
                        }
                        self.tbvServiceProviderOptions.reloadData()
                    } else {
                        self.viewNoData.isHidden = false
                        self.filteredArray.removeAll()
                        self.serviceProvider.removeAll()
                        self.tbvServiceProviderOptions.reloadData()
                    }
                }catch{
                    print("parse error", error as Any)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }


    }

    @objc func onClickCall(sender:UIButton) {
        let index = sender.tag

        let phone = filteredArray[index].service_provider_phone_view
        if phone == nil && phone == "" {
            return
        }
        
        doCall(on: phone)
//
//        if let url = URL(string: "tel://\(phone!)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }

    }
    
    @objc func onClickViewProfile(sender:UIButton){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = serviceProvider[sender.tag]
        nextVC.service_provider_users_id = self.serviceProvider[sender.tag].serviceProviderUsersID ?? ""
       nextVC.isUpdate = false
        nextVC.row = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }

    @objc func onClickEmail(sender:UIButton) {
        let index = sender.tag

        let email = filteredArray[index].serviceProviderEmail
        if email == nil && email == "" {
            return
        }
        
        if let url = URL(string: "mailto:\(email!)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func openMapForPlace(sender:UIButton) {

        let index = sender.tag

        let lat = Double(filteredArray[index].serviceProviderLatitude!)
        let lng = Double(filteredArray[index].serviceProviderLogitude!)
        let latitude: CLLocationDegrees = CLLocationDegrees(lat!)
        let longitude: CLLocationDegrees = CLLocationDegrees(lng!)
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = filteredArray[index].serviceProviderName
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func viewWillLayoutSubviews() {

       
    }
    
    
    func permission() -> Bool{
        let isPermision = true
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                
            case .restricted, .denied :
                
                let ac = UIAlertController(title: "Turn on your location setting", message: "1.Select Location > 2.Tap Always or While Using", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default)
                             {
                    (result : UIAlertAction) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .default)
                             {
                    (result : UIAlertAction) -> Void in
                    ac.dismiss(animated: true, completion: nil)
                })
                present(ac, animated: true)
                print("No access")
                
            case .notDetermined:
                
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                print("Access")
                
            @unknown default:
                
                break
                
            }
            
        } else {
            
            print("Location services are not enabled")
            
        }
        
        return isPermision
    }
    @IBAction func btnKeyboardReturnClicked(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapFilter(sender:UIButton) {
        let vc = ServiceProviderFilterVC()
        vc.category = category
        vc.onApplyFilterServiceProvider = self
        vc.categoryId = categoryId
        vc.subCategoryId = subCategoryId
        vc.radius = radius
        vc.companyName = companyName
        
        vc.view.frame = view.frame
        self.addPopView(vc: vc)
    }
    
    func doCallServiceProviderApi() {
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getLocalServiceProviders":"getLocalServiceProviders",
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(LocalServiceProviderResponse.self, from:json!)
                    if response.status == "200" {
                        self.category = response.localServiceProvider
                    } else {
                        self.viewNoData.isHidden = false
                    }
                } catch {
                    print("parse error",error)
                }
            }
        })
    }
    
    
}
extension ServiceProviderDetailVC:UITableViewDelegate ,UITableViewDataSource,ServiceProviderDelegate{

    func checkboxToggleButton(indexPath: IndexPath!) {
//        if filteredArray[indexPath.row].isCheck {
//            filteredArray[indexPath.row].isCheck = false
//
//        }else{
//            filteredArray[indexPath.row].isCheck = true
//        }
//        tbvServiceProviderOptions.reloadData()
        
        //        print("zzxczc")
        //        let cell = tbvServiceProviderOptions.cellForRow(at: indexPath)
        //        if cell!.isSelected{
        //            print("deselect")
        //            cell?.setSelected(false, animated: true)
        //        }else{
        //            print("select")
        //            cell?.setSelected(true, animated: true)
        //        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        if filteredArray.count != 0{
//            viewNoData.isHidden = true
//        }else{
//            viewNoData.isHidden = false
//            lblNoDataDescription.text = "No Service Providers Found!!"
//        }
        return filteredArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvServiceProviderOptions.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ServiceProviderDetailCell
        cell.selectionStyle = .none
        Utils.setImageFromUrl(imageView: cell.imgServieProvider, urlString: filteredArray[indexPath.row].serviceProviderUserImage, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
    
        cell.lblAddress.text = filteredArray[indexPath.row].serviceProviderAddress
        cell.lblName.text = filteredArray[indexPath.row].serviceProviderName
        cell.lblPhoneNumber.text = filteredArray[indexPath.row].service_provider_phone_view
        cell.lblDistance.text = filteredArray[indexPath.row].distance_in_km
        cell.delegate = self
        cell.indexPath = indexPath
        cell.lbCategory.text = filteredArray[indexPath.row].service_provider_category_name ?? ""
        if filteredArray[indexPath.row].serviceProviderEmail != nil && filteredArray[indexPath.row].serviceProviderEmail != "" {
            cell.lblEmail.text = filteredArray[indexPath.row].serviceProviderEmail
            cell.viewMail.isHidden  = false
        } else {
            cell.viewMail.isHidden  = true
        }
   
        setupMarqee(label: cell.lblName)
        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
//
        cell.bEmail.tag = indexPath.row
        cell.bEmail.addTarget(self, action: #selector(onClickEmail(sender:)), for: .touchUpInside)
        cell.bViewProfile.tag = indexPath.row
        cell.bViewProfile.addTarget(self, action: #selector(onTapDetails(sender:)), for: .touchUpInside)
        cell.bLocation.tag = indexPath.row
        cell.bLocation.addTarget(self, action: #selector(openMapForPlace(sender:)), for: .touchUpInside)
        
        if filteredArray[indexPath.row].isKyc == "1" {
            //verified
            cell.ivVerified.isHidden = false
        } else {
            cell.ivVerified.isHidden = true
        }
        
        if filteredArray.count - 1 == indexPath.row {
            cell.bottomContraintView.constant = 120
        } else {
            cell.bottomContraintView.constant = 22
        }
       
        
        let myAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let mail = NSAttributedString(string: filteredArray[indexPath.row].serviceProviderEmail ?? "", attributes: myAttribute)
        cell.lblEmail.attributedText = mail
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = filteredArray[indexPath.row]
       // nextVC.serviceProvider = serviceProviderDetail
       // nextVC.subProviderDetail = subProviderDetail
        nextVC.service_provider_users_id = self.filteredArray[indexPath.row].serviceProviderUsersID ?? ""
      
        nextVC.isUpdate = false
        nextVC.row = indexPath.row
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

    
    @objc func onTapDetails(sender : UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = filteredArray[sender.tag]
        nextVC.service_provider_users_id = self.filteredArray[sender.tag].serviceProviderUsersID ?? ""
      
       // nextVC.serviceProvider = serviceProviderDetail
       // nextVC.subProviderDetail = subProviderDetail
        nextVC.isUpdate = false
        nextVC.row = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}

extension ServiceProviderDetailVC: AppDialogDelegate , OnApplyFilterServiceProvider{
    
    //for filter apply
    func onApplyFilterServiceProvider(categoryId: String, subCategoryId: String, radius: String, companyName: String, isApplyFilter: Bool) {
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.radius = radius
        self.companyName = companyName
        tfSearch.text = ""
        
        if isApplyFilter {
            ivFilter.setImageColor(color: ColorConstant.colorP)
        } else {
            ivFilter.setImageColor(color: ColorConstant.grey_60)
        }
        
        doCallServiceProviderDetail(local_service_provider_id: categoryId, local_service_provider_sub_id: subCategoryId, search_keyword: companyName, radius: radius)
    }
    
       
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
         //   self.doCallApiForCallback(callBackIDs: serviceProviderDetail.localServiceProviderID)
        }
    }
}
