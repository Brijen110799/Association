//
//  AddComplaintsVC.swift
//  Finca
//
//  Created by harsh panchal on 01/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown
import AVKit
class AddComplaintsVC: BaseVC, UITextViewDelegate {
    
    var videoData = Data()
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var imgpreview: UIImageView!
    var videoURL : NSURL?
    @IBOutlet weak var viewOfMic: UIView!
    @IBOutlet weak var viewOfBlink: UIView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var viewOfDetails: UIView!
    @IBOutlet weak var viewOfImage: UIView!
    
    @IBOutlet weak var lblAudioPathName: UILabel!
    @IBOutlet weak var viewRecordedAudio: UIView!
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var imgComplaint: UIImageView!
    @IBOutlet weak var tfComplainTitle: UITextField!
    @IBOutlet weak var tfCompainDesc: UITextField!
    @IBOutlet weak var tfViewComplainDescriptioHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfViewComplainTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var imgRecordAudioBtn: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var btnSaveComplain: UIButton!
    @IBOutlet weak var btnViewPickerDone: UIButton!
    @IBOutlet weak var lblRecordAudio: UILabel!
    @IBOutlet weak var lblScreenTitle: UILabel!
    var flagForEditing = false
    var complainDetails : ComplainModel!
    var isPickerHidden = true
    var selectedIndex = 0
    var complainCatList = [ComplainCategory]()
    var recordingLimit = ""
    var selctedCatId = ""
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var fileURl : URL!
    var dropdown = DropDown()
    var audioDuration = 0
    let hint = "* Complain Description"
    let ACCEPTABLE_CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 !@%&*()_-+={}[]'?<>,./"
    var isPlay = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgpreview.isHidden = true
        self.btnplay.isHidden = true
        self.btnclose.isHidden = true
        
        
        viewOfBlink.isHidden = true
        self.viewOfImage.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        self.viewOfDetails.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        doCallGetComplainCatApi()
        doneButtonOnKeyboard(textField: tfComplainTitle)
       // doneButtonOnKeyboard(textField: tfCompainDesc)
        doneButtonOnKeyboard(textField: tvDescription)
        tfComplainTitle.delegate = self

//        tvDescription.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        if tvDescription.text == ""{
//            tvDescription.text = doGetValueLanguage(forKey: "Enter_valid_description")
//        }
        tvDescription.delegate = self

        
        if flagForEditing{
            Utils.setImageFromUrl(imageView: imgComplaint, urlString: complainDetails.complainPhoto, palceHolder: "addphotos")
            tvDescription.text = complainDetails.complainDescription
            tfComplainTitle.text = complainDetails.compalainTitle
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        viewPicker.isHidden = true
        lblScreenTitle.text = doGetValueLanguage(forKey: "complaint")
        lblRecordAudio.text = doGetValueLanguage(forKey: "record_audio")
        lblCategory.text = doGetValueLanguage(forKey: "select_category_spinner")
        tfComplainTitle.placeholder("\(doGetValueLanguage(forKey: "complaint_title"))*")
        tvDescription.placeholder = ("\(doGetValueLanguage(forKey: "complaint_description"))*")
        tvDescription.placeholderColor = .gray
        
        btnSaveComplain.setTitle(doGetValueLanguage(forKey: "save").uppercased(), for: .normal)
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if imgComplaint.image ==  UIImage(named: "addphotos")  {
            print("addd image")
        }
       //check_record_permission()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        
     //   if tvDescription.isEditing{
            //            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
           // }
            //            }
        }
    }
    
    @IBAction func btnAttchementvideo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
            self.openCameraforvideo()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Gallery", style: .default, handler: { _ in
            self.openGalleryforvideo()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK:- AUDIO RECORDING MODULE
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            self.toast(message: "Please give microphone permission from the settings app and try again.", type: .Faliure)
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL
    {
        let filename = "\(doGetValueLanguage(forKey: "app_name"))_\(Date().generateCurrentTimeStamp()).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder()
    {
        if checkMicroPhonePermssion()
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                let durtion = audioDuration / 1000
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]
                let url = getFileUrl()
                audioRecorder = try AVAudioRecorder(url:url , settings: settings)
                self.fileURl = url
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record(forDuration: TimeInterval(durtion))
                audioRecorder.prepareToRecord()

                viewOfMic.backgroundColor = ColorConstant.red500
                imgRecordAudioBtn.image = UIImage(named: "mic_off")
                imgRecordAudioBtn.setImageColor(color: .white)
                viewOfBlink.isHidden = false
                
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
                    if  self.viewOfBlink.alpha == 0.0 {
                        print("0.0")
                        self.viewOfBlink.alpha = 1.0
                    } else {
                        print("1.0")
                        self.viewOfBlink.alpha = 0.0
                    }
                }, completion: nil)
                
                if checkMicroPhonePermssion() {
                    if audioRecorder != nil{
                        audioRecorder.record()
                    }else{
                        self.showAlertMessage(title: "Alert!!", msg: "The Microphone is Occupied by Other Application Please Try Again!!")
                    }

                }
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                //            record_btn_ref.setTitle("Stop", for: .normal)
                //            play_btn_ref.isEnabled = false
                isRecording = true
            }
            catch let error {
                print(error as Any)
                self.showAlertMessage(title: "Alert !!", msg: "Microphone is currently occupied by another application. Please Try Later!!")
            }
        }
        /* else
         {
         display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
         }*/
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    @IBAction func btncloseAction(_ sender: Any) {
        self.imgpreview.isHidden = true
        self.btnplay.isHidden = true
        self.btnclose.isHidden = true
        imgComplaint.image = UIImage(named: "newphoto")
        
        
    }
    @IBAction func btnplayAction(_ sender: Any) {
        
        
        if  videoURL != nil
        {
            let player = AVPlayer(url: videoURL! as URL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true) {
                player.play()

            }
        }
        
    }
    
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        if(isRecording)
        {
            isPlay = true
            finishAudioRecording(success: true)
            imgRecordAudioBtn.image = UIImage(named: "mic_on")
            
            //            record_btn_ref.setTitle("Record", for: .normal)
            //            play_btn_ref.isEnabled = true
            viewOfMic.backgroundColor = UIColor(named: "bg_color")
            imgRecordAudioBtn.setImageColor(color: .white)
            viewOfBlink.isHidden = true
            
            isRecording = false
        }
        else
        {
            isPlay = false
            setup_recorder()

        }
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if checkMicroPhonePermssion() {
            if audioRecorder.isRecording
            {
                //  let totalTimeString = String(format: "%02d:",Double(audioRecorder.currentTime))
                
                // print("durtion = ," , durtion)
                //  print("dicucuc = " , audioRecorder.currentTime)
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d",min, sec)
                recordingTimeLabel.text = totalTimeString
                audioRecorder.updateMeters()
            } else {
                // print("is stop ")
                finishAudioRecording(success: true)
            }
        }
        
    }

    func finishAudioRecording(success: Bool)
    {
        if success
        {
            imgRecordAudioBtn.image = UIImage(named: "mic_on")
            isRecording = false
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            self.lblAudioPathName.text = self.fileURl.localizedName
            self.viewRecordedAudio.isHidden = false
            print("recorded successfully.")
            viewOfMic.backgroundColor = ColorConstant.primaryColor.withAlphaComponent(0.25)
            viewOfBlink.isHidden = true
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    @IBAction func btnCategorySelect(_ sender: UIButton) {
        var category = [String]()
        category.removeAll()
        for item in complainCatList{
            category.append(item.categoryName)
        }
        dropdown.anchorView = lblCategory
        dropdown.dataSource = category
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblCategory.text = item
            self.selctedCatId = self.doGetIdfromCategoryName(catName: item)
        }
        dropdown.show()
    }
    
    func doGetIdfromCategoryName(catName:String!) -> String! {
        var catid = ""
        for item in complainCatList{
            if item.categoryName == catName{
                catid = item.complaintCategoryID
            }else{
                //                break
            }
        }
        return catid
    }

    @IBAction func btnChooseImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveComplain(_ sender: Any) {
        if doValidate(){
            
            if flagForEditing{
                doCallEditComplainAPi()
            }else{
                doCallComplainRegisterApi()
                

            }
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfComplainTitle ||  textField == tvDescription {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            return  (string == filtered)
        }
        return true
    }

    func doValidate()->Bool{
        
        /* if imgComplaint.image == UIImage(named: "no-image-available"){
         showAlertMessage(title: "", msg: "please select a image for your complain")
         return false
         }*/
        if selctedCatId == "" {
            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "please_select_category"))")
            return false
        }
        if (tfComplainTitle.text?.isEmptyOrWhitespace())!{
            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "please_add_complaint_title"))")
            return false
        }
        if tvDescription.text!.isEmptyOrWhitespace() ||  tvDescription.text == "" {
            showAlertMessage(title: "", msg:doGetValueLanguage(forKey: "please_add_complaint_description"))
            return false
        }
      
