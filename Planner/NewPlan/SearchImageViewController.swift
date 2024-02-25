//
//  SearchImageViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/25.
//

import UIKit
import Kingfisher

class SearchImageViewController: BaseViewController {
    
    let searchBar = UISearchBar()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    var searchResult = NaverModel(total: 0, display: 0, items: [])
    var start = 1
    
    var delegate: PassDataDelegate?
    var priority: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.priorityReceived(priority: priority)
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchImageCollectionViewCell.self, forCellWithReuseIdentifier: "Search")
        collectionView.backgroundColor = .black
        
        searchBar.delegate = self
    }
    
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 2)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical

        return layout
        
    }
}

extension SearchImageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)

        NaverAPIManager.shared.ImageAPI(search: searchBar.text!, start: self.start) { result, error in
            if let result = result {
                self.searchResult = result
            }
            self.collectionView.reloadData()
        }
    }
}

extension SearchImageViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        if !self.searchResult.items.isEmpty {
            for indexPath in indexPaths {
                if self.searchResult.items.count - 5 == indexPath.row && start + self.searchResult.display < self.searchResult.total {
                    self.start += 30
                    NaverAPIManager.shared.ImageAPI(search: self.searchBar.text!, start: self.start) {
                        image, error in
                        if let image = image {
                            if self.searchResult.items.count == 0 {
                                self.searchResult = image
                            } else {
                                self.searchResult.items.append(contentsOf: image.items)
                            }
                            
                            self.collectionView.reloadData()
                            
                            if self.start == 1 && !self.searchResult.items.isEmpty{
                                self.collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: false)
                            }
                        } else {
                            print("통신 실패")
                        }
                    }
                    
                }
            }
        }
    }
}

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Search", for: indexPath) as! SearchImageCollectionViewCell
        let url = URL(string: self.searchResult.items[indexPath.row].link)
        cell.image.kf.setImage(with: url, placeholder: UIImage(systemName: "suit.heart"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.priority = self.searchResult.items[indexPath.row].link
        navigationController?.popViewController(animated: true)
    }
    
}
