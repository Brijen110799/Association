//
//  TabMyClassifiedVC.swift
//  Finca
//
//  Created by Jay Patel on 18/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabMyClassifiedVC: BaseVC {
    var userClassifiedList = [ListedItem]()
    var filterClassifiedList = [ListedItem]()
    let itemCell = "ClassifiedCell"
    var MainTabClassifiedVC: MainTabClassifiedVC!
    var selectedIndex = -1
    
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var tbvMyClassified: UITableView!
    @IBOutlet var lbNoData : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tfSearch)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvMyClassified.register(nib, forCellReuseIdentifier: itemCell)
        tbvMyClassified.delegate = self
        tbvMyClassified.dataSource = self
        viewNoData.clipsToBounds = true
        addRefreshControlTo(tableView: tbvMyClassified)
        hideView()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        ivClose.isHidden  = true
        heightOfSearchView.constant = 0
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        ivSearch.setImageColor(color: ColorConstant.colorP)
        ivClose.setImageColor(color: ColorConstant.colorP)
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_category")
        lbNoData.text = doGetValueLanguage(forKey: "no_classified_found")
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
        
        filterClassifiedList = textField.text!.isEmpty ? userClassifiedList : userClassifiedList.filter({ (item:ListedItem) -> Bool in
            
            return item.classifiedAddTitle.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        hideView()
        tbvMyClassified.reloadData()
        if textField.text == "" {
            self.ivClose.isHidden  = true
        } else {
            self.ivClose.isHidden  = false
        }
        //    hideView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        ivClose.isHidden = true
        
        refreshControl.beginRefreshing()
        userClassifiedList.removeAll()
        tbvMyClassified.reloadData()
        doCallMyClassifiedDataApi()
        refreshControl.endRefreshing()
    }
    func hideView() {
        if filterClassifiedList.count == 0{
            viewNoData.isHidden = false
            lbNoData.text = doGetValueLanguage(forKey: "no_data")
        } else {
            viewNoData.isHidden = true
        }
    }
    func doCallMyClassifiedDataApi() {
        
        showProgress()
        let params = ["getUserClassifiedItems":"getUserClassifiedItems",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(UserClassifiedResponse.self, from:json!)
                    if response.status == "200" {
                        self.heightOfSearchView.constant = 56
                        //                              print(response)
                        self.userClassifiedList = response.listedItems
                        self.filterClassifiedList = self.userClassifiedList
                        self.tbvMyClassified.reloadData()
                        self.viewNoData.isHidden = true
                    } else {
                        self.userClassifiedList.removeAll()
                        self.filterClassifiedList.removeAll()
                        self.viewNoData.isHidden = false
                        self.tbvMyClassified.reloadData()
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                    }
                    
                } catch {
                    print("parse error",error as Any)
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        })
    }
    @IBAction func onClickClearText(_ sender: Any) {
        tfSearch.text = ""
        
        filterClassifiedList = userClassifiedList
        tbvMyClassified.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        hideView()
    }
    @IBAction func btnAddClassified(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "idAddMyClassifiedVC")as! AddMyClassifiedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onClickDeletePost(_ sender : UIButton ){
        
       // showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "Do you want to delete?", style: .Delete)
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel"),okText : doGetValueLanguage(forKey: "delete"))
        selectedIndex = sender.tag
        print("selectedIndex==",selectedIndex)
        //        confirmDailog(id: feedArray[index].feedId)
        
    }
    func doEditFunc(index : Int){
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "idAddMyClassifiedVC")as! AddMyClassifiedVC
        vc.editData = "editData"
        vc.setEditData = filterClassifiedList[index]
        print(filterClassifiedList[index])
        //  print(userClassifiedList[index] , "userData")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension TabMyClassifiedVC: UITableViewDelegate,UITableViewDataSource,ActionClassified{
    func doEdit(indexpath: IndexPath) {
        doEditFunc(index: indexpath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterClassifiedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvMyClassified.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ClassifiedCell
        let data = filterClassifiedList[indexPath.row]
        cell.btnDelete.tag = indexPath.row
        //cell.btnDelete.isHidden = false
        cell.ViewDelete.isHidden = false
        cell.btnDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
        cell.lblTitle.text = data.classifiedAddTitle
        cell.lblBrand.text = data.classifiedBrandName.uppercased()
        //cell.lblFeatures.text = data.classifiedFeatures
        cell.lblPrice.text = "\(localCurrency()) "+data.classifiedExpectedPrice
        cell.lblManufacturingYear.text = data.classifiedManufacturingYear
        cell.lblDate.text = data.itemAddedDate
        cell.lbCategory.text = data.classified_category_name ?? ""
        cell.indexpath = indexPath
        cell.data = self
        // cell.data = indexPath
    //    print("image is ===",data.images[0])
        if data.images == nil {
            cell.imgClassified.image = UIImage(named: "banner_placeholder")
            
        }else{
             Utils.setImageFromUrl(imageView: cell.imgClassified, urlString:data.imageURL+data.images[0])
        }
        cell.lbLocation.text = data.location
        cell.lbBrand.text = "\(doGetValueLanguage(forKey: "brand_colon")) : "
        cell.lbPrice.text = "\(doGetValueLanguage(forKey: "price_colon")) : "
        cell.lbManufacturingYear.text = "\(doGetValueLanguage(forKey: "purchase_year")) : "
        cell.lbLocationLabel.text = "\(doGetValueLanguage(forKey: "location_colon")) : "
        cell.lbDate.text = "\(doGetValueLanguage(forKey: "uploaded_date")) : "
        cell.lbCategoryLabel.text = "\(doGetValueLanguage(forKey: "category")) : "
     
        
        if indexPath.row == filterClassifiedList.count - 1 {
            cell.viewBottom.isHidden = false
        }else  {
            cell.viewBottom.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idClassifiedDetailsVC")as! ClassifiedDetailsVC
        vc.userClassifiedList = filterClassifiedList[indexPath.row]
        vc.flag = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doDelete(classifiedMasterID:String){
        showProgress()
        let params = ["deleteUserClassifiedItem":"deleteUserClassifiedItem",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "classified_master_id":classifiedMasterID]
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.doCallMyClassifiedDataApi()
                        //                              print(response)
                    }
                    
                } catch {
                    print("parse error",error as Any)
                }
            }else{
                print(error as Any)
            }
        })
    }
    
}
extension TabMyClassifiedVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "my_classified").uppercased())
        //  Details
    }
}
extension TabMyClassifiedVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) {
                //              self.filterComplainList[self.selectedIndex]
                //                self.doCallDeleteApi(propertyDetail: selectedIndex)
                self.doDelete(classifiedMasterID: self.filterClassifiedList[self.selectedIndex].classifiedMasterID)
            }
        }
    }
}
