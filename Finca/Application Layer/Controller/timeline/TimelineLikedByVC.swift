//
//  TimelineLikedByVC.swift
//  Finca
//
//  Created by harsh panchal on 27/01/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class TimelineLikedByVC: BaseVC {
    var likedByList = [LikeModel]()
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    var itemCell = "TimelineLikeCell"
    var context : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        lbTitle.text = doGetValueLanguage(forKey: "liked_list")
        
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.sheetViewController?.dismiss(animated: true)
    }
}
extension TimelineLikedByVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedByList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = likedByList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! TimelineLikeCell
        cell.lblUsername.text = data.userName + " (\(data.blockName!))"
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfilePic, palceHolder: "user_default")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = likedByList[indexPath.row]
        self.sheetViewController?.dismiss(animated: false, completion: {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//            vc.user_id = data.userId
//            self.context.navigationController?.pushViewController(vc, animated: true)


//            let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//            vc.user_id = data.userId
//            self.context.navigationController?.pushViewController(vc, animated: true)
            
            let vc = MemberDetailsVC()
            vc.user_id = data.userId ?? ""
            vc.userName =  ""
            self.context.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
}
