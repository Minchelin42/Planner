//
//  AllPlanTableViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class AllPlanTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let dateLabel = UILabel()
    let tagLabel = UILabel()
    let priorityLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(priorityLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(contentView).inset(10)
            make.height.equalTo(15)
            make.width.equalTo(200)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(15)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(13)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView).inset(10)
            make.width.equalTo(150)
            make.height.equalTo(13)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(5)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(13)
        }
    }
    
    func configureView() {
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
        priorityLabel.textAlignment = .right
        
        tagLabel.text = "쇼핑"
        tagLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tagLabel.textColor = .darkGray
        tagLabel.textAlignment = .right
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


#Preview {
    AllPlanViewController()
}
