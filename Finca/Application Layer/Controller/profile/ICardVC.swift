//
//  ICardVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 10/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
import MarqueeLabel

class ICardVC: BaseVC {
    @IBOutlet weak var viewSnapshot: UIView!
    @IBOutlet weak var ImgMain:UIImageView!
    @IBOutlet weak var ImgProfile:UIImageView!
    @IBOutlet weak var ImgvWQrCode:UIImageView!
    @IBOutlet weak var lblname:MarqueeLabel!
    @IBOutlet weak var lblno:MarqueeLabel!
    @IBOutlet weak var lblmobilenumber:UILabel!
    @IBOutlet weak var lbldeveloper:UILabel!
    @IBOutlet weak var lblcompanyname:UILabel!
    @IBOutlet weak var lbltitleSocietyname:MarqueeLabel!
    @IBOutlet weak var lblSociety:UILabel!
    @IBOutlet weak var lbltextpath:MarqueeLabel!
    var userProfileReponse : MemberDetailResponse!
    var responseProfessional : ResponseProfessional!
    var modelFamilyMember:MemberDetailModal!
    var StrPassFrom = ""
    var blockName = ""
    var unitName = ""
    var society_namee = ""
    var companyname = ""
    var textpath = ""
    var designations = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarqee(label: lbltitleSocietyname)
        lbltitleSocietyname.triggerScrollStart()
        if StrPassFrom == "1"
        {
            lbltitleSocietyname.text = society_namee
            let fullname = modelFamilyMember.userFirstName + "  " + modelFamilyMember.userLastName
            lblname.text = fullname
            self.lblno.text = blockName + "-" + userProfileReponse.floorName
          //  lblmobilenumber.text = modelFamilyMember.userMobile ?? ""
           // lbldeveloper.text = modelFamilyMember.designation ?? ""
            lbltextpath.text = textpath
                //modelFamilyMember.company_address ?? ""
            Utils.setImageFromUrl(imageView: ImgProfile, urlString: modelFamilyMember.userProfilePic ?? "", palceHolder: "user_default")
            Utils.setImageFromUrl(imageView: ImgvWQrCode, urlString: modelFamilyMember.icard_qr_code ?? "", palceHolder: "no-image-available")
            
            lblSociety.text = society_namee
           // lblcompanyname.text = companyname
            
        }else
        {
            lbldeveloper.text = userProfileReponse.designation
            lblmobilenumber.text = ("\(userProfileReponse.countryCode ?? "") \(userProfileReponse.userMobile ?? "")")
            let Fullname = userProfileReponse.userFirstName + " " + userProfileReponse.userLastName
            lblname.text = Fullname
            lblno.text = userProfileReponse.blockName + "-" + userProfileReponse.unitName
           // lblmobilenumber.text = userProfileReponse.userMobile ?? ""
          //  lbldeveloper.text = userProfileReponse.designation ?? ""
            lblcompanyname.text = userProfileReponse.companyName ?? ""
            lbltextpath.text = userProfileReponse.society_address ?? ""
            lblSociety.text = userProfileReponse.society_name
            lbltitleSocietyname.text = userProfileReponse.society_name ?? ""
            
            Utils.setImageFromUrl(imageView: ImgProfile, urlString: userProfileReponse.userProfilePic ?? "", palceHolder: "user_default")
            Utils.setImageFromUrl(imageView: ImgvWQrCode, urlString: userProfileReponse.icardQrcode ?? "", palceHolder: "no-image-available")
            
            lbltextpath.type = .continuous
            lbltextpath.speed = .duration(15)
            lbltextpath.animationCurve = .easeInOut
            lbltextpath.fadeLength = 10.0
        }
        DispatchQueue.main.async {
            self.setupMarqee(label:self.lblname)
            self.lblname.triggerScrollStart()
        }
        DispatchQueue.main.async {
            self.setupMarqee(label:self.lblno)
            self.lblno.triggerScrollStart()
        }
       
    }
    @IBAction func BackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDownloadClicked(_ sender: UIButton) {
            let image = viewSnapshot.snapshotVieww2()!
           UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
           self.view.makeToast("Image Saved to Gallery", duration: 2.0, position: .bottom, style: successStyle)
    }
    func convertUIImageToString (image: UIImage) -> String {

        var imageAsData: Data = image.pngData()!
        var imageAsInt: Int = 0 // initialize

        let data = NSData(bytes: &imageAsData, length: MemoryLayout<Int>.size)
        data.getBytes(&imageAsInt, length: MemoryLayout<Int>.size)

        let imageAsString: String = String (imageAsInt)

        return imageAsString

    }
    @IBAction func ShareClick(_ sender: UIButton) {
        let image = viewSnapshot.snapshotVieww2()
        let shareAll = [ image as Any ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension UIView{
    func snapshotVieww2() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
