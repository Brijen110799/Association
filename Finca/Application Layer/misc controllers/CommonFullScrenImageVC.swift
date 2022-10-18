//
//  CommonFullScrenImageVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 19/03/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class CommonFullScrenImageVC: BaseVC , UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var imgback: UIImageView!
    @IBOutlet weak var btnback: UIButton!
    var iscomefrom = ""
   // @IBOutlet weak var hConImage: NSLayoutConstraint!
       @IBOutlet weak var scrollview: UIScrollView!
       @IBOutlet weak var ivImage: UIImageView!
      
    @IBOutlet weak var viewDownload: UIView!
    var imagePath = ""
    var isShowDownload = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.delegate = self
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 6.0
        Utils.setImageFromUrl(imageView:ivImage , urlString: imagePath)
        viewDownload.isHidden = true
        if isShowDownload != ""{
            viewDownload.isHidden = false
        }
        
        if iscomefrom == "vehicle"
        {
            self.imgback.image = UIImage.init(named: "cancel_white")
        }
        else{
            self.imgback.image = UIImage.init(named: "back_white")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if ivImage.image == nil {
//            return
//        }
//        let ratio = ivImage.image!.size.width / ivImage.image!.size.height
//        let newHeight = ivImage.frame.width / ratio
       // hConImage.constant = newHeight
        
    }
  
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ivImage
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        
        if iscomefrom == "vehicle"
        {
            self.dismiss(animated: true)
        }
        else{
            doPopBAck()
        }
       
    }

    @IBAction func tapDownload(_ sender: Any) {
        if let image = ivImage.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            toast(message: "Image saved to photos", type: .Success)
        } else {
            toast(message: "Download Failed", type: .Faliure)
        }
       
        
    }
}
