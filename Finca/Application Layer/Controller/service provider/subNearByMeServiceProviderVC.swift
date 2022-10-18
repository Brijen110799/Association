//
//  subNearByMeServiceProviderVC.swift
//  Finca
//
//  Created by Hardik on 5/18/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class subNearByMeServiceProviderVC: UIViewController {
    @IBOutlet weak var lblSPName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var ivSPImage: UIImageView!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    
    @IBOutlet weak var lblEmailIDTitle: UILabel!
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var lblMobileTitle: UILabel!
    var mapdata : LocalServiceProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSPName.text = mapdata.serviceProviderName!
        lblAddress.text = mapdata.serviceProviderAddress!
        lblMobileNo.text = mapdata.serviceProviderPhone!
        lblEmail.text = mapdata.serviceProviderEmail!
        lblDistance.text = mapdata.distanceInKm
        Utils.setImageFromUrl(imageView: ivSPImage, urlString: mapdata.serviceProviderUserImage)
        print("name of service provider marker ======== ",mapdata.serviceProviderName!)
    }
    

    @IBAction func onClickDirection(_ sender: Any) {
        
        let lat = Double(mapdata.serviceProviderLatitude!)
        let long = Double(mapdata.serviceProviderLogitude!)
           let latitude: CLLocationDegrees = CLLocationDegrees(lat!)
                let longitude: CLLocationDegrees = CLLocationDegrees(long!)
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = mapdata.serviceProviderName
                mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        removeFromParent()
        view.removeFromSuperview()
    }
    
}
