//
//  UserActivityViewVC.swift
//  Finca
//
//  Created by harsh panchal on 08/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class UserActivityViewVC: BaseVC{
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblClearActivity: UILabel!
    let itemcell = "UserActivityCell"
    var activityList = [UserActivityModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    @IBOutlet weak var viewFab: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemcell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.estimatedRowHeight = 140
        tbvData.rowHeight = UITableView.automaticDimension
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_activities")
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
        lblClearActivity.text = doGetValueLanguage(forKey: "clear_activities").uppercased()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }

    override func fetchNewDataOnRefresh() {
        self.activityList.removeAll()
        self.doCallApi()
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnClearActivityClicked(_ sender: UIButton) {
       // self.showAppDialog(delegate: self, dialogTitle: "Alert !!", dialogMessage: "Do You Really Want To Clear All Activites ? ", style: .Info)
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "delete_all_activity"), style: .Delete, cancelText: doGetValueLanguage(forKey: "cancel"), okText: doGetValueLanguage(forKey: "delete"))
    }
    func doCallApi(){
        self.showProgress()
        let param = ["getAcitivity":"getAcitivity",
                     "society_id":doGetLocalDataUser().societyID!,
                     "user_id":doGetLocalDataUser().userID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.myActivityController, parameters: param) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(UserActivityResponse.self, from: Data!)
                    if response.status == "200"{
                        self.activityList.append(contentsOf: response.logname)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }

    func doCallClearApi() {
        self.showProgress()
        let param = ["deleteAcitivity":"deleteAcitivity",
                     "society_id":doGetLocalDataUser().societyID!,
                     "user_id":doGetLocalDataUser().userID!]
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.myActivityController, parameters: param) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
}
extension UserActivityViewVC : UITableViewDelegate , UITableViewDataSource{

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.2){
                self.viewFab.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.2){
                self.viewFab.isHidden = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityList.count == 0{
            self.viewNoData.isHidden = false
            self.viewFab.isHidden = true
        }else{
            self.viewNoData.isHidden = true
            self.viewFab.isHidden = false
        }
        return activityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data =  activityList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! UserActivityCell
        if indexPath.row % 2 == 0{
            cell.viewType = .right
            cell.lblRightTimeStamp.text = data.logTime
            cell.lblRightActivityDescription.text = data.logName
            Utils.setImageFromUrl(imageView: cell.imgRightActivityType, urlString: data.logImage, palceHolder: "logo_dark")
        }else{
            cell.viewType = .left
            cell.lblTimeStamp.text = data.logTime
            cell.lblActivityDescription.text = data.logName
            Utils.setImageFromUrl(imageView: cell.imgActivityType, urlString: data.logImage, palceHolder: "logo_dark")
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UserActivityViewVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        self.dismiss(animated: true) {
            self.doCallClearApi()
        }
    }

    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
