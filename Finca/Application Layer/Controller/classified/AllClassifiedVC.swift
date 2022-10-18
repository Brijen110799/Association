//
//  AllClassifiedVC.swift
//  Finca
//
//  Created by Jay Patel on 19/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
import XLPagerTabStrip
class AllClassifiedVC: BaseVC {
    var userClassifiedList = [ListedItem]()
    var filterClassifiedList = [ListedItem]()
    let itemCell = "ClassifiedCell"
    var selectedIndex = -1
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    var subClassifiedList : ClassifiedSubCategory!
    var classifiedList : ClassifiedCategory!
    @IBOutlet weak var ivClose: UIImageView!
   // @IBOutlet var lblHeading: UILabel!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var tbvAllCLassified: UITableView!
    
    @IBOutlet weak var ivRadioMostRecent: UIImageView!
  
    @IBOutlet weak var ivRadioLTH: UIImageView!
    @IBOutlet weak var ivRadioHTL: UIImageView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var lbNoData : UILabel!
    @IBOutlet weak var lbMostRecent : UILabel!
   
    @IBOutlet weak var lbLTH : UILabel!
    @IBOutlet weak var lbHTL : UILabel!
   
    @IBOutlet weak var ivFilter: UIImageView!
    var filter_type = ""
    var state_id = "0"
    var city_id = "0"
    var city = ""
    var state = ""
    var category_id = "0"
    var sub_category_id = "0"
    var product_type = ""
    var classifiedCategory = [ClassifiedCategory]()
    var mainTabClassifiedVC : MainTabClassifiedVC?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        heightOfSearchView.constant = 0
        doneButtonOnKeyboard(textField: tfSearch)
       // lblHeading.text = subClassifiedList.classifiedSubCategoryName
        ivSearch.setImageColor(color: ColorConstant.colorP)
       // ivClose.setImageColor(color: ColorConstant.colorP)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvAllCLassified.register(nib, forCellReuseIdentifier: itemCell)
        tbvAllCLassified.delegate = self
        tbvAllCLassified.dataSource = self
        viewNoData.clipsToBounds = true
        addRefreshControlTo(tableView: tbvAllCLassified)
        //        hideView()
        
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_item")
        lbNoData.text = doGetValueLanguage(forKey: "no_item_found")
        lbMostRecent.text = doGetValueLanguage(forKey: "most_recent")
       
        lbLTH.text = doGetValueLanguage(forKey: "price_low_to_high")
        lbHTL.text = doGetValueLanguage(forKey: "price_high_to_low")
        
        doGetCategory()
        fetchNewDataOnRefresh()
        //ivFilter.setImageColor(color: ColorConstant.grey_60)
        ivRadioMostRecent.image = UIImage(named: "radio-selected")
        ivRadioMostRecent.setImageColor(color:  ColorConstant.colorP)
       
        
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
        
