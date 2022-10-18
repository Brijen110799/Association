//
//  SosAlertVC.swift
//  Finca
//
//  Created by anjali on 30/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import AVFoundation
import Lightbox
class SosAlertVC: UIViewController {
    
    let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: "beep", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var btnOPenImage:UIButton!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSendBy: MarqueeLabel!
    
    @IBOutlet weak var lbDate: UILabel!
    var fcmData:FcmData!
    
    @IBOutlet weak var lbSocityName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if fcmData.society_name != nil {
            lbSocityName.text = "EMERGENCY \n" + fcmData.society_name
        }

        do {
            UIDevice.vibrate_device()
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
            audioPlayer.play()
            audioPlayer.numberOfLoops = 3
        } catch {
            // couldn't load file :(
        }
        lbTitle.text = fcmData.sos_title
        DispatchQueue.main.async {
            self.setupMarqee(label:self.lbSendBy)
            self.lbSendBy.triggerScrollStart()
        }
        lbSendBy.text = fcmData.sos_by
        lbDate.text = fcmData.otime
        if fcmData.sos_image != nil {
            btnOPenImage.isHidden = false
            Utils.setImageFromUrl(imageView: ivImage, urlString: fcmData.sos_image, palceHolder: "fincasys_notext")
        } else {
            btnOPenImage.isHidden = true
            ivImage.image = UIImage(named: "emergency")
            ivImage.setImageColor(color: .black)
        }
        
    }
    func setupMarqee(label : MarqueeLabel) {
        label.type = .continuous
        label.animationCurve = .easeIn
        label.fadeLength = 10.0
        label.leadingBuffer = 0
        label.trailingBuffer = 0
    }
    @IBAction func btnOpenImage(_ sender: UIButton) {
        
        // Create an instance of LightboxController.
        let image = LightboxImage(image:ivImage.image!)
        let controller = LightboxController(images: [image], startIndex: 0)
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        // Present your controller.
        parent?.present(controller, animated: true, completion: nil)
    }
    @IBAction func PianoC(sender: AnyObject) {

    }
    @IBAction func onClickDismis(_ sender: Any) {
        audioPlayer.stop()    
        Utils.setHome()
    }
}
extension UIDevice{
    static func vibrate_device(){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
extension SosAlertVC:LightboxControllerPageDelegate,LightboxControllerDismissalDelegate{
    
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    
}
