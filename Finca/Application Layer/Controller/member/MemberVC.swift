//
//  MemberVC.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//
import UIKit
import CenteredCollectionView
import AVKit
import AVFoundation
struct ResponseMember : Codable {
    
    var population:String! // "population" : 1,
    var message:String!  //"message" : "Get Member success.",
    var status:String! //"status" : "200"
    var block : [BlockModelMember]!
    var member_types : [MmeberTypes]!
    var population_view_new:String!
    var block_view_new:String!
    var population_key_ios_value:String!
    var blocks_key_ios_value:String!
    var hide_user_type:Bool!
    let population_key_name : String!
    let blocks_key_name : String!
    let block_view : String!
    
}
struct MmeberTypes : Codable {
    
    var type_key_name:String!
    var type_key_colour:String!
    var user_types_values_ios:String!
    
}
struct BlockModelMember : Codable {
    var block_status:String! //"block_status" : "0",
    var block_name:String!// "block_name" : "A",
    var block_id:String! //"block_id" : "126",
    var society_id:String!  //"society_id" : "48"
    var isSelect:Bool!  //"society_id" : "48"
    var  floors : [FloorModelMember]!
    var  units : [UnitModelMember]!
    var total_members:String? //"block_id" : "126",?
}
struct FloorModelMember : Codable {
    var floor_name:String! //"floor_name" : "1 Floor",
    var society_id:String! //"society_id" : "48",
    var floor_status:String! //"floor_status" : "0",
    var block_id:String!// "block_id" : "126",
    var floor_id:String!  //"floor_id" : "518"
    var  units : [UnitModelMember]!
    var cellH : CGFloat!
    
}
struct UnitModelMember : Codable {
    var user_unit_id:String! //"user_unit_id" : null,
    var user_mobile:String! //"user_mobile" : null,
    var user_email:String! //"user_email" : null,
    var user_type:String! //"user_type" : null,
    var user_floor_id:String! //"user_floor_id" : null,
    var unit_name:String! //"unit_name" : "101",
    var user_last_name:String! //"user_last_name" : null,
    var user_status:String! //"user_status" : null,
    var user_block_id:String! //"user_block_id" : null,
    var user_id_proof:String! //"user_id_proof" : null,
    var user_full_name:String! //"user_full_name" : null,
    var floor_id:String! //"floor_id" : "518",
    var chat_status:String! //"chat_status" : "0",
    var unit_status:String!  //"unit_status" : "0",
    var unit_type:String!  //"unit_type" : null,
    var unit_id:String! //"unit_id" : "2118",
    var user_profile_pic:String! //"user_profile_pic" : ".com\/img\/users\/
    var society_id:String! //"society_id" : null,
    var family_count:String! //"family_count" : "1",
    var user_id:String!//"user_id" : null,
    var user_first_name:String! //"user_first_name" : null
    var member: [MemberDetailModal]!
    var about_business : String! //about_business
    var block_name : String! //about_business
    var myParking:[MyParkingModelMember]!
    var tenant_view: String!
    var public_mobile : String!
    var is_defaulter : String!
    var unit_colour:String!
    var distance:String!
    var radius_distance:String!
    var company_name:String!
    var title:String!
    var sub_title:String!
    var sub_title_icon:String!
    
}
struct MyParkingModelMember : Codable {
    var sociaty_id:String! //"sociaty_id" : null,
    var parking_name:String! // "parking_name" : "C-1",
    var unit_id:String! //"unit_id" : "2119",
    var society_parking_id:String!  //"society_parking_id" : "49",
    var vehicle_no:String! // "vehicle_no" : "Ground1-C-1 - gj 01 hu 420",
    var parking_id:String! // "parking_id" : "1645",
    var block_id:String! // "block_id" : "126",
    var parking_type:String!// "parking_type" : "0",
    var floor_id:String!  //"floor_id" : "518",
    var parking_status:String! //"parking_status" : "1"
    
}
class MemberVC: BaseVC {
    var youtubeVideoID = ""
    @IBOutlet weak var bVideo:UIButton!
    @IBOutlet weak var VwVideo: UIView!
    @IBOutlet weak var HeightVwHideshow: NSLayoutConstraint!
    @IBOutlet weak var VwMemberStatus:UIView!
    @IBOutlet weak var viewSelectorSlot: UIView!
    @IBOutlet weak var cvBlock: UICollectionView!
    @IBOutlet weak var cvUnits: UICollectionView!
    @IBOutlet weak var cvMemberType: UICollectionView!
    @IBOutlet weak var lbBlock: UILabel!
    @IBOutlet weak var lbPopulation: UILabel!
    @IBOutlet weak var bMenu: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    let itemCell = "BlockMemberCell"
    let itemCellFloor = "FloorSelectionCell"
    let itemCellMemberType = "MemberTypeCell"
    
