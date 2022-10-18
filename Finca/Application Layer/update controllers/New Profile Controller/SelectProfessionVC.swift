//
//  SelectProfessionVC.swift
//  DemoOne
//
//  Created by Silverwing_macmini5 on 14/02/20.
//  Copyright © 2020 Silverwing_macmini5. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Speech
class SelectProfessionVC: BaseVC,SFSpeechRecognizerDelegate {
    
    var type:String!
    var NewprofessionCategoryList = [ProfessionCategory]()
    var NewfilterProfessionCategoryList = [ProfessionCategory]()
    var NewprofessionTypeList = [ProfessionType]()
    var NewfilterProfessionTypeList = [ProfessionType]()
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var VwBlink:UIView!
    var selectedIndex : String!
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    var fullStr = ""
    @IBOutlet weak var viewRadius: UIView!
    @IBOutlet weak var viewRadiusOne: UIView!
    @IBOutlet weak var tbvProfession: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var bCancel: UIButton!
    @IBOutlet weak var bDone: UIButton!
    var context : EditProfessionalDetailsVC!
    var OccContext : OccupationVC!

    var profileCompleteVC : ProfileCompleteVC!
    
    @IBOutlet weak var viewNoData: UIView!
    var tag = 0
    var parkingBlockList = [ParkingData]()
    var filterBlockList = [ParkingData]()
    var employmentTypeList = [CommonCheckModel]()
    var filterEmploymentTypeList = [CommonCheckModel]()
    var professionCategoryList = [ProfessionCategory]()
    var filterProfessionCategoryList = [ProfessionCategory]()
    var professionTypeList = [ProfessionType]()
    var filterProfessionTypeList = [ProfessionType]()
    var itemCell = "RadioButtonCell"
    @IBOutlet weak var lblNoDataText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonOnKeyboard(textField: tfSearch)
        switch tag {
        case 0:
            self.filterEmploymentTypeList =  employmentTypeList
        case 1:
            self.filterProfessionCategoryList = professionCategoryList
        case 2:
            self.filterProfessionTypeList =  professionTypeList
        case ConditionConstants.parkingList:
            self.filterBlockList = parkingBlockList
        default:
            break;
        }
        tbvProfession.tag = tag
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tbvProfession.reloadData()
        print("tag",tag)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvProfession.register(nib, forCellReuseIdentifier: itemCell)
        tbvProfession.delegate = self
        tbvProfession.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        VwBlink.isHidden = true
        
