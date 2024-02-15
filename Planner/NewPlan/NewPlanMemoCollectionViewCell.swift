//
//  NewPlanMemoCollectionViewCell.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class NewPlanMemoCollectionViewCell: UICollectionViewCell {
    
    let textInputView = UIView()
    let grayLine = UIView()
    let titleTextField = UITextField()
    let memoTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(textInputView)
        contentView.addSubview(grayLine)
        contentView.addSubview(titleTextField)
        contentView.addSubview(memoTextField)
    }
    
    func configureLayout() {
        textInputView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(150)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(textInputView).inset(14)
            make.top.equalTo(textInputView)
        }
        
        grayLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalTo(textInputView).inset(10)
            make.height.equalTo(1)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(grayLine.snp.bottom)
            make.horizontalEdges.equalTo(textInputView).inset(14)
            make.bottom.greaterThanOrEqualTo(textInputView).offset(-60)
        }
    }
    
    func configureView() {
        textInputView.backgroundColor = .white
        textInputView.clipsToBounds = true
        textInputView.layer.cornerRadius = 10
        
        grayLine.backgroundColor = .gray
        
        titleTextField.placeholder = "제목"
        memoTextField.placeholder = "메모"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
