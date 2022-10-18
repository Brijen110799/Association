//
//  PenaltyDetailVC.swift
//  Finca
//
//  Created by silverwing_macmini3 on 1/7/1399 AP.
//  Copyright © 1399 anjali. All rights reserved.
//

import UIKit

class PenaltyDetailVC: BaseVC {

    //let rupee = "\u{20B9}"
    var flag = false
    var penaltyContext : PenaltyVC!
    var index : IndexPath!
    
    @IBOutlet weak var lblSubTotalAmount: UILabel!
    @IBOutlet weak var lblIGSTamount: UILabel!
    @IBOutlet weak var lblCGSTamount: UILabel!
    @IBOutlet weak var lblSGSTamount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblIGSTpercentage: UILabel!
    @IBOutlet weak var lblCGSTpercentage: UILabel!
    @IBOutlet weak var lblSGSTpercentage: UILabel!
    @IBOutlet weak var stackViewIgst: UIStackView!
    @IBOutlet weak var stackViewCgst: UIStackView!
    @IBOutlet weak var stackViewSgst: UIStackView!
    @IBOutlet weak var imgPenaltyPhoto: UIImageView!
    @IBOutlet weak var lblPenaltyTitle: UILabel!
    var isPay = false
    override func viewDidLoad() {
        super.viewDidLoad()

        index = penaltyContext.index
        let subTotal = penaltyContext.penaltyList[index.row].amountWithoutGst!
        let totalAmt = penaltyContext.penaltyList[index.row].penaltyAmount!
        let billType = penaltyContext.penaltyList[index.row].billType!
        let penaltyName = penaltyContext.penaltyList[index.row].penaltyName!
        Utils.setImageFromUrl(imageView: imgPenaltyPhoto, urlString: penaltyContext.penaltyList[index.row].penaltyPhoto!)
        
        lblSubTotalAmount.text = "\(localCurrency())\(subTotal)"
        lblTotalAmount.text = "\(localCurrency())\(totalAmt)" 
        lblPenaltyTitle.text = penaltyName
        isPay = penaltyContext.penaltyList[index.row].isPay
        if billType == "GST" {
            let gstType = penaltyContext.penaltyList[index.row].gstType
            let gstPer = penaltyContext.penaltyList[index.row].gstSlab!
            
            if gstType == "IGST" {
                
                stackViewCgst.isHidden = true
                stackViewSgst.isHidden = true
                let igstAmt = penaltyContext.penaltyList[index.row].igstAmount!
                lblIGSTamount.text = igstAmt
                lblIGSTpercentage.text = "IGST (" + gstPer + "%)"
                
            } else if gstType == "CGST/SGST" {
                let sgstAmt = penaltyContext.penaltyList[index.row].sgstAmount!
                let cgstAmt = penaltyContext.penaltyList[index.row].cgstAmount!
                lblCGSTamount.text = cgstAmt
                lblSGSTamount.text = sgstAmt
                let per = Float(gstPer)
                let sgstPer = per! / 2
                lblCGSTpercentage.text = "CGST (" + String(sgstPer) + "%)"
                lblSGSTpercentage.text = "SGST (" + String(sgstPer) + "%)"
                stackViewIgst.isHidden = true
                
            }
    
        } else {
            stackViewCgst.isHidden = true
            stackViewSgst.isHidden = true
            stackViewIgst.isHidden = true
        }
        
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
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
    @IBAction func onClickPayNow(_ sender: Any) {
        
        
        if !isPay   {
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Online payment can not be accepted at this moment.", style: .Info, tag: 0, cancelText: "CANCEL", okText: "OKAY")
            return
        }
        self.dismiss(animated: true) { [self] in
            //self.index = self.penaltyContext.index
            //self.penaltyContext.doCallPay(indexPath: self.index)
           
                var model = PayloadDataPayment()
                model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PENALTY
                model.paymentForName = self.penaltyContext.penaltyList[self.index.row].penaltyName ?? ""
                model.paymentDesc = self.penaltyContext.penaltyList[self.index.row].penaltyName ?? ""
                model.paymentAmount = self.penaltyContext.penaltyList[self.index.row].penaltyAmount ?? ""
                model.paymentFor  = "Penalty"
                model.paymentReceivedId  = self.penaltyContext.penaltyList[self.index.row].penaltyID ?? ""
                model.penaltyId  = self.penaltyContext.penaltyList[self.index.row].penaltyID ?? ""
                model.paymentBalanceSheetId  = self.penaltyContext.penaltyList[self.index.row].balancesheetID ?? ""
            model.userName = "\(doGetLocalDataUser().userFullName!)"
            model.userEmail = "\(doGetLocalDataUser().userEmail!)"
            model.userMobile = "\(doGetLocalDataUser().userMobile!)"
                let vc = PaymentOptionsVC()
                vc.payloadDataPayment = model
                vc.paymentSucess = self.penaltyContext.self
                self.penaltyContext.navigationController?.pushViewController(vc, animated: true)
            
          
         }
        
    }
}
extension PenaltyDetailVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
