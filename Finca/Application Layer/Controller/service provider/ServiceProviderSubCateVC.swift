//
//  ServiceProviderSubCateVC.swift
//  Finca
//
//  Created by harsh panchal on 03/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ServiceProviderSubCateVC: BaseVC {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var cvSubServiceProvider: UICollectionView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbNoData: UILabel!
   
    var itemCell = "ServiceProviderNewCell"
    var subServiceProviderList = [LocalServiceSubProviderModel]()
    var filteredArray = [LocalServiceSubProviderModel]()
    var parentContext : ServiceProviderVC!
    var locationManager = CLLocationManager()
    var serviceProviderDetail : LocalServiceProviderModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPageTitle.text = serviceProviderDetail.serviceProviderCategoryName + " categories"
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.filteredArray = self.subServiceProviderList
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvSubServiceProvider.register(nib, forCellWithReuseIdentifier: itemCell)
        cvSubServiceProvider.delegate = self
        cvSubServiceProvider.dataSource = self
        viewNoData.isHidden = true
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
    }
    
    @IBAction func onClickLocation(_ sender: Any) {
//        if permission(){
//            let vc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idNearByMeServiceProviderVC")as! NearByMeServiceProviderVC
//           // vc.selecteddata = serviceProviderDetail
//            parentContext.navigationController?.pushViewController(vc, animated: true)
//            dismiss(animated: true, completion: nil)
//        }
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMessageWithClick(title: "Turn on your location setting", msg: StringConstants.KEY_STEP_NEXT)
                    
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    let vc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idNearByMeServiceProviderVC")as! NearByMeServiceProviderVC
                   // vc.selecteddata = serviceProviderDetail
                    self.parentContext.navigationController?.pushViewController(vc, animated: true)
                    self.dismiss(animated: true, completion: nil)
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }
        
        
    }
    @IBAction func btnKeyboardReturnClicked(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filteredArray = textField.text!.isEmpty ? subServiceProviderList : subServiceProviderList.filter({ (item:LocalServiceSubProviderModel) -> Bool in
            
            return item.serviceProviderSubCategoryName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        if filteredArray.count > 0 {
            self.viewNoData.isHidden  = true
        } else {
            self.viewNoData.isHidden  = false
        }
        
        
        cvSubServiceProvider.reloadData()
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {

       
    }
    
   
    override func onClickDone() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
extension ServiceProviderSubCateVC : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = filteredArray[indexPath.row]
        let cell = cvSubServiceProvider.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ServiceProviderNewCell
      //  Utils.setImageFromUrl(imageView: cell.imgServiceProvider, urlString: data.serviceProviderSubCategoryImage, palceHolder: "fincasys_notext")
        
        cell.lblServiceProviderName.text = data.serviceProviderSubCategoryName
        //cell.heightImgView.constant = 140
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = cvSubServiceProvider.bounds.width/2
        return CGSize(width: width - 1, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
//        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "idServiceProviderDetailVC")as! ServiceProviderDetailVC
//        nextvc.headingText = data.serviceProviderSubCategoryName
       // nextvc.subProviderDetail = data
       // nextvc.serviceProviderDetail = self.serviceProviderDetail
        //            nextvc.serviceProviderDetail = filteredArray[indexPath.row]
        
        if  StringConstants.KEY_IS_OLD_SERVICE_UI {
            // this old ui
            let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailOldVC")as! ServiceProviderDetailOldVC
            nextvc.headingText = data.serviceProviderSubCategoryName
            nextvc.subProviderDetail = data
            nextvc.serviceProviderDetail = self.serviceProviderDetail
            
            self.dismiss(animated: true) {
                self.parentContext.navigationController?.pushViewController(nextvc, animated: true)
            }
        } else {
            let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailVC")as! ServiceProviderDetailVC
            nextvc.headingText = data.serviceProviderSubCategoryName
            //nextvc.serviceProviderDetail = filteredArray[indexPath.row]
            
            self.dismiss(animated: true) {
                self.parentContext.navigationController?.pushViewController(nextvc, animated: true)
            }
        }
      
        
        
        
       
    }
}
