//
//  BuySellFilterVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 01/07/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import UIKit
import DropDown
class BuySellFilterVC: BaseVC {
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbSubCategory: UILabel!
    @IBOutlet weak var lbFilterLabel: UILabel!
    @IBOutlet weak var lbSelctCategoryLabel: UILabel!
    @IBOutlet weak var lbSelctSubCategoryLabel: UILabel!
    @IBOutlet weak var bReset: UIButton!
    @IBOutlet weak var bApply: UIButton!
    
    @IBOutlet weak var lbCondition: UILabel!
    @IBOutlet weak var lbConditionLabel: UILabel!
    let dropDown = DropDown()
    var categoryString = [String]()
    var subCategoryString = [String]()
    var onApplyFilterServiceProvider : OnApplyFilterServiceProvider!
    var categoryId = "0"
    var subCategoryId = "0"
    var classifiedCategory = [ClassifiedCategory]()
    var catetegoryPlace = ""
    var classifiedSubCategory = [ClassifiedSubCategory]()
    var condition = ""
   var isResetfilter = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
        catetegoryPlace = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbFilterLabel.text = doGetValueLanguage(forKey: "filter")
        lbSelctCategoryLabel.text = doGetValueLanguage(forKey: "select_category").uppercased()
        lbSelctSubCategoryLabel.text = doGetValueLanguage(forKey: "select_sub_category")
        bReset.setTitle(doGetValueLanguage(forKey: "reset"), for: .normal)
        bApply.setTitle(doGetValueLanguage(forKey: "apply"), for: .normal)
        
        lbCategory.text = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
        subCategoryString.append(doGetValueLanguage(forKey: "all_sub_category"))
        
        lbCondition.text = doGetValueLanguage(forKey: "all")
        lbConditionLabel.text = doGetValueLanguage(forKey: "condition")
        
        
        if condition != "" {
            
            if condition == "0" {
                lbCondition.text = doGetValueLanguage(forKey: "old_items")
            } else {
                lbCondition.text = doGetValueLanguage(forKey: "new_items")
            }
        } else {
            lbCondition.text = doGetValueLanguage(forKey: "all")
        }
        
        
        categoryString.append(catetegoryPlace)
        for item in classifiedCategory {
            categoryString.append(item.classifiedCategoryName)
            
            if categoryId != "0" &&  categoryId == item.classifiedCategoryID {
                lbCategory.text = item.classifiedCategoryName
                
               
                subCategoryString.removeAll()
                subCategoryString.append(doGetValueLanguage(forKey: "all_sub_category"))
                
                
                self.doCallGetSubCatDataAPI()
                
            }
            
            
        }
        
    }


   
    @IBAction func tapCloseFilter(_ sender: Any) {
        removePopView()
    }
    @IBAction func tapCategory(_ sender: Any) {
        isResetfilter = ""
        dropDown.anchorView = lbCategory
        dropDown.dataSource = categoryString
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbCategory.text = item
            
            subCategoryId = "0"
            lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
            classifiedSubCategory.removeAll()
            subCategoryString.removeAll()
            subCategoryString.append(doGetValueLanguage(forKey: "all_sub_category"))

            if item == catetegoryPlace {
                categoryId = "0"
            } else {
                categoryId = classifiedCategory[index-1].classifiedCategoryID ?? ""
                doCallGetSubCatDataAPI()
                
            }
              
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
    }
    @IBAction func tapSubCategory(_ sender: Any) {
        
        isResetfilter = ""
        dropDown.anchorView = lbSubCategory
        dropDown.dataSource = subCategoryString
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbSubCategory.text = item
            if item == doGetValueLanguage(forKey: "all_sub_category") {
                subCategoryId = "0"
            } else {
                subCategoryId = classifiedSubCategory[index-1].classifiedSubCategoryID ?? "0"
            }
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
        
    }
    @IBAction func tapCondition(_ sender: Any) {
        isResetfilter = ""
        let array = [doGetValueLanguage(forKey: "all"),doGetValueLanguage(forKey: "old_items"),doGetValueLanguage(forKey: "new_items")]
        dropDown.anchorView = lbCondition
        dropDown.dataSource = array
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbCondition.text = item
            if item == doGetValueLanguage(forKey: "all") {
                condition = ""
            } else if item == doGetValueLanguage(forKey: "old_items") {
                condition = "0"
            } else {
                condition = "1"
            }
        }
        //        dropDown.width = btnDropdownRelation.frame.width
        dropDown.show()
        
        
    }
    
    
  
    @IBAction func tapApply(_ sender: Any) {
        var isApplyFilter = true
        if isResetfilter != "" {
            isApplyFilter = false
        }
        onApplyFilterServiceProvider.onApplyFilterServiceProvider(categoryId: categoryId, subCategoryId: subCategoryId, radius: condition, companyName: "", isApplyFilter: isApplyFilter)
        removePopView()
    }
    @IBAction func tapReset(_ sender: Any) {
        categoryId = "0"
        subCategoryId = "0"
        condition = ""
        isResetfilter = "1"
        lbCategory.text = "\(doGetValueLanguage(forKey: "all")) \(doGetValueLanguage(forKey: "category"))"
        lbSubCategory.text = doGetValueLanguage(forKey: "all_sub_category")
        lbCondition.text = doGetValueLanguage(forKey: "all")
        
      //  onApplyFilterServiceProvider.onApplyFilterServiceProvider(categoryId: categoryId, subCategoryId: subCategoryId, radius: "", companyName: "", isApplyFilter: false)
       // removePopView()
    }
    
    func doCallGetSubCatDataAPI() {

        showProgress()
        let params = ["getClassifiedSubCategories":"getClassifiedSubCategories",
                      "classified_category_id":categoryId]
        //                      "society_id":doGetLocalDataUser().societyID!]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(SubClassifiedResponse.self, from:json!)
                    if response.status == "200" {
                        //                                print(response)
                        self.classifiedSubCategory = response.classifiedSubCategory
                    
                        for item in response.classifiedSubCategory {
                            
                            if self.subCategoryId != "0" && self.subCategoryId == item.classifiedSubCategoryID {
                                self.lbSubCategory.text = item.classifiedSubCategoryName
                            }
                            
                            self.subCategoryString.append(item.classifiedSubCategoryName)
                        }
                        
                        
                        
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
    
}
