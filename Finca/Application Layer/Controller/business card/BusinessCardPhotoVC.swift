//
//  BusinessCardPhotoVC.swift
//  Finca
//
//  Created by Hardik on 3/5/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit


class BusinessCardPhotoVC: UIViewController {
   
    var userProfileReponse : MemberDetailResponse!
    var dataVC : BusinessCardDetailsVC!
    var flag : Bool!
    @IBOutlet weak var tbvcards: UITableView!
    let itemcell = "BusinessCardCell"
    var shareFlag = "share"
    var  visitCard = [CardModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        tbvcards.register(nib, forCellReuseIdentifier: itemcell)
        tbvcards.delegate = self
        tbvcards.dataSource = self
        }
}
extension BusinessCardPhotoVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvcards.dequeueReusableCell(withIdentifier: itemcell, for: indexPath)as! BusinessCardCell
        Utils.setImageFromUrl(imageView: cell.ivCard, urlString: visitCard[indexPath.row].card_bg ?? "", palceHolder: StringConstants.KEY_BENNER_PLACE_HOLDER)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataVC.cardflag = Int(visitCard[indexPath.row].card_id ?? "1") ?? 1
        dataVC.flag = true
        dataVC.shareFlag = "share"

        dataVC.tbvCardDetails.reloadData()
        self.sheetViewController?.dismiss(animated: false, completion: nil)
    }
}
