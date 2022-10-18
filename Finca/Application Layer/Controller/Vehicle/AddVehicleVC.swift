//
//  AddVehicleVC.swift
//  Finca
//
//  Created by CHPL Group on 07/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import SwiftUI

class AddVehicleVC: BaseVC {
    enum Vehicle : String{
        case car = "Car"
        case bike = "Bike"
        case Default = ""
    }
   
    @IBOutlet weak var lbvehicletype: UILabel!
    @IBOutlet weak var lbrcphoto: UILabel!
    @IBOutlet weak var lbVehiclephoto: UILabel!
    @IBOutlet weak var scollvw:UIScrollView!
    var selectedImages = [UIImage]()
    var AllVehicleList = [list]()
    var vechilesModelEditFromParking:list!
    var isComeFromParking = ""
    var strQRcodeId = ""
    var vehiclercbook = ""
    var vehicleimage = ""
    var tag = ""
    var initForUpdate = false
    var pickertag = 0
    var unit = ""
    var Cat : Vehicle = Vehicle.Default
    @IBOutlet weak var ivproofimage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfVehicleNumber:UITextField!
    @IBOutlet weak var ivAddVehicleImage:UIImageView!
    @IBOutlet weak var imgOnRadiobutton:UIImageView!
    @IBOutlet weak var imgOffRadiobutton:UIImageView!
    @IBOutlet weak var btnCar:UIButton!
    @IBOutlet weak var btnBike:UIButton!
    @IBOutlet weak var btnADD:UIButton!
    var vehicleimgdata = Data()
    var rcimgdata = Data()
    var vehicleimgrequired = ""
    var rcimgrequired = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tfVehicleNumber.delegate = self
        unit = "1"
        
       
        
       
        lbvehicletype.text = doGetValueLanguage(forKey: "vehicle_type")
        tfVehicleNumber.placeholder =  doGetValueLanguage(forKey: "vehicle_number")
        
        
        if self.isKeyPresentInUserDefaults(key: StringConstants.VEHICLE_PHOTO_REQUIRED) {
            if let vehiclephotorequired = UserDefaults.standard.string(forKey: StringConstants.VEHICLE_PHOTO_REQUIRED) {
                
                self.vehicleimgrequired = vehiclephotorequired
             
                if vehiclephotorequired == "1"
                {
                    lbVehiclephoto.text = "\(doGetValueLanguage(forKey: "vehicle_photo"))*"
                }
                else{
                    lbVehiclephoto.text = doGetValueLanguage(forKey: "vehicle_photo")
                }
                
            }
        }
        
        if self.isKeyPresentInUserDefaults(key: StringConstants.RC_BOOK_PHOTO_REQUIRED) {
            if let rcphotorequired = UserDefaults.standard.string(forKey: StringConstants.RC_BOOK_PHOTO_REQUIRED) {
             
                self.rcimgrequired = rcphotorequired
                if rcphotorequired == "1"
                {
                    lbrcphoto.text = "\(doGetValueLanguage(forKey: "vehicle_ownership_proof"))*"
                }
                else{
                    lbrcphoto.text = doGetValueLanguage(forKey: "vehicle_ownership_proof")
                }
                
            }
        }

        
        
        
    if isComeFromParking == "1"
        {
        
        self.btnADD.setTitle(doGetValueLanguage(forKey: "update"), for: .normal)
        self.lbTitle.text = doGetValueLanguage(forKey: "edit_vehicle_details")
        
        tfVehicleNumber.text = vechilesModelEditFromParking.vehiclenumber
        
        
          
          if let type = vechilesModelEditFromParking.vehicletype
          {
              if type == "1"
              {
                 
                  self.Cat = Vehicle.bike
                  self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
                  self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
                  unit = "1"
                 
              }
              else{
                 
                  self.Cat = Vehicle.car
                  self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
                  self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
                  unit = "0"
              }
          }
        if let vehiclephoto = vechilesModelEditFromParking.vehiclephoto
        {
            self.vehicleimgrequired = "0"
            
            Utils.setImageFromUrl(imageView:ivAddVehicleImage , urlString: vehiclephoto)
           
        }
          
          
        if let rcbook = vechilesModelEditFromParking.rcbook
        {
            self.rcimgrequired = "0"
            Utils.setImageFromUrl(imageView:ivproofimage , urlString:rcbook)
           
        }
          
        
    }
        else{
            self.btnADD.setTitle(doGetValueLanguage(forKey: "add"), for: .normal)
            self.lbTitle.text = doGetValueLanguage(forKey: "add_vehicle_details")
        }
    
        tfVehicleNumber.autocapitalizationType = .allCharacters
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    
    
