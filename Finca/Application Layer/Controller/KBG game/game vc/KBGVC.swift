//
//  KBGVC.swift
//  Finca
//
//  Created by Hardik on 5/7/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

// MARK: - KBGResponse
struct KBGResponse: Codable {
    let game: [Game]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case game = "game"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Game
struct Game: Codable {
    let kbgGameId: String!
    let societyId: String!
    let categoryName: String!
    let kbgGameName: String!
    let sponsorImage: String!
    let kbgGameSponsorName: String!
    let sponsorUrl: String!
    
    enum CodingKeys: String, CodingKey {
        case kbgGameId = "kbg_game_id"
        case societyId = "society_id"
        case categoryName = "category_name"
        case kbgGameName = "kbg_game_name"
        case sponsorImage = "sponsor_image"
        case kbgGameSponsorName = "kbg_game_sponsor_name"
        case sponsorUrl = "sponsor_url"
    }
}


class KBGVC: BaseVC {
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var viewcarousel: iCarousel!
    @IBOutlet weak var pagerCount: UIPageControl!
    @IBOutlet weak var lblGameList: UILabel!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var lblnodata: UILabel!
    var index = 0
    var kbgList = [Game]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var fistTimeChange = true
    override func viewDidLoad() {
        super.viewDidLoad()
        lblnodata.text = doGetValueLanguage(forKey: "no_game_available")
        vwNoData.isHidden = true
        viewcarousel.delegate = self
        viewcarousel.dataSource = self
        viewcarousel.type = .coverFlow
        viewcarousel.isPagingEnabled = true
        viewcarousel.isScrollEnabled = true
        viewcarousel.stopAtItemBoundary = true
        viewcarousel.bounces = false

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblGameList.text = doGetValueLanguage(forKey: "game_list")
    }

    func doroteta()  {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        //           if fistTimeChange {
        //               fistTimeChange = false
        docallGame()
        //        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //        UIDevice.current.setValue(value, forKey: "orientation")
        //        HousiInfoVC.attemptRotationToDeviceOrientation()
        //        UIView.setAnimationsEnabled(true)
        //        appDel.myOrientation = .landscape
        //        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        // }
        
        
    }

    func docallGame(){
        
        DispatchQueue.main.async {
            self.showProgress()
        }

        let param = ["getKbg":"getKbg",
                     "society_id": doGetLocalDataUser().societyID!,
                     "user_id": doGetLocalDataUser().userID!]
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPostCommon(serviceName:  ServiceNameConstants.kbgController, parameters: param) { (Data, Error) in
            self.hideProgress()
            if Data != nil{
                do{
                    let response =  try JSONDecoder().decode(KBGResponse.self, from: Data!)
                    if response.status == "200"{
                        self.kbgList = response.game
                        self.viewcarousel.reloadData()
                    }else{
                        print("201")
                        self.vwNoData.isHidden = false
                    }
                }catch{
                    print(Error as Any)
                }
            }else{
                print("parse Error")
            }
        }
    }
    
    @objc func pagerClickedOnResult(_ sender : UIButton){
        let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idResultVC")as! ResultVC
        vc.item = kbgList[sender.tag]
        pushVC(vc: vc)
        
    }
    
    @objc func pagerClickedOnPlay(_ sender : UIButton){
        
        let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idGeneralKnowledgeGameVC")as! GeneralKnowledgeGameVC
        vc.item = kbgList[sender.tag]
        pushVC(vc: vc)
        
    }
    
    @objc func pagerClickedOnCard(_ sender : UIButton){
        
        let url1 = kbgList[sender.tag].sponsorUrl

        if url1 != "" {
            guard let url = URL(string: url1!) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override var shouldAutorotate: Bool {
        return true
    }

    
}
extension KBGVC : iCarouselDelegate,iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return kbgList.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewgame = (Bundle.main.loadNibNamed("KgbGamesCell", owner: self, options: nil)![0] as? UIView)! as! KgbGamesCell
        
        viewgame.frame = viewcarousel.frame
      //  viewgame.lblsponsor.text = kbgList[index].kbgGameSponsorName
        let StrSponsor = kbgList[index].kbgGameSponsorName
        if StrSponsor != ""
        {
            viewgame.lblsponsor.text = StrSponsor
            
        }else
        {
            viewgame.VwSponser.isHidden = true
            viewgame.heightConstraint?.constant = 269
        }
        viewgame.lblgamename.text = kbgList[index].kbgGameName
        viewgame.lblcategory.text = kbgList[index].categoryName
        viewgame.lblCategoryTitle.text = doGetValueLanguage(forKey: "category")
        viewgame.lblPlay.text = doGetValueLanguage(forKey: "play")
        viewgame.lblResult.text = doGetValueLanguage(forKey: "result")
        Utils.setImageFromUrl(imageView: viewgame.ivGame, urlString: kbgList[index].sponsorImage)
        print( kbgList[index].sponsorImage!  ," kbgList[index].sponsorImage")

        viewgame.onClickResult.tag = index
        viewgame.onClickResult.addTarget(self, action: #selector(pagerClickedOnResult(_:)), for: .touchUpInside)
        
        viewgame.onClickPlay.tag = index
        viewgame.onClickPlay.addTarget(self, action: #selector(pagerClickedOnPlay(_:)), for: .touchUpInside)
        
        viewgame.onClickGame.tag = index
        viewgame.onClickGame.addTarget(self, action: #selector(pagerClickedOnCard(_:)), for: .touchUpInside)
        if index % 2 != 0{
            viewgame.gradientView.leftEnd = #colorLiteral(red: 0.137254902, green: 0.6901960784, blue: 0.937254902, alpha: 1)
            viewgame.gradientView.rightEnd = #colorLiteral(red: 0.7529411765, green: 0.9098039216, blue: 0.9803921569, alpha: 1)
        }else{
            viewgame.gradientView.leftEnd = #colorLiteral(red: 0.3647058824, green: 0, blue: 0.831372549, alpha: 1)
            viewgame.gradientView.rightEnd = #colorLiteral(red: 0.6117647059, green: 0.2078431373, blue: 0.8509803922, alpha: 1)
        }
        
        pagerCount.currentPage = viewcarousel.currentItemIndex
        pagerCount.numberOfPages = kbgList.count
        return viewgame
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        index = carousel.currentItemIndex+1
    }




}
