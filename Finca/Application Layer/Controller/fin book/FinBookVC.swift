//
//  FinBookVC.swift
//  Finca
//
//  Created by Jay Patel on 30/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class FinBookVC: BaseVC {
    let itemCell = "FinCustomerListCell"
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var viewOverview: UIView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var bMenu: UIButton!
    @IBOutlet var tbvCustomerList: UITableView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblTotalDue: UILabel!
    @IBOutlet weak var lblTotalAdvance: UILabel!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblViewReport: UILabel!
    @IBOutlet weak var lblAddCustomer: UILabel!
    var youtubeVideoID = ""
    @IBOutlet weak var videoview:UIView!
    var customerList = [CustomerListModel](){
        didSet{
            self.filterList = self.customerList
        }
    }
    var filterList = [CustomerListModel](){
        didSet{
            self.tbvCustomerList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        doInintialRevelController(bMenu: bMenu)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvCustomerList.register(nib, forCellReuseIdentifier: itemCell)
        tbvCustomerList.delegate = self
        tbvCustomerList.dataSource = self
        doneButtonOnKeyboard(textField: tfSearch)
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        addRefreshControlTo(tableView: tbvCustomerList)
        lblScreenTitle.text = menuTitle
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
        lblViewReport.text = doGetValueLanguage(forKey: "view_report")
        lblAddCustomer.text = doGetValueLanguage(forKey: "add_customer")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search"))
        if youtubeVideoID != ""
        {
            videoview.isHidden = false
        }else
        {
            videoview.isHidden = true
        }
    }

    @objc func textFieldDidChange(textField: UITextField) {
        filterList = textField.text!.isEmpty ? customerList : customerList.filter({ (item:CustomerListModel) -> Bool in

            return item.customerName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
    }

    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        self.tfSearch.text = ""
        self.customerList.removeAll()
        self.doCallApi()
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
    }

    func doCallApi(){
        self.showProgress()
        let params = ["getCustomer":"getCustomer",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        print("params",params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.finBookController, parameters: params) { (Data, error) in
            self.hideProgress()
            if Data != nil{
               
                do{
                    let response = try JSONDecoder().decode(CustomerListResponse.self, from: Data!)
                    if response.status == "200"{
                        self.viewOverview.isHidden = false
                        self.lblTotalDue.text = "\(self.doGetValueLanguage(forKey: "total_due"))\n" + response.totalDue
                        self.lblTotalAdvance.text = "\(self.doGetValueLanguage(forKey: "total_advance"))\n" + response.totalAdvance
                        self.customerList.append(contentsOf: response.customer)
                    }else{
                        self.viewOverview.isHidden = true
                    }
                }catch{
                    print("parse Error",error)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }

    @IBAction func btnViewReport(_ sender: UIButton!) {
        let nextVc = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idFinBookReportVC")as! FinBookReportVC
        nextVc.imagePlace = ivNoData.image ?? #imageLiteral(resourceName: "book")
        self.navigationController?.pushViewController(nextVc, animated:     true)
    }
    @IBAction func btnAddCustomer(_ sender: Any) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = storyboard!.instantiateViewController(withIdentifier: "idFinAddCustomerDialogVC")as! FinAddCustomerDialogVC
                       vc.context = self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    

    
    @IBAction func btnVideo(_ sender: UIButton) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = storyboardConstants.main.instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }

    @IBAction func btnHome(_ sender: UIButton) {
        let destiController = storyboardConstants.main
            .instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
}
extension FinBookVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterList.count == 0  {
            if customerList.count != 0{
                self.viewSearch.isHidden = false
            }else{
                self.viewSearch.isHidden = true
            }
            self.viewNoData.isHidden = false
            self.viewReport.isHidden = true
        }else{
            self.viewReport.isHidden = false
            self.viewNoData.isHidden = true
            self.viewSearch.isHidden = false
        }
        return filterList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filterList[indexPath.row]
        let cell = tbvCustomerList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! FinCustomerListCell
        if data.isDue{
            cell.lblType.text = doGetValueLanguage(forKey: "due")
            cell.lblType.textColor = ColorConstant.red500
            cell.lblAmount.textColor = ColorConstant.red500
        }else{
            cell.lblType.text = "Advance"
            cell.lblType.textColor = ColorConstant.green500
            cell.lblAmount.textColor = ColorConstant.green500
        }
        DispatchQueue.main.async {
               cell.viewMain.clipsToBounds = true
               cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
               }
        cell.lblCustomerName.text = data.customerName
        cell.lblAmount.text = data.dueAmount
        cell.lblNameInitials.text = String(data.customerName.first!)
        cell.lblPhoneNumber.text = data.customerMobile
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filterList[indexPath.row]
        let nextVC = storyboardConstants.temporary.instantiateViewController(withIdentifier: "idCustomerAccountDetailsVC")as! CustomerAccountDetailsVC
        nextVC.customerData = data
        nextVC.imageNoData = ivNoData.image ?? UIImage(named: "")!
        nextVC.context = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
