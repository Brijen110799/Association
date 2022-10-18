//
//  DailyNewsDetailsVC.swift
//  Finca
//
//  Created by CHPL Group on 11/04/22.
//  Copyright © 2022 Silverwing. All rights reserved.
//

import UIKit

class  DailyNewsDetailsVC: BaseVC {
    @IBOutlet weak var viewOfSearch: UIView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    var NameTitle = ""
    var menu_icon = ""
    var documentid = ""
    let itemCell = "DocumentListCell"
    var Document_List = [DocumentModel]()
    var filterDocumentList = [DocumentModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.text = NameTitle
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        filterDocumentList.removeAll()
        self.doneButtonOnKeyboard(textField: tfSearch)
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        lbNoData.text = doGetValueLanguage(forKey: "no_documents_found")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_document")
        addRefreshControlTo(tableView: tbvData)
        Utils.setImageFromUrl(imageView: ivNoData, urlString: menu_icon)
        
    }
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        view.endEditing(true)
        refreshControl.beginRefreshing()
        doGetDocumentSubData()
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    @objc func textFieldDidChange(textField: UITextField) {
        filterDocumentList = textField.text!.isEmpty ? Document_List : Document_List.filter({ (item:DocumentModel) -> Bool in
            return item.ducumentName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        if filterDocumentList.count == 0 {
            self.viewNoData.isHidden = false
        } else {
            self.viewNoData.isHidden = true
        }

        tbvData.reloadData()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func btnadd(_ sender: UIButton) {
//        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "idUploadDocumentVC")as! UploadDocumentVC
//
//        self.navigationController?.pushViewController(nextVC, animated: true)
//    }
    func doGetDocumentSubData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getDailyNews":"getDailyNews",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "document_type_id":documentid,
                      "language_id":"1"]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.dailynewscontroller, parameters: params) { (json, error) in
            self.hideProgress()
            print(json as Any)
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(DocumentResponses.self, from:json!)
                    if response.status == "200" {
                        self.Document_List = response.list
                        self.filterDocumentList = self.Document_List
                        self.tbvData.reloadData()
                        self.viewNoData.isHidden = true
                        self.viewOfSearch.isHidden = false
                    }else {
                        self.viewNoData.isHidden = false
                        self.viewOfSearch.isHidden = true
                        self.filterDocumentList = self.Document_List
                        self.filterDocumentList.removeAll()
                        self.tbvData.reloadData()
                       // self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
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
    
}
extension  DailyNewsDetailsVC :   UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDocumentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! DocumentListCell

              cell.lbDocName.text = filterDocumentList[indexPath.row].ducumentName
              cell.lbDocumentTimeAndDate.text = filterDocumentList[indexPath.row].uploadeDate
              cell.lbDocSubName.text = filterDocumentList[indexPath.row].ducumentDescription
        
        cell.btndelete.isHidden = true
        cell.heightbtndelete.constant = 0
        print(cell.lbDocSubName.maxNumberOfLines)
        print(cell.lbDocSubName.numberOfVisibleLines)
       // cell.heightlblDesc.constant = CGFloat(cell.lbDocSubName.maxNumberOfLines * 23)
        if filterDocumentList[indexPath.row].ducumentDescription == "" {
            cell.lbDocSubName.isHidden = true
        }
        
        
        if filterDocumentList[indexPath.row].type == "1"
        {
            cell.ivDoc.image = UIImage(named: "website1")
        }
        else{
            if  filterDocumentList[indexPath.row].documentFile.contains(".pdf") {
                    cell.ivDoc.image = UIImage(named: "pdf")
                } else  if  filterDocumentList[indexPath.row].documentFile.contains(".doc") || filterDocumentList[indexPath.row].documentFile.contains(".docx") {
                    cell.ivDoc.image = UIImage(named: "doc")
                } else  if  filterDocumentList[indexPath.row].documentFile.contains(".ppt") || filterDocumentList[indexPath.row].documentFile.contains(".pptx") {
                    cell.ivDoc.image = UIImage(named: "ppt")
                }
            else  if  filterDocumentList[indexPath.row].documentFile.contains(".txt") {
                cell.ivDoc.image = UIImage(named: "txt")
            }
            else  if  filterDocumentList[indexPath.row].documentFile.contains(".xls") || filterDocumentList[indexPath.row].documentFile.contains(".xlsx") {
               cell.ivDoc.image = UIImage(named: "xls")
            }
                else  if  filterDocumentList[indexPath.row].documentFile.contains(".jpg") || filterDocumentList[indexPath.row].documentFile.contains(".jpeg") {
                    cell.ivDoc.image = UIImage(named: "jpg-2")
                } else  if  filterDocumentList[indexPath.row].documentFile.contains(".png")  {
                    cell.ivDoc.image = UIImage(named: "png")
                } else  if  filterDocumentList[indexPath.row].documentFile.contains(".zip")  {
                    cell.ivDoc.image = UIImage(named: "zip")
                } else {
                    cell.ivDoc.image = UIImage(named: "office-material")
                }
        }
      

            if filterDocumentList[indexPath.row].userId == doGetLocalDataUser().userID!{
//                cell.viewDeleteButton.isHidden = false
//                cell.btnDeleteClicked.tag = indexPath.row
//                cell.btnDeleteClicked.addTarget(self, action: #selector(doCallDeleteApi(_:)), for: .touchUpInside)

            }else{
//                cell.viewDeleteButton.isHidden = true
            }
//
            return  cell
//        }
//    }
//
//
//
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StrAttachments = filterDocumentList[indexPath.row].documentFile ?? ""
        if StrAttachments.lowercased().contains("jpg") ||  StrAttachments.lowercased().contains("jpeg") ||  StrAttachments.lowercased().contains("png") {
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
            nextVC.imagePath = StrAttachments
            nextVC.isShowDownload = "yes"
            pushVC(vc: nextVC)
        } else {
            let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "NoticcWebvw") as! NoticcWebvw
            vc.strUrl = StrAttachments
            vc.strNoticetitle = filterDocumentList[indexPath.row].ducumentName ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
       }
               
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

extension UILabel {
    var numberOfVisibleLine: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

extension UILabel {
    var maxNumberOfLine: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
