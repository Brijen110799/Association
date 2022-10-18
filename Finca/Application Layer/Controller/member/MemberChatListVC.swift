//
//  MemberChatListVC.swift
//  Finca
//
//  Created by anjali on 27/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class MemberChatListVC: BaseVC {

    @IBOutlet weak var cvData: UICollectionView!
    let cellItem = "MemberChatListCell"
    @IBOutlet weak var heightConCollectionView: NSLayoutConstraint!
    var memberArray =  [MemberDetailModal]()
    var isConersion:Bool!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceSub: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellItem, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: cellItem)
        cvData.dataSource = self
        cvData.delegate = self
        
        if !isConersion {
            bottomSpace.constant = 0
            bottomSpaceSub.constant = 16
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func viewWillLayoutSubviews() {
        /*if isConersion {
             heightConCollectionView.constant = cvData.contentSize.height + 200
        } else {
             heightConCollectionView.constant = cvData.contentSize.height + 30
        }*/
        
     //   print("heig col",cvData.contentSize.height)
       
        
        if cvData.contentSize.height > 450 {
              heightConCollectionView.constant = 450 + 30
        } else {
            heightConCollectionView.constant = cvData.contentSize.height + 30
        }
        
        
        
    }
    @IBAction func onClickClose(_ sender: Any) {
        removeFromParent()
        view.removeFromSuperview()
    }
    override func onClickDone() {
        removeFromParent()
        view.removeFromSuperview()
    }
}

extension MemberChatListVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem, for: indexPath) as! MemberChatListCell
        
        cell.lbName.text = memberArray[indexPath.row].userFirstName + " " + memberArray[indexPath.row].userLastName + " " + memberArray[indexPath.row].memberRelationName
        
        Utils.setImageFromUrl(imageView: cell.ivImageProfile, urlString: memberArray[indexPath.row].userProfilePic, palceHolder: "user_default")
        
        if isConersion {
            if  memberArray[indexPath.row].memberChat != nil {
                if memberArray[indexPath.row].memberChat != "0" {
                    cell.viewChatCount.isHidden = false
                    cell.lbChatCount.text = memberArray[indexPath.row].memberChat
                    
                } else {
                    cell.viewChatCount.isHidden = true
                }
            }
            
            
        } else {
           cell.viewChatCount.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-4, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if memberArray[indexPath.row].userID != doGetLocalDataUser().userID!{
            
            if memberArray[indexPath.row].userStatus == "2"{
                showAlertMessageWithClick(title: "", msg: "Account Not Active!!")
            }else{
                let vc = storyboardConstants.chat.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                vc.user_id = memberArray[indexPath.row].userID!
                vc.userFullName = memberArray[indexPath.row].userFirstName! + " " + memberArray[indexPath.row].userLastName!
                vc.user_image = memberArray[indexPath.row].userProfilePic!
                vc.public_mobile  =  memberArray[indexPath.row].publicMobile!
                vc.mobileNumber =  memberArray[indexPath.row].userMobile!
                vc.isGateKeeper = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
