//
//  ReferVendorVC.swift
//  Finca
//
//  Created by CHPL Group on 02/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class ReferVendorVC: BaseVC, AppDialogDelegate {
    
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.filterReferList[tag]
                self.deleteReferance(refer_id: data.refer_id, index: tag)
            }
        }
    }
    
    func btnCancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    var referlist = [refer_list]()
    let itemcell = "VendorReferenceCell"
    var filterReferList = [refer_list]()
    var actionClick = 0
    var youtubeVideoID = ""
    
    @IBOutlet weak var btnMenu: UIButton!
    var menuTitle : String!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var tfsearch: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var viewtf: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var viewAddBtn: UIView!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBAction func bMenu(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        doInintialRevelController(bMenu: btnMenu)
        if self.revealViewController() != nil {
            revealViewController().delegate = self
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        addRefreshControlTo(tableView: tbvData)
        Utils.setImageFromUrl(imageView: imgNodata, urlString: getPlaceholderLocal(key: menuTitle))
        tbvData.dataSource = self
        tbvData.delegate = self
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        lblMainTitle.text = menuTitle//doGetValueLanguage(forKey: "refer_vendor")
        doneButtonOnKeyboard(textField: tfsearch)
        tfsearch.placeholder = doGetValueLanguage(forKey: "search")
        tfsearch.text = ""
        tfsearch.delegate = self
        tfsearch.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
//        addRefreshControlTo(tableView: tbvData)
        self.dogetReferList()
        tbvData.reloadData()
    }
    
    override func pullToRefreshData(_ sender: Any) {
        self.hidePull()
        self.tfsearch.text = ""
        self.tfsearch.resignFirstResponder()
        self.dogetReferList()
        tbvData.reloadData()
    }
    
    @IBAction func onclickMenu(_ sender: Any) {
//        goToDashBoard(storyboard: mainStoryboard)
    }
    
    @IBAction func onclickhome(_ sender: Any) {
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        }
    
    @IBAction func onclickAdd(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "idAddrefervendorVC")as! AddrefervendorVC
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    @objc func textFieldDidChange(sender : UITextField) {

        filterReferList = sender.text!.isEmpty ? referlist : referlist.filter({ (item:refer_list) -> Bool in

            return item.refer_vendor_name.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.refer_vendor_company.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.refer_vendor_contact_number.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.business_category.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        if filterReferList.count == 0 {
            self.viewNodata.isHidden = false
        }else{
            self.viewNodata.isHidden = true
        }
        tbvData.reloadData()
      }
//    override func fetchNewDataOnRefresh() {
//          tfsearch.text = ""
//          view.endEditing(true)
//
//        refreshControl.beginRefreshing()
//
//          refreshControl.endRefreshing()
//        tbvData.reloadData()
//
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.2){
                if self.actionClick == 0{
                    self.viewAddBtn.isHidden = false
                }
            }
        } else {
            UIView.animate(withDuration: 0.2){
                if self.actionClick == 0{
                    self.viewAddBtn.isHidden = true
                }
            }
        }
    }
    
    func deleteReferance(refer_id:String!,index:Int!) {
        showProgress()
     
        let params = ["key":apiKey(),
                      "deleteReferance":"deleteReferance",
                      "society_id":doGetLocalDataUser().societyID!,
                      "refer_id":refer_id!,
                      "added_by":doGetLocalDataUser().userID!,
                      "user_type":"0"
                     ]
        print("param" , params)
       
       
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.vendor_referance_controller, parameters: params) { [self] (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(ReferListResponse.self, from: json!)
                    if response.status == "200"{
                        dogetReferList()
                     
                        self.tbvData.reloadData()
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
    
    func dogetReferList() {
        showProgress()

        let params = ["key":apiKey(),
                      "getReferList":"getReferList",
                      "society_id":doGetLocalDataUser().societyID!,
                      "added_by":doGetLocalDataUser().userID!,
                      "user_type":"0"
                     ]
        print("param" , params)


        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.vendor_referance_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(ReferListResponse.self, from: json!)
                    if response.status == "200"{
                        self.referlist = response.refer ?? []
                        if self.referlist.count > 0{
                            self.filterReferList = self.referlist
                            self.viewNodata.isHidden = true
                            self.tbvData.isHidden = false
                            self.tbvData.reloadData()
                        }else{
                            self.viewNodata.isHidden = false
                            self.tbvData.isHidden = true
                        }
                    }else{
                        self.viewNodata.isHidden = false
                        self.tbvData.isHidden = true
                    }
                    }catch{
                    print("error")
                }
            }
                    else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
}
extension ReferVendorVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterReferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvData.dequeueReusableCell(withIdentifier: "VendorReferenceCell", for: indexPath) as! VendorReferenceCell
        let obj = self.filterReferList[indexPath.row]
        cell.lblCat.text = obj.business_category
        cell.lblName.text = obj.refer_vendor_name
        
        
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedStringMobile = NSAttributedString(string: obj.refer_vendor_contact_number, attributes: underlineAttribute)
        cell.lblMobno.attributedText = underlineAttributedStringMobile
        
        if obj.refer_vendor_email != ""{
            let underlineAttributedStringEmail = NSAttributedString(string: obj.refer_vendor_email, attributes: underlineAttribute)
            cell.lblEmailid.attributedText = underlineAttributedStringEmail
            cell.btnForEmail.isHidden = false
            cell.imgemail.isHidden = false
            cell.lblEmailid.isHidden = false
            cell.heightEmailConst.constant = 20
        }else {
            cell.lblEmailid.text = doGetValueLanguage(forKey: "not_available")
        }
        
//        cell.lblMobno.text = obj.refer_vendor_contact_number
       
//        cell.lblEmailid.text = obj.refer_vendor_email
        cell.lblTItle.text = obj.refer_vendor_company
        cell.btndlt.tag = indexPath.row
        cell.btndlt.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnedit.tag = indexPath.row
        cell.btnedit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnForCall.tag = indexPath.row
        cell.btnForCall.addTarget(self, action: #selector(onClickCall(_:)), for: .touchUpInside)
        cell.btnForEmail.tag = indexPath.row
        cell.btnForEmail.addTarget(self, action: #selector(onClickEmail(_:)), for: .touchUpInside)
       return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    @objc func onClickDelete(_ sender : UIButton) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: sender.tag , cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "delete").uppercased())
//        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"),tag: sender.tag, style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel").uppercased(),okText : doGetValueLanguage(forKey: "delete").uppercased())
    }
    
    @objc func onClickEdit(_ sender : UIButton) {
            let vc = self.storyboard?.mainStory().instantiateViewController(withIdentifier: "idAddrefervendorVC")as! AddrefervendorVC
            let data = filterReferList[sender.tag]
            vc.Refervendor = data
            vc.isEdit = true
            vc.delegate = self
            vc.isComeFromParking = "1"
            vc.initForUpdate = true
            pushVC(vc: vc)
        }
    
    @objc func onClickCall(_ sender : UIButton) {
        let phone = self.filterReferList[sender.tag].refer_vendor_contact_number
        if phone != doGetValueLanguage(forKey: "not_available") && phone != doGetValueLanguage(forKey: "private")
        {
            doCall(on: self.filterReferList[sender.tag].refer_vendor_contact_number)
        }
    }
    
    @objc func onClickEmail(_ sender : UIButton) {
        let email = self.filterReferList[sender.tag].refer_vendor_email
        if let url = URL(string: "mailto:\(email ?? "")") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
    
extension ReferVendorVC: MoveToBack{
    func PassToastMessage(Message: String) {
        dogetReferList()
        self.toast(message: Message, type: .Information)
    }
}
    

