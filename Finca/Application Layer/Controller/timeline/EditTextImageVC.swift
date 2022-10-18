//
//  EditTextImageVC.swift
//  Zoobiz
//
//  Created by zoobiz mac min on 19/05/21.
//

import UIKit

// MARK: - ClassifiedImage :
protocol PassImage {
    func passImage(image:UIImage,strType:String)
}
struct ClassifiedImage {
    var originalImage: UIImage?
    var editedImage: UIImage?
    var isEdit: Bool?
    var numberOfEdit: Int?
    var isOnlyText: Bool?
    var backgroudColorIndex: Int?
//    var bkgGradientBottomColor: String?
    var viewAllSubviews: [UIView]?
}
struct ClassifiedTextDrawer {
    var text: String?
}
// MARK: - ClassifiedImage :

struct GradientColorModel: Codable {
    var topColor, bottomColor, colorType, gradientAngle, colorRadius: String?
}
class EditTextImageVC: BaseVC, UITextViewDelegate {

    // MARK: - IBOutlets & Variable Declaration :
    var ImageSave = UIImage()
    var Delegate:PassImage!
    @IBOutlet weak var viewBackground: GradientView!
    @IBOutlet weak var viewBackgroundText: GradientView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewColorOption: GradientView!
    @IBOutlet weak var txtView: UITextView!
//    @IBOutlet weak var txtView: VerticallyCenteredTextView!

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var viewText: UIView!
    
//    @IBOutlet weak var viewFrame: UIView!
//     @IBOutlet weak var viewDragg: UIView!
//     @IBOutlet weak var imgView: UIImageView!

//    @IBOutlet weak var txtContainer: UIView!
//    @IBOutlet weak var textLabel: UILabel!


    @IBOutlet weak var sliderTextSize: UISlider!
    @IBOutlet weak var btnTextColor: UIButton!
    @IBOutlet weak var btnTextFont: UIButton!
    @IBOutlet weak var imgTextAlignment: UIImageView!
    @IBOutlet weak var viewDelete: UIView!
    
    @IBOutlet weak var contDelete: UIView!
    @IBOutlet weak var imgDelete: UIImageView!
    //@IBOutlet weak var consTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constextViewBottom: NSLayoutConstraint!


    var completion: ((_ image: ClassifiedImage) -> ())?
    var selImg : ClassifiedImage?
    var editIndex : Int?
    
