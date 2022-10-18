//
//  SubClassifiedVC.swift
//  Finca
//
//  Created by Jay Patel on 19/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class SubClassifiedVC: BaseVC {
    
    var menuTitle : String!
    @IBOutlet weak var ivNoData: UIImageView!
    var classifiedList : ClassifiedCategory!
    var subClassifiedList = [ClassifiedSubCategory]()
    var filterSubClassifiedList = [ClassifiedSubCategory]()
    let itemCell = "ServiceProviderNewCell"
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet var heightOfSearchView: NSLayoutConstraint!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var lblHeading: UILabel!
    @IBOutlet var clvSubClassified: UICollectionView!
    @IBOutlet var lbNoData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tfSearch)
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        lblHeading.text = classifiedList.classifiedCategoryName
        let nib = UINib(nibName: itemCell, bundle: nil)
        clvSubClassified.register(nib, forCellWithReuseIdentifier: itemCell)
        clvSubClassified.delegate  = self
        clvSubClassified.dataSource = self
        addRefreshControlTo(collectionView: clvSubClassified)
        ivClose.isHidden  = true
        heightOfSearchView.constant = 0
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        ivSearch.setImageColor(color: ColorConstant.colorP)
        ivClose.setImageColor(color: ColorConstant.colorP)
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_item")
        lbNoData.text = doGetValueLanguage(forKey: "no_item_found")
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //your code


        filterSubClassifiedList = textField.text!.isEmpty ? subClassifiedList : subClassifiedList.filter({ (item:ClassifiedSubCategory) -> Bool in

            return item.classifiedSubCategoryName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })

        hideView()
        clvSubClassified.reloadData()
        if textField.text == "" {
            self.ivClose.isHidden  = true
        } else {
            self.ivClose.isHidden  = false
        }
        //    hideView()

    }
    func hideView() {
        if filterSubClassifiedList.count == 0{
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
    }
    @IBAction func onClickClearText(_ sender: Any) {
        tfSearch.text = ""
        
        filterSubClassifiedList = subClassifiedList
        clvSubClassified.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        hideView()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        ivClose.isHidden = true

        refreshControl.beginRefreshing()
        subClassifiedList.removeAll()
        clvSubClassified.reloadData()
        doCallGetSubCatDataAPI()
        refreshControl.endRefreshing()
    }
    func doCallGetSubCatDataAPI() {

        showProgress()
        let params = ["getClassifiedSubCategories":"getClassifiedSubCategories",
                      "classified_category_id":classifiedList.classifiedCategoryID!]
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
                        self.heightOfSearchView.constant = 56
                        self.subClassifiedList = response.classifiedSubCategory
                        self.filterSubClassifiedList = self.subClassifiedList
                        self.clvSubClassified.reloadData()
                        self.viewNoData.isHidden = true

                    } else {
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                        self.subClassifiedList.removeAll()
                        self.filterSubClassifiedList.removeAll()
                        self.viewNoData.isHidden = false
                        self.clvSubClassified.reloadData()
                    }

                } catch {
                    print("parse error",error as Any)
                }
            }else{
                print(error as Any)
            }
        })
    }
    @IBAction func btnOnClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension SubClassifiedVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterSubClassifiedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvSubClassified.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ServiceProviderNewCell
        Utils.setImageFromUrl(imageView: cell.imgServiceProvider, urlString: filterSubClassifiedList[indexPath.row].classifiedSubCategoryImage, palceHolder: "fincasys_notext")
        //  cell.heightImgView.constant = 100
        DispatchQueue.main.async {
            cell.viewMain.clipsToBounds = true
            cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
        }
        cell.lblServiceProviderName.text = filterSubClassifiedList[indexPath.row].classifiedSubCategoryName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = clvSubClassified.bounds.width/2
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idAllClassifiedVC")as! AllClassifiedVC
        vc.subClassifiedList = subClassifiedList[indexPath.row]
        vc.classifiedList = classifiedList
        vc.menuTitle = menuTitle

        navigationController?.pushViewController(vc, animated: true)
    }
}
