//
//  QrScanVC.swift
//  Finca
//
//  Created by Ankit Prajapati on 14/03/22.
//

import UIKit
import MercariQRScanner
import AVFoundation

class QrScanVC: BaseVC {
    
    //MARK: IBOutlets & Variable Declaration:
    
    @IBOutlet weak var vwQrScan: UIView!
    var qrScannerView = QRScannerView()
    //var delegate: refreshDataDelegate?
    
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
        qrScannerView = QRScannerView(frame: CGRect(x: 0, y: 0, width: vwQrScan.frame.size.width, height: vwQrScan.frame.size.height))
        vwQrScan.addSubview(qrScannerView)
        qrScannerView.centerXConstraint?.constant = 0
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        //        qrScannerView.configure(delegate: self)
        //        qrScannerView.focusImagePadding = 1.0
        //        qrScannerView.animationDuration = 1.0
        qrScannerView.startRunning()
    }
    
    //MARK: Server Requests Functions:
    
    private func checkQRCodeString(strQR: String) {
        
        DispatchQueue.main.async {
            self.showProgress()
        }
        
        let strTime = strQR.fromBase64()
        var strDateTime = ""
        if let strQRContent = strTime {
            if let index = strQRContent.firstIndex(of: "_") {
                strDateTime = String(strQRContent.prefix(upTo: index))
            }
        }
        
        let params = ["checkQRCode": "checkQRCode",
                      "language_id": "1",
                      "society_id": doGetLocalDataUser().societyID!,
                      "generate_number":"",
                      "language_id":doGetLanguageId()
                      
        ]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.vehicle_controller, parameters: params) { (data, error) in
            
            self.hideProgress()
            DispatchQueue.main.async {
                
                if data != nil {
                    do {
                        let response = try JSONDecoder().decode(CommonResponse.self, from: data!)
                        if response.status == "200" {
                            //self.toast(message: response.message ?? "", type: .Information)
                          //  if let del = self.delegate {
                           //     del.getData()
                         //   }
                          //  self.doPopBAck()
                        } else {
                            self.toast(message: response.message ?? "", type: .Information)
                            self.qrScannerView.startRunning()
                            self.qrScannerView.rescan()
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
        doPopBAck()
    }
    
}

extension QrScanVC: QRScannerViewDelegate {
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        qrScannerView.stopRunning()
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
      
//        print(code)
//        self.toast(message: code, type: .Defult)
        qrScannerView.stopRunning()
        self.checkQRCodeString(strQR: code)
    }
}






