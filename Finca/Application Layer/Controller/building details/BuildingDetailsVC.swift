//
//  BuildingDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
class BuildingDetailsVC: BaseVC,CNContactViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
//    @IBOutlet weak var viewLeft1: RadialGradientSqureView!
//    @IBOutlet weak var viewLeft2: RadialGradientSqureView!
//    @IBOutlet weak var viewLeft3: RadialGradientSqureView!
//    @IBOutlet weak var viewRight1: RadialGradientSqureView!
//    @IBOutlet weak var viewRight2: RadialGradientSqureView!
//    @IBOutlet weak var viewRight3: RadialGradientSqureView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblBuildingBase: UILabel!
    @IBOutlet weak var lblSocietyName: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
//    @IBOutlet weak var lblBuilderName: UILabel!
//    @IBOutlet weak var lblBuilderAddress: UILabel!
//    @IBOutlet weak var lblMobileNumber: UILabel!
//    @IBOutlet weak var btnSecretaryEmail: UIButton!
//    @IBOutlet weak var lblBuilderDetails: UILabel!
    @IBOutlet weak var lblBuildingAuth: UILabel!
  //  @IBOutlet weak var lblStatisticalDetails: UILabel!
    
    @IBOutlet weak var lblbuildingPhone: UILabel!
    @IBOutlet weak var lblbuildingEmail: UILabel!
    @IBOutlet weak var lblbuildingwebsite: UILabel!
    @IBOutlet weak var tbvBuildingCell: UITableView!
    @IBOutlet weak var tbvHeighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnSecretaryMobile: UIButton!
    @IBOutlet weak var btnDialBuilderNumber: UIButton!
    @IBOutlet var seperatorView: [UIView]!
    
//    @IBOutlet weak var lblNumOfBlocks: UILabel!
//    @IBOutlet weak var lblNumOfUnits: UILabel!
//    @IBOutlet weak var lblPopulation: UILabel!
//    @IBOutlet weak var lblSatff: UILabel!
//    @IBOutlet weak var lblCarsParked: UILabel!
//    @IBOutlet weak var lblBikesParked: UILabel!
  //  @IBOutlet var cardview : [UIView]!
    @IBOutlet weak var bMenu: UIButton!
    
    //@IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var btnmobile: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbBuildingAddress: UILabel!
//    @IBOutlet weak var lbBuildingDetails: UILabel!
//    @IBOutlet weak var lbName: UILabel!
//    @IBOutlet weak var lbMobile: UILabel!
//    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbBuildingAutority: UILabel!
//    @IBOutlet weak var lbStatisticalDetails: UILabel!
//    @IBOutlet weak var lbBlocks: UILabel!
//    @IBOutlet weak var lbUnits: UILabel!
//    @IBOutlet weak var lbPopulation: UILabel!
//    @IBOutlet weak var lbResource: UILabel!
//    @IBOutlet weak var lbParkingCar: UILabel!
//    @IBOutlet weak var lbParkingBike: UILabel!
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    var Strmobile = ""
    var StrAddress = ""
    var stremail = ""
    var strwebsite = ""
    var StrSocietyname = ""
    var committeeList = [CommitteeModel]()
    
    var menuTitle = ""
    
    let itemCell = "BuildingDetailsCell"
   
    @IBOutlet weak var btnphone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnwebsite: UIButton!
    
    var strAssociationnumber = ""
    var strAssociationEmail = ""
    var strAssociationwebsite = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvBuildingCell.register(nib, forCellReuseIdentifier: itemCell)
        tbvBuildingCell.delegate = self
        tbvBuildingCell.dataSource = self
       // lblBuilderDetails.layer.cornerRadius = 5
       // lblBuilderDetails.layer.masksToBounds = true
        lblBuildingAuth.layer.cornerRadius = 5
        lblBuildingAuth.layer.masksToBounds = true
       // lblStatisticalDetails.layer.cornerRadius = 5
        //lblStatisticalDetails.layer.masksToBounds = true
        doGetBuildingDetails()

