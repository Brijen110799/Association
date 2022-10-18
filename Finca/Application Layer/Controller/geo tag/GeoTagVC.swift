//
//  GeoTagVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 01/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils
import DropDown
class GeoTagVC: BaseVC , CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var viewcity: UIView!
    @IBOutlet weak var viewarea: UIView!
    @IBOutlet weak var viewradius: UIView!
    
    @IBOutlet weak var viewbloodgroup: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    var titleToolbar = ""
    
    @IBOutlet weak var lblheaderbloodgroup: UILabel!
    @IBOutlet weak var lbCompanyName: UILabel!
   // @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
   // @IBOutlet weak var lbMobile: UILabel!
  //  @IBOutlet weak var lbEmail: UILabel!
  //  @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var bottomConViewDetails: NSLayoutConstraint!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    
   // @IBOutlet weak var lbPlorName: MarqueeLabel!
    @IBOutlet weak var lbUserName: MarqueeLabel!
  //  @IBOutlet weak var lbWebSite: UILabel!
    @IBOutlet weak var viewDefult: UIView!
    @IBOutlet weak var viewSatellite: UIView!
  //  @IBOutlet weak var viewFillter: UIView!
    @IBOutlet weak var viewTarrain: UIView!
    @IBOutlet weak var lbDefult: UILabel!
    @IBOutlet weak var lbSatellite: UILabel!
    @IBOutlet weak var lbTarrain: UILabel!
    
    @IBOutlet weak var viewMainViewMapType: UIView!
    @IBOutlet weak var conWidthMapType: NSLayoutConstraint!
    @IBOutlet weak var conHieghtMapType: NSLayoutConstraint!
    @IBOutlet weak var viewMenu: UIView!
    
    
    @IBOutlet weak var viewMainInfo: UIView!
    @IBOutlet weak var ivFilter: UIImageView!
    
    @IBOutlet weak var viewFilterMain: UIView!
    @IBOutlet weak var viewFilterShowMe: UIView!
    @IBOutlet weak var lbMemberCount: UILabel!
    @IBOutlet weak var lbProfile: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbRadius: UILabel!
    @IBOutlet weak var lbShowMe: UILabel!
    
    @IBOutlet weak var lbGeoTagMemberCount: UILabel!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var viewMarkerList: UIView!
    @IBOutlet weak var viewMemberListTop: UIView!
    @IBOutlet weak var viewOtherMemberPin: UIView!
    var  destinationMarker = GMSMarker()
    let destinationCoordinate = CLLocation()
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    private var clusterManager: GMUClusterManager!
    var latPass = ""
    var langPass =  ""
    var latDirc = ""
    var langDirc =  ""
    var city_name = ""
    var nearByData = [ModelNearData]()
    var selectUserId = ""
    var isLoadingShow = true
    var other_user_id = ""
    var other_user_name = ""
    var responseMember : ResponseMember?
    var cities = [String]()
    let dropDown = DropDown()
    var filterCityId = ""
    var areas = [String]()
    var aredId = ""
    var bloodGroup = ""
    var  floors = [FloorModelMember]()
    private var radius = ""
    private var my_team = "0"
    private var get_new_member = "0"
    var isComeFrom  = ""
    let cellItem = "MemberUserCell"
    var markerData = [ModelNearData]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // doInintialRevelController(bMenu: bMenu)
        lbTitle.text = titleToolbar
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 8)
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        loadLocation()
        selectorMapView(type: "1")
        conWidthMapType.constant = 0
        conHieghtMapType.constant = 0
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
//                                                 clusterIconGenerator: iconGenerator)
//        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
//                                           renderer: renderer)
//
//        // Register self to listen to GMSMapViewDelegate events.
//        clusterManager.setMapDelegate(self)
        setupMarqee(label: lbUserName)
        //setupMarqee(label: lbPlorName)
      
        viewFilterMain.isHidden = true
        viewMainInfo.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied :
                showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                
            case .notDetermined:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
             
              //  doGetMembes(my_team: "0", get_new_member: "0", user_latitude: "", user_longitude: "", city: "", area: "")
            @unknown default:
                break
            }
            } else {
                print("Location services are not enabled")
        }
       
        
        doGetMembes(my_team: "0", get_new_member: "0", user_latitude: "", user_longitude: "", city: "", area: "")
        ivFilter.setImageColor(color: ColorConstant.grey_60)
        lbProfile.text = doGetValueLanguage(forKey:  "profiles")
        let inb = UINib(nibName: cellItem, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: cellItem)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        
        
        if other_user_id != "" {
            viewOtherMemberPin.isHidden = false
        }
        
    }

    func showAlertMsg(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
          //  self.goToHome()
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
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func tapHome(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSearchMemberVC")as! SearchMemberVC
         self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func tapChangeView(_ sender: Any) {
        viewMainViewMapType.isHidden = false
        
        conWidthMapType.constant = 140
        conHieghtMapType.constant = 170
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    @IBAction func tapCloseChangeView(_ sender: Any) {
       
        conWidthMapType.constant = 0
        conHieghtMapType.constant = 0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        },completion: {(finished:Bool) in
        // the code you put here will be compiled once the animation finishes
            self.viewMainViewMapType.isHidden = true
        })
         
    }
    @IBAction func btnBackAction(_ sender: Any) {
     doPopRootBAck()
    }
    @IBAction func tapDefult(_ sender: Any) {
        selectorMapView(type: "1")
        mapView.mapType = GMSMapViewType.normal
        tapCloseChangeView(sender)
    }
    @IBAction func tapSatellite(_ sender: Any) {
        selectorMapView(type: "2")
        mapView.mapType = GMSMapViewType.satellite
         tapCloseChangeView(sender)
    }
    @IBAction func tapTerrain(_ sender: Any) {
        selectorMapView(type: "3")
        mapView.mapType = GMSMapViewType.terrain
         tapCloseChangeView(sender)
    }
    @IBAction func tapCloseDetailView(_ sender: Any) {
        viewMainInfo.isHidden = true
        bottomConViewDetails.constant = 16
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func tapFilter(_ sender: Any) {
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied :
                showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                
            case .notDetermined:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                
                if responseMember?.block.count != 0
                {
                    let nextVC = MemberFilterDailogVC()
                    
                    if let block = responseMember?.block
                    {
                        nextVC.areaDataForFilterModel = block
                    }
                    //?? //[BlockFastMember]()//[BlockModelMember]()
                    // nextVC.floorsForFilter = floorsForFilter
                    nextVC.onApplyFilter = self
                    nextVC.iscomefrom = "geomap"
                    nextVC.filterCityId = filterCityId
                    nextVC.aredId = aredId
                    nextVC.radius = radius
                    nextVC.my_team = my_team
                    nextVC.bloodGroup = bloodGroup
                    nextVC.get_new_member = get_new_member
                    nextVC.view.frame = view.frame
                    self.addPopView(vc: nextVC)
                    
                }
                
                
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        
        
    }
    
  
    
    @IBAction func tapApply(_ sender: Any) {
        ivFilter.setImageColor(color: ColorConstant.colorP)
        doGetNearBy(user_latitude: latPass, user_longitude: langPass)
      //  closeFilter()
    }
    
    @IBAction func tapMembers(_ sender: Any) {
        //goToDashBoard(storyboard: mainStoryboard)
        
        
        if isComeFrom == "DashBord" {
            let vc = NewMemberVC()
            vc.menuTitle = doGetValueLanguage(forKey: "members")
            vc.isComeFromGeoTag = "geotag"
            pushVC(vc: vc)
        } else {
            doPopBAck()
        }
        
    }
    private func defuleStateLabel(label : UILabel) {
        label.layer.cornerRadius =  label.frame.height / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = ColorConstant.grey_40.cgColor
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.textColor = ColorConstant.grey_40
    }
    private func selectedStateLabel(label : UILabel) {
        label.layer.cornerRadius =  label.frame.height / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.backgroundColor = ColorConstant.colorP
        label.clipsToBounds = true
        label.textColor = .white
    }
    
    func selectorMapView(type : String) {
        
        switch type {
        case "1":
            //defule
            viewDefult.backgroundColor = ColorConstant.primaryColor
            viewSatellite.backgroundColor = .white
            viewTarrain.backgroundColor = .white
            
            lbDefult.textColor = .white
            lbSatellite.textColor = ColorConstant.primaryColor
            lbTarrain.textColor = ColorConstant.primaryColor
            
        case "2":
            //satellite
            viewSatellite.backgroundColor = ColorConstant.primaryColor
            viewDefult.backgroundColor = .white
            viewTarrain.backgroundColor = .white
            
            lbSatellite.textColor = .white
            lbDefult.textColor = ColorConstant.primaryColor
            lbTarrain.textColor = ColorConstant.primaryColor
        case "3":
            //satellite
            viewTarrain.backgroundColor = ColorConstant.primaryColor
            viewDefult.backgroundColor = .white
            viewSatellite.backgroundColor = .white
            
            lbTarrain.textColor = . white
            lbDefult.textColor = ColorConstant.primaryColor
            lbSatellite.textColor = ColorConstant.primaryColor
        default:
            break
        }
        
    }
    
    @IBAction func tapDirection(_ sender: Any) {
       let url = "https://www.google.com/maps/dir/\(latPass),\(langPass)/\(latDirc),\(langDirc)/@23.0969294,72.6118082,11z/data=!4m2!4m1!3e0"
        
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            //  UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@\(lat),\(lon),6z")!)
        }
    }
    
    @IBAction func tapMapUserDetails(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "idMemberDetailsVC") as! MemberDetailsVC
//        vc.user_id =  selectUserId
//        pushVC(vc: vc)
//        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = selectUserId
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MemberDetailsVC()
        vc.user_id = selectUserId
        vc.userName = ""
        pushVC(vc: vc)
        
    }
    
    @IBAction func tapCloseMarkerlist(_ sender: Any) {
        viewMarkerList.isHidden = true
    }
    
    func loadMap(lat:Double,long:Double) {
        print("loadMap")
        self.mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude:  long, zoom: 10.0)
        self.mapView.animate(to: camera)
        self.mapView.isMyLocationEnabled = true
        // self.mapView.reloadInputViews()
         //getAddress(mapView: mapView)
        getAddressFromLatLon(pdblLatitude: lat, withLongitude: long)
       
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
       
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        renderer.minimumClusterSize = 1000
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)

        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        //clusterManager.s
    }
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
         var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
         let lat: Double = Double("\(pdblLatitude)")!
         //21.228124
         let lon: Double = Double("\(pdblLongitude)")!
         //72.833770
         let ceo: CLGeocoder = CLGeocoder()
         center.latitude = lat
         center.longitude = lon

         let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


         ceo.reverseGeocodeLocation(loc, completionHandler:
             {(placemarks, error) in
                 if (error != nil)
                 {
                     print("reverse geodcode fail: \(error!.localizedDescription)")
                    return
                 }
                 let pm = placemarks! as [CLPlacemark]

                 if pm.count > 0 {
                     let pm = placemarks![0]
                     self.city_name = String((pm.locality!))
                    self.doGetNearBy(user_latitude: "\(lat)", user_longitude: "\(lon)")
                     // print(addressString)
               }
         })

     }
     
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if (locations.last != nil) {
            
            DispatchQueue.main.async {
               
                self.locationManager.stopUpdatingLocation()
            }
            
            print("lkdlskd \(locValue.latitude)")
            
            if latPass == "" {
                loadMap(lat: locValue.latitude,long: locValue.longitude)
                latPass = String(locValue.latitude)
                langPass = String(locValue.longitude)
               
            }
           
        }
        
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       // let coordinate = self.mapView.projection.coordinate(for: self.mapView.center)
       // getAddressFromLatLon(lat: coordinate.latitude , withLongitude: coordinate.longitude)
       
        
    }
   
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         //print("didTap" + marker.snippet!)
         
         if let _ = marker.userData as? GMUCluster {
          // mapView.animate(toZoom: mapView.camera.zoom)
             NSLog("Did tap cluster" , marker.layer.latitude)
             let camera = GMSCameraPosition.camera(withLatitude: marker.layer.latitude, longitude:  marker.layer.longitude, zoom: mapView.camera.zoom + 1)
             mapView.animate(to: camera)
           return true
         }
        
        
        
       
        
        
        let index = Int(marker.snippet!)!
        let item = nearByData[index]
        var nearByDataTemp = [ModelNearData]()
        
        let coordinateSource = CLLocation(latitude: Double(item.plot_lattitude ?? "0.0") ?? 0, longitude: Double(item.plot_longitude ?? "0.0") ?? 0)
       
        
       
        
        
        for itemSub in nearByData {
            let coordinateDestination = CLLocation(latitude: Double(itemSub.plot_lattitude ?? "0.0") ?? 0, longitude: Double(itemSub.plot_longitude ?? "0.0") ?? 0.0)
            let distanceInMeters = coordinateSource.distance(from: coordinateDestination)  // result is in meters
            
            //let dist = dis
           // print("distanceInMeters \(distanceInMeters)")
            if distanceInMeters < 15  {
                nearByDataTemp.append(itemSub)
            }
        }
        
        
        if nearByDataTemp.count > 1 {
            viewMarkerList.isHidden = false
         //   print("count \(nearByDataTemp.count)")
            lbGeoTagMemberCount.text = "\(nearByDataTemp.count) \(doGetValueLanguage(forKey: "members_are_here"))"
            self.markerData = nearByDataTemp
            tbvData.reloadData()
            return true
        }
    
        
        let camera = GMSCameraPosition.camera(withLatitude: marker.layer.latitude, longitude:  marker.layer.longitude, zoom: mapView.camera.zoom + 1)
        mapView.animate(to: camera)
         print("didTap" + marker.snippet!)
         lbCompanyName.text = item.company_name
         lbUserName.text = item.user_full_name
         lbAddress.text = item.plot_address
      //   lbMobile.text = item.company_contact_number
      //   lbEmail.text = item.company_email
       //  lbPlorName.text = item.plot_name
       //  lbWebSite.text = item.company_website
         selectUserId = item.user_id
         latDirc = item.plot_lattitude
         langDirc = item.plot_longitude
         
         
         
         Utils.setImageFromUrl(imageView: ivProfile, urlString: item.user_profile_pic, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        
            viewMainInfo.isHidden = false
            bottomConViewDetails.constant = view.frame.height / 3 - 40
            
             UIView.animate(withDuration: 0.2, animations: { () -> Void in
                 self.view.layoutIfNeeded()
             })
         
         
         
         
         return true
     }

    func doGetNearBy(user_latitude : String,user_longitude : String) {
        if self.isLoadingShow {
           showProgress()
        }
           //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
           let params = ["getgeoTag":"getgeoTag",
                         "user_latitude" : user_latitude,
                         "user_longitude" : user_longitude,
                         "block_id" : filterCityId ,
                         "floor_id" : aredId,
                         "radius" : "",
                         "my_team" : my_team,
                         "get_new_member" : get_new_member,
                         "user_id" : doGetLocalDataUser().userID ?? "",
                         "other_user_id" : other_user_id,
                         "society_id":doGetLocalDataUser().societyID!,
                         "blood_group":bloodGroup]
           print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: NetworkAPI.geo_tag_controller, parameters: params) { [self] (json, error) in
               //  self.hideProgress()
               if json != nil {
                 
                   do {
                       let response = try JSONDecoder().decode(ResponseNearData.self, from:json!)
                       
                       if response.status == "200" {
                        self.nearByData = response.geoTagList
                        if radius != "" {
                            print("radius = \(radius)")
                            var temp = [ModelNearData]()
                            
                            if response.geoTagList.count > 0 {
                                for item in response.geoTagList {
                                    if Double(item.radius_distance ?? "0") ?? 0 <=  Double(radius) ?? 0 {
                                        temp.append(item)
                                    }
                                }
                            }
                            nearByData = temp
                        }
                        
                        self.lbMemberCount.text = "\(nearByData.count)"
                        self.loadMarker()
//                           if nearByData.count == 0 {
//                               self.viewFilterMain.isHidden = true
//                           }else {
//                               self.viewFilterMain.isHidden = false
//                           }
                       
                        
                       }else {
                           DispatchQueue.main.async {
                               self.mapView.clear()
                               self.clusterManager.clearItems()
                           }
                           
                           if self.isLoadingShow {
                               self.hideProgress()
                           }
                           self.viewFilterMain.isHidden = true
                           self.toast(message: response.message, type: .Information)
                           //    self.members.removeAll()
                        //   self.viewNoData.isHidden = false
                        //   self.tblData.reloadData()
                       }
                   } catch {
                       print("parse error")
                   }
               }else if error != nil{
                self.hideProgress()
                self.showNoInternetToast()
            }
           }
        
      
        
           
       }
    
    
    func loadMarker() {
        DispatchQueue.main.async {
            if self.isLoadingShow {
                self.hideProgress()
                self.isLoadingShow = false
            }
        }
        if clusterManager != nil && clusterManager.clusterRequestCount() > 0 {
            clusterManager.clearItems()
            print("")
        }
        DispatchQueue.main.async {
            for (index,item) in self.nearByData.enumerated(){
                
                //    let lat = Double(item.plot_lattitude)
                //  let lon = Double(item.plot_longitude)
                
                if let lat = self.self.getDouble(item.plot_lattitude), let lon = self.getDouble(item.plot_longitude) {
                    //print("Result: \(b)")
                    let markerView = UIImageView(image: UIImage(named: "geo_tag_marker"))
                   // markerView.setImageColor(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    markerView.frame = CGRect(x: 0, y: 0, width: 22, height: 27)
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                     print("location: \(location)")
//                                    let marker = GMSMarker()
//                                    marker.iconView = markerView
//                                    marker.position = location
//                                     marker.snippet = "\(index)"
//                     marker.map = self.mapView
                    let marker = GMSMarker(position: location)
                    marker.iconView = markerView
                    marker.snippet = "\(index)"
                    self.clusterManager.add(marker)
                } else {
                    print("No result")
                }
                
                
            }
        }
        clusterManager.cluster()
      //  mapView.reloadInputViews()
        
    }
    func getDouble(_ data:String) -> Double?{
        return Double(data)
    }
    func doGetMembes(my_team : String,get_new_member : String,user_latitude : String,user_longitude : String,city : String,area : String) {
       
        //showProgress()
       
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMembersNew":"getMembersNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "my_id":doGetLocalDataUser().userID!,
                      "my_team" : my_team,
                      "get_new_member" :get_new_member,
                      "user_latitude" : user_latitude,
                      "user_longitude" : user_longitude,
                      "block_id" : city,
                      "floor_id" : area]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName:  NetworkAPI.view_member_list_controller, parameters: params) { (json, error) in
            
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    if response.status == "200" {
                        
                        //self.MemberTypes = response.member_types
                        
                        self.responseMember = response
                        
                        
                        if let data = response.block {
                            if data.count > 0 {
                                for item in data {
                                    self.cities.append(item.block_name ?? "")
                                }
                            }
                            
                        }
                        
                        
//                        if let data = response.block {
//                            self.areaData = data
//                            self.setDataMember(index: 0)
//                            self.cvArea.reloadData()
//                        }
                       
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
  
  
}
extension GeoTagVC:  OnApplyFilter {
    
    //for filter apply
    func onApplyFilter(cityId: String, areaId: String, radius: String, my_team: String, get_new_member: String , isApplyFilter : Bool,cityName : String,areaName : String,radiusName : String , showMe : String,bloodgroup:String) {
        self.filterCityId = cityId
        self.aredId = areaId
        self.radius = radius
        self.my_team = my_team
        self.get_new_member = get_new_member
        self.bloodGroup = bloodgroup
        
        viewFilterShowMe.isHidden = false
        lbCity.text = cityName
        lbArea.text = areaName
        lbRadius.text = radiusName
        lblheaderbloodgroup.text = bloodgroup
        
        if bloodgroup == ""
        {
            self.viewbloodgroup.isHidden = true
        }
        else{
            self.viewbloodgroup.isHidden = false
        }
        
        if radiusName == ""
        {
            self.viewradius.isHidden = true
        }
        else{
            self.viewradius.isHidden = false
        }
        
        
        viewFilterShowMe.isHidden = true
        if showMe != "" {
            viewFilterShowMe.isHidden = false
            lbShowMe.text = showMe
        }
        
        if isApplyFilter {
            ivFilter.setImageColor(color: ColorConstant.colorP)
            viewFilterMain.isHidden = false
            viewMemberListTop.isHidden = true
        } else {
            ivFilter.setImageColor(color: ColorConstant.grey_60)
            viewFilterMain.isHidden = true
            viewMemberListTop.isHidden = false
        }
        other_user_id = ""
//        lbTitle.text = doGetValueLanguage(forKey: "location")
        doGetNearBy(user_latitude: latPass, user_longitude: langPass)
    }
    
}
extension GeoTagVC:  UITableViewDataSource , UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem, for: indexPath) as! MemberUserCell
        let item = markerData[indexPath.row]
        cell.lbName.text = item.user_full_name ?? ""
        cell.lbCompany.text = "\(item.company_name ?? "")"
        cell.ConLeft.constant = 0
        cell.ConRight.constant = 0
        
        cell.isAddGesture = false
        
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic ?? "" ,palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
        cell.selectionStyle = .none
        
       
        cell.viewLine.isHidden = false
        cell.bInfo.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemberDetailsVC()
        vc.user_id = markerData[indexPath.row].user_id ?? ""
        vc.userName = ""
        pushVC(vc: vc)
    }
}

struct ResponseNearData : Codable {
    let status  :String! //" : "200"
    let message  :String! //" : "Get Success.",
    let geoTagList : [ModelNearData]!
}
struct ModelNearData : Codable {
    let plot_name : String! //" : "Ankleshwar-Ankleshwar-L-295",
    let plot_longitude : String! //" : "73.0228173",
    let user_profile_pic : String! //" : "https:\/\/gdma.fincasys.com\/img\/users\ofile",
    let plot_address : String! //" : "L-295, Ankleshwar, Ankleshwar",
    let public_mobile : String! //" : "1",
    let company_website : String! //" : "www.preranachemical.com",
    let user_full_name : String! //" : "D. N. Vithalani",
    let user_mobile : String! //" : "0****0",
    let company_contact_number : String! //" : "221212",
    let user_email : String! //" : "info@preranachemical.com",
    let company_name : String! //" : "D. N. Chemicals",
    let user_id : String! //" : "1",
    let plot_lattitude : String! //" : "21.6180391",
    let company_email : String! //" : "info@preranachemical.com"
    let distance : String! //" : "13.86 KM",
    let radius_distance : String! //" : "13.86",
}
