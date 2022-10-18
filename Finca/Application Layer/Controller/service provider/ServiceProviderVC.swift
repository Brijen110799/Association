//
//  ServiceProviderVC.swift
//  Finca
//
//  Created by harsh panchal on 26/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Speech
import CoreLocation
class ServiceProviderVC: BaseVC, SFSpeechRecognizerDelegate {
    
    var youtubeVideoID = ""
    @IBOutlet weak var VwVideo:UIView!
    @IBOutlet weak var bVideo:UIButton!
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var cvServiceProvider: UICollectionView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var VwBlink:UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    let itemCell = "ServiceProviderNewCell"
    var ServiceProviderList = [LocalServiceProviderModel]()
    var filteredArray = [LocalServiceProviderModel]()
    var selecteditem = -1
    var menuTitle : String!
    var fullStr = ""
    var ViewTimer: Timer?
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                    
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "idGlobalSearchServiceProviderVC") as! GlobalSearchServiceProviderVC
//                    vc.menuTitle = self.menuTitle
//                    self.pushVC(vc: vc)
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }

        doInintialRevelController(bMenu:bMenu)
        super.viewDidLoad()
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        doCallServiceProviderApi()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvServiceProvider.register(nib, forCellWithReuseIdentifier: itemCell)
        cvServiceProvider.delegate  = self
        cvServiceProvider.dataSource = self
        addRefreshControlTo(collectionView: cvServiceProvider)
        //doCallServiceProviderApi()
       // imgClose.isHidden = true
        viewNoData.isHidden = true
        doInitSpeechRecogniser()
        lblScreenTitle.text = menuTitle
        lblNoDataFound.text = doGetValueLanguage(forKey: "no_service_provider_available")
        tfSearch.placeholder(doGetValueLanguage(forKey: "search_category"))
        
        if youtubeVideoID != ""
        {
            VwVideo.isHidden = false
        }else
        {
            VwVideo.isHidden = true
        }
    }
    func doInitSpeechRecogniser(){
                VwBlink.isHidden = true
                imgClose.image = UIImage.init(named: "mic_off")
                microphoneButton.isEnabled = false
                speechRecognizer?.delegate = self
                SFSpeechRecognizer.requestAuthorization { (authStatus) in
                    var isButtonEnabled = false
        
                    switch authStatus {
                    case .authorized:
                        isButtonEnabled = true
        
                    case .denied:
                        isButtonEnabled = false
                        print("User denied access to speech recognition")
        
                    case .restricted:
                        isButtonEnabled = false
                        print("Speech recognition restricted on this device")
        
                    case .notDetermined:
                        isButtonEnabled = false
                        print("Speech recognition not yet authorized")
                    @unknown default:
                        print("default exicute")
                        break
                    }
        
                    OperationQueue.main.addOperation() {
                        self.microphoneButton.isEnabled = isButtonEnabled
                    }
                }
    }

    func startRecording() {
        
       // ViewTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(alarmAlertActivate), userInfo: nil, repeats: true)
        
        VwBlink.isHidden = false
        
        VwBlink.backgroundColor = ColorConstant.primaryColor
        VwBlink.startBlink()
        
//        UIView.animate(withDuration: 15.0, delay: 0.0, options: [.repeat, .autoreverse],animations: {
//
//            self.VwBlink.setProgress(1.0, animated: true)
//        })
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        DispatchQueue.main.async { [unowned self] in
                
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
               
                var isFinal = false
                
                if result != nil {
                    
                    isFinal = (result?.isFinal)!
                    print(result?.bestTranscription.formattedString ?? "")
                    let Str = result?.bestTranscription.formattedString ?? ""
                    fullStr = Str.trimmingCharacters(in: .whitespaces)
                    tfSearch.text = fullStr
            
                    filteredArray = fullStr.isEmpty ? ServiceProviderList : ServiceProviderList.filter({ (item:LocalServiceProviderModel) -> Bool in
                        
                        return item.serviceProviderCategoryName.lowercased().range(of: fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                    })
                    
                    if filteredArray.count > 0
                    {
                        self.viewNoData.isHidden = true
                    }else
                    {
                        self.viewNoData.isHidden = false
                    }
                        
                    cvServiceProvider.reloadData()
                    
                }
                
                if error != nil || isFinal {
                   
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.microphoneButton.isEnabled = true
                    recognitionRequest.endAudio()
                 
                    imgClose.image = UIImage.init(named: "mic_off")
                    VwBlink.isHidden = true
                    VwBlink.stopBlink()
                    
                }else
                {
                    
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.microphoneButton.isEnabled = false
                    recognitionRequest.endAudio()
                   // tfSearch.text = ""
                    imgClose.image = UIImage.init(named: "mic_on")
                    VwBlink.isHidden = false
                    
                }
            })
            
            }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
      //  textView.text = "Say something, I'm listening!"
        
    }

    @IBAction func onClickLocation(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        loadNoti()
    }
    override func fetchNewDataOnRefresh() {
        filteredArray.removeAll()
        ServiceProviderList.removeAll()
        cvServiceProvider.reloadData()
        refreshControl.beginRefreshing()
        doCallServiceProviderApi()
        refreshControl.endRefreshing()
        
    }
    @IBAction func onClickClear(_ sender: Any) {
//        imgClose.isHidden = true
//        tfSearch.text = ""
//        closeKeyboard()
//     self.viewNoData.isHidden = true
//        self.filteredArray = ServiceProviderList
//          cvServiceProvider.reloadData()
        // ........................old code above .....................
        
        
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            let randomNumber = Int.random(in: 1...10)
//            print("Number: \(randomNumber)")
//
//            if randomNumber == 10 {
//                timer.invalidate()
//
//
//            }
//        }
//
//
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            showAlertMsg(title: "", msg: "My Association needs access to microphone.Tap Settings -> turn on Microphone")
            return
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        @unknown default: break
            
        }
        
        if audioEngine.isRunning {
               audioEngine.stop()
                recognitionRequest?.endAudio()
                microphoneButton.isEnabled = false
                imgClose.image = UIImage.init(named: "mic_off")
           } else {
                microphoneButton.isEnabled = true
                startRecording()
                imgClose.image = UIImage.init(named: "mic_on")
           
            
           }
    }
    func showAlertMsg(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        
        filteredArray = textField.text!.isEmpty ? ServiceProviderList : ServiceProviderList.filter({ (item:LocalServiceProviderModel) -> Bool in
            
            return item.serviceProviderCategoryName.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || item.service_provider_category_name_search.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
       
//        if textField.text == "" {
//            self.imgClose.isHidden  = false
//        } else {
//            self.imgClose.isHidden  = false
//        }
        
        
        if filteredArray.count == 0 {
            self.viewNoData.isHidden = false
        } else {
            self.viewNoData.isHidden = true
        }
        
        cvServiceProvider.reloadData()
    }

    func doCallServiceProviderApi() {

        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getLocalServiceProviders":"getLocalServiceProviders",
                      "society_id":doGetLocalDataUser().societyID!,
                      "country_code":doGetLocalDataUser().countryCode!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.LSPController, parameters: params, completionHandler: { (json, error) in
            self.hideProgress()
            if json != nil {
                print("something")
                do {
                    print("something")
                    let response = try JSONDecoder().decode(LocalServiceProviderResponse.self, from:json!)
                    if response.status == "200" {
                        self.ServiceProviderList.append(contentsOf: response.localServiceProvider)
                        self.filteredArray = self.ServiceProviderList
                        self.cvServiceProvider.reloadData()
                          self.viewNoData.isHidden = true
                    } else {
                        self.viewNoData.isHidden = false
                    }
                } catch {
                    print("parse error",error)
                }
            }
        })
    }
    
    func loadNoti() {
        
//        if getNotiCount() !=  "0" {
//            self.viewNotiCount.isHidden =  false
//            self.lbNotiCount.text = getNotiCount()
//        } else {
//            self.viewNotiCount.isHidden =  true
//
//        }
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        goToDashBoard(storyboard: mainStoryboard)
    }
    
    
    @IBAction func btnNotification(_ sender: UIButton) {
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
    
    @IBAction func tapSearch(_ sender: Any) {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied :
                    self.showAlertMsg(title: "Turn on your location setting", msg: "1.Select Location > 2.Tap Always or While Using")
                    
                case .notDetermined:
                    print("No access")
                    self.locationManager.requestAlwaysAuthorization()
                    // For use in foreground
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "idGlobalSearchServiceProviderVC") as! GlobalSearchServiceProviderVC
                    vc.menuTitle = self.menuTitle
                    self.pushVC(vc: vc)
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled")
            }
        }

        
        
        
    }
    
}

