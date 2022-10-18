//
//  BalanceSheetDetailsVC.swift
//  Finca
//
//  Created by anjali on 29/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import WebKit
class BalanceSheetDetailsVC: BaseVC , WKNavigationDelegate {
    @IBOutlet weak var lblBalancesheetName: UILabel!
    @IBOutlet weak var viewWebview: UIView!
    var webView : WKWebView!
    var stringUrl : String!
    var balanceData : BalancesheetModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // print(stringUrl)
       // let url = URL(string: stringUrl)
      //  let myRequest = URLRequest(url: url!)
        lblBalancesheetName.text = balanceData.balancesheet_name
        let urlM = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        webView = WKWebView(frame: viewWebview.bounds)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webView.contentMode = .scaleAspectFit
        
        //self.webView.scrollView.delegate = self
       // webView.load(myRequest)
        
        let url: URL! = URL(string: urlM!)
       // print("tetse", url)
        webView.load(URLRequest(url: url))
        
        self.viewWebview.addSubview(webView)
        self.viewWebview.sendSubviewToBack(webView)
        
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
    
    
    @IBAction func onClickBack(_ sender: Any) {
       doPopBAck()
    }
    

}
