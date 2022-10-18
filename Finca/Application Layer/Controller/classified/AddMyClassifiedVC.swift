//
//  AddMyClassifiedVC.swift
//  Finca
//
//  Created by Jay Patel on 18/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
//import OpalImagePicker
import Photos
import DropDown

class AddMyClassifiedVC: BaseVC, UITextViewDelegate {
    var selectedImages = [UIImage]()
    let itemCellImage = "SelectedImagesCell"
    var selctedCatId = ""
    var category = DropDown()
    var subCategory = DropDown()
    var purchaseYearDrop = DropDown()
    var catId = ""
    var index = 0
    var classifiedCatList = [ClassifiedCategory]()
    var classifiedSubCatList = [ClassifiedSubCategory]()
    var subCatId = ""
    let hint = "Description *"
    var currentYear: Int!
    var editData = ""
    var setEditData : ListedItem!
    //    var selctedCatId = ""
    //    @IBOutlet var tvDescription: ACFloatingTextfield!
    
    @IBOutlet weak var tvSpecification: UITextView!
    @IBOutlet var tvDescription: UITextView!
    @IBOutlet var tfFeatures: ACFloatingTextfield!
    
    @IBOutlet var btnSubCat: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet var tfTitle: ACFloatingTextfield!
    // @IBOutlet var tfApproxPurchaseYear: ACFloatingTextfield!
    @IBOutlet var tfColor: ACFloatingTextfield!
    @IBOutlet var tfPrice: ACFloatingTextfield!
    @IBOutlet var tfBrand: ACFloatingTextfield!
    
    @IBOutlet var lblPurchaseYear: UILabel!
    @IBOutlet var btnDeleteImage: UIButton!
    @IBOutlet var btnDeleteImage2: UIButton!
    @IBOutlet var btnDeleteImage3: UIButton!
    @IBOutlet var btnDeleteImage4: UIButton!
    @IBOutlet var lblSubCategory: UILabel!
    //    @IBOutlet var NewAddPhotoView: UIView!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnAddPhoto2: UIButton!
    @IBOutlet var btnAddPhoto3: UIButton!
    @IBOutlet var btnAddPhoto4: UIButton!
    //    @IBOutlet var clvPhoto: UICollectionView!
    @IBOutlet var imgClassified: UIImageView!
    @IBOutlet var imgClassified2: UIImageView!
    @IBOutlet var imgClassified3: UIImageView!
    @IBOutlet var imgClassified4: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var viewItemDetails: UIView!
    @IBOutlet weak var viewTitleMentionKey: UIView!
    @IBOutlet weak var viewPurchaseYear: UIView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbPhotoLabel: UILabel!
    @IBOutlet var lbPurchaseYear: UILabel!
    @IBOutlet var lbProductCondition: UILabel!
    @IBOutlet var lbTips: UILabel!
    @IBOutlet var lbOld: UILabel!
    @IBOutlet var lbNew: UILabel!
    @IBOutlet weak var ivRadioOld: UIImageView!
    @IBOutlet weak var ivRadioNew: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let placeHolder = "newphoto"
    var product_type = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSubCategory.isHidden = true
       setUIData()
        lbTitle.text = doGetValueLanguage(forKey: "add_classified_item")
        btnAdd.setTitle(doGetValueLanguage(forKey: "add").uppercased(), for: .normal)
        if editData == "editData"{
            
            lbTitle.text = doGetValueLanguage(forKey: "edit_classified_item")
            btnAdd.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
            self.lblSubCategory.isHidden = false
            catId = setEditData.classifiedcategoryid
            subCatId = setEditData.classifiedsubcategoryid
            self.doCallGetSubClassifiedDataApi(catId: self.catId)
        }
        if editData == "AllClassified"{
            lbTitle.text = doGetValueLanguage(forKey: "edit_classified_item")
            btnAdd.setTitle(doGetValueLanguage(forKey: "update").uppercased(), for: .normal)
           
            self.lblSubCategory.isHidden = false
//            catId = setEditData.classifiedcategoryid
//            subCatId = setEditData.classifiedsubcategoryid
            self.doCallGetSubClassifiedDataApi(catId: self.catId)
        }
        doCallGetClassifiedDataApi()
        doneButtonOnKeyboard(textField: tfBrand)
        doneButtonOnKeyboard(textField: tfPrice)
        //        doneButtonOnKeyboard(textField: tfApproxPurchaseYear)
        doneButtonOnKeyboard(textField: tfTitle)
        doneButtonOnKeyboard(textField: tvDescription)
        doneButtonOnKeyboard(textField: tvSpecification)
        doneButtonOnKeyboard(textField: tfFeatures)
        btnDeleteImage.isHidden = true
        btnDeleteImage2.isHidden = true
        btnDeleteImage3.isHidden = true
        btnDeleteImage4.isHidden = true
        
