//
//  NearByMeServiceProviderVC.swift
//  Finca
//
//  Created by Hardik on 5/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import DropDown
import MapKit
import GoogleMaps
import CoreLocation

// MARK: - MapDataResponse
struct MapDataResponse: Codable {
    let localServiceProvider: [LocalServiceProvider]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case localServiceProvider = "local_service_provider"
        case message = "message"
        case status = "status"
    }
}

// MARK: - LocalServiceProvider
struct LocalServiceProvider: Codable {
    let serviceProviderUsersId: String!
    let serviceProviderName: String!
    let serviceProviderAddress: String!
    let serviceProviderLatitude: String!
    let serviceProviderLogitude: String!
    let serviceProviderPhone: String!
    let serviceProviderEmail: String!
    let isKyc: String!
    let openStatus: String!
    let timing: String!
    let serviceProviderUserImage: String!
    let totalRatings: String!
    let averageRating: String!
    let userPreviousRating: String!
    let userPreviousComment: String!
    let distance: String!
    let distanceInKm: String!
    
    enum CodingKeys: String, CodingKey {
        case serviceProviderUsersId = "service_provider_users_id"
        case serviceProviderName = "service_provider_name"
        case serviceProviderAddress = "service_provider_address"
        case serviceProviderLatitude = "service_provider_latitude"
        case serviceProviderLogitude = "service_provider_logitude"
        case serviceProviderPhone = "service_provider_phone"
        case serviceProviderEmail = "service_provider_email"
        case isKyc = "is_kyc"
        case openStatus = "openStatus"
        case timing = "timing"
        case serviceProviderUserImage = "service_provider_user_image"
        case totalRatings = "totalRatings"
        case averageRating = "averageRating"
        case userPreviousRating = "userPreviousRating"
        case userPreviousComment = "userPreviousComment"
        case distance = "distance"
        case distanceInKm = "distance_in_km"
    }
}

