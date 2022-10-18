//
//  ServiceProviderFilterVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/06/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit
import DropDown

protocol OnApplyFilterServiceProvider {
    func onApplyFilterServiceProvider(categoryId : String ,subCategoryId : String , radius : String , companyName : String,isApplyFilter : Bool)
}
class ServiceProviderFilterVC: BaseVC {

    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbSubCategory: UILabel!
    @IBOutlet weak var lbRadius: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbFilterLabel: UILabel!
    @IBOutlet weak var lbSelctCategoryLabel: UILabel!
    @IBOutlet weak var lbSelctSubCategoryLabel: UILabel!
    @IBOutlet weak var lbSelectRadius: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var bReset: UIButton!
    @IBOutlet weak var bApply: UIButton!
     
    let dropDown = DropDown()
    var radius = ""
    var category = [LocalServiceProviderModel]()
    var subSategory = [LocalServiceSubProviderModel]()
    var categoryString = [String]()
    var subCategoryString = [String]()
    var catetegoryPlace = ""
    
    var categoryId = "0"
    var subCategoryId = "0"
    var onApplyFilterServiceProvider : OnApplyFilterServiceProvider!
    var companyName = ""
    var isResetfilter = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        catetegoryPlace = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbFilterLabel.text = doGetValueLanguage(forKey: "filter")
        lbSelctCategoryLabel.text = doGetValueLanguage(forKey: "select_category")
        lbSelctSubCategoryLabel.text = doGetValueLanguage(forKey: "select_sub_category")
        lbSelectRadius.text = doGetValueLanguage(forKey: "radius")
        lbName.text = doGetValueLanguage(forKey: "company_name_cum")
        bReset.setTitle(doGetValueLanguage(forKey: "reset"), for: .normal)
        bApply.setTitle(doGetValueLanguage(forKey: "apply"), for: .normal)
        tfName.placeholder = doGetValueLanguage(forKey: "type_here")
        
        lbCategory.text = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
        lbRadius.text = doGetValueLanguage(forKey: "all")
        
        
        if radius != "" {
            lbRadius.text  = "\(radius) km"
        }
        if companyName != "" {
            tfName.text = companyName
        }
        
        categoryString.append(catetegoryPlace)
        for item in category {
            categoryString.append(item.serviceProviderCategoryName)
            
            if categoryId != "0" &&  categoryId == item.localServiceProviderID {
                lbCategory.text = item.serviceProviderCategoryName
                
                
                if let data =  item.localServiceSubProvider {
                   
                    subCategoryString.removeAll()
                    subCategoryString.append(doGetValueLanguage(forKey: "all_sub_category"))
                    
                    if data.count > 0 {
                        subSategory = item.localServiceSubProvider
                        for itemSub in  data {
                            
                            if subCategoryId != "0" && subCategoryId == itemSub.localServiceProviderSubId {
                                lbSubCategory.text = itemSub.serviceProviderSubCategoryName
                            }
                            subCategoryString.append(itemSub.serviceProviderSubCategoryName)
                        }
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @IBAction func tapCloseFilter(_ sender: Any) {
        removePopView()
    }
    @IBAction func tapCategory(_ sender: Any) {
      
        dropDown.anchorView = lbCategory
        dropDown.dataSource = categoryString
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbCategory.text = item
            isResetfilter = ""
            subCategoryId = "0"
            lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
           
            subSategory.removeAll()
            subCategoryString.removeAll()
            subCategoryString.append(doGetValueLanguage(forKey: "all_sub_category"))
           
            if item == catetegoryPlace {
                categoryId = "0"
            } else {
                categoryId = category[index-1].localServiceProviderID ?? ""
                
                if category[index-1].localServiceSubProvider.count > 0 {
                    subSategory = category[index-1].localServiceSubProvider
                    
                    if let data =  category[index-1].localServiceSubProvider {
                        
                        if data.count > 0 {
                            for item in  data {
                                subCategoryString.append(item.serviceProviderSubCategoryName)
                            }
                        }
                    }
                }
              
            }
              
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
    }
    @IBAction func tapSubCategory(_ sender: Any) {
        
//        if subSategory.count == 0 {
//            return
//        }
        dropDown.anchorView = lbSubCategory
        dropDown.dataSource = subCategoryString
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            isResetfilter = ""
            lbSubCategory.text = item
            if item == doGetValueLanguage(forKey: "all_sub_category") {
                subCategoryId = "0"
            } else {
                subCategoryId = subSategory[index-1].localServiceProviderSubId ?? "0"
            }
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
        
    }
    @IBAction func tapRadius(_ sender: Any) {
        dropDown.anchorView = lbRadius
        dropDown.dataSource = [doGetValueLanguage(forKey: "all") ,"40 km","30 km","20 km","10 km"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbRadius.text = item
            isResetfilter = ""
            if item == doGetValueLanguage(forKey: "all") {
                radius = ""
            } else {
                radius = String(item.split(separator: " ")[0])
            }
        }
       
        dropDown.show()
    }
    @IBAction func tapApply(_ sender: Any) {
        var isApplyFilter = true
        if isResetfilter != "" {
            isApplyFilter = false
        }
        onApplyFilterServiceProvider.onApplyFilterServiceProvider(categoryId: categoryId, subCategoryId: subCategoryId, radius: radius, companyName: tfName.text ?? "", isApplyFilter: isApplyFilter)
        removePopView()
    }
    @IBAction func tapReset(_ sender: Any) {
        lbCategory.text = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
        lbRadius.text = doGetValueLanguage(forKey: "all")
      
        categoryId = "0"
        subCategoryId = "0"
        radius = ""
        tfName.text  =  ""
        isResetfilter = "1"
//        onApplyFilterServiceProvider.onApplyFilterServiceProvider(categoryId: categoryId, subCategoryId: subCategoryId, radius: radius, companyName: tfName.text ?? "", isApplyFilter: false)
//        removePopView()
    }

   
    @objc  func keyboardWillShow(sender: NSNotification) {
       
        self.view.frame.origin.y = -120
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
       // scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       
        self.view.frame.origin.y = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
   
    @IBAction func btnKeyboardReturnClicked(_ sender: UITextField) {
        self.view.endEditing(true)
    }
}
