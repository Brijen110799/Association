//
//  InvoiceVC.swift
//  Finca
//
//  Created by anjali on 31/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import WebKit
class InvoiceVC: BaseVC , WKNavigationDelegate, WKScriptMessageHandler{
  
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewWebview: UIView!
    var webView : WKWebView!
    var strUrl:String!
    var isComeFrom = ""
    var filePath = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isComeFrom == "chat" {
            lbTitle.text = ""
        }
      
        let url = URL(string: strUrl)
        
        
        let myRequest = URLRequest(url: url!)
        //print("url" , url)
      //  webView = WKWebView(frame: self.view.frame)
        
        let configuration = WKWebViewConfiguration()
        let script = WKUserScript(source: "window.print = function() { window.webkit.messageHandlers.print.postMessage('print') }", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        configuration.userContentController.add(self, name: "print")
      
        webView = WKWebView(frame:viewWebview.bounds,configuration: configuration)
        webView.configuration.preferences.javaScriptEnabled = true
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webView.contentMode = .scaleAspectFit
        webView.navigationDelegate = self
        //self.webView.scrollView.delegate = self
        webView.load(myRequest)
        self.viewWebview.addSubview(webView)
        self.viewWebview.sendSubviewToBack(webView)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "print" {
                //printCurrentPage()
                Priner()
            } else {
               // println("Some other message sent from web page...")
            }
    }
    func printCurrentPage() {
//        let printController = UIPrintInteractionController.shared
//        let printFormatter = self.webView.viewPrintFormatter()
//        printController.printFormatter = printFormatter
//
//        let completionHandler: UIPrintInteractionController.CompletionHandler = { (printController, completed, error) in
//            if !completed {
//                if let e = error {
//                   // println("[PRINT] Failed: \(e.domain) (\(e.code))")
//                } else {
//                   // println("[PRINT] Canceled")
//                }
//            }
//        }
//
//        if let controller = printController {
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                controller.presentFromBarButtonItem(someBarButtonItem, animated: true, completionHandler: completionHandler)
//            } else {
//                controller.present(animated: true, completionHandler: completionHandler)
//            }
//        }
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
        if isComeFrom == "chat" {
            savePdf()
        }
    }
  
    
    @IBAction func onClickPrint(_ sender: Any) {
        if isComeFrom == "chat" {
         
            let url = NSURL.fileURL(withPath: filePath)
           // let url = NSURL.init(fileURLWithPath: pdfNameFromUrl)
            let shareAll = [url as Any] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         
                
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
          
        }else {
            Priner()
        }
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
        printController.printingItem = self.viewWebview.toImage()
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
        
        
       /* let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = (webView.url?.absoluteString)!
        printInfo.duplex = UIPrintInfo.Duplex.none
        printInfo.orientation = UIPrintInfo.Orientation.portrait

        //New stuff
        printController.printPageRenderer = nil
        printController.printingItems = nil
        printController.printingItem = webView.url!
        //New stuff

        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true

        //printController.presentFromBarButtonItem(printButton, animated: true, completionHandler: nil)
        printController.present(animated: true, completionHandler: nil)*/
        
    }
    func savePdf(){
        let theFileName = (strUrl as NSString).lastPathComponent
        DispatchQueue.main.async {
            let url = URL(string: self.strUrl)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(self.doGetValueLanguage(forKey: "app_name"))-\(theFileName)"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            self.filePath = "\(actualPath)"
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
}
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