class NearByMeServiceProviderVC: BaseVC  {
    
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btngps: UIButton!
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var mapView: GMSMapView!
    var listcategory = [LocalServiceProviderModel]()
    //var selecteddata : LocalServiceProviderModel!
    // let dropDown = DropDown()
    var locationManager = CLLocationManager()
    var mapdatalist = [LocalServiceProvider]()
    var isSelected = false
    var serviceproviderID = ""
    //    let marker = GMSMarker()
    //    let marker2 = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // doCheckPermission()
        lblScreenTitle.text = doGetValueLanguage(forKey: "near_by_service_provider")
        self.locationManager.delegate = self
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locationManager.location
            if currentLocation != nil{
                doCallMapApi(lat: String(currentLocation.coordinate.latitude), long: String(currentLocation.coordinate.longitude), lspID: "0")
            }else{
                
                
                self.currentLocation = locationManager.location
            }
        }else{
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedAlways,.authorizedWhenInUse:
//            self.locationManager.requestLocation()
//            print("requestLocation")
//            self.loadMap(lat: self.currentLocation.coordinate.latitude, long: self.currentLocation.coordinate.longitude)
//            break;
//        case .denied , .restricted, .notDetermined:
//            self.locationManager.requestWhenInUseAuthorization()
//            print("Please access Location permission")
//            let ac = UIAlertController(title: "", message: "Please access Location permission", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default)
//            {
//                (result : UIAlertAction) -> Void in
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            })
//            ac.addAction(UIAlertAction(title: "Cancel", style: .default)
//            {
//                (result : UIAlertAction) -> Void in
//                ac.dismiss(animated: true, completion: nil)
//            })
//            present(ac, animated: true)
//        default:
//            break
//        }
    }
    
    override func viewWillLayoutSubviews() {

//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedAlways,.authorizedWhenInUse:
//            self.locationManager.requestLocation()
//            print("requestLocation")
//           // self.loadMap(lat: self.currentLocation.coordinate.latitude, long: self.currentLocation.coordinate.longitude)
//            break;
//        case .denied , .restricted, .notDetermined:
//            self.locationManager.requestWhenInUseAuthorization()
//            print("Please access Location permission")
//            let ac = UIAlertController(title: "", message: "Please access Location permission", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default)
//            {
//                (result : UIAlertAction) -> Void in
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            })
//            ac.addAction(UIAlertAction(title: "Cancel", style: .default)
//            {
//                (result : UIAlertAction) -> Void in
//                ac.dismiss(animated: true, completion: nil)
//            })
//            present(ac, animated: true)
//        default:
//            break
//        }

    }
    
    
    func doCheckPermission(){
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
        }else{
            print("allow permission")
        }
    }
    
    func loadMap(lat : Double! , long : Double!) {
        
        print(currentLocation.coordinate.latitude ,"latitude" , currentLocation.coordinate.longitude , "logitude")
        
        
        let camera = GMSCameraPosition.camera(withLatitude:  lat, longitude: long, zoom: 16.0) //Set default lat and long
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.size.width, height: self.viewMap.frame.size.height), camera: camera)
       
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
       
        self.viewMap.addSubview(mapView)
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        print("location: \(location)")
        marker.position = location
        self.mapView.delegate = self
        marker.title = "My Location"
        marker.snippet = "My Location"
        marker.map = self.mapView
    }
    
    func doCallMapApi(lat : String! , long : String! , lspID : String!){
        
        
        let  param = ["getServiceProviderUserMapData":"getServiceProviderUserMapData",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "local_service_provider_id":lspID!,
                      "local_service_provider_sub_id":"0",
                      "user_latitude":lat!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "user_longitude":long!]
        
        print("param ----->" , param)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName:ServiceNameConstants.LSPController, parameters: param) { (Data, Error) in
            if Data != nil{
                
                do{
                    let response = try JSONDecoder().decode(MapDataResponse.self, from: Data!)
                    
                    if response.status == "200"{
                        
                        self.mapdatalist = response.localServiceProvider
                        self.loadMap(lat: self.currentLocation.coordinate.latitude, long: self.currentLocation.coordinate.longitude)
                        //  var markerDict: [String: GMSMarker] = [:]
                        for item in self.mapdatalist {
                            let marker = GMSMarker()
                            let location = CLLocationCoordinate2D(latitude: Double(item.serviceProviderLatitude)!, longitude: Double(item.serviceProviderLogitude)!)
                            print("location: \(location)")
                            marker.position = location
                            self.mapView.delegate = self
                            marker.userData = item
                            marker.title = item.serviceProviderName
                            // marker.snippet =  item.serviceProviderName
                            marker.map = self.mapView
                            marker.icon = GMSMarker.markerImage(with: UIColor.green)
                            // markerDict[item.serviceProviderName] = marker
                        }
                        
                        if self.mapdatalist.count == 0{
                            self.toast(message: "No Service Provider Found", type: .Information)
                        }
                    }else{
                        print("201")
                    }
                }catch{
                    print("error")
                }
            }else{
                print("parse error")
            }
        }
    }
    
    
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
    @IBAction func onClickCategory(_ sender: Any) {
        
    }
    
    @IBAction func onClickgps(_ sender: Any) {
        self.locManager.requestAlwaysAuthorization()
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locationManager.location
            let position = GMSCameraPosition.camera(withLatitude: Double(currentLocation.coordinate.latitude),
                                                    longitude: Double(currentLocation.coordinate.longitude),
                                                    zoom: 20)
            mapView.camera = position

        }else{
            locationManager.requestWhenInUseAuthorization()
//            self.showAlertMessage(title: "Location permission error", msg: "Please give location permission")
        }
        
    }
}
extension NearByMeServiceProviderVC : CLLocationManagerDelegate{
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if (status == CLAuthorizationStatus.denied) {
                print("denied")
    //            // The user denied authorization
    //            isLocationEnable = false
            } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
                print("authorizedWhenInUse")
    //            // The user accepted authorization
    //            self.clLocationManager.delegate = self
    //            self.clLocationManager.startUpdatingLocation()
    //            isLocationEnable = true
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[locations.count-1]
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location responder error",error.localizedDescription)
    }
}
extension NearByMeServiceProviderVC : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        if marker.title != "My Location"{
            let vc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idsubNearByMeServiceProviderVC")as! subNearByMeServiceProviderVC
            print("didtap")
            vc.mapdata = marker.userData as? LocalServiceProvider
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.addChild(vc)
            self.view.addSubview(vc.view)
        }
        return true
    }
    
   

    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("end drag")
    }
    
}
