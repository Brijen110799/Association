//
//  PaymentDetailVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 21/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class PaymentDetailVC: BaseVC {
    
    var is_wallet_applied = Bool()
    var StrWalletAmount = ""
    var StrIsComeFromEvent = ""
    var StrIsComeFromRenew = ""
    var paymentSucess : PaymentSucessDelegate!
    var StrPayment = ""
    var StrDate = ""
    var paymentTransactionsId = ""
    var StrMaintenanceName = ""
    var StrSuccess = ""
    var payments_gateways = [PaymentsGateways]()
    var payloadDataPayment : PayloadDataPayment!
    var SelectedPaymentsGateways : PaymentsGateways!
    @IBOutlet weak var Scrollvw:UIScrollView!
    @IBOutlet weak var VwInsidescroll:UIView!
    @IBOutlet weak var lbAmount:UILabel!
    @IBOutlet weak var lbStatus:UILabel!
    @IBOutlet weak var lbdate:UILabel!
    @IBOutlet weak var lbTitle:UILabel!
    @IBOutlet weak var lbaintainance:UILabel!
    @IBOutlet weak var lbTransactionId:UILabel!
    @IBOutlet weak var VwShadow:UIView!
    @IBOutlet weak var ImgVwLogo:UIImageView!
    @IBOutlet weak var ImgvwSuceessFail:UIImageView!
    @IBOutlet weak var lblAmounts : UILabel!
    @IBOutlet weak var lblAmountsFrom : UILabel!
    @IBOutlet weak var lblwallet : UILabel!
    
    
    var isComeFromPlan = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from:Date())
        setThreeCorner(viewMain: VwShadow)
        
     if StrSuccess == "Success"
     {
        lbStatus.textColor = ColorConstant.green600
        lbAmount.textColor = ColorConstant.green600
        ImgvwSuceessFail.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        perform(#selector(zoomIN), with: nil, afterDelay: 0.2)
    
       // if StrPayment == "PayUMoeny"
        //{
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: SelectedPaymentsGateways.payment_getway_logo)
           
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.image = UIImage(named: "checked")
         
            if is_wallet_applied == true
            {
                
                let IntfromRazor = SelectedPaymentsGateways.transaction_amount_using_wallet.integerValue ?? 0
                let IntWallet = StrWalletAmount.integerValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount_using_wallet ?? "")"
            }else
            {
                
                lbAmount.text = "\(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
                
              //  lbAmount.text = "\(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
            }
           
       // }
        /*else if StrPayment == "Razorpay"
        {
          
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: payments_gateways[0].payment_getway_logo)
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.image = UIImage(named: "checked")
            
           
            if is_wallet_applied == true
            {
                
                let IntfromRazor = payments_gateways[0].transaction_amount_using_wallet.doubleValue ?? 0
                let IntWallet = StrWalletAmount.doubleValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[0].transaction_amount_using_wallet ?? "")"
            }else
            {
                lbAmount.text = "\(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
            }
        }else{
            
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: payments_gateways[2].payment_getway_logo)
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.image = UIImage(named: "checked")
            
           
            if is_wallet_applied == true
            {
                
                let IntfromRazor = payments_gateways[2].transaction_amount_using_wallet.doubleValue ?? 0
                let IntWallet = StrWalletAmount.doubleValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[2].transaction_amount_using_wallet ?? "")"
            }else
            {
                lbAmount.text = "\(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
            }
            
            
        }
 */
    }else
     {
        ImgvwSuceessFail.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        perform(#selector(zoomIN), with: nil, afterDelay: 0.2)
        lbStatus.textColor = ColorConstant.red500
        lbAmount.textColor = ColorConstant.red500
       // if StrPayment == "PayUMoeny"
        //{
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: SelectedPaymentsGateways.payment_getway_logo)
            
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.setImageWithTint(ImageName: "close_round", TintColor: ColorConstant.red500)
        
            if is_wallet_applied == true
            {
                
                let IntfromRazor = SelectedPaymentsGateways.transaction_amount_using_wallet.doubleValue ?? 0
                let IntWallet = StrWalletAmount.doubleValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount_using_wallet ?? "")"
            }else
            {
              
                lbAmount.text = "\(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(SelectedPaymentsGateways.transaction_amount ?? "")"
            }
           
        //}
        /*else if StrPayment == "Razorpay"
        {
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: payments_gateways[0].payment_getway_logo)
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.setImageWithTint(ImageName: "close_round", TintColor: ColorConstant.red500)
        
            if is_wallet_applied == true
            {
                let IntfromRazor = payments_gateways[0].transaction_amount_using_wallet.doubleValue ?? 0
                let IntWallet = StrWalletAmount.doubleValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[0].transaction_amount_using_wallet ?? "")"
            }else
            {
             
                lbAmount.text = "\(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[0].transaction_amount ?? "")"
            }
        }else
        {
            Utils.setImageFromUrl(imageView: ImgVwLogo, urlString: payments_gateways[2].payment_getway_logo)
            lbaintainance.text = StrMaintenanceName
            lbdate.text = dateString
            lbTransactionId.text = "Transaction ID" + " " + paymentTransactionsId
            lbStatus.text = StrSuccess
            ImgvwSuceessFail.setImageWithTint(ImageName: "close_round", TintColor: ColorConstant.red500)
        
            if is_wallet_applied == true
            {
                let IntfromRazor = payments_gateways[2].transaction_amount_using_wallet.doubleValue ?? 0
                let IntWallet = StrWalletAmount.doubleValue ?? 0
                let Inttotal = IntfromRazor + IntWallet
                lbAmount.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblwallet.isHidden = false
                lblwallet.text = "Paid from" + " " + "Wallet" + "  " + self.localCurrency() + StrWalletAmount
                lblAmounts.text = "\(self.localCurrency()) \(String(Inttotal))"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[2].transaction_amount_using_wallet ?? "")"
            }else
            {
             
                lbAmount.text = "\(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
                lblwallet.isHidden = true
                lblAmounts.text = "\(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
                lblAmountsFrom.text = "\("Paid from") \(StrPayment)   \(self.localCurrency()) \(payments_gateways[2].transaction_amount ?? "")"
            }
            
        }
 */
     }
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
    @IBAction func BtnShareClick(_ sender: UIButton) {
        
        let image = convertToimg(with: VwShadow)!
        let shareAll = [ image as Any] as [Any]

        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
      
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBAction func BackBtnClick(_ sender: UIButton) {
        
        if StringConstants.CheckRenew == true{
            StringConstants.CheckRenew = false
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RenewPlanDetailsVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            return
        }
        
        if isComeFromPlan != "" {
            popToHomeController()
            return
        }
//        if StrIsComeFromRenew == ""{
//            popToHomeController()
//            return
//        }
        
        if StrIsComeFromEvent == "1"{
            let controllers : Array = self.navigationController!.viewControllers
            self.navigationController!.popToViewController(controllers[0], animated: true)
            
        }else{
            for controller in self.navigationController!.viewControllers as Array {
                
                if   controller.isKind(of: EventPaymentDetailsVC.self) || controller.isKind(of: PenaltyVC.self) || controller.isKind(of: HomeVC.self) || controller.isKind(of: NewRegistrationVC.self) || controller.isKind(of: RenewPlanDetailsVC.self){
                    
                    self.navigationController!.popToViewController(controller, animated: true)
                    
                    break
                    
                }
                
            }
        }
    }
    @objc func zoomOUT() {

        UIView.animate(withDuration: 1.0, animations: {
            self.ImgvwSuceessFail.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        }) { [self] finished in
            ImgvwSuceessFail.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            perform(#selector(zoomIN), with: nil, afterDelay: 0.5)

        }
    }
    @objc func zoomIN() {
        UIView.animate(withDuration: 1.0, animations: {
            self.ImgvwSuceessFail.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }) { [self] finished in
            perform(#selector(zoomOUT), with: nil, afterDelay: 0.5)

        }

    }
}
