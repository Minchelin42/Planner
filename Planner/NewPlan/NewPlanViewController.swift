//
//  NewPlanViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class inputButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        contentHorizontalAlignment = .leading
//        semanticContentAttribute = .forceRightToLeft
//        setImage(UIImage(systemName: "chevron.right"), for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

class NewPlanViewController: BaseViewController {
    
    let textInputView = UIView()
    let grayLine = UIView()
    let titleTextField = UITextField()
    let memoTextField = UITextField()
    let deadLine = inputButton()
    let tag = inputButton()
    let grade = inputButton()
    let plusImage = inputButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(deadLineReceivedNotification), name: NSNotification.Name("DeadLineReceived"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(priorityReceivedNotification), name: NSNotification.Name("PriorityReceived"), object: nil)

    }
    
    
    @objc func deadLineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["deadLine"] as? String {
            deadLine.setTitle("마감일 \(value)", for: .normal)
        }
    }
    
    
    @objc func priorityReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["priority"] as? String {
            grade.setTitle("우선순위 \(value)", for: .normal)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(textInputView)
        view.addSubview(grayLine)
        view.addSubview(titleTextField)
        view.addSubview(memoTextField)
        view.addSubview(deadLine)
        view.addSubview(tag)
        view.addSubview(grade)
        view.addSubview(plusImage)
    }
    
    override func configureLayout() {
        textInputView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        
        deadLine.snp.makeConstraints { make in
            make.top.equalTo(textInputView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        tag.snp.makeConstraints { make in
            make.top.equalTo(deadLine.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        grade.snp.makeConstraints { make in
            make.top.equalTo(tag.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        plusImage.snp.makeConstraints { make in
            make.top.equalTo(grade.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        
        navigationItem.title = "새로운 할 일"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        textInputView.backgroundColor = .white
        textInputView.clipsToBounds = true
        textInputView.layer.cornerRadius = 10
        
        grayLine.backgroundColor = .gray
        
        titleTextField.placeholder = "제목"
        memoTextField.placeholder = "메모"
   
        
        deadLine.setTitle("마감일", for: .normal)
        deadLine.addTarget(self, action: #selector(deadLineButtonClicked), for: .touchUpInside)
        tag.setTitle("태그", for: .normal)
        tag.addTarget(self, action: #selector(tagButtonClicked), for: .touchUpInside)
        grade.setTitle("우선 순위", for: .normal)
        grade.addTarget(self, action: #selector(gradeButtonClicked), for: .touchUpInside)
        plusImage.setTitle("이미지 추가", for: .normal)
        plusImage.addTarget(self, action: #selector(plusImageButtonClicked), for: .touchUpInside)
    }
    
    @objc func deadLineButtonClicked() {
        let vc = DateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tagButtonClicked() {
        let vc = TagViewController()
        vc.setTag = { value in
            self.tag.setTitle("태그 \(value)", for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func gradeButtonClicked() {
        let vc = PriorityViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func plusImageButtonClicked() {

    }

}

#Preview {
    NewPlanViewController()
}