//        for view in cardview{
//            view.layer.shadowRadius = 2
//            view.layer.shadowOffset = CGSize.zero
//            view.layer.shadowOpacity = 0.3
//        }
//        setThreeCorner(viewMain: viewLeft1)
//        setThreeCorner(viewMain: viewLeft2)
//        setThreeCorner(viewMain: viewLeft3)
//        setThreeCorner(viewMain: viewRight1)
//        setThreeCorner(viewMain: viewRight2)
//        setThreeCorner(viewMain: viewRight3)
        
        lbTitle.text = menuTitle
        lbBuildingAddress.text = "\(doGetValueLanguage(forKey: "addresses")) :"
        lblbuildingwebsite.text = "\(doGetValueLanguage(forKey: "website")) :"
        lblbuildingEmail.text = "\(doGetValueLanguage(forKey: "email_contact_finca")) :"
        lblbuildingPhone.text = "\(doGetValueLanguage(forKey: "phone")) :"
//        lbBuildingDetails.text = doGetValueLanguage(forKey: "builder_details")
//        lbName.text = doGetValueLanguage(forKey: "name")
//        lbMobile.text = doGetValueLanguage(forKey: "mobile_no")
//        lbAddress.text = doGetValueLanguage(forKey: "address")
        lbBuildingAutority.text = doGetValueLanguage(forKey: "building_authorities")
         if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    @IBAction func ShareClick(_ sender: UIButton) {
        
        print(doGetLocalDataUser().societyLongitude!)
        print(doGetLocalDataUser().societyLatitude!)
        
        self.showProgress()
        
        var shareText = ""
      if strwebsite != ""
        {
           shareText = "Society Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!) \nWebsite: \(String(describing: strwebsite))"
      }
        else if stremail != ""
          {
             shareText = "Society Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!) \nEmail: \(String(describing: stremail))"
        }
        else if Strmobile != ""
          {
             shareText = "Society Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!) \nPhone: \(String(describing: Strmobile))"
        }
        else{
             shareText = "Society Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!)"
        }
        
       
        
        
        
        
        
        let shareAll = [ shareText ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        //        self.present(activityViewController, animated: true, completion: nil)
        self.present(activityViewController, animated: true) {
            self.hideProgress()
        }
        
    }
    @IBAction func CallClick(_ sender: UIButton) {
        
        let phone_number = Strmobile
        
        doCall(on: phone_number)
        
//        if let phoneCallURL = URL(string: "telprompt://\(phone_number)") {
//
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                if #available(iOS 10.0, *) {
//                    application.open(phoneCallURL, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                    application.openURL(phoneCallURL as URL)
//
//                }
//            }
//        }
    }
    @IBAction func onClickShareAddress(_ sender: Any) {
        
        
        //self.showProgress()
        
        var shareText = "Association Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!)"
        
       if  strwebsite != ""
        {
           shareText = shareText  + "\nWebsite: \(String(describing: strwebsite))"
       }
         if  stremail != ""
         {
            shareText = shareText + "\nEmail: \(String(describing: stremail))"
        }
         if  Strmobile != ""
         {
            shareText = shareText + "\nPhone: \(String(describing: Strmobile))"
        }
            
        
//       let shareText = "Society Name: \(String(describing: StrSocietyname))  \nAddress:  \(String(describing: StrAddress)) \n  https://maps.google.com/?q=\(doGetLocalDataUser().societyLatitude!),\(doGetLocalDataUser().societyLongitude!)"
//
        print(shareText)
        let shareAll = [ shareText ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        //        self.present(activityViewController, animated: true, completion: nil)
        self.present(activityViewController, animated: true) {
            //self.hideProgress()
        }
        
//        let text = doGetLocalDataUser().societyAddress
//        // set up activity view controller
//        let textToShare = [ text ]
//
//        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
    }
    @objc  func btnCallSecretary(_ sender: UIButton) {
        let phone_number = committeeList[sender.tag].adminMobile!
        if committeeList[sender.tag].mobile_private ?? "" == "1" {
                    // number is  privare
                    DispatchQueue.main.async { [self] in
                      
        //                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: self.baseVC.doGetValueLanguage(forKey: "this_mobile_number_is_private"), style: .Info , cancelText: self.baseVC.doGetValueLanguage(forKey: "ok"),okText: "OKAY")
                        self.toast(message: doGetValueLanguage(forKey: "this_mobile_number_is_private"), type: .Defult)
                    }
                    
                }else{
                    doCall(on: phone_number)
                }
//
//
//        doCall(on: phone_number)
        
//         {
//
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                if #available(iOS 10.0, *) {
//                    application.open(phoneCallURL, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                    application.openURL(phoneCallURL as URL)
//
//                }
//            }
//        }
    }
    @objc func btnOpenEmail(_ sender: UIButton) {
        
        let email = committeeList[sender.tag].adminEmail!
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnWebsiteAction(_ sender: Any) {
        
        if strAssociationwebsite != ""
        {
        
            let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "NoticcWebvw") as! NoticcWebvw
            vc.strUrl = strAssociationwebsite
            vc.strNoticetitle = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnEmailAction(_ sender: Any) {
        
        if strAssociationEmail != ""
        {
            if let url = URL(string: "mailto:\(strAssociationEmail)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
  
    
    @IBAction func btnPhoneAction(_ sender: Any) {
        
        
        if strAssociationnumber != ""
        {
            doCall(on: strAssociationnumber)
        }
     
    }
    
    
    @objc func btnSaveContact(_ sender: UIButton) {
        if committeeList[sender.tag].mobile_private ?? "" == "1" {
            showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "this_mobile_number_is_private"))
            return
        }
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        _ = tbvBuildingCell.indexPathForSelectedRow
        let admin_mobile = committeeList[sender.tag].adminMobile!
        let admin_email = committeeList[sender.tag].adminEmail!
        let admin_name = committeeList[sender.tag].adminName!
        //let admin_profile = committeeList[sender.tag].adminProfile!
        let contact = CNMutableContact()
        
        if admin_name != "" && admin_mobile != "" && admin_email != ""{
        contact.givenName = admin_name
        
//        let image = UIImage(systemName: admin_profile)
//        contact.imageData = image?.jpegData(compressionQuality: 1.0)
       
      let name = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: admin_name))
      contact.phoneNumbers = [name]
        
        
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: admin_email as NSString)
            contact.emailAddresses = [homeEmail]
        
      let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue : admin_mobile))
      contact.phoneNumbers = [homePhone]
        
        let vc = CNContactViewController(forNewContact: contact)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        saveRequest.add(contact, toContainerWithIdentifier: nil)

        do {
            try store.execute(saveRequest)
        } catch {
            print("Saving contact failed, error: \(error)")
            // Handle the error
        }
        
        }
        
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNotification(_ sender: Any) {

        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    @IBAction func onClickChat(_ sender: Any) {

        goToDashBoard(storyboard: mainStoryboard)
    }
    
    //
    override func viewWillLayoutSubviews() {
      //  tbvHeighConstraint.constant = tbvBuildingCell.contentSize.height
    }
    
    func doGetBuildingDetails(){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "buildingDetails":"buildingDetails",
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode ?? ""]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.buildingDetailsController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BuildingDetailResponse.self, from:json!)
                    if response.status == "200" {
                        if response.societyBased == ""{
                            self.lblBuildingBase.isHidden = true
                        }else{
                            self.lblBuildingBase.isHidden = false
                            self.lblBuildingBase.text = "   " + response.societyBased
                        }
                        self.lblSocietyName.text = "   "+response.societyName
                        self.StrSocietyname = response.societyName

                        Utils.setImageFromUrl(imageView: self.imgCompanyLogo, urlString: response.cover_photo!, palceHolder: "fincasys_notext")
                        self.StrAddress = response.societyAddress
                        self.StrSocietyname = response.societyName
                       
                        self.lblAddress.textAlignment = .left
                        self.lblAddress.text = response.societyAddress
                        self.lblWebsite.text = response.association_website
                        self.lblPhone.text = response.association_phone_number
                        self.lblEmail.text = response.association_email
                        
                        
                        self.strAssociationnumber = response.association_phone_number
                        self.strAssociationwebsite = response.association_website
                        self.strAssociationEmail = response.association_email
                        
                        self.stremail = response.association_email
                        self.strwebsite = response.association_website
                        self.Strmobile =  response.association_phone_number
                        
                        
                        if response.societyAddress == ""
                        {
                            
                            self.lbBuildingAddress.isHidden = true
                            self.lblAddress.isHidden = true
                        }
                        else{
                            
                            self.lbBuildingAddress.isHidden = false
                            self.lblAddress.isHidden = false
                        }
                        
                        if response.association_website == ""
                        {
                            self.btnwebsite.isHidden = true
                            self.lblbuildingwebsite.isHidden = true
                            self.lblWebsite.isHidden = true
                        }
                        else{
                            self.btnwebsite.isHidden = false
                            self.lblbuildingwebsite.isHidden = false
                            self.lblWebsite.isHidden = false
                        }
                        
                        if response.association_phone_number == ""
                        {
                            self.btnphone.isHidden = true
                            self.lblbuildingPhone.isHidden = true
                            self.lblPhone.isHidden = true
                        }
                        else{
                            self.btnphone.isHidden = false
                            self.lblbuildingPhone.isHidden = false
                            self.lblPhone.isHidden = false
                        }
                        if response.association_email == ""
                        {
                            self.btnwebsite.isHidden = true
                            self.lblbuildingEmail.isHidden = true
                            self.lblEmail.isHidden = true
                        }
                        else{
                            self.btnwebsite.isHidden = false
                            self.lblbuildingEmail.isHidden = false
                            self.lblEmail.isHidden = false
                        }
                      
                        
                        
                      //  self.lblBuilderName.text = response.builderName
                       // self.lblMobileNumber.text = response.builderMobile
                       // self.Strmobile =  response.builderMobile
                        self.committeeList.append(contentsOf: response.commitie)
                        
                        
                      
                        self.tbvBuildingCell.reloadData()
                        
                        
                        self.tbvHeighConstraint.constant = CGFloat(self.committeeList.count * 180)
                        
                        
                        
//                        self.lblNumOfBlocks.text = String(response.noOfBlocks)
//                        self.lblNumOfUnits.text = String(response.noOfUnits)
//                        self.lblPopulation.text = String(response.noOfPopulation)
                       // self.lblSatff.text = String(response.noOfStaff)
                     //   self.lblCarsParked.text = response.carAllocate+"/"+response.carCapcity
                       // self.lblBikesParked.text = response.bikeAllocate+"/"+response.bikeCapcity
                        
                       // self.lblBuilderAddress.text = response.builderAddress
                        
                    }else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
}
extension BuildingDetailsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return committeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvBuildingCell.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! BuildingDetailsCell
        //cell.imgSaveFile.image = UIImage(named: "save_black_36pt_2x")
        cell.lbName.text = doGetValueLanguage(forKey: "name")
        cell.lbRole.text = doGetValueLanguage(forKey: "designation")
        cell.lbMobile.text = doGetValueLanguage(forKey: "mobile_no")
        cell.lbEmail.text = doGetValueLanguage(forKey: "email_ID")
        cell.lblName.text = committeeList[indexPath.row].adminName
        
        cell.lblEmail.text = committeeList[indexPath.row].adminEmail
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: committeeList[indexPath.row].adminProfile, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)

        cell.lblTitle.text = committeeList[indexPath.row].roleName
