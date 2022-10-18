//
//  DailyNewsVC.swift
//  Finca
//
//  Created by CHPL Group on 11/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class DailyNewsVC: BaseVC {
    
    @IBOutlet weak var viewOfSearch: UIView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var ViewNoData: UIView!
    var youtubeVideoID = ""
    let itemCell = "DocumentsCell"
    var Document_List = [document_type_list]()
    var document_id = ""
    var filterDocumentList = [document_type_list]()
    var menuTitle = ""
    var menu_icon = ""
  
    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
//        if self.revealViewController() != nil {
//            revealViewController().delegate = self
//            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
        
        self.doneButtonOnKeyboard(textField: tfSearch)
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        documentInteractionController.delegate = self
        addRefreshControlTo(collectionView: cvData)
        tfSearch.delegate = self
        Utils.setImageFromUrl(imageView: ivNoData, urlString: menu_icon)
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        lbTitle.text = menuTitle
        lbNoData.text = doGetValueLanguage(forKey: "no_documents_found")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_document")
//        if youtubeVideoID != ""
//        {
//            VwVideo.isHidden = false
//        }else
//        {
//            VwVideo.isHidden = true
//        }
    }

    @objc func textFieldDidChange(textField: UITextField) {
        filterDocumentList = textField.text!.isEmpty ? Document_List : Document_List.filter({ (item:document_type_list) -> Bool in
            return item.documentTypeName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        if filterDocumentList.count == 0 {
            self.ViewNoData.isHidden = false
        } else {
            self.ViewNoData.isHidden = true
        }

        
//        if textField.text == "" {
//            self.ivClose.isHidden = true
//        } else {
//            self.ivClose.isHidden = false
//        }
        
//        if textField.text == "" {
//            self.tfSearch.isHidden = true
//        }else {
//            self.tfSearch.isHidden = false
//        }
        cvData.reloadData()
    }
    
    

    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        view.endEditing(true)
       // viewClear.isHidden  = true
        refreshControl.beginRefreshing()
        doGetDocumentData()
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }

   

    func doGetDocumentData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getDailyNewsType":"getDailyNewsType",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "language_id":doGetLanguageId()]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.dailynewscontroller, parameters: params) { (json, error) in
            self.hideProgress()
            print(json as Any)
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(DocumentResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.Document_List = response.list
                        self.filterDocumentList = self.Document_List
                        if self.filterDocumentList.count == 0 {
                            self.viewOfSearch.isHidden = true
                        }else {
                            self.viewOfSearch.isHidden = false
                        }
                        self.cvData.reloadData()
                        self.viewOfSearch.isHidden = false
                    }else {
                        self.viewOfSearch.isHidden = true
                        self.filterDocumentList = self.Document_List
                        self.filterDocumentList.removeAll()
                        self.cvData.reloadData()
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        self.showProgress()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.hideProgress()
                self.share(url: tmpURL)
            }
        }.resume()
    }
    
    
    @IBAction func onClickNotification(_ sender: Any) {
        goToDashBoard(storyboard: mainStoryboard)
}
}

extension DailyNewsVC: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }

}
extension URL {
    
    var typeIdentifiers: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    var localizedNames: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
}

extension  DailyNewsVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentsCell
        cell.lblDocumentName.text = filterDocumentList[indexPath.row].documentTypeName
        Utils.setImageFromUrl(imageView: cell.ivPlaceHolder, urlString: filterDocumentList[indexPath.row].documentIcon)
        
        
        if filterDocumentList[indexPath.row].documentTypeID == doGetLocalDataUser().userID!{
            cell.viewDeleteButton.isHidden = false
            cell.btnDeleteClicked.tag = indexPath.row
        }else{
            cell.viewDeleteButton.isHidden = true
        }
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filterDocumentList.count == 0 && filterDocumentList.count < 1{
            self.ViewNoData.isHidden = false
        }else{
            self.ViewNoData.isHidden = true
        }
        return filterDocumentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idDailyNewsDetailsVC") as! DailyNewsDetailsVC
        vc.documentid = filterDocumentList[indexPath.row].documentTypeID
        vc.NameTitle = filterDocumentList[indexPath.row].documentTypeName
        vc.menu_icon = menu_icon
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let yourWidth = collectionView.bounds.width / 2
        return CGSize(width: yourWidth - 2, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    private func doReadDocumentRead(document_id : String) {
        
        let params = ["readDoc":"readDoc",
                      "society_id":self.doGetLocalDataUser().societyID!,
                      "user_id":self.doGetLocalDataUser().userID!,
                      "unit_id":self.doGetLocalDataUser().unitID!,
                      "document_id":document_id]
        print("param \(params)")
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.documentController, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        
                    }else{
                       // self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                }
            }
        }
        
    }
    
}

