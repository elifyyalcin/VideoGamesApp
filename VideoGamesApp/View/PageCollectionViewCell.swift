//
//  PageCollectionViewCell.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 4.06.2022.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    var backgroundImage = UIImageView()
    
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
        
        backgroundImage.snp.makeConstraints { (make) in
            make.bottom.top.width.height.equalToSuperview()
        }
    }
    
    private func customizeViews() {
        backgroundImage.backgroundColor = .clear
        backgroundImage.contentMode = .scaleAspectFill
    }
}
