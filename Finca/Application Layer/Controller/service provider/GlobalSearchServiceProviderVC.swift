//
//  GlobalSearchServiceProviderVC.swift
//  Finca
//
//  Created by CHPL Group on 03/01/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GlobalSearchServiceProviderVC: BaseVC {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var conCVHeight: NSLayoutConstraint!
    @IBOutlet weak var conTbvHeight: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbNoData: UILabel!
  
    private  let itemCellCV = "ServiceProviderNewCell"
    private let itemCellTBV = "ServiceProviderDetailCell"
    
    private var user_latitude = ""
    private var user_longitude = ""
    private var categoryArray = [LocalServiceProviderModel]()
    private var serviceProvider = [LocalServiceProviderListModel]()
    private var locationManager = CLLocationManager()
    var menuTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: itemCellCV, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCellCV)
        cvData.delegate  = self
        cvData.dataSource = self
        
        let nibTBV = UINib(nibName: itemCellTBV, bundle: nil)
        tbvData.register(nibTBV, forCellReuseIdentifier: itemCellTBV)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.estimatedRowHeight = 150
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.allowsMultipleSelection = false
        tbvData.separatorStyle = .none
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tfSearch.placeholder = doGetValueLanguage(forKey: "search")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            if  let currentLocation = locationManager.location {
                self.user_latitude = String(currentLocation.coordinate.latitude)
                self.user_longitude = String(currentLocation.coordinate.longitude)
            }
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        indicatorView.isHidden = true
        lbNoData.text =  "\(doGetValueLanguage(forKey: "search")) \(doGetValueLanguage(forKey: "service_provider_details"))"
        viewNoData.isHidden = false
       
        Utils.setImageFromUrl(imageView: ivNoData, urlString:  getPlaceholderLocal(key: menuTitle), palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
        
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.text?.count ?? 0 >= 3 {
            doGetData(search_keyword: textField.text ?? "")
        }else {
            noDataSet()
            lbNoData.text =  "\(doGetValueLanguage(forKey: "search")) \(doGetValueLanguage(forKey: "service_provider_details"))"
        }
    }
    
    private func noDataSet(){
        categoryArray.removeAll()
        serviceProvider.removeAll()
        cvData.reloadData()
        tbvData.reloadData()
        viewNoData.isHidden = false
    }

    
    @IBAction func tapBack(_ sender: UIButton) {
        doPopBAck()
    }
    
    override func viewDidLayoutSubviews() {
       
        DispatchQueue.main.async {
            if self.categoryArray.count > 0 {
                self.conCVHeight.constant = self.cvData.contentSize.height
            } else {
                self.conCVHeight.constant = 8
            }
        }
        DispatchQueue.main.async {
            if self.serviceProvider.count > 0 {
                self.conTbvHeight.constant = self.tbvData.contentSize.height
            } else {
                self.conTbvHeight.constant = 8
            }
        }
       
    }
    
    func doGetData(search_keyword : String) {
        indicatorView.startAnimating()
        let params = ["searchServiceProvider":"searchServiceProvider",
                      "search_keyword" : search_keyword,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID ?? "",
                      "user_latitude":user_latitude,
                      "user_longitude":user_longitude]
        
        print("param" , params)
        AlamofireSingleTon.sharedInstance.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params, completionHandler: { (json, error) in
            self.indicatorView.stopAnimating()
            if json != nil {
                do {
          
                    let response = try JSONDecoder().decode(ResponseSearchVendor.self, from:json!)
                    if response.status == "200" {
                       
                        
                        if let dataCategory = response.local_service_provider_category  {
                            
                            if dataCategory.count > 0   {
                                self.categoryArray = dataCategory
                            } else {
                                self.categoryArray.removeAll()
                            }
                            
                            DispatchQueue.main.async {
                                self.cvData.reloadData()
                            }
                            
                        }
                        
                        
                        if let dataProvider = response.local_service_provider {
                            if dataProvider.count > 0   {
                                self.serviceProvider = dataProvider
                            } else {
                                self.serviceProvider.removeAll()
                            }
                            DispatchQueue.main.async {
                                self.tbvData.reloadData()
                            }
                        }
                        if self.categoryArray.count > 0 || self.serviceProvider.count > 0 {
                            self.viewNoData.isHidden = true
                        } else {
                            self.viewNoData.isHidden = false
                        }
                        
                    } else {
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                        self.noDataSet()
                    }
                } catch {
                    print("parse error",error)
                }
            }
        })
    }
}


extension GlobalSearchServiceProviderVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  categoryArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellCV, for: indexPath) as! ServiceProviderNewCell
      //  Utils.setImageFromUrl(imageView: cell.imgServiceProvider, urlString: filteredArray[indexPath.row].serviceProviderCategoryImage, palceHolder: "fincasys_notext")
       // cell.heightImgView.constant = 80
       
        cell.lblServiceProviderName.text = categoryArray[indexPath.row].serviceProviderCategoryName
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2
        return CGSize(width: width - 1, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 //       let data = filteredArray[indexPath.row]
        
//        if data.localServiceSubProvider.count == 0{
//            if  StringConstants.KEY_IS_OLD_SERVICE_UI {
//                // this old ui
//                let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailOldVC")as! ServiceProviderDetailOldVC
//                nextvc.headingText = filteredArray[indexPath.row].serviceProviderCategoryName
//                nextvc.serviceProviderDetail = filteredArray[indexPath.row]
//                self.navigationController?.pushViewController(nextvc, animated: true)
//            } else {
//                let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailVC")as! ServiceProviderDetailVC
//                nextvc.headingText = filteredArray[indexPath.row].serviceProviderCategoryName
//                //nextvc.serviceProviderDetail = filteredArray[indexPath.row]
//                self.navigationController?.pushViewController(nextvc, animated: true)
//            }
//
//        }else{
//            let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderSubCateVC")as! ServiceProviderSubCateVC
//            nextvc.subServiceProviderList.append(contentsOf: data.localServiceSubProvider)
//            nextvc.serviceProviderDetail = filteredArray[indexPath.row]
//            nextvc.modalPresentationStyle = .fullScreen
//            nextvc.parentContext = self
//            self.present(nextvc, animated: true, completion: nil)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewDidLayoutSubviews()
    }
   
}

extension GlobalSearchServiceProviderVC:UITableViewDelegate ,UITableViewDataSource,ServiceProviderDelegate{

    func checkboxToggleButton(indexPath: IndexPath!) {

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  serviceProvider.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellTBV, for: indexPath)as! ServiceProviderDetailCell
        cell.selectionStyle = .none
        
        let dataItem = serviceProvider[indexPath.row]
        Utils.setImageFromUrl(imageView: cell.imgServieProvider, urlString: dataItem.serviceProviderUserImage, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
    
        cell.lblAddress.text = dataItem.serviceProviderAddress
        cell.lblName.text = dataItem.serviceProviderName
        cell.lblPhoneNumber.text = dataItem.service_provider_phone_view
        cell.lblDistance.text = dataItem.distance_in_km
        cell.delegate = self
        cell.indexPath = indexPath
        cell.lbCategory.text = dataItem.service_provider_category_name ?? ""
        if dataItem.serviceProviderEmail != nil && dataItem.serviceProviderEmail != "" {
            cell.lblEmail.text = dataItem.serviceProviderEmail
            cell.viewMail.isHidden  = false
        } else {
            cell.viewMail.isHidden  = true
        }
   
        setupMarqee(label: cell.lblName)
        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(onClickCall(sender:)), for: .touchUpInside)
//
        cell.bEmail.tag = indexPath.row
        cell.bEmail.addTarget(self, action: #selector(onClickEmail(sender:)), for: .touchUpInside)
        cell.bViewProfile.tag = indexPath.row
        cell.bViewProfile.addTarget(self, action: #selector(onTapDetails(sender:)), for: .touchUpInside)
        cell.bLocation.tag = indexPath.row
        cell.bLocation.addTarget(self, action: #selector(openMapForPlace(sender:)), for: .touchUpInside)
        
        if dataItem.isKyc == "1" {
            //verified
            cell.ivVerified.isHidden = false
        } else {
            cell.ivVerified.isHidden = true
        }
        cell.bottomContraintView.constant = 22
        let myAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let mail = NSAttributedString(string: dataItem.serviceProviderEmail ?? "", attributes: myAttribute)
        cell.lblEmail.attributedText = mail
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = serviceProvider[indexPath.row]
       // nextVC.serviceProvider = serviceProviderDetail
       // nextVC.subProviderDetail = subProviderDetail
        nextVC.service_provider_users_id = self.serviceProvider[indexPath.row].serviceProviderUsersID ?? ""

        nextVC.isUpdate = false
        nextVC.row = indexPath.row
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewDidLayoutSubviews()
    }
  
    @objc func onTapDetails(sender : UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idClickedServiceProviderDetailVC")as! ClickedServiceProviderDetailVC
        nextVC.serviceProviderDetail = serviceProvider[sender.tag]
        nextVC.service_provider_users_id = self.serviceProvider[sender.tag].serviceProviderUsersID ?? ""

       // nextVC.serviceProvider = serviceProviderDetail
       // nextVC.subProviderDetail = subProviderDetail
        nextVC.isUpdate = false
        nextVC.row = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @objc func onClickCall(sender:UIButton) {
        let index = sender.tag

        let phone = serviceProvider[index].service_provider_phone_view
        if phone == nil && phone == "" {
            return
        }
        doCall(on: phone)
    }
    
    @objc func onClickEmail(sender:UIButton) {
        let index = sender.tag

        let email = serviceProvider[index].serviceProviderEmail
        if email == nil && email == "" {
            return
        }
        
        if let url = URL(string: "mailto:\(email!)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @objc func openMapForPlace(sender:UIButton) {

        let index = sender.tag

        let lat = Double(serviceProvider[index].serviceProviderLatitude!)
        let lng = Double(serviceProvider[index].serviceProviderLogitude!)
        let latitude: CLLocationDegrees = CLLocationDegrees(lat!)
        let longitude: CLLocationDegrees = CLLocationDegrees(lng!)
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = serviceProvider[index].serviceProviderName
        mapItem.openInMaps(launchOptions: options)
    }
}


struct ResponseSearchVendor : Codable {
    let status : String? //" : "200",
    let message : String? //" : "Get Local Service Providers Details successfully."
    let local_service_provider_category: [LocalServiceProviderModel]?
    let local_service_provider: [LocalServiceProviderListModel]?
}
