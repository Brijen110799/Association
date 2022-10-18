//
//  ManageAddressVC.swift
//  Finca
//
//  Created by Nanshi Shivhare on 10/05/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//



import UIKit




// MARK: - AddressResponse
struct AddressResponse:Codable {
    let list: [List]?
    let message: String?
    let status: String?

}

// MARK: - Address
struct List: Codable {
    
    let additional_company_address_id: String? //  "6",
    let unit_id: String? //  "2284",
    let user_id: String? //  "2304",
    let additional_company_title: String? //  "Office",
    let additional_company_address: String? //  "ahmedabad",
    let location_latitude: String? //  "23.037986474532595",
    let location_longitude: String? //  "72.511948607862",
    let additional_company_phone: String? //  "8128380042",
    let direction_link: String? //  "https://maps.google.com/?q=23.037986474532595,72.511948607862"
    
    
    
    
}

class ManageAddressVC: BaseVC, AppDialogDelegate {
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.filterList[tag]
                self.deleteAddress(strAddress_id: data.additional_company_address_id!, index: tag)
            }
        }
    }
    
    func btnCancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    

    
    var Addresslist = [List]()
    var filterList = [List]()
    let itemcell = "Addresscell"
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var tfSerch: UITextField!
    @IBOutlet weak var viewtf: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var viewAddBtn: UIView!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: itemcell, bundle: nil)
        tblAddress.register(nib, forCellReuseIdentifier: itemcell)
        
        doneButtonOnKeyboard(textField: tfSerch)
        tfSerch.placeholder = doGetValueLanguage(forKey: "search")
        tfSerch.text = ""
        tfSerch.delegate = self
        tfSerch.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        lblMainTitle.text = doGetValueLanguage(forKey: "additional_address_manage")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        customView.backgroundColor = UIColor.clear
        tblAddress.tableFooterView = customView
        
        
//        addRefreshControlTo(tableView: tbvData)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        dogetAddressList()
    }
    
    
    
    func dogetAddressList() {
        showProgress()

        let params = ["getCompanyAddress":"getCompanyAddress",
                      "unit_id":doGetLocalDataUser().unitID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                     ]
        print("param" , params)


        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.additional_company_address_controller, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(AddressResponse.self, from: json!)
                    if response.status == "200"{
                        
                        self.Addresslist = response.list  ?? []
                        
                        print( self.Addresslist.count)
    
                        if self.Addresslist.count > 0{
                            self.filterList = self.Addresslist
                            self.viewNodata.isHidden = true
                            self.tblAddress.isHidden = false
                            self.tblAddress.reloadData()
                        }else{
                            self.viewNodata.isHidden = false
                            self.tblAddress.isHidden = true
                        }
                    }else{
                        self.viewSearch.isHidden = true
                        self.viewNodata.isHidden = false
                        self.tblAddress.isHidden = true
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
    
    
    func deleteAddress(strAddress_id:String!,index:Int!) {
        showProgress()
    
     
        let params = [
                      "deleteCompanyAddress":"deleteCompanyAddress",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "additional_company_address_id":strAddress_id!
                     ]
        print("param" , params)
       
       
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.additional_company_address_controller, parameters: params) { [self] (json, error) in
                   self.hideProgress()
            if json != nil {
                do{
                    let response = try JSONDecoder().decode(AddressResponse.self, from: json!)
                    if response.status == "200"{
                       dogetAddressList()
                     
                        self.tblAddress.reloadData()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message!)
                    }
                }catch{
                    print("error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
    @objc func textFieldDidChange(sender : UITextField) {

        filterList = sender.text!.isEmpty ? Addresslist : Addresslist.filter({ (item:List) -> Bool in

            return item.additional_company_title!.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || (item.additional_company_address!.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        if filterList.count == 0 {
            self.viewNodata.isHidden = false
        }else{
            self.viewNodata.isHidden = true
        }
        tblAddress.reloadData()
      }
    @IBAction func btnBackAction(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func btnAddAddress(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "idAddAddressVC")as! AddAddressVC
        //nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ManageAddressVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAddress.dequeueReusableCell(withIdentifier: "Addresscell", for: indexPath) as! Addresscell
        let obj = self.filterList[indexPath.row]
//        cell.lblCat.text = obj.business_category
        cell.lbltitle.text = obj.additional_company_title
        cell.lblAddress.text = obj.additional_company_address
//
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedStringMobile = NSAttributedString(string: obj.additional_company_phone!, attributes: underlineAttribute)
        cell.lblnumber.attributedText = underlineAttributedStringMobile
////        cell.lblMobno.text = obj.refer_vendor_contact_number


        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btncall.tag = indexPath.row
        cell.btncall.addTarget(self, action: #selector(onClickCall(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnshare.tag = indexPath.row
        cell.btnshare.addTarget(self, action: #selector(onClickShare(_:)), for: .touchUpInside)

       return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 148
//
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    
    
    @objc func onClickDelete(_ sender : UIButton) {
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "are_you_sure_want_to_delete"), style: .Delete, tag: sender.tag , cancelText: doGetValueLanguage(forKey: "cancel").uppercased(), okText: doGetValueLanguage(forKey: "delete").uppercased())

    }
//    
    @objc func onClickEdit(_ sender : UIButton) {
            let vc = self.storyboard?.mainStory().instantiateViewController(withIdentifier: "idAddAddressVC")as! AddAddressVC
            let data = filterList[sender.tag]
            vc.Addressresp = data
            vc.isEdit = true
        
        pushVC(vc: vc)
        }
    
    @objc func onClickCall(_ sender : UIButton) {
        let phone = self.filterList[sender.tag].additional_company_phone
        if phone != doGetValueLanguage(forKey: "not_available") && phone != doGetValueLanguage(forKey: "private")
        {
            doCall(on: self.filterList[sender.tag].additional_company_phone)
        }
    }
    
    @objc func onClickShare(_ sender : UIButton) {
       
        
        var shareText = ""
        if doGetLocalDataUser().userFullName  ?? "" != ""  {
            shareText = "\(shareText)Name : \(doGetLocalDataUser().userFullName ?? "")\n"
         }
         if  doGetLocalDataUser().company_name ?? "" != ""{
             shareText = "\(shareText)Company Name : \(doGetLocalDataUser().company_name ?? "")\n"
         }
        
        if self.filterList[sender.tag].additional_company_title ?? "" != ""{
             shareText = "\(shareText) \(self.filterList[sender.tag].additional_company_title ?? "")\n"
         }
         if self.filterList[sender.tag].additional_company_address ?? "" != ""{
             shareText = "\(shareText)Address: \(self.filterList[sender.tag].additional_company_address ?? "")\n"
         }
        if self.filterList[sender.tag].additional_company_phone ?? "" != ""{
            shareText = "\(shareText)Mobile No: \(self.filterList[sender.tag].additional_company_phone ?? "")\n\n"
        }
         
         
         if self.filterList[sender.tag].direction_link  ?? "" != ""{
             shareText = "\(shareText) \(self.filterList[sender.tag].direction_link ?? "")"
         }
         
         let shareAll = [ shareText ] as [Any]
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = self.view
         
         activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
         //        self.present(activityViewController, animated: true, completion: nil)
         self.present(activityViewController, animated: true)
    }
    

    
}
