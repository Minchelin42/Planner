//
//  PlanCollectionViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit
import SnapKit

class PlanCollectionViewCell: UICollectionViewCell {
    
    let backView = UIView()
    let imageBack = UIView()
    let image = UIImageView()
    let title = UILabel()
    let count = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(backView)
        contentView.addSubview(imageBack)
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(count)
    }
    
    func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageBack.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(10)
            make.leading.equalTo(backView.snp.leading).offset(10)
            make.size.equalTo(40)
        }
        
        image.snp.makeConstraints { make in
            make.edges.equalTo(imageBack).inset(7)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.bottom.equalTo(backView.snp.bottom).inset(10)
            make.leading.equalTo(backView.snp.leading).offset(10)
            make.trailing.equalTo(backView.snp.trailing).inset(10)
        }
        
        count.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(10)
            make.trailing.equalTo(backView.snp.trailing)
            make.leading.greaterThanOrEqualTo(image.snp.trailing).offset(30)
            make.size.equalTo(30)
        }
    }
    
    func configureView() {
        backView.backgroundColor = .darkGray
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 15
        
        imageBack.clipsToBounds = true
        imageBack.layer.cornerRadius = 20
    
        title.textColor = .gray
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        
        count.textColor = .white
        count.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    PlanViewController()
}