    func doUpdatevehicle() {
        showProgress()
     
        let params = ["key":apiKey(),
                      "updateVehicle":"updateVehicle",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "language_id":doGetLanguageId(),
                      "block_id":doGetLocalDataUser().blockID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "vehicle_type":unit,
                      "vehicle_id":vechilesModelEditFromParking.vehicle_id,
                      "qrcode_id": vechilesModelEditFromParking.qrcode_id,
                      "vehicle_photo": "",
                      "vehicle_rc_book": "",
                      "old_vehicle_photo":vechilesModelEditFromParking.old_vehiclephoto,
                      "old_rc_book":vechilesModelEditFromParking.old_rcbook,
                      "vehicle_number":tfVehicleNumber.text!,
        ]
        print("param" , params)
       
       
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPostMultipartmultiImagesfromdata(serviceName: ServiceNameConstants.vehicle_controller, parameters: params as [String : Any],imageData: vehicleimgdata,fileName: "vehicle_photo",imageData1: rcimgdata ,fileName1: "vehicle_rc_book", compression: 0.3) { (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
                    if response.status == "200"{
                        self.doPopRootBAck()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height

    }

    @objc func keyboardWillHide(notification: NSNotification) {

        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scollvw.contentInset = contentInsets
        self.scollvw.scrollIndicatorInsets = contentInsets
    }
    
    
    func doAddvehicle() {
        showProgress()
     
        let params = ["key":apiKey(),
                      "addVehicle":"addVehicle",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "language_id":doGetLanguageId(),
                      "block_id":doGetLocalDataUser().blockID!,
                      "floor_id":doGetLocalDataUser().floorID!,
                      "vehicle_type":unit,
                      "qrcode_id": strQRcodeId,
                      "vehicle_photo": "",
                      "vehicle_rc_book": "",
                      "vehicle_number":tfVehicleNumber.text!]
        print("param" , params)
       // if ivAddVehicleImage.image == UIImage(named: "addphoto"){
           // ivAddVehicleImage.image = UIImage(named: "banner_placeholder")
        //}
       
        let requrest = AlamofireSingleTon.sharedInstance
               requrest.requestPostMultipartmultiImages(serviceName: ServiceNameConstants.vehicle_controller, parameters: params,imageFile: ivAddVehicleImage.image,fileName: "vehicle_photo",imageFile1: ivproofimage.image,fileName1: "vehicle_rc_book", compression: 0.3) { (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
                    if response.status == "200"{
                        self.doPopRootBAck()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func onClickGallery(_ sender: UIButton) {
        
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera(tag: sender.tag)
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery(tag: sender.tag)
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    
    func openCamera(tag:Int)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.view.tag = tag
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(tag: Int)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.view.tag = tag
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openPermision() {
        let ac = UIAlertController(title: "", message: "Please access micro phone permission", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default)
        {
            (result : UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default)
        {
            (result : UIAlertAction) -> Void in
            ac.dismiss(animated: true, completion: nil)
        })
        present(ac, animated: true)
    }
    
    @IBAction func btnbike(_ sender: Any) {
        self.Cat = Vehicle.bike
        self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
        self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
        unit = "1"
    }
    
    @IBAction func btncar(_ sender: Any) {
        self.Cat = Vehicle.car
        self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
        self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
        unit = "0"
    }
   
//    @IBAction func onClickChooseImage(_ sender: UIButton) {
//
//        switch sender.tag {
//        case 0:
//            self.Cat = Vehicle.car
//            self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
//            self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
//            unit = "0"
//
//        default:
//            self.Cat = Vehicle.bike
//            self.imgOffRadiobutton.setImageWithTint(ImageName: "radio-off-button", TintColor: ColorConstant.primaryColor)
//            self.imgOnRadiobutton.setImageWithTint(ImageName: "radio-on-button", TintColor: ColorConstant.primaryColor)
//            unit = "1"
//        }
//
//    }
    
    @IBAction func onClickAddVehicle(_ sender: UIButton) {
        
        if sender.currentTitle == doGetValueLanguage(forKey: "update")
        {
            if tfVehicleNumber.text == ""{
                self.showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "please_enter_your_vehicle_no"))
            }
        
            
            else{
                doUpdatevehicle()
            }
            
        }
        else{
            if tfVehicleNumber.text == ""{
                self.showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "please_enter_your_vehicle_no"))
            }
           // else if vehicleimgdata.count == 0{
             else if vehicleimgrequired == "1"
                {
                 self.showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "please_select_your_vehicle_photo"))
                }
                
         //   }
       //     else if rcimgdata.count == 0{
             else if rcimgrequired == "1"
                {
                 self.showAlertMessage(title: "", msg:  doGetValueLanguage(forKey: "please_select_your_rcbook_photo"))
                }
                
          //  }
           
            else{
                doAddvehicle()
            }
            
        }
        
        
    }
}

extension AddVehicleVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
      
        if let img = info[.editedImage] as? UIImage
        {
            
            print("imagePickerController edit")
           
            (picker.view.tag == 0) ? (self.ivAddVehicleImage.image = img) : (self.ivproofimage.image = img)
            
            if  let imageData = img.jpegData(compressionQuality:0.3) {
           
            (picker.view.tag == 0) ? (self.vehicleimgdata = imageData) : (self.rcimgdata = imageData)
                
                (picker.view.tag == 0) ? (self.vehicleimgrequired = "0") : (self.rcimgrequired = "0")
                
            }
            

        }
        else if let img = info[.originalImage] as? UIImage
        {
            print("imagePickerController ordi")

            (picker.view.tag == 0) ? (self.ivAddVehicleImage.image = img) : (self.ivproofimage.image = img)
            
            if  let imageData = img.jpegData(compressionQuality:0.3) {

            (picker.view.tag == 0) ? (self.vehicleimgdata = imageData) : (self.rcimgdata = imageData)
            
                (picker.view.tag == 0) ? (self.vehicleimgrequired = "0") : (self.rcimgrequired = "0")
            }

        }
        
    
        
        print(self.vehicleimgdata)
        
       
        
    }
}
