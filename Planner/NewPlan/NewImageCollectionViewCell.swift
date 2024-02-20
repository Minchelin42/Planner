//
//  NewImageCollectionViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/20.
//

import UIKit

final class NewImageCollectionViewCell: UICollectionViewCell {

    let backView = UIView()
    let title = UILabel()
    var selectImage = UIImageView()
    let image = UIImageView()
    
    let subTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(backView)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        contentView.addSubview(selectImage)
        contentView.addSubview(image)
    }
    
    private func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).inset(15)
            make.width.equalTo(150)
            make.top.bottom.equalTo(backView).inset(10)
        }
        
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(title.snp.trailing).offset(15)
            make.width.equalTo(150)
            make.top.bottom.equalTo(backView).inset(10)
        }
        
        selectImage.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(40)
            make.size.equalTo(30)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(15)
            make.size.equalTo(15)
        }
    }
    
    private func configureView() {
        backView.backgroundColor = .darkGray
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 13
        
        title.textColor = .white
        title.text = "마감일"
        title.font = .systemFont(ofSize: 15, weight: .semibold)
        title.textAlignment = .left
        
        subTitle.textColor = .lightGray
        subTitle.text = "마감일마감일마감일마감일마감일마감일마감일"
        subTitle.font = .systemFont(ofSize: 12, weight: .semibold)
        subTitle.textAlignment = .right
        subTitle.numberOfLines = 0
        
        selectImage.backgroundColor = .clear
        
        image.image = UIImage(systemName: "chevron.compact.right")
        image.tintColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    PlanNewViewController()
}

