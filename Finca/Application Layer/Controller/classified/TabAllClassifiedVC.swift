//
//  TabAllClassifiedVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 21/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabAllClassifiedVC: BaseVC {
    var MainTabClassifiedVC: MainTabClassifiedVC!
    let itemCell = "ServiceProviderNewCell"
    var classifiedList = [ClassifiedCategory]()
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    var filterClassifiedList = [ClassifiedCategory]()
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var clvAllClassified: UICollectionView!
    @IBOutlet var lbNoDada : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        doneButtonOnKeyboard(textField: tfSearch)
        clvAllClassified.register(nib, forCellWithReuseIdentifier: itemCell)
        clvAllClassified.delegate  = self
        clvAllClassified.dataSource = self
        addRefreshControlTo(collectionView: clvAllClassified)
        ivClose.isHidden  = true
        heightOfSearchView.constant = 0
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        ivSearch.setImageColor(color: ColorConstant.colorP)
        ivClose.setImageColor(color: ColorConstant.colorP)
       Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_category")
        lbNoDada.text  = doGetValueLanguage(forKey: "no_classified_found")
        
        //        doCallGetClassifiedDataApi()
    }
      
    @IBAction func onClickClearText(_ sender: Any) {
        tfSearch.text = ""
        
        filterClassifiedList = classifiedList
        clvAllClassified.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        hideView()
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code
        
        
        filterClassifiedList = textField.text!.isEmpty ? classifiedList : classifiedList.filter({ (item:ClassifiedCategory) -> Bool in
            
            return item.classifiedCategoryName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        hideView()
        clvAllClassified.reloadData()
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
        classifiedList.removeAll()
        clvAllClassified.reloadData()
        doCallGetClassifiedDataApi()
        refreshControl.endRefreshing()
    }
    func hideView() {
        if filterClassifiedList.count == 0{
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
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
                        self.heightOfSearchView.constant = 56
                        //                        print(response)
                        self.classifiedList = response.classifiedCategory
                        self.filterClassifiedList = self.classifiedList
                        self.clvAllClassified.reloadData()
                        self.viewNoData.isHidden = true
                        
                    } else {
                        self.classifiedList.removeAll()
                        self.filterClassifiedList.removeAll()
                        self.viewNoData.isHidden = false
                        self.clvAllClassified.reloadData()
                        self.lbNoDada.text  = self.doGetValueLanguage(forKey: "no_data")
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
extension TabAllClassifiedVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterClassifiedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvAllClassified.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ServiceProviderNewCell
        Utils.setImageFromUrl(imageView: cell.imgServiceProvider, urlString: filterClassifiedList[indexPath.row].classifiedCategoryImage, palceHolder: "fincasys_notext")
       // cell.heightImgView.constant = 100
        DispatchQueue.main.async {
               cell.viewMain.clipsToBounds = true
               cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
               }
        cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
        cell.lblServiceProviderName.text = filterClassifiedList[indexPath.row].classifiedCategoryName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = clvAllClassified.bounds.width/2
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSubClassifiedVC")as! SubClassifiedVC
        vc.menuTitle = menuTitle
        vc.classifiedList = filterClassifiedList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TabAllClassifiedVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: doGetValueLanguage(forKey: "all_classified").uppercased())
        //  Details
    }
}
