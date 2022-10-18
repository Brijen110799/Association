//
//  DailogLocationVC.swift
//  Finca
//
//  Created by anjali on 11/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Speech

class DailogLocationVC: BaseVC,SFSpeechRecognizerDelegate {
    
    var ArrFiltercountries = [CountryModel]()
    var ArrFilterstates = [StateModel]()
    var ArrFiltercity = [CityModel]()
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    var type:String!
    var state_id:String!
    var itemCell = "LocationCell"
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var VwBlink:UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tbvData: UITableView!
    
    @IBOutlet weak var bDone: UIButton!
    @IBOutlet weak var bCancel: UIButton!
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var ivNoData: UIImageView!
    @IBOutlet weak var lbNoData: UILabel!
    var selectedIndex : String!
    var countries = [CountryModel]()
    var filterCountries = [CountryModel]()
    var selectLocationVC:SelectLocationVC!
    var classiLocationFilter : ClassifiedLocationFilterVC!
    var states = [StateModel]()
    var filterStates = [StateModel]()
    var cities = [CityModel]()
    var filterCities = [CityModel]()
    var selectedRow : Int!
    var selectData = ""
    var fullStr = ""
    
    private var select_country = "Select Country"
    private var select_state = "Select State"
    private var select_city = "Select City"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
        
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
       
        
        viewNoData.isHidden = true
        if type == "state" {
            filterStates = states
            if doGetValueLanguage(forKey: "search_state") != "" {
                tfSearch.placeholder = doGetValueLanguage(forKey: "search_state")
            }
            lbNoData.text = "No state found"
            ivNoData.image = UIImage(named: "no_city")
        } else if type == "country"  {
            filterCountries = countries
            if doGetValueLanguage(forKey: "search_country") != "" {
                tfSearch.placeholder = doGetValueLanguage(forKey: "search_country")
            }
            lbNoData.text = "No country found"
            ivNoData.image = UIImage(named: "no_country")
        } else if type == "city" {
            filterCities = cities
            if doGetValueLanguage(forKey: "search_city") != "" {
              tfSearch.placeholder = doGetValueLanguage(forKey: "search_city")
            }
            
            lbNoData.text = "No city found"
            ivNoData.image = UIImage(named: "no_city")
            //doFilerCity()
        }
        // hideKeyBoardHideOutSideTouch()
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
        VwBlink.isHidden = true
      
        bDone.setTitle("done".uppercased(), for: .normal)
        bCancel.setTitle( "cancel".uppercased(), for: .normal)
        if doGetValueLanguage(forKey: "cancel") != "" {
            bDone.setTitle(doGetValueLanguage(forKey: "done").uppercased(), for: .normal)
            bCancel.setTitle(doGetValueLanguage(forKey: "cancel").uppercased(), for: .normal)
          
        }
        