        tvSpecification.delegate = self
        tvDescription.delegate = self
        tfPrice.delegate = self
        tfFeatures.delegate = self
        tfTitle.delegate = self
        tfBrand.delegate = self
       // tvDescription.text = hint
       // tvDescription.textColor = UIColor.lightGray
        
        
        if editData == "editData"{
            var PriceSet = ""
            var set = ""
            tvDescription.text = setEditData.classifiedDescribeSelling
            tvDescription.textColor = UIColor.black
            
            tvSpecification.text = setEditData.classifiedspecification
            tvSpecification.textColor = UIColor.black
            tfFeatures.text = setEditData.classifiedFeatures
            tfTitle.text = setEditData.classifiedAddTitle
            tfBrand.text = setEditData.classifiedBrandName
            lblPurchaseYear.text = setEditData.classifiedManufacturingYear
            set = setEditData.classifiedExpectedPrice.replacingOccurrences(of: ".00", with: "", options: NSString.CompareOptions.literal, range: nil)
            print("Set" , set)
            PriceSet = setEditData.classifiedExpectedPrice.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            tfPrice.text = PriceSet
            product_type = setEditData.product_type ?? "0"
            
           // print(tfPrice.text , "PriceSet")
            //           print("setEditData.images.count",setEditData.images.count)
            if setEditData.images == nil{
                btnAddPhoto.isHidden = false
                btnAddPhoto2.isHidden = false
                btnAddPhoto3.isHidden = false
                btnAddPhoto4.isHidden = false
                btnDeleteImage2.isHidden = true
                btnDeleteImage.isHidden = true
                btnDeleteImage3.isHidden = true
                btnDeleteImage4.isHidden = true
            }else{
                if setEditData.images.count == 1{
                    btnAddPhoto.isHidden = true
                    btnDeleteImage.isHidden = false
                    //imgClassified.isHidden = false
                    print(setEditData.imageURL+setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                }else if setEditData.images.count == 2{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                }else if setEditData.images.count == 3{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnAddPhoto3.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    btnDeleteImage3.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                    Utils.setImageFromUrl(imageView: imgClassified3, urlString: setEditData.imageURL  + setEditData.images[2])
                }else{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnAddPhoto3.isHidden = true
                    btnAddPhoto4.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    btnDeleteImage3.isHidden = false
                    btnDeleteImage4.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                    Utils.setImageFromUrl(imageView: imgClassified3, urlString: setEditData.imageURL  + setEditData.images[2])
                    Utils.setImageFromUrl(imageView: imgClassified4, urlString: setEditData.imageURL  + setEditData.images[3])
                }
            }
            
        }
        if editData == "AllClassified"{
            var PriceSet = ""
            var set = ""
            tvDescription.text = setEditData.classifiedDescribeSelling
            tvDescription.textColor = UIColor.black
            tvSpecification.text = setEditData.classifiedspecification
            tvSpecification.textColor = UIColor.black
            tfFeatures.text = setEditData.classifiedFeatures
            tfTitle.text = setEditData.classifiedAddTitle
            tfBrand.text = setEditData.classifiedBrandName
            lblPurchaseYear.text = setEditData.classifiedManufacturingYear
            set = setEditData.classifiedExpectedPrice.replacingOccurrences(of: ".00", with: "", options: NSString.CompareOptions.literal, range: nil)
            print("Set" , set)
            PriceSet = setEditData.classifiedExpectedPrice.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            product_type = setEditData.product_type ?? "0"
            tfPrice.text = PriceSet
           // print(tfPrice.text , "PriceSet")
            //           print("setEditData.images.count",setEditData.images.count)
            if setEditData.images == nil{
                btnAddPhoto.isHidden = false
                btnAddPhoto2.isHidden = false
                btnAddPhoto3.isHidden = false
                btnAddPhoto4.isHidden = false
                btnDeleteImage2.isHidden = true
                btnDeleteImage.isHidden = true
                btnDeleteImage3.isHidden = true
                btnDeleteImage4.isHidden = true
            }else{
                if setEditData.images.count == 1{
                    btnAddPhoto.isHidden = true
                    btnDeleteImage.isHidden = false
                    //imgClassified.isHidden = false
                    print(setEditData.imageURL+setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                }else if setEditData.images.count == 2{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                }else if setEditData.images.count == 3{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnAddPhoto3.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    btnDeleteImage3.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                    Utils.setImageFromUrl(imageView: imgClassified3, urlString: setEditData.imageURL  + setEditData.images[2])
                }else{
                    btnAddPhoto.isHidden = true
                    btnAddPhoto2.isHidden = true
                    btnAddPhoto3.isHidden = true
                    btnAddPhoto4.isHidden = true
                    btnDeleteImage2.isHidden = false
                    btnDeleteImage.isHidden = false
                    btnDeleteImage3.isHidden = false
                    btnDeleteImage4.isHidden = false
                    Utils.setImageFromUrl(imageView: imgClassified, urlString: setEditData.imageURL  + setEditData.images[0])
                    Utils.setImageFromUrl(imageView: imgClassified2, urlString: setEditData.imageURL  + setEditData.images[1])
                    Utils.setImageFromUrl(imageView: imgClassified3, urlString: setEditData.imageURL  + setEditData.images[2])
                    Utils.setImageFromUrl(imageView: imgClassified4, urlString: setEditData.imageURL  + setEditData.images[3])
                }
            }
            
        }
        setThreeCorner(viewMain: mainImageView)
        setThreeCorner(viewMain: categoryView)
        setThreeCorner(viewMain: subCategoryView)
        setThreeCorner(viewMain: viewPurchaseYear)
        setThreeCorner(viewMain: viewTitleMentionKey)
        setThreeCorner(viewMain: viewItemDetails)
        selectProductCondition(type: product_type)
    }
    
    func setUIData() {
        lbPhotoLabel.text = doGetValueLanguage(forKey: "add_desc_classified")
         
        tfBrand.placeholder = "\(doGetValueLanguage(forKey: "brand"))*"
        tfFeatures.placeholder = "\(doGetValueLanguage(forKey: "features"))*"
        tfPrice.placeholder = "\(doGetValueLanguage(forKey: "expected_price"))*"
        tfTitle.placeholder = "\(doGetValueLanguage(forKey: "title_star"))*"
        lbPurchaseYear.text = "\(doGetValueLanguage(forKey: "purchase_year"))*"
        lbTips.text = doGetValueLanguage(forKey: "classified_mention")
        lbProductCondition.text  = doGetValueLanguage(forKey: "condition")
        lbOld.text  = doGetValueLanguage(forKey: "old_items")
        lbNew.text  = doGetValueLanguage(forKey: "new_items")
        tvDescription.placeholder = "\(doGetValueLanguage(forKey: "description_colon")) :"
        tvDescription.placeholderColor = .gray
        tvSpecification.placeholder = "\(doGetValueLanguage(forKey: "specification"))* :"
        tvSpecification.placeholderColor = .gray
        
        
        
        lblCategory.text = doGetValueLanguage(forKey:"select_category")
        ///selectProductCondition(type: product_type)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
   
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    @IBAction func btnDeleteImage(_ sender: UIButton) {
        let deleteTag = sender.tag
        print("tag is",deleteTag)
        
        //        for (index,item) in selectedImages.enumerated(){
        
        if deleteTag == 1{
            
            self.imgClassified.image = UIImage(named: placeHolder)
            self.btnDeleteImage.isHidden = true
            self.btnAddPhoto.isHidden = false
            
        }else if deleteTag == 2{
            
            self.imgClassified2.image = UIImage(named: placeHolder)
            self.btnDeleteImage2.isHidden = true
            self.btnAddPhoto2.isHidden = false
            
        }else if deleteTag == 3{
            
            self.imgClassified3.image = UIImage(named: placeHolder)
            self.btnDeleteImage3.isHidden = true
            self.btnAddPhoto3.isHidden = false
            
        }else if deleteTag == 4{
            
            self.imgClassified4.image = UIImage(named: placeHolder)
            self.btnDeleteImage4.isHidden = true
            self.btnAddPhoto4.isHidden = false
            
        }
        //        }
        print(selectedImages.count)
    }
    
    @IBAction func btnAddImage(_ sender: UIButton) {
        index = sender.tag
        let alertVC = UIAlertController(title: "", message: "Select profile picture", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.btnOpenCamera()
        }))
        alertVC.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            //self.btnOpenGallery()
            self.shoImagePicker()
        }))
        /* alertVC.addAction(UIAlertAction(title: "File Explorer", style: .default, handler: { (UIAlertAction) in
         self.attachDocument()
         }))*/
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func btnOpenCamera() {
        //   self.pickerTag = tag
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func shoImagePicker() {
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        //Change color of image tint to black
        imagePicker.selectionImageTintColor = UIColor.black
        //Change status bar style
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        //Limit maximum allowed selections to 5
        //    imagePicker.maximumSelectionsAllowed = 10
        //Only allow image media type assets
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        imagePicker.imagePickerDelegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func doCallImageSetup()  {
        print(selectedImages.count)
        if selectedImages.count > 0 {
            if selectedImages.count >= 4{
                
            }else{
                
            }
            btnAddPhoto.isHidden = true
            imgClassified.isHidden = true
            //            clvPhoto.isHidden = false
            
        }else{
            btnAddPhoto.isHidden = false
            
            imgClassified.isHidden = false
            //            clvPhoto.isHidden = true
        }
    }
    func doCallGetClassifiedDataApi() {
        
        showProgress()
        let params = ["getClassifiedCategories":"getClassifiedCategories"]
        //                      "society_id":doGetLocalDataUser().societyID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(classifiedResponse.self, from:json!)
                    if response.status == "200" {
                        self.classifiedCatList = response.classifiedCategory
                        if self.catId != ""{
                            for item in self.classifiedCatList{
                                print("200")
                                if item.classifiedCategoryID == self.catId {
                                    print("====")
                                    self.lblCategory.text = item.classifiedCategoryName
                                    self.doCallGetSubClassifiedDataApi(catId:self.catId)
                                    print("suncat" ,self.subCatId)
                                    //                                for data in self.classifiedSubCatList{
                                    //
                                    //                                    if data.classifiedSubCategoryID == self.subCatId {
                                    //
                                    //                                     self.lblSubCategory.text = data.classifiedSubCategoryName
                                    //                                        print("====", data.classifiedSubCategoryName)
                                    //                                }
                                    //
                                    //                            }
                                }
                            }
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
    
    @IBAction func btnPurchaseYear(_ sender: Any) {
        currentYear = Calendar.current.component(.year, from: Date())
        let years = (currentYear - 50...currentYear).map { String($0) }
        print("currentYear is==",currentYear as Any)
        print("years is ==",years)
        
        purchaseYearDrop.anchorView = lblPurchaseYear
        purchaseYearDrop.dataSource = years.reversed()
        purchaseYearDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblPurchaseYear.text = item
        }
        purchaseYearDrop.show()
    }
    @IBAction func btnSubCategory(_ sender: Any) {
        if lblCategory.text == doGetValueLanguage(forKey:"select_category"){
            showAlertMessage(title: "", msg: "please first select category")
        }else{
            var subCategoryList = [String]()
            subCategoryList.removeAll()
            for item in classifiedSubCatList{
                subCategoryList.append(item.classifiedSubCategoryName)
            }
            subCategory.anchorView = lblSubCategory
            subCategory.dataSource = subCategoryList
            subCategory.selectionAction = { [unowned self] (index: Int, item: String) in
                self.lblSubCategory.text = item
                print(item , "item")
                
                self.subCatId = String(self.classifiedSubCatList[index].classifiedSubCategoryID)
                //                   self.selctedCatId = self.doGetIdfromSubCategoryName(catName: item)
            }
            subCategory.show()
        }
    }
    func doCallGetSubClassifiedDataApi(catId:String) {
        
        //              showProgress()
        let params = ["getClassifiedSubCategories":"getClassifiedSubCategories",
                      "classified_category_id":catId]
        //                      "society_id":doGetLocalDataUser().societyID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.classifiedController, parameters: params, completionHandler: { (json, error) in
            //                        self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(SubClassifiedResponse.self, from:json!)
                    if response.status == "200" {
                        //                                print(response)
                        self.classifiedSubCatList = response.classifiedSubCategory
                        
                        if self.subCatId != ""{
                            for item in self.classifiedSubCatList{
                                print("sub 200")
                                if item.classifiedSubCategoryID == self.subCatId {
                                    print(" sub ====")
                                    self.lblSubCategory.text = item.classifiedSubCategoryName
                                  //  print(item.classifiedSubCategoryName,"classifiedSubCategoryName")
                                    
                                }
                            }
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
    @IBAction func btnCategory(_ sender: Any) {
        var categoryList = [String]()
        categoryList.removeAll()
        for item in classifiedCatList{
            categoryList.append(item.classifiedCategoryName)
        }
        category.anchorView = lblCategory
        category.dataSource = categoryList
        category.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblCategory.text = item
            self.lblSubCategory.isHidden = false
            self.lblSubCategory.text = ""
            self.lblSubCategory.text = doGetValueLanguage(forKey:"select_sub_category")
            
            
            self.catId = String(self.classifiedCatList[index].classifiedCategoryID)
            print("catid == " , self.catId)
            self.doCallGetSubClassifiedDataApi(catId: self.catId)
            //                   self.selctedCatId = self.doGetIdfromCategoryName(catName: item)
        }
        category.show()
    }
    
    
    func doEditAPI(subCatId:String,catId:String){
        
        
        
        // PriceSet = text2.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        showProgress()
        let params = ["editClassifiedItem":"editClassifiedItem",
                      "classified_master_id": setEditData.classifiedMasterID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "classified_category_id":catId,
                      "classified_sub_category_id":subCatId,
                      "classified_add_title":tfTitle.text!,
                      "classified_describe_selling":tvDescription.text!,
                      "classified_specification":tvSpecification.text!,
                      "classified_brand_name":tfBrand.text!,
                      "classified_manufacturing_year":lblPurchaseYear.text!,
                      "classified_features":tfFeatures.text!,
                      "classified_expected_price":tfPrice.text!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "product_type" : product_type]
        
        print("param" , params)
        print("catid is===",catId)
        print("subCatId is===",subCatId)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipart(serviceName: ServiceNameConstants.classifiedController, parameters: params as [String : Any], imagesArray: selectedImages, compression: 0, completionHandler:{ (json, error) in
            self.hideProgress()
            print("selectedImages" , self.selectedImages )
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.toast(message: response.message, type: .Success)
                        
                        // self.toast(message: "Item Update successfully", type: .Success, duration: 2.0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.toast(message: response.message, type: .Faliure)
                    }
                    
                } catch {
                    print("parse error",error as Any)
                }
            }else{
                print(error as Any)
            }
        })
    }
    
    func doAddClassifiedDataApi(subCatId:String,catId:String) {
        DispatchQueue.main.async {
            self.showProgress()
        }
        
        var images = [UIImage]()
        print("size" , selectedImages.count)
        for image in selectedImages {
//            if image.cgImage != UIImage(named: "newphoto")?.cgImage{
//                images.append(image)
//            }
            if  !image.isEqualToImage(image: UIImage(named: placeHolder)!) {
                images.append(image)
            }
        }
        
       
      
        let params = ["addClassifiedItem":"addClassifiedItem",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "classified_category_id":catId,
                      "classified_sub_category_id":subCatId,
                      "classified_add_title":tfTitle.text!,
                      "classified_describe_selling":tvDescription.text!,
                      "classified_specification":tvSpecification.text!,
                      "classified_brand_name":tfBrand.text!,
                      "classified_manufacturing_year":lblPurchaseYear.text!,
                      "classified_features":tfFeatures.text!,
                      "classified_expected_price":tfPrice.text!,
                      "country_code":doGetLocalDataUser().countryCode!,
                      "user_name":doGetLocalDataUser().userFullName!,
                      "user_mobile":doGetLocalDataUser().userMobile!,
                      "product_type" : product_type]
        
        print("param" , params)
        print("catid is===",catId)
        print("subCatId is===",subCatId)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostMultipart(serviceName: ServiceNameConstants.classifiedController, parameters: params as [String : Any], imagesArray: images, compression: 0, completionHandler:{ (json, error) in
          //  print("selectedImages" , self.selectedImages )
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        //                              print(response)
                        self.navigationController?.popViewController(animated: true)
                        
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
    func doValidate()->Bool{
        
        /* if imgComplaint.image == UIImage(named: "no-image-available"){
         showAlertMessage(title: "", msg: "please select a image for your complain")
         return false
         }*/
        selectedImages.removeAll()
        if !imgClassified.image!.isEqualToImage(image: UIImage(named:placeHolder)!) {
            if selectedImages.count < 4{
                selectedImages.append(imgClassified.image!)
            }
        }
        if !imgClassified2.image!.isEqualToImage(image: UIImage(named: placeHolder)!) {
            if selectedImages.count < 4{
                selectedImages.append(imgClassified2.image!)
            }
        }
        if !imgClassified3.image!.isEqualToImage(image: UIImage(named: placeHolder)!) {
            if selectedImages.count < 4{
                selectedImages.append(imgClassified3.image!)
            }
        }
        if !imgClassified4.image!.isEqualToImage(image: UIImage(named: placeHolder)!) {
            if selectedImages.count < 4{
                selectedImages.append(imgClassified4.image!)
            }
        }
  
        if lblCategory.text == doGetValueLanguage(forKey:"select_category"){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"select_category"))
            return false
        }
        
        if lblSubCategory.text == doGetValueLanguage(forKey:"select_sub_category"){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"select_sub_category"))
            return false
        }
        if (tfBrand.text?.isEmptyOrWhitespace())!{
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"please_enter_brand"))
            return false
        }
        if (tvSpecification.text?.isEmptyOrWhitespace())!{
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"please_enter_specification"))
            return false
        }
        //        if (tfApproxPurchaseYear.text!.isEmptyOrWhitespace()){
        //            showAlertMessage(title: "", msg: "please select purchase year")
        //            return false
        //        }
