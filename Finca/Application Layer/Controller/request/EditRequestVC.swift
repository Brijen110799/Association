//
//  EditRequestVC.swift
//  Finca
//
//  Created by Jay Patel on 17/03/20.
//  Copyright © 2020 anjali. All rights reserved.

import UIKit
import AVFoundation
import DropDown
class EditRequestVC: BaseVC {
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
    var requestStatus = [RequestResponse]()
    var requestDetailList : RequestModel!
    //    var requestCatList = [ComplainCategory]()
    var flagForEditing = false
    var status = "3"
    var audio_duration = 0

    @IBOutlet weak var lblRequestCategory: UILabel!
    @IBOutlet weak var lblRequestTitle: UILabel!
    @IBOutlet weak var tfReqestDescription: ACFloatingTextfield!
    @IBOutlet weak var lblCategory: UILabel!

    @IBOutlet var lblHadingREQNo: UILabel!
    @IBOutlet weak var imgRequest: UIImageView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var imgRecordAudioBtn: UIImageView!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var bubbleViews : [UIView]!
    @IBOutlet weak var viewOfBlink: UIView!

    @IBOutlet weak var lblAudioPathName: UILabel!
    @IBOutlet weak var viewRecordedAudio: UIView!

    @IBOutlet weak var btnSaveRequest: UIButton!
    @IBOutlet weak var lblRecordAudio: UILabel!
    @IBOutlet weak var btnDonePickerVIew: UIButton!
    let palceHolder = "newphoto"
    var category = [String]()
    // 0 ->open, 1->closed, 2 ->in progress, 3 ->reply
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCategory.text! = "Reply"
//        tfReqestDescription.delegate = self
        lblHadingREQNo.text = requestDetailList.request_no+"-\(doGetValueLanguage(forKey: "edit"))"
       // lblHadingREQNo.text = requestDetailList.request_no+" - Edit"
        lblRequestCategory.text = requestDetailList.request_title
        lblRequestTitle.text = requestDetailList.request_description
        doneButtonOnKeyboard(textField: tfReqestDescription)
        tfReqestDescription.delegate = self
        tfReqestDescription.placeholder("\(doGetValueLanguage(forKey: "request_message_required"))*")
        lblRecordAudio.text = doGetValueLanguage(forKey: "record_audio")
        btnSaveRequest.setTitle(doGetValueLanguage(forKey: "save"), for: .normal)
        //check_record_permission()

