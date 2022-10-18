//
//  ClickedServiceProviderDetailVC.swift
//  Finca
//
//  Created by Jay Patel on 12/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
struct CommonDistanseResponse : Codable{
    let distance:String! // " Ashram Road - 8.79 km",
    let message:String! // "Distance Calculated Successfully",
    let status:String! // "200"
}
class ClickedServiceProviderDetailVC: BaseVC,CLLocationManagerDelegate {
    //    var newResponse: LocalServiceProviderListModel!
    //    var totalRating: String!
    var row: Int!
    var isUpdate = false
    var userRating = 0.0
    var distanceData : String!
    var newServiceProviderDetail = [LocalServiceProviderListModel]()
    var serviceProviderDetail : LocalServiceProviderListModel!
    var serviceProvider : LocalServiceProviderModel!
    var subProviderDetail : LocalServiceSubProviderModel!
    var indexSelect = -1
    @IBOutlet var lblServiceProviderName: UILabel!
    @IBOutlet var imgServiceProvider: UIImageView!
    @IBOutlet var lblServiceProviderDistance: UILabel!
    @IBOutlet var UserRatingBar: CosmosView!
    @IBOutlet var lblTopHeading: UILabel!
    @IBOutlet var lblRatingNumber: UILabel!
    @IBOutlet var viewRatingStar: CosmosView!
    @IBOutlet var lblNumberOfRating: UILabel!
    @IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblOpenTime: UILabel!
    @IBOutlet weak var lblSatus: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    @IBOutlet weak var ivVerfied: UIImageView!
    @IBOutlet weak var conWidthVerified: NSLayoutConstraint!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var ivChat: UIImageView!
    @IBOutlet weak var VwWebsite:UIView!
    @IBOutlet weak var lblWebsite:UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblRateThis: UILabel!
    @IBOutlet weak var btnReportComplain: UIButton!
    @IBOutlet weak var lblRequestForCallBack: UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var VwNotes:UIView!
    
    @IBOutlet weak var lbBroucher: UILabel!
    @IBOutlet weak var viewBroucher: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var lbCategory: UILabel!
    var selectedIndex = -1
    var service_provider_users_id = ""
    let request = AlamofireSingleTon.sharedInstance
    let locationManager = CLLocationManager()
    var latPass = ""
    var langPass = ""
    
    @IBOutlet weak var viewcallback: UIView!
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var txtmobilenumber: UITextField!
    @IBOutlet weak var lblmobilenumbertitle: UILabel!
    @IBOutlet weak var lblcallbacktitle: UILabel!
    var countryList = CountryList()
    var countryName = "India"
    var countryCode = "Ind"
    var country_code = ""
   
    @IBOutlet weak var btndonetitle: UIButton!
    @IBOutlet weak var btncanceltitle: UIButton!
    
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
        self.viewcallback.isHidden = true
        print(row as Any)
        self.viewMain.layer.maskedCorners = [.layerMinXMinYCorner]
        
        locationManager.delegate = self
        txtmobilenumber.keyboardType = .numberPad
        countryList.delegate = self
        doneButtonOnKeyboard(textField: txtmobilenumber)
        txtmobilenumber.placeholder = doGetValueLanguage(forKey: "enter_your_mobile_number")
        lblmobilenumbertitle.text = doGetValueLanguage(forKey: "call_back_mobile")
        
