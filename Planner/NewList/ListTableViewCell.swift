//
//  ListTableViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/20.
//

import UIKit
import SnapKit

final class ListTableViewCell: UITableViewCell {

    let backView = UIView()
    let listImage = UIImageView()
    let title = UILabel()
    let count = UILabel()
    let chevronImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .darkGray
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(backView)
        contentView.addSubview(listImage)
        contentView.addSubview(title)
        contentView.addSubview(count)
        contentView.addSubview(chevronImage)
    }
    
    private func configureLayout() {
        backView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(40)
        }
        
        listImage.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(4)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.trailing).offset(12)
            make.top.bottom.equalTo(contentView).inset(10)
            make.width.equalTo(245)
        }
        
        count.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.trailing).offset(10)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        
        chevronImage.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(15)
        }
        
    }

    private func configureView() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 20
        backView.backgroundColor = .systemOrange
        
        listImage.tintColor = .white
        listImage.image = UIImage(systemName: "suit.heart")
        
        title.textColor = .white
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        
        count.textColor = .gray
        count.font = .systemFont(ofSize: 13, weight: .medium)
        
        chevronImage.image = UIImage(systemName: "chevron.compact.right")
        chevronImage.tintColor = .gray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
