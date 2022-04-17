//
//  NewsVC.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/28/22.
//

import UIKit
import WebKit

class NewsVC: BaseVC {
    
    @IBOutlet weak var webView: WKWebView!
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !url.isEmpty {
            let myURL = URL(string: url)
            var myRequest = URLRequest(url: myURL!)
            myRequest.httpShouldHandleCookies = false
            webView.load(myRequest)
           // webView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
        }
    }
    
    
    
    
    
}
