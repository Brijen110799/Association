//
//  NoticcWebvw.swift
//  Finca
//
//  Created by Fincasys Macmini on 29/10/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import WebKit
class NoticcWebvw: BaseVC , WKNavigationDelegate{
    
    @IBOutlet weak var lbltitle : UILabel!
    @IBOutlet weak var viewWebviews: UIView!
    var webView : WKWebView!
    var strUrl:String!
    var strNoticetitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        lbltitle.text = strNoticetitle
        let url = URL(string: strUrl)
        let myRequest = URLRequest(url: url!)
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        //self.webView.scrollView.delegate = self
        webView.load(myRequest)
        self.viewWebviews.addSubview(webView)
        self.viewWebviews.sendSubviewToBack(webView)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgress()
        print(error)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgress()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
        
    }
    @IBAction func onClickPrint(_ sender: Any) {
      //  Priner()
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    func Priner() {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "Invoice Print"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = false
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = self.viewWebviews.toImages()
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }

}
extension UIView {
    func toImages() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
