//
//  SelectProfileLocationVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 29/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol locationDelegate {
    func getLocationdata(lat:String,long:String,imgUrl:String,address:String)
}

class SelectProfileLocationVC: BaseVC {

    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var btnSelectThisLocation: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    
    var delegate:locationDelegate?
    var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    let destinationMarker = GMSMarker()
    var destinationCoordinate = CLLocationCoordinate2D()
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            locationManager.headingOrientation = .portrait
            locationManager.headingFilter = kCLHeadingFilterNone
//            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        } else {
            SettingsAlertController(title: "Alert", message: "Please enable location service.")
        }
    }
    
    func setupSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        let subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        mapBgView.addSubview(subView)
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
       
        self.lblAddress.text = lines.joined(separator: "\n")
        self.destinationCoordinate = coordinate
            
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.doPopBAck()
    }
    
    @IBAction func selectThisLocationTapped(_ sender: UIButton) {
        if(lblAddress.text == "" || lblAddress.text == nil) {
            toast(message: "Please Select Location", type: .Defult)
        } else {
//            let vc = storyboardConstants.wfhStoryboard.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC
            let vc = LocationPopUpVC(nibName: "LocationPopUpVC", bundle: nil)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.latitude = "\(destinationCoordinate.latitude)"
            vc.longitude = "\(destinationCoordinate.longitude)"
            vc.address = lblAddress.text
            vc.completion = { lat, long, imgurl, address in
                if let del = self.delegate {
                    del.getLocationdata(lat: lat, long: long, imgUrl: imgurl, address: address)
                }
                self.doPopBAck()
            }
            present(vc, animated: true, completion: nil)
        }
        
    }
}

extension SelectProfileLocationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location: location)
        }
    }
    
    func render(location:CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.frame = CGRect(x: 0, y: 0, width: self.mapBgView.frame.width, height: self.mapBgView.frame.height)
        mapView.settings.myLocationButton = true
        mapView.isTrafficEnabled = true
        mapView.mapType = .normal
        mapView.settings.compassButton = true
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.mapBgView.addSubview(mapView)
        
        setupSearchController()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension SelectProfileLocationVC : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        destinationMarker.position = position.target
        destinationMarker.map = mapView
        print(destinationMarker.position)
    }
}

extension SelectProfileLocationVC {
    func SettingsAlertController(title: String, message: String) {

      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

      let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
      let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
      }

      alertController.addAction(cancelAction)
      alertController.addAction(settingsAction)
      self.present(alertController, animated: true, completion: nil)

   }
}

extension SelectProfileLocationVC : GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        destinationMarker.position = place.coordinate
        destinationMarker.map = mapView
        mapView.animate(toLocation: place.coordinate)
        // Do something with the selected place.
//        print("Place name: \(place.name!)")
//        print("Place address: \(place.formattedAddress!)")
        self.lblAddress.text = place.formattedAddress
        self.destinationCoordinate = place.coordinate
//        print("Place attributions: \(place.attributions!)")
      }

      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
      }

}

extension SelectProfileLocationVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name!)")
    print("Place ID: \(place.placeID!)")
    print("Place attributions: \(place.attributions!)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
//  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//  }
//
//  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//  }

}

extension SelectProfileLocationVC : locationDelegate {
    func getLocationdata(lat: String, long: String, imgUrl: String, address: String) {
        self.dismiss(animated: true) {
            var imageUrl:String?
//            let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C" + "\(lat),\(long)" + "&key=" + "AIzaSyB6qE0fKEKXK5Vj2wgBXJbnCioD47HaBK0"
            let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C" + "\(lat),\(long)" + "&key=" + StringConstants.GOOGLE_MAP_KEY

            print(mapUrl)
            if let url = URL(string: mapUrl){
                imageUrl = "\(url)"
            }
            
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddWFHVC") as? AddWFHVC
//            vc?.imgUrl = imageUrl
//            self.navigationController?.popToViewController(vc!, animated: true)
            let vc = ProfileCompleteVC(nibName: "ProfileCompleteVC", bundle: nil)
            vc.imgUrl = imageUrl
            self.doPopBAck()
        }
    }
    
}
