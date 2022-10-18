//
//  iCardVC.swift
//  Finca
//
//  Created by CHPL Group on 30/03/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class iCardVC: BaseVC {
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var viewSnapshot: UIView!
    @IBOutlet weak var viewQR: UIView!
    @IBOutlet weak var lblEnrolment: UILabel!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lbTitleEnrolment: UILabel!
    @IBOutlet weak var lbTitleBloodGroup: UILabel!
    @IBOutlet weak var lbTitleAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAssociationName: UILabel!
    @IBOutlet weak var lbTitlePhoneNumber: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var ivQR: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var button = 0
    var userProfileReponse : MemberDetailResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewQR.isHidden = true
        viewSnapshot.isHidden = false
        lbTitleAddress.text = self.doGetValueLanguage(forKey: "addresses")
        lbTitleBloodGroup.text = self.doGetValueLanguage(forKey: "blood_group")
        lbTitlePhoneNumber.text = self.doGetValueLanguage(forKey: "mobile_no")
        lblName.text = userProfileReponse.userFullName
        lblAddress.text = userProfileReponse.companyAddress
        lblBloodGroup.text = userProfileReponse.blood_group ?? "o+"
        lblEnrolment.text = doGetLocalDataUser().advocate_code
        lblPhoneNumber.text = ("\(String(describing: userProfileReponse.countryCode) ) \(userProfileReponse.userMobile ?? "")")
        lblAssociationName.text = userProfileReponse.society_name
        Utils.setImageFromUrl(imageView: ivQR, urlString: userProfileReponse.icardQrcode)
        Utils.setImageFromUrl(imageView: ivProfileImage, urlString: userProfileReponse.userProfilePic, palceHolder: "user_default")
        
        
        if (lblName.text?.isEmptyOrWhitespace())!  {
            lblName.text = self.doGetValueLanguage(forKey: "no_data")
        }
        if (lblAddress.text?.isEmptyOrWhitespace())!  {
            lblAddress.text = self.doGetValueLanguage(forKey: "no_data")
        }
        if (lblBloodGroup.text?.isEmptyOrWhitespace())!  {
            lblBloodGroup.text = self.doGetValueLanguage(forKey: "no_data")
        }
        if (lblEnrolment.text?.isEmptyOrWhitespace())!  {
            lblEnrolment.text = self.doGetValueLanguage(forKey: "no_data")
        }
        if (lblPhoneNumber.text?.isEmptyOrWhitespace())!  {
            lblPhoneNumber.text = self.doGetValueLanguage(forKey: "no_data")
        }
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
 
    func doroteta()  {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
   
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func btnDownloadClicked(_ sender: UIButton) {
        button = button + 1
        print(button)
            switch button {
            case 1:
                viewQR.isHidden = false
                viewSnapshot.isHidden = true
                break;
            case 2:
                viewQR.isHidden = true
                viewSnapshot.isHidden = false
                button = 0
                break;
            default:
                print("Unknown")
                return
            }
    }

    @IBAction func ShareClick(_ sender: UIButton) {
        let image = viewSnapshot.snapshotViewww()
        let shareAll = [ image as Any ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension UIView{
    func snapshotViewww() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIView {

    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}
