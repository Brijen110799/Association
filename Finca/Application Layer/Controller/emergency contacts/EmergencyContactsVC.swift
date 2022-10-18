//
//  EmergencyContactsVC.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import EzPopup
class EmergencyContactsVC: BaseVC {
    
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tbvEmergencyContacts: UITableView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var tfSearchBar: UITextField!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var conTrallingAddBuuton: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    
    let itemCell = "EmergencyContactCell"
    var menuTitle = ""
    var EmergencyNumberList = [EmergencyNumberModel]()
    var filteredArray = [EmergencyNumberModel]()
    var lastContentOffset: CGFloat = 0
    var deleteIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetEmergencyNumber()
        tfSearchBar.delegate = self
        tfSearchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvEmergencyContacts.register(nib, forCellReuseIdentifier: itemCell)
        tbvEmergencyContacts.delegate = self
        tbvEmergencyContacts.dataSource = self
         Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        addRefreshControlTo(tableView: tbvEmergencyContacts)
        noDataView.clipsToBounds = true
        noDataView.isHidden = true
        ivClose.isHidden = true
        lbTitle.text = menuTitle
        lbNoData.text = doGetValueLanguage(forKey: "no_emergency_number_available")
        tfSearchBar.placeholder = doGetValueLanguage(forKey: "search")
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        //    EmergencyNumberList.removeAll()
        doGetEmergencyNumber()
        refreshControl.endRefreshing()
        tfSearchBar.text = ""
        ivClose.isHidden = true
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(false)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filteredArray = textField.text!.isEmpty ? EmergencyNumberList : EmergencyNumberList.filter({ (item:EmergencyNumberModel) -> Bool in
            
            return item.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        if textField.text == "" {
            self.ivClose.isHidden  = true
        } else {
            self.ivClose.isHidden  = false
        }
        if filteredArray.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
        }
        
        
        tbvEmergencyContacts.reloadData()
    }
    
    @IBAction func onClickClearText(_ sender: Any) {
        tfSearchBar.text = ""
        self.filteredArray = self.EmergencyNumberList
        tbvEmergencyContacts.reloadData()
        view.endEditing(true)
        ivClose.isHidden = true
        self.noDataView.isHidden  = true
    }

    @IBAction func btnAddEmergencyNumberClicked(_ sender: UIButton) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let vc = subStoryboard.instantiateViewController(withIdentifier: "idDialogAddEmergencyContact")as! DialogAddEmergencyContact
        vc.emergencyContactsVC =  self
        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
        popupVC.backgroundAlpha = 0.8
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)
    }

    func doGetEmergencyNumber(){
        print("get emergency contact")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getEmergencyNumber":"getEmergencyNumber",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.emergencyNumberController, parameters: params) { [self] (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(EmergencyResponse.self, from:json!)
                    if response.status == "200" {
                        self.EmergencyNumberList =  response.emergencyNumber
                        self.filteredArray = self.EmergencyNumberList
                        self.tbvEmergencyContacts.reloadData()
                        self.tfSearchBar.text = ""
                        self.view.endEditing(true)
                        self.ivClose.isHidden = true
                        if self.EmergencyNumberList.count > 0 {
                            self.noDataView.isHidden = true
                        } else {
                            self.noDataView.isHidden = false
                        }
                        
                    }else {
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                        self.noDataView.isHidden = false
                        // self.toast(message: response.message, type: .Faliure)
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
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
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
        /*  let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
         self.navigationController?.pushViewController(vc, animated: true)*/
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    func doDelete() {
        self.showProgress()
        let params = ["deleteEmergencyContact":"deleteEmergencyContact",
                      "emergencyContact_id":filteredArray[deleteIndex].emergencyContactId!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(EmergencyResponse.self, from:json!)
                    if response.status == "200" {
                        self.doGetEmergencyNumber()
                    }else {
                        self.noDataView.isHidden = false
                        // self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doRecallData() {
        doGetEmergencyNumber()
    }
}

extension EmergencyContactsVC : UITableViewDelegate,UITableViewDataSource,EmergencyButtonActions{

    func onClickDelete(at indexPath: IndexPath!) {
        deleteIndex   = indexPath.row
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete, tag: indexPath.row,cancelText: doGetValueLanguage(forKey: "cancel").uppercased(),okText: doGetValueLanguage(forKey: "delete").uppercased())

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func CallContact(at indexPath: IndexPath!) {
        let phone_number = filteredArray[indexPath.row].mobile.replacingOccurrences(of: " ", with: "")
        print(phone_number)
        
        
        if let phoneCallURL = URL(string: "telprompt://\(phone_number)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvEmergencyContacts.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as!  EmergencyContactCell
        cell.lblOccupation.text = filteredArray[indexPath.row].designation
        cell.lblPersonName.text = filteredArray[indexPath.row].name
        
        DispatchQueue.main.async {
               cell.viewMain.clipsToBounds = true
               cell.viewMain.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 10)
               }
        
        if filteredArray[indexPath.row].name != nil &&    filteredArray[indexPath.row].name != "" {
            let firstletter = filteredArray[indexPath.row].name[filteredArray[indexPath.row].name.startIndex]
            cell.lblThumbnail.text = firstletter.uppercased()
        } else {
            cell.lblThumbnail.text = ""
        }

        cell.selectionStyle = .none
        cell.actions = self
        cell.indexPath = indexPath
        
        if filteredArray[indexPath.row].userId != "" && filteredArray[indexPath.row].userId == doGetLocalDataUser().userID {
            cell.viewDelete.isHidden = false
        } else {
            cell.viewDelete.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
        //print("scrollViewWillBeginDragging" , scrollView.contentOffset.y)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            // print("move up")
            self.conTrallingAddBuuton.constant = -60
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            //    print("move down")
            self.conTrallingAddBuuton.constant = 16
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            // didn't move
        }

    }
    
}

extension EmergencyContactsVC: AppDialogDelegate{
    
    func btnAgreeClicked(dialogType: DialogStyle, tag:Int) {
        if dialogType == .Delete{
           // let data = self.filteredArray[tag]
            self.dismiss(animated: true) {
                self.doDelete()
            }
        }
    }
    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

