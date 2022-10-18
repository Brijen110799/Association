//
//  ShareBusinessICardVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 19/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import MarqueeLabel
import Toast_Swift

class ShareBusinessICardVC: BaseVC {
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
    @IBOutlet weak var lbltextpath:UILabel!
    
    @IBOutlet weak var ivCompanyLogo: UIImageView!
    
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
        DispatchQueue.main.async {
            self.setupMarqee(label:self.lbltitleSocietyname)
            self.lbltitleSocietyname.triggerScrollStart()
        }
        if StrPassFrom == "1"
        {
           
            lbltitleSocietyname.text = society_namee
            let fullname = modelFamilyMember.userFirstName + "  " + modelFamilyMember.userLastName
            lblname.text = fullname
            self.lblno.text =  unitName + "-" + blockName
            
         
            lblmobilenumber.text = modelFamilyMember.userMobile ?? ""
            lbldeveloper.text = modelFamilyMember.designation ?? ""
           // print(userProfileReponse.society_address ?? "")
           // lbltextpath.text = userProfileReponse.society_address ?? ""
                //modelFamilyMember.company_address ?? ""
            Utils.setImageFromUrl(imageView: ImgProfile, urlString: modelFamilyMember.userProfilePic ?? "", palceHolder: "user_default")
            Utils.setImageFromUrl(imageView: ImgvWQrCode, urlString: modelFamilyMember.icard_qr_code ?? "", palceHolder: "no-image-available")
            
            lblSociety.text = society_namee
            lblcompanyname.text = companyname
            lbltextpath.text = textpath
            
        }else
        {
            let Fullname = userProfileReponse.userFirstName + " " + userProfileReponse.userLastName
            lblname.text = Fullname
            lblno.text = "\(userProfileReponse.floorName ?? "")-\(userProfileReponse.blockName ?? "")"
            lblmobilenumber.text = userProfileReponse.countryCode + userProfileReponse.userMobile
            lbldeveloper.text = userProfileReponse.designation ?? ""
            lblcompanyname.text = userProfileReponse.companyName ?? ""
            lbltextpath.text = userProfileReponse.companyAddress ?? ""
            lblSociety.text = userProfileReponse.society_name
            lbltitleSocietyname.text = userProfileReponse.society_name ?? ""
            
            Utils.setImageFromUrl(imageView: ImgProfile, urlString: userProfileReponse.userProfilePic ?? "", palceHolder: "user_default")
            Utils.setImageFromUrl(imageView: ImgvWQrCode, urlString: userProfileReponse.icardQrcode ?? "", palceHolder: "no-image-available")
            
            
            if  userProfileReponse.company_logo ?? "" != "" {
                ivCompanyLogo.isHidden = false
                Utils.setImageFromUrl(imageView: ivCompanyLogo, urlString: userProfileReponse.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            }
           
           // if let complogog = doGetLocalDataUser().co
            
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
        let image = viewSnapshot.snapshotVieww()!
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
        let image = viewSnapshot.snapshotVieww()
        let shareAll = [ image as Any ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension UIView{
    func snapshotVieww() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
