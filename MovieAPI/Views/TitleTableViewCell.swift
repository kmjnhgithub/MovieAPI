//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/29.
//

import UIKit
import SDWebImage


// 給UpcomingViewController 跟 SearchViewController共用
class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    // 播放按鈕
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)) // 自定義系統圖片大小，使用大小為30的圖片配置
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // 啟用Auto Layout
        button.tintColor = .white
        return button
    }()
    
    // 電影名稱
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 允許多行顯示
        label.lineBreakMode = .byWordWrapping // 在單詞邊界處自動換行
        label.translatesAutoresizingMaskIntoConstraints = false // 啟用Auto Layout
        return label
    }()
    
    // 影片海報
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // 讓圖片充滿並保持原始比例
        imageView.translatesAutoresizingMaskIntoConstraints = false // 啟用Auto Layout
        imageView.clipsToBounds = true // 讓超過邊界的內容被切掉
        return imageView
    }()
    
    // 初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) // 呼叫父類別的初始化方法
        
        // 將創建好的視圖添加到內容視圖中
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }
    
    // 設定佈局Constraints
    private func applyConstraints() {
        
        // 海報圖片視圖設定約束
        let titlesPosterUIImageViewConstraints = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // 緊貼在 contentView 的左邊
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // 距離 contentView 頂部 10 單位
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10), // 距離 contentView 底部 10 單位
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100) // 寬度固定為 100 單位
        ]
        
        // 影片名稱視圖設定約束
        let titleLabelConstraints = [

            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 20), // 緊貼在 titlesPosterUIImageView 右邊，間隔 20 單位
            titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -10), // 確保titleLabel不會與playTitleButton重疊
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // 垂直置中於 contentView
        ]
        
        // 播放按鈕視圖設定約束
        let playTitleButtonConstraints = [
            playTitleButton.widthAnchor.constraint(equalToConstant: 50),
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // 緊貼在 contentView 右邊，間隔 -20 單位
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // 垂直置中於 contentView
        ]
        
        // 啟用佈局約束
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    // 讓UpcomingViewController / SearchViewController 在繪製此cell時所需的配製方法
    public func configure(with model: TitleViewModel) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlesPosterUIImageView.sd_setImage(with: url, completed: nil) // 使用SDWebImage庫來非同步加載圖片
        titleLabel.text = model.titleName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
