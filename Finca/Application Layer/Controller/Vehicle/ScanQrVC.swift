//
//  ScanQrVC.swift
//  Finca
//
//  Created by CHPL Group on 08/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import MercariQRScanner
import AVFoundation


struct CheckQRCodeRes: Codable {
  let status: String? //  "200",
  let message: String? //  "Qr code Scan Successfully.",
  let qrcode_id: String? //  "3"
}

protocol QRCodeValidateDelegate{
    func passdata(qrcodeId : String?,apicall:String)
}

class ScanQrVC: BaseVC {
    
    
    var iscomefrom = ""
    var imagePath = ""
    var strvehicleQrcode = ""
    @IBOutlet weak var vwQrScan: UIView!
    
    @IBOutlet weak var imgvw: UIImageView!
    var qrScannerView = QRScannerView()
//    var delegate: refreshDataDelegate?
//    var vehicleNumber = ""
    var delegate: QRCodeValidateDelegate?

    //MARK: View Cycle Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
    }
    
    private func setupQRScanner() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupQRScannerView()
            break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupQRScannerView()
                    }
                }
            }
        default:
            print("Default")
        }
    }
    
    private func setupQRScannerView() {
        qrScannerView = QRScannerView(frame: vwQrScan.bounds)
        vwQrScan.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        //        qrScannerView.configure(delegate: self)
        //        qrScannerView.focusImagePadding = 1.0
        //        qrScannerView.animationDuration = 1.0
        qrScannerView.startRunning()
    }
     
    
    //MARK: Server Requests Functions:
   
    private func checkQRCodeString(strQR: String) {
        self.showProgress()
        
        print("strQR",strQR)

        let params = ["key":apiKey(),
                      "checkQrCode":"checkQrCode",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "generate_number": strQR,
                      "language_id":doGetLanguageId()
        ]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { (data, error) in
            
            self.hideProgress()
            DispatchQueue.main.async {
                
                if data != nil {
                    do {
                        let response = try JSONDecoder().decode(CheckQRCodeRes.self, from: data!)
                        if response.status == "200" {
                            self.toast(message: response.message ?? "", type: .Information)
                            if let del = self.delegate {
                                del.passdata(qrcodeId: response.qrcode_id, apicall: "Yes")
                            }
                            self.dismiss(animated: true)
                            //self.doPopBAck()
                        } else {
                            self.toast(message: response.message ?? "", type: .Information)
                            self.qrScannerView.startRunning()
                            self.qrScannerView.rescan()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.dismiss(animated: true)
                            }
                           
                        }
                    } catch {
                        print("Parse Error", error as Any)
                    }
                }
            }
        }
    }
    
    //MARK: Button Actions:
    
    @IBAction func onClickBack(_ sender: UIButton) {
//        doPopBAck()
        self.dismiss(animated: false)
    }
//    func dovehicleList() {
//        showProgress()
//
//        let params = ["key":apiKey(),
//                      "checkQrCode":"checkQrCode",
//                      "user_id":doGetLocalDataUser().userID!,
//                      "society_id":doGetLocalDataUser().societyID!,
//                      "generate_number": "",
//                      "language_id":doGetLanguageId()]
//
//        print("param" , params)
//        let request = AlamofireSingleTon.sharedInstance
//        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { (json, error) in
//            self.hideProgress()
//            if json != nil {
//                do{
//                    let response = try JSONDecoder().decode(vehicleResponse.self, from: json!)
//                    if response.status == "200"{
//                        self.toast(message: response.message ?? "", type: .Information)
////
//                    }else{
//                        self.toast(message: response.message ?? "", type: .Information)
//                        self.qrScannerView.startRunning()
//                        self.qrScannerView.rescan()
//
//                    }
//                }catch{
//                    print("error")
//                }
//            }else if error != nil{
//                self.showNoInternetToast()
//            }
//        }
//
//    }
}

extension ScanQrVC: QRScannerViewDelegate {
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        qrScannerView.stopRunning()
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
      
     //   print(code)
       
        qrScannerView.stopRunning()
        
        if iscomefrom == "My"
        {
            self.checkQRCodeString(strQR: code) // TEMP
        }
        else{
                    if let del = self.delegate {
                        del.passdata(qrcodeId: code, apicall: "No")
                        
                        DispatchQueue.main.async {
                           // self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true)
                        }
                        
                    }
            
           
            
        }
       
        
//        if let del = self.delegate {
//            del.passdata(qrcodeId: code)
//        }
        
//        vehicleNumber = code
//        print(vehicleNumber)
 //     self.delegate?.Vehiclenumber(number: vehicleNumber)
        let defaults = UserDefaults.standard
        defaults.set(code, forKey: "Number")
       // doPopBAck()
    }
}

extension String {

    func fromBase64() -> String? {
        
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
