//
//  CircularDetailsVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 06/05/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import WebKit



class CircularDetailsVC: BaseVC , WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var wvData: WKWebView!
    
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbAppBarTitle: UILabel!
    @IBOutlet weak var ivAttache: UIImageView!
    @IBOutlet weak var viewAttache: UIView!
    
    @IBOutlet weak var conHeightWV: NSLayoutConstraint!
    var modelNoticeBoard : ModelNoticeBoard?
    var notices  =  [ModelNoticeBoard]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbAppBarTitle.text = "\(doGetValueLanguage(forKey: "circular"))"
        lbTitle.text = modelNoticeBoard?.notice_title ?? ""
        lbData.text = modelNoticeBoard?.notice_time ?? ""
        wvData.navigationDelegate = self
        wvData.scrollView.isScrollEnabled = false

       /* let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        webView.load(request)*/
        setThreeCorner(viewMain: viewMain)
        
      
        
        
        if modelNoticeBoard?.notice_attachment ?? "" != "" {
            viewAttache.isHidden = false
            let data =  modelNoticeBoard?.notice_attachment ?? ""
            if  data.contains(".pdf") {
                ivAttache.image = UIImage(named: "pdf")
            } else  if  data.contains(".doc") || data.contains(".docx") {
                ivAttache.image = UIImage(named: "doc")
            } else  if  data.contains(".ppt") || data.contains(".pptx") {
                ivAttache.image = UIImage(named: "doc")
            } else  if  data.contains(".jpg") || data.contains(".jpeg") {
                ivAttache.image = UIImage(named: "jpg-2")
            } else  if  data.contains(".png")  {
                ivAttache.image = UIImage(named: "png")
            } else  if  data.contains(".zip")  {
                ivAttache.image = UIImage(named: "zip")
            } else {
                ivAttache.image = UIImage(named: "office-material")
            }
            
        } else {
            viewAttache.isHidden = true
        }
        
        doReadNoticeBoard()
        
    }


    @IBAction func tapBack(_ sender: Any) {
        doPopBAck()
    }
    @IBAction func tapAttch(_ sender: Any) {
     
        let StrAttachments = modelNoticeBoard?.notice_attachment  ?? ""
        
           
        if StrAttachments.lowercased().contains("jpg") ||  StrAttachments.lowercased().contains("jpeg") ||  StrAttachments.lowercased().contains("png") {
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCommonFullScrenImageVC")as! CommonFullScrenImageVC
            nextVC.imagePath = StrAttachments
            nextVC.isShowDownload = "yes"
            pushVC(vc: nextVC)
        } else {
            let vc =  mainStoryboard.instantiateViewController(withIdentifier:  "NoticcWebvw") as! NoticcWebvw
            vc.strUrl = StrAttachments
            vc.strNoticetitle = modelNoticeBoard?.notice_title ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCellHeight), userInfo: nil, repeats: false)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //        let js = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        //webView.evaluateJavaScript(js, completionHandler: nil)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
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
    
    @objc func updateCellHeight() {
        conHeightWV.constant = wvData.scrollView.contentSize.height
    }
    func doReadNoticeBoard() {
        // "read":"0" mean is unread massagee
        let params = ["getNoticeSingle":"getNoticeSingle",
                      "society_id":doGetLocalDataUser().societyID!,
                      "notice_board_id":modelNoticeBoard?.notice_board_id ?? "",
                      "user_id" : doGetLocalDataUser().userID ?? "",
                      "unit_id" : doGetLocalDataUser().unitID ?? "",
                      "block_id" : doGetLocalDataUser().blockID ?? "",
                      "auth_check":"true"]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.noticeBoardController, parameters: params) { (json, error) in
            
            if json != nil {
               // print(json as Any)
                do {
                    let response = try JSONDecoder().decode(ResponseNoticeBaord.self, from:json!)
                   // print(response)
                    if response.status == "200" {
                        self.notices = response.notice
                        
                        print(self.notices)
                       
                        var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                          headerString.append(self.notices[0].notice_description ?? "")
                        self.wvData.loadHTMLString(headerString, baseURL: nil)
                     
                        
                    }else {
                    }
                    //                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}
