//
//  DiscussionCommentCell.swift
//  Finca
//
//  Created by harsh panchal on 29/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
protocol DiscussionCommentCellDelegate{
    func onClickViewProfile(at indexPath : IndexPath)
    func ReplyButtonClicked(at indexPath : IndexPath)
    func DeleteButtonClicked(at indexPath : IndexPath)
    func onClickViewimage(at indexPath : IndexPath)
}
extension DiscussionCommentCellDelegate{
    func onClickViewProfile(at indexPath : IndexPath){
        
    }
    func ReplyButtonClicked(at indexPath : IndexPath){

    }
    func DeleteButtonClicked(at indexPath : IndexPath){

    }
    func onClickViewimage(at indexPath : IndexPath){

    }
}
class DiscussionCommentCell: UITableViewCell {

    @IBOutlet weak var btncommentsub: UIButton!
    @IBOutlet weak var heightimgcomment: NSLayoutConstraint!
    @IBOutlet weak var btncomment: UIButton!
    @IBOutlet weak var imgcomment: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblCommentText: UITextView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    let itemCell = "DiscussionSubCommentCell"
    @IBOutlet weak var tbvData: UITableView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCommentReply: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    var indexPath : IndexPath!
    var delegate : DiscussionCommentCellDelegate!
    var commentList = [CommentListModel](){
        didSet{
            self.tbvData.reloadData()
        }
    }
    var context : DiscussionDetailVC!
    @IBOutlet weak var bReply: UIButton!
    @IBOutlet weak var bDeleteMain: UIButton!
    @IBOutlet weak var conLeftsideMainview: NSLayoutConstraint!
    
    @IBOutlet weak var bViewProfileSub: UIButton!
    
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(nib, forCellReuseIdentifier: itemCell)
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.estimatedRowHeight = 100
        // Initialization code
    }

    func subCommentData(commentList : [CommentListModel]) {
        self.commentList.append(contentsOf: commentList)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override func layoutSubviews() {
//        if self.tbvData.contentSize.height != 0.0{
//            tbvData.setNeedsLayout()
//            print("tableview height",self.tbvData.contentSize.height)
//            self.tbvHeight.constant = self.tbvData.contentSize.height
//            tbvData.layoutIfNeeded()
//        }
//    }
    
    @IBAction func onClickViewProfile(_ sender: Any) {
        if delegate != nil {
            self.delegate.onClickViewProfile(at: self.indexPath)
        }
       
    }
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        if delegate != nil {
            self.delegate.DeleteButtonClicked(at: self.indexPath)
        }
       
    }
    
    @IBAction func btnpreviewimage(_ sender: UIButton) {
        if delegate != nil {
            self.delegate.onClickViewimage(at: self.indexPath)
        }
       
    }

    @IBAction func btnReplyClicked(_ sender: UIButton) {
     //   self.delegate.ReplyButtonClicked(at: self.indexPath)
    }
}
extension DiscussionCommentCell :  UITableViewDataSource,UITableViewDelegate,DiscussionCommentCellDelegate{

    func DeleteButtonClicked(at indexPath: IndexPath) {
        context.showAppDialog(delegate: self, dialogTitle: "Alert !!", dialogMessage: "Are You Sure To Delete The Comment??", style: .Delete, tag: indexPath.row)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = commentList[indexPath.row]
        let cell = tbvData.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! DiscussionSubCommentCell
        cell.lblCreatedBy.text = data.createdBy
        cell.lblCommentText.text = data.commentMessaage
       // cell.delegate = self
        cell.indexPath = indexPath
        if data.userId == BaseVC().doGetLocalDataUser().userID!{
            
            cell.viewDelete.isHidden = false
        }else{
            cell.viewDelete.isHidden = true
        }
        Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: data.userProfile, palceHolder: "user_default")
        cell.lblCreatedDate.text = data.commentCreatedDate
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.layoutSubviews()
//    }
}
extension DiscussionCommentCell : AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        if dialogType == .Delete{
            context.dismiss(animated: true) {
                self.context.showProgress()
                let data = self.commentList[tag]
                let params = ["deleteComment":"deleteComment",
                              "society_id":BaseVC().doGetLocalDataUser().societyID!,
                              "user_id":BaseVC().doGetLocalDataUser().userID!,
                              "country_code":BaseVC().doGetLocalDataUser().countryCode!,
                              "comment_id":data.commentId!]
                let request = AlamofireSingleTon.sharedInstance
                request.requestPost(serviceName: ServiceNameConstants.discussionController, parameters: params) { (Data, Err) in
                    if Data != nil{
                        self.context.hideProgress()
                        do{
                            let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                            if response.status == "200"{
                                self.context.fetchNewDataOnRefresh()
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
    }

    func btnCancelClicked() {
        context.dismiss(animated: true, completion: nil)
    }
}
