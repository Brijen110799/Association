//
//  RecentChatViewVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 29/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecentChatViewVC: BaseVC {
     
    @IBOutlet weak var tbvData: UITableView!
    var dataRecent = [ResponseRecentChat]()
    
    var youtubeVideoID = UserDefaults.standard.string(forKey: StringConstants.CHAT_VIDEO_ID) ?? ""
    private let itemCell = "RecentChatUserCell"
    private var db: Firestore! // forebase database
    private var listener: ListenerRegistration?
    
    
    

   // private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 110
        tbvData.rowHeight = UITableView.automaticDimension
     
       doFetchRecentData()
    }

    
    func doFetchRecentData() {
        dataRecent.removeAll()
        db = Firestore.firestore()
        
       // var ref: DocumentReference? = nil
        listener =   db.collection("Society").document(doGetLocalDataUser().societyID ?? "").collection("Recent").whereField("userChatIds", arrayContains: userChatId()).addSnapshotListener({ [self] (snapShot, error) in
            
            
            if error != nil {
                print("error " , error as Any)
                return
            }
           // let value = snapShot.value
            
            print("renccent cha vc  " , snapShot!.documentChanges)
            
            for item in snapShot!.documentChanges {

                let itemMode = try? item.document.data(as: ResponseRecentChat.self)
              
                
                if item.type == .added {
                    
                    if dataRecent.count > 0 {
                        
                        
                        let contains = self.dataRecent.map(){$0.userChatIds == itemMode?.userChatIds}.contains(true)
                        
                        
                        if !contains{
                            if itemMode?.recentMsgDeletedById == nil {
                                dataRecent.append(itemMode!)
                            } else {
                                if itemMode?.recentMsgDeletedById != userChatId() {
                                    dataRecent.append(itemMode!)
                                }
                            }
                        }
                    } else {
                        if itemMode?.recentMsgDeletedById == nil || itemMode?.recentMsgDeletedById != userChatId() {
                            dataRecent.append(itemMode!)
                        }
                    }



                } else  if item.type == .modified {
                    
                     if dataRecent.count > 0 {
                    
                        
                        for (index, item) in dataRecent.enumerated() {
                            
                            if item.recentMsgDeletedById != nil &&  item.recentMsgDeletedById.count > 2 && item.recentMsgDeletedById == userChatId() {
                                dataRecent.remove(at: index)
                            } else {
                                dataRecent[index] = item
                            }
                            
                        }
                        
                     } else {
                        if itemMode?.recentMsgDeletedById == nil || itemMode?.recentMsgDeletedById != userChatId() {
                            dataRecent.append(itemMode!)
                        }
                     }
                    
                }  else  if item.type == .removed {
                    for (index, item) in dataRecent.enumerated() {
                        
                        if item.recentId  == itemMode?.recentId {
                            dataRecent.remove(at: index)
                        }
                    }
                        
                }
                //dataRecent.append(itemMode!)
            
            }
            
            tbvData.reloadData()
         
            
        })
        
      //  list.remove()
    }


    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func tapAddChat(_ sender: Any) {
        let vc = MainTabStartNewChatVC()
        pushVC(vc: vc)
        
    }
    @IBAction func btnHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMoreMenuClicked(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "", message: "Select From below Options", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "New Group", style: .default, handler: { (UIAlertAction) in
            let nextVC = storyboardConstants.chat.instantiateViewController(withIdentifier: "idAddGroupChatVC")as! AddGroupChatVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func bPlayVideo(_ sender: UIButton) {
       /* if youtubeVideoID != ""{
            let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
            vc.videoId = youtubeVideoID!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            UIUtility.toastMessage(onScreen: "No Video Available!!", from: self)
        }*/
        
        if youtubeVideoID != ""{
            if youtubeVideoID.contains("https"){
                let url = URL(string: youtubeVideoID)!
                
                playVideo(url: url)
               
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil ).instantiateViewController(withIdentifier: "idVideoPlayerVC") as! VideoPlayerVC
                vc.videoId = youtubeVideoID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            toast(message: "No Tutorial Available!!", type: .Warning)
        }
    }
    
}
extension RecentChatViewVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRecent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCell, for: indexPath) as! RecentChatUserCell
        let item = dataRecent[indexPath.row]
        if item.single {
            cell.lbMsg.text = "\(item.recentMsgSenderName ?? "") : \(item.recentMsg ?? "")"
            
            if  item.userDataList[0].userChatId != nil && item.userDataList[0].userChatId == userChatId() {
                cell.lbUserName.text = item.userDataList[1].userName
                cell.lbUnitName.text = item.userDataList[1].userBlockName
                Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.userDataList[1].userProfile, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
            } else {
                cell.lbUserName.text = item.userDataList[0].userName
                cell.lbUnitName.text = item.userDataList[0].userBlockName
                Utils.setImageFromUrl(imageView: cell.ivProfile, urlString: item.userDataList[0].userProfile, palceHolder: StringConstants.KEY_USER_PLACE_HOLDER)
            }
            
            if  item.userDataList[0].userChatId != nil && item.userDataList[0].userChatId == userChatId() {
                
            }
            
        }
       
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = dataRecent[indexPath.row]
        
        var userModel = MemberModelChat()
        
        if  item.userDataList[0].userChatId != nil && item.userDataList[0].userChatId == userChatId() {
            userModel =  item.userDataList[1]
        } else {
            userModel =  item.userDataList[0]
        }
        
        if item.single {
            //indivual chat
            let vc = ChatRoomVC()
            vc.responseRecentChat = item
            vc.userModel = userModel
            vc.sendTo = item.sentTo
            pushVC(vc: vc)
            
        } else{
            //group
            
            
            
            
        }
        
        
        
        
        
    }
    
    
}


struct ResponseRecentChat : Codable  {
    let recentId : String!
    let recentMsg : String!
    let recentGroupName : String!
    let recentGroupProfile : String!
    let recentMsgDate : String!
    let recentMsgSenderId : String!
    let recentMsgSenderName : String!
    let recentMsgDeletedById : String!
    let recentBlockById : String!
    let recentTypeById : String!
    let recentCreatedById : String!
    let sentTo : String!
    let societyId : String!
    let single : Bool!
    let withChat : String!
    let unReadCount : String!
    let mTimestamp : Date!
    let userChatIds : [String]!
    let userSilentSetting : [String]!
    let userDataList : [MemberModelChat]!
    let typeData : [TypeData]!
    let unReadData : [UnReadData]!
   
}

struct TypeData : Codable {
    let userChatId : String!
    let typing : Bool!
}
struct UnReadData : Codable {
    let userChatId : String!
    let countUnread : String!
}










