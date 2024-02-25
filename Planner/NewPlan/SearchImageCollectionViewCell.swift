//
//  SearchImageCollectionViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/25.
//

import UIKit

final class SearchImageCollectionViewCell: UICollectionViewCell {
    
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }

    func configureHierarchy() {
        contentView.addSubview(image)
    }
    
    func configureLayout() {
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