        btndonetitle.setTitle(doGetValueLanguage(forKey: "yes"), for: .normal)
        btncanceltitle.setTitle(doGetValueLanguage(forKey: "no"), for: .normal)
        lblcallbacktitle.text = doGetValueLanguage(forKey: "callback_to_service_provider")
        
       
    }
    func setDefultCountry(){
        let localRegion =  Locale.current.regionCode
        let count = Countries()
        for item in count.countries {
            if item.countryCode == localRegion{
                lblcountrycode.text = self.country_code
                self.countryName = item.name!
                self.countryCode = item.countryCode
                self.country_code =  "+\(item.phoneExtension)"
                break
            }
        }
    }
    
    private func showAlertMsg(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                    
                   
                    self.loadLocation()
                    
                    
                })
            }
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            self.doPopBAck()
        }))
        self.present(alert, animated: true)
    }
  
    func  loadLocation() {
           // Ask for Authorisation from the User.
           self.locationManager.requestAlwaysAuthorization()
           // For use in foreground
           self.locationManager.requestWhenInUseAuthorization()
           
           if CLLocationManager.locationServicesEnabled() {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               locationManager.startUpdatingLocation()
           }
           
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if (locations.last != nil) {
            
            DispatchQueue.main.async {
                
                self.locationManager.stopUpdatingLocation()
            }
            
            //print("lkdlskd \(locValue.latitude)")
            if latPass == "" {
                latPass = String(locValue.latitude)
                langPass = String(locValue.longitude)
                
                if serviceProviderDetail == nil && service_provider_users_id != "" {
                    
                    doGetSPDetails()
                }
            }
           
        }
    
     }
    override func viewWillAppear(_ animated: Bool) {
        lblCall.text = doGetValueLanguage(forKey: "call")
        lblShare.text = doGetValueLanguage(forKey: "share")
        lblEmail.text = doGetValueLanguage(forKey: "email_contact_finca")
        lblLocation.text = doGetValueLanguage(forKey: "direction")
        lblRateThis.text = doGetValueLanguage(forKey: "rate_this")
        lblRequestForCallBack.text = doGetValueLanguage(forKey: "request_for_callback").uppercased()
        btnReportComplain.setTitle(doGetValueLanguage(forKey: "btn_report_serviceprovider").uppercased(), for: .normal)
        lbBroucher.text = doGetValueLanguage(forKey: "brochure")
        lblcallbacktitle.text = doGetValueLanguage(forKey: "callback_to_service_provider")
        
        if serviceProviderDetail != nil {
            setData()
            
            if serviceProviderDetail.token != nil &&  serviceProviderDetail.token != "" {
                ivChat.image = UIImage(named: "chat")
                lblEmail.text = doGetValueLanguage(forKey: "chat")
             } else {
                ivChat.image = UIImage(named: "mail")
                 lblEmail.text = doGetValueLanguage(forKey: "email_contact_finca")
            }
            ivChat.setImageColor(color: ColorConstant.colorP)
        }
        
//        doCallServiceProviderDetail()
//        lblNumberOfRating.text = totalRating+" Rating"
        //
//        if newResponse.totalRatings != nil {
//            lblNumberOfRating.text = newResponse.totalRatings+" Rating"
//
//        }else{
//            lblNumberOfRating.text = "0 Rating"
//        }
      
       
        
      
        
       
        
        
        checkLocationIsOn()
        
    }
    
    func checkLocationIsOn() {
        
       
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                    
                case .notDetermined:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    self.loadLocation()
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }
       
    }
    
    func setData() {
        lblOpenTime.text = serviceProviderDetail.timing
        lblSatus.text = serviceProviderDetail.openStatus
       
        lbCategory.text = serviceProviderDetail.service_provider_category_name ?? ""
        
        if serviceProviderDetail.sp_webiste != nil && serviceProviderDetail.sp_webiste != ""
        {
            VwWebsite.isHidden = false
            lblWebsite.text = doGetValueLanguage(forKey: "website")
        }else
        {
            VwWebsite.isHidden = true
        }
        if serviceProviderDetail.work_description != nil && serviceProviderDetail.work_description != "" {
            VwNotes.isHidden = false
            lblDescription.text = serviceProviderDetail.work_description
        }else
        {
            VwNotes.isHidden = true
        }
        if isUpdate == false {
            if serviceProviderDetail.userPreviousRating != ""{
                UserRatingBar.rating = Double(serviceProviderDetail.userPreviousRating!)!
            }else{
                UserRatingBar.rating = 0.0
            }
        }else{
            UserRatingBar.rating = userRating
        }
        
        if serviceProviderDetail.brochure_profile ?? ""  != "" {
            viewBroucher.isHidden = false
        } else {
            viewBroucher.isHidden = true
        }
        
        if serviceProviderDetail.serviceProviderEmail ?? ""  != "" {
            viewEmail.isHidden = false
        } else {
            viewEmail.isHidden = true
        }
        
        
        viewRatingStar.settings.fillMode = .half
        UserRatingBar.rating = userRating
        lblNumberOfRating.text = serviceProviderDetail.totalRatings+" Rating"
        lblRatingNumber.text = serviceProviderDetail.averageRating
        viewRatingStar.rating = Double(serviceProviderDetail.averageRating!)!
        lblServiceProviderDistance.text = serviceProviderDetail.distance_in_km ?? ""
        //lblTopHeading.text! = serviceProviderDetail.serviceProviderName
        lblServiceProviderName.text! = serviceProviderDetail.serviceProviderName
        lblTopHeading.text! = serviceProviderDetail.serviceProviderName
        Utils.setImageFromUrl(imageView: imgServiceProvider, urlString: serviceProviderDetail.serviceProviderUserImage)
        lblMobileNumber.text! = serviceProviderDetail.service_provider_phone_view
        lblAddress.text! = serviceProviderDetail.serviceProviderAddress
        lbEmail.text! = serviceProviderDetail.serviceProviderEmail
        if serviceProviderDetail.userPreviousRating == ""{
            UserRatingBar.rating = 0
        }else{
            UserRatingBar.rating = Double(serviceProviderDetail.userPreviousRating!)!
        }
        if serviceProviderDetail.isKyc == "1"{
            ivVerfied.isHidden = false
            conWidthVerified.constant  = 20
        }else {
            ivVerfied.isHidden = true
            conWidthVerified.constant  = 0
        }
    }
    func doCallServiceProviderDetail(){
        self.showProgress()
        var providerId = ""
        var subProviderId = "0"
        if subProviderDetail != nil{
            providerId = self.serviceProvider.localServiceProviderID
            subProviderId = self.subProviderDetail.localServiceProviderSubId
        }else{
            
            providerId = self.serviceProvider.localServiceProviderID
        }
//        showProgress()
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
        
      
        request.requestPostCommon(serviceName: ServiceNameConstants.LSPController, parameters: params, completionHandler: { (json, error) in
                
                self.hideProgress()
                if json != nil {
//                    self.hideProgress()
                    print(json as Any)
                    print("something")
                    do {
                        print("something")
                        let response = try JSONDecoder().decode(LocalServiceProviderListResponse.self, from:json!)
                        if response.status == "200" {
                        //    for item in response.localServiceProvider{
//                                self.totalRating = item.totalRatings!
//                                print("totalRating is====",self.totalRating)
                         //   }
//                            self.newResponse = response.localServiceProvider[self.row]
//                            self.newResponse = self.newServiceProviderDetail[self.row]
                            
                            
                            
                            
//                            self.filteredArray = self.serviceProvider
//                            self.tbvServiceProviderOptions.reloadData()
                        }
                    } catch {
                        print("parse error")
                    }
                }
            })
    }

    func doCallApiForCallback(callBackIDs:String!){
          
          self.showProgress()
          let params = ["key":ServiceNameConstants.API_KEY,
                        "addCallRequest":"addCallRequest",
                        "local_service_provider_users_id":callBackIDs!,
                        "user_id":doGetLocalDataUser().userID!,
                        "user_mobile":txtmobilenumber.text!,
                        "user_name":doGetLocalDataUser().userFullName!,
                        "society_id":doGetLocalDataUser().societyID!,
                        "country_code":self.countryCode]
          
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
                          self.viewcallback.isHidden = true
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
    @IBAction func btnRequestForCallback(_ sender: UIButton){
        
        
        self.txtmobilenumber.text = doGetLocalDataUser().userMobile!
        self.lblcountrycode.text =  doGetLocalDataUser().countryCode!
      
       
        if serviceProviderDetail != nil {
            self.viewcallback.isHidden = false
//            showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "\(doGetValueLanguage(forKey: "callback_to_service_provider"))", style: .Info, tag: 1, cancelText: "\(doGetValueLanguage(forKey: "no"))", okText: "\(doGetValueLanguage(forKey: "yes"))")
//
//            selectedIndex = sender.tag
            
        } else {
            checkLocationIsOn()
        }
        
    }
    
    @IBAction func btnReportComplain(_ sender: Any) {
        if serviceProviderDetail != nil {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "idReport_ComplainServiceProviderDialogVC")as!Report_ComplainServiceProviderDialogVC
            vc.data = serviceProviderDetail
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            addChild(vc)  // add child for main view
            view.addSubview(vc.view)
        } else {
            checkLocationIsOn()
        }
    }
    @IBAction func btnGiveRating(_ sender: Any) {
        if serviceProviderDetail != nil {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "idReviewServiceProviderDialogVC")as!ReviewServiceProviderDialogVC
            vc.data = serviceProviderDetail
            vc.vc = self
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            addChild(vc)  // add child for main view
            view.addSubview(vc.view)
        } else {
            checkLocationIsOn()
        }
    }
    @IBAction func btnWebsite(_ sender:Any) {
        if serviceProviderDetail != nil {
            if serviceProviderDetail.sp_webiste.contains("http://")  ||  serviceProviderDetail.sp_webiste.contains("https://")
            {
                guard let url = URL(string:serviceProviderDetail.sp_webiste) else { return }
                UIApplication.shared.open(url)
            }else
            {
                guard let url = URL(string:"https://"+serviceProviderDetail.sp_webiste) else { return }
                UIApplication.shared.open(url)
            }
        } else {
            checkLocationIsOn()
        }
        
    }
    
    @IBAction func tapBroucher(_ sender:Any){
        if serviceProviderDetail != nil {
            guard let url = URL(string:serviceProviderDetail.brochure_profile ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            checkLocationIsOn()
        }
        
    }
    
    
    @IBAction func btncancelAction(_ sender: Any) {
        self.viewcallback.isHidden = true
    }
    @IBAction func btndoneAction(_ sender: Any) {
        
        self.doCallApiForCallback(callBackIDs: self.serviceProviderDetail.serviceProviderUsersID)
    }
    @IBAction func btncountrycodeAction(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func btnShare(_ sender: Any) {
//        if serviceProviderDetail != nil {
//        let text =  "\(serviceProviderDetail.serviceProviderName!) \(serviceProviderDetail.serviceProviderEmail!) \(serviceProviderDetail.serviceProviderPhone!)  \(serviceProviderDetail.serviceProviderAddress!) "
//        let textShare = [ text ]
//        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
//        } else {
//            checkLocationIsOn()
//        }
        
        if serviceProviderDetail != nil {
            
            let vc  = VendorShareVC()
            vc.serviceProviderDetail = serviceProviderDetail
            vc.view.frame = view.frame
            addPopView(vc: vc)
        }
        
    }
    @IBAction func btnLocation(_ sender: Any) {
        
        if serviceProviderDetail != nil {
            let lat = Double(serviceProviderDetail.serviceProviderLatitude!)
            let lng = Double(serviceProviderDetail.serviceProviderLogitude!)
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
            mapItem.name = serviceProviderDetail.serviceProviderName
            mapItem.openInMaps(launchOptions: options)
        } else {
            checkLocationIsOn()
        }
    }
    @IBAction func btnEmail(_ sender: Any) {
        
        if serviceProviderDetail != nil {
            if serviceProviderDetail.serviceProviderEmail ?? ""  != "" {
                let email = serviceProviderDetail.serviceProviderEmail!
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } else {
                showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "email_service_not_available"))
            }
            
        } else {
            checkLocationIsOn()
        }
    }
    @IBAction func btnCall(_ sender: Any) {
        
        if serviceProviderDetail != nil {
            let phone = serviceProviderDetail.service_provider_phone_view!
            doCall(on: phone)
        } else {
            checkLocationIsOn()
        }
       
        
//        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onTapPhoto(_ sender: Any) {
        let url = serviceProviderDetail.serviceProviderUserImage
        if url == nil && url == "" {
            return
        }
       // print("dsdsd " , url)
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
        nextVC.imagePath = url!
        pushVC(vc: nextVC)
    }
    private func doGetSPDetails() {
        showProgress()
        
        let params = ["getVendorDetails":"getVendorDetails",
                      "service_provider_users_id":service_provider_users_id,
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "user_latitude":latPass,
                      "user_longitude":langPass]
        print("params \(params)")
        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(LocalServiceProviderListResponse.self, from: Data!)
                    if response.status == "200"{
                        self.serviceProviderDetail = response.localServiceProvider[0]
                        self.setData()
                        
                    }else {
                        self.showAlertMessageWithClick(title: "", msg: response.message)
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
        
    }
    override func onClickDone() {
        doPopBAck()
    }
}
extension ClickedServiceProviderDetailVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
            self.doCallApiForCallback(callBackIDs: self.serviceProviderDetail.serviceProviderUsersID)
        }
    }
}
extension ClickedServiceProviderDetailVC : CountryListDelegate {
    func selectedCountry(country: Country) {
      //  lblCountryNameCode.text = "\(country.flag!) +\(country.phoneExtension)"
        //lblCountryNameCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
        self.countryName = country.name!
        self.countryCode = country.countryCode
        self.country_code = "+\(country.phoneExtension)"
        lblcountrycode.text = self.country_code
      
    }
    func selectedAltCountry(country: Country) {
       
    }
}