    var bkgColors : [GradientColorModel] = [GradientColorModel(topColor: "#F44336", bottomColor: "#9C27B0", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#00BCD4", bottomColor: "#4CAF50", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#00BCD4", bottomColor: "#3F51B5", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#E91E63", bottomColor: "#FFEB3B", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#2196F3", bottomColor: "#9C27B0", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#FF5722", bottomColor: "#795548", colorType: "linear", gradientAngle: "45", colorRadius: "0"),
      GradientColorModel(topColor: "#9C27B0", bottomColor: "#795548", colorType: "linear", gradientAngle: "45", colorRadius: "0")]
    
//    var textColors = ["#FFFFFF", "#000000", "#2062AF", "#14BCA9", "#F4B528", "#2196F3", "#DD3E48", "#5C88BE", "#59BC10", "#E87034", "#51C1EE", "#707070", "#F84C44", "#8C47FB"]
    var textColors = ["#F44336", "#9C27B0", "#3F51B5", "#03A9F4", "#009688", "#8BC34A", "#FFEB3B", "#FF9800", "#795548", "#607D8B"]
    
//    var textFontTitles = ["Modern", "Typewriter", "Classic", "Strong"]
//    var textFonts = [Static.sharedInstance.font_Modern, Static.sharedInstance.font_Courier_Bold, Static.sharedInstance.font_Roboto_Black, Static.sharedInstance.font_SF_Bold]
    
    var textFontTitles = ["Modern", "Typewriter", "Classic", "Strong", "Cursive", "Comic", "Bubble", "Stencil"]
    var textFonts = [Static.sharedInstance.font_Modern, Static.sharedInstance.font_Courier_Bold, Static.sharedInstance.font_Roboto_Black, Static.sharedInstance.font_SF_Bold, Static.sharedInstance.font_Great_Vibes, Static.sharedInstance.font_Comic, Static.sharedInstance.font_Bubble, Static.sharedInstance.font_Stencil]
    
    var textAlignmentImgs = ["align_center_border", "align_left_border", "align_right_border"]
    var textAlignmentType: [NSTextAlignment] = [.center, .left, .right]
    
    var bkgColorSelIndex = 0
    var txtColorSelIndex = 0
    var txtFontSelIndex = 0
    var txtAlignmentSelIndex = 0

    var isTextEdit = false
    var bottomPadding: CGFloat = 0.0
        
    // MARK: - View Cycle Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        override var contentSize: CGSize {
        //            didSet {
        //                var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        //                topCorrection = max(0, topCorrection)
        //                contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        //            }
        //        }
        
        
//        var topCorrection = (txtView.bounds.size.height - txtView.contentSize.height * txtView.zoomScale) / 2.0
//        topCorrection = max(0, topCorrection)
//        txtView.contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        viewText.isHidden = true
        viewDelete.isHidden = true
        viewText.isHidden = false
        isTextEdit = false
        txtView.placeholder = "Type Here"
        txtView.placeholderColor = #colorLiteral(red: 0.8205339884, green: 0.8205339884, blue: 0.8205339884, alpha: 1)
//        txtView.isScrollEnabled = false
        txtView.textColor = UIColor.white
//        txtView.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        txtView.text = ""
        txtFontSelIndex = 0
        txtColorSelIndex = 0
        txtAlignmentSelIndex = 0
        
        sliderTextSize.value = 20.0
        sliderTextSize.minimumValue = 13.0
        sliderTextSize.maximumValue = 60.0
        
        
        
        if let objImg = selImg {
            if let isEDIT = objImg.isEdit {
                if isEDIT {
                    self.bkgColorSelIndex = objImg.backgroudColorIndex ?? 0
                    if let subviews = objImg.viewAllSubviews {
                        for subview in subviews {
                            if subview.isKind(of: UITextView.self) {
                                if let label: UITextView = subview as? UITextView {
                                    txtView.text = label.text!
                                    txtView.accessibilityLabel = label.accessibilityLabel
                                    txtView.accessibilityIdentifier = label.accessibilityIdentifier
                                    txtView.font = label.font
                                    txtView.textAlignment = label.textAlignment
                                    txtView.textColor = label.textColor
                                    
                                    if let strHint = label.accessibilityHint {
                                        let fistChar = String(strHint.first!)
                                        let secondChar = String(strHint[strHint.index(strHint.startIndex, offsetBy:1)])
                                        let thirdChar = String(strHint[strHint.index(strHint.startIndex, offsetBy:2)])
                                        txtColorSelIndex = Int(fistChar)!
                                        txtFontSelIndex = Int(secondChar)!
                                        txtAlignmentSelIndex = Int(thirdChar)!
                                    }
                                    
                                    if let font = label.font {
                                        sliderTextSize.value = Float(font.pointSize)
                                    }
                                    //                                    sliderTextSize.value = Float(label.font!.pointSize)
                                    self.isTextEdit = true
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        txtView.delegate = self
        doneButtonOnKeyboard(textField: txtView)
//        addKeyboardAccessory(textViews: [txtView])
        
        self.setupNewBackgroundColor()
        self.setupTextCaptionColors()
        self.setupTextFont()
        self.setupTextAlignment()
       
//        txtView.backgroundColor = .black
//        self.txtView.becomeFirstResponder()

    }
    
    override func viewDidLayoutSubviews() {

//        var topCorrection = (txtView.bounds.size.height - txtView.contentSize.height * txtView.zoomScale) / 2.0
//        topCorrection = max(0, topCorrection)
//        txtView.contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        
//        let height =  viewMain.frame.size.height - 10
//        if txtView.contentSize.height > height {
//            // consTextViewHeight.constant = height
//        }
//        else {
//            // consTextViewHeight.constant = txtView.contentSize.height
//        }
        
        txtView.centerVerticalText()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
//        self.scrollview.contentInset = contentInsets
//        self.scrollview.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
       // bottomPadding = keyboardSize.height - CGFloat(75.0)
        constextViewBottom.constant = keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
//        self.scrollview.contentInset = contentInsets
//        self.scrollview.scrollIndicatorInsets = contentInsets
        constextViewBottom.constant = 10
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.txtView.centerVerticalText()
        }
    }
    
    // MARK: - Other functions:
    
    func addAllGesturesInView(view: UIView) {

//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(gesture:)))
//        panGesture.delegate = self
//        view.addGestureRecognizer(panGesture)
//
//        let rotationGesture = UIRotationGestureRecognizer(target: self, action:#selector(self.handleRotationGesture(gesture:)))
//        rotationGesture.delegate = self
//        view.addGestureRecognizer(rotationGesture)
//
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(self.handlePinchGesture(gesture:)))
//        pinchGesture.delegate = self
//        view.addGestureRecognizer(pinchGesture)
        
//        if view.tag == 10 {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handletapGesture(gesture:)))
////            tapGesture.delegate = self
//            view.addGestureRecognizer(tapGesture)
//        }
        viewMain.addSubview(view)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func setupNewBackgroundColor() {
        
//        bkgColorSelIndex += 1
        if bkgColorSelIndex >= bkgColors.count {
            bkgColorSelIndex = 0
        }
        
        self.viewBackground.topColor = hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].topColor!)
        self.viewBackground.bottomColor = hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].bottomColor!)
        self.viewBackground.layoutSubviews()
        
        self.viewBackgroundText.topColor = hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].topColor!)
        self.viewBackgroundText.bottomColor = hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].bottomColor!)
        self.viewBackgroundText.layoutSubviews()
        
        var nextInd = bkgColorSelIndex + 1
        if nextInd >= bkgColors.count {
            nextInd = 0
        }
        self.viewColorOption.topColor = hexStringToUIColor(hex: bkgColors[nextInd].topColor!)
        self.viewColorOption.bottomColor = hexStringToUIColor(hex: bkgColors[nextInd].bottomColor!)
        self.viewColorOption.layoutSubviews()
        