        if doGetValueLanguage(forKey: "select_country") != "" {
            select_country = doGetValueLanguage(forKey: "select_country")
            select_state = doGetValueLanguage(forKey: "select_state")
            select_city = doGetValueLanguage(forKey: "select_city")
        }
        
        
    }
    @IBAction func onClickClear(_ sender: Any) {
        
        
        //doInitSpeechRecogniser()
       // selectedIndex = nil
        selectedRow = nil
        
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
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
           // var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                DispatchQueue.main.async {
                    self.doForRecord()
                }
                
                break
               // isButtonEnabled = true
                
            case .denied:
                //isButtonEnabled = false
                print("User denied access to speech recognition")
                
                DispatchQueue.main.async {
                    self.showAlertMsg(title: "", msg: "My Association needs access to speech recognition.Tap Settings -> turn on Speech Recognition")
                    return
                }
              
                
            case .restricted:
               // isButtonEnabled = false
                print("Speech recognition restricted on this device")
                return
            case .notDetermined:
               // isButtonEnabled = false
                print("Speech recognition not yet authorized")
                return
            @unknown default:
                break
            }
            
           
        }
        
        
        
    }
    
    func doForRecord() {
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
            //  imgClose.image = UIImage.init(named: "mic_off")
        } else {
            microphoneButton.isEnabled = true
            startRecording()
            //  imgClose.image = UIImage.init(named: "mic_on")
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
        audioEngine.inputNode.removeTap(onBus: 0)
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
                    selectedIndex = nil
                    if type == "country" {
                             
                        filterCountries = []
                        filterCountries = fullStr.isEmpty ? countries : countries.filter({ (item:CountryModel) -> Bool in
                                              
                                              return item.name.lowercased().range(of: fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                                          })
                                          
                    } else if type == "state"  {
                                        
                                        filterStates = []
                                          
                                        filterStates = fullStr.isEmpty ? states : states.filter({ (item:StateModel) -> Bool in
                                              
                                              return item.name.lowercased().range(of: fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                                          })
                                      
                    } else if type == "city" {
                                        filterCities = []
                                          filterCities = fullStr.isEmpty ? cities : cities.filter({ (item:CityModel) -> Bool in
                                              
                                              return item.name.lowercased().range(of: fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                                          })
                                      }
                    
                    tbvData.reloadData()

            
               //     filteredArray = fullStr.isEmpty ? ServiceProviderList : ServiceProviderList.filter({ (item:LocalServiceProviderModel) -> Bool in
                        
                       // return item.serviceProviderCategoryName.lowercased().range(of: fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                  //  })
                    
                  //  if filteredArray.count > 0
                 //   {
                 //       self.viewNoData.isHidden = true
                //    }else
                 //   {
                 //       self.viewNoData.isHidden = false
                 //   }
                        
                  //  cvServiceProvider.reloadData()
                    
                }
                
                if error != nil || isFinal {
                   
                 //   self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.microphoneButton.isEnabled = true
                    recognitionRequest.endAudio()
                 
                 //   imgClose.image = UIImage.init(named: "mic_off")
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
                  //  imgClose.image = UIImage.init(named: "mic_on")
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
//    @IBAction func microphoneTapped(_ sender: AnyObject) {
//        if audioEngine.isRunning {
//               audioEngine.stop()
//               recognitionRequest?.endAudio()
//               microphoneButton.isEnabled = false
//               microphoneButton.setTitle("Start Recording", for: .normal)
//           } else {
//               startRecording()
//               microphoneButton.setTitle("Stop Recording", for: .normal)
//           }
//    }
    func doInitSpeechRecogniser(){
        VwBlink.isHidden = true
        //                imgClose.image = UIImage.init(named: "mic_off")
       // microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
                DispatchQueue.main.async {
                    self.showAlertMsg(title: "", msg: "My Association needs access to speech recognition.Tap Settings -> turn on Speech Recognition")
                }
              
                return
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                break
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        
        //your code
        if type == "state" {
            
            filterStates = textField.text!.isEmpty ? states : states.filter({ (item:StateModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            if filterStates.count == 0 {
                viewNoData.isHidden = false
            } else {
                viewNoData.isHidden = true
            }
            tbvData.reloadData()
        } else if type == "country" {
            filterCountries = textField.text!.isEmpty ? countries : countries.filter({ (item:CountryModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            if filterCountries.count == 0 {
                viewNoData.isHidden = false
            } else {
                viewNoData.isHidden = true
            }
            tbvData.reloadData()
        }else if type == "city" {
            filterCities = textField.text!.isEmpty ? cities : cities.filter({ (item:CityModel) -> Bool in
                
                return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            if filterCities.count == 0 {
                viewNoData.isHidden = false
            } else {
                viewNoData.isHidden = true
            }
            tbvData.reloadData()
        }
        
    }
    @IBAction func onClickDone(_ sender: Any) {
        if isValidate() {
            if selectedRow != nil{
                if type == "state" {
                    //                    selectedIndex = filterStates[selectedRow].name
                    
                    for item in states {
                        if item.name == selectedIndex  {
                            selectLocationVC.state_id = item.stateID
                            selectLocationVC.state = item.name
                            break
                        }
                    }
                     //selectItemState(index: selectedRow, isFirstTime: false)
                    //
                } else if type == "country" {
                    //                     selectedIndex = filterCountries[selectedRow].name
                    
                    for item in countries {
                        if item.name == selectedIndex {
                           selectLocationVC.country_code = "+\(item.country_code ?? "")"
                            selectLocationVC.country_id = item.countryID
                            selectLocationVC.country = item.name
                            break
                        }
                    }
                    
                }else if type == "city" {
                    //                    selectedIndex = filterCities[selectedRow].name
                    for item in cities {
                        if item.name == selectedIndex {
                            selectLocationVC.city_id = item.cityID
                            selectLocationVC.city = item.name
                            break
                        }
                    }
                }
                selectLocationVC.reloadArrays()
            }
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func isValidate() -> Bool {
       var isValide = true
        
        if type == "state" {
            
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_state)
                
            }
        } else if type == "country" {
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_country)
            }
        }else if type == "city" {
            if selectedIndex ?? "" == "" {
                isValide = false
                showAlertMessage(title: "", msg: select_city)
            }
        }
        
        return isValide
    }
}

extension DailogLocationVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == "state" {
            return  self.filterStates.count
        } else if type == "country"  {
            return self.filterCountries.count
        } else if type == "city" {
            return self.filterCities.count
        }
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCell, for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        
        
        if type == "state" {
            if selectedIndex == filterStates[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterStates[indexPath.row].name
            
        } else  if type == "country" {
            if selectedIndex == filterCountries[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCountries[indexPath.row].name
            
        }else  if type == "city" {
            if selectedIndex == filterCities[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCities[indexPath.row].name
            
        }
        cell.ivImage.tintColor = UIColor(named: "ColorPrimary")
        cell.ivImage.image = cell.ivImage.image?.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        if type == "state" {
            selectedIndex = filterStates[indexPath.row].name
            
            //            selectLocationVC.state_id = filterStates[indexPath.row].stateID
            //            selectLocationVC.state = filterStates[indexPath.row].name
            //             //selectItemState(index: indexPath.row, isFirstTime: false)
            //
        } else if type == "country" {
            selectedIndex = filterCountries[indexPath.row].name
            //             selectLocationVC.country_id = filterCountries[indexPath.row].countryID
            //              selectLocationVC.country = filterCountries[indexPath.row].name
        }else if type == "city" {
            selectedIndex = filterCities[indexPath.row].name
            //             selectLocationVC.city_id = filterCities[indexPath.row].cityID
            //            selectLocationVC.city = filterCities[indexPath.row].name
        }
        self.view.endEditing(true)
        tableView.reloadData()
        
    }
}








