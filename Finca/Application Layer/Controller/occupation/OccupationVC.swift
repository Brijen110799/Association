//
//  OccupationVC.swift
//  Finca
//
//  Created by harsh panchal on 13/12/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
class OccupationVC: BaseVC {
    let itemCell = "NewOccuoationCell"
    var youtubeVideoID = ""
    var occupationList = [OccupationModel]()
    var filterList = [OccupationModel](){
        didSet{
            cvData.reloadData()
        }
    }
    var pickerHidden = true
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    var professionCategoryList = [ProfessionCategory]()
    var categoryFilterList = [ProfessionCategory]()
    var subCateList = [ProfessionType]()
    @IBOutlet weak var btnBusinessType: UIButton!
    var selectedIndexCate = 0
    var selectedIndexType = 0
    @IBOutlet weak var btnBusinessCate: UIButton!
    @IBOutlet weak var lblProfessionCategory: UILabel!
    @IBOutlet weak var lblProfessionType: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tfSearchBar: UITextField!
    @IBOutlet weak var btnProfessionCategory: UIButton!
    @IBOutlet weak var btnProfessionType: UIButton!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbTitle : UILabel!
    @IBOutlet weak var lbNoData : UILabel!
    @IBOutlet weak var bRemoveFilter: UIButton!
    @IBOutlet weak var lbProfessionCategory: UILabel!
    @IBOutlet weak var lbProfessionType: UILabel!
  
    
    var menuTitle   =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnProfessionType.isEnabled = false
        btnBusinessType.isEnabled = false
        doInintialRevelController(bMenu: bMenu)
        tfSearchBar.addTarget(self, action: #selector(dofilter(_:)), for: .editingChanged)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
       
        
//        let nib = UINib(nibName: itemCell, bundle: nil)
//        tbvData.register(nib, forCellReuseIdentifier: itemCell)
//        tbvData.delegate = self
//        tbvData.dataSource = self
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.dataSource = self
        cvData.delegate = self
        
        tfSearchBar.placeholder = doGetValueLanguage(forKey: "search")
        lbTitle.text = menuTitle
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        lbProfessionCategory.text = doGetValueLanguage(forKey: "profession_category")
        lbProfessionType.text = doGetValueLanguage(forKey: "profession_type")
        bRemoveFilter.setTitle(doGetValueLanguage(forKey: "remove_filter"), for: .normal)
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    @IBAction func doneButtonClicked(_ sender: UITextField, forEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @objc func dofilter(_ sender:UITextField!){
        filterList = sender.text!.isEmpty ? occupationList : occupationList.filter({ (item:OccupationModel) -> Bool in
            
        return (item.businessCategories.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil) || (item.userFullName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil) || item.companyName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.searchKeyword.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil  || item.companyContactNumber.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.businessCategoriesSub.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.blockName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.unitName.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil  || item.designation.lowercased().range(of: sender.text!, options: .caseInsensitive, range: nil, locale: nil) != nil 
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doCallApi()
    }
    
    @IBAction func btnClearFilter(_ sender: UIButton) {
        self.viewFilter.isHidden = true
        self.viewSearchBar.showAnimated(in: stackView)
        self.tfSearchBar.text = ""
        print(occupationList)
        print(filterList)
        self.subCateList = []
        self.filterList = self.occupationList
        lblProfessionCategory.text = ""
        lblProfessionType.text = ""
    }
    
    @IBAction func btnShowFilter(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewSearchBar.isHidden = true
        self.viewFilter.showAnimated(in: stackView)
        self.filterList = self.occupationList
    }
    
    @IBAction func btnSelectProfessionCate(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 1
        vc.OccContext = self
        vc.professionCategoryList = self.professionCategoryList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }
    
    @IBAction func btnSelectBusinessType(_ sender: UIButton) {
        
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSelectProfessionVC") as! SelectProfessionVC
        vc.tag = 2
        vc.OccContext = self
        vc.professionTypeList = self.subCateList
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    
    func doCallFilterApi(matchString:String!){
        self.filterList.removeAll()
        self.cvData.reloadData()
        for item in occupationList{
            if item.businessCategories == matchString || item.businessCategoriesSub == matchString{
                self.filterList.append(item)
                cvData.reloadData()
            }
        }
        if filterList.count != 0{
            viewNoData.isHidden = true
        }else{
            viewNoData.isHidden = false
        }
    }
    
    func doCallApi(){
        self.showProgress()
        let params = ["searchBusiness":"searchBusiness",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "unit_id":doGetLocalDataUser().unitID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.occupationController, parameters: params) { (Data, Err) in
            if Data != nil{
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(OccupationResponse.self, from: Data!)
                    if response.status == "200"{
                        self.occupationList =  response.occupation
                        self.filterList = self.occupationList
                        self.cvData.reloadData()
                        
                    }else{
                        if self.filterList.count != 0{
                            self.viewNoData.isHidden = true
                        }else{
                            self.viewNoData.isHidden = false
                        }
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
        
        let params2 = ["getCatgory": "getCatgory", "society_id":doGetLocalDataUser().societyID ?? ""]
        request.requestPostCommon(serviceName: ServiceNameConstants.bussinessCategoryController, parameters: params2) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                print(Data as Any)
                do{
                    let response = try JSONDecoder().decode(ProfessionCategoryResponse.self, from: Data!)
                    if response.status == "200"{
                     //   self.professionCategoryList.append(ProfessionCategory(categoryId: "-1", subCategory: [ProfessionType(categoryName: "Select Business Type")], categoryIndustry: "All Business"))
                        self.btnBusinessType.isEnabled = true
                        self.professionCategoryList.append(contentsOf: response.category)
                        
                    }else{
                        
                    }
                }catch{
                    print("Parse Error",Err as Any)
                }
            }
        }
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    @IBAction func btnNotification(_ sender: UIButton) {
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
    }

    
    func doInitProfessionTypeArr(tag:Int!,selectedIndexPath : IndexPath!,identifier:String! = ""){
        switch tag {
        case 1:
            self.subCateList.removeAll()
            //self.lblProfessionType.text = "Select"

            for data in professionCategoryList{
                if data.categoryId == identifier{
                    self.subCateList.append(contentsOf: data.subCategory)
                    self.lblProfessionCategory.text = data.categoryIndustry
                    doCallFilterApi(matchString: data.categoryIndustry)
                    btnProfessionType.isEnabled = true
                }
            }
            break;
        case 2:
            for data in subCateList{
                if data.categoryName == identifier{
                    self.lblProfessionType.text = data.categoryName
                    doCallFilterApi(matchString: data.categoryName)
                }
            }
        default:
            break;
        }
    }
}

extension OccupationVC : UITableViewDelegate , UITableViewDataSource,OcupationCellDelegate{
    
    func onClickContactNumber(indexPath: IndexPath) {
        let phone = filterList[indexPath.row].companyContactNumber!
        if let url = URL(string: "tel:\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filterList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! OccupationCell
        
        cell.lblName.text = data.userFullName
        cell.lblFieldName.text = data.businessCategories
        cell.lblCompanyName.text = data.companyName
        cell.lblBusinessCategory.text = data.businessCategories
        cell.lblFieldName.text = data.designation
        cell.lblPhoneNumber.attributedText = NSAttributedString(string:data.companyContactNumber , attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        cell.lblBlockName.text = data.blockName + " - " + data.unitName
        Utils.setImageFromUrl(imageView: cell.imgUser, urlString: data.userProfilePic, palceHolder: "user_default")
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filterList[indexPath.row]
//        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = data.userId
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MemberDetailsVC()
        vc.user_id = data.userId ?? ""
        vc.userName =  ""
        pushVC(vc: vc)
    }
}
extension UIView {
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
}

extension OccupationVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.filterList.count != 0{
            self.viewNoData.isHidden = true
        }else{
            self.viewNoData.isHidden = false
        }
        
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! NewOccuoationCell
          let data = filterList[indexPath.row]
        
        cell.lbUnitName.text = data.blockName + " - " + data.unitName
        
        DispatchQueue.main.async {
            self.setupMarqee(label:cell.lbUnitName)
            cell.lbUnitName.triggerScrollStart()
        }
        cell.lbUserName.text = data.userFullName
        cell.lbCategory.text = data.businessCategories
        cell.lbCompanyName.text = data.companyName
        cell.lbDesigation.text = data.designation
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        
        cell.bDetails.tag = indexPath.row
        cell.bDetails.addTarget(self, action: #selector(onTapDetails(sender:)), for: .touchUpInside)
        cell.bDetails.setTitle(doGetValueLanguage(forKey: "details"), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2
        return CGSize(width: width - 1, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      }
    
    @objc func onTapDetails(sender : UIButton) {
//        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//        vc.user_id = filterList[sender.tag].userId
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idProfessionalDetailBS")as! ProfessionalDetailBS
        vc.user_id = filterList[sender.tag].userId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

