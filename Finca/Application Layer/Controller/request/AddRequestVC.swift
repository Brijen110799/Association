//
//  AddRequestVC.swift
//  Finca
//
//  Created by Jay Patel on 16/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import AVFoundation
class AddRequestVC: BaseVC, UITextViewDelegate {
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var imgComplaint: UIImageView!
    @IBOutlet weak var tfRequestTitle: UITextField!
    @IBOutlet weak var tfViewRequestDescriptioHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOfBlink: UIView!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var tfViewRequestTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet weak var imgRecordAudioBtn: UIImageView!
    
    @IBOutlet weak var viewOfMic: UIView!
    @IBOutlet weak var viewOfDetail: UIView!
    @IBOutlet weak var viewImage: UIView!

    @IBOutlet weak var lblAudioPathName: UILabel!
    @IBOutlet weak var viewRecordedAudio: UIView!
    
    @IBOutlet weak var btnSaveRequest: UIButton!
    @IBOutlet weak var lblRecordAudio: UILabel!
    @IBOutlet weak var lblScreenTitle: UILabel!
    var flagForEditing = false
    var requestDetails : RequestModel!
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
    var audio_duration  = 0
    let imagePlaceHolder = "newphoto"
    let hint = "* Request Description"
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOfBlink.isHidden = true
        self.viewOfDetail.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        self.viewImage.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        doneButtonOnKeyboard(textField: tvDesc)
        doneButtonOnKeyboard(textField: tfRequestTitle)
        tfRequestTitle.delegate = self
        tvDesc.delegate = self
        

        check_record_permission()

