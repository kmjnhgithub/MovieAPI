//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/26.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // 將視圖背景設為系統預設背景色
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true // (Navigation Bar) 顯示大型標題。
        navigationController?.navigationItem.largeTitleDisplayMode = .always // 設定(navigationItem) 的大標題顯示模式，無論什麼情況下都將顯示大型標題
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds // 最終把 upcomingTable 加入view裏面並符合view的邊界
    }
    
    // 取得即將上映的api
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovie { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // cellForRowAt 主要繪製cell裡面的畫面配置
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknow", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // didSelectRowAt 處理cell被點選的事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 以動畫的方式取消選中指定的cell。
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self]result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
