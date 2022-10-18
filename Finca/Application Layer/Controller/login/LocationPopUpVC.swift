//
//  LocationPopUpVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 29/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class LocationPopUpVC: UIViewController {

    @IBOutlet weak var lblLatLong: UILabel!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnChangeLocation: UIButton!
    
    var latitude:String?
    var longitude:String?
    var address:String?
    var imgUrl:String?
    var completion: ((_ lat:String,_ long:String,_ imgUrl:String,_ address:String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblLatLong.text = "\(latitude ?? "") ,\(longitude ?? "")"
        
        let mapLocImgUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C\(latitude ?? ""),\(longitude ?? "")&key=\(StringConstants.GOOGLE_MAP_KEY)"
        if let mapUrl = URL(string: mapLocImgUrl) {
            self.imgMap.setImage(url: mapUrl)
        }
        self.imgUrl = mapLocImgUrl
    }
    
    @IBAction func OkTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let comp = self.completion {
                comp(self.latitude ?? "", self.longitude ?? "", self.imgUrl ?? "",self.address ?? "")
            }
        }
    }
    
    @IBAction func ChangeLocationTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
