//
//  SubmitAndExitPopUPVC.swift
//  Finca
//
//  Created by Hardik on 5/9/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import EzPopup
class SubmitAndExitPopUPVC: BaseVC {
    var flag = ""
    var questionData : Question!
    var pointswon : String = ""
    var currentDate = UIDatePicker()
    var context : GeneralKnowledgeGameVC!
    var item : Game!
    var gameflag = false
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == doGetValueLanguage(forKey: "time_over"){
            print("timeover dialog")
            lbltitle.text = doGetValueLanguage(forKey: "time_over")
            lblMessage.text = doGetValueLanguage(forKey: "submit_your_score_and_exit_game")
        }
        if flag == doGetValueLanguage(forKey: "oops_your_answer_is_wrong"){
            print("wrong dialog")
            lbltitle.text = doGetValueLanguage(forKey: "oops_your_answer_is_wrong")
            lblMessage.text = doGetValueLanguage(forKey: "submit_your_score_and_exit_game")
        }
        if flag == doGetValueLanguage(forKey: "winner"){
            print("winner dialog")
            lbltitle.text = doGetValueLanguage(forKey: "winner")
            lblMessage.text = doGetValueLanguage(forKey: "you_gave_all_answers_correctly")
        }

        if flag == doGetValueLanguage(forKey: "exit_the_game"){
            print("exit in middle of game")
            lbltitle.text = doGetValueLanguage(forKey: "quit_game")
            lblMessage.text = doGetValueLanguage(forKey: "submit_your_score_and_exit_game")
        }

        self.doSubmitData { (flag) in
            if flag != false{
                print("##score submitted!!")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.onClickSubmit()
                }
            }else{
                self.toast(message: "Failed to submit the score!!", type: .Faliure)
            }
        }

    }

//    @FormUrlEncoded
//    @POST("kbg_controller.php")
//    Single<KBGSubmitResultResponse> submitResult(
//            @Field("submitResult") String submitResult,
//            @Field("society_id") String society_id,
//            @Field("user_id") String user_id,
//            @Field("kbg_game_id") String kbg_game_id,
//            @Field("wining_point") String wining_point,
//            @Field("currect_answer") String currect_answer,
//            @Field("user_full_name") String user_full_name,
//            @Field("user_profile_pic") String user_profile_pic,
//            @Field("unit_name") String unit_name,
//            @Field("user_mobile") String user_mobile
//    );

    func doSubmitData(completion : @escaping((Bool)->())){
        let params = ["submitResult":"submitResult",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id":doGetLocalDataUser().userID!,
                      "kbg_game_id":questionData.kbgGameID!,
                      "wining_point":self.pointswon,
                      "currect_answer":questionData.currectAnswer!,
                      "user_full_name":doGetLocalDataUser().userFullName!,
                      "user_profile_pic":doGetLocalDataUser().userProfilePic!,
                      "unit_name":doGetLocalDataUser().unitName!,
                      "user_mobile":doGetLocalDataUser().userMobile!]
        print(params as Any)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPostCommon(serviceName: ServiceNameConstants.kbgController, parameters: params) { (Data, Err) in
            if Data != nil{
                do{
                    let response = try JSONDecoder().decode(CommonResponse.self, from: Data!)
                    if response.status == "200"{
                       completion(true)
                    }else{
                        completion(false)
                        print("faliure message",response.message as Any)
                    }
                }catch{
                    print("api error",Err as Any)
                    print("parse error",error as Any)
                }
            }
        }
    }
//    func resultDailog(){
//        let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitDialogVC")as! SubmitDialogVC
//        vc.pointswon = String(self.pointswon)
//        vc.item = self.item!
//      //  vc.flag = doGetValueLanguage(forKey: "oops_your_answer_is_wrong")
//        vc.exitContext = self
//        vc.context = self.context
//        let screenwidth = UIScreen.main.bounds.width
//        let screenheight = UIScreen.main.bounds.height
//        let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
//        popupVC.backgroundAlpha = 0.8
//        popupVC.backgroundColor = .black
//        popupVC.shadowEnabled = true
//        popupVC.canTapOutsideToDismiss = true
//        present(popupVC, animated: true)
//    }
    
   @objc func onClickSubmit() {
    if flag == ""{
        self.dismiss(animated: true) {
            self.context.navigationController?.popViewController(animated: true)
        }
    }
        if flag == doGetValueLanguage(forKey: "time_over"){
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitDialogVC")as! SubmitDialogVC
            vc.pointswon = String(self.pointswon)
            vc.item = self.item!
            vc.flag = doGetValueLanguage(forKey: "time_over")
            vc.exitContext = self
            vc.context = self.context
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
            }
        
        if flag == doGetValueLanguage(forKey: "winner"){
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitDialogVC")as! SubmitDialogVC
            vc.pointswon = String(self.pointswon)
            vc.item = self.item!
            vc.flag = doGetValueLanguage(forKey: "winner")
            vc.exitContext = self
            vc.context = self.context
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }
        if flag == doGetValueLanguage(forKey: "oops_your_answer_is_wrong"){
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitDialogVC")as! SubmitDialogVC
            vc.pointswon = String(self.pointswon)
            vc.item = self.item!
            vc.flag = doGetValueLanguage(forKey: "oops_your_answer_is_wrong")
            vc.exitContext = self
            vc.context = self.context
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
        }

        if flag == doGetValueLanguage(forKey: "exit_the_game"){
            let vc = UIStoryboard(name: "KBG", bundle: nil).instantiateViewController(withIdentifier: "idSubmitDialogVC")as! SubmitDialogVC
            vc.pointswon = String(self.pointswon)
            vc.item = self.item!
            vc.flag = doGetValueLanguage(forKey: "exit_the_game")
            vc.exitContext = self
            vc.context = self.context
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let popupVC = PopupViewController(contentController:vc , popupWidth: screenwidth  , popupHeight: screenheight)
            popupVC.backgroundAlpha = 0.8
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)

        }
    }
    
}
