//
//  ViewController.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 3.06.2022.
//

import UIKit
import SnapKit
import Foundation

class HomeViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel()
    
    private var gamesSlide = [Result]()
    private var gamesList = [Result]()
    private var allGames = [Result]()
    private var searchList = [Result]()
    
    private let pageControl = UIPageControl()
    private let searchBar = UISearchBar()
    private let searchBarLineView = UIView()
    private let searchIcon = UIImageView()
    private let notFoundLabel = UILabel()
    private let homeView = UIView()
    private let searchView = UIView()
    
    private lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        homeViewModel.delegate = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        homeViewModel.delegate = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        homeViewModel.delegate = self
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: "pageCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getGameData()
        viewSetup()
        customizeViews()
        notFoundLabel.isHidden = true
        searchView.isHidden = true
    }
    
    func viewSetup() {
        view.addSubview(searchView)
        searchView.addSubview(searchCollectionView)
        view.addSubview(homeView)
        homeView.addSubview(listCollectionView)
        homeView.addSubview(pageCollectionView)
        homeView.addSubview(pageControl)
        view.addSubview(searchBar)
        view.addSubview(searchBarLineView)
        view.addSubview(searchIcon)
        view.addSubview(notFoundLabel)
        
        searchCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBarLineView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        homeView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBarLineView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        pageCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        listCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(pageCollectionView.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-115)
            make.left.equalToSuperview().offset(10)
        }
        
        searchBarLineView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalTo(searchBar).offset(15)
            make.height.equalTo(2)
            make.left.equalTo(searchBar.snp.left)
        }
        
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(searchBar.snp.centerY)
            make.right.equalTo(searchBarLineView.snp.right).offset(-5)
        }
        
        notFoundLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func customizeViews() {
        view.backgroundColor = .white
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.searchTextPositionAdjustment = .init(horizontal: -30, vertical: 0)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange])
        searchBar.searchTextField.leftViewMode = .never
        searchIcon.image = UIImage(named: "search")
        searchBarLineView.backgroundColor = .orange
        
        notFoundLabel.text = "Üzgünüz, aradığınız oyun bulunamadı!"
    }
}

extension HomeViewController : HomeViewModelProtocol {
    
    func dataUpdated() {
        pageCollectionView.reloadData()
        listCollectionView.reloadData()
    }
    
    func addData(pageData : [Result], listData: [Result], allData: [Result]) {
        self.gamesSlide = pageData
        self.gamesList = listData
        self.allGames = allData
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchList = Array(allGames.dropFirst(3))
        
        notFoundLabel.isHidden = true
        searchView.isHidden = true
        homeView.isHidden = false
        
        if searchText.count > 2 {
            searchView.isHidden = false
            homeView.isHidden = true
            
            //searchList = allGames
            searchList.removeAll()
            for index in 0...allGames.count - 1 {
                if (allGames[index].name.contains(searchText)) {
                    searchList.append(allGames[index])
                }
            }
            if searchList.isEmpty {
                homeView.isHidden = true
                searchView.isHidden = true
                notFoundLabel.isHidden = false
            }
        }
        searchCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pageCollectionView {
            return gamesSlide.count
        } else if collectionView == listCollectionView {
            return gamesList.count
        } else {
            return searchList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCollectionViewCell", for: indexPath) as! PageCollectionViewCell
            let url = URL(string: gamesSlide[indexPath.row].backgroundImage)
            let data = try! Data(contentsOf: url!)
            cell.backgroundImage.image = UIImage(data: data)
            return cell
        } else if collectionView == listCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            let url = URL(string: gamesList[indexPath.row].backgroundImage)
            let data = try! Data(contentsOf: url!)
            cell.backgroundImage.image = UIImage(data: data)
            cell.gameNameLabel.text = gamesList[indexPath.row].name
            cell.ratingAndReleaseLabel.text = "\(gamesList[indexPath.row].rating) - \( gamesList[indexPath.row].released)"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            let url = URL(string: searchList[indexPath.row].backgroundImage)
            let data = try! Data(contentsOf: url!)
            cell.backgroundImage.image = UIImage(data: data)
            cell.gameNameLabel.text = searchList[indexPath.row].name
            cell.ratingAndReleaseLabel.text = "\(searchList[indexPath.row].rating) - \( searchList[indexPath.row].released)"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if collectionView == pageCollectionView {
            return CGSize(width: width, height: width/2)
        }
        return CGSize(width: width, height: width/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == pageCollectionView {
            pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        var id = Int()
        
        if collectionView == pageCollectionView {
            id = gamesSlide[indexPath.row].id
        } else if collectionView == listCollectionView {
            id = gamesList[indexPath.row].id
        } else {
            id = searchList[indexPath.row].id
        }
        
        vc.gameId = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}