    var blocks = [BlockModelMember]()
    var  floors = [FloorModelMember]()
    var  MemberTypes = [MmeberTypes]()
    var isFirstTimeload = true
   
    @IBOutlet weak var VwHideShow:UIView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    var isFirstTimeLoad = true
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var menuTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cvBlock.reloadData()
        }
        self.cvMemberType.isHidden = true
        self.VwHideShow.isHidden = true
        self.HeightVwHideshow.constant = 0
        
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        //********//
      //  viewSelectorSlot.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.2235294118, blue: 0.4549019608, alpha: 1)
       // viewSelectorSlot.layer.borderWidth = 2
        centeredCollectionViewFlowLayout = (cvBlock.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        // let yourWidth = cvBlock.bounds.width  / 2
        
        //        return CGSize(width: yourWidth-4, height: 100)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: 60,
            height: 60
        )
    
        cvBlock.showsVerticalScrollIndicator = false
        cvBlock.showsHorizontalScrollIndicator = false
        // Modify the collectionView's decelerationRate (REQUIRED STEP)
        cvBlock.decelerationRate = UIScrollView.DecelerationRate.fast
        // Do any additional setup after loading the view.
        cvBlock.delegate = self
        cvBlock.dataSource = self
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvBlock.register(inb, forCellWithReuseIdentifier: itemCell)
        
        cvUnits.delegate = self
        cvUnits.dataSource = self
        let inbFloor = UINib(nibName: itemCellFloor, bundle: nil)
        cvUnits.register(inbFloor, forCellWithReuseIdentifier: itemCellFloor)
        
        let inbMember = UINib(nibName: itemCellMemberType, bundle: nil)
        cvMemberType.register(inbMember, forCellWithReuseIdentifier: itemCellMemberType)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clickFloor(_:)),
                                               name: NSNotification.Name(rawValue: "clickFloor"),
                                               object: nil)

        doInintialRevelController(bMenu: bMenu)
        
        addRefreshControlTo(collectionView: cvUnits)

        if UserDefaults.standard.data(forKey: StringConstants.KEY_MEMBER_DATA) != nil {
            
            //  print("testet" , doGetLocalMemberData())
            self.loadViewMember(response: self.doGetLocalMemberData())
            doGetSocietes(isFirstTime: false)
        } else {
            doGetSocietes(isFirstTime: true)
        }
        lbTitle.text = menuTitle
        self.cvMemberType.isHidden = true
        self.VwHideShow.isHidden = true
        self.HeightVwHideshow.constant = 0
    }
    override func pullToRefreshData(_ sender: Any) {
        self.blocks.removeAll()
        self.floors.removeAll()
        cvUnits.reloadData()
        cvBlock.reloadData()
        hidePull()
        doGetSocietes(isFirstTime: true)
    }
    override func setupMarqee(label : MarqueeLabel) {
       
            label.type = .continuous
            label.animationCurve = .easeIn
            label.speed = .duration(15)
            label.fadeLength = 10.0
            label.leadingBuffer = 0
            label.trailingBuffer = 0
            label.restartLabel()
      
    }
    @IBAction func btnSearchMemberClicked(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSearchMemberVC")as! SearchMemberVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction func btnHomeClicked(_ sender: UIButton) {
        self.popToHomeController()
    }
    
  
    @IBAction func onClickNotification(_ sender: Any) {
        
        print(youtubeVideoID)
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!

                playVideo(url: url)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            self.toast(message: "No Tutorial Available!!", type: .Warning)
        }
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
        let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        newFrontViewController.isNavigationBarHidden = true
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @objc func clickFloor(_ notification: NSNotification) {
        
        let data =  notification.userInfo?["data"] as? UnitModelMember
        if data?.unit_status == "2" || data?.unit_status == "1" || data?.unit_status == "3" || data?.unit_status == "5" {
            
            if data?.tenant_view == "1" && doGetLocalDataUser().userType! == "1"{
             
                self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: "This Account is private", style: .Info, tag: 0, cancelText: "", okText: "OKAY")

            
                
            }else{
                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//                vc.user_id = data?.user_id
//                self.navigationController?.pushViewController(vc, animated: true)
//                let data = feedArray[index]
//                let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//                vc.user_id = data?.user_id
//                vc.context = self
//                self.navigationController?.pushViewController(vc, animated: true)
                let vc = MemberDetailsVC()
                vc.user_id = data?.user_id ?? ""
                vc.userName =  ""
                pushVC(vc: vc)
            }
        }
    }
    
    func doCallApiForMemberDetails(selected_residentID:String!){
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getProfileData":"getProfileData",
                      "user_id":selected_residentID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.memberDetailController, parameters: params) { (json, error) in
            
            if json != nil {
                print(json as Any)
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(MemberDetailResponse.self, from:json!)
                    if response.status == "200" {
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
//                        vc.memMainResponse = response
//                        self.navigationController?.pushViewController(vc, animated: true)


//                        let vc = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idCoMemberProfileVC") as! CoMemberProfileVC
//                        vc.user_id = selected_residentID
//                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        let vc = MemberDetailsVC()
                        vc.user_id = selected_residentID
                        vc.userName =  ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func selectItem(index:Int) {
        
        print("selectItem", index)
        
        //blocks
        print(index)
        for i in (0..<blocks.count) {
            
            if i == index {
                blocks[i].isSelect = true
            } else {
                blocks[i].isSelect = false
            }
        }
        cvBlock.reloadData()
        
    }
    
    
    func setDataUtnit(floors:[FloorModelMember]) {
        
        print("dhsdhshdg")
        
        if self.floors.count > 0 {
            self.floors.removeAll()
            cvUnits.reloadData()
        }
        
        self.floors.append(contentsOf: floors)
        cvUnits.reloadData()
        self.cvUnits.performBatchUpdates({
            
        }) { (bool) in
            
            print("load finish" , bool)
            if bool {
                self.cvUnits.reloadData()
            }
            
        }
    }
    
    func doGetSocietes(isFirstTime : Bool) {
        if isFirstTime {
            showProgress()
        }
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMembersNew":"getMembersNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "my_id":doGetLocalDataUser().userID!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName:  NetworkAPI.view_member_list_controller, parameters: params) { (json, error) in
            if isFirstTime {
                self.hideProgress()
            }
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    if response.status == "200" {
                        
                        self.MemberTypes = response.member_types
                        
                        if let encoded = try? JSONEncoder().encode(response) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_MEMBER_DATA)
                        }
                        
                        //   self.societyArray.append(contentsOf: response.society)
                        //  self.cvData.reloadData()
                       
                        self.loadViewMember(response: self.doGetLocalMemberData())
//                        if !response.hide_user_type
//                        {
//                            self.cvMemberType.isHidden = false
//                            self.VwHideShow.isHidden = false
//                            self.HeightVwHideshow.constant = 40
//                        }else
//                        {
//                            self.cvMemberType.isHidden = true
//                            self.VwHideShow.isHidden = true
//                            self.HeightVwHideshow.constant = 0
//                        }
                       // self.cvMemberType.reloadData()
                      
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    func loadViewMember(response:ResponseMember) {
        self.lbBlock.text = ""
         self.lbPopulation.text = ""
        if response.blocks_key_name ?? "" != ""{
            self.lbBlock.text = "\(doGetValueLanguage(forKey: response.blocks_key_name)): \(response.block_view ?? "")"
        }
        if response.population_key_name ?? "" != ""{
            self.lbPopulation.text = "\(doGetValueLanguage(forKey: response.population_key_name)): \(response.population ?? "")"
        }
        self.blocks = response.block
      
        //self.MemberTypes = response.member_types
        
        self.cvBlock.reloadData()
        self.cvMemberType.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cvMemberType.reloadData()
        }
        
        for (index,block) in response.block.enumerated() {
            if block.block_name.lowercased() == doGetLocalDataUser().blockName.lowercased() {
                self.setDataUtnit(floors: block.floors)
                self.selectItem(index: index)
                centeredCollectionViewFlowLayout.scrollToPage(index: index, animated: true)
                break
            }
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func setGradintColor(viewGradint:UIView,color:[CGColor]) {
        //  let context = UIGraphicsGetCurrentContext()
        let colors = color as CFArray
        let endRadius = min(viewGradint.frame.width, viewGradint.frame.height) / 2
        let center = CGPoint(x: viewGradint.bounds.size.width / 2, y: viewGradint.bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    override func viewWillLayoutSubviews() {
        // isFirstTimeLoad = false
        // cvUnits.reloadData()
    }
}
extension MemberVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvUnits {
            return  floors.count
        }
        if collectionView == cvMemberType
        {
            return MemberTypes.count
        }
        return  blocks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvUnits {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellFloor, for: indexPath) as! FloorSelectionCell
            
            cell.lbTitle.text = floors[indexPath.row].floor_name
            //  cell.lbTitle.text = String(indexPath.row)
            cell.doSetDataMember(units: floors[indexPath.row].units, isMember: true)
            
            
            if floors[indexPath.row].cellH == nil {
                floors[indexPath.row].cellH = cell.cvData.contentSize.height + 10
            }
            
            return cell
        }
        
        if collectionView == cvMemberType
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellMemberType, for: indexPath) as! MemberTypeCell
            cell.lbltitle.text = MemberTypes[indexPath.row].user_types_values_ios
            cell.VwColor.backgroundColor = hexStringToUIColor(hex: MemberTypes[indexPath.row].type_key_colour)
            cell.lbltitle.textColor = hexStringToUIColor(hex: MemberTypes[indexPath.row].type_key_colour)
            cell.VwColor.layer.cornerRadius = 7.5
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! BlockMemberCell
        
        if blocks[indexPath.row].block_name.count > 3 {
            let name =  blocks[indexPath.row].block_name
            cell.lbTitle.text = name
            cell.lbFullNeme.text = name
            DispatchQueue.main.async {
                self.setupMarqee(label:cell.lbTitle)
                cell.lbTitle.triggerScrollStart()
            }
            
        } else {
            cell.lbTitle.text = blocks[indexPath.row].block_name
             cell.lbFullNeme.text  = ""
//            DispatchQueue.main.async {
//                self.setupMarqee(label:cell.lbTitle)
//                cell.lbTitle.triggerScrollStart()
//            }
        }
        
        // cell.lbTitle.textColor = UIColor.white
        
        if blocks[indexPath.row].isSelect != nil && blocks[indexPath.row].isSelect {
            // cell.viewTest.backgroundColor = ColorConstant.primaryColor
            //cell.viewTest.backgroundColor = UIColor(named: "ColorPrimary")
            
            //  setGradintColor(viewGradint: cell.viewTest , color: [ColorConstant.startEmpty.cgColor,ColorConstant.endEmpty.cgColor])
            cell.viewTest.isHidden = false
            cell.viewUnselect.isHidden = true
            
            // cell.lbTitle.textColor = UIColor.white
        } else {
            //  setGradintColor(viewGradint: cell.viewTest , color: [ColorConstant.startBlockUnselect.cgColor,ColorConstant.endBlockUnselect.cgColor])
            cell.viewTest.isHidden = true
            cell.viewUnselect.isHidden = false
            
            //  cell.viewTest.backgroundColor = UIColor(named: "gray_20")
            //cell.lbTitle.textColor = ColorConstant.colorGray90
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvUnits {
            
            var height = 0
            if floors.count > 0 {
                let count = floors[indexPath.row].units.count
                if count <= 4 {
                    height = 150
                } else {
                    if count  % 4 == 0 {
                        height = count * 100 / 4 + 65
                    }  else {
                        if count  % 2 == 0 {
                            height = count * 100 / 4 + 90
                        } else {
                            height = count * 100 / 4 + 120
                        }
                    }
                }
            }
            
          //  let cell : FloorSelectionCell = collectionView.cellForItem(at: indexPath) as! FloorSelectionCell
        //    print("deepak " ,cell.cvData.contentSize.height )
            
            let yourWidth = collectionView.bounds.width
            return CGSize(width: yourWidth-4, height: CGFloat(height))
        }
        if collectionView == cvMemberType
        {
            return CGSize(width: 100, height:40)
        }
        
        if collectionView == cvBlock {
//            let label = UILabel(frame: CGRect.zero)
//            label.text = blocks[indexPath.row].block_name
//            label.sizeToFit()
//
//            if label.text?.count ?? 3 > 3 {
//                return CGSize(width: label.frame.size.width + 80, height: 80)
//            } else {
//                return CGSize(width: 60, height: 80)
//            }

            return CGSize(width: 180, height:80)
        }
        
        return CGSize(width: 160, height:80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvBlock {
         
            let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
            if currentCenteredPage != indexPath.row {
                // trigger a scrollToPage(index: animated:)
                DispatchQueue.main.async {
                    self.centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
                }
                
            }
            self.setDataUtnit(floors: blocks[indexPath.row].floors)
            selectItem(index: indexPath.row)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ///       print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        //        print(centeredCollectionViewFlowLayout.currentCenteredPage!)
        if centeredCollectionViewFlowLayout.currentCenteredPage == nil {
            return
        }
        if blocks.count > 0 {
            self.setDataUtnit(floors: blocks[centeredCollectionViewFlowLayout.currentCenteredPage!].floors)
            
            self.selectItem(index: centeredCollectionViewFlowLayout.currentCenteredPage!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if isFirstTimeLoad  {
            self.viewWillLayoutSubviews()
            
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if centeredCollectionViewFlowLayout.currentCenteredPage == nil {
            return
        }
        
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        // print(centeredCollectionViewFlowLayout.currentCenteredPage!)
        self.selectItem(index: centeredCollectionViewFlowLayout.currentCenteredPage!)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}
extension MemberVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }else if dialogType == .Cancel{
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }else if dialogType == .Delete{
            self.dismiss(animated: true) {
                //              self.filteruserClassifiedList[self.selectedIndex]
                //                self.doCallDeleteApi(propertyDetail: selectedIndex)
                //self.doDelete(index: Int(self.userClassifiedList[self.selectedIndex].classifiedMasterID)!)
            }
        }
    }
}