//
//        if self.fileURl == nil{
//            if tvDescription.text!.isEmptyOrWhitespace(){
//                showAlertMessage(title: "", msg: "please mention a description for your complain")
//                return false
//            }
//            if tvDescription.text == ""{
//                showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "Enter_valid_description"))")
//                return false
//            }
//        }
        
        if isRecording {
            showAlertMessage(title: "", msg: "Please stop audio recording")
            return false
        }
        
        /* if UIImage(named: "addphotos")?.cgImage == imgComplaint.image?.cgImage{
         imgComplaint.image = UIImage(named: "")
         }*/
        return true
    }
    
    func doCallGetComplainCatApi(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getComplainCategory":"getComplainCategory"]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                print(json as Any)
                do {
                    
                    let response = try JSONDecoder().decode(ComplainCategoryResponse.self, from:json!)
                    if response.status == "200" {
                        self.complainCatList.append(contentsOf: response.complainCategory)
                        self.pickerView.reloadAllComponents()
                        if self.flagForEditing{
                            self.selctedCatId = self.complainDetails.complaintCategory!
                            self.lblCategory.text =
                                self.complainCatList[Int(self.complainDetails.complaintCategory)!-1].categoryName}
                        self.audioDuration = response.audioDuration!

                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }else{
                
            }
        }
    }
    
    func doCallEditComplainAPi(){
        self.showProgress()
        var imagedata = ""
        if imgComplaint.image?.cgImage == UIImage(named: "newphoto")?.cgImage{
            imagedata = ""
        }else{
            imagedata = convertImageTobase64(imageView: imgComplaint)
        }
        let params = ["key":ServiceNameConstants.API_KEY,
                      "editComplain":"editComplain",
                      "society_id":doGetLocalDataUser().societyID!,
                      "complain_id":self.complainDetails.complainID!,
                      "compalain_title":tfComplainTitle.text!,
                      "complain_description":tvDescription.text!,
                      "complaint_category":selctedCatId,
                      "complain_photo":imagedata]

        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                        self.doPopBAck()
                    }else {
                        self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallComplainRegisterApi(){
        var imageData : UIImage? = nil
        if UIImage(named: "newphoto")?.cgImage != imgComplaint.image?.cgImage{
            imageData = imgComplaint.image
        }

        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addComplainNew":"addComplainNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "compalain_title":tfComplainTitle.text!,
                      "complain_description":tvDescription.text! == doGetValueLanguage(forKey: "complaint_description") ? "" : tvDescription.text!,
                      "complain_date":"",
                      "complain_status":"0",
                      "complain_assing_to":doGetLocalDataUser().blockName! + "-" + doGetLocalDataUser().floorName!,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().company_name ?? "",
                      "complaint_category":selctedCatId,
                      "user_id":doGetLocalDataUser().userID!]
        let request = AlamofireSingleTon.sharedInstance
        print("param" , params)
        if  imageData == nil && fileURl == nil && videoData == nil {
            request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            self.doPopBAck()
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
        else if  videoData != nil  {
            
            request.requestPostMultipartImageAndAudioVideo(serviceName: ServiceNameConstants.complainController, parameters: params, fileURL:fileURl,compression: 0,fileParam: "complaint_voice" ,videofile:videoData,videoname:"complaint_video") { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {

                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {

                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            self.doPopBAck()
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
            
            
        }
        else if  imageData != nil  {
            
            request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.complainController, parameters: params, fileURL:fileURl,compression: 0, imageFile: imgComplaint.image! , fileParam: "complaint_voice" ,imageFileParam: "complain_photo") { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {

                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {

                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            self.doPopBAck()
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
            
            
        }
        else if fileURl != nil{
            print("only autio")
            request.requestPostMultipartDocument(serviceName: ServiceNameConstants.complainController, parameters: params, fileURL:fileURl, fileParam: "complaint_voice", compression: 0) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            self.doPopBAck()
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
        else if imageData != nil  {
            request.requestPostMultipartImage(serviceName: ServiceNameConstants.complainController, parameters: params, imageFile: imgComplaint.image, fileName: "complain_photo", compression: 0.3) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            self.doPopBAck()
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }
        
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCameraforvideo()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = 30.0
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGalleryforvideo()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.videoMaximumDuration = 30.0
            imagePicker.mediaTypes = ["public.movie"]
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnRemoveAudioRecording(_ sender: UIButton) {
        
        if isPlay == true{
            print("true")
            self.recordingTimeLabel.text = "00:00"
            self.lblAudioPathName.text = ""
            self.fileURl = nil
            self.viewRecordedAudio.isHidden = true
        }else{
            if recordingTimeLabel.text != "00:30"{
                print("false")
                showAlertMessage(title: "", msg: "please stop audio")
            }
        }
        if recordingTimeLabel.text == "00:30"{
            self.recordingTimeLabel.text = "00:00"
            self.lblAudioPathName.text = ""
            self.fileURl = nil
            self.viewRecordedAudio.isHidden = true
        }
    }
    
    func checkMicroPhonePermssion() -> Bool {
        var isPermision = true
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            // print("Permission granted")
            isPermision = true
        case AVAudioSession.RecordPermission.denied:
            // print("Pemission denied")
            // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            var flag = false
            AVCaptureDevice.requestAccess(for: .audio) { (Granted) in
                if Granted{
                    flag = true

                }else{
                    self.self.initToastStyles()
                    self.toast(message: "Please give microphone permission from system settings", type: .Warning)
                   // ToastView.appearance().backgroundColor = .red
                    
                    flag = false
                }
            }
            isPermision = flag

        case AVAudioSession.RecordPermission.undetermined:
            //print("Request permission here")
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            var flag = false
            AVCaptureDevice.requestAccess(for: .audio) { (Granted) in
                if Granted{
                    flag = true

                }else{
                    flag = false
                }
            }
            isPermision = flag
        default:
            break
        }
        return isPermision
        
    }
    override func initToastStyles(){
        warningStyle.messageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        warningStyle.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        
    }
    func openPermision() {
        let ac = UIAlertController(title: "", message: "Please access micro phone permission", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default)
        {
            (result : UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default)
        {
            (result : UIAlertAction) -> Void in
            ac.dismiss(animated: true, completion: nil)
        })
        present(ac, animated: true)
    }
    
}
extension AddComplaintsVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)


        if let img = info[.editedImage] as? UIImage
        {
            let fixOrientationImage = img.fixOrientation()
            imgComplaint.image = fixOrientationImage
            imgpreview.image = fixOrientationImage
            
            self.imgpreview.isHidden = false
            self.btnplay.isHidden = true
            self.btnclose.isHidden = false
            
            
        }else if let img = info[.originalImage] as? UIImage
        {
            //image = img
            let fixOrientationImage = img.fixOrientation()
            imgComplaint.image = fixOrientationImage
            imgpreview.image = fixOrientationImage
            
            self.imgpreview.isHidden = false
            self.btnplay.isHidden = true
            self.btnclose.isHidden = false
            
        }
        
        if let videourl = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
        {
            
            self.videoURL = videourl
            
                         
           
            do {
                videoData = try Data(contentsOf: videourl as URL)
                let asset = AVURLAsset(url: videourl as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                imgpreview.image = thumbnail
                
                self.imgpreview.isHidden = false
                self.btnplay.isHidden = false
                self.btnclose.isHidden = false
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
            
        }
          
        
        

    }
}
extension AddComplaintsVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField) {
        case tfComplainTitle:
            tfViewComplainTitleHeightConstraint.constant = 2
            break;
        case tvDescription:
            tfViewComplainDescriptioHeightConstraint.constant = 2
            break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField) {
        case tfComplainTitle:
            tfViewComplainTitleHeightConstraint.constant = 1
            break;
        case tvDescription:
            tfViewComplainDescriptioHeightConstraint.constant = 1
            break;
            
        default:
            break;
        }
    }
}
extension UIView{
    func animShowPicker(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    func animHidePicker(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
extension AddComplaintsVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
            return 1
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return complainCatList.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return complainCatList[row].categoryName
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            selectedIndex = row
        }else{
            selectedIndex = 0
        }
    }
}
extension AddComplaintsVC : AVAudioRecorderDelegate, AVAudioPlayerDelegate{

}
extension Date {
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}

extension UIImage {

    func fixOrientation() -> UIImage {

        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity

        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }

        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }

        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;

        ctx.concatenate(transform)

        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }

        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }


}
