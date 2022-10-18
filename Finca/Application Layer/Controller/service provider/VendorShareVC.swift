//
//  VendorShareVC.swift
//  Finca
//
//  Created by CHPL Group on 20/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit
import Cosmos
class VendorShareVC: BaseVC {
    
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbNoRating: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbOpen: UILabel!
    @IBOutlet weak var lbMail: UILabel!
    @IBOutlet weak var lbCall: UILabel!
    @IBOutlet weak var lbWebSite: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var viewVeryfied: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var viewMainShare: UIView!
    
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewMail: UIView!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var viewWebSite: UIView!
    
    var serviceProviderDetail : LocalServiceProviderListModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setData()
        
    }


    @IBAction func tapShare(_ sender: Any) {
        let name = serviceProviderDetail?.serviceProviderName ?? ""
        let email = serviceProviderDetail?.serviceProviderEmail ?? ""
        let phone = serviceProviderDetail?.service_provider_phone_view ?? ""
        let address = serviceProviderDetail?.serviceProviderAddress ?? ""
        var shareText = ""

        if name != "" {
            shareText = "Vendor : \(name)\n"
        }
        if email != "" {
            shareText = "\(shareText)Email : \(email)\n"
        }
       
        if phone != "" {
            shareText = "\(shareText)Phone : \(phone)\n"
        }
        if address != "" {
            shareText = "\(shareText)Address : \(address)"
        }
        
        DispatchQueue.main.async {
            let image = Utils.convertToimg(with: self.viewMainShare)!
            let imageShare = [ image ,shareText ] as [Any]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.modalPresentationStyle = .overFullScreen
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        removePopView()
    }
    
    func setData() {
        
        lbCategory.text = serviceProviderDetail?.service_provider_category_name ?? ""
        
        
       
       
        ratingView.rating = Double(serviceProviderDetail?.averageRating ?? "0.0") ?? 0.0
        lbLocation.text = serviceProviderDetail?.serviceProviderAddress ?? ""
        
        if serviceProviderDetail?.serviceProviderEmail ?? "" != "" {
            lbMail.text = serviceProviderDetail?.serviceProviderEmail ?? ""
        } else {
            viewMail.isHidden = true
        }
      
        if serviceProviderDetail?.sp_webiste ?? "" != "" {
            lbWebSite.text = serviceProviderDetail?.sp_webiste ?? ""
        }else {
            viewWebSite.isHidden = true
        }
        
        if serviceProviderDetail?.work_description ?? "" != ""{
            lbDesc.text = serviceProviderDetail?.work_description ?? ""
        } else {
            viewDesc.isHidden = true
        }
        
        if serviceProviderDetail?.timing ?? "" != "" {
            lbTime.text = serviceProviderDetail?.timing ?? ""
            lbOpen.text = serviceProviderDetail?.openStatus ?? ""
           
        }else {
            viewTime.isHidden = false
        }
        
        ratingView.settings.fillMode = .half
        
        lbRating.text = "\(serviceProviderDetail?.totalRatings ?? "")"+" Rating"
        lbNoRating.text = serviceProviderDetail?.averageRating ?? "0"
        //lblTopHeading.text! = serviceProviderDetail.serviceProviderName
        lbName.text = serviceProviderDetail?.serviceProviderName ?? ""
        Utils.setImageFromUrl(imageView: ivImage, urlString: serviceProviderDetail?.serviceProviderUserImage
                                ?? "",palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
        lbCall.text! = serviceProviderDetail?.service_provider_phone_view ?? ""
        
        
        
        if serviceProviderDetail?.isKyc == "1"{
            viewVeryfied.isHidden = false
        }else {
            viewVeryfied.isHidden = true
        }
        
    }
    
}