        if flagForEditing{
            Utils.setImageFromUrl(imageView: imgRequest, urlString: requestDetailList.request_image, palceHolder: palceHolder)
            tfReqestDescription.text = requestDetailList.request_description

        }
        for item in bubbleViews{
                   item.makeBubbleView()
               }
        self.viewOfBlink.isHidden = true
        self.viewPicker.isHidden = true
    }

    @IBAction func btnCategorySelect(_ sender: UIButton) {
        //3 for Reply, 1 for close

        let category = ["Reply","Close"]

        //category.removeAll()

        dropdown.anchorView = lblCategory
        dropdown.dataSource = category
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblCategory.text = item
            if item == "Reply"{
                self.status = "3"
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

//    func check_record_permission()
//    {
//        switch AVAudioSession.sharedInstance().recordPermission {
//        case AVAudioSessionRecordPermission.granted:
//            isAudioRecordingGranted = true
//            break
//        case AVAudioSessionRecordPermission.denied:
//            isAudioRecordingGranted = false
//            break
//        case AVAudioSessionRecordPermission.undetermined:
//            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
//                if allowed {
//                    self.isAudioRecordingGranted = true
//                } else {
//                    self.isAudioRecordingGranted = false
//                }
//            })
//            break
//        default:
//            break
//        }
//    }

    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL
    {
        let filename = "Fincasys_\(Date().generateCurrentTimeStamp()).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }

//    func setup_recorder()
//    {
//        if checkMicroPhonePermssion()
//        {
//            let session = AVAudioSession.sharedInstance()
//            do
//            {
//                let durtion = audio_duration / 1000
//                try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
//                try session.setActive(true)
//                let settings = [
//                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                    AVSampleRateKey: 44100,
//                    AVNumberOfChannelsKey: 2,
//                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
//                ]
//                let url = getFileUrl()
//                audioRecorder = try AVAudioRecorder(url:url , settings: settings)
//                self.fileURl = url
//                audioRecorder.delegate = self
//                audioRecorder.isMeteringEnabled = true
//                audioRecorder.record(forDuration: TimeInterval(durtion))
//                audioRecorder.prepareToRecord()
//                viewOfBlink.isHidden = false
//            }
//            catch let error {
//                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
//            }
//        }
//        /* else
//         {
//         display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
//         }*/
//    }
    
    
    func setup_recorder()
    {
        if checkMicroPhonePermssion()
        {
            let session = AVAudioSession.sharedInstance()
            let durtion = audio_duration / 1000

            do
            {
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

                viewRecordedAudio.backgroundColor = ColorConstant.red500
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
    
    @IBAction func start_recording(_ sender: UIButton)
    {

        if(isRecording)
        {
            finishAudioRecording(success: true)
            imgRecordAudioBtn.image = UIImage(named: "mic_on")
            //            record_btn_ref.setTitle("Record", for: .normal)
            //            play_btn_ref.isEnabled = true
            isRecording = false
        }
        else
        {
            setup_recorder()
//            imgRecordAudioBtn.image = UIImage(named: "mic_off")
//            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
//                if  self.viewOfBlink.alpha == 0.0 {
//                    print("0.0")
//                    self.viewOfBlink.alpha = 1.0
//                } else {
//                    print("1.0")
//                    self.viewOfBlink.alpha = 0.0
//                }
//            }, completion: nil)
//            if checkMicroPhonePermssion() {
//                if audioRecorder != nil{
//                    audioRecorder.record()
//                }else{
//                    self.showAlertMessage(title: "Alert!!", msg: "The Microphone is Occupied by Other Application Please Try Again!!")
//                }
//
//            }
////            if checkMicroPhonePermssion() {
////                audioRecorder.record()
////
////            }
//            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//            //            record_btn_ref.setTitle("Stop", for: .normal)
//            //            play_btn_ref.isEnabled = false
//            isRecording = true
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
            }else {
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
            self.viewOfBlink.isHidden = true
        }
        else
        {
            self.viewOfBlink.isHidden = true
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
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
            doCallEditRequestAPi()
        }
    }

    func doValidate()->Bool{

        if tfReqestDescription.text == ""{
            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "Enter_valid_message"))")
            return false
        }

        if isRecording {
            showAlertMessage(title: "", msg: "\(doGetValueLanguage(forKey: "recored_file_mp3"))")
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
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            openPermision()
            isPermision = false

        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            openPermision()
            isPermision = false
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
    func doCallEditRequestAPi(){

        var imageData : UIImage? = nil
        if UIImage(named: palceHolder)?.cgImage != imgRequest.image?.cgImage{
            imageData = imgRequest.image
        }

        self.showProgress()
        let params = ["editRequestNew":"editRequestNew",
                      "society_id":doGetLocalDataUser().societyID!,
                      "request_id" : requestDetailList.request_id!,
                      "request_title":requestDetailList.request_title!,
                      "request_description":tfReqestDescription.text!,
                      "request_status":status,
                      "unit_id":doGetLocalDataUser().unitID!,
                      "user_name":userName(),
                      "user_id":doGetLocalDataUser().userID!]

        let request = AlamofireSingleTon.sharedInstance
        print("param" , params)
        if fileURl == nil && imageData == nil {
            request.requestPost(serviceName: ServiceNameConstants.requestController, parameters: params) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {

                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {

//                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
//
//                            self.doPopBAck()
                            self.showAlertMessageWithClick(title: "", msg: "Request " + self.lblCategory.text!  + " Successfully.")
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        }else if fileURl != nil &&  imageData != nil  {

            request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.requestController, parameters: params, fileURL:fileURl,compression: 0, imageFile: imgRequest.image, fileParam: "request_audio" ,imageFileParam: "request_image") { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {

                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {

//                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
//                            self.doPopBAck()
                            self.showAlertMessageWithClick(title: "", msg: "Request " + self.lblCategory.text!  + " Successfully.")
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }


        }else if fileURl != nil{
            request.requestPostMultipartDocument(serviceName: ServiceNameConstants.requestController, parameters: params, fileURL:fileURl, fileParam: "request_audio", compression: 0) {
                (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {
                        print("dfdgfddg1")
                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {
                            print("dfdgfddg2")
//                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
//                            self.doPopBAck()
                            self.showAlertMessageWithClick(title: "", msg: "Request " + self.lblCategory.text!  + " Successfully.")
                        }else {
                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                        }
                        print(Data as Any)
                    } catch {
                        print("parse error")
                    }
                }
            }
        } else if imageData != nil  {
            request.requestPostMultipartImage(serviceName: ServiceNameConstants.requestController, parameters: params, imageFile: imgRequest.image, fileName: "request_image", compression: 0.3) { (Data, Err) in
                if Data != nil {
                    self.hideProgress()
                    print(Data as Any)
                    do {

                        let response = try JSONDecoder().decode(CommonResponse.self, from:Data!)
                        if response.status == "200" {

//                            self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
//                            self.doPopBAck()
                            self.showAlertMessageWithClick(title: "", msg: "Request " + self.lblCategory.text!  + " Successfully.")
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

    @IBAction func btnRemoveAudioRecording(_ sender: UIButton) {

           if isRecording == false{
               self.recordingTimeLabel.text = "00:00"
               self.lblAudioPathName.text = ""
               self.fileURl = nil
               self.viewRecordedAudio.isHidden = true
           }else{
               if recordingTimeLabel.text != "00:30"{
                   showAlertMessage(title: "", msg: "Please Stop Audio Recording to remove the file")
               }
           }

       }

}
extension EditRequestVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard (info[.originalImage] as? UIImage) != nil else {
            print("Image not found!")
            return
        }
        
        if let img = info[.editedImage] as? UIImage
        {
            let fixOrientationImage = img.fixOrientation()
            imgRequest.image = fixOrientationImage


        }else if let img = info[.originalImage] as? UIImage
        {
            //image = img
            let fixOrientationImage = img.fixOrientation()
            imgRequest.image = fixOrientationImage

        }
        
        // imgRequest.image = selectedImage
    }
}
extension EditRequestVC :  AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField) {

        case tfReqestDescription:
            break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField) {
        case tfReqestDescription:
            break;
            
        default:
            break;
        }
    }
}