        filterClassifiedList = textField.text!.isEmpty ? userClassifiedList : userClassifiedList.filter({ (item:ListedItem) -> Bool in
            
            return item.classifiedAddTitle.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        hideView()
        tbvAllCLassified.reloadData()

        //    hideView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        category_id = "0"
        sub_category_id = "0"
        ivFilter.setImageColor(color: ColorConstant.grey_60)
        refreshControl.beginRefreshing()
        userClassifiedList.removeAll()
        tbvAllCLassified.reloadData()
        doCallAllClassifiedDataApi()
        refreshControl.endRefreshing()
    }
    @IBAction func onClickClearText(_ sender: Any) {
        //        tfSearch.text = ""
        //        filterClassifiedList = userClassifiedList
        //        tbvAllCLassified.reloadData()
        //        view.endEditing(true)
        //        ivClose.isHidden = true
        //        hideView()
        viewFilter.isHidden = false
    }
    func hideView() {
        if filterClassifiedList.count == 0{
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
    }
    func doDelete(index:Int){
        showProgress()
        let params = ["deleteUserClassifiedItem":"deleteUserClassifiedItem",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "classified_master_id":userClassifiedList[index].classifiedMasterID!]
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

                    }

                } catch {
                    print("parse error",error as Any)
                }
            }else{
                print(error as Any)
            }
        })
    }
    func doCallAllClassifiedDataApi() {

        showProgress()
        let params = ["getOtherUserClassifiedItemsNew":"getOtherUserClassifiedItemsNew",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "category_id":category_id,
                      "sub_category_id":sub_category_id,
                      "filter_type" :filter_type,
                      "product_type" : product_type]

        print("param" , params)
        //    print("userid is=====",doGetLocalDataUser().userID + doGetLocalDataUser().userFullName)
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
                        self.tbvAllCLassified.reloadData()
                        self.viewNoData.isHidden = true
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tbvAllCLassified.scrollToRow(at: indexPath, at: .top, animated: true)

                    } else {
                        self.userClassifiedList.removeAll()
                        self.filterClassifiedList.removeAll()
                        self.viewNoData.isHidden = false
                        self.tbvAllCLassified.reloadData()
                        //                            self.viewNoData.isHidden = false
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                    }

                } catch {
                    print("parse error",error as Any)
                }
            }else if error != nil{
                    self.showNoInternetToast()
                
               // print(error as Any)
            }
        })
    }
    @IBAction func btnOnClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickDeletePost(_ sender : UIButton ){
       
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel"),okText : doGetValueLanguage(forKey: "delete"))
        selectedIndex = sender.tag
        //        confirmDailog(id: feedArray[index].feedId)

    }
    @IBAction func tapMostRecent(_ sender: Any) {
        filter_type = ""
        ivRadioMostRecent.image = UIImage(named: "radio-selected")
        ivRadioLTH.image = UIImage(named: "radio-blank")
        ivRadioHTL.image = UIImage(named: "radio-blank")
        ivRadioMostRecent.setImageColor(color:  ColorConstant.colorP)
        ivRadioLTH.setImageColor(color:  ColorConstant.colorP)
        ivRadioHTL.setImageColor(color:  ColorConstant.colorP)
        viewFilter.isHidden = true
        doCallAllClassifiedDataApi()
    }
  
    @IBAction func onClickLowToHigh(_ sender: Any) {
        filter_type = "pricelow"
        ivRadioLTH.image = UIImage(named: "radio-selected")
        ivRadioMostRecent.image = UIImage(named: "radio-blank")
        ivRadioHTL.image = UIImage(named: "radio-blank")
        ivRadioMostRecent.setImageColor(color:  ColorConstant.colorP)
        ivRadioLTH.setImageColor(color:  ColorConstant.colorP)
        ivRadioHTL.setImageColor(color:  ColorConstant.colorP)
        viewFilter.isHidden = true
        doCallAllClassifiedDataApi()
    }
    @IBAction func onClickHighToLow(_ sender: Any) {
        filter_type = "pricehigh"
        ivRadioHTL.image = UIImage(named: "radio-selected")
        ivRadioMostRecent.image = UIImage(named: "radio-blank")
        ivRadioLTH.image = UIImage(named: "radio-blank")
        ivRadioMostRecent.setImageColor(color:  ColorConstant.colorP)
        ivRadioLTH.setImageColor(color:  ColorConstant.colorP)
        ivRadioHTL.setImageColor(color:  ColorConstant.colorP)
        viewFilter.isHidden = true
        doCallAllClassifiedDataApi()
    }
    @IBAction func tapCloseFilter(_ sender: Any) {
        viewFilter.isHidden = true
      
    }
    @IBAction func onClickApply(_ sender: Any) {
        doCallAllClassifiedDataApi()
        viewFilter.isHidden = true
    }
    func doEditFunc(index : Int){
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "idAddMyClassifiedVC")as! AddMyClassifiedVC
        vc.editData = "AllClassified"
        vc.setEditData = filterClassifiedList[index]
        vc.catId = classifiedList.classifiedCategoryID!
        vc.subCatId = subClassifiedList.classifiedSubCategoryID!
        print(filterClassifiedList[index])
        //  print(userClassifiedList[index] , "userData")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onTapLocationFilter(_ sender: Any) {
        let vc = ClassifiedLocationFilterVC()
        vc.onSelectedLocation = self
        vc.state = state
        vc.city = city
        vc.state_id = state_id
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        vc.view.frame = view.frame
        addChild(vc)
        view.addSubview(vc.view)
    }
    
    @IBAction func onTapCategoryFilter(_ sender: Any) {
        viewFilter.isHidden = true
        mainTabClassifiedVC?.showFilterDailog(classifiedCategory: classifiedCategory,categoryId: category_id,subCategoryId: sub_category_id,product_type: product_type)
       
    }
    
    func doGetCategory() {
        
      
        let params = ["getClassifiedCategories":"getClassifiedCategories"]
        //                      "society_id":doGetLocalDataUser().societyID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
           
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(classifiedResponse.self, from:json!)
                    if response.status == "200" {
                        self.classifiedCategory = response.classifiedCategory
                        
                    } else {
                        
                    }
                    
                } catch {
                    print("parse error",error as Any)
                }
            }else{
                print(error as Any)
            }
        })
    }
   
    func doAfterApplyFilter(categoryId: String, subCategoryId: String,  isApplyFilter: Bool, product_type : String) {
        self.category_id = categoryId
        self.sub_category_id = subCategoryId
        self.product_type = product_type
        doCallAllClassifiedDataApi()
        if isApplyFilter {
            ivFilter.setImageColor(color: ColorConstant.colorP)
        } else {
            ivFilter.setImageColor(color: ColorConstant.grey_60)
        }
    }
    
}
extension AllClassifiedVC: UITableViewDelegate,UITableViewDataSource,ActionClassified{
    func doEdit(indexpath: IndexPath) {
        doEditFunc(index: indexpath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterClassifiedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvAllCLassified.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ClassifiedCell
        let data = filterClassifiedList[indexPath.row]
        cell.lblTitle.text = data.classifiedAddTitle
        cell.lblBrand.text = data.classifiedBrandName
        //            cell.lblFeatures.text = data.classifiedFeatures
        cell.lblPrice.text = "\(localCurrency())"+data.classifiedExpectedPrice
        cell.lblManufacturingYear.text = data.classifiedManufacturingYear
        cell.lblDate.text = data.itemAddedDate
        cell.lbCategory.text = data.classified_category_name ?? ""
        cell.indexpath = indexPath
        cell.data = self
        //  print("image is ===",data.images[0])
        if filterClassifiedList[indexPath.row].userID == doGetLocalDataUser().userID!{
            cell.btnDelete.tag = indexPath.row
            cell.viewEdit.isHidden = true
            cell.ViewDelete.isHidden = true
            cell.viewEdit.endEditing(true)
            cell.ViewDelete.endEditing(true)
//            cell.ViewDelete.isHidden = false
//            cell.viewEdit.isHidden = false
            //                cell.imgDelete.isHidden = false
            cell.btnDelete.addTarget(self, action: #selector(onClickDeletePost(_:)), for: .touchUpInside)
        }else{
            //                cell.btnDelete.isHidden = true
            cell.viewEdit.isHidden = true
            cell.ViewDelete.isHidden = true
            cell.viewEdit.endEditing(true)
            cell.ViewDelete.endEditing(true)
        }
       // let urlImg =
        if data.images == nil{
            cell.imgClassified.image =  UIImage(named: "banner_placeholder")
        }else {
            Utils.setImageFromUrl(imageView: cell.imgClassified, urlString:data.imageURL+data.images[0])

        }

        
        
        cell.lbLocation.text = data.location
        cell.lbBrand.text = "\(doGetValueLanguage(forKey: "brand_colon")) : "
        cell.lbPrice.text = "\(doGetValueLanguage(forKey: "price_colon")) : "
        cell.lbManufacturingYear.text = "\(doGetValueLanguage(forKey: "purchase_year")) : "
        cell.lbLocationLabel.text = "\(doGetValueLanguage(forKey: "location_colon")) : "
        cell.lbDate.text = "\(doGetValueLanguage(forKey: "uploaded_date")) : "
        cell.lbCategoryLabel.text = "\(doGetValueLanguage(forKey: "category")) : "
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClassifiedDetailsVC")as! ClassifiedDetailsVC
        nextVC.userClassifiedList = filterClassifiedList[indexPath.row]
        nextVC.flag = 2
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension AllClassifiedVC: AppDialogDelegate , OnSelectedLocation,OnApplyFilterServiceProvider{
    
    //for filter apply
    func onApplyFilterServiceProvider(categoryId: String, subCategoryId: String, radius: String, companyName: String, isApplyFilter: Bool) {
        print("call sub")
//        self.categoryId = categoryId
//        self.subCategoryId = subCategoryId
//        self.radius = radius
//        self.companyName = companyName
//
//
//        if isApplyFilter {
//            ivFilter.setImageColor(color: ColorConstant.colorP)
//        } else {
//            ivFilter.setImageColor(color: ColorConstant.grey_60)
//        }
        
     
    }
    func locationFilter(state_id: String, city_id: String, state: String, city: String) {
        self.state_id = state_id
        self.city_id = city_id
        self.city =  city
        self.state = state
        
        doCallAllClassifiedDataApi()
    }
    
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) {
                //              self.filteruserClassifiedList[self.selectedIndex]
                //                self.doCallDeleteApi(propertyDetail: selectedIndex)
                self.doDelete(index: Int(self.userClassifiedList[self.selectedIndex].classifiedMasterID)!)
            }
        }
    }
}
extension AllClassifiedVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "all_classified").uppercased())
        //  Details
    }
}
