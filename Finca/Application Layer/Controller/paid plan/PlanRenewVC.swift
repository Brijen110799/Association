//
//  PlanRenewVC.swift
//  Zoobiz
//
//  Created by zoobiz mac min on 13/04/21.
//

import UIKit

class PlanRenewVC: BaseVC {
    
    //MARK: IBOutlets & Variable Declaration:
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var viewBtnClose: UIView!
    
    let planRenewCell = "PlanRenewCell"
    var discountMessage = ""
    var specialDiscount = false
    var ratingDialog = false
    var isIapPayment = false
    var isPopupDismiss = false
    var msgTitle = String()
    var packages = [PackageModel]()
    var expire_title_main  = ""
    var expire_title_sub  = ""
    var is_force_dailog = false
   // var registerResponse : RegistrationResponse?
//    var completion: ((_ selectedInd :Int) -> ())?
    var completion: ((_ packageModel: PackageModel?) -> ())?
    
    //MARK: View Cycle Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = expire_title_main
        self.lblDesc.text = expire_title_sub
        
        if specialDiscount {
            self.lblDesc.text = self.discountMessage
        }
        viewBtnClose.isHidden = true
        if !is_force_dailog {
            viewBtnClose.isHidden = false
        }
        let nib = UINib(nibName: planRenewCell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: planRenewCell)
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceVertical = true
        
        if self.packages.count > 0 {
            self.cvData.reloadData()
        }
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        self.instanceLocal().setPlanLastShowDate(setdata: dateFormater.string(from: Date()))
        
    }

    
    
    //MARK: Button Actions:
    
    @objc func choosePackage(sender : UIButton) {
        self.completion!(packages[sender.tag])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBtnToDismiss(_ sender: Any) {
        if !is_force_dailog {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK: Other Extensions :

extension PlanRenewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planRenewCell, for: indexPath) as! PlanRenewCell
        cell.lblDiscountedPrice.text = ""
        cell.vwDesh.isHidden = true
        cell.btnChoose.setTitle("", for: .normal)
        cell.lbTitleBtn.text = "CHOOSE".uppercased()

        if self.packages.count > indexPath.item {
            let package = self.packages[indexPath.item]
            if let packagePrice = package.package_amount {
                cell.lblPlanPrice.text = "\(localCurrency())\(packagePrice)"
            }
            cell.lblPlanTitle.text = "\(package.package_name ?? "")\n\(package.no_of_months ?? "")"
            cell.btnChoose.tag = indexPath.item
            cell.btnChoose.addTarget(self, action: #selector(choosePackage(sender:)), for: .touchUpInside)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cvWidth = (collectionView.frame.size.width - 22) / 2
        
        if specialDiscount {
            return CGSize(width: cvWidth * 2, height: cvWidth * 1.40)
        }
        
        return CGSize(width: cvWidth, height: cvWidth * 1.38)
    }

}
