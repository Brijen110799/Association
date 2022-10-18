//
//  SelectLocationMapVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 18/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SelectLocationMapVC: BaseVC , GMSMapViewDelegate ,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbAddress: UILabel!
    
    var destinationMarker = GMSMarker()
    let destinationCoordinate = CLLocation()
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    var address = ""
    var geoCoder :CLGeocoder!
    var latPass = ""
    var langPass =  ""
    var chatVC : ChatVC!
    var onTapMediaSelect : OnTapMediaSelect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self;
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        locationManager.delegate = self

        loadLocation()
        geoCoder = CLGeocoder()
        
        
    }
    


    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }

    @IBAction func onClickSelect(_ sender: Any) {
        let latlong = latPass + "," + langPass
        if onTapMediaSelect != nil {
            onTapMediaSelect.onLocationSuccess(location: latlong,address : lbAddress.text!)
        } else {
            chatVC.doSendLocation(address: lbAddress.text!, location_lat_long: latlong)
        }
        doPopBAck()
        
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

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // let coordinate = self.mapView.projection.coordinate(for: self.mapView.center)
        // getAddressFromLatLon(lat: coordinate.latitude , withLongitude: coordinate.longitude)
        getAddress(mapView: mapView)

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        if (locations.last != nil) {

            locationManager.stopUpdatingLocation()

            loadMap(lat: locValue.latitude,long: locValue.longitude)
            // latPass = String(coordinate.latitude)//
            // langPass = String(coordinate.longitude)
        }


    }
    
    func loadMap(lat:Double,long:Double) {
        self.mapView.delegate = self

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude:  long, zoom: 17.0)
        self.mapView.animate(to: camera)
        self.mapView.isMyLocationEnabled = true
        // self.mapView.reloadInputViews()
    }
    func getAddress(mapView: GMSMapView) {
        // var add = ""
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        
        let geoCoder = GMSGeocoder()
        //  geoCoder.res
        //  let lat  = mapView.camera.target.latitude
        // let lang  = mapView.camera.target.longitude
        latPass = String(coordinate.latitude)
        langPass = String(coordinate.longitude)
        
        let lat  = coordinate.latitude
        let lang  = coordinate.longitude
        
        let pos  = CLLocationCoordinate2DMake(lat, lang)
        
        geoCoder.reverseGeocodeCoordinate(pos) { (response, error) in
            if error != nil {
                print("error" , error?.localizedDescription ?? "")
            } else {
                
                if response != nil {
                    let result = response?.results()?.first
                    
                    // print("shdhdhdhdh   =   ",result)
                    //  print("subLocality   =   ",result?.subLocality)
                    //   print("subLocality   =   ",result?.locality)
                    
                    self.address = (result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 })! //  this method get all address
                    
                    
                    print("address" , self.address)
                    self.lbAddress.text = self.address
                    

                    //                    if result?.postalCode != nil {
                    //                        self.address_pincode =  (result?.postalCode!)!
                    //                    }
                    //
                    //                    if result?.subLocality != nil {
                    //                        self.address_locality = ((result?.subLocality)!)
                    //                        add = ((result?.subLocality)!)
                    //                    }
                    //
                    //                    if result?.locality != nil {
                    //                       add =  add + "," +  (result?.locality!)!
                    //                    }
                    //
                    //                   // let diplayAdd = String((result?.subLocality!)!)  + " " + String((result?.locality!)!)
                    //
                    //                    self.tvAddress.text = add
                } else {
                    // self.lbAddress.text = ""
                }
                
                
            }
            
            
        }
        
        
        
    }
    

}
