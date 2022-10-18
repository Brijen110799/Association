//
//  SeasonalGreetingsDetailVC.swift
//  Zoobiz
//
//  Created by zoobiz mac min on 07/04/21.
//

import UIKit



class SeasonalGreetingsDetailVC: BaseVC {

    //MARK: IBOutlets & Variable Declaration:

//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var lblBusName: UILabel!
//    @IBOutlet weak var viewTextlables: UIView!

    @IBOutlet weak var btnTextOption1: UIButton!
    @IBOutlet weak var btnTextOption2: UIButton!
    @IBOutlet weak var btnTextOption3: UIButton!

//    @IBOutlet weak var btnLogoSmall: UIButton!
//    @IBOutlet weak var btnLogoMedium: UIButton!
//    @IBOutlet weak var btnLogoLarge: UIButton!
//    @IBOutlet weak var lblLogoSmall: UILabel!
//    @IBOutlet weak var lblLogoMedium: UILabel!
//    @IBOutlet weak var lblLogoLarge: UILabel!

    
    @IBOutlet weak var viewDrawContent: UIView!
    @IBOutlet weak var viewGreetings: UIView!

    @IBOutlet weak var imgBackground: UIImageView!
  //  @IBOutlet weak var imgBusinessLogo: UIImageView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTextOption1: UILabel!
    @IBOutlet weak var lblTextOption2: UILabel!
    @IBOutlet weak var lblTextOption3: UILabel!
    
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var viewLogo: UIView!
   // @IBOutlet weak var switchBusLogo: KNSwitcher!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var lbShowLogo: UILabel!
    @IBOutlet weak var lbShareGreeting: UILabel!
    @IBOutlet weak var viewPinchName: PanRotatePinchUIView!
    var selImageArray : GreetingData?
    var menuTitle : String!
    @IBOutlet weak var switchLogo: LabelSwitch!
    //MARK: View Cycle Methods:
    private var fonts = [String]()
    private var fontIndex = 0
    private var colors = [UIColor.black,UIColor.white]
    private var colorIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewText.isHidden = true
        viewLogo.isHidden = true
        
        if let object = selImageArray {
            
            if let imgUrl = object.background_image {
                Utils.setImageFromUrl(imageView: self.imgBackground, urlString: imgUrl, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
                lblTitle.text = object.main_title ?? ""
            }
            
           
            doGetProfileData()
        
        }

        ivLogo.isHidden = true
       // viewGreetings.shouldResetViewPositionAfterRemovingDraggability = true
       // ivLogo.addDraggability(withinView: self.viewGreetings)
       // lbName.addDraggability(withinView:  self.viewGreetings)

        
        lbName.text = ""
        viewPinchName.borderWidth = 1
        viewPinchName.borderColor  = .green
        setupSwitchButton(labelSwitch: switchLogo, isCheck: false)
        lbText.text = doGetValueLanguage(forKey: "text")
        lbColor.text = doGetValueLanguage(forKey: "color")
        lbShowLogo.text = doGetValueLanguage(forKey: "show_company_logo")
        lbShareGreeting.text = doGetValueLanguage(forKey: "share_greeting").uppercased()
       
        
        
//        for family: String in UIFont.familyNames
//            {
//                print(family)
//                for names: String in UIFont.fontNames(forFamilyName: family)
//                {
//                    print("== \(names)")
//                }
//            }
        
        fontAdd()
        
        
    }
    
