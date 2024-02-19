//
//  AllPlanTableViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit
import SnapKit

class AllPlanTableViewCell: UITableViewCell {

    let checkButton = UIButton()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let dateLabel = UILabel()
    let tagLabel = UILabel()
    let priorityLabel = UILabel()
    let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(image)
    }
    
    func configureLayout() {
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(15)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(priorityLabel.snp.trailing).offset(4)
            make.height.equalTo(15)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(8)
            make.leading.equalTo(priorityLabel.snp.leading)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(13)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.leading.equalTo(priorityLabel.snp.leading)
            make.width.equalTo(110)
            make.height.equalTo(13)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
            make.height.equalTo(13)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(60)
        }
    }

    func configureView() {
        checkButton.clipsToBounds = true
        checkButton.layer.cornerRadius = 7.5
        checkButton.layer.borderColor = UIColor.gray.cgColor
        checkButton.layer.borderWidth = 1
        
        titleLabel.text = "제목"
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .white
        
        memoLabel.text = "섭타이틀"
        memoLabel.font = .systemFont(ofSize: 13, weight: .medium)
        memoLabel.textColor = .gray
        
        dateLabel.text = "8888년 88월 88일"
        dateLabel.font = .systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = .red
        
        priorityLabel.text = "완전 안중요한데 하고싶음"
        priorityLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        priorityLabel.textColor = .white
        
        tagLabel.text = "쇼핑"
        tagLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tagLabel.textColor = .darkGray
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


#Preview {
    AllPlanViewController()
}