//        viewText.isHidden = false
//        isTextEdit = false
//        txtView.placeholder = "Type Here"
//        txtView.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        txtView.text = ""
//        txtFontSelIndex = 0
//        txtColorSelIndex = 0
//        txtAlignmentSelIndex = 0
//
//        sliderTextSize.value = 18.0
//        sliderTextSize.minimumValue = 10.0
//        sliderTextSize.maximumValue = 58.0
//
//        self.setupTextCaptionColors()
//        self.setupTextFont()
//        self.setupTextAlignment()

    }
    
//    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
//
//        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
//        let cropped:UIImage = UIImage(cgImage:imageRef)
//        return cropped
//    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        
        let imageViewScale = max(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
//    func cropImage(image: UIImage, toRect: CGRect) -> UIImage? {
//        // Cropping is available trhough CGGraphics
//        let cgImage :CGImage! = image.cgImage
//        let croppedCGImage: CGImage! = cgImage.cropping(to: toRect)
//
//        return UIImage(cgImage: croppedCGImage)
//    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true, view: UIView) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? view.bounds).image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        txtView.text = "Type Here"
//        if textView == txtView {
//            if textView.text == "Type Here" {
//                textView.text = ""
//            }
//            constextViewBottom.constant = bottomPadding
 //           viewDidLayoutSubviews()
//
//            txtView.updateConstraints()
//        }
        txtView.centerVerticalText()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtView.centerVerticalText()
        
//        if textView == txtView {
//            if textView.text.replacingOccurrences(of: " ", with: "") == "" {
//                textView.text = "Type Here"
////                txtView.isScrollEnabled = false
//            }
//            constextViewBottom.constant = 10.0
//            self.sliderTextSize.value = self.sliderTextSize.value + 1
//            self.moveSlider(self.sliderTextSize)
            
//            viewDidLayoutSubviews()
//            let val = sliderTextSize.value + 1.0
//            txtView.font = UIFont(name: textFonts[txtFontSelIndex], size: CGFloat(val))
//            txtView.contentSize = CGSize(width: txtView.contentSize.width, height: txtView.contentSize.height + 1)

  //      }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtView {
            let maxLength = 350
            let currentString: NSString = (textView.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView == txtView {
//            if textView.text.count > 25 {
//                txtView.isScrollEnabled = true
//            }
//        }
//    }
    
    // MARK: - Button Actions:
    
    /*
     func handlePan(recognizer: UIPanGestureRecognizer) {
         let translation = recognizer.translationInView(view)
         if let view = recognizer.view {
             view.center = CGPoint(x:view.center.x + translation.x,
                 y:view.center.y + translation.y)
         }
         recognizer.setTranslation(CGPointZero, inView: view)
     }

     func handlePinch(recognizer: UIPinchGestureRecognizer) {
         if let view = recognizer.view as? UILabel {
             let pinchScale: CGFloat = recognizer.scale
             view.transform = CGAffineTransformScale(view.transform, pinchScale, pinchScale)
             recognizer.scale = 1.0
         }
     }

     func handleRotate(recognizer: UIRotationGestureRecognizer) {
         if let view = recognizer.view as? UILabel {
             let rotation: CGFloat = recognizer.rotation
             view.transform = CGAffineTransformRotate(view.transform, rotation)
             recognizer.rotation = 0.0
         }
     }
     */
    
    @objc func handlePinchGesture(gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed{
            print("UIPinchGestureRecognizer")
//            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: gesture.scale, y: gesture.scale)
//            gesture.scale = 1.0
            
//            gesture.view?.transform = (gesture.view?.transform)!.rotated(by: rotationGesture.rotation)
//            rotationGesture.rotation = 0
            
            if let gestureview = gesture.view {
                let pinchScale: CGFloat = gesture.scale
                gestureview.transform = gestureview.transform.scaledBy(x: pinchScale, y: pinchScale)
                gesture.scale = 1.0
            }
        }
    }

    @objc func handleRotationGesture(gesture: UIRotationGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            print("UIRotationGestureRecognizer")
            //            gesture.view?.transform = (gesture.view?.transform)!.rotated(by: gesture.rotation)
            //            gesture.rotation = 0
            //
            //            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
            //            pinchGesture.scale = 1.0
            
            if let gestureview = gesture.view {
                let rotation: CGFloat = gesture.rotation
                gestureview.transform = gestureview.transform.rotated(by: rotation)
                gesture.rotation = 0.0
            }
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            //print("UIPanGestureRecognizer")
            if let gestureview = gesture.view {
                let translation = gesture.translation(in: viewMain)
                gestureview.transform = gestureview.transform.translatedBy(x: translation.x, y: translation.y)
                gesture.setTranslation(CGPoint(x: 0, y: 0), in: viewMain)
                
//                switch recognizer.state {
//                  case .began, .changed:
//                      imgView.layer.transform = CATransform3DMakeTranslation(translation.x, translation.y, 0)
//                      // OR
//                      // imgView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
//                  case .ended:
//                      if deleteIcon.frame.intersects(imgView.layer.frame) {
//                          animateDelete()
//                      } else {
//                          moveBack()
//                      }
                
            }
        }
    }
    
    @objc func draggedView(gesture:UIPanGestureRecognizer) {
//            viewMain.bringSubviewToFront(gesture.view!)
//            let translation = gesture.translation(in: viewMain)
//            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + translation.x, y: (gesture.view?.center.y)! + translation.y)
//            gesture.setTranslation(CGPoint.zero, in: self.viewMain)

        if let gestureview = gesture.view {
            //            if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            
//            print(gestureview.tag)
            let translation = gesture.translation(in: viewMain)
            gestureview.center = CGPoint(x: gestureview.center.x + translation.x, y: gestureview.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: viewMain)
            
            if gestureview.tag == 10 {
                if  gestureview.isKind(of: UILabel.self) {
                    
                    var isGoforDeleteAtEnd = false
                    if viewDelete.frame.intersects(gestureview.layer.frame) {
                        viewDelete.isHidden = false
                        isGoforDeleteAtEnd = true
                        contDelete.borderColor = ColorConstant.red400
                            //UIColor(named: ColorConstant.red400)
                        imgDelete.imageTintColor = ColorConstant.red400
                            //UIColor(named: ColorConstant.red400)

                        if let label : UILabel = gestureview as? UILabel {
                            label.textColor = ColorConstant.red400
                                //UIColor(named: ColorConstant.red400)
                        }
                    } else {
                        viewDelete.isHidden = false
                        isGoforDeleteAtEnd = false
                        contDelete.borderColor = UIColor.white
                        imgDelete.imageTintColor = UIColor.white
                        
                        if let label : UILabel = gestureview as? UILabel {
                            if let hextcode = label.accessibilityLabel {
                                label.textColor = hexStringToUIColor(hex: hextcode)
                            }
                        }
                    }
                    
                    if gesture.state == .ended {
                        if isGoforDeleteAtEnd {
                            UIView.animate(withDuration: 0.3) {
                                gestureview.alpha = 0
                            } completion: { (completed) in
                                gestureview.removeFromSuperview()
                                self.viewDelete.isHidden = true
                            }
                        } else {
                            self.viewDelete.isHidden = true
                        }
                    }
                    
                }
            }
            else {
                self.viewDelete.isHidden = true
            }
            //            }
        }
//            let location = gesture.location(in: self.viewMain)
//            gesture.view?.center = location
//        }
    }
    
    @objc func handletapGesture(gesture: UITapGestureRecognizer) {
        
//        if gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed {
            print("UITapGestureRecognizer")
//            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: gesture.scale, y: gesture.scale)
//            gesture.scale = 1.0
            
//            gesture.view?.transform = (gesture.view?.transform)!.rotated(by: rotationGesture.rotation)
//            rotationGesture.rotation = 0
            
            if let gestureview = gesture.view {
                if let label : UILabel = gestureview as? UILabel {
                    
                    txtView.text = label.text!
                    txtView.accessibilityLabel = label.accessibilityLabel
                    txtView.accessibilityIdentifier = label.accessibilityIdentifier
                    txtView.font = label.font
                    txtView.textAlignment = label.textAlignment
                    txtView.textColor = label.textColor
                    if let strHint = label.accessibilityHint {
                        let fistChar = String(strHint.first!)
                        let secondChar = String(strHint[strHint.index(strHint.startIndex, offsetBy:1)])
                        let thirdChar = String(strHint[strHint.index(strHint.startIndex, offsetBy:2)])
                        txtColorSelIndex = Int(fistChar)!
                        txtFontSelIndex = Int(secondChar)!
                        txtAlignmentSelIndex = Int(thirdChar)!
                    }
                    
                    sliderTextSize.value = Float(label.font.pointSize)
                    self.setupTextCaptionColors()
                    self.setupTextFont()
                    self.setupTextAlignment()
                    self.isTextEdit = true
                    self.viewText.isHidden = false
                    
//                    let input = "Swift Tutorials"
//                    let char = input[input.index(input.startIndex, offsetBy: 3)]
                    
//                    label.accessibilityHint = "\(txtColorSelIndex)\(txtFontSelIndex)\(txtAlignmentSelIndex)"


                }
                
//                let pinchScale: CGFloat = gesture.scale
//                gestureview.transform = gestureview.transform.scaledBy(x: pinchScale, y: pinchScale)
//                gesture.scale = 1.0
            }
//        }
    }
    
    
    @IBAction func btnBackgroundColor(_ sender: Any) {
        self.bkgColorSelIndex += 1
        self.setupNewBackgroundColor()
    }
    
    @IBAction func btnTextEdit(_ sender: Any) {
        viewText.isHidden = false
        isTextEdit = false
        //txtView.text = "Type Here"
        //txtView.textColor = UIColor.white

//        txtView.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        txtView.text = ""
        txtFontSelIndex = 0
        txtColorSelIndex = 0
        txtAlignmentSelIndex = 0
        
        sliderTextSize.value = 20.0
        sliderTextSize.minimumValue = 13.0
        sliderTextSize.maximumValue = 60.0
        
        self.setupTextCaptionColors()
        self.setupTextFont()
        self.setupTextAlignment()
    }


    @IBAction func btnBack(_ sender: Any) {
      doPopBAck()
    }
    
    @IBAction func btnSave(_ sender: Any)  {
        saveText()
    }
    func convertToimg(with view: UIView) -> UIImage? {
          UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
          defer { UIGraphicsEndImageContext() }
          if let context = UIGraphicsGetCurrentContext() {
              view.layer.render(in: context)
              let image = UIGraphicsGetImageFromCurrentImageContext()
              
              return image
          }
          return nil
      }
    func saveText() {
        viewMain.cornerRadius = 0
        if let image = convertToimg(with: viewMain) {
//            self.selImg?.editedImage = image
            viewMain.cornerRadius = 10

            
            var allSubviews = [UIView]()
            for subview in viewMain.subviews {
                // print(subview.tag)
                if !(subview.tag == 2) {
                    allSubviews.append(subview)
                }
            }
            
            if var selImgObj = self.selImg {
                selImgObj.editedImage = image
                selImgObj.isEdit = true
                selImgObj.numberOfEdit =  selImgObj.numberOfEdit! + 1
                selImgObj.viewAllSubviews = allSubviews
                selImgObj.backgroudColorIndex = bkgColorSelIndex
//                selImgObj.bkgGradientTopColor = ""
//                selImgObj.bkgGradientBottomColor = ""
                self.completion!(selImgObj)
            }
            else {
                
//                self.viewBackground.topColor = Utils.hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].topColor!)
//                self.viewBackground.bottomColor = Utils.hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].bottomColor!)
//                let hexStrTop = bkgColors[bkgColorSelIndex].topColor ?? ""
//                let hexStrBottom = bkgColors[bkgColorSelIndex].bottomColor ?? ""
                
                let imgObj = ClassifiedImage(originalImage: nil, editedImage: image, isEdit: true, numberOfEdit: 1, isOnlyText: true, backgroudColorIndex: bkgColorSelIndex, viewAllSubviews: allSubviews)
//                let imgObj = ClassifiedImage(originalImage: nil, editedImage: image, isEdit: true, numberOfEdit: 1, isOnlyText: true, viewAllSubviews: viewMain.subviews)
                self.completion!(imgObj)
            }

//            let cgimage = image.cgImage!
//            let contextImage: UIImage = UIImage(cgImage: cgimage)
//            let contextSize: CGSize = contextImage.size
//            let posX: CGFloat = 10.0
//            let posY: CGFloat = ((contextSize.height - (contextSize.width - 20.0)) / 2.0)
//            let cgwidth: CGFloat = contextSize.width - 20.0
//            let cgheight: CGFloat = contextSize.width - 20.0
            
//            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
//            let imageRef: CGImage = cgimage.cropping(to: rect)!
//            // Create a new image based on the imageRef and rotate back to the original orientation
//            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
//            self.completion!(image)

        }
       
        doPopBAck()
    }
    
}

//MARK:- UIGestureRecognizerDelegate Methods

extension EditTextImageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UITextView {

    func centerVerticalText() {
       // self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}

//extension EditTextImageVC: UITextViewDelegate {
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
//                textView.textColor = UIColor.black
//            }
//        }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Type Here"
//            textView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        }
//    }
//
//}

// TEXT VIEW :
extension EditTextImageVC {
    
    func setupTextCaptionColors() {
        
        if txtColorSelIndex >= textColors.count {
            txtColorSelIndex = 0
        }
//        txtView.textColor = Utils.hexStringToUIColor(hex: textColors[txtColorSelIndex])
        txtView.textColor = UIColor.white

        var nextInd = txtColorSelIndex + 1
        if nextInd >= textColors.count {
            nextInd = 0
        }
        
        btnTextColor.backgroundColor = hexStringToUIColor(hex: textColors[nextInd])
        
    }
    
    func setupTextFont() {
        
        if txtFontSelIndex >= textFontTitles.count {
            txtFontSelIndex = 0
        }
        txtView.font = UIFont(name: textFonts[txtFontSelIndex], size: CGFloat(sliderTextSize.value))
        
        var nextInd = txtFontSelIndex + 1
        if nextInd >= textFontTitles.count {
            nextInd = 0
        }
        
        btnTextFont.titleLabel?.font = UIFont(name: textFonts[nextInd], size: 15.0)
       // btnTextFont.setTitle(textFontTitles[nextInd], for: .normal)
        btnTextFont.setTitle("T", for: .normal)
        
    }
    
    func setupTextAlignment() {
        
        if txtAlignmentSelIndex >= textAlignmentType.count {
            txtAlignmentSelIndex = 0
        }
        txtView.textAlignment = textAlignmentType[txtAlignmentSelIndex]
        var nextInd = txtAlignmentSelIndex + 1
        if nextInd >= textAlignmentImgs.count {
            nextInd = 0
        }
        
        imgTextAlignment.image = UIImage(named: textAlignmentImgs[nextInd] )
        
    }
    
    
    @IBAction func btnTextAlignmentTextView(_ sender: Any) {
        txtAlignmentSelIndex += 1
        setupTextAlignment()
    }
    
    
    @IBAction func btnFontTextView(_ sender: Any) {
        txtFontSelIndex += 1
        setupTextFont()
    }
    
    @IBAction func btnColorTextView(_ sender: Any) {
        txtColorSelIndex += 1
        setupTextCaptionColors()
    }


    @IBAction func btnBackText(_ sender: Any) {
//        viewText.isHidden = true
//        doPopBack()
        
        if txtView.text.replacingOccurrences(of: " ", with: "") == "" || txtView.text == "Type Here" {
            doPopBAck()
        } else {
            //self.showAppDialog(delegate: self, dialogTitle: "Save Changes ?", dialogMessage: "", index: 0, title: "SAVE", type: "CANCEL_ACTION_HANDLER", cancelTitle: "DISCARD")
            
            //self.showAppDialog(delegate: self, dialogTitle: "save Changes ?", dialogMessage: "", style: .Info)
            doPopBAck()
        }
    }
    
    @IBAction func btnDoneTextView(_ sender: Any)  {
        self.txtView.resignFirstResponder()
        
        /*
        if self.isTextEdit {            
            for subview in viewMain.subviews {
                if subview.tag == 10 {
                    if subview.isKind(of: UILabel.self) {
                        if let label : UILabel = subview as? UILabel {
                            if let labelID = label.accessibilityIdentifier {
                                let textID = self.txtView.accessibilityIdentifier ?? ""
                                if labelID == textID {
                                    label.text =  self.txtView.text!
                                    label.textAlignment = self.txtView.textAlignment
                                    label.textColor = Utils.hexStringToUIColor(hex: textColors[txtColorSelIndex])
                                    label.font = UIFont(name: textFonts[txtFontSelIndex], size: CGFloat(sliderTextSize.value))
                                    label.sizeToFit()
                                    label.accessibilityLabel = textColors[txtColorSelIndex]
                                    label.accessibilityHint = "\(txtColorSelIndex)\(txtFontSelIndex)\(txtAlignmentSelIndex)"
                                    label.sizeToFit()
//                                    self.addAllGesturesInView(view: label)
//                                    subview.removeFromSuperview()
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            let label = UILabel()
            label.isUserInteractionEnabled = true
            label.numberOfLines = 0
            label.text =  self.txtView.text!
            label.textAlignment = self.txtView.textAlignment
            label.textColor = Utils.hexStringToUIColor(hex: textColors[txtColorSelIndex])
            label.font = UIFont(name: textFonts[txtFontSelIndex], size: CGFloat(sliderTextSize.value))
            label.sizeToFit()
            label.tag = 10
            label.accessibilityLabel = textColors[txtColorSelIndex]
            label.accessibilityIdentifier = "\(viewMain.subviews.count + 1)"
            label.accessibilityHint = "\(txtColorSelIndex)\(txtFontSelIndex)\(txtAlignmentSelIndex)"
            
            var lblWidth: CGFloat = label.frame.size.width
            if lblWidth > viewMain.frame.size.width {
                lblWidth = viewMain.frame.size.width
                label.frame.size.width = lblWidth
                label.sizeToFit()
            }
            
            let lblHeight: CGFloat = label.frame.size.height
            let posY: CGFloat = (viewMain.frame.size.height - lblHeight) / 2
            let posx: CGFloat = (viewMain.frame.size.width - lblWidth) / 2
            label.frame = CGRect(x:posx, y: posY, width: lblWidth, height: lblHeight)
            
            self.addAllGesturesInView(view: label)
            
        }
        isTextEdit = false
        txtView.text = ""
        viewText.isHidden = true
        
        */
        
        if !(txtView.text.replacingOccurrences(of: " ", with: "") == "" || txtView.text == "Type Here") {
            
            viewMain.cornerRadius = 0
            self.txtView.accessibilityHint = "\(txtColorSelIndex)\(txtFontSelIndex)\(txtAlignmentSelIndex)"
            if let image = convertToimg(with: viewMain) {
                ImageSave = image
                viewMain.cornerRadius = 10
                var allSubviews = [UIView]()
                for subview in viewMain.subviews {
                    // print(subview.tag)
                    if !(subview.tag == 2) {
                        allSubviews.append(subview)
                    }
                }
                
                //            if var selImgObj = self.selImg {
                //                selImgObj.editedImage = image
                //                selImgObj.isEdit = true
                //                selImgObj.numberOfEdit =  selImgObj.numberOfEdit! + 1
                //                selImgObj.viewAllSubviews = allSubviews
                //                selImgObj.backgroudColorIndex = bkgColorSelIndex
                ////                selImgObj.bkgGradientTopColor = ""
                ////                selImgObj.bkgGradientBottomColor = ""
                //                self.completion!(selImgObj)
                //            }
                //            else {
                
                //                self.viewBackground.topColor = Utils.hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].topColor!)
                //                self.viewBackground.bottomColor = Utils.hexStringToUIColor(hex: bkgColors[bkgColorSelIndex].bottomColor!)
                //                let hexStrTop = bkgColors[bkgColorSelIndex].topColor ?? ""
                //                let hexStrBottom = bkgColors[bkgColorSelIndex].bottomColor ?? ""
                
                
             /*   if var selImgObj = self.selImg {
                    selImgObj.editedImage = image
                    selImgObj.isEdit = true
                    selImgObj.numberOfEdit =  selImgObj.numberOfEdit! + 1
                    selImgObj.viewAllSubviews = allSubviews
                    selImgObj.backgroudColorIndex = bkgColorSelIndex
                    self.completion!(selImgObj)
                }
                else {
                    let imgObj = ClassifiedImage(originalImage: nil, editedImage: image, isEdit: true, numberOfEdit: 1, isOnlyText: true, backgroudColorIndex: bkgColorSelIndex, viewAllSubviews: allSubviews)
                    self.completion!(imgObj)
                }
 */
            }
            Delegate.passImage(image: ImageSave, strType: "EditTextImage")
           doPopBAck()
        }
    }
    
    @IBAction func moveSlider(_ sender: UISlider) {
//        txtView.font = UIFont(name: Static.sharedInstance.zoobiz_font_regular, size: CGFloat(sender.value))
        txtView.font = UIFont(name: textFonts[txtFontSelIndex], size: CGFloat(sender.value))
       // self.viewDidLayoutSubviews()

//        let trackRect = sender.trackRect(forBounds: sender.frame)
//        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
//        self.sliderLabel.center = CGPoint(x: thumbRect.midX, y: self.sliderLabel.center.y)
//        self.sliderLabel.text = "\(Int(sender.value))"

    }
    
}

extension EditTextImageVC: AppDialogDelegate {
    func btnAgreeClicked(dialogType: DialogStyle, tag: Int) {
        
    }
    
    
    func btnAgreeClicked(index: Int, type: String) {
        dismiss(animated: true) {
            self.saveText()
//            self.viewMain.cornerRadius = 0
//            if let image = Utils.convertToimg(with: self.viewMain) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//            self.doPopBack()
        }
    }
    
    func btnCancelClicked() {
        dismiss(animated: true) {
            self.doPopBAck()
        }
    }
}


class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
