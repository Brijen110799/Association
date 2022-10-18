//
//  DialogWinnerVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 27/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class DialogWinnerVC: BaseVC {
    let itemCell = "DialogClaimWinnerCell"
      
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var heightConCVData: NSLayoutConstraint!
    var winnerList = [WinnerList]()
    
    var titleGame = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemCell)
        cvData.delegate = self
        cvData.dataSource = self
        // Do any additional setup after loading the view.
        cvData.reloadData()
        lbTitle.text = titleGame
    }
    

    @IBAction func onClickCancel(_ sender: Any) {
        removeFromParent()
        view.removeFromSuperview()
   
    }
    
    override func viewWillLayoutSubviews() {
        
//        if winnerList.count > 3 {
//            heightConCVData.constant = cvData.contentSize.height
//        } else {
//             heightConCVData.constant = 140
//        }
    }
    
}
extension DialogWinnerVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return winnerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! DialogClaimWinnerCell
       let item = winnerList[indexPath.row]
        cell.lbName.text = item.user_name
        Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.user_profile_pic, palceHolder: "user_default")
      
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourwidth = collectionView.frame.width/3
        return CGSize(width: yourwidth - 3 , height:140)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddd didSelectItemAt ")
      
       
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
}
