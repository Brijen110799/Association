//
//  ProfileCompleteVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 24/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import EzPopup

class ProfileCompleteVC: BaseVC {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategoryLabel: UILabel!
    @IBOutlet weak var lbSubCategoryLabel: UILabel!
    @IBOutlet weak var lbDesigation: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var bSubmit: UIButton!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbSubCategory: UILabel!
    @IBOutlet weak var tfDesigation: ACFloatingTextfield!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var tfCategoryOther: ACFloatingTextfield!
    @IBOutlet weak var tfSubCategoryOther: ACFloatingTextfield!
    
    //@IBOutlet weak var lbTitle: UILabel!
    @IBOutlet  var views: [UIView]!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var viewMapImage: UIView!
    @IBOutlet weak var lbLatlong: UILabel!
    @IBOutlet weak var ivMap: UIImageView!
    
    var professionCategoryList = [ProfessionCategory]()
    var professionTypeList = [ProfessionType]()
    let request = AlamofireSingleTon.sharedInstance
    private var lat = ""
    private var long = ""
    private var category = ""
    private var subCategory = ""
    var imgUrl:String?
    var locAddress:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbTitle.text = doGetValueLanguage(forKey: "profile_completeness")
        
        lbCategoryLabel.text = doGetValueLanguage(forKey: "business_type")
        lbSubCategoryLabel.text = doGetValueLanguage(forKey: "business_type")
        lbCategory.text = doGetValueLanguage(forKey: "select_businees_type")
        lbSubCategory.text = doGetValueLanguage(forKey: "select_businees_type")
       
        tfCategoryOther.placeholder = doGetValueLanguage(forKey: "business_type")
        tfSubCategoryOther.placeholder = doGetValueLanguage(forKey: "business_type")
        
        
        tfDesigation.placeholder = doGetValueLanguage(forKey: "designation")
        tvAddress.placeholder = doGetValueLanguage(forKey: "address")
        lbDesigation.text = doGetValueLanguage(forKey: "designation")
        lbAddress.text = doGetValueLanguage(forKey: "address")
        
        
        tvAddress.placeholderColor = .gray
        bSubmit.setTitle(doGetValueLanguage(forKey: "submit"), for: .normal)
        lbLocation.text = doGetValueLanguage(forKey: "select_location_marker")
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        doGetCategory()
        