//        if (tvDescription.text!.isEmptyOrWhitespace()){
//            showAlertMessage(title: "", msg: "please add description")
//            return false
//        }
        if (tfTitle.text!.isEmptyOrWhitespace()){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"please_enter_title"))
            return false
        }
        if (tvDescription.text!.isEmptyOrWhitespace()){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"please_enter_description"))
            return false
        }
        if (tfFeatures.text!.isEmptyOrWhitespace()){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"please_enter_features"))
            return false
        }
        if (tfPrice.text!.isEmptyOrWhitespace()){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"valid_expected_price"))
            return false
        }
        if (Int(tfPrice.text!) == 0){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey:"valid_expected_price"))
            return false
        }
        /* if UIImage(named: "addphotos")?.cgImage == imgComplaint.image?.cgImage{
         imgComplaint.image = UIImage(named: "")
         }*/
        return true
    }
    @IBAction func btnAddClassified(_ sender: Any) {
        if doValidate(){
            
            if editData == "editData"{
                print("doEditAPI")
                doEditAPI(subCatId: subCatId, catId: catId)
            }else if editData == "AllClassified"{
                print("doEditAPI")
                doEditAPI(subCatId: subCatId, catId: catId)
            }else{
                print("doAddClassifiedDataApi")
                doAddClassifiedDataApi(subCatId: subCatId, catId: catId)
            }
        }
    }
        
    
    @objc func btnImageRemove(_ sender:UIButton){
        self.selectedImages.remove(at: sender.tag)
        //        clvPhoto.reloadData()
        
        if selectedImages.count == 0 {
            imgClassified.isHidden = false
            btnAddPhoto.isHidden = false
            //            clvPhoto.isHidden = true
        }
        //           doSetHeightImaheCollection()
    }

    @IBAction func onClickOld(_ sender: Any) {
        product_type = "0" // old
        selectProductCondition(type: product_type)
        
    }
    @IBAction func onClickNew(_ sender: Any) {
        product_type = "1" // new
        selectProductCondition(type: product_type)
        
    }
    private func selectProductCondition(type : String){
        // type 0 is old and 1 is new
        switch type {
        case "0":
            ivRadioOld.image = UIImage(named: "radio-selected")
            ivRadioNew.image = UIImage(named: "radio-blank")
            ivRadioOld.setImageColor(color:  ColorConstant.colorP)
            ivRadioNew.setImageColor(color:  ColorConstant.colorP)
        case "1":
            ivRadioNew.image = UIImage(named: "radio-selected")
            ivRadioOld.image = UIImage(named: "radio-blank")
            ivRadioOld.setImageColor(color:  ColorConstant.colorP)
            ivRadioNew.setImageColor(color:  ColorConstant.colorP)
        default:
            break
        }
        
    }
   
}

