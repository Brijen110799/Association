//
//  VoiceSearchVC.swift
//  Finca
//
//  Created by Fincasys Macmini on 11/12/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import Speech
import EzPopup
import FittedSheets
import QuartzCore


class VoiceSearchVC: BaseVC,SFSpeechRecognizerDelegate {
    
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
   
    var context:HomeVC!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        lblsearchtext.text = "Say something..."
        appMenusNew = []
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cornerRadius(view1: btnVoicesearch, radius: 12)
        
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
                microphoneButton.isEnabled = true

           } else {

            microphoneButton.isEnabled = true
            startRecording()
         
           }
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
                        microphoneButton.isEnabled = true
        
                   } else {
        
                    microphoneButton.isEnabled = true
                    startRecording()
                  
                   }
    }
    func doInitSpeechRecogniser(){
        
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
                       microphoneButton.isEnabled = true
    
                  } else {
       
                   microphoneButton.isEnabled = true
                   startRecording()
                  }
        
      }
    @IBAction func TryAgainBtnClick(_ sender: UIButton) {
        
        lblsearchtext.text = "Say something..."
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
                microphoneButton.isEnabled = true

           } else {

            microphoneButton.isEnabled = true
            startRecording()
          
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
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        DispatchQueue.main.async { [weak self] in
                
            self?.recognitionTask = self?.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                var isFinal = false
                
                if result != nil {
                    
                    isFinal = (result?.isFinal)!
                    let Str = result?.bestTranscription.formattedString ?? ""
                    self?.fullStr = Str.trimmingCharacters(in: .whitespaces)
               
                }
                if error != nil || isFinal {
                   
                //    imgClose.setImageColor(color: .white)
                    self?.audioEngine.stop()
                  //  StopPulse()
                    self?.inputNode.removeTap(onBus: 0)
                    self?.recognitionRequest = nil
                    self?.recognitionTask = nil
                 //   self.microphoneButton.isEnabled = true
                    recognitionRequest.endAudio()
                    self?.context.gotoSuggestionMenu(textVoice: self?.fullStr ?? "")
                    
                }else
                {
                    self?.lblsearchtext.text = "Didn't catch that. Try speaking again."
                    self?.audioEngine.stop()
                    self?.inputNode.removeTap(onBus: 0)
                    self?.recognitionRequest = nil
                    self?.recognitionTask = nil
                 //   self.microphoneButton.isEnabled = false
                    recognitionRequest.endAudio()
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
    }
}
