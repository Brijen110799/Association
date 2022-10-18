//
//  OfferDetailVC.swift
//  Finca
//
//  Created by silverwing_macmini3 on 12/28/1398 AP.
//  Copyright © 1398 anjali. All rights reserved.
//

import UIKit

class OfferDetailVC: BaseVC {
    var sliderData : Slider!
    @IBOutlet weak var imgOfferImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewWebsite: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var lbCall: UILabel!
    @IBOutlet weak var lbVideo: UILabel!
    @IBOutlet weak var lbWeb: UILabel!
    @IBOutlet weak var lbShare: UILabel!
    var context : HomeVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: imgOfferImage, urlString: sliderData.sliderImageName)
      //  print(sliderData)
        lblName.text = sliderData.aboutOffer
        viewCall.isHidden = true
        if sliderData.pageMobile != "" &&  sliderData.pageMobile.count > 2 {
            viewCall.isHidden = false
        }
        if sliderData.pageURL == ""{
            viewWebsite.isHidden = true
        }
        if sliderData.youtubeURL == ""{
            viewVideo.isHidden = true
        }
        lbCall.text = doGetValueLanguage(forKey: "call")
        lbVideo.text = doGetValueLanguage(forKey: "video")
        lbWeb.text = doGetValueLanguage(forKey: "web")
        lbShare.text = doGetValueLanguage(forKey: "share")
        
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        //self.sheetViewController?.dismiss(animated: false , completion: nil)
        removeFromParent()
        view.removeFromSuperview()
        
    }
    @IBAction func btnShareNow(_ sender: Any) {
        let image = imgOfferImage.image
        //let text = lblName.text ?? ""
        let shareAll = [ image as Any] as [Any]

        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func onClickCallNow(_ sender: Any) {
        if let phoneCallURL = URL(string: "telprompt://\(sliderData.pageMobile!)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    @IBAction func btnWebsiteClicked(_ sender: Any) {
        guard let url = URL(string: sliderData.pageURL!) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onClickWatchVideo(_ sender: Any) {
        
        let youtubeVideoID = sliderData.youtubeURL!
        print("youtube id",youtubeVideoID)
        if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID
            print("youtubeVideoID",youtubeVideoID)
            self.context.navigationController?.pushViewController(vc, animated: true)
            self.sheetViewController?.dismiss(animated: false , completion: nil)
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
    }
}
