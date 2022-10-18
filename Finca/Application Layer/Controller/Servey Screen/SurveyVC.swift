

import UIKit
import FittedSheets
struct SurveyInfo : Codable {
    let survey: [SurveyModel]!
    let message, status: String!
}

// MARK: - Survey
struct SurveyModel : Codable {
    let surveyID, surveyTitle, surveyDesciption, surveyDate: String!
    let surveyStatus: String!
    let surveyStatusCheck: String!
    let isSurveySubmited: Bool!
    enum CodingKeys: String, CodingKey {
        case surveyID = "survey_id"
        case surveyTitle = "survey_title"
        case surveyDesciption = "survey_desciption"
        case surveyDate = "survey_date"
        case surveyStatus = "survey_status"
        case surveyStatusCheck = "survey_status_check"
        case isSurveySubmited = "is_survey_submited"
    }
}

class SurveyVC: BaseVC {
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var tbvSurvey: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewClear: UIView!
    
    @IBOutlet weak var ViewSearch: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoData: UILabel!
    
    var itemCell = "SurveyCell"
    var menuTitle =  ""
    var SurverArr = [SurveyModel]()
    var filterSurveyQuesList = [SurveyModel]()
    var flagViewRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetSurveyQuestions()
        addRefreshControlTo(tableView: tbvSurvey)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvSurvey.register(nib, forCellReuseIdentifier: itemCell)
        tbvSurvey.delegate = self
        tbvSurvey.dataSource = self
        //tbvSurvey.estimatedRowHeight = 50
        Utils.setImageFromUrl(imageView: ivNoData, urlString: getPlaceholderLocal(key: menuTitle))
        viewClear.isHidden  = true
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tbvSurvey.estimatedRowHeight = UITableView.automaticDimension
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
        lbTitle.text = doGetValueLanguage(forKey: "survey")
        tfSearch.placeholder = doGetValueLanguage(forKey: "search_survey")
        lbNoData.text = doGetValueLanguage(forKey: "no_survey_available")
        tfSearch.clearButtonMode = .whileEditing
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    @objc func textFieldDidChange(textField: UITextField) {

        //your code

        filterSurveyQuesList = textField.text!.isEmpty ? SurverArr : SurverArr.filter({ (item:SurveyModel) -> Bool in

            return item.surveyTitle.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.surveyStatus.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })

        if textField.text == "" {
            self.imgClose.isHidden = true
        } else {
            self.imgClose.isHidden = false
        }
        
        if textField.text == "" {
            self.tfSearch.isHidden = true
        }else {
            self.tfSearch.isHidden = false
        }
        
        if filterSurveyQuesList.count == 0 {
            //self.ViewSearch.isHidden = false
            self.viewNoData.isHidden = false
        } else {
           // self.ViewSearch.isHidden = true
            self.viewNoData.isHidden = true
        }

        tbvSurvey.reloadData()
    }
    
    override func fetchNewDataOnRefresh() {
        tfSearch.text = ""
        view.endEditing(true)
        viewClear.isHidden  = true
        refreshControl.beginRefreshing()
        // pollingQuesList.removeAll()
        tbvSurvey.reloadData()
        doGetSurveyQuestions()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        if flagViewRefresh {
            flagViewRefresh = false
            //viewNoData.isHidden = true
            filterSurveyQuesList.removeAll()
            doGetSurveyQuestions()
        } else {

            // viewNoData.isHidden = false

        }

    }

