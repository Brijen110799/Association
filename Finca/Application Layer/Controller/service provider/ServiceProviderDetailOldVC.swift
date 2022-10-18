//
//  ServiceProviderDetailOldVC.swift
//  Finca
//
//  Created by CHPL Group on 27/10/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation


class ServiceProviderDetailOldVC: BaseVC {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tbvServiceProviderOptions: UITableView!
    var selectedID = [String]()
    var serviceProvider = [LocalServiceProviderListModel]()
    var filteredArray = [LocalServiceProviderListModel]()
    var serviceProviderDetail : LocalServiceProviderModel!
    var subProviderDetail : LocalServiceSubProviderModel!
    var headingText : String!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let itemCell = "ServiceProviderDetailCell"
    var selectedIndex = -1
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblNoDataDescription: UILabel!
    @IBOutlet weak var lblRequestForCallBack: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeading.text = headingText
        doCallServiceProviderDetail()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvServiceProviderOptions.register(nib, forCellReuseIdentifier: itemCell)
        tbvServiceProviderOptions.delegate = self
        tbvServiceProviderOptions.dataSource = self
        tbvServiceProviderOptions.estimatedRowHeight = 150
        tbvServiceProviderOptions.rowHeight = UITableView.automaticDimension
        addRefreshControlTo(tableView: tbvServiceProviderOptions)
        tbvServiceProviderOptions.allowsMultipleSelection = true
        lblRequestForCallBack.text = doGetValueLanguage(forKey: "request_for_callback")
        lblNoDataDescription.text = doGetValueLanguage(forKey: "no_service_provider_available")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @IBAction func onClickLocation(_ sender: UIButton) {
        if  permission(){
        let vc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idNearByMeServiceProviderVC")as! NearByMeServiceProviderVC
       // vc.selecteddata = serviceProviderDetail
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
        serviceProvider.removeAll()
        filteredArray.removeAll()
        tbvServiceProviderOptions.reloadData()
        refreshControl.beginRefreshing()
        doCallServiceProviderDetail()
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doCallServiceProviderDetail(){
        self.showProgress()
        var providerId = ""
        var subProviderId = "0"
        if subProviderDetail != nil{
            providerId = self.serviceProviderDetail.localServiceProviderID
            subProviderId = self.subProviderDetail.localServiceProviderSubId
        }else{
            
            providerId = self.serviceProviderDetail.localServiceProviderID
        }
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getServiceProviderUser":"getServiceProviderUser",
                      "user_latitude":doGetLocalDataUser().societyLatitude!,
                      "user_longitude":doGetLocalDataUser().societyLongitude!,
                      "user_id":doGetLocalDataUser().userID!,
                      "local_service_provider_id":providerId,
                      "local_service_provider_sub_id": subProviderId,
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!]
        
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

                        self.serviceProvider.append(contentsOf: response.localServiceProvider)

                        for (index,_) in self.serviceProvider.enumerated(){
                            self.serviceProvider[index].isCheck = true
                        }
                        self.filteredArray = self.serviceProvider
                        self.tbvServiceProviderOptions.reloadData()
                    }
                }catch{
                    print("parse error", error as Any)
                }
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
        nextVC.serviceProvider = serviceProviderDetail
        nextVC.subProviderDetail = subProviderDetail
        nextVC.isUpdate = false
        nextVC.row = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
//
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
    
}
extension ServiceProviderDetailOldVC:UITableViewDelegate ,UITableViewDataSource,ServiceProviderDelegate{

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

        if filteredArray.count != 0{
            viewNoData.isHidden = true
        }else{
            viewNoData.isHidden = false
            lblNoDataDescription.text = "No Service Providers Found!!"
        }
        return filteredArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvServiceProviderOptions.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ServiceProviderDetailCell
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 10
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.masksToBounds = true
        Utils.setImageFromUrl(imageView: cell.imgServieProvider, urlString: filteredArray[indexPath.row].serviceProviderUserImage, palceHolder: "fincasys_notext")
      //  print("images is==",filteredArray[indexPath.row].serviceProviderUserImage)
        cell.lblAddress.text = filteredArray[indexPath.row].serviceProviderAddress
        cell.lblName.text = filteredArray[indexPath.row].serviceProviderName
        cell.lblPhoneNumber.text = filteredArray[indexPath.row].service_provider_phone_view
        cell.lblDistance.text = filteredArray[indexPath.row].distance_in_km
        cell.delegate = self
        cell.indexPath = indexPath
        cell.lbCategory.text =  filteredArray[indexPath.row].service_provider_category_name ?? ""
        if filteredArray[indexPath.row].serviceProviderEmail != nil && filteredArray[indexPath.row].serviceProviderEmail != "" {
            cell.lblEmail.text = filteredArray[indexPath.row].serviceProviderEmail
            cell.viewMail.isHidden  = false
        } else {
            cell.viewMail.isHidden  = true
        }
        // cell.btnIsCheck.tag = indexPath.row

        // cell.btnIsCheck.addTarget(self, action: #selector(onClickCheck(sender:)), for: .touchUpInside)

        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
//
        cell.bEmail.tag = indexPath.row
        cell.bEmail.addTarget(self, action: #selector(onClickEmail(sender:)), for: .touchUpInside)
        cell.bViewProfile.tag = indexPath.row
        cell.bViewProfile.addTarget(self, action: #selector(onTapDetails(sender:)), for: .touchUpInside)
        cell.bLocation.tag = indexPath.row
        cell.bLocation.addTarget(self, action: #selector(openMapForPlace(sender:)), for: .touchUpInside)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if filteredArray[indexPath.row].isCheck{
            cell.imgIsVerified.image = UIImage(named: "check_box")
            // cell.imgIsVerified.tintColor = UIColor(named: "ColorPrimary")
            cell.imgIsVerified.setImageColor(color: UIColor(named: "ColorPrimary")!)
            //        imgIsVerified.image = imgIsVerified.image?.withRenderingMode(.alwaysTemplate)
        }else{
            cell.imgIsVerified.image = UIImage(named: "check_box_uncheck")
            //  cell.imgIsVerified.tintColor = UIColor(named: "ColorPrimary")
            cell.imgIsVerified.setImageColor(color: UIColor(named: "ColorPrimary")!)
        }
        if filteredArray[indexPath.row].isKyc == "1" {
            //verified
            cell.ivVerified.isHidden = false
        } else {
            cell.ivVerified.isHidden = true
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = serviceProvider[indexPath.row]
        nextVC.serviceProvider = serviceProviderDetail
        nextVC.subProviderDetail = subProviderDetail
        nextVC.isUpdate = false
        nextVC.row = indexPath.row
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

    
    @objc func onTapDetails(sender : UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = serviceProvider[sender.tag]
        nextVC.serviceProvider = serviceProviderDetail
        nextVC.subProviderDetail = subProviderDetail
        nextVC.isUpdate = false
        nextVC.row = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}

extension ServiceProviderDetailOldVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
            self.doCallApiForCallback(callBackIDs: serviceProviderDetail.localServiceProviderID)
        }
    }
}