//extension AddMyClassifiedVC:  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return selectedImages.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = clvPhoto.dequeueReusableCell(withReuseIdentifier: itemCellImage, for: indexPath)as!SelectedImagesCell
//        cell.imgSelectedImage.image = selectedImages[indexPath.row]
//        cell.imgSelectedImage.contentMode = .scaleToFill
//        cell.btnDeletePressed.tag = indexPath.row
//        cell.btnDeletePressed.addTarget(self, action: #selector(btnImageRemove(_:)), for: .touchUpInside)
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = clvPhoto.frame.width / 2
//        return CGSize(width: width - 3 , height: 160)
//    }
//}
extension AddMyClassifiedVC : OpalImagePickerControllerDelegate{
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
//        if index==1{
//            print("xczsadadaz")
//            btnAddPhoto.isHidden = true
//            btnDeleteImage.isHidden = false
//            imgClassified.image = images[0]
//            print("xczsadadaz",images[0])
//        }
//        if index==2{
//            btnAddPhoto2.isHidden = true
//            btnDeleteImage2.isHidden = false
//            imgClassified2.image = images[0]
//
//        }
//        if index==3{
//            btnAddPhoto3.isHidden = true
//            btnDeleteImage3.isHidden = false
//            imgClassified3.image = images[0]
//
//        }
//        if index==4{
//            btnAddPhoto4.isHidden = true
//            btnDeleteImage4.isHidden = false
//            imgClassified4.image = images[0]
//
//        }
        //        self.selectedImages.append(contentsOf: images)
        //        if images.count > 0 {
        ////            imgClassified.isHidden = true
        //            btnAddPhoto.isHidden = true
        ////            clvPhoto.isHidden = false
        //        }
        //        doCallImageSetup()
        //        self.selectedImages.append(contentsOf: images)
        ////        self.clvPhoto.reloadData()
        //        //        doSetHeightImaheCollection()
//        picker.dismiss(animated: true) {
//            //            picker.
//            picker.viewDidDisappear(true)
//        }
    }
    
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
         
        
        if index==1{
            print("xczsadadaz")
            btnAddPhoto.isHidden = true
            btnDeleteImage.isHidden = false
            imgClassified.image = self.getAssetThumbnailNew(asset: assets[0])
           // print("xczsadadaz",images[0])
        }
        if index==2{
            btnAddPhoto2.isHidden = true
            btnDeleteImage2.isHidden = false
            imgClassified2.image = self.getAssetThumbnailNew(asset: assets[0])
            
        }
        if index==3{
            btnAddPhoto3.isHidden = true
            btnDeleteImage3.isHidden = false
            imgClassified3.image = self.getAssetThumbnailNew(asset: assets[0])
            
        }
        if index==4{
            btnAddPhoto4.isHidden = true
            btnDeleteImage4.isHidden = false
            imgClassified4.image =  self.getAssetThumbnailNew(asset: assets[0])
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
extension AddMyClassifiedVC :  UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        if index==1{
            print("xczz")
            
            btnAddPhoto.isHidden = true
            btnDeleteImage.isHidden = false
            imgClassified.image = selectedImage
            print("index==1",selectedImage)
        }
        if index==2{
            btnAddPhoto2.isHidden = true
            btnDeleteImage2.isHidden = false
            imgClassified2.image = selectedImage
            print("index==2",selectedImage)
        }
        if index==3{
            btnAddPhoto3.isHidden = true
            btnDeleteImage3.isHidden = false
            imgClassified3.image = selectedImage
            print("index==3",selectedImage)
        }
        if index==4{
            btnAddPhoto4.isHidden = true
            btnDeleteImage4.isHidden = false
            imgClassified4.image = selectedImage
            print("index==4",selectedImage)
        }
        // self.selectedImages.append(selectedImage)
        //        self.clvPhoto.reloadData()
    }
}

extension UIImage {

    func isEqualToImage(image: UIImage) -> Bool {
        let data1: Data = self.pngData()!
        let data2: Data = image.pngData()!
        return data1 == (data2)
    }

}