extension ServiceProviderVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvServiceProvider.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ServiceProviderNewCell
      //  Utils.setImageFromUrl(imageView: cell.imgServiceProvider, urlString: filteredArray[indexPath.row].serviceProviderCategoryImage, palceHolder: "fincasys_notext")
       // cell.heightImgView.constant = 80
       
        cell.lblServiceProviderName.text = filteredArray[indexPath.row].serviceProviderCategoryName
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = cvServiceProvider.bounds.width/2
        return CGSize(width: width - 1, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
        
        if data.localServiceSubProvider.count == 0{
            if  StringConstants.KEY_IS_OLD_SERVICE_UI {
                // this old ui
                let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailOldVC")as! ServiceProviderDetailOldVC
                nextvc.headingText = filteredArray[indexPath.row].serviceProviderCategoryName
                nextvc.serviceProviderDetail = filteredArray[indexPath.row]
                self.navigationController?.pushViewController(nextvc, animated: true)
            } else {
                let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderDetailVC")as! ServiceProviderDetailVC
                nextvc.headingText = filteredArray[indexPath.row].serviceProviderCategoryName
                //nextvc.serviceProviderDetail = filteredArray[indexPath.row]
                self.navigationController?.pushViewController(nextvc, animated: true)
            }
          
        }else{
            let nextvc = storyboardConstants.serviceprovider.instantiateViewController(withIdentifier: "idServiceProviderSubCateVC")as! ServiceProviderSubCateVC
            nextvc.subServiceProviderList.append(contentsOf: data.localServiceSubProvider)
            nextvc.serviceProviderDetail = filteredArray[indexPath.row]
            nextvc.modalPresentationStyle = .fullScreen
            nextvc.parentContext = self
            self.present(nextvc, animated: true, completion: nil)
        }
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
}
extension UIView {
    func startBlink() {
        UIView.animate(withDuration: 0.8,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.alpha = 0.5 },
              completion: nil)
    }
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 0.8
    }
}