        tfSearch.placeholder = doGetValueLanguage(forKey: "search")
        bCancel.setTitle(doGetValueLanguage(forKey: "cancel"), for: .normal)
        bDone.setTitle(doGetValueLanguage(forKey: "done"), for: .normal)
     }
    func doInitSpeechRecogniser(){
                VwBlink.isHidden = true
//                imgClose.image = UIImage.init(named: "mic_off")
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
                        print("defult exicute")
                        break
                    }
        
                    OperationQueue.main.addOperation() {
                        self.microphoneButton.isEnabled = isButtonEnabled
                    }
                }
    }
    @IBAction func onClickClear(_ sender: Any) {
        
        doInitSpeechRecogniser()
    
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            showAlertMsg(title: "", msg: "Needs access to microphone.Tap Settings -> turn on Microphone")
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
      
        VwBlink.isHidden = false
        VwBlink.backgroundColor = ColorConstant.primaryColor
        VwBlink.startBlink()
   
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
        DispatchQueue.main.async { [weak self] in
                
            self!.recognitionTask = self!.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
               
                var isFinal = false
                
                if result != nil {
                    
                    isFinal = (result?.isFinal)!
                    print(result?.bestTranscription.formattedString ?? "")
                    let Str = result?.bestTranscription.formattedString ?? ""
                    self?.fullStr = Str.trimmingCharacters(in: .whitespaces)
                    self?.tfSearch.text = self?.fullStr
                    self?.selectedIndex = nil
                    if self?.tbvProfession.tag == 1 {
                             
                        self?.filterProfessionCategoryList = []
                        self!.filterProfessionCategoryList = self!.fullStr.isEmpty ? self!.professionCategoryList : self!.professionCategoryList.filter({ (item:ProfessionCategory) -> Bool in
                                              
                            return item.categoryIndustry.lowercased().range(of: self!.fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                                          })
                                          
                    } else if self!.tbvProfession.tag == 2 {
                                        
                        self!.filterProfessionTypeList = []
                                          
                        self!.filterProfessionTypeList = self!.fullStr.isEmpty ? self!.professionTypeList : self!.professionTypeList.filter({ (item:ProfessionType) -> Bool in
                                              
                            return item.categoryName.lowercased().range(of: self!.fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                                          })
                                      
                    }
                    self!.tbvProfession.reloadData()
                }
                if error != nil || isFinal {
                   
                    self?.audioEngine.stop()
                    self?.inputNode.removeTap(onBus: 0)
                    self?.recognitionRequest = nil
                    self?.recognitionTask = nil
                    self?.microphoneButton.isEnabled = true
                    recognitionRequest.endAudio()
                 
                 //   imgClose.image = UIImage.init(named: "mic_off")
                    self?.VwBlink.isHidden = true
                        self?.VwBlink.stopBlink()
                    
                }else
                {
                    
                    self?.audioEngine.stop()
                    self?.inputNode.removeTap(onBus: 0)
                    self?.recognitionRequest = nil
                    self?.recognitionTask = nil
                    self?.microphoneButton.isEnabled = false
                    recognitionRequest.endAudio()
                   // tfSearch.text = ""
                  //  imgClose.image = UIImage.init(named: "mic_on")
                    self?.VwBlink.isHidden = false
                    
                }
            })
            
            }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        if inputNode != nil {
            
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        
        }
        }
        // audioEngine.prepare()
        _ = audioEngine.mainMixerNode
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    @IBAction func onClickDone(_ sender: Any) {
        let selectedIndex = tbvProfession.indexPathForSelectedRow
        var uniqueIdentifier = ""
        if selectedIndex != nil{
            switch tbvProfession.tag {
            case 0:
//                print("selected row!",selectedIndex?.row)
                let data = self.filterEmploymentTypeList[(selectedIndex?.row)!]
//                print("tag 0 data",data.id)
                uniqueIdentifier = data.title
            case 1:
                let data = self.filterProfessionCategoryList[selectedIndex!.row]
                uniqueIdentifier = data.categoryId
            case 2:
                let data = self.filterProfessionTypeList[selectedIndex!.row]
                uniqueIdentifier = data.categoryName
            case ConditionConstants.parkingList:
                let data = self.filterBlockList[selectedIndex!.row]
                uniqueIdentifier = data.societyParkingID
            default:
                break;
            }
            self.dismiss(animated: true){
                if self.context != nil{
                    print("unique identifier",uniqueIdentifier)
                    self.context.doInitProfessionTypeArr(tag: self.tag, selectedIndexPath: selectedIndex,identifier: uniqueIdentifier)
                }else if self.OccContext != nil{
                    self.OccContext.doInitProfessionTypeArr(tag: self.tag, selectedIndexPath: selectedIndex,identifier: uniqueIdentifier)
                }else if self.profileCompleteVC != nil{
                    self.profileCompleteVC.doInitProfessionTypeArr(tag: self.tag, selectedIndexPath: selectedIndex,identifier: uniqueIdentifier)
                }
                
                
            }
        }else{
            self.toast(message: "Please Select A Option Form List", type: .Information)
        }
    }
    @objc func textFieldDidChange(textField: UITextField) {

        switch tbvProfession.tag {
        case 0:
            filterEmploymentTypeList = textField.text!.isEmpty ? employmentTypeList : employmentTypeList .filter({ (item:CommonCheckModel) -> Bool in

                return item.title!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        case 1:
            filterProfessionCategoryList = textField.text!.isEmpty ? professionCategoryList : professionCategoryList .filter({ (item:ProfessionCategory) -> Bool in

                return item.categoryIndustry!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        case 2:
            filterProfessionTypeList = textField.text!.isEmpty ? professionTypeList : professionTypeList .filter({ (item:ProfessionType) -> Bool in

                return item.categoryName!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        case ConditionConstants.parkingList:
            filterBlockList = textField.text!.isEmpty ? parkingBlockList : parkingBlockList .filter({ (item:ParkingData) -> Bool in

                return item.socieatyParkingName!.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        default:
            break;
        }
        tbvProfession.reloadData()
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {

        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 120
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func noDataPlaceholderInit(count : Int!){
        if count == 0{
            viewNoData.isHidden = false
        }else{
            viewNoData.isHidden = true
        }
    }
}
extension SelectProfessionVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch tableView.tag {
        case 0:
            count = filterEmploymentTypeList.count
//            print("employmentTypeList count",employmentTypeList.count)
            self.lblNoDataText.text = "No Data Found"
            self.noDataPlaceholderInit(count: count)
            return filterEmploymentTypeList.count
        case 1:
            count = filterProfessionCategoryList.count
//            print("professionCategoryList count",professionCategoryList.count)
            self.noDataPlaceholderInit(count: count)
            self.lblNoDataText.text = "No Data Found"
            return filterProfessionCategoryList.count
        case 2:
            count = filterProfessionTypeList.count
//            print("profession type count",professionTypeList.count)
            self.noDataPlaceholderInit(count: count)
            self.lblNoDataText.text = "No Data Found"
            return filterProfessionTypeList.count
        case ConditionConstants.parkingList:
            count = filterBlockList.count
//            print("parking block count",parkingBlockList.count)
            self.noDataPlaceholderInit(count: count)
            self.lblNoDataText.text = "No Blocks Found"
            return filterBlockList.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvProfession.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! RadioButtonCell
        cell.selectionStyle = .none
        switch tableView.tag {
        case 0:
            let data = filterEmploymentTypeList[indexPath.row]
            cell.lblItemName.text = data.title
            return cell
        case 1:
            let data = filterProfessionCategoryList[indexPath.row]
            cell.lblItemName.text = data.categoryIndustry
            return cell
        case 2:
            let data = filterProfessionTypeList[indexPath.row]
            cell.lblItemName.text = data.categoryName
            return cell
        case ConditionConstants.parkingList:
            let data = filterBlockList[indexPath.row]
            cell.lblItemName.text = data.socieatyParkingName
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
