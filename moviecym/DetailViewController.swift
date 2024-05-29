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
        
        let urlKorString =  "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query="+movieName
        //let urlKorString = "https://www.youtube.com/results?search_query=" + movieName//유튜브
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
