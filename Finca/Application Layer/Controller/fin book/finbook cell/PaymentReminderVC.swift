//
//  PaymentReminderVC.swift
//  Finca
//
//  Created by harsh panchal on 25/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class PaymentReminderVC: BaseVC {
    enum ReminderType {
        case PaymentReminder
        case TransactionReminder
    }

    var controller: UIDocumentInteractionController = UIDocumentInteractionController()
    
    @IBOutlet weak var stackView: UIStackView!
  
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblUserMobile: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewPassImage: UIView!
    @IBOutlet weak var viewTransactionImage: UIView!

    @IBOutlet weak var viewHeader: UIView!
    // transaction outlets
    @IBOutlet weak var lblTransactionUserName: UILabel!
    @IBOutlet weak var lblTransactionUserMobile: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblTranscationAmount: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblRevceiverMobileNumber: UILabel!

    @IBOutlet weak var lblpaymentType: UILabel!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd MMM yyyy"
        return formatter1
    }()
    var transactionData : CustomerTansactionModel!
    var customerData : CustomerListModel!
    var shareImage : UIImage!
    var reminderType : ReminderType!

    override func viewDidLoad() {
        super.viewDidLoad()
        if reminderType == .TransactionReminder{
            self.stackView.setNeedsLayout()
            self.viewTransactionImage.isHidden = true
            self.viewPassImage.isHidden = false
            self.stackView.layoutIfNeeded()
        }else if reminderType == .PaymentReminder{
            self.stackView.setNeedsLayout()
            self.viewPassImage.isHidden = false
            self.viewTransactionImage.isHidden = true
            self.stackView.layoutIfNeeded()
        }
        self.viewHeader.roundCorners(corners: .bottomRight ,radius: 28)
        
        
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch reminderType {
        case .PaymentReminder:
            self.lblpaymentType.text = doGetValueLanguage(forKey: "payment_reminder")
            self.lblUserName.text = doGetLocalDataUser().userFullName
            //self.lblInitialChars.text = String(lblUserName.text!.first!)
            self.lblAmount.text =  "\(localCurrency())\(customerData.dueAmount!)"
            self.lblUserMobile.text = "\(self.doGetValueLanguage(forKey: "to")):" + customerData.customerMobile!
            
            if customerData.dueDate ?? "" != "" {
                self.lblDate.text = "\(doGetValueLanguage(forKey: "due")) as on: \(customerData.dueDate ?? "")"
            } else {
                self.lblDate.text = dateFormatter1.string(from: Date())
            }
           
            self.lblAmount.textColor = ColorConstant.colorP
        case .TransactionReminder:
           
            self.lblUserName.text = doGetLocalDataUser().userFullName
            //self.lblInitialChars.text = String(lblUserName.text!.first!)
            
            self.lblUserMobile.text = customerData.customerMobile!
            self.lblDate.text = dateFormatter1.string(from: Date())
            if transactionData.creditAmount != "0.00"{
                self.lblpaymentType.text = "CREDIT AMOUNT"
                self.lblAmount.text =  "\(localCurrency())\(transactionData.creditAmount!)"
                self.lblAmount.textColor = ColorConstant.red500
            }else{
                self.lblpaymentType.text = "DEBIT AMOUNT"
                self.lblAmount.text =  "\(localCurrency())\(transactionData.debitAmount!)"
                self.lblAmount.textColor = ColorConstant.green500
            }
//            self.lblTransactionUserName.text = doGetLocalDataUser().userFullName!
//            self.lblTransactionUserMobile.text = doGetLocalDataUser().userMobile!
//            self.lblRevceiverMobileNumber.text = customerData.customerName!
//            if transactionData.creditAmount != "0.00"{
//                self.lblTransactionType.text = "CREDIT AMOUNT"
//                self.lblTranscationAmount.text =  transactionData.creditAmount!
//                self.lblTranscationAmount.textColor = ColorConstant.red500
//            }else{
//                self.lblTransactionType.text = "DEBIT AMOUNT"
//                self.lblTranscationAmount.text =  transactionData.debitAmount!
//                self.lblTranscationAmount.textColor = ColorConstant.green500
//            }
//            self.lblTransactionDate.text = transactionData.msgDateView!
            break
        default:
            break;
        }
    }

    @IBAction func btnShareClicked(_ sender: UIButton) {
        if reminderType == .TransactionReminder{
            shareImage = self.viewTransactionImage.snapshotView()
        }else if reminderType == .PaymentReminder{
            shareImage = self.viewPassImage.snapshotView()
        }
        //  let message  = "Payment of " + customerData.dueAmount! + " To " + doGetLocalDataUser().userFullName! + " is pending. Please make payment as soon as possible. \n \nThank You \nFincasys"
        //        let shareAll:UIImage =  shareImage!
        //        let shareitem:Array = [shareAll] as [Any]
        //
        //       // let message = "Payment of " + customerData.dueAmount! + " To " + doGetLocalDataUser().userFullName! + " is pending. Please make payment as soon as possible."
        //        let activityViewController = UIActivityViewController(activityItems: shareitem, applicationActivities: nil)
        //        print(shareitem, "shareitem")
        //        activityViewController.popoverPresentationController?.sourceView = self.view
        //        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
        //        self.present(activityViewController, animated: true, completion: nil)
        
        // let message = "hello"
//        let shareAll = [ shareImage as Any ] as [Any]
//
//               let activityViewController = UIActivityViewController(activityItems: [shareAll], applicationActivities: nil)
//
//               activityViewController.popoverPresentationController?.sourceView = self.view
//
//               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
//
//               self.present(activityViewController, animated: true, completion: nil)
        
        let urlWhats = "whatsapp://app"
        print("urlWhats",urlWhats)
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
             if let whatsappURL = URL(string: urlString) {

                 if UIApplication.shared.canOpenURL(whatsappURL as URL) {

                     if let image = shareImage{
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                             let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                             do {
                                 try imageData.write(to: tempFile, options: .atomic)
                                 self.controller = UIDocumentInteractionController(url: tempFile)
                                 self.controller.uti = "net.whatsapp.image"
                                 self.controller.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)

                             } catch {
                                 print(error)
                             }
                         }
                     }

                 } else {
                    print("Cannot open whatsapp")
                 }
             }
         }

}
}