        //addKeyboardAccessory(textFields: [tfDesigation])
        //addKeyboardAccessory(textViews: [tvAddress])
        doneButtonOnKeyboard(textField: [tfDesigation,tfCategoryOther,tfSubCategoryOther])
        doneButtonOnKeyboard(textField: tvAddress)
        for item in views {
            setThreeCorner(viewMain: item)
        }
        
    }


    @IBAction func tapCategory(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 1
        vc.profileCompleteVC = self
        vc.professionCategoryList = self.professionCategoryList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func tapSubCategory(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 2
        vc.profileCompleteVC = self
        vc.professionTypeList = self.professionTypeList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    @IBAction func tapSubmit(_ sender: Any) {
        if isValidateData() {
            doUpdateData()
        }
    }
    @IBAction func tapLocation(_ sender: Any) {
//        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "idSelectLocationMapVC") as! SelectLocationMapVC
//        vc.onTapMediaSelect = self
//         pushVC(vc: vc)
        let vc = SelectProfileLocationVC(nibName: "SelectProfileLocationVC", bundle: nil)
        vc.delegate = self
        pushVC(vc: vc)
    }
    
    private func isValidateData() -> Bool {
        var isValida = true
        
        if category == "" {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_your_business_type"))
            isValida = false
        } else {
            
            if category.lowercased() == "other".lowercased() {
                
               if tfCategoryOther.text == "" {
                    tfCategoryOther.showErrorWithText(errorText: doGetValueLanguage(forKey: "enter_here"))
                    isValida = false
                }
                
            }
            
        }

        
//        if subCategory == "" {
//            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_your_business_type"))
//            isValida = false
//        } else {
//
//            if subCategory.lowercased() == "other".lowercased() {
//
//               if tfSubCategoryOther.text == "" {
//                    tfSubCategoryOther.showErrorWithText(errorText: doGetValueLanguage(forKey: "enter_here"))
//                    isValida = false
//                }
//
//            }
//        }
        
        
        if tfDesigation.text!.isEmptyOrWhitespace()  {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "please_enter_valid_designation"))
            isValida = false
        }
        if tvAddress.text!.isEmptyOrWhitespace(){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "Please_enter_valid_company_address"))
            isValida = false
        }
        if lat == "" {
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "select_your_address_location"))
            isValida = false
        }
        return isValida
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height

    }

    @objc func keyboardWillHide(notification: NSNotification) {

        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
    }
    
    private func doGetCategory(){
        self.showProgress()
        let params = ["getCatgory": "getCatgory", "society_id": doGetLocalDataUser().societyID ?? ""]
//     print(params)
        request.requestPost(serviceName: ServiceNameConstants.bussinessCategoryController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
                self.hideProgress()
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                    if response.status == "200"{
                        self.professionCategoryList = response.category
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }
    
    
     func doInitProfessionTypeArr(tag:Int!,selectedIndexPath : IndexPath!,identifier:String! = ""){
        
        switch tag {
       
        case 1:
            self.professionTypeList.removeAll()
            subCategory = ""
            self.lbSubCategory.text = doGetValueLanguage(forKey: "select_businees_type")
            for data in professionCategoryList{
                if data.categoryId == identifier{
                    //self.professionTypeList.append(contentsOf: data.subCategory)
                    self.lbCategory.text = data.categoryIndustry!
                    category = data.categoryIndustry!
                    tfSubCategoryOther.isHidden = true
                    if category.lowercased() == "other".lowercased() {
                        tfCategoryOther.isHidden = false
                    } else {
                        tfCategoryOther.isHidden = true
                    }
                }
            }
            break;
        case 2:
            for (_,data) in professionTypeList.enumerated(){
                if data.categoryName == identifier{
                    self.lbSubCategory.text = data.categoryName
                    subCategory = data.categoryName
                    
                    if subCategory.lowercased() == "other".lowercased() {
                        tfSubCategoryOther.isHidden = false
                    } else {
                        tfSubCategoryOther.isHidden = true
                    }
                }
            }
        default:
            break;
        }
    }
    
    private func doUpdateData() {
        showProgress()
        
        let params = ["updateBusinessDetails":"updateBusinessDetails",
                      "society_id":doGetLocalDataUser().societyID ?? "",
                      "plot_lattitude":lat,
                      "plot_longitude":long,
                      "unit_id":doGetLocalDataUser().unitID ?? "",
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "business_categories":category,
                      "business_categories_other":tfCategoryOther.text ?? "",
                      "business_categories_sub":category,
                      "professional_other" : tfCategoryOther.text ?? "",
                      "designation" : tfDesigation.text ?? "",
                      "company_address" : tvAddress.text ?? "",
                      "user_mobile" : doGetLocalDataUser().userMobile ?? ""]
        request.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (Data, Err) in
            self.hideProgress()
            if Data != nil{
              
                //                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                    if response.status == "200"{
                    
                        self.instanceLocal().setCompleteProfile(setData: true)
                        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER) as! SWRevealViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
        
    }
}
/*extension ProfileCompleteVC : OnTapMediaSelect {
    func onLocationSuccess(location: String, address: String) {
        <#code#>
    }
    
    func onSuccessMediaSelect(image: [UIImage], fileImage: [URL]) {

    }

    func onSucessUploadingFile(fileUrl: [String], msg: String) {

    }

    func selectDocument(fileArray: [URL], type: String, file_duration: String) {

    }

    func onTapOthers(type: String) {

    }
    
//    func onLocationSuccess(location: String, address: String) {
//        lat = String(location.split(separator: ",")[0])
//        long = String(location.split(separator: ",")[1])
//
//        lbLatlong.text = "\(lat)\n\(long)"
//        viewMapImage.isHidden = false
//        let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C"
//            + location + "&key=" + StringConstants.MAP_KEY
//
//        ivMap.setImage(url: URL(string: mapUrl)!)
//    }
 
}*/

extension ProfileCompleteVC : locationDelegate {
    func getLocationdata(lat: String, long: String, imgUrl: String, address: String) {
        
        self.imgUrl = imgUrl
        self.lat = lat
        self.long = long
        self.lbLatlong.text = "\(lat)\n\(long)"
        self.locAddress = address
        viewMapImage.isHidden = false
        //        let mapUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C" + "\(lat),\(long)" + "&key=" + StringConstants.GOOGLE_MAP_KEY
        //        Utils.setImageFromUrl(imageView: imgMap, urlString: mapUrl)
        
        let mapLocImgUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C\(lat),\(long)&key=\(StringConstants.GOOGLE_MAP_KEY)"
        
        if let mapUrl = URL(string: mapLocImgUrl) {
            self.ivMap.setImage(url: mapUrl)
        }
        
    }
}
