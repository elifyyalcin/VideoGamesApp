//
//  DetailViewController.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 7.06.2022.
//

import UIKit
import SQLite

class DetailViewController: UIViewController {
    var gameId = Int()
    private let db = DB()
    private var dbGameArray : [Game] = []
    private let detailViewModel = DetailViewModel()
    private var gameImageUrl = String()
    private var gameName = String()
    private var gameRating = Double()
    private var gameReleased = String()
    
    private let gameImage = UIImageView()
    private let nameLabel = UILabel()
    private let releaseLabel = UILabel()
    private let metacriticRateLabel = UILabel()
    private let gameDescriptionTextView = UITextView()
    
    private let favButton = UIButton()
    private let backButton = UIButton()
    private let backButtonView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.connection()
        dbGameArray.append(contentsOf: db.gameList())
        detailViewModel.gameId = gameId
        detailViewModel.getDetailData()
        viewSetup()
        customizeViews()
        detailViewModel.delegate = self
    }
    
    func viewSetup() {
        view.insertSubview(gameImage, at: 0)
        view.addSubview(nameLabel)
        view.addSubview(releaseLabel)
        view.addSubview(metacriticRateLabel)
        view.addSubview(gameDescriptionTextView)
        view.addSubview(favButton)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(25)
        }
        gameImage.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(gameImage.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        releaseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
        }
        metacriticRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(releaseLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
        }
        gameDescriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(metacriticRateLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        favButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(gameImage.snp.bottom).offset(-10)
            make.width.height.equalTo(40)
        }
        
    }
    
    func customizeViews() {
        view.backgroundColor = .white
        
        gameDescriptionTextView.backgroundColor = .clear
        gameDescriptionTextView.isUserInteractionEnabled = false
        gameDescriptionTextView.showsVerticalScrollIndicator = false
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        backButton.setBackgroundImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        favButton.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        
        if !dbGameArray.isEmpty {
            var idArray = [Int]()
            for index in 0...dbGameArray.count - 1 {
                idArray.append(dbGameArray[index].id)
            }

            if idArray.contains(gameId) {
                favButton.setBackgroundImage(UIImage(named: "liked"), for: .normal)
            } else {
                favButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
            }
        } else {
            favButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
        }
    }
    
    @objc func favButtonAction() {
        let isExist = db.insertGame(id: gameId,imgUrl: gameImageUrl, name: gameName, rating: gameRating, release: gameReleased)
        if isExist == -1 {
            db.deleteGame(gameId: gameId)
            favButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
        } else {
            favButton.setBackgroundImage(UIImage(named: "liked"), for: .normal)
        }
    }
    
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController : DetailViewModelProtocol {
    
    func setData(gameImageUrl: String, gameName: String, releaseDate: String, metacriticRate: Int, gameDescription: String) {
        
        let url = URL(string: gameImageUrl)
        let data = try! Data(contentsOf: url!)
        gameImage.image = UIImage(data: data)
        nameLabel.text = gameName
        releaseLabel.text = releaseDate
        metacriticRateLabel.text = String(metacriticRate)
        gameDescriptionTextView.text = gameDescription
    }
    
    func setData(id: Int, gameImageUrl: String, gameName: String, releaseDate: String, rating: Double) {
        self.gameImageUrl = gameImageUrl
        self.gameName = gameName
        gameRating = rating
        gameReleased = releaseDate
        gameId = id
    }
}