        if flagForEditing{
            Utils.setImageFromUrl(imageView: imgComplaint, urlString: requestDetails.request_image, palceHolder: "addphotos")
            tvDesc.text = requestDetails.request_description
            tfRequestTitle.text = requestDetails.request_title
        }
        //               pickerView.delegate = self
        //               pickerView.dataSource = self
        lblScreenTitle.text = doGetValueLanguage(forKey: "request")
        lblRecordAudio.text = doGetValueLanguage(forKey: "record_audio")
        tfRequestTitle.placeholder("\(doGetValueLanguage(forKey: "request_title"))*")
        tvDesc.placeholder = "\(doGetValueLanguage(forKey: "request_description"))*"
        tvDesc.placeholderColor = UIColor.lightGray
        btnSaveRequest.setTitle(doGetValueLanguage(forKey: "save"), for: .normal)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       
    }


    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if imgComplaint.image ==  UIImage(named: "addphotos")  {
            print("addd image")
        }
        
        
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {

        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
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
        let filename = "Fincasys_\(Date().generateCurrentTimeStamp()).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
//    func setup_recorder()
//    {
//        if checkMicroPhonePermssion()
//        {
//            let session = AVAudioSession.sharedInstance()
//            let durtion = audio_duration / 1000
//
//            do
//            {
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
//
//                viewOfMic.backgroundColor = ColorConstant.red500
//                imgRecordAudioBtn.image = UIImage(named: "mic_off")
//                imgRecordAudioBtn.setImageColor(color: .white)
//                viewOfBlink.isHidden = false
//
//
//                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat , UIView.AnimationOptions.curveEaseOut], animations: {
//                    if  self.viewOfBlink.alpha == 0.0 {
//                        print("0.0")
//                        self.viewOfBlink.alpha = 1.0
//                    } else {
//                        print("1.0")
//                        self.viewOfBlink.alpha = 0.0
//                    }
//                }, completion: nil)
//                if checkMicroPhonePermssion() {
//                    if audioRecorder != nil{
//                        audioRecorder.record()
//                    }else{
//                        self.showAlertMessage(title: "Alert!!", msg: "The Microphone is Occupied by Other Application Please Try Again!!")
//                    }
//
//                }
//                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//                //            record_btn_ref.setTitle("Stop", for: .normal)
//                //            play_btn_ref.isEnabled = false
//                isRecording = true
//            }
//            catch let error {
//                print(error as Any)
//                self.showAlertMessage(title: "Alert !!", msg: "Microphone is currently occupied by another application. Please Try Later!!")
//            }
//        }
//        /* else
//         {
//         display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
//         }*/
//    }
//
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
            isRecording = false
            viewOfBlink.isHidden = true
        }
        else
        {
        //    setup_recorder()
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
            print("recorded successfully.")
            viewOfMic.backgroundColor = ColorConstant.primaryColor.withAlphaComponent(0.25)
            viewOfBlink.isHidden = true
            self.lblAudioPathName.text = self.fileURl.localizedName
            self.viewRecordedAudio.isHidden = false
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
    func doCallAddRequestRegisterApi(){
        var imageData : UIImage? = nil
        if UIImage(named: "newphoto")?.cgImage != imgComplaint.image?.cgImage{
            imageData = imgComplaint.image
        }

        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addRequestNew":"addRequestNew",
                      "user_id":doGetLocalDataUser().userID!,
                      "society_id":doGetLocalDataUser().societyID!,
                      "user_name":userName(),
                      "request_title":tfRequestTitle.text!,
                      "request_description":tvDesc.text! == doGetValueLanguage(forKey: "request_description") ? "" : tvDesc.text!,
                      "unit_id":doGetLocalDataUser().unitID!]
        let request = AlamofireSingleTon.sharedInstance
        print("param" , params)
        if  imageData == nil && fileURl == nil {
            request.requestPost(serviceName: ServiceNameConstants.requestController, parameters: params){ (Data, Err) in
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

            request.requestPostMultipartImageAndAudio(serviceName: ServiceNameConstants.requestController, parameters: params, fileURL:fileURl,compression: 0, imageFile: imgComplaint.image , fileParam: "request_audio" ,imageFileParam: "request_image") { (Data, Err) in
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
            request.requestPostMultipartDocument(serviceName: ServiceNameConstants.requestController, parameters: params, fileURL:fileURl, fileParam: "request_audio", compression: 0) { (Data, Err) in
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
            request.requestPostMultipartImage(serviceName: ServiceNameConstants.requestController, parameters: params, imageFile: imgComplaint.image, fileName: "request_image", compression: 0.3) { (Data, Err) in
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
    func doValidate()->Bool{
        
        
        if tfRequestTitle.text!.isEmptyOrWhitespace() {
            showAlertMessage(title: "", msg: (doGetValueLanguage(forKey: "enter_valid_title")))
            return false
        }
        if tvDesc.text.isEmptyOrWhitespace(){
            showAlertMessage(title: "", msg: doGetValueLanguage(forKey: "Enter_valid_description"))
            return false
        }
        if isRecording {
            showAlertMessage(title: "", msg: "Please stop audio recording")
            return false
        }

        return true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @IBAction func btnSaveComplain(_ sender: Any) {
        if doValidate(){
            doCallAddRequestRegisterApi()
        }

    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
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
           // openPermision()
            isPermision = false

        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            //openPermision()
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
}
extension AddRequestVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)

        if let img = info[.editedImage] as? UIImage
        {
            let fixOrientationImage = img.fixOrientation()
            imgComplaint.image = fixOrientationImage
            
            
        }else if let img = info[.originalImage] as? UIImage
        {
            //image = img
            let fixOrientationImage = img.fixOrientation()
            imgComplaint.image = fixOrientationImage
            
        }
        
        

    }
}
extension AddRequestVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField) {
        case tfRequestTitle:
            tfViewRequestTitleHeightConstraint.constant = 40
            break;
        case tvDesc:
            tfViewRequestDescriptioHeightConstraint.constant = 2
            break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField) {
        case tfRequestTitle:
            tfViewRequestTitleHeightConstraint.constant = 40
            break;
        case tvDesc:
            tfViewRequestDescriptioHeightConstraint.constant = 1
            break;
            
        default:
            break;
        }
    }
}
extension AddRequestVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
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
extension AddRequestVC : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
}
