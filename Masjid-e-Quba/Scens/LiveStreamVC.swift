//
//  LiveStreamVC.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/28/22.
//

import UIKit
import WebKit

class LiveStreamVC: BaseVC {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.load(NSURLRequest(url: NSURL(string: "http://www.mequba.com/live-streaming/")! as URL) as URLRequest)
    }
    

}