//        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
//        let underlineAttributedString = NSAttributedString(string: committeeList[indexPath.row].adminMobile, attributes: underlineAttribute)
        cell.lblMobile.text = committeeList[indexPath.row].adminMobile

//        let underlineAttribute1 = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
//        let underlineAttributedString1 = NSAttributedString(string: committeeList[indexPath.row].adminEmail, attributes: underlineAttribute)
//        cell.lblEmail.attributedText = underlineAttributedString1

        
//        if committeeList[indexPath.row].mobile_private ?? "" == "1" {
//            cell.viewCall.isHidden = true
//        } else {
//            cell.viewCall.isHidden = false
//        }
        
        cell.selectionStyle = .none
        cell.btnEmail.tag = indexPath.row
        cell.btnEmail.addTarget(self, action: #selector(btnOpenEmail(_:)), for: .touchUpInside)
        cell.btnMobile.tag = indexPath.row
        cell.btnMobile.addTarget(self, action: #selector(btnCallSecretary(_:)), for: .touchUpInside)
        cell.btnSaveContact.addTarget(self, action: #selector(btnSaveContact(_:)), for: .touchUpInside)
        cell.btnSaveContact.tag = indexPath.row
        DispatchQueue.main.async {
            
            cell.shadowView.clipsToBounds = true
            cell.shadowView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
            self.viewAddress.clipsToBounds = true
            self.viewAddress.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
            //self.shadowView.clipsToBounds = true
           // self.shadowView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
            
//            self.viewLeft1.clipsToBounds = true
//            self.viewLeft1.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//            self.viewLeft2.clipsToBounds = true
//            self.viewLeft2.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//
//            self.viewLeft3.clipsToBounds = true
//            self.viewLeft3.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//
//            self.viewRight1.clipsToBounds = true
//            self.viewRight1.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//
//            self.viewRight2.clipsToBounds = true
//            self.viewRight2.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
//
//            self.viewRight3.clipsToBounds = true
//            self.viewRight3.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
            
            
            
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIButton {
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


