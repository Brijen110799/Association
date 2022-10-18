//
//  MyPassesVC.swift
//  bnievents
//
//  Created by harsh panchal on 03/09/19.
//  Copyright © 2019 Guest User. All rights reserved.
//

import UIKit
import WebKit
// MARK: - ProcedureListResponse
struct MyPassResponse: Codable {
    var status: String!
    var passes: [PassModel]!
    var message: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case passes = "passes"
        case message = "message"
    }
}

// MARK: - Pass
struct PassModel: Codable {
    var entryStatus: String!
    var qrCode: String!
    var eventStartDate: String!
    var passType: String!
    var eventId: String!
    var passNo: String!
    var eventTitle: String!
    var passId: String!
    var qrCodeIos: String!
    var event_image:String!

    enum CodingKeys: String, CodingKey {
        case entryStatus = "entry_status"
        case qrCode = "qr_code"
        case eventStartDate = "event_start_date"
        case passType = "pass_type"
        case eventId = "event_id"
        case passNo = "pass_no"
        case eventTitle = "event_title"
        case passId = "pass_id"
        case qrCodeIos = "qr_code_ios"
        case event_image = "event_image"
    }
}

class MyPassesVC: BaseVC {
    
    @IBOutlet weak var tbvMyPasses: UITableView!
    var passList = [PassModel]()
    let itemCell = "MyPassCell"
    var eventDetails : MyEvent!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(rawValue:StringConstants.UPDATE_PASS_LIST), object: nil)
        addRefreshControlTo(tableView: tbvMyPasses)
        //        doCallWebService()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvMyPasses.register(nib, forCellReuseIdentifier: itemCell)
        tbvMyPasses.delegate = self
        tbvMyPasses.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNewDataOnRefresh()
    }
    @objc func refreshData(){
        fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        passList.removeAll()
        tbvMyPasses.reloadData()
        doCallWebService()
        refreshControl.endRefreshing()
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    func doCallWebService(){
        let params = ["getPassesDayWise":"getPassesDayWise",
                      "society_id":doGetLocalDataUser().societyID!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "event_id":eventDetails.eventId!,
                      "event_attend_id":eventDetails.eventAttendId!]
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            if json != nil{
                print("#json \(json as Any)")
                do{
                    
                    let response = try JSONDecoder().decode(MyPassResponse.self, from: json!)
                    if response.status == "200"{
                        self.passList.append(contentsOf: response.passes)
                        self.tbvMyPasses.reloadData()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
extension MyPassesVC : UITableViewDelegate,UITableViewDataSource,EntryPassDelegate{
    func btnSharePassClicked(at indexPath: IndexPath) {
        let image = self.tbvMyPasses.snapshotRows(at: [indexPath])
        let shareAll = [ image as Any ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvMyPasses.dequeueReusableCell(withIdentifier: itemCell, for: indexPath )as! MyPassCell
        cell.lblTicketnumber.text = passList[indexPath.row].passNo
        cell.lblDate.text = passList[indexPath.row].eventStartDate
       // cell.lblpassType.text = passList[indexPath.row].passType.uppercased()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        Utils.setImageFromUrl(imageView: cell.imgQRImage, urlString: passList[indexPath.row].qrCodeIos)
        Utils.setImageFromUrl(imageView: cell.imgEvent, urlString: passList[indexPath.row].event_image)
        cell.imgEvent.roundCorners(corners: [.topLeft, .topRight], radius: 14)
        
        cell.viewTopView.roundCorners(corners: [.topLeft, .topRight], radius: 14)
   
        if passList[indexPath.row].entryStatus == "1"{
            cell.imgVerifiedQR.isHidden = false
        }else{
            cell.imgVerifiedQR.isHidden = true
        }
        cell.lblEventName.text = passList[indexPath.row].eventTitle
        cell.lblMemberpass.text = passList[indexPath.row].passType
        cell.lbltitleDate.text = doGetValueLanguage(forKey: "dates")
        cell.lbltitleTicketnumber.text = doGetValueLanguage(forKey: "pass_number")
        //cell.addGradient(viewMain: cell.viewTop, color: [UIColor(named: "ColorPrimary")!.cgColor,#colorLiteral(red: 0.7268739343, green: 0.433236897, blue: 0.8259053826, alpha: 1).cgColor])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 414
    }

}
extension UITableView
{
    func snapshotRows(at indexPaths: Set<IndexPath>) -> UIImage?
    {
        guard !indexPaths.isEmpty else { return nil }
        var rect = self.rectForRow(at: indexPaths.first!)
        for indexPath in indexPaths
        {
            let cellRect = self.rectForRow(at: indexPath)
            rect = rect.union(cellRect)
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexPath in indexPaths
        {
            let cell = self.cellForRow(at: indexPath)
            cell?.layer.bounds.origin.y = self.rectForRow(at: indexPath).origin.y - rect.minY
            cell?.layer.render(in: context)
            cell?.layer.bounds.origin.y = 0
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
class CustomImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 14)
    }
}
extension UIView {
   func roundCornersView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
