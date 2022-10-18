//
//  PenaltyImageShowVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 26/11/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class PenaltyImageShowVC: BaseVC {
    
    var cgst_lbl_view = ""
    var igst_lbl_view = ""
    var sgst_lbl_view = ""
    var tax_slab = ""
    var StrValue = ""
    var PaidStatus = ""
    var Strtitle = ""
    var StrDate = ""
    var StrtotalAmount = ""
    var StrtotalAmountView = ""
    var StrWithoutGst = ""
    var Strpayment_request_id = ""
    var Strbalancesheet_id = ""
    var Strpenalty_id = ""
    var StrDescription = ""
    var InvoiceUrl = ""
    var already_requests = Bool()
    var StrPayment_RequestID = ""
    var CGst_Amount = ""
    var Sgst_amount = ""
    var Igst_amount = ""
    var Gst_type = ""
    var Penalty_amount = ""
    var Gst_slab = ""
    var gst = ""
    var bill_type = ""
    var is_taxble = ""
    var taxble_type = ""
    var igst_amount_view = ""
    var cgst_amount_view = ""
    var sgst_amount_view = ""
    
    var index = 0
    var penaltyContext : PenaltyVC!
    var HalfGstSlab = Double()
    @IBOutlet weak var btnInvoice : UIButton!
    @IBOutlet weak var btnAlreadyPaid : UIButton!
    @IBOutlet weak var btnPaynow : UIButton!
    
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lbltotalAmount:UILabel!
    @IBOutlet weak var lblDescription:UILabel!

    @IBOutlet weak var pager: iCarousel!
    @IBOutlet weak var pagerControll: UIPageControl!
    
    @IBOutlet weak var lblCgstAmount : UILabel!
    @IBOutlet weak var lblSgstAmount : UILabel!
    
    @IBOutlet weak var CgstPercent : UILabel!
    @IBOutlet weak var SgstPercent : UILabel!
   
    @IBOutlet weak var viewCgst: UIView!
    @IBOutlet weak var viewSgst: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    var  sliders = [PenaltyImageModel]()
    var penaltyListNext = [PenaltyModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScreenTitle.text = doGetValueLanguage(forKey: "penalty_summary")
        lblTotalAmount.text = doGetValueLanguage(forKey: "total_amount")
        lblAmountTitle.text = doGetValueLanguage(forKey: "amount") // total
        btnPaynow.setTitle(doGetValueLanguage(forKey: "pay_now"), for: .normal)
        btnInvoice.setTitle(doGetValueLanguage(forKey: "invoice").uppercased(), for: .normal)
    if gst == "0" {
      if is_taxble == "1"
        //bill_type == "GST"
      {
        if taxble_type == "1"
            //Gst_type == "IGST"
        {
           // lblSgstAmount.isHidden = true
           // SgstPercent.isHidden = true
            viewSgst.isHidden = true
            lblCgstAmount.text = "\(localCurrency()) \(Igst_amount)"
            lblAmount.text = "\(localCurrency()) \(StrtotalAmountView)"
            lbltotalAmount.text = "\(localCurrency()) \(StrWithoutGst)"
            let Slab = Gst_slab.doubleValue
            HalfGstSlab = Slab!
           
            
            CgstPercent.text = igst_lbl_view
                //"IGST" + "(" + StrHalfGst + "%" + ")"
            
        }else
        {
            lblCgstAmount.text = "\(localCurrency()) \(CGst_Amount)"
            lblSgstAmount.text = "\(localCurrency()) \(Sgst_amount)"
            lblAmount.text = "\(localCurrency()) \(StrtotalAmountView)"
            lbltotalAmount.text = "\(localCurrency()) \(StrWithoutGst)"
            let Slab = Gst_slab.doubleValue
            HalfGstSlab = Slab!/2
         
            
            CgstPercent.text = cgst_lbl_view
                //"CGST" + "(" + StrHalfGst + "%" + ")"
            SgstPercent.text = sgst_lbl_view
                //"SGST" + "(" + StrHalfGst + "%" + ")"
        }
        
      }else{
        
//        lblSgstAmount.isHidden = true
//        lblCgstAmount.isHidden = true
//        CgstPercent.isHidden = true
//        SgstPercent.isHidden = true
        lbltotalAmount.text = "\(localCurrency()) \(StrWithoutGst)"
        lblAmount.text = "\(localCurrency()) \(StrtotalAmountView)"
        
        viewSgst.isHidden = true
        viewCgst.isHidden = true
      }
}else
{
    if is_taxble == "1"
        //bill_type == "GST"
    {
      if taxble_type == "1"
        //Gst_type == "IGST"
      {
          //lblSgstAmount.isHidden = true
        // SgstPercent.isHidden = true
        viewSgst.isHidden = true
        lblCgstAmount.text = "$" + igst_lbl_view  // Igst_amount
        lblAmount.text = "$" + StrtotalAmountView
        lbltotalAmount.text = "$" + StrWithoutGst
        let Slab = Gst_slab.doubleValue
        HalfGstSlab = Slab!
       // let StrHalfGst = String(HalfGstSlab)
        
        CgstPercent.text = cgst_lbl_view
            //"IGST" + "(" + StrHalfGst + "%" + ")"
        
      }else
      {
        lblCgstAmount.text = "\(localCurrency()) \(cgst_lbl_view)"  // CGst_Amount
        lblSgstAmount.text = "\(localCurrency()) \(sgst_lbl_view)"  // Sgst_amount
        lblAmount.text = "\(localCurrency()) \(StrtotalAmountView)"
        lbltotalAmount.text = "\(localCurrency()) \(StrWithoutGst)"
        let Slab = Gst_slab.doubleValue
        HalfGstSlab = Slab!/2
        //let StrHalfGst = String(HalfGstSlab)
        
        CgstPercent.text = cgst_lbl_view
            //"CGST" + "(" + StrHalfGst + "%" + ")"
        SgstPercent.text = sgst_lbl_view
            //"SGST" + "(" + StrHalfGst + "%" + ")"
      }
}
}
       
        lbltitle.text = doGetValueLanguage(forKey: "date") +  "   " + StrDate
        lblDescription.text = Strtitle
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    
        pager.isPagingEnabled = true
        pager.isScrollEnabled = true
        pager.stopAtItemBoundary = true
        pager.bounces = false
        pager.delegate = self
        pager.dataSource = self
        pager.cornerRadius = 12
        pager.reloadData()
        
        doLoadSliderData()
 
    }
    override func viewWillAppear(_ animated: Bool) {
       
       if StrValue == "1"
       {
        
        btnAlreadyPaid.isHidden = false
        btnAlreadyPaid.setTitle(doGetValueLanguage(forKey: "cancel_payment_request"), for: .normal)
        
       }else
       {
        if PaidStatus == "0"
        {
         
         btnInvoice.isHidden = true
         btnPaynow.isHidden = false
         if already_requests == false
         {
             btnAlreadyPaid.isHidden = false
             btnAlreadyPaid.setTitle(doGetValueLanguage(forKey: "already_paid"), for: .normal)
         }else
         {
             btnAlreadyPaid.isHidden = false
             btnAlreadyPaid.setTitle(doGetValueLanguage(forKey: "cancel_payment_request"), for: .normal)
         }
        
        }else
        {
         btnInvoice.isHidden = false
         btnPaynow.isHidden = true
         btnAlreadyPaid.isHidden = true
         
        }
       }
        btnAlreadyPaid?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
    }
    @objc func fire(){
        if sliders.count > 0{

            if index == sliders.count {
                index = 0
                self.pagerControll.currentPage = pager.currentItemIndex
            } else {
                pager.currentItemIndex = index
                self.pagerControll.currentPage = pager.currentItemIndex
            }
        }
    }
    @IBAction func BackClickevent(_ sender: UIButton) {
     doPopBAck()
    }
    @IBAction func InvoiceClick(_ sender:UIButton) {
        
        let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "idInvoiceVC") as! InvoiceVC
        vc.strUrl = InvoiceUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func AlreadyPaid(_ sender: UIButton) {
        
        if btnAlreadyPaid.titleLabel?.text == doGetValueLanguage(forKey: "already_paid")
        {
        var model = PayloadDataPayment()
        model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PENALTY
        //model.paymentForName = penaltyListNext[]
            //self.penaltyContext.penaltyList[self.index.row].penaltyName ?? ""
        model.paymentDesc = Strtitle
        model.paymentAmount = StrtotalAmount
        model.paymentFor  = "Penalty"
        model.paymentForName  = Strtitle
        model.paymentReceivedId  = Strpayment_request_id
        model.penaltyId  = Strpenalty_id
        model.paymentBalanceSheetId  = Strbalancesheet_id
        model.request_type = "2"
        model.PaybleAmountComma = StrtotalAmountView
            model.userName = "\(doGetLocalDataUser().userFullName!)"
            model.userEmail = "\(doGetLocalDataUser().userEmail!)"
            model.userMobile = "\(doGetLocalDataUser().userMobile!)"

       // let vc = PaymentOptionsVC()
        let vc2 = UIStoryboard(name: "sub", bundle: nil ).instantiateViewController(withIdentifier: "AlreadyPaidVC") as! AlreadyPaidVC
        vc2.payloadDataPayment = model
        vc2.StrAmounts = StrtotalAmount
        vc2.StrPenaltyId = Strpenalty_id
        vc2.StrPaidFor = "Penalty"
        vc2.delegateCustom = self
        self.navigationController?.pushViewController(vc2, animated: true)
        
        }else{
            
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_cancel_payment_request"), style: .Delete, tag: 0, cancelText: doGetValueLanguage(forKey: "close"), okText: doGetValueLanguage(forKey: "cancel_payment"))
       
        }
   
    }
    @IBAction func PayNowClick(_ sender: UIButton) {
        
        var model = PayloadDataPayment()
        model.paymentTypeFor = StringConstants.PAYMENTFORTYPE_PENALTY
        //model.paymentForName = penaltyListNext[]
            //self.penaltyContext.penaltyList[self.index.row].penaltyName ?? ""
        model.paymentDesc = Strtitle
        model.paymentAmount = StrtotalAmount
        model.paymentFor  = "Penalty"
        model.paymentForName  = Strtitle
        model.paymentReceivedId  = Strpayment_request_id
        model.penaltyId  = Strpenalty_id
        model.paymentBalanceSheetId  = Strbalancesheet_id
        model.PaybleAmountComma = StrtotalAmountView
        model.userName = "\(doGetLocalDataUser().userFullName!)"
        model.userEmail = "\(doGetLocalDataUser().userEmail!)"
        model.userMobile = "\(doGetLocalDataUser().userMobile!)"

        let vc = PaymentOptionsVC()
        vc.payloadDataPayment = model
        vc.paymentSucess = self
        vc.StrDate = StrDate
        vc.StrMaintenanceName = "Penalty" + " " + Strtitle
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    func doLoadSliderData() {
        pagerControll.numberOfPages = 0
        print(sliders)
     //   sliders.removeAll()
        let data = UserDefaults.standard.data(forKey: StringConstants.KEY_SLIDER_DATA)
        
        if data != nil{
            /// doLoadSlider()
           // let decoded = try? JSONDecoder().decode([PenaltyImageModel].self, from: data!)
           // self.sliders.append(contentsOf: (decoded)!)
            print(sliders)
            self.pager.reloadData()
            carouselDidScroll(pager)
            self.pagerControll.numberOfPages = sliders.count
            self.pagerControll.currentPage = 0
        }
    }
    @objc func pagerClickedBy(_ sender : UIButton){
//        let data = slider[sender.tag]
//        let vc = self.subStoryboard.instantiateViewController(withIdentifier: "idOfferDetailVC")as! OfferDetailVC
//        vc.sliderData = data
//        vc.context = self
//        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(350)])
//        sheetController.blurBottomSafeArea = false
//        sheetController.adjustForBottomSafeArea = false
//        sheetController.topCornersRadius = 0
//        sheetController.topCornersRadius = 15
//        sheetController.dismissOnBackgroundTap = false
//        sheetController.dismissOnPan = false
//        sheetController.handleSize = CGSize(width: 0, height: 0)
//        sheetController.extendBackgroundBehindHandle = true
//        self.present(sheetController, animated: false, completion: nil)
    }
}
extension PenaltyImageShowVC : iCarouselDelegate,iCarouselDataSource,getDataDelegate {
    func getDataFromAnotherVC(temp: String) {
         StrValue = temp
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return sliders.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        print(sliders[index].penalty_photo ?? "")
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: sliders[index].penalty_photo ?? "", palceHolder: "banner_placeholder")
        viewCard.frame = pager.frame
        viewCard.layer.masksToBounds = false
        viewCard.viewMain.layer.cornerRadius = 12
        viewCard.ivImage.layer.cornerRadius = 12
        viewCard.btnClickPager.tag = index
        viewCard.btnClickPager.addTarget(self, action: #selector(pagerClickedBy(_:)), for: .touchUpInside)
        return viewCard
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if (option == .spacing) {
            return value * 1.1
        }
        return value
        
    }

    func carouselDidScroll(_ carousel: iCarousel) {
        index = carousel.currentItemIndex + 1
        self.pagerControll.currentPage = carousel.currentItemIndex
    }
    func doCallAPi(){
        showProgress()
        let params = ["deleteRequest":"deleteRequest",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "payment_request_id" : StrPayment_RequestID]
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.payment_request_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    if response.status == "200" {
                        self.btnAlreadyPaid.setTitle(self.doGetValueLanguage(forKey: "already_paid"), for: .normal)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
}
struct SliderImages: Codable {
    let penalty_photo: String!
    
    enum CodingKeys: String, CodingKey {
        case penalty_photo = "penalty_photo"
        
    }
}
struct PenaltyModel2 {
    
    let penalty_photo: String!
    
    enum CodingKeys: String, CodingKey {
        case penalty_photo = "penalty_photo"
        
    }
    
}

extension PenaltyImageShowVC: AppDialogDelegate , PaymentSucessDelegate{
    func onSucusses() {
        
        print("payment succes back")
        doPopBAck()
      //  self.doCallApi()
        
    }
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                self.doCallAPi()
                
            }
        }
    }
}
