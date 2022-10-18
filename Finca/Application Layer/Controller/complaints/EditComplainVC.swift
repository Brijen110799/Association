//
//  EditComplainVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 11/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown
import AVKit
class EditComplainVC: BaseVC {
    
    
    var audiopermission = false
    var videoURL : NSURL?
    var videoData = Data()
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var imgpreview: UIImageView!
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
    var isPickerHidden = true
    var selectedIndex = 0
    var complainDetailList : ComplainModel!
    var complainCatList = [ComplainCategory]()
    var flagForEditing = false
    var status = "0"
    var complainStatus = [complainStatusModel]()
    var audio_duration = 0
    
    @IBOutlet weak var lblAudioPathName: UILabel!
    @IBOutlet weak var viewRecordedAudio: UIView!
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet var lblHradingCNNo: UILabel!
    @IBOutlet weak var imgComplaint: UIImageView!
    @IBOutlet var tfComplainMessage: UITextField!
    @IBOutlet var lblComplainTitle: UILabel!
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
    @IBOutlet var lblComplainDesc: UILabel!
    @IBOutlet var bubbleViews : [UIView]!
    @IBOutlet weak var viewOfBlink: UIView!
    
    @IBOutlet weak var btnSaveComplain: UIButton!
    @IBOutlet weak var lblRecordAudio: UILabel!
    @IBOutlet weak var btnDonePickerView: UIButton!
    var category = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgpreview.isHidden = true
        self.btnplay.isHidden = true
        self.btnclose.isHidden = true
        
        viewOfBlink.isHidden = true
        lblCategory.text! = "Reply"
        //lblHradingCNNo.text = complainDetailList.complain_no
        lblHradingCNNo.text = complainDetailList.complain_no+"-\(doGetValueLanguage(forKey: "edit"))"
        lblComplainTitle.text = complainDetailList.complaintcategoryview
        lblComplainDesc.text = complainDetailList.compalainTitle
       // tfCompainDesc.text = complainDetailList.complainDescription

        doneButtonOnKeyboard(textField: tfCompainDesc)

        tfCompainDesc.delegate = self

        check_record_permission()

        if flagForEditing{
            Utils.setImageFromUrl(imageView: imgComplaint, urlString: complainDetailList.complainPhoto, palceHolder: "addphotos")
            tfCompainDesc.text = complainDetailList.complainDescription
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        viewPicker.isHidden = true
        for item in complainStatus{
            self.category.append(item.status)
        }
        lblHradingCNNo.text = "\(complainDetailList.complain_no ?? "")\(doGetValueLanguage(forKey: "edit_complain"))"
        lblRecordAudio.text = doGetValueLanguage(forKey: "record_audio")
        btnSaveComplain.setTitle(doGetValueLanguage(forKey: "save").uppercased(), for: .normal)
        tfCompainDesc.placeholder("\(doGetValueLanguage(forKey: "complaint_message"))*")
    }

