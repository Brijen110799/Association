//
//  SeasonalGreetingsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 12/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import SwiftUI

class SeasonalGreetingsVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
  //  var seasonalGreetings = [SeasonalGreeting]()
    let categorycell = "CategoryCell"
    let request = AlamofireSingleTon.sharedInstance
    private var seasonalGreetings = [SeasonalGreeting]()
    private var filterSeasonalGreetings = [SeasonalGreeting]()
    @IBOutlet weak var tfSearch : UITextField!
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lbNoData: UILabel!
    var menuTitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: categorycell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: categorycell)
        cvData.delegate = self
        cvData.dataSource = self
        cvData.alwaysBounceVertical = false
        cvData.keyboardDismissMode  = .interactive
     //   cvData.register(UINib(nibName: "cell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"cell")
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(didChangeText(sender:)), for: .editingChanged)
        doGetSeasonalGreetingData()
        lbNoData.text = doGetValueLanguage(forKey: "no_data")
        lbltitle.text = doGetValueLanguage(forKey: "seasonal_greetings")
    }
    @objc func didChangeText(sender : UITextField) {
        
        filterSeasonalGreetings = sender.text!.isEmpty ? seasonalGreetings : seasonalGreetings.filter({ item in
            return item.title?.lowercased().range(of: sender.text?.lowercased() ?? "") != nil
        })
        
        if filterSeasonalGreetings.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
        cvData.reloadData()
      }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
        
    }
    
    func doGetSeasonalGreetingData() {
        
        
        let params = ["getSeasonalGreetings" : "getSeasonalGreetings",
                      "user_id": doGetLocalDataUser().userID ?? ""]
        
        DispatchQueue.main.async {
            self.showProgress()
        }
        
        request.requestPostCommon(serviceName: NetworkAPI.seasonal_greeting_controller, parameters: params) { (data, error) in

            DispatchQueue.main.async {
                self.hideProgress()
                if data != nil {
                    do {
                        let response = try JSONDecoder().decode(SeasonalGreetingsResponse.self, from: data!)
                        if response.status == "200" {
                            self.viewNoData.isHidden = true
                            if let arrSeasGreets = response.seasonalGreetings {
                                if arrSeasGreets.count > 0 {
                                    self.seasonalGreetings = arrSeasGreets
                                    self.filterSeasonalGreetings = arrSeasGreets
                                    self.cvData.reloadData()
                                }
                            }
                        } else {
                            self.viewNoData.isHidden = false
                            self.showAlertMessage(title: "", msg: response.message ?? "")
                        }
                    }
                    catch {
                        print("parse error", error.localizedDescription)
                    }
                }else if error != nil{
                    self.showNoInternetToast()
                }
            }
        }
    }

    
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
}

extension SeasonalGreetingsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterSeasonalGreetings.count
    }
    
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "cell", for: indexPath) as? SectionHeader {
                if let sectionTitle = self.filterSeasonalGreetings[indexPath.section].title {
                    sectionHeader.sectionHeaderlabel.text = sectionTitle
                }
                return sectionHeader
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imgArr = self.filterSeasonalGreetings[section].image_array {
            return imgArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categorycell, for: indexPath) as! CategoryCell
        cell.lbTitle.text = ""
        if let imgArr = self.filterSeasonalGreetings[indexPath.section].image_array {
            if imgArr.count > indexPath.item {
                let object = imgArr[indexPath.item]
                let iconUrl = object.cover_image ?? ""
               // cell.ivImage.clipsToBounds = true
               // cell.ivImage.cornerRadius = 10.0
                cell.ivImage.contentMode = .scaleToFill
                Utils.setImageFromUrl(imageView: cell.ivImage, urlString: iconUrl, palceHolder: StringConstants.KEY_LOGO_PLACE_HOLDER)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvWidth = (collectionView.frame.size.width) / 3
        return CGSize(width: cvWidth - 1 , height: cvWidth - 1 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let cvWidth = collectionView.frame.size.width - 10
        return CGSize(width: cvWidth, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        if let imgArr = self.filterSeasonalGreetings[indexPath.section].image_array {
            if imgArr.count > indexPath.item {
               let object = imgArr[indexPath.item]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSeasonalGreetingsDetailVC") as! SeasonalGreetingsDetailVC
                vc.selImageArray = object
                self.pushVC(vc: vc)
            }
        }
    }

}


class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionHeaderlabel: UILabel!
}
struct SeasonalGreetingsResponse: Codable {
    let seasonalGreetings: [SeasonalGreeting]?
    let status, message: String?
}
struct SeasonalGreeting: Codable {
    let title : String? //" : "Mahavir Jayanti (25 April 2021)",
    let seasonal_greet_id : String? //" : "7"
    let image_array :[GreetingData]?
}

struct GreetingData: Codable {
    let logo_alignment : String? //" : "Center",
    let show_to_name : Bool? //" : false,
    let from_name_font_color : String? //" : "#1f203c",
    let main_title : String? //" : "Ram Navami (21 May 2021)",
    let page_alignment : String? //" : "Left",
    let show_from_name : Bool? //" : true,
    let title_alignment : String? //" : "",
    let from_name_font_name : String? //" : "montserrat_semi_bold",
    let description_font_name : String? //" : "",
    let background_image : String? //" : "https:\/\/master.3583971618398246_sg.jpg",
    let title_on_image : String? //" : "",
    let to_text_alignment : String? //" : "Start",
    let from_text_alignment : String? //" : "Center",
    let to_name_font_size : String? //" : "",
    let description_alignment : String? //" : "",
    let to_name_font_color : String? //" : "",
    let description_on_image : String? //" : "",
    let seasonal_greet_image_id : String? //" : "27",
    let from_name_font_size : String? //" : "Medium",
    let title_font_name : String? //" : "",
    let description_font_color : String? //" : "",
    let to_name_font_name : String? //" : "",
    let cover_image : String? //" : "https:\/\/mast14985234691618398246_sg.jpg",
    let title_font_color : String? //" : ""
}

