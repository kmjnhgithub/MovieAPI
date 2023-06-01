//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by mike liu on 2023/6/1.
//

import UIKit
import WebKit

// HomePage detail
class TitlePreviewViewController: UIViewController {
    
    
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "spider man"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "this test article try to testing....."
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true // 不設置 = true，即使設置了圓角，背景色仍可能會填充整個按鈕的邊界，按鈕看起來並未實現圓角效果
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // webView 的頂部與父視圖的安全區域頂部對齊
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor), // webView 的左側與父視圖的左側對齊
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor), // webView 的右側與父視圖的右側對齊
            webView.heightAnchor.constraint(equalToConstant: 200) // 設定 webView 的高度
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20), // titleLabel 的頂部在 webView 的底部下方 20 點的位置
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20) // titleLabel 的左側與父視圖的左側間隔 20 點
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15), // overviewLabel 的頂部在 titleLabel 的底部下方 15 點的位置
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // overviewLabel 的左側與父視圖的左側間隔 20 點
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor) // overviewLabel 的右側與父視圖的右側對齊
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // downloadButton 的中心點與父視圖的中心點對齊
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25), // downloadButton 的頂部在 overviewLabel 的底部下方 25 點的位置
            downloadButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4), // downloadButton 的寬度為父視圖寬度的 0.4 倍
            downloadButton.heightAnchor.constraint(equalToConstant: 40) // 設定 downloadButton 的高度為 40
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    // 配置電影細節的畫面
    func configure(with model: TitlePreviewViewModel) {
        
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(model.youtubeView.id.videoId)") else {return}
        
        webView.load(URLRequest(url: url))
    }

}
