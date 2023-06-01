//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/26.
//

import UIKit

// search page
class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = " Search Movie or TV"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true // (Navigation Bar) 顯示大型標題。
        navigationController?.navigationItem.largeTitleDisplayMode = .always // 設定(navigationItem) 的大標題顯示模式，無論什麼情況下都將顯示大型標題

        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController // 將自定義的 searchController 加入到導航欄，用戶點擊搜索欄時顯示自定義的搜索介面。
        navigationItem.hidesSearchBarWhenScrolling = false // SearchBar always on top
        
        navigationController?.navigationBar.tintColor = .systemGray2
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self // 為 UISearchController 設定一個更新搜尋結果的代理對象。
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                                    self?.discoverTable.reloadData()
                                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknow", posterURL: title.poster_path ?? "")
        
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
     // didSelectRowAt 處理cell被點選的事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 以動畫的方式取消選中指定的cell。
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview:  title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
 
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
            
        }
        
    }



// 當搜尋框文字更新時，會呼叫 updateSearchResults(for:) 方法來更新搜尋結果。
extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    // 當搜索條件變化時，更新搜索結果
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, // 確認用戶輸入的是否為nil
              !query.trimmingCharacters(in: .whitespaces).isEmpty, // trimmingCharacters(in: .whitespaces)是將文字兩端的空白字符去掉，然後isEmpty檢查處理後的文字是否為空。如果為空則條件不滿足直接返回。
              query.trimmingCharacters(in: .whitespaces).count >= 3, // 用戶輸入的文字（去掉兩端的空白字符後）至少有三個字符。如果字符數少於三個，則條件不滿足，直接返回。
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                // 嘗試將 searchController.searchResultsController 轉型為 SearchResultsViewController，並確認這個轉型成功。如果轉型不成功，則條件不滿足，直接返回。
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
