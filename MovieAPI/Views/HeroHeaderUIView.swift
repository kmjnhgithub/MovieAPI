//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/28.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal) // 設置按鈕在常態（未被壓下）狀態的標題為 "Download"。
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false // 這個屬性用於 Auto Layout，當設定為 false 時，表示我們將手動添加約束來定位和尺寸按鈕，而不是讓系統自動生成約束。
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal) // 設置按鈕在常態（未被壓下）狀態的標題為 "Play"。
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false // 這個屬性用於 Auto Layout，當設定為 false 時，表示我們將手動添加約束來定位和尺寸按鈕，而不是讓系統自動生成約束。
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // 等比例縮放圖片，但它會讓圖片完全填滿整個 UIImageView，可能導致圖片的某些部分被裁剪掉。
        imageView.clipsToBounds = true // 圖片大小超過 imageView 的邊界將被裁剪，只在 imageView 界限內的圖片才會被顯示。
        imageView.image = UIImage(named: "heroimage")
        return imageView
    }()
    
    private func addGradient() {
        let gradintLayer = CAGradientLayer()
        gradintLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.addSublayer(gradintLayer)
        self.gradientLayer = gradintLayer
    
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            // playButton 的前導邊（左邊，若在右向左的語言環境中則為右邊）與父視圖的前導邊的距離應為25點。這裡的leadingAnchor指的就是playButton所在視圖的前導邊。
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            // playButton 的底部與父視圖底部的距離應為-20點。也就是說，playButton底部會在父視圖的底部向上20點的位置。這裡的bottomAnchor指的是playButton所在視圖的底部邊。
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            // playButton 的寬度 (widthAnchor) 應該等於一個固定的值，equalToConstant: 一種創建固定大小約束的方式，而其他的 constraint(equalTo:)或 constraint(equalTo:constant:) 則可以創建與其他視圖相對應的約束。
            playButton.widthAnchor.constraint(equalToConstant: 120 )
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        // 在設定約束前，translatesAutoresizingMaskIntoConstraints必須被設定為false，否則系統會根據視圖的frame和autoresizingMask屬性生成約束，可能與手動設定的約束衝突。
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    // func layoutSubviews() 會在每次 view 的 frame 變動時被調用。在這裡，heroImageView 的大小隨著 view 的大小變化調整，確保圖片視圖總是填滿整個 view。
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        gradientLayer?.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
