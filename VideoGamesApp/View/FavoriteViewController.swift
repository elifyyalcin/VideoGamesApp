//
//  FavoriteViewController.swift
//  
//
//  Created by Elif Yalçın on 3.06.2022.
//

import UIKit
import SnapKit
import SQLite

class FavoriteViewController: UIViewController {
    
    private let db = DB()
    private var favGameList:[Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.connection()
        favGameList = db.gameList()
        favListCollectionView.reloadData()
    }
    
    func viewSetup() {
        view.backgroundColor = .white
        view.addSubview(favListCollectionView)
        
        favListCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    private lazy var favListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
}

extension FavoriteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favGameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        let url = URL(string: favGameList[indexPath.row].imgUrl)
        let data = try! Data(contentsOf: url!)
        cell.backgroundImage.image = UIImage(data: data)
        cell.gameNameLabel.text = favGameList[indexPath.row].name
        cell.ratingAndReleaseLabel.text = "\(favGameList[indexPath.row].rating) - \( favGameList[indexPath.row].release)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        var id = favGameList[indexPath.row].id
        vc.gameId = Int(id)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
