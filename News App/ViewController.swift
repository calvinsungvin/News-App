//
//  ViewController.swift
//  News App
//
//  Created by Calvin Sung on 2021/7/16.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    var viewModels = [viewModel]()
    var articles = [Article]()
    
    let searchVC = UISearchController(searchResultsController: nil)
    
    let table: UITableView = {
       let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        getNews()
        createSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func getNews(){
        APICallers.shared.getNewsUrl { [weak self] (result) in
            switch result {
            case .success(let articles):
                self?.articles = articles
                print(articles)
                self?.viewModels = articles.compactMap({viewModel(title: $0.title, subtitle: $0.description ?? "No Description", newsImage: URL(string: $0.urlToImage ?? "https://ichef.bbci.co.uk/news/1024/branded_news/EE6F/production/_117793016_gettyimages-1159840867.jpg"))})
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
    }
    
    
    func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: articles[indexPath.row].url) else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        
        APICallers.shared.search(query: text){ [weak self] (result) in
            switch result {
            case .success(let articles):
                self?.articles = articles
                print(articles)
                self?.viewModels = articles.compactMap({viewModel(title: $0.title, subtitle: $0.description ?? "No Description", newsImage: URL(string: $0.urlToImage ?? "https://ichef.bbci.co.uk/news/1024/branded_news/EE6F/production/_117793016_gettyimages-1159840867.jpg"))})
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.table.reloadData()
                self?.searchVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.isEmpty {
            getNews()
        }
    }
}
