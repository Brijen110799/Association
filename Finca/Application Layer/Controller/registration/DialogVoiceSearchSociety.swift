//
//  DialogVoiceSearchSociety.swift
//  Finca
//
//  Created by Fincasys Macmini on 27/01/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import Speech
import EzPopup
import FittedSheets
import QuartzCore

class DialogVoiceSearchSociety: BaseVC,SFSpeechRecognizerDelegate  {
    
    @IBOutlet weak var VwMain:UIView!
    @IBOutlet weak var VwAnimate:UIView!
    @IBOutlet weak var btnVoicesearch:UIButton!
    @IBOutlet weak var lblsearchtext:UILabel!
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    @IBOutlet weak var microphoneButton: UIButton!
    var fullStr = ""
    var appMenus = [MenuModel]()
    var appMenusNew = [MenuModel]()
   
    var context:SocietyVC!
    var societyArray = [ModelSociety]()
    var filterSocietyArrayNew = [ModelSociety]()

    override func viewDidLoad() {
        super.viewDidLoad()

        lblsearchtext.text = "Say something..."
        filterSocietyArrayNew = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // cornerRadius(view1: btnVoicesearch, radius: 12)
        
       /* switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            showAlertMsg(title: "", msg: "Fincasys needs access to microphone.Tap Settings -> turn on Microphone")
            return
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        @unknown default: break

        }
        if audioEngine.isRunning {
               audioEngine.stop()
                recognitionRequest?.endAudio()
                microphoneButton.isEnabled = true

           } else {

            microphoneButton.isEnabled = true
            startRecording()
            
           }*/
        setupSpeech()
    }
    func cornerRadius(view1: UIView, radius: CGFloat = 10) {
        view1.layer.cornerRadius = radius
        showAnimation()
    }
    func showAnimation() {
        let pulse = PulseAnimation(numberOfPulse: Float.infinity, radius: 50, postion: VwAnimate.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = #colorLiteral(red: 0.05282949957, green: 0.5737867104, blue: 1, alpha: 1)
        VwMain.layer.insertSublayer(pulse, below: VwAnimate.layer)
    }
    func popDismiss()
    {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func VoiceSearchCancelBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func VoiceSearchBtnClick(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = true
            startAudioRecording()
        }
    }
   
    @IBAction func TryAgainBtnClick(_ sender: UIButton) {
        
      
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = true
        } else {
           // microphoneButton.isEnabled = true
            startAudioRecording()
            
            
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
        
        DispatchQueue.main.async {
            //[weak self] in
                
            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
               
                var isFinal = false
                
                if result != nil {
                    
                    isFinal = (result?.isFinal)!
                    print(result?.bestTranscription.formattedString ?? "")
                    let Str = result?.bestTranscription.formattedString ?? ""
                    print(Str)
                    self.fullStr = Str.trimmingCharacters(in: .whitespaces)
                  
                    self.filterSocietyArrayNew = (self.fullStr.isEmpty) ? self.societyArray : self.societyArray.filter({ (item:ModelSociety) -> Bool in
                        
                        return item.society_name.lowercased().range(of: self.fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
                    })
                    
                }
                
                if error != nil || isFinal {
                    
                    self.audioEngine.stop()
                    if self.inputNode != nil
                    {
                        self.inputNode.removeTap(onBus: 0)
                    }
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    recognitionRequest.endAudio()
                    if (self.filterSocietyArrayNew.count) > 0
                    {
                        self.context.gotoSuggestionMenu(textVoice: self.filterSocietyArrayNew)
                    }else
                    {
                        self.lblsearchtext.text = "try Again..."
                    }
                    
                    
                }else
                {
                    
                    self.audioEngine.stop()
                    if self.inputNode != nil
                    {
                        self.inputNode.removeTap(onBus: 0)
                    }
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.microphoneButton.isEnabled = false
                    recognitionRequest.endAudio()

                }
            })
            
            }
        if inputNode != nil
        {
            let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
                //inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
        }
        
        
        }
       _ = audioEngine.mainMixerNode
        //prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    
    /// this is new code done
    
    func setupSpeech() {

            self.btnVoicesearch.isEnabled = false
            self.speechRecognizer?.delegate = self

            SFSpeechRecognizer.requestAuthorization { (authStatus) in

                var isButtonEnabled = false

                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    self.startAudioRecording()
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    self.showAlertMsg(title: "", msg: "My Association needs access to microphone.Tap Settings -> turn on Microphone")
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    self.showAlertMsg(title: "", msg: "My Association needs access to microphone.Tap Settings -> turn on Microphone")
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                @unknown default:
                    self.btnVoicesearch.isEnabled = false
                }

                OperationQueue.main.addOperation() {
                    self.btnVoicesearch.isEnabled = isButtonEnabled
                }
            }
        }

    func startAudioRecording() {

           // Clear all previous session data and cancel task
           if recognitionTask != nil {
               recognitionTask?.cancel()
               recognitionTask = nil
           }

           // Create instance of audio session to record voice
           let audioSession = AVAudioSession.sharedInstance()
           do {
               try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
               try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
           } catch {
               print("audioSession properties weren't set because of an error.")
           }

           self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

           let inputNode = audioEngine.inputNode
            audioEngine.inputNode.removeTap(onBus: 0)
           guard let recognitionRequest = recognitionRequest else {
               fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
           }

           recognitionRequest.shouldReportPartialResults = true

           self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

               var isFinal = false
               var string = ""
               if result != nil {
                //self.doFilterData(text: result?.bestTranscription.formattedString ?? "")
                  // self.lblText.text = result?.bestTranscription.formattedString
                
                   isFinal = (result?.isFinal)!
                string = result?.bestTranscription.formattedString ?? ""
                self.goToReturn(text: string)
               }

               if error != nil || isFinal {

                   self.audioEngine.stop()
                   inputNode.removeTap(onBus: 0)

                   self.recognitionRequest = nil
                   self.recognitionTask = nil

                   self.btnVoicesearch.isEnabled = true
               // self.goToReturn(text: string)
                
                
               }
           })

           let recordingFormat = inputNode.outputFormat(forBus: 0)
           inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
               self.recognitionRequest?.append(buffer)
           }

           self.audioEngine.prepare()

           do {
               try self.audioEngine.start()
           } catch {
               print("audioEngine couldn't start because of an error.")
           }

           //self.lblText.text = "Say something, I'm listening!"
       }
    
    
    private func doFilterData(text  : String ) {
        print("doFilterData   \(text)")
        
        self.filterSocietyArrayNew = (text.isEmpty) ? self.societyArray : self.societyArray.filter({ (item:ModelSociety) -> Bool in
            
            return item.society_name.lowercased().range(of: self.fullStr, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
      //  goToReturn()
    }
    
    func goToReturn(text : String) {
//        if (self.filterSocietyArrayNew.count) > 0 {
//            self.dismiss(animated: true, completion: {
//                self.context.gotoSuggestionMenu(textVoice: self.filterSocietyArrayNew)
//            })
//        }else{
//            self.lblsearchtext.text = "try Again..."
//        }
        audioEngine.stop()
        print("goToReturn \(text)")
        dismiss(animated: true, completion: {
            self.context.doReturnVoiceText(text: text)
        })
        
    }

}
