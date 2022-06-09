//
//  ListCollectionViewCell.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 4.06.2022.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    let backgroundImage = UIImageView()
    let gameNameLabel = UILabel()
    let ratingAndReleaseLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        customizeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(ratingAndReleaseLabel)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(contentView.snp.height)
            make.top.bottom.equalToSuperview()
        }
        gameNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage.snp.right).offset(15)
            make.top.equalTo(backgroundImage.snp.top)
        }
        ratingAndReleaseLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage.snp.right).offset(15)
            make.top.equalTo(gameNameLabel.snp.bottom).offset(5)
        }
    }
    
    private func customizeViews() {
        contentView.backgroundColor = .clear
    }
    
}
