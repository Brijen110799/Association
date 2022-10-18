//
//  NoticeBoardCell.swift
//  Finca
//
//  Created by anjali on 29/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import WebKit
import WebKit
class NoticeBoardCell: UITableViewCell , WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler  {
    
    @IBOutlet weak var viewMain_Attachment: UIView!
    @IBOutlet weak var imgvw_Attachment_icon:UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbNoticeTile: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnAttachment : UIButton!
   
    @IBOutlet weak var viewWebview: UIView!
    @IBOutlet weak var viewSubView: UIView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var bViewMore: UIButton!
    @IBOutlet weak var bTapDesc: UIButton!
    
   // var webView : WKWebView!
    var webView = WKWebView()
    
   var tableView: UITableView!
    var heightWebvw: CGFloat = 1200.0
    
    
    @IBOutlet weak var heightConWV: NSLayoutConstraint!
    var noticeVC : NoticeVC!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.webView.scrollView.delegate = self
        self.viewMain.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
     
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
           if(message.name == "callbackHandler") {
               print("JavaScript is sending a message \(message.body)")
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(htmlContent : String , index : Int) {
        webView.tag = index
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false

       /* let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        webView.load(request)*/
        
        
        var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
headerString.append(htmlContent)
        webView.loadHTMLString(headerString, baseURL: nil)
        
        
    }
    
    
    @objc func updateCellHeight() {
        heightWebvw = webView.scrollView.contentSize.height
        
        noticeVC.upadateHeightCon(he:heightWebvw, index: webView.tag)
        
        //heightConstraint.isActive = false
       // heightConWV = webView.heightAnchor.constraint(equalToConstant: height)
      //  heightConWV.constant  = height
       // heightConWV.isActive = true
        
   //     tableView.reloadData()
        
    }
    
    
   //MARK: - WKWebView
   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCellHeight), userInfo: nil, repeats: false)
   }

   func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
       //        let js = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
       //webView.evaluateJavaScript(js, completionHandler: nil)
   }
   
 

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebView.NavigationType) -> Bool {

        print(navigationType)
        if request.url?.query?.range(of: "target=external") != nil {
            if let url = request.url {
              
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                return false
            }
        }
        return true
    }
    
     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         if navigationAction.navigationType == .linkActivated  {
             if let url = navigationAction.request.url,
                let _ = url.host,UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url)
                 print(url)
                 print("Redirected to browser. No need to open it locally")
                 decisionHandler(.cancel)
             } else {
                 print("Open it locally")
                 guard
                    let url = navigationAction.request.url,
                    let scheme = url.scheme else {
                        decisionHandler(.cancel)
                        return
                    }

                 if (scheme.lowercased() == "mailto" || scheme.lowercased() == "tel") {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                     // here I decide to .cancel, do as you wish
                     decisionHandler(.cancel)
                     return
                 }
                 decisionHandler(.allow)
             }
         } else {
             print("not a user click")
             decisionHandler(.allow)
         }
     }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