    func doGetSurveyQuestions(){
        print("delete success")
        self.showProgress()
        let params = ["getSurvey":"getSurvey",
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_id" : doGetLocalDataUser().userID!,
                      "unit_id" :  doGetLocalDataUser().unitID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.surveyController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(SurveyInfo.self, from:json!)
                    if response.status == "200" {
                        self.viewNoData.isHidden = true
                        self.ViewSearch.isHidden = false
                        self.SurverArr = response.survey
                        self.filterSurveyQuesList =  self.SurverArr
                        self.tbvSurvey.reloadData()
                    }else {
                        self.viewNoData.isHidden = false
                        self.ViewSearch.isHidden = true
                        self.SurverArr.removeAll()
                        self.filterSurveyQuesList.removeAll()
                        self.tbvSurvey.reloadData()
                        self.lbNoData.text = self.doGetValueLanguage(forKey: "no_data")
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else if error != nil{
                self.showNoInternetToast()
            }
        }
    }

   
    @IBAction func onClickNotification(_ sender: Any) {
        //        let vc = mainStoryboard.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        let vc = subStoryboard.instantiateViewController(withIdentifier: "idSurveyVC") as! SurveyVC
        pushVC(vc: vc)
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

        goToDashBoard(storyboard: mainStoryboard)
    }
    @IBAction func onClickClear(_ sender: Any) {

        filterSurveyQuesList = SurverArr
        viewNoData.isHidden = true
        viewClear.isHidden  = true
        tbvSurvey.reloadData()
        tfSearch.text = ""
        view.endEditing(true)

    }
}

extension SurveyVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterSurveyQuesList.count == 0 {
          //  ViewSearch.isHidden = true
            //viewNoData.isHidden = false
        }else{
            //ViewSearch.isHidden = false
             //viewNoData.isHidden = true
        }
        return filterSurveyQuesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filterSurveyQuesList[indexPath.row]
        let cell = tbvSurvey.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! SurveyCell

        cell.lblSurveyTitle.text = data.surveyTitle
        cell.lblSurveyDes.text =  data.surveyDesciption
        cell.lblDate.text =  data.surveyDate
        cell.lbDate.text = doGetValueLanguage(forKey: "dates")
        cell.lbDescption.text = doGetValueLanguage(forKey: "description")
        cell.lblSurveyDes.isHidden = data.surveyDesciption ?? "" == "" ? true : false
        cell.lbDescption.isHidden = data.surveyDesciption ?? "" == "" ? true : false
        //cell.lblDate.textColor = UIColor(named: "blue_500")
//        switch (data.surveyStatus.lowercased()) {
//        case "open":
//            cell.lblStatus.text = "Open"
//            cell.viewStatus.backgroundColor = ColorConstant.green500
//            cell.lblStatus.textColor = UIColor.white
//            break;
//        case "close":
//            cell.lblStatus.text = "Close"
//            cell.viewStatus.backgroundColor = ColorConstant.red500
//            cell.lblStatus.textColor = UIColor.white
//            break
//        default:
//            break;
//        }
        
        if data.surveyStatusCheck == "0" {
            cell.lblStatus.text = data.surveyStatus
            cell.viewStatus.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 0.4)
            cell.lblStatus.textColor = ColorConstant.green500
            //cell.widthOfStatus.constant = 60
        } else if data.surveyStatusCheck == "1" {
            cell.lblStatus.text = data.surveyStatus
            cell.viewStatus.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.262745098, blue: 0.2117647059, alpha: 0.1966235017)
            cell.lblStatus.textColor = #colorLiteral(red: 0.9411764706, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            //cell.widthOfStatus.constant = 140
        } else {
            cell.lblStatus.text = data.surveyStatus
            cell.viewStatus.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.262745098, blue: 0.2117647059, alpha: 0.1966235017)
            cell.lblStatus.textColor = #colorLiteral(red: 0.9411764706, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            //cell.widthOfStatus.constant = 50
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.filterSurveyQuesList[indexPath.row]
        
        if item.surveyStatusCheck == "0" && !item.isSurveySubmited {
            let nextVC = UIStoryboard(name: "sub", bundle: nil).instantiateViewController(withIdentifier: "idSurveyQuestionVC")as! SurveyQuestionVC
            nextVC.surveyBasicDetails = self.filterSurveyQuesList[indexPath.row]
            nextVC.surveyVC = self
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if item.surveyStatusCheck == "1" {
            let vc = subStoryboard.instantiateViewController(withIdentifier: "idSurveyResultVC") as! SurveyResultVC
            vc.surveyModel = item
            pushVC(vc: vc)
        } else if item.surveyStatusCheck == "2" {
            toast(message: item.surveyStatus, type: .Information)
        } else {
           
            self.showAppDialog(delegate: self, dialogTitle: "", dialogMessage: doGetValueLanguage(forKey: "submit_opinion"), style: .Info, tag: 0, cancelText: "", okText: "OKAY")
           // toast(message: "You have already submitted your valuable opinion,Result will be published soon, Please wait for the result", type: .Information)
        }
       
    }

}
extension SurveyVC: AppDialogDelegate{
    func btnAgreeClicked(dialogType: DialogStyle,tag : Int) {
        if dialogType == .Info{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
