//
//  DailogMemberAndParkingVC.swift
//  Finca
//
//  Created by anjali on 05/09/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DailogMemberAndParkingVC: BaseVC {
    
    @IBOutlet weak var cvData: UICollectionView!
    let cellItem = "MemberChatListCell"
    @IBOutlet weak var lbTitle: UILabel!
    var memberArray =  [MemberDetailModal]()
    var myParking = [MyParkingModal]()
    @IBOutlet weak var heightConCollectionView: NSLayoutConstraint!
    var isMember:Bool!
    let itemCellParking = "MyVehicleNumberCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        cvData.dataSource = self
        cvData.delegate = self
        
        
        
        // Do any additional setup after loading the view.
        if isMember {
            lbTitle.text = "SELECT MEMBER FOR VIEW PROFILE"
            let nib = UINib(nibName: cellItem, bundle: nil)
            cvData.register(nib, forCellWithReuseIdentifier: cellItem)
            
        } else {
            lbTitle.text = "MEMBER PARKING LIST"
            let inb1 = UINib(nibName: itemCellParking, bundle: nil)
            cvData.register(inb1, forCellWithReuseIdentifier: itemCellParking)
            
        }
    }
    
    
    @IBAction func onClickClose(_ sender: Any) {
        removeFromParent()
        view.removeFromSuperview()
    }
    override func viewWillLayoutSubviews() {
        
        if cvData.contentSize.height > 450 {
            heightConCollectionView.constant = 450 + 30
        } else {
            heightConCollectionView.constant = cvData.contentSize.height + 30
        }
    }
    
    override func onClickDone() {
        removeFromParent()
        view.removeFromSuperview()
    }
}

extension DailogMemberAndParkingVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isMember {
            return myParking.count
        }
        return memberArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isMember {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellParking, for: indexPath) as! MyVehicleNumberCell
            
            let splitString = myParking[indexPath.row].vehicleNo.split{$0 == "~"}.map(String.init)
            
            
            cell.lbNumber.text =  splitString[1].uppercased()
            cell.lbParkingSlot.text = splitString[0]
            
            return  cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! MemberChatListCell
        
        cell.lbName.text = memberArray[indexPath.row].userFirstName + " " + memberArray[indexPath.row].userLastName + " " + memberArray[indexPath.row].memberRelationName
        
        Utils.setImageFromUrl(imageView: cell.ivImageProfile, urlString: memberArray[indexPath.row].userProfilePic, palceHolder: "user_default")
        
        cell.viewChatCount.isHidden = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-4, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = memberArray[indexPath.row]
        if isMember {
            if data.tenantView == "1" && doGetLocalDataUser().userType! == "1"{
                showAlertMessage(title: "", msg: "This Account is Private!!")
            }else{
                if data.userStatus == "2"{
                    showAlertMessageWithClick(title: "", msg: "Account Not Active!!")
                }else{
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//                    vc.user_id = userID
//                    self.navigationController?.pushViewController(vc, animated: true)

                    let data = memberArray[indexPath.row]
//                    let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//                    vc.user_id = data.userID!
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    let vc = MemberDetailsVC()
                    vc.user_id = data.userID ?? ""
                    vc.userName =  ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
            }
           
        }
        
    }
    
    
}

