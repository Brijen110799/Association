//
//  DocumentsVC.swift
//  Finca
//
//  Created by harsh panchal on 25/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DocumentsVC: BaseVC {
    
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
    var youtubeVideoID = ""
    let itemCell = "DocumentsCell"
    var Document_List = [document_type_list]()
    var document_id = ""
    var filterDocumentList = [document_type_list]()
    var menuTitle = ""
    var menuIcon = ""
    @IBOutlet weak var ViewNoData: UIView!

    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        self.doneButtonOnKeyboard(textField: tfSearch)
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        documentInteractionController.delegate = self
        addRefreshControlTo(collectionView: cvData)
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: menuIcon)
        lbTitle.text = menuTitle
        lbNoData.text = doGetValueLanguage(forKey: "no_documents_found")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_document")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
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

        cvData.reloadData()
    }

    override func fetchNewDataOnRefresh() {
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
        refreshControl.beginRefreshing()
        doGetDocumentData()
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }

    @IBAction func btnAddDocument(_ sender: UIButton) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "idUploadDocumentVC")as! UploadDocumentVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)

    }

    func doGetDocumentData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getDocType":"getDocType",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "user_type":doGetLocalDataUser().userType!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.documentController, parameters: params) { (json, error) in
            self.hideProgress()
            print(json as Any)
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(DocumentResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.Document_List = response.list
                        self.filterDocumentList = self.Document_List
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
    
    @IBAction func onClickChat(_ sender: Any) {
        /*   let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
    }

    @objc func doCallDeleteApi(_ sender:UIButton){
        document_id =  self.Document_List[sender.tag].documentTypeID
        showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "delete_document"), style: .Delete,cancelText: doGetValueLanguage(forKey: "cancel"),okText : doGetValueLanguage(forKey: "delete"))
    }
    
    func doDelete() {
        self.showProgress()
        let params = ["deleteDoc":"deleteDoc",
                      "society_id":self.doGetLocalDataUser().societyID!,
                      "user_id":self.doGetLocalDataUser().userID!,
                      "document_id":document_id]
        
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.documentController, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                    }else{
                        self.showAlertMessage(title: "", msg: response.message)
                    }
                }catch{
                }
            }
        }
    }
    
}
extension DocumentsVC: AppDialogDelegate{

    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                self.doDelete()
            }
        }
    }

}

extension DocumentsVC: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }

}
extension URL {
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
}

extension  DocumentsVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! DocumentsCell
        cell.lblDocumentName.text = filterDocumentList[indexPath.row].documentTypeName
        Utils.setImageFromUrl(imageView: cell.ivPlaceHolder, urlString: filterDocumentList[indexPath.row].documentIcon)
//        if  filterDocumentList[indexPath.row].documentIcon.contains(".pdf") {
//            cell.ivPlaceHolder.image = UIImage(named: "pdf")
//        } else  if  filterDocumentList[indexPath.row].documentIcon.contains(".doc") || filterDocumentList[indexPath.row].documentIcon.contains(".docx") {
//            cell.ivPlaceHolder.image = UIImage(named: "doc")
//        } else  if  filterDocumentList[indexPath.row].documentIcon.contains(".ppt") || filterDocumentList[indexPath.row].documentIcon.contains(".pptx") {
//            cell.ivPlaceHolder.image = UIImage(named: "doc")
//        } else  if  filterDocumentList[indexPath.row].documentIcon.contains(".jpg") || filterDocumentList[indexPath.row].documentIcon.contains(".jpeg") {
//            cell.ivPlaceHolder.image = UIImage(named: "jpg-2")
//        } else  if  filterDocumentList[indexPath.row].documentIcon.contains(".png")  {
//            cell.ivPlaceHolder.image = UIImage(named: "png")
//        } else  if  filterDocumentList[indexPath.row].documentIcon.contains(".zip")  {
//            cell.ivPlaceHolder.image = UIImage(named: "zip")
//        } else {
//            cell.ivPlaceHolder.image = UIImage(named: "office-material")
//        }
        
        if filterDocumentList[indexPath.row].documentTypeID == doGetLocalDataUser().userID!{
            cell.viewDeleteButton.isHidden = false
            cell.btnDeleteClicked.tag = indexPath.row
            cell.btnDeleteClicked.addTarget(self, action: #selector(doCallDeleteApi(_:)), for: .touchUpInside)
            
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
        
       
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idDocumentListVC") as! DocumentListVC
        vc.documentid = filterDocumentList[indexPath.row].documentTypeID
        //vc.filterDocumentList = filterDocumentList
        vc.NameTitle = filterDocumentList[indexPath.row].documentTypeName
        vc.menuIcon = menuIcon
        self.navigationController?.pushViewController(vc, animated: true)
//        DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
//                self.doReadDocumentRead(document_id: self.filterDocumentList[indexPath.row].documentID ?? "")
//            }
        //}
        
//        guard let url = URL(string: filterDocumentList[indexPath.row].documentFile) else { return }
//        UIApplication.shared.open(url)
//
        
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

