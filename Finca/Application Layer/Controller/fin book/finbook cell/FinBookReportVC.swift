//
//  FinBookReportVC.swift
//  Finca
//
//  Created by harsh panchal on 24/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class FinBookReportVC: BaseVC {

    @IBOutlet weak var lblTotalEntries: UILabel!
    @IBOutlet weak var lblTotalDebit: UILabel!
    @IBOutlet weak var lblTotalCredit: UILabel!
    @IBOutlet weak var viewHeader: UIStackView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    
    @IBOutlet weak var viewDownload: UIView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotalCreditTitle: UILabel!
    @IBOutlet weak var lblTotalDebitTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblReportDownload: UILabel!
    let itemCell = "FinBookReportCell"
    var imagePlace = UIImage()
    var transactionList = [FinbookReportModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.estimatedRowHeight = 100
        lblScreenTitle.text = doGetValueLanguage(forKey: "report")
        lblTotalTitle.text = doGetValueLanguage(forKey: "total")
        lblTotalDebitTitle.text = doGetValueLanguage(forKey: "you_got")
        lblTotalCreditTitle.text = doGetValueLanguage(forKey: "you_gave")
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
        lblReportDownload.text = doGetValueLanguage(forKey: "report")
        ivNoData.image = imagePlace
    }

    override func viewWillAppear(_ animated: Bool) {
        self.doCallApi()
    }

    func doCallApi(){
        self.showProgress()
        let params = ["getTransactionAll":"getTransactionAll",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        print("params = ",params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(FinbookReportResponse.self, from: Data!)
                    if response.status == "200"{
                        self.lblTotalCredit.text = self.localCurrency() + response.totalCreditAmount
                        self.lblTotalDebit.text = self.localCurrency() + response.totalDebitAmount
                        self.lblTotalEntries.text = String(response.tansaction.count) + " Entries"
                        self.transactionList.append(contentsOf: response.tansaction)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    @IBAction func btnDownloadClicked(_ sender: UIButton) {
        self.tbvData.convertToPDF()
       // print("table view pdf data",pdfData)
        self.toast(message: "PDF SAVED", type: .Information)
    }
@IBAction func btnBack(_ sender: UIButton) {
    doPopBAck()
}
}

extension FinBookReportVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactionList.count == 0{
            self.viewHeader.isHidden = true
            self.viewDownload.isHidden = true
            self.viewNoData.isHidden = false
        }else{
            self.viewHeader.isHidden = false
            self.viewDownload.isHidden = false
            self.viewNoData.isHidden = true
        }
        return transactionList.count
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = transactionList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! FinBookReportCell
        cell.lblDescription.text = data.customerName + "\n" + data.createdDate
        cell.lblDebit.text = self.localCurrency() + data.debitAmountView
        cell.lblCredit.text = self.localCurrency() + data.creditAmountView
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UITableView {
    func saveTablePdf(data: NSMutableData,name:String) -> String {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("\(name).pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }

    func convertToPDF() {
        let priorBounds = self.bounds
        setBoundsForAllItems()
        self.layoutIfNeeded()
        let _: () = createPDF()
        self.bounds = priorBounds
       // return pdfData
    }

    private func getContentFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
    }

    private func createPDF() {
        let pdfPageBounds: CGRect = getContentFrame()
        let pdfData: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()

        let _ = self.saveTablePdf(data: pdfData, name: "FinbookReportExport\(Date().millisecondsSince1970)")
    }

    private func setBoundsForAllItems() {
        if self.isEndOfTheScroll() {
            self.bounds = getContentFrame()
        } else {
            self.bounds = getContentFrame()
            self.reloadData()
        }
    }

    private func isEndOfTheScroll() -> Bool  {
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        return distanceFromBottom < frame.size.height
    }
}
