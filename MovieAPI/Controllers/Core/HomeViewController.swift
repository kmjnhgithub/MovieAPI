//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/26.
//

import UIKit



enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    // 在HomeViewController類別內定義了兩個私有變數：randomTrendingMovie（隨機熱門電影）和headerView（頭部視圖）。
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    // 各區塊的標題
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    
    
    // 定義一個私有的UITableView實例homeFeedTable，該表格視圖用於顯示首頁的主要內容。其中創建了一個表格，並註冊了CollectionViewTableViewCell。
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.idenifier)
        return table
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 在視圖加載完成後，設定背景色為系統背景色，並將homeFeedTable添加到視圖上。
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        
        // 將HomeViewController設定為表格的委派和資料來源。
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        // 調用configureNavbar方法來配置導覽列。
        configureNavbar()
        
        // 創建一個HeroHeaderUIView的實例作為表格的頭部視圖。
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        // 調用configureHeroHeaderView方法來配置頭部視圖。
        configureHeroHeaderView()
    }
    
    // 在configureHeroHeaderView方法中，呼叫API來獲取電影列表，並隨機選擇一部電影作為頭部視圖的內容。
    private func configureHeroHeaderView() {
        APICaller.shared.getDiscoverMovies { [weak self]result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavbar() {
        
        // 創建一個圖像，並設定該圖像為導覽項目的左邊按鈕。
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal) // 強制iOS系統使用原始的圖片，不然顏色會不正確
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        // 設定了兩個按鈕，分別顯示一個人物圖像和一個播放圖標。
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .systemGray
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.idenifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovie { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .systemGray
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // 設定navigationBar的行為模式（當螢幕往上滑的時候navigationBar跟著向上被推擠移動）
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffet = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffet
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }

}


//為HomeViewController擴展一個CollectionViewTableViewCellDelegate協議，當CollectionViewTableViewCell的單元格被選中時，會跳轉到TitleInfoViewController視圖控制器。
extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