    private func fontAdd() {
        fonts.append(Static.sharedInstance.zoobiz_font_regular)
        fonts.append(Static.sharedInstance.zoobiz_font_semibold)
        fonts.append(Static.sharedInstance.zoobiz_font_bold)
        fonts.append(Static.sharedInstance.font_gotham_book)
        fonts.append(Static.sharedInstance.font_gotham_bold)
        fonts.append(Static.sharedInstance.font_gotham_black)
        fonts.append(Static.sharedInstance.font_montserrat_semibold)
        fonts.append(Static.sharedInstance.font_montserrat_regular)
        fonts.append(Static.sharedInstance.font_Modern)
        fonts.append(Static.sharedInstance.font_Great_Vibes)
        fonts.append(Static.sharedInstance.font_Bubble)
        fonts.append(Static.sharedInstance.font_Roboto_Black)
        fonts.append(Static.sharedInstance.font_Comic)
        lbName.font = UIFont(name: fonts[fontIndex] , size: CGFloat(14))
        lbName.textColor = colors[colorIndex]
    }
   
 
  
        
    func doGetProfileData() {
        //showProgress()
        let params = ["getAbout":"getAbout",
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "unit_id":doGetLocalDataUser().unitID ?? "",
                      "society_id":doGetLocalDataUser().societyID ?? ""]
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.profesional_detail_controller, parameters: params) { [self] (json, error) in
            //hideProgress()
            if json != nil {
               
                print(json as Any)
                do {
                    let response = try JSONDecoder().decode(ResponseMemberNew.self, from:json!)
                    if response.status == "200" {
                        
                            viewLogo.isHidden = true
//                            if let businessLogo = response.company_logo {
//                                if businessLogo.replacingOccurrences(of: " ", with: "") != "" {
//                                    viewLogo.isHidden = false
//                                    Utils.setImageFromUrl(imageView: self.imgBusinessLogo, urlString: businessLogo, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
//                                }
//                            }
                        
                       
                        
                        if response.company_logo ?? "" != "" {
                            viewLogo.isHidden = false
                            Utils.setImageFromUrl(imageView: self.ivLogo, urlString: response.company_logo ?? "", palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
                        }
                   
                        
                        if let object = selImageArray {
                           
                            viewText.isHidden = true
                            if let showText = object.show_from_name {
                                if showText {
                                    viewText.isHidden = false
                                    let name = response.user_full_name ?? ""
                                    let compName = response.company_name ?? ""
                                    lblTextOption1.text = name
                                    lblTextOption2.text = "\(name) And \(compName)"
                                    lblTextOption3.text = compName
                                    btnTextOption1.isSelected = true
                                    lblTextOption1.textColor = .black
                                    self.lbName.text = lblTextOption1.text
                                }
                            }
                             
                        }
                            
                       
                        
                    }else {
                        self.toast(message: response.message ?? "", type: .Faliure)
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    //MARK: Server Request Functions:
    
    func doAttemptToshareSeasonalGeerting() {
        
//        if let object = selImageArray {
//            var userID = ""
//            if let profile = Utils.doGetUserProfileData() {
//                userID = profile.userID ?? ""
//            }
//
//            let params = ["shareSeasonalGreetNew" : "shareSeasonalGreetNew", "user_id": userID, "seasonal_greet_id": object.seasonal_greet_image_id ?? ""]
//            request.requestPost(serviceName: NetworkAPI.common_controller, parameters: params) { (data, error) in
//
//                DispatchQueue.main.async {
//                    if data != nil {
//                        do {
//                            let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
//                            if response.status == "200" {
//                                print(response)
//                            }
//                        }
//                        catch {
//                            print("parse error", error.localizedDescription)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    

  

    
    func convertToimg(with view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()

            return image
        }
        return nil
    }

    //MARK: Button Actions:
    
    
    @IBAction func tapbtnHome(_ sender: UIButton) {
        Utils.setHome()
    }
    
    @IBAction func tapBtnShare(_ sender: Any) {
       // self.doAttemptToshareSeasonalGeerting()
        
        viewPinchName.borderColor  = .clear
        DispatchQueue.main.async {
            let image = Utils.convertToimg(with: self.viewGreetings)!
            let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.modalPresentationStyle = .overFullScreen
            self.present(activityViewController, animated: true, completion:{
                self.viewPinchName.borderWidth = 1
                self.viewPinchName.borderColor  = .green
            })
        }
    }

    @IBAction func onTapBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func tapbtnTextOptions(_ sender: UIButton) {
        if sender.tag == 0 {
            btnTextOption1.isSelected = true
            btnTextOption2.isSelected = false
            btnTextOption3.isSelected = false
            lblTextOption1.textColor =  .black
            lblTextOption2.textColor = .black
            lblTextOption3.textColor = .black
            self.lbName.text = lblTextOption1.text
        }
//        else if sender == btnTextOption2 {
        else if sender.tag == 1 {

            btnTextOption1.isSelected = false
            btnTextOption2.isSelected = true
            btnTextOption3.isSelected = false
            lblTextOption1.textColor =  .black
            lblTextOption2.textColor = .black
            lblTextOption3.textColor = .black
            self.lbName.text = lblTextOption2.text
        }
        else {
            
            btnTextOption1.isSelected = false
            btnTextOption2.isSelected = false
            btnTextOption3.isSelected = true
            lblTextOption1.textColor = .black
            lblTextOption2.textColor = .black
            lblTextOption3.textColor = .black
            self.lbName.text = lblTextOption3.text
        }
        
    }

    @IBAction func onChangeSlider(_ sender: UISlider) {
        //ivLogo.frame.size.width = CGFloat(48 + (10 * sender.value))
        //ivLogo.frame.size.height = CGFloat(48 + (10 * sender.value))
        let val = 14 + roundf(sender.value)
        
        lbName.font = UIFont(name: fonts[fontIndex] , size: CGFloat(val))
      //  print("change slide \(val)")
        
    }
    
    private func setupSwitchButton(labelSwitch:LabelSwitch ,isCheck  : Bool) {
        labelSwitch.lText = doGetValueLanguage(forKey: "on_setting").uppercased()
        labelSwitch.rText = doGetValueLanguage(forKey: "off").uppercased()
        labelSwitch.lBackColor = ColorConstant.colorP
        labelSwitch.lTextColor =  .white
       
        labelSwitch.rBackColor = .white
        labelSwitch.rTextColor = ColorConstant.colorP
        
         labelSwitch.borderColor = ColorConstant.colorP
        labelSwitch.borderWidth = 0.5
       
        labelSwitch.delegate = self
        labelSwitch.fullSizeTapEnabled = true
        
       
        if isCheck {
            labelSwitch.curState = .R
            labelSwitch.circleColor = .white
        } else {
            labelSwitch.curState = .L
            labelSwitch.circleColor = ColorConstant.colorP
        }
       
    }
    
    @IBAction func tapFontchanges() {
        
        if fontIndex == fonts.count - 1 {
            fontIndex = 0
        }else {
            fontIndex += 1
        }
        lbName.font = UIFont(name: fonts[fontIndex] , size: CGFloat(14))
        
    }
    
    @IBAction func tapColorChanges() {
        
        if colorIndex == colors.count - 1 {
            colorIndex = 0
        }else {
            colorIndex += 1
        }
        lbName.textColor = colors[colorIndex]
        
    }
    
    
}


extension SeasonalGreetingsDetailVC: UIGestureRecognizerDelegate ,LabelSwitchDelegate{
    
 
       //todo for swich button
       func switchChangToState(sender: LabelSwitch) {
               
               if sender.curState == .L {
                   //off
                   ivLogo.isHidden  = true
                   switchLogo.circleColor = ColorConstant.colorP
               } else {
                   //on
                   ivLogo.isHidden  = false
                   switchLogo.circleColor = .white
               }
               
           
       }
}