    @IBAction func btnCategorySelect(_ sender: UIButton) {
        //category.removeAll()
        
        dropdown.anchorView = lblCategory
        dropdown.dataSource = category
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblCategory.text = item
            if item == "Reply"{
                self.status = "0"
            }else if item == "Reopen"{
                self.status = "2"
            }else if item == "Close"{
                self.status = "1"
            }
            //self.selctedCatId = self.doGetIdfromCategoryName(catName: item)
        }
        dropdown.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- AUDIO RECORDING MODULE
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
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
                let durtion = audio_duration / 1000
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                let url = getFileUrl()
                audioRecorder = try AVAudioRecorder(url:url , settings: settings)
                self.fileURl = url
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record(forDuration: TimeInterval(durtion))
                audioRecorder.prepareToRecord()
                viewOfBlink.isHidden = false
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
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
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        
        if self.audiopermission {
            if(isRecording)
            {
                finishAudioRecording(success: true)
                imgRecordAudioBtn.image = UIImage(named: "mic_on")
                //            record_btn_ref.setTitle("Record", for: .normal)
                //            play_btn_ref.isEnabled = true
                isRecording = false
                viewOfBlink.isHidden = true
            }
            else
            {

                setup_recorder()
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
                    if  self.viewOfBlink.alpha == 0.0 {
                        print("0.0")
                        self.viewOfBlink.alpha = 1.0
                    } else {
                        print("1.0")
                        self.viewOfBlink.alpha = 0.0
                    }
                }, completion: nil)
                imgRecordAudioBtn.image = UIImage(named: "mic_off")
                if checkMicroPhonePermssion() {
                    audioRecorder.record()
                    
                }
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                //            record_btn_ref.setTitle("Stop", for: .normal)
                //            play_btn_ref.isEnabled = false
                isRecording = true
            }
        }
        else{
            self.checkMicroPhonePermssion()
        }
        
       
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if checkMicroPhonePermssion() {
            if audioRecorder.isRecording
            {
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d",min, sec)
                recordingTimeLabel.text = totalTimeString
                audioRecorder.updateMeters()
            } else {
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
            self.viewOfBlink.isHidden = true
        }
        else
        {
            self.viewOfBlink.isHidden = true
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }

    func doGetIdfromCategoryName(catName:String!) -> String! {
        var catid = ""
        for item in complainCatList{
            if item.categoryName == catName{
                catid = item.complaintCategoryID
            }
        }
        return catid
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

    @IBAction func btnSaveComplain(_ sender: Any) {
        
        
        if doValidate(){
            doCallEditComplainAPi()
            
        }
    }
    
    func doValidate()->Bool{
        if fileURl == nil{
            if (tfCompainDesc.text?.isEmptyOrWhitespace())!{
                showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "Enter_valid_message"))")
                return false
            }
        }

        if isRecording {
            showAlertMessage(title: "", msg: "Please stop audio recording")
            return false
        }
        return true
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkMicroPhonePermssion() -> Bool {
        var isPermision = true
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
            isPermision = true
            self.audiopermission = true
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            openPermision()
            isPermision = false
            self.audiopermission = false
            
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            openPermision()
            isPermision = false
            self.audiopermission = false
        default:
            break
        }
        return isPermision
        
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

    override func onClickDone() {
        self.doPopBAck()
        
    }

    func doCallEditComplainAPi(){
        
        
        
        var imageData : UIImage? = nil
        if UIImage(named: "newphoto")?.cgImage != imgComplaint.image?.cgImage{
            imageData = imgComplaint.image
        }
        self.showProgress()
        let params = ["editComplainNew":"editComplainNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "complain_id" : complainDetailList.complainID!,
                      "compalain_title":complainDetailList.compalainTitle!,
                      "complain_category":complainDetailList.complaintCategory!,
                      "complain_description":tfComplainMessage.text!,
                      "complaint_status":status,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":doGetLocalDataUser().company_name ?? "",
                      "user_id":doGetLocalDataUser().userID!]
        
        let request = AlamofireSingleTon.sharedInstance
        print("param" , params)
        if fileURl == nil && imageData == nil && videoData == nil {
            request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            
                            //self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            
                            
                            self.showAlertMessageWithClick(title: "", msg: "Complain " + self.lblCategory.text!  + " Successfully.")
                             // self.doPopBAck()
                        }else {
                            self.doPopBAck()
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }else if fileURl != nil &&  imageData != nil  {
            
            request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.complainController, parameters: params, fileURL:fileURl,compression: 0, imageFile: imgComplaint.image, fileParam: "complaint_voice" ,imageFileParam: "complain_photo") { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            
                            self.showAlertMessageWithClick(title: "", msg: "Complain " + self.lblCategory.text!  + " Successfully.")
                            
                            //                                          self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            //                                          self.doPopBAck()
                        }else {
                            self.doPopBAck()
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
            
            
        }else if fileURl != nil{
            request.requestPostMultipartDocument(serviceName: ServiceNameConstants.complainController, parameters: params, fileURL:fileURl, fileParam: "complaint_voice", compression: 0) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                          //  self.showAlertMessageWithClick(title: "", msg: "Complain " + self.lblCategory.text!  + " Successfully.")
                            
                            //                               self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            //                               self.doPopBAck()
                        }else {
                            
                            self.doPopBAck()
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        } else if imageData != nil  {
            request.requestPostMultipartImage(serviceName: ServiceNameConstants.complainController, parameters: params, imageFile: imgComplaint.image, fileName: "complain_photo", compression: 0.3) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            self.showAlertMessageWithClick(title: "", msg: "Complain " + self.lblCategory.text!  + " Successfully.")
                            
                            //                               self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                            //
                        }else {
                            self.doPopBAck()
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

                            self.showAlertMessageWithClick(title: "", msg: "Complain " + self.lblCategory.text!  + " Successfully.")
                            
                        }else {
                            self.doPopBAck()
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

    @IBAction func btnRemoveAudioRecording(_ sender: UIButton) {

        if isRecording == false{
            self.recordingTimeLabel.text = "00:00"
            self.lblAudioPathName.text = ""
            self.fileURl = nil
            self.viewRecordedAudio.isHidden = true
        }else{
            if recordingTimeLabel.text != "00:30"{
                showAlertMessage(title: "", msg: "Please stop audio recording to remove the file")
            }
        }

    }

}

extension EditComplainVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
        
        // imgComplaint.image = selectedImage
    }
}
extension EditComplainVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField) {
            //        case tfComplainTitle:
            //            tfViewComplainTitleHeightConstraint.constant = 2
        //            break;
        case tfCompainDesc:
            //tfViewComplainDescriptioHeightConstraint.constant = 2
            break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField) {
            //        case tfComplainTitle:
            //            tfViewComplainTitleHeightConstraint.constant = 1
        //            break;
        case tfCompainDesc:
            // tfViewComplainDescriptioHeightConstraint.constant = 1
            break;
            
        default:
            break;
        }
    }
}

extension EditComplainVC : UIPickerViewDelegate, UIPickerViewDataSource , UIScrollViewDelegate{
    
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
extension EditComplainVC : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    
    
    
}
