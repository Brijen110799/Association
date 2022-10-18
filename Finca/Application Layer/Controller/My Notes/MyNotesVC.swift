//
//  MyNotesVC.swift
//  Finca
//
//  Created by Silverwing_macmini4 on 21/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
struct GetNotesModelList : Codable {
    let user_id : String! // "333",
    let note_title : String! // "Hb",
    let note_id : String! // "2",
    let note_description : String! // "gH",
    let share_with_admin : Bool! //min" : false,
    let created_date : String! // "21 Dec 2020",
    let society_id : String! // "203"
    let admin_id  : String!
}
struct GetNotesResponse : Codable {
    var message: String!
    var status: String!
    var notes: [GetNotesModelList]!
}

class MyNotesVC: BaseVC {

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tbvNotes: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var notesArr = [GetNotesModelList]()
    let itemCell = "NotesCell"
    var editContext : Bool!
    var AddMyNotes : GetNotesModelList!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvNotes.register(nib, forCellReuseIdentifier: itemCell)
        tbvNotes.delegate = self
        tbvNotes.dataSource = self
        tbvNotes.estimatedRowHeight = UITableView.automaticDimension
        tbvNotes.rowHeight = UITableView.automaticDimension
        lblScreenTitle.text = doGetValueLanguage(forKey: "my_notes")
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_data")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchNewDataOnRefresh()
    }
    override func fetchNewDataOnRefresh() {
        self.notesArr.removeAll()
        doCallGetApi()
    }
    @IBAction func btnBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func btnAddNote(_ sender: Any) {
        btnAdd.addTarget(self, action: #selector(self.animateDown(sender:)), for: [.touchDown, .touchDragEnter])
        btnAdd.addTarget(self, action: #selector(self.animateUp(sender:)), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        let vc = AddMyNotesVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
}
    @objc func animateDown(sender: UIButton) {
       animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
   }
    @objc func animateUp(sender: UIButton) {
       animate(sender, transform: .identity)
   }

     func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    func doCallGetApi(){
        self.showProgress()
        let params = ["getNotes":"getNotes",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "language_id":doGetLanguageId()]
        print(params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.user_notes_controller, parameters: params) { (json, Err) in
      
            if json.self != nil{
                print(json as Any)
                self.hideProgress()
               do{
                    let response = try JSONDecoder().decode(GetNotesResponse.self, from: json!)
                    if response.status == "200"{
                        self.notesArr = response.notes
                        self.tbvNotes.reloadData()
                        self.viewNoData.isHidden = true
                        print("sucess")
                    }else{
                        self.viewNoData.isHidden = false
                        self.notesArr.removeAll()
                        self.tbvNotes.reloadData()
                    }
                }
                catch{
                    print("parse error",error as Any)
                }
            }
        }
        
    }
    
    func doCallDeleteApi(params : [String : String]) {
        self.showProgress()
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.user_notes_controller, parameters: params) { (Data, Err) in
            if Data != nil{
                self.hideProgress()
                do{
                    let response = try JSONDecoder().decode(GetNotesResponse.self, from: Data!)
                    if response.status == "200"{
                        self.fetchNewDataOnRefresh()
                        self.toast(message: response.message, type: .Success)
                    }else{
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("parse error",error as Any)
                }
            }
        }
    }
    
}
extension MyNotesVC : UITableViewDelegate,UITableViewDataSource,NotesListCellDelegate{
    func DeleteButtonClicked(at indexPath: IndexPath) {
        self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "sure_to_delete"), style: .Delete, tag: indexPath.row , cancelText: doGetValueLanguage(forKey: "no"), okText: doGetValueLanguage(forKey: "yes"))
       // self.showAppDialog(delegate: self, dialogTitle: "Alert !!", dialogMessage: "Are you sure you want to delete?", style: .Delete, tag: indexPath.row)

    }
    func EditButtonClicked(at indexPath: IndexPath) {
        let data = notesArr[indexPath.row]
        let vc = AddMyNotesVC()
        vc.strTitle = data.note_title
        vc.strDescription = data.note_description
        vc.dialogType = .Update
        vc.notesData = data
        //vc.switchAdmin = data.share_withad
        vc.editContext = self
        pushVC(vc: vc)
    }
    func shareButtonClicked(at indexPath: IndexPath){
        let data = notesArr[indexPath.row]
        let shareText = "Title:\n \(String(describing: data.note_title!)) \n\nDescription: \n \(String(describing: data.note_description!).uppercased())"
        
        let shareAll = [ shareText ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: {})
        
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = notesArr[indexPath.row]
        let cell = tbvNotes
            .dequeueReusableCell(withIdentifier: "NotesCell")as! NotesCell
        cell.lbTitle.text = data.note_title
        cell.lbDescription.text = data.note_description
        cell.lbNoteDate.text = data.created_date
        cell.selectionStyle = .none
        cell.indexpath = indexPath
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = notesArr[indexPath.row]
        let vc = MyNotesDetailsVC()
        vc.strTitle =  data.note_title
        vc.strDescription = data.note_description
        vc.strNotesDate = data.created_date
        vc.shareFlag = data.share_with_admin
        if data.admin_id ?? "" != "0" {
            vc.isAdminAdd = true
        }
        
       // vc.isAdminAdd
        pushVC(vc: vc)
       
    }
    
}
extension MyNotesVC : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            self.dismiss(animated: true) {
                let data = self.notesArr[tag]
                let params = ["deleteNote":"deleteNote",
                              "note_id":data.note_id!,
                              "user_id":self.doGetLocalDataUser().userID!,
                              "language_id":self.doGetLanguageId()]
                self.doCallDeleteApi(params: params)

            }
        }
    }

    func btnCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIButton {
 
}
