//
//  DetailViewController.swift
//  movieWoo
//
//  Created by 조영민 on 5/22/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName
//    let urlString = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=%EC%98%81%ED%99%94%EC%88%9C%EC%9C%84"
        let urlKorString =  "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query="+movieName
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
